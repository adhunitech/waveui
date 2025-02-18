// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart' show IterableProperty, clampDouble;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/colors.dart';
import 'package:waveui/material/constants.dart';
import 'package:waveui/material/theme.dart';

enum CollapseMode { parallax, pin, none }

enum StretchMode { zoomBackground, blurBackground, fadeTitle }

class FlexibleSpaceBar extends StatefulWidget {
  const FlexibleSpaceBar({
    super.key,
    this.title,
    this.background,
    this.centerTitle,
    this.titlePadding,
    this.collapseMode = CollapseMode.parallax,
    this.stretchModes = const <StretchMode>[StretchMode.zoomBackground],
    this.expandedTitleScale = 1.5,
  }) : assert(expandedTitleScale >= 1);

  final Widget? title;

  final Widget? background;

  final bool? centerTitle;

  final CollapseMode collapseMode;

  final List<StretchMode> stretchModes;

  final EdgeInsetsGeometry? titlePadding;

  final double expandedTitleScale;

  static Widget createSettings({
    required double currentExtent,
    required Widget child,
    double? toolbarOpacity,
    double? minExtent,
    double? maxExtent,
    bool? isScrolledUnder,
    bool? hasLeading,
  }) => FlexibleSpaceBarSettings(
    toolbarOpacity: toolbarOpacity ?? 1.0,
    minExtent: minExtent ?? currentExtent,
    maxExtent: maxExtent ?? currentExtent,
    isScrolledUnder: isScrolledUnder,
    hasLeading: hasLeading,
    currentExtent: currentExtent,
    child: child,
  );

  @override
  State<FlexibleSpaceBar> createState() => _FlexibleSpaceBarState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool?>('centerTitle', centerTitle));
    properties.add(EnumProperty<CollapseMode>('collapseMode', collapseMode));
    properties.add(IterableProperty<StretchMode>('stretchModes', stretchModes));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('titlePadding', titlePadding));
    properties.add(DoubleProperty('expandedTitleScale', expandedTitleScale));
  }
}

class _FlexibleSpaceBarState extends State<FlexibleSpaceBar> {
  bool _getEffectiveCenterTitle(ThemeData theme) =>
      widget.centerTitle ??
      switch (theme.platform) {
        TargetPlatform.android || TargetPlatform.fuchsia || TargetPlatform.linux || TargetPlatform.windows => false,
        TargetPlatform.iOS || TargetPlatform.macOS => true,
      };

  Alignment _getTitleAlignment(bool effectiveCenterTitle) {
    if (effectiveCenterTitle) {
      return Alignment.bottomCenter;
    }
    return switch (Directionality.of(context)) {
      TextDirection.rtl => Alignment.bottomRight,
      TextDirection.ltr => Alignment.bottomLeft,
    };
  }

  double _getCollapsePadding(double t, FlexibleSpaceBarSettings settings) {
    switch (widget.collapseMode) {
      case CollapseMode.pin:
        return -(settings.maxExtent - settings.currentExtent);
      case CollapseMode.none:
        return 0.0;
      case CollapseMode.parallax:
        final double deltaExtent = settings.maxExtent - settings.minExtent;
        return -Tween<double>(begin: 0.0, end: deltaExtent / 4.0).transform(t);
    }
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final FlexibleSpaceBarSettings settings = context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>()!;

      final List<Widget> children = <Widget>[];

      final double deltaExtent = settings.maxExtent - settings.minExtent;

      // 0.0 -> Expanded
      // 1.0 -> Collapsed to toolbar
      final double t = clampDouble(1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent, 0.0, 1.0);

      // background
      if (widget.background != null) {
        final double fadeStart = math.max(0.0, 1.0 - kToolbarHeight / deltaExtent);
        const double fadeEnd = 1.0;
        assert(fadeStart <= fadeEnd);
        // If the min and max extent are the same, the app bar cannot collapse
        // and the content should be visible, so opacity = 1.
        final double opacity =
            settings.maxExtent == settings.minExtent ? 1.0 : 1.0 - Interval(fadeStart, fadeEnd).transform(t);
        double height = settings.maxExtent;

        // StretchMode.zoomBackground
        if (widget.stretchModes.contains(StretchMode.zoomBackground) && constraints.maxHeight > height) {
          height = constraints.maxHeight;
        }
        final double topPadding = _getCollapsePadding(t, settings);
        children.add(
          Positioned(
            top: topPadding,
            left: 0.0,
            right: 0.0,
            height: height,
            child: _FlexibleSpaceHeaderOpacity(
              // IOS is relying on this semantics node to correctly traverse
              // through the app bar when it is collapsed.
              alwaysIncludeSemantics: true,
              opacity: opacity,
              child: widget.background,
            ),
          ),
        );

        // StretchMode.blurBackground
        if (widget.stretchModes.contains(StretchMode.blurBackground) && constraints.maxHeight > settings.maxExtent) {
          final double blurAmount = (constraints.maxHeight - settings.maxExtent) / 10;
          children.add(
            Positioned.fill(
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
                child: const ColoredBox(color: Colors.transparent),
              ),
            ),
          );
        }
      }

