// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/constants.dart';
import 'package:waveui/material/ink_well.dart';
import 'package:waveui/material/material.dart';
import 'package:waveui/material/material_state_mixin.dart';
import 'package:waveui/material/theme.dart';
import 'package:waveui/material/theme_data.dart';

@Category(<String>['Material', 'Button'])
class RawMaterialButton extends StatefulWidget {
  const RawMaterialButton({
    required this.onPressed,
    super.key,
    this.onLongPress,
    this.onHighlightChanged,
    this.mouseCursor,
    this.textStyle,
    this.fillColor,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.splashColor,
    this.elevation = 2.0,
    this.focusElevation = 4.0,
    this.hoverElevation = 4.0,
    this.highlightElevation = 8.0,
    this.disabledElevation = 0.0,
    this.padding = EdgeInsets.zero,
    this.visualDensity = VisualDensity.standard,
    this.constraints = const BoxConstraints(minWidth: 88.0, minHeight: 36.0),
    this.shape = const RoundedRectangleBorder(),
    this.animationDuration = kThemeChangeDuration,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.autofocus = false,
    MaterialTapTargetSize? materialTapTargetSize,
    this.child,
    this.enableFeedback = true,
  }) : materialTapTargetSize = materialTapTargetSize ?? MaterialTapTargetSize.padded,
       assert(elevation >= 0.0),
       assert(focusElevation >= 0.0),
       assert(hoverElevation >= 0.0),
       assert(highlightElevation >= 0.0),
       assert(disabledElevation >= 0.0);

  final VoidCallback? onPressed;

  final VoidCallback? onLongPress;

  final ValueChanged<bool>? onHighlightChanged;

  final MouseCursor? mouseCursor;

  final TextStyle? textStyle;

  final Color? fillColor;

  final Color? focusColor;

  final Color? hoverColor;

  final Color? highlightColor;

  final Color? splashColor;

  final double elevation;

  final double hoverElevation;

  final double focusElevation;

  final double highlightElevation;

  final double disabledElevation;

  final EdgeInsetsGeometry padding;

  final VisualDensity visualDensity;

  final BoxConstraints constraints;

  final ShapeBorder shape;

  final Duration animationDuration;

  final Widget? child;

  bool get enabled => onPressed != null || onLongPress != null;

  final MaterialTapTargetSize materialTapTargetSize;

  final FocusNode? focusNode;

  final bool autofocus;

  final Clip clipBehavior;

  final bool enableFeedback;

  @override
  State<RawMaterialButton> createState() => _RawMaterialButtonState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onPressed', onPressed));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onLongPress', onLongPress));
    properties.add(ObjectFlagProperty<ValueChanged<bool>?>.has('onHighlightChanged', onHighlightChanged));
    properties.add(DiagnosticsProperty<MouseCursor?>('mouseCursor', mouseCursor));
    properties.add(DiagnosticsProperty<TextStyle?>('textStyle', textStyle));
    properties.add(ColorProperty('fillColor', fillColor));
    properties.add(ColorProperty('focusColor', focusColor));
    properties.add(ColorProperty('hoverColor', hoverColor));
    properties.add(ColorProperty('highlightColor', highlightColor));
    properties.add(ColorProperty('splashColor', splashColor));
    properties.add(DoubleProperty('elevation', elevation));
    properties.add(DoubleProperty('hoverElevation', hoverElevation));
    properties.add(DoubleProperty('focusElevation', focusElevation));
    properties.add(DoubleProperty('highlightElevation', highlightElevation));
    properties.add(DoubleProperty('disabledElevation', disabledElevation));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding));
    properties.add(DiagnosticsProperty<VisualDensity>('visualDensity', visualDensity));
    properties.add(DiagnosticsProperty<BoxConstraints>('constraints', constraints));
    properties.add(DiagnosticsProperty<ShapeBorder>('shape', shape));
    properties.add(DiagnosticsProperty<Duration>('animationDuration', animationDuration));
    properties.add(DiagnosticsProperty<bool>('enabled', enabled));
    properties.add(EnumProperty<MaterialTapTargetSize>('materialTapTargetSize', materialTapTargetSize));
    properties.add(DiagnosticsProperty<FocusNode?>('focusNode', focusNode));
    properties.add(DiagnosticsProperty<bool>('autofocus', autofocus));
    properties.add(EnumProperty<Clip>('clipBehavior', clipBehavior));
    properties.add(DiagnosticsProperty<bool>('enableFeedback', enableFeedback));
  }
}

