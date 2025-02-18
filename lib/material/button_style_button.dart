// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/button_style.dart';
import 'package:waveui/material/colors.dart';
import 'package:waveui/material/constants.dart';
import 'package:waveui/material/ink_well.dart';
import 'package:waveui/material/material.dart';
import 'package:waveui/material/theme_data.dart';
import 'package:waveui/material/tooltip.dart';

enum IconAlignment { start, end }

abstract class ButtonStyleButton extends StatefulWidget {
  const ButtonStyleButton({
    required this.onPressed,
    required this.onLongPress,
    required this.onHover,
    required this.onFocusChange,
    required this.style,
    required this.focusNode,
    required this.autofocus,
    required this.clipBehavior,
    required this.child,
    super.key,
    this.statesController,
    this.isSemanticButton = true,
    @Deprecated(
      'Remove this parameter as it is now ignored. '
      'Use ButtonStyle.iconAlignment instead. '
      'This feature was deprecated after v3.28.0-1.0.pre.',
    )
    this.iconAlignment,
    this.tooltip,
  });

  final VoidCallback? onPressed;

  final VoidCallback? onLongPress;

  final ValueChanged<bool>? onHover;

  final ValueChanged<bool>? onFocusChange;

  final ButtonStyle? style;

  final Clip? clipBehavior;

  final FocusNode? focusNode;

  final bool autofocus;

  final WidgetStatesController? statesController;

  final bool? isSemanticButton;

  @Deprecated(
    'Remove this parameter as it is now ignored. '
    'Use ButtonStyle.iconAlignment instead. '
    'This feature was deprecated after v3.28.0-1.0.pre.',
  )
  final IconAlignment? iconAlignment;

  final String? tooltip;

  final Widget? child;

  @protected
  ButtonStyle defaultStyleOf(BuildContext context);

  @protected
  ButtonStyle? themeStyleOf(BuildContext context);

  bool get enabled => onPressed != null || onLongPress != null;

  @override
  State<ButtonStyleButton> createState() => _ButtonStyleState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(FlagProperty('enabled', value: enabled, ifFalse: 'disabled'));
    properties.add(DiagnosticsProperty<ButtonStyle>('style', style, defaultValue: null));
    properties.add(DiagnosticsProperty<FocusNode>('focusNode', focusNode, defaultValue: null));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onPressed', onPressed));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onLongPress', onLongPress));
    properties.add(ObjectFlagProperty<ValueChanged<bool>?>.has('onHover', onHover));
    properties.add(ObjectFlagProperty<ValueChanged<bool>?>.has('onFocusChange', onFocusChange));
    properties.add(EnumProperty<Clip?>('clipBehavior', clipBehavior));
    properties.add(DiagnosticsProperty<bool>('autofocus', autofocus));
    properties.add(DiagnosticsProperty<WidgetStatesController?>('statesController', statesController));
    properties.add(DiagnosticsProperty<bool?>('isSemanticButton', isSemanticButton));
    properties.add(EnumProperty<IconAlignment?>('iconAlignment', iconAlignment));
    properties.add(StringProperty('tooltip', tooltip));
  }

  static WidgetStateProperty<T>? allOrNull<T>(T? value) => value == null ? null : WidgetStatePropertyAll<T>(value);

  static WidgetStateProperty<Color?>? defaultColor(Color? enabled, Color? disabled) {
    if ((enabled ?? disabled) == null) {
      return null;
    }
    return WidgetStateProperty<Color?>.fromMap(<WidgetStatesConstraint, Color?>{
      WidgetState.disabled: disabled,
      WidgetState.any: enabled,
    });
  }

  static EdgeInsetsGeometry scaledPadding(
    EdgeInsetsGeometry geometry1x,
    EdgeInsetsGeometry geometry2x,
    EdgeInsetsGeometry geometry3x,
    double fontSizeMultiplier,
  ) => switch (fontSizeMultiplier) {
    <= 1 => geometry1x,
    < 2 => EdgeInsetsGeometry.lerp(geometry1x, geometry2x, fontSizeMultiplier - 1)!,
    < 3 => EdgeInsetsGeometry.lerp(geometry2x, geometry3x, fontSizeMultiplier - 2)!,
    _ => geometry3x,
  };
}

class _ButtonStyleState extends State<ButtonStyleButton> with TickerProviderStateMixin {
  AnimationController? controller;
  double? elevation;
  Color? backgroundColor;
  WidgetStatesController? internalStatesController;

  void handleStatesControllerChange() {
    // Force a rebuild to resolve WidgetStateProperty properties
    setState(() {});
  }