      // title
      if (widget.title != null) {
        final ThemeData theme = Theme.of(context);

        Widget? title;
        switch (theme.platform) {
          case TargetPlatform.iOS:
          case TargetPlatform.macOS:
            title = widget.title;
          case TargetPlatform.android:
          case TargetPlatform.fuchsia:
          case TargetPlatform.linux:
          case TargetPlatform.windows:
            title = Semantics(namesRoute: true, child: widget.title);
        }

        // StretchMode.fadeTitle
        if (widget.stretchModes.contains(StretchMode.fadeTitle) && constraints.maxHeight > settings.maxExtent) {
          final double stretchOpacity = 1 - clampDouble((constraints.maxHeight - settings.maxExtent) / 100, 0.0, 1.0);
          title = Opacity(opacity: stretchOpacity, child: title);
        }

        final double opacity = settings.toolbarOpacity;
        if (opacity > 0.0) {
          TextStyle titleStyle = theme.textTheme.titleLarge!;
          titleStyle = titleStyle.copyWith(color: titleStyle.color!.withOpacity(opacity));
          final bool effectiveCenterTitle = _getEffectiveCenterTitle(theme);
          final double leadingPadding = (settings.hasLeading ?? true) ? 72.0 : 0.0;
          final EdgeInsetsGeometry padding =
              widget.titlePadding ??
              EdgeInsetsDirectional.only(start: effectiveCenterTitle ? 0.0 : leadingPadding, bottom: 16.0);
          final double scaleValue = Tween<double>(begin: widget.expandedTitleScale, end: 1.0).transform(t);
          final Matrix4 scaleTransform = Matrix4.identity()..scale(scaleValue, scaleValue, 1.0);
          final Alignment titleAlignment = _getTitleAlignment(effectiveCenterTitle);
          children.add(
            Padding(
              padding: padding,
              child: Transform(
                alignment: titleAlignment,
                transform: scaleTransform,
                child: Align(
                  alignment: titleAlignment,
                  child: DefaultTextStyle(
                    style: titleStyle,
                    child: LayoutBuilder(
                      builder:
                          (context, constraints) => SizedBox(
                            width: constraints.maxWidth / scaleValue,
                            child: Align(alignment: titleAlignment, child: title),
                          ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      }

      return ClipRect(child: Stack(children: children));
    },
  );
}

class FlexibleSpaceBarSettings extends InheritedWidget {
  const FlexibleSpaceBarSettings({
    required this.toolbarOpacity,
    required this.minExtent,
    required this.maxExtent,
    required this.currentExtent,
    required super.child,
    super.key,
    this.isScrolledUnder,
    this.hasLeading,
  }) : assert(minExtent >= 0),
       assert(maxExtent >= 0),
       assert(currentExtent >= 0),
       assert(toolbarOpacity >= 0.0),
       assert(minExtent <= maxExtent),
       assert(minExtent <= currentExtent),
       assert(currentExtent <= maxExtent);

  final double toolbarOpacity;

  final double minExtent;

  final double maxExtent;

  final double currentExtent;

  final bool? isScrolledUnder;

  final bool? hasLeading;

  @override
  bool updateShouldNotify(FlexibleSpaceBarSettings oldWidget) =>
      toolbarOpacity != oldWidget.toolbarOpacity ||
      minExtent != oldWidget.minExtent ||
      maxExtent != oldWidget.maxExtent ||
      currentExtent != oldWidget.currentExtent ||
      isScrolledUnder != oldWidget.isScrolledUnder ||
      hasLeading != oldWidget.hasLeading;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('toolbarOpacity', toolbarOpacity));
    properties.add(DoubleProperty('minExtent', minExtent));
    properties.add(DoubleProperty('maxExtent', maxExtent));
    properties.add(DoubleProperty('currentExtent', currentExtent));
    properties.add(DiagnosticsProperty<bool?>('isScrolledUnder', isScrolledUnder));
    properties.add(DiagnosticsProperty<bool?>('hasLeading', hasLeading));
  }
}

// We need the child widget to repaint, however both the opacity
// and potentially `widget.background` can be constant which won't
// lead to repainting.
// see: https://github.com/flutter/flutter/issues/127836
class _FlexibleSpaceHeaderOpacity extends SingleChildRenderObjectWidget {
  const _FlexibleSpaceHeaderOpacity({
    required this.opacity,
    required super.child,
    required this.alwaysIncludeSemantics,
  });

  final double opacity;
  final bool alwaysIncludeSemantics;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderFlexibleSpaceHeaderOpacity(opacity: opacity, alwaysIncludeSemantics: alwaysIncludeSemantics);

  @override
  void updateRenderObject(BuildContext context, covariant _RenderFlexibleSpaceHeaderOpacity renderObject) {
    renderObject
      ..alwaysIncludeSemantics = alwaysIncludeSemantics
      ..opacity = opacity;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('opacity', opacity));
    properties.add(DiagnosticsProperty<bool>('alwaysIncludeSemantics', alwaysIncludeSemantics));
  }
}

class _RenderFlexibleSpaceHeaderOpacity extends RenderOpacity {
  _RenderFlexibleSpaceHeaderOpacity({super.opacity, super.alwaysIncludeSemantics});

  @override
  bool get isRepaintBoundary => false;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) {
      return;
    }
    if ((opacity * 255).roundToDouble() <= 0) {
      layer = null;
      return;
    }
    assert(needsCompositing);
    layer = context.pushOpacity(offset, (opacity * 255).round(), super.paint, oldLayer: layer as OpacityLayer?);
    assert(() {
      layer!.debugCreator = debugCreator;
      return true;
    }());
  }
}
