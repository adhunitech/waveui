// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/badge_theme.dart';
import 'package:waveui/material/color_scheme.dart';
import 'package:waveui/material/theme.dart';

class Badge extends StatelessWidget {
  const Badge({
    super.key,
    this.backgroundColor,
    this.textColor,
    this.smallSize,
    this.largeSize,
    this.textStyle,
    this.padding,
    this.alignment,
    this.offset,
    this.label,
    this.isLabelVisible = true,
    this.child,
  });

  Badge.count({
    required int count,
    super.key,
    this.backgroundColor,
    this.textColor,
    this.smallSize,
    this.largeSize,
    this.textStyle,
    this.padding,
    this.alignment,
    this.offset,
    this.isLabelVisible = true,
    this.child,
  }) : label = Text(count > 999 ? '999+' : '$count');

  final Color? backgroundColor;

  final Color? textColor;

  final double? smallSize;

  final double? largeSize;

  final TextStyle? textStyle;

  final EdgeInsetsGeometry? padding;

  final AlignmentGeometry? alignment;

  final Offset? offset;

  final Widget? label;

  final bool isLabelVisible;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    if (!isLabelVisible) {
      return child ?? const SizedBox();
    }

    final BadgeThemeData badgeTheme = BadgeTheme.of(context);
    final BadgeThemeData defaults = _BadgeDefaultsM3(context);
    final Decoration effectiveDecoration = ShapeDecoration(
      color: backgroundColor ?? badgeTheme.backgroundColor ?? defaults.backgroundColor!,
      shape: const StadiumBorder(),
    );
    final double effectiveWidthOffset;
    final Widget badge;
    final bool hasLabel = label != null;
    if (hasLabel) {
      final double minSize = effectiveWidthOffset = largeSize ?? badgeTheme.largeSize ?? defaults.largeSize!;
      badge = DefaultTextStyle(
        style: (textStyle ?? badgeTheme.textStyle ?? defaults.textStyle!).copyWith(
          color: textColor ?? badgeTheme.textColor ?? defaults.textColor!,
        ),
        child: _IntrinsicHorizontalStadium(
          minSize: minSize,
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: effectiveDecoration,
            padding: padding ?? badgeTheme.padding ?? defaults.padding!,
            alignment: Alignment.center,
            child: label,
          ),
        ),
      );
    } else {
      final double effectiveSmallSize = effectiveWidthOffset = smallSize ?? badgeTheme.smallSize ?? defaults.smallSize!;
      badge = Container(
        width: effectiveSmallSize,
        height: effectiveSmallSize,
        clipBehavior: Clip.antiAlias,
        decoration: effectiveDecoration,
      );
    }

    if (child == null) {
      return badge;
    }

    final AlignmentGeometry effectiveAlignment = alignment ?? badgeTheme.alignment ?? defaults.alignment!;
    final TextDirection textDirection = Directionality.of(context);
    final Offset defaultOffset = textDirection == TextDirection.ltr ? const Offset(4, -4) : const Offset(-4, -4);
    // Adds a offset const Offset(0, 8) to avoiding breaking customers after
    // the offset calculation changes.
    // See https://github.com/flutter/flutter/pull/146853.
    final Offset effectiveOffset = (offset ?? badgeTheme.offset ?? defaultOffset) + const Offset(0, 8);

    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        child!,
        Positioned.fill(
          child: _Badge(
            alignment: effectiveAlignment,
            offset: hasLabel ? effectiveOffset : Offset.zero,
            hasLabel: hasLabel,
            widthOffset: effectiveWidthOffset,
            textDirection: textDirection,
            child: badge,
          ),
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(ColorProperty('textColor', textColor));
    properties.add(DoubleProperty('smallSize', smallSize));
    properties.add(DoubleProperty('largeSize', largeSize));
    properties.add(DiagnosticsProperty<TextStyle?>('textStyle', textStyle));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('padding', padding));
    properties.add(DiagnosticsProperty<AlignmentGeometry?>('alignment', alignment));
    properties.add(DiagnosticsProperty<Offset?>('offset', offset));
    properties.add(DiagnosticsProperty<bool>('isLabelVisible', isLabelVisible));
  }
}

class _Badge extends SingleChildRenderObjectWidget {
  const _Badge({
    required this.alignment,
    required this.offset,
    required this.widthOffset,
    required this.textDirection,
    required this.hasLabel,
    super.child, // the badge
  });

  final AlignmentGeometry alignment;
  final Offset offset;
  final double widthOffset;
  final TextDirection textDirection;
  final bool hasLabel;

  @override
  _RenderBadge createRenderObject(BuildContext context) => _RenderBadge(
    alignment: alignment,
    widthOffset: widthOffset,
    hasLabel: hasLabel,
    offset: offset,
    textDirection: Directionality.maybeOf(context),
  );

  @override
  void updateRenderObject(BuildContext context, _RenderBadge renderObject) {
    renderObject
      ..alignment = alignment
      ..offset = offset
      ..widthOffset = widthOffset
      ..hasLabel = hasLabel
      ..textDirection = Directionality.maybeOf(context);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AlignmentGeometry>('alignment', alignment));
    properties.add(DiagnosticsProperty<Offset>('offset', offset));
    properties.add(DoubleProperty('widthOffset', widthOffset));
    properties.add(EnumProperty<TextDirection>('textDirection', textDirection));
    properties.add(DiagnosticsProperty<bool>('hasLabel', hasLabel));
  }
}