  WidgetStatesController get statesController => widget.statesController ?? internalStatesController!;

  void initStatesController() {
    if (widget.statesController == null) {
      internalStatesController = WidgetStatesController();
    }
    statesController.update(WidgetState.disabled, !widget.enabled);
    statesController.addListener(handleStatesControllerChange);
  }

  @override
  void initState() {
    super.initState();
    initStatesController();
  }

  @override
  void didUpdateWidget(ButtonStyleButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.statesController != oldWidget.statesController) {
      oldWidget.statesController?.removeListener(handleStatesControllerChange);
      if (widget.statesController != null) {
        internalStatesController?.dispose();
        internalStatesController = null;
      }
      initStatesController();
    }
    if (widget.enabled != oldWidget.enabled) {
      statesController.update(WidgetState.disabled, !widget.enabled);
      if (!widget.enabled) {
        // The button may have been disabled while a press gesture is currently underway.
        statesController.update(WidgetState.pressed, false);
      }
    }
  }

  @override
  void dispose() {
    statesController.removeListener(handleStatesControllerChange);
    internalStatesController?.dispose();
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle? widgetStyle = widget.style;
    final ButtonStyle? themeStyle = widget.themeStyleOf(context);
    final ButtonStyle defaultStyle = widget.defaultStyleOf(context);

    T? effectiveValue<T>(T? Function(ButtonStyle? style) getProperty) {
      final T? widgetValue = getProperty(widgetStyle);
      final T? themeValue = getProperty(themeStyle);
      final T? defaultValue = getProperty(defaultStyle);
      return widgetValue ?? themeValue ?? defaultValue;
    }

    T? resolve<T>(WidgetStateProperty<T>? Function(ButtonStyle? style) getProperty) =>
        effectiveValue((style) => getProperty(style)?.resolve(statesController.value));

    Color? effectiveIconColor() =>
        widgetStyle?.iconColor?.resolve(statesController.value) ??
        themeStyle?.iconColor?.resolve(statesController.value) ??
        widgetStyle?.foregroundColor?.resolve(statesController.value) ??
        themeStyle?.foregroundColor?.resolve(statesController.value) ??
        defaultStyle.iconColor?.resolve(statesController.value) ??
        // Fallback to foregroundColor if iconColor is null.
        defaultStyle.foregroundColor?.resolve(statesController.value);

    final double? resolvedElevation = resolve<double?>((style) => style?.elevation);
    final TextStyle? resolvedTextStyle = resolve<TextStyle?>((style) => style?.textStyle);
    Color? resolvedBackgroundColor = resolve<Color?>((style) => style?.backgroundColor);
    final Color? resolvedForegroundColor = resolve<Color?>((style) => style?.foregroundColor);
    final Color? resolvedShadowColor = resolve<Color?>((style) => style?.shadowColor);
    final Color? resolvedSurfaceTintColor = resolve<Color?>((style) => style?.surfaceTintColor);
    final EdgeInsetsGeometry? resolvedPadding = resolve<EdgeInsetsGeometry?>((style) => style?.padding);
    final Size? resolvedMinimumSize = resolve<Size?>((style) => style?.minimumSize);
    final Size? resolvedFixedSize = resolve<Size?>((style) => style?.fixedSize);
    final Size? resolvedMaximumSize = resolve<Size?>((style) => style?.maximumSize);
    final Color? resolvedIconColor = effectiveIconColor();
    final double? resolvedIconSize = resolve<double?>((style) => style?.iconSize);
    final BorderSide? resolvedSide = resolve<BorderSide?>((style) => style?.side);
    final OutlinedBorder? resolvedShape = resolve<OutlinedBorder?>((style) => style?.shape);

    final WidgetStateMouseCursor mouseCursor = _MouseCursor(
      (states) => effectiveValue((style) => style?.mouseCursor?.resolve(states)),
    );

    final WidgetStateProperty<Color?> overlayColor = WidgetStateProperty.resolveWith<Color?>(
      (states) => effectiveValue((style) => style?.overlayColor?.resolve(states)),
    );

    final VisualDensity? resolvedVisualDensity = effectiveValue((style) => style?.visualDensity);
    final MaterialTapTargetSize? resolvedTapTargetSize = effectiveValue((style) => style?.tapTargetSize);
    final Duration? resolvedAnimationDuration = effectiveValue((style) => style?.animationDuration);
    final bool resolvedEnableFeedback = effectiveValue((style) => style?.enableFeedback) ?? true;
    final AlignmentGeometry? resolvedAlignment = effectiveValue((style) => style?.alignment);
    final Offset densityAdjustment = resolvedVisualDensity!.baseSizeAdjustment;
    final InteractiveInkFeatureFactory? resolvedSplashFactory = effectiveValue((style) => style?.splashFactory);
    final ButtonLayerBuilder? resolvedBackgroundBuilder = effectiveValue((style) => style?.backgroundBuilder);
    final ButtonLayerBuilder? resolvedForegroundBuilder = effectiveValue((style) => style?.foregroundBuilder);

    final Clip effectiveClipBehavior =
        widget.clipBehavior ??
        ((resolvedBackgroundBuilder ?? resolvedForegroundBuilder) != null ? Clip.antiAlias : Clip.none);

    BoxConstraints effectiveConstraints = resolvedVisualDensity.effectiveConstraints(
      BoxConstraints(
        minWidth: resolvedMinimumSize!.width,
        minHeight: resolvedMinimumSize.height,
        maxWidth: resolvedMaximumSize!.width,
        maxHeight: resolvedMaximumSize.height,
      ),
    );
    if (resolvedFixedSize != null) {
      final Size size = effectiveConstraints.constrain(resolvedFixedSize);
      if (size.width.isFinite) {
        effectiveConstraints = effectiveConstraints.copyWith(minWidth: size.width, maxWidth: size.width);
      }
      if (size.height.isFinite) {
        effectiveConstraints = effectiveConstraints.copyWith(minHeight: size.height, maxHeight: size.height);
      }
    }

    // Per the Material Design team: don't allow the VisualDensity
    // adjustment to reduce the width of the left/right padding. If we
    // did, VisualDensity.compact, the default for desktop/web, would
    // reduce the horizontal padding to zero.
    final double dy = densityAdjustment.dy;
    final double dx = math.max(0, densityAdjustment.dx);
    final EdgeInsetsGeometry padding = resolvedPadding!
        .add(EdgeInsets.fromLTRB(dx, dy, dx, dy))
        .clamp(EdgeInsets.zero, EdgeInsetsGeometry.infinity);

    // If an opaque button's background is becoming translucent while its
    // elevation is changing, change the elevation first. Material implicitly
    // animates its elevation but not its color. SKIA renders non-zero
    // elevations as a shadow colored fill behind the Material's background.
    if (resolvedAnimationDuration! > Duration.zero &&
        elevation != null &&
        backgroundColor != null &&
        elevation != resolvedElevation &&
        backgroundColor!.value != resolvedBackgroundColor!.value &&
        backgroundColor!.opacity == 1 &&
        resolvedBackgroundColor.opacity < 1 &&
        resolvedElevation == 0) {
      if (controller?.duration != resolvedAnimationDuration) {
        controller?.dispose();
        controller = AnimationController(duration: resolvedAnimationDuration, vsync: this)..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            setState(() {}); // Rebuild with the final background color.
          }
        });
      }
      resolvedBackgroundColor = backgroundColor; // Defer changing the background color.
      controller!.value = 0;
      controller!.forward();
    }
    elevation = resolvedElevation;
    backgroundColor = resolvedBackgroundColor;

    Widget result = Padding(
      padding: padding,
      child: Align(
        alignment: resolvedAlignment!,
        widthFactor: 1.0,
        heightFactor: 1.0,
        child:
            resolvedForegroundBuilder != null
                ? resolvedForegroundBuilder(context, statesController.value, widget.child)
                : widget.child,
      ),
    );
    if (resolvedBackgroundBuilder != null) {
      result = resolvedBackgroundBuilder(context, statesController.value, result);
    }

    result = InkWell(
      onTap: widget.onPressed,
      onLongPress: widget.onLongPress,
      onHover: widget.onHover,
      mouseCursor: mouseCursor,
      enableFeedback: resolvedEnableFeedback,
      focusNode: widget.focusNode,
      canRequestFocus: widget.enabled,
      onFocusChange: widget.onFocusChange,
      autofocus: widget.autofocus,
      splashFactory: resolvedSplashFactory,
      overlayColor: overlayColor,
      highlightColor: Colors.transparent,
      customBorder: resolvedShape!.copyWith(side: resolvedSide),
      statesController: statesController,
      child: IconTheme.merge(data: IconThemeData(color: resolvedIconColor, size: resolvedIconSize), child: result),
    );

    if (widget.tooltip != null) {
      result = Tooltip(message: widget.tooltip, child: result);
    }

    final Size minSize;
    switch (resolvedTapTargetSize!) {
      case MaterialTapTargetSize.padded:
        minSize = Size(
          kMinInteractiveDimension + densityAdjustment.dx,
          kMinInteractiveDimension + densityAdjustment.dy,
        );
        assert(minSize.width >= 0.0);
        assert(minSize.height >= 0.0);
      case MaterialTapTargetSize.shrinkWrap:
        minSize = Size.zero;
    }

    return Semantics(
      container: true,
      button: widget.isSemanticButton,
      enabled: widget.enabled,
      child: _InputPadding(
        minSize: minSize,
        child: ConstrainedBox(
          constraints: effectiveConstraints,
          child: Material(
            elevation: resolvedElevation!,
            textStyle: resolvedTextStyle?.copyWith(color: resolvedForegroundColor),
            shape: resolvedShape.copyWith(side: resolvedSide),
            color: resolvedBackgroundColor,
            shadowColor: resolvedShadowColor,
            surfaceTintColor: resolvedSurfaceTintColor,
            type: resolvedBackgroundColor == null ? MaterialType.transparency : MaterialType.button,
            animationDuration: resolvedAnimationDuration,
            clipBehavior: effectiveClipBehavior,
            child: result,
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AnimationController?>('controller', controller));
    properties.add(DoubleProperty('elevation', elevation));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(DiagnosticsProperty<WidgetStatesController?>('internalStatesController', internalStatesController));
    properties.add(DiagnosticsProperty<WidgetStatesController>('statesController', statesController));
  }
}

class _MouseCursor extends WidgetStateMouseCursor {
  const _MouseCursor(this.resolveCallback);

  final WidgetPropertyResolver<MouseCursor?> resolveCallback;

  @override
  MouseCursor resolve(Set<WidgetState> states) => resolveCallback(states)!;

  @override
  String get debugDescription => 'ButtonStyleButton_MouseCursor';

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<WidgetPropertyResolver<MouseCursor?>>.has('resolveCallback', resolveCallback));
  }
}