class _RawMaterialButtonState extends State<RawMaterialButton> with WidgetStateMixin {
  @override
  void initState() {
    super.initState();
    setWidgetState(WidgetState.disabled, !widget.enabled);
  }

  @override
  void didUpdateWidget(RawMaterialButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    setWidgetState(WidgetState.disabled, !widget.enabled);
    // If the button is disabled while a press gesture is currently ongoing,
    // InkWell makes a call to handleHighlightChanged. This causes an exception
    // because it calls setState in the middle of a build. To preempt this, we
    // manually update pressed to false when this situation occurs.
    if (isDisabled && isPressed) {
      removeWidgetState(WidgetState.pressed);
    }
  }

  double get _effectiveElevation {
    // These conditionals are in order of precedence, so be careful about
    // reorganizing them.
    if (isDisabled) {
      return widget.disabledElevation;
    }
    if (isPressed) {
      return widget.highlightElevation;
    }
    if (isHovered) {
      return widget.hoverElevation;
    }
    if (isFocused) {
      return widget.focusElevation;
    }
    return widget.elevation;
  }

  @override
  Widget build(BuildContext context) {
    final Color? effectiveTextColor = WidgetStateProperty.resolveAs<Color?>(widget.textStyle?.color, WidgetStates);
    final ShapeBorder? effectiveShape = WidgetStateProperty.resolveAs<ShapeBorder?>(widget.shape, WidgetStates);
    final Offset densityAdjustment = widget.visualDensity.baseSizeAdjustment;
    final BoxConstraints effectiveConstraints = widget.visualDensity.effectiveConstraints(widget.constraints);
    final MouseCursor? effectiveMouseCursor = WidgetStateProperty.resolveAs<MouseCursor?>(
      widget.mouseCursor ?? WidgetStateMouseCursor.clickable,
      WidgetStates,
    );
    final EdgeInsetsGeometry padding = widget.padding
        .add(
          EdgeInsets.only(
            left: densityAdjustment.dx,
            top: densityAdjustment.dy,
            right: densityAdjustment.dx,
            bottom: densityAdjustment.dy,
          ),
        )
        .clamp(EdgeInsets.zero, EdgeInsetsGeometry.infinity);

    final Widget result = ConstrainedBox(
      constraints: effectiveConstraints,
      child: Material(
        elevation: _effectiveElevation,
        textStyle: widget.textStyle?.copyWith(color: effectiveTextColor),
        shape: effectiveShape,
        color: widget.fillColor,
        // For compatibility during the M3 migration the default shadow needs to be passed.
        shadowColor: Theme.of(context).shadowColor,
        type: widget.fillColor == null ? MaterialType.transparency : MaterialType.button,
        animationDuration: widget.animationDuration,
        clipBehavior: widget.clipBehavior,
        child: InkWell(
          focusNode: widget.focusNode,
          canRequestFocus: widget.enabled,
          onFocusChange: updateWidgetState(WidgetState.focused),
          autofocus: widget.autofocus,
          onHighlightChanged: updateWidgetState(WidgetState.pressed, onChanged: widget.onHighlightChanged),
          splashColor: widget.splashColor,
          highlightColor: widget.highlightColor,
          focusColor: widget.focusColor,
          hoverColor: widget.hoverColor,
          onHover: updateWidgetState(WidgetState.hovered),
          onTap: widget.onPressed,
          onLongPress: widget.onLongPress,
          enableFeedback: widget.enableFeedback,
          customBorder: effectiveShape,
          mouseCursor: effectiveMouseCursor,
          child: IconTheme.merge(
            data: IconThemeData(color: effectiveTextColor),
            child: Padding(padding: padding, child: Center(widthFactor: 1.0, heightFactor: 1.0, child: widget.child)),
          ),
        ),
      ),
    );
    final Size minSize;
    switch (widget.materialTapTargetSize) {
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
      button: true,
      enabled: widget.enabled,
      child: _InputPadding(minSize: minSize, child: result),
    );
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
