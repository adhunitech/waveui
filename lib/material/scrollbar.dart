// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

import 'package:waveui/material/color_scheme.dart';
import 'package:waveui/material/scrollbar_theme.dart';
import 'package:waveui/material/theme.dart';

const double _kScrollbarThickness = 8.0;
const double _kScrollbarThicknessWithTrack = 12.0;
const double _kScrollbarMargin = 2.0;
const double _kScrollbarMinLength = 48.0;
const Radius _kScrollbarRadius = Radius.circular(8.0);
const Duration _kScrollbarFadeDuration = Duration(milliseconds: 300);
const Duration _kScrollbarTimeToFade = Duration(milliseconds: 600);

class Scrollbar extends StatelessWidget {
  const Scrollbar({
    required this.child,
    super.key,
    this.controller,
    this.thumbVisibility,
    this.trackVisibility,
    this.thickness,
    this.radius,
    this.notificationPredicate,
    this.interactive,
    this.scrollbarOrientation,
  });

  final Widget child;

  final ScrollController? controller;

  final bool? thumbVisibility;

  final bool? trackVisibility;

  final double? thickness;

  final Radius? radius;

  final bool? interactive;

  final ScrollNotificationPredicate? notificationPredicate;

  final ScrollbarOrientation? scrollbarOrientation;

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return CupertinoScrollbar(
        thumbVisibility: thumbVisibility ?? false,
        thickness: thickness ?? CupertinoScrollbar.defaultThickness,
        thicknessWhileDragging: thickness ?? CupertinoScrollbar.defaultThicknessWhileDragging,
        radius: radius ?? CupertinoScrollbar.defaultRadius,
        radiusWhileDragging: radius ?? CupertinoScrollbar.defaultRadiusWhileDragging,
        controller: controller,
        notificationPredicate: notificationPredicate,
        scrollbarOrientation: scrollbarOrientation,
        child: child,
      );
    }
    return _MaterialScrollbar(
      controller: controller,
      thumbVisibility: thumbVisibility,
      trackVisibility: trackVisibility,
      thickness: thickness,
      radius: radius,
      notificationPredicate: notificationPredicate,
      interactive: interactive,
      scrollbarOrientation: scrollbarOrientation,
      child: child,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ScrollController?>('controller', controller));
    properties.add(DiagnosticsProperty<bool?>('thumbVisibility', thumbVisibility));
    properties.add(DiagnosticsProperty<bool?>('trackVisibility', trackVisibility));
    properties.add(DoubleProperty('thickness', thickness));
    properties.add(DiagnosticsProperty<Radius?>('radius', radius));
    properties.add(DiagnosticsProperty<bool?>('interactive', interactive));
    properties.add(
      ObjectFlagProperty<ScrollNotificationPredicate?>.has('notificationPredicate', notificationPredicate),
    );
    properties.add(EnumProperty<ScrollbarOrientation?>('scrollbarOrientation', scrollbarOrientation));
  }
}

class _MaterialScrollbar extends RawScrollbar {
  const _MaterialScrollbar({
    required super.child,
    super.controller,
    super.thumbVisibility,
    super.trackVisibility,
    super.thickness,
    super.radius,
    ScrollNotificationPredicate? notificationPredicate,
    super.interactive,
    super.scrollbarOrientation,
  }) : super(
         fadeDuration: _kScrollbarFadeDuration,
         timeToFade: _kScrollbarTimeToFade,
         pressDuration: Duration.zero,
         notificationPredicate: notificationPredicate ?? defaultScrollNotificationPredicate,
       );

  @override
  _MaterialScrollbarState createState() => _MaterialScrollbarState();
}

class _MaterialScrollbarState extends RawScrollbarState<_MaterialScrollbar> {
  late AnimationController _hoverAnimationController;
  bool _dragIsActive = false;
  bool _hoverIsActive = false;
  late ColorScheme _colorScheme;
  late ScrollbarThemeData _scrollbarTheme;
  // On Android, scrollbars should match native appearance.
  late bool _useAndroidScrollbar;

  @override
  bool get showScrollbar => widget.thumbVisibility ?? _scrollbarTheme.thumbVisibility?.resolve(_states) ?? false;

  @override
  bool get enableGestures => widget.interactive ?? _scrollbarTheme.interactive ?? !_useAndroidScrollbar;

  WidgetStateProperty<bool> get _trackVisibility => WidgetStateProperty.resolveWith(
    (states) => widget.trackVisibility ?? _scrollbarTheme.trackVisibility?.resolve(states) ?? false,
  );

  Set<WidgetState> get _states => <WidgetState>{
    if (_dragIsActive) WidgetState.dragged,
    if (_hoverIsActive) WidgetState.hovered,
  };