class _InputPadding extends SingleChildRenderObjectWidget {
  const _InputPadding({required this.minSize, super.child});

  final Size minSize;

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderInputPadding(minSize);

  @override
  void updateRenderObject(BuildContext context, covariant _RenderInputPadding renderObject) {
    renderObject.minSize = minSize;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Size>('minSize', minSize));
  }
}

class _RenderInputPadding extends RenderShiftedBox {
  _RenderInputPadding(this._minSize, [RenderBox? child]) : super(child);

  Size get minSize => _minSize;
  Size _minSize;
  set minSize(Size value) {
    if (_minSize == value) {
      return;
    }
    _minSize = value;
    markNeedsLayout();
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    if (child != null) {
      return math.max(child!.getMinIntrinsicWidth(height), minSize.width);
    }
    return 0.0;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    if (child != null) {
      return math.max(child!.getMinIntrinsicHeight(width), minSize.height);
    }
    return 0.0;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    if (child != null) {
      return math.max(child!.getMaxIntrinsicWidth(height), minSize.width);
    }
    return 0.0;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    if (child != null) {
      return math.max(child!.getMaxIntrinsicHeight(width), minSize.height);
    }
    return 0.0;
  }

  Size _computeSize({required BoxConstraints constraints, required ChildLayouter layoutChild}) {
    if (child != null) {
      final Size childSize = layoutChild(child!, constraints);
      final double height = math.max(childSize.width, minSize.width);
      final double width = math.max(childSize.height, minSize.height);
      return constraints.constrain(Size(height, width));
    }
    return Size.zero;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) =>
      _computeSize(constraints: constraints, layoutChild: ChildLayoutHelper.dryLayoutChild);

  @override
  double? computeDryBaseline(covariant BoxConstraints constraints, TextBaseline baseline) {
    final RenderBox? child = this.child;
    if (child == null) {
      return null;
    }
    final double? result = child.getDryBaseline(constraints, baseline);
    if (result == null) {
      return null;
    }
    final Size childSize = child.getDryLayout(constraints);
    return result + Alignment.center.alongOffset(getDryLayout(constraints) - childSize as Offset).dy;
  }

  @override
  void performLayout() {
    size = _computeSize(constraints: constraints, layoutChild: ChildLayoutHelper.layoutChild);
    if (child != null) {
      final BoxParentData childParentData = child!.parentData! as BoxParentData;
      childParentData.offset = Alignment.center.alongOffset(size - child!.size as Offset);
    }
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (super.hitTest(result, position: position)) {
      return true;
    }
    final Offset center = child!.size.center(Offset.zero);
    return result.addWithRawTransform(
      transform: MatrixUtils.forceToPoint(center),
      position: center,
      hitTest: (result, position) {
        assert(position == center);
        return child!.hitTest(result, position: center);
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Size>('minSize', minSize));
  }
}