class _RenderBadge extends RenderAligningShiftedBox {
  _RenderBadge({
    required Offset offset,
    required bool hasLabel,
    required double widthOffset,
    super.textDirection,
    super.alignment,
  }) : _offset = offset,
       _hasLabel = hasLabel,
       _widthOffset = widthOffset;

  Offset get offset => _offset;
  Offset _offset;
  set offset(Offset value) {
    if (_offset == value) {
      return;
    }
    _offset = value;
    markNeedsLayout();
  }

  bool get hasLabel => _hasLabel;
  bool _hasLabel;
  set hasLabel(bool value) {
    if (_hasLabel == value) {
      return;
    }
    _hasLabel = value;
    markNeedsLayout();
  }

  double get widthOffset => _widthOffset;
  double _widthOffset;
  set widthOffset(double value) {
    if (_widthOffset == value) {
      return;
    }
    _widthOffset = value;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    assert(constraints.hasBoundedWidth);
    assert(constraints.hasBoundedHeight);
    size = constraints.biggest;

    child!.layout(const BoxConstraints(), parentUsesSize: true);
    final double badgeSize = child!.size.height;
    final Alignment resolvedAlignment = alignment.resolve(textDirection);
    final BoxParentData childParentData = child!.parentData! as BoxParentData;
    Offset badgeLocation = offset + resolvedAlignment.alongOffset(Offset(size.width - widthOffset, size.height));
    if (hasLabel) {
      // Adjust for label height.
      badgeLocation = badgeLocation - Offset(0, badgeSize / 2);
    }
    childParentData.offset = badgeLocation;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Offset>('offset', offset));
    properties.add(DiagnosticsProperty<bool>('hasLabel', hasLabel));
    properties.add(DoubleProperty('widthOffset', widthOffset));
  }
}

class _IntrinsicHorizontalStadium extends SingleChildRenderObjectWidget {
  const _IntrinsicHorizontalStadium({required this.minSize, super.child});
  final double minSize;

  @override
  _RenderIntrinsicHorizontalStadium createRenderObject(BuildContext context) =>
      _RenderIntrinsicHorizontalStadium(minSize: minSize);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('minSize', minSize));
  }
}

class _RenderIntrinsicHorizontalStadium extends RenderProxyBox {
  _RenderIntrinsicHorizontalStadium({required double minSize, RenderBox? child}) : _minSize = minSize, super(child);

  double get minSize => _minSize;
  double _minSize;
  set minSize(double value) {
    if (_minSize == value) {
      return;
    }
    _minSize = value;
    markNeedsLayout();
  }

  @override
  double computeMinIntrinsicWidth(double height) => getMaxIntrinsicWidth(height);

  @override
  double computeMaxIntrinsicWidth(double height) =>
      math.max(getMaxIntrinsicHeight(double.infinity), super.computeMaxIntrinsicWidth(height));

  @override
  double computeMinIntrinsicHeight(double width) => getMaxIntrinsicHeight(width);

  @override
  double computeMaxIntrinsicHeight(double width) => math.max(minSize, super.computeMaxIntrinsicHeight(width));

  BoxConstraints _childConstraints(RenderBox child, BoxConstraints constraints) {
    final double childHeight = math.max(minSize, child.getMaxIntrinsicHeight(constraints.maxWidth));
    final double childWidth = child.getMaxIntrinsicWidth(constraints.maxHeight);
    return constraints.tighten(width: math.max(childWidth, childHeight), height: childHeight);
  }

  Size _computeSize({required ChildLayouter layoutChild, required BoxConstraints constraints}) {
    final RenderBox child = this.child!;
    final Size childSize = layoutChild(child, _childConstraints(child, constraints));
    if (childSize.height > childSize.width) {
      return Size(childSize.height, childSize.height);
    }
    return childSize;
  }

  @override
  @protected
  Size computeDryLayout(covariant BoxConstraints constraints) =>
      _computeSize(layoutChild: ChildLayoutHelper.dryLayoutChild, constraints: constraints);

  @override
  double? computeDryBaseline(BoxConstraints constraints, TextBaseline baseline) {
    final RenderBox child = this.child!;
    return child.getDryBaseline(_childConstraints(child, constraints), baseline);
  }

  @override
  void performLayout() {
    size = _computeSize(layoutChild: ChildLayoutHelper.layoutChild, constraints: constraints);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('minSize', minSize));
  }
}

// BEGIN GENERATED TOKEN PROPERTIES - Badge

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// dart format off
class _BadgeDefaultsM3 extends BadgeThemeData {
  _BadgeDefaultsM3(this.context) : super(
    smallSize: 6.0,
    largeSize: 16.0,
    padding: const EdgeInsets.symmetric(horizontal: 4),
    alignment: AlignmentDirectional.topEnd,
  );

  final BuildContext context;
  late final ThemeData _theme = Theme.of(context);
  late final ColorScheme _colors = _theme.colorScheme;

  @override
  Color? get backgroundColor => _colors.error;

  @override
  Color? get textColor => _colors.onError;

  @override
  TextStyle? get textStyle => Theme.of(context).textTheme.labelSmall;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BuildContext>('context', context));
  }
}
// dart format on

// END GENERATED TOKEN PROPERTIES - Badge