  WidgetStateProperty<Color> get _thumbColor {
    final Color onSurface = _colorScheme.onSurface;
    final Brightness brightness = _colorScheme.brightness;
    late Color dragColor;
    late Color hoverColor;
    late Color idleColor;
    switch (brightness) {
      case Brightness.light:
        dragColor = onSurface.withOpacity(0.6);
        hoverColor = onSurface.withOpacity(0.5);
        idleColor =
            _useAndroidScrollbar ? Theme.of(context).highlightColor.withOpacity(1.0) : onSurface.withOpacity(0.1);
      case Brightness.dark:
        dragColor = onSurface.withOpacity(0.75);
        hoverColor = onSurface.withOpacity(0.65);
        idleColor =
            _useAndroidScrollbar ? Theme.of(context).highlightColor.withOpacity(1.0) : onSurface.withOpacity(0.3);
    }

    return WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.dragged)) {
        return _scrollbarTheme.thumbColor?.resolve(states) ?? dragColor;
      }

      // If the track is visible, the thumb color hover animation is ignored and
      // changes immediately.
      if (_trackVisibility.resolve(states)) {
        return _scrollbarTheme.thumbColor?.resolve(states) ?? hoverColor;
      }

      return Color.lerp(
        _scrollbarTheme.thumbColor?.resolve(states) ?? idleColor,
        _scrollbarTheme.thumbColor?.resolve(states) ?? hoverColor,
        _hoverAnimationController.value,
      )!;
    });
  }

  WidgetStateProperty<Color> get _trackColor {
    final Color onSurface = _colorScheme.onSurface;
    final Brightness brightness = _colorScheme.brightness;
    return WidgetStateProperty.resolveWith((states) {
      if (showScrollbar && _trackVisibility.resolve(states)) {
        return _scrollbarTheme.trackColor?.resolve(states) ??
            switch (brightness) {
              Brightness.light => onSurface.withOpacity(0.03),
              Brightness.dark => onSurface.withOpacity(0.05),
            };
      }
      return const Color(0x00000000);
    });
  }

  WidgetStateProperty<Color> get _trackBorderColor {
    final Color onSurface = _colorScheme.onSurface;
    final Brightness brightness = _colorScheme.brightness;
    return WidgetStateProperty.resolveWith((states) {
      if (showScrollbar && _trackVisibility.resolve(states)) {
        return _scrollbarTheme.trackBorderColor?.resolve(states) ??
            switch (brightness) {
              Brightness.light => onSurface.withOpacity(0.1),
              Brightness.dark => onSurface.withOpacity(0.25),
            };
      }
      return const Color(0x00000000);
    });
  }

  WidgetStateProperty<double> get _thickness => WidgetStateProperty.resolveWith((states) {
    if (states.contains(WidgetState.hovered) && _trackVisibility.resolve(states)) {
      return widget.thickness ?? _scrollbarTheme.thickness?.resolve(states) ?? _kScrollbarThicknessWithTrack;
    }
    // The default scrollbar thickness is smaller on mobile.
    return widget.thickness ??
        _scrollbarTheme.thickness?.resolve(states) ??
        (_kScrollbarThickness / (_useAndroidScrollbar ? 2 : 1));
  });

  @override
  void initState() {
    super.initState();
    _hoverAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _hoverAnimationController.addListener(updateScrollbarPainter);
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    _colorScheme = theme.colorScheme;
    _scrollbarTheme = ScrollbarTheme.of(context);
    switch (theme.platform) {
      case TargetPlatform.android:
        _useAndroidScrollbar = true;
      case TargetPlatform.iOS:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        _useAndroidScrollbar = false;
    }
    super.didChangeDependencies();
  }

  @override
  void updateScrollbarPainter() {
    scrollbarPainter
      ..color = _thumbColor.resolve(_states)
      ..trackColor = _trackColor.resolve(_states)
      ..trackBorderColor = _trackBorderColor.resolve(_states)
      ..textDirection = Directionality.of(context)
      ..thickness = _thickness.resolve(_states)
      ..radius = widget.radius ?? _scrollbarTheme.radius ?? (_useAndroidScrollbar ? null : _kScrollbarRadius)
      ..crossAxisMargin = _scrollbarTheme.crossAxisMargin ?? (_useAndroidScrollbar ? 0.0 : _kScrollbarMargin)
      ..mainAxisMargin = _scrollbarTheme.mainAxisMargin ?? 0.0
      ..minLength = _scrollbarTheme.minThumbLength ?? _kScrollbarMinLength
      ..padding = MediaQuery.paddingOf(context)
      ..scrollbarOrientation = widget.scrollbarOrientation
      ..ignorePointer = !enableGestures;
  }

  @override
  void handleThumbPressStart(Offset localPosition) {
    super.handleThumbPressStart(localPosition);
    setState(() {
      _dragIsActive = true;
    });
  }

  @override
  void handleThumbPressEnd(Offset localPosition, Velocity velocity) {
    super.handleThumbPressEnd(localPosition, velocity);
    setState(() {
      _dragIsActive = false;
    });
  }

  @override
  void handleHover(PointerHoverEvent event) {
    super.handleHover(event);
    // Check if the position of the pointer falls over the painted scrollbar
    if (isPointerOverScrollbar(event.position, event.kind, forHover: true)) {
      // Pointer is hovering over the scrollbar
      setState(() {
        _hoverIsActive = true;
      });
      _hoverAnimationController.forward();
    } else if (_hoverIsActive) {
      // Pointer was, but is no longer over painted scrollbar.
      setState(() {
        _hoverIsActive = false;
      });
      _hoverAnimationController.reverse();
    }
  }

  @override
  void handleHoverExit(PointerExitEvent event) {
    super.handleHoverExit(event);
    setState(() {
      _hoverIsActive = false;
    });
    _hoverAnimationController.reverse();
  }

  @override
  void dispose() {
    _hoverAnimationController.dispose();
    super.dispose();
  }
}
