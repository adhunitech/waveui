// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'dart:math' as math;
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/button_style.dart';
import 'package:waveui/material/color_scheme.dart';
import 'package:waveui/material/colors.dart';
import 'package:waveui/material/constants.dart';
import 'package:waveui/material/icons.dart';
import 'package:waveui/material/ink_well.dart';
import 'package:waveui/material/material.dart';
import 'package:waveui/material/segmented_button_theme.dart';
import 'package:waveui/material/text_button.dart';
import 'package:waveui/material/text_button_theme.dart';
import 'package:waveui/material/theme.dart';
import 'package:waveui/material/theme_data.dart';
import 'package:waveui/material/tooltip.dart';

class ButtonSegment<T> {
  const ButtonSegment({required this.value, this.icon, this.label, this.tooltip, this.enabled = true})
    : assert(icon != null || label != null);

  final T value;

  final Widget? icon;

  final Widget? label;

  final String? tooltip;

  final bool enabled;
}

class SegmentedButton<T> extends StatefulWidget {
  const SegmentedButton({
    required this.segments,
    required this.selected,
    super.key,
    this.onSelectionChanged,
    this.multiSelectionEnabled = false,
    this.emptySelectionAllowed = false,
    this.expandedInsets,
    this.style,
    this.showSelectedIcon = true,
    this.selectedIcon,
    this.direction = Axis.horizontal,
  }) : assert(segments.length > 0),
       assert(selected.length > 0 || emptySelectionAllowed),
       assert(selected.length < 2 || multiSelectionEnabled);

  final List<ButtonSegment<T>> segments;

  final Axis direction;

  final Set<T> selected;

  final void Function(Set<T>)? onSelectionChanged;

  final bool multiSelectionEnabled;

  final bool emptySelectionAllowed;

  final EdgeInsets? expandedInsets;

  static ButtonStyle styleFrom({
    Color? foregroundColor,
    Color? backgroundColor,
    Color? selectedForegroundColor,
    Color? selectedBackgroundColor,
    Color? disabledForegroundColor,
    Color? disabledBackgroundColor,
    Color? shadowColor,
    Color? surfaceTintColor,
    Color? iconColor,
    double? iconSize,
    Color? disabledIconColor,
    Color? overlayColor,
    double? elevation,
    TextStyle? textStyle,
    EdgeInsetsGeometry? padding,
    Size? minimumSize,
    Size? fixedSize,
    Size? maximumSize,
    BorderSide? side,
    OutlinedBorder? shape,
    MouseCursor? enabledMouseCursor,
    MouseCursor? disabledMouseCursor,
    VisualDensity? visualDensity,
    MaterialTapTargetSize? tapTargetSize,
    Duration? animationDuration,
    bool? enableFeedback,
    AlignmentGeometry? alignment,
    InteractiveInkFeatureFactory? splashFactory,
  }) {
    final WidgetStateProperty<Color?>? overlayColorProp =
        (foregroundColor == null && selectedForegroundColor == null && overlayColor == null)
            ? null
            : switch (overlayColor) {
              (final Color overlayColor) when overlayColor.value == 0 => const WidgetStatePropertyAll<Color?>(
                Colors.transparent,
              ),
              _ => _SegmentedButtonDefaultsM3.resolveStateColor(foregroundColor, selectedForegroundColor, overlayColor),
            };
    return TextButton.styleFrom(
      textStyle: textStyle,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      iconColor: iconColor,
      iconSize: iconSize,
      disabledIconColor: disabledIconColor,
      elevation: elevation,
      padding: padding,
      minimumSize: minimumSize,
      fixedSize: fixedSize,
      maximumSize: maximumSize,
      side: side,
      shape: shape,
      enabledMouseCursor: enabledMouseCursor,
      disabledMouseCursor: disabledMouseCursor,
      visualDensity: visualDensity,
      tapTargetSize: tapTargetSize,
      animationDuration: animationDuration,
      enableFeedback: enableFeedback,
      alignment: alignment,
      splashFactory: splashFactory,
    ).copyWith(
      foregroundColor: _defaultColor(foregroundColor, disabledForegroundColor, selectedForegroundColor),
      backgroundColor: _defaultColor(backgroundColor, disabledBackgroundColor, selectedBackgroundColor),
      overlayColor: overlayColorProp,
    );
  }

  static WidgetStateProperty<Color?>? _defaultColor(Color? enabled, Color? disabled, Color? selected) {
    if ((selected ?? enabled ?? disabled) == null) {
      return null;
    }
    return WidgetStateProperty<Color?>.fromMap(<WidgetStatesConstraint, Color?>{
      WidgetState.disabled: disabled,
      WidgetState.selected: selected,
      WidgetState.any: enabled,
    });
  }

  final ButtonStyle? style;

  final bool showSelectedIcon;

  final Widget? selectedIcon;

  @override
  State<SegmentedButton<T>> createState() => SegmentedButtonState<T>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<ButtonSegment<T>>('segments', segments));
    properties.add(EnumProperty<Axis>('direction', direction));
    properties.add(IterableProperty<T>('selected', selected));
    properties.add(ObjectFlagProperty<void Function(Set<T> p1)?>.has('onSelectionChanged', onSelectionChanged));
    properties.add(DiagnosticsProperty<bool>('multiSelectionEnabled', multiSelectionEnabled));
    properties.add(DiagnosticsProperty<bool>('emptySelectionAllowed', emptySelectionAllowed));
    properties.add(DiagnosticsProperty<EdgeInsets?>('expandedInsets', expandedInsets));
    properties.add(DiagnosticsProperty<ButtonStyle?>('style', style));
    properties.add(DiagnosticsProperty<bool>('showSelectedIcon', showSelectedIcon));
  }
}

@visibleForTesting
class SegmentedButtonState<T> extends State<SegmentedButton<T>> {
  bool get _enabled => widget.onSelectionChanged != null;

  @visibleForTesting
  final Map<ButtonSegment<T>, WidgetStatesController> statesControllers = <ButtonSegment<T>, WidgetStatesController>{};

  @protected
  @override
  void didUpdateWidget(covariant SegmentedButton<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget != widget) {
      statesControllers.removeWhere((segment, controller) {
        if (widget.segments.contains(segment)) {
          return false;
        } else {
          controller.dispose();
          return true;
        }
      });
    }
  }

  void _handleOnPressed(T segmentValue) {
    if (!_enabled) {
      return;
    }
    final bool onlySelectedSegment = widget.selected.length == 1 && widget.selected.contains(segmentValue);
    final bool validChange = widget.emptySelectionAllowed || !onlySelectedSegment;
    if (validChange) {
      final bool toggle = widget.multiSelectionEnabled || (widget.emptySelectionAllowed && onlySelectedSegment);
      final Set<T> pressedSegment = <T>{segmentValue};
      late final Set<T> updatedSelection;
      if (toggle) {
        updatedSelection =
            widget.selected.contains(segmentValue)
                ? widget.selected.difference(pressedSegment)
                : widget.selected.union(pressedSegment);
      } else {
        updatedSelection = pressedSegment;
      }
      if (!setEquals(updatedSelection, widget.selected)) {
        widget.onSelectionChanged!(updatedSelection);
      }
    }
  }

  @protected
  @override
  Widget build(BuildContext context) {
    final SegmentedButtonThemeData theme = SegmentedButtonTheme.of(context);
    final SegmentedButtonThemeData defaults = _SegmentedButtonDefaultsM3(context);
    final TextDirection textDirection = Directionality.of(context);

    const Set<WidgetState> enabledState = <WidgetState>{};
    const Set<WidgetState> disabledState = <WidgetState>{WidgetState.disabled};
    final Set<WidgetState> currentState = _enabled ? enabledState : disabledState;

    P? effectiveValue<P>(P? Function(ButtonStyle? style) getProperty) {
      late final P? widgetValue = getProperty(widget.style);
      late final P? themeValue = getProperty(theme.style);
      late final P? defaultValue = getProperty(defaults.style);
      return widgetValue ?? themeValue ?? defaultValue;
    }

    P? resolve<P>(WidgetStateProperty<P>? Function(ButtonStyle? style) getProperty, [Set<WidgetState>? states]) =>
        effectiveValue((style) => getProperty(style)?.resolve(states ?? currentState));

    ButtonStyle segmentStyleFor(ButtonStyle? style) => ButtonStyle(
      textStyle: style?.textStyle,
      backgroundColor: style?.backgroundColor,
      foregroundColor: style?.foregroundColor,
      overlayColor: style?.overlayColor,
      surfaceTintColor: style?.surfaceTintColor,
      elevation: style?.elevation,
      padding: style?.padding,
      iconColor: style?.iconColor,
      iconSize: style?.iconSize,
      shape: const WidgetStatePropertyAll<OutlinedBorder>(RoundedRectangleBorder()),
      mouseCursor: style?.mouseCursor,
      visualDensity: style?.visualDensity,
      tapTargetSize: style?.tapTargetSize,
      animationDuration: style?.animationDuration,
      enableFeedback: style?.enableFeedback,
      alignment: style?.alignment,
      splashFactory: style?.splashFactory,
    );

    final ButtonStyle segmentStyle = segmentStyleFor(widget.style);
    final ButtonStyle segmentThemeStyle = segmentStyleFor(theme.style).merge(segmentStyleFor(defaults.style));
    final Widget? selectedIcon =
        widget.showSelectedIcon ? widget.selectedIcon ?? theme.selectedIcon ?? defaults.selectedIcon : null;

    Widget buttonFor(ButtonSegment<T> segment) {
      final Widget label = segment.label ?? segment.icon ?? const SizedBox.shrink();
      final bool segmentSelected = widget.selected.contains(segment.value);
      final Widget? icon =
          (segmentSelected && widget.showSelectedIcon)
              ? selectedIcon
              : segment.label != null
              ? segment.icon
              : null;
      final WidgetStatesController controller = statesControllers.putIfAbsent(segment, WidgetStatesController.new);
      controller.update(WidgetState.selected, segmentSelected);

      final Widget button =
          icon != null
              ? TextButton.icon(
                style: segmentStyle,
                statesController: controller,
                onPressed: (_enabled && segment.enabled) ? () => _handleOnPressed(segment.value) : null,
                icon: icon,
                label: label,
              )
              : TextButton(
                style: segmentStyle,
                statesController: controller,
                onPressed: (_enabled && segment.enabled) ? () => _handleOnPressed(segment.value) : null,
                child: label,
              );

      final Widget buttonWithTooltip =
          segment.tooltip != null ? Tooltip(message: segment.tooltip, child: button) : button;

      return MergeSemantics(
        child: Semantics(
          checked: segmentSelected,
          inMutuallyExclusiveGroup: widget.multiSelectionEnabled ? null : true,
          child: buttonWithTooltip,
        ),
      );
    }

    final OutlinedBorder resolvedEnabledBorder =
        resolve<OutlinedBorder?>((style) => style?.shape, disabledState) ?? const RoundedRectangleBorder();
    final OutlinedBorder resolvedDisabledBorder =
        resolve<OutlinedBorder?>((style) => style?.shape, disabledState) ?? const RoundedRectangleBorder();
    final BorderSide enabledSide = resolve<BorderSide?>((style) => style?.side, enabledState) ?? BorderSide.none;
    final BorderSide disabledSide = resolve<BorderSide?>((style) => style?.side, disabledState) ?? BorderSide.none;
    final OutlinedBorder enabledBorder = resolvedEnabledBorder.copyWith(side: enabledSide);
    final OutlinedBorder disabledBorder = resolvedDisabledBorder.copyWith(side: disabledSide);
    final VisualDensity resolvedVisualDensity =
        segmentStyle.visualDensity ?? segmentThemeStyle.visualDensity ?? Theme.of(context).visualDensity;
    final EdgeInsetsGeometry resolvedPadding =
        resolve<EdgeInsetsGeometry?>((style) => style?.padding, enabledState) ?? EdgeInsets.zero;
    final MaterialTapTargetSize resolvedTapTargetSize =
        segmentStyle.tapTargetSize ?? segmentThemeStyle.tapTargetSize ?? Theme.of(context).materialTapTargetSize;
    final double fontSize = resolve<TextStyle?>((style) => style?.textStyle, enabledState)?.fontSize ?? 20.0;

    final List<Widget> buttons = widget.segments.map(buttonFor).toList();

    final Offset densityAdjustment = resolvedVisualDensity.baseSizeAdjustment;
    const double textButtonMinHeight = 40.0;

    final double adjustButtonMinHeight = textButtonMinHeight + densityAdjustment.dy;
    final double effectiveVerticalPadding = resolvedPadding.vertical + densityAdjustment.dy * 2;
    final double effectedButtonHeight = max(fontSize + effectiveVerticalPadding, adjustButtonMinHeight);
    final double tapTargetVerticalPadding = switch (resolvedTapTargetSize) {
      MaterialTapTargetSize.shrinkWrap => 0.0,
      MaterialTapTargetSize.padded => max(0, kMinInteractiveDimension + densityAdjustment.dy - effectedButtonHeight),
    };

    return Material(
      type: MaterialType.transparency,
      elevation: resolve<double?>((style) => style?.elevation)!,
      shadowColor: resolve<Color?>((style) => style?.shadowColor),
      surfaceTintColor: resolve<Color?>((style) => style?.surfaceTintColor),
      child: TextButtonTheme(
        data: TextButtonThemeData(style: segmentThemeStyle),
        child: Padding(
          padding: widget.expandedInsets ?? EdgeInsets.zero,
          child: _SegmentedButtonRenderWidget<T>(
            tapTargetVerticalPadding: tapTargetVerticalPadding,
            segments: widget.segments,
            enabledBorder: _enabled ? enabledBorder : disabledBorder,
            disabledBorder: disabledBorder,
            direction: widget.direction,
            textDirection: textDirection,
            isExpanded: widget.expandedInsets != null,
            children: buttons,
          ),
        ),
      ),
    );
  }

  @protected
  @override
  void dispose() {
    for (final WidgetStatesController controller in statesControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<Map<ButtonSegment<T>, WidgetStatesController>>('statesControllers', statesControllers),
    );
  }
}

class _SegmentedButtonRenderWidget<T> extends MultiChildRenderObjectWidget {
  const _SegmentedButtonRenderWidget({
    required this.segments,
    required this.enabledBorder,
    required this.disabledBorder,
    required this.direction,
    required this.textDirection,
    required this.tapTargetVerticalPadding,
    required this.isExpanded,
    required super.children,
    super.key,
  }) : assert(children.length == segments.length);

  final List<ButtonSegment<T>> segments;
  final OutlinedBorder enabledBorder;
  final OutlinedBorder disabledBorder;
  final Axis direction;
  final TextDirection textDirection;
  final double tapTargetVerticalPadding;
  final bool isExpanded;

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderSegmentedButton<T>(
    segments: segments,
    enabledBorder: enabledBorder,
    disabledBorder: disabledBorder,
    textDirection: textDirection,
    direction: direction,
    tapTargetVerticalPadding: tapTargetVerticalPadding,
    isExpanded: isExpanded,
  );

  @override
  void updateRenderObject(BuildContext context, _RenderSegmentedButton<T> renderObject) {
    renderObject
      ..segments = segments
      ..enabledBorder = enabledBorder
      ..disabledBorder = disabledBorder
      ..direction = direction
      ..textDirection = textDirection;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<ButtonSegment<T>>('segments', segments));
    properties.add(DiagnosticsProperty<OutlinedBorder>('enabledBorder', enabledBorder));
    properties.add(DiagnosticsProperty<OutlinedBorder>('disabledBorder', disabledBorder));
    properties.add(EnumProperty<Axis>('direction', direction));
    properties.add(EnumProperty<TextDirection>('textDirection', textDirection));
    properties.add(DoubleProperty('tapTargetVerticalPadding', tapTargetVerticalPadding));
    properties.add(DiagnosticsProperty<bool>('isExpanded', isExpanded));
  }
}

class _SegmentedButtonContainerBoxParentData extends ContainerBoxParentData<RenderBox> {
  RRect? surroundingRect;
}

class _RenderSegmentedButton<T> extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, ContainerBoxParentData<RenderBox>>,
        RenderBoxContainerDefaultsMixin<RenderBox, ContainerBoxParentData<RenderBox>> {
  _RenderSegmentedButton({
    required List<ButtonSegment<T>> segments,
    required OutlinedBorder enabledBorder,
    required OutlinedBorder disabledBorder,
    required TextDirection textDirection,
    required double tapTargetVerticalPadding,
    required bool isExpanded,
    required Axis direction,
  }) : _segments = segments,
       _enabledBorder = enabledBorder,
       _disabledBorder = disabledBorder,
       _textDirection = textDirection,
       _direction = direction,
       _tapTargetVerticalPadding = tapTargetVerticalPadding,
       _isExpanded = isExpanded;

  List<ButtonSegment<T>> get segments => _segments;
  List<ButtonSegment<T>> _segments;
  set segments(List<ButtonSegment<T>> value) {
    if (listEquals(segments, value)) {
      return;
    }
    _segments = value;
    markNeedsLayout();
  }

  OutlinedBorder get enabledBorder => _enabledBorder;
  OutlinedBorder _enabledBorder;
  set enabledBorder(OutlinedBorder value) {
    if (_enabledBorder == value) {
      return;
    }
    _enabledBorder = value;
    markNeedsLayout();
  }

  OutlinedBorder get disabledBorder => _disabledBorder;
  OutlinedBorder _disabledBorder;
  set disabledBorder(OutlinedBorder value) {
    if (_disabledBorder == value) {
      return;
    }
    _disabledBorder = value;
    markNeedsLayout();
  }

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;
  set textDirection(TextDirection value) {
    if (value == _textDirection) {
      return;
    }
    _textDirection = value;
    markNeedsLayout();
  }

  Axis get direction => _direction;
  Axis _direction;
  set direction(Axis value) {
    if (value == _direction) {
      return;
    }
    _direction = value;
    markNeedsLayout();
  }

  double get tapTargetVerticalPadding => _tapTargetVerticalPadding;
  double _tapTargetVerticalPadding;
  set tapTargetVerticalPadding(double value) {
    if (value == _tapTargetVerticalPadding) {
      return;
    }
    _tapTargetVerticalPadding = value;
    markNeedsLayout();
  }

  bool get isExpanded => _isExpanded;
  bool _isExpanded;
  set isExpanded(bool value) {
    if (value == _isExpanded) {
      return;
    }
    _isExpanded = value;
    markNeedsLayout();
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    RenderBox? child = firstChild;
    double minWidth = 0.0;
    while (child != null) {
      final _SegmentedButtonContainerBoxParentData childParentData =
          child.parentData! as _SegmentedButtonContainerBoxParentData;
      final double childWidth = child.getMinIntrinsicWidth(height);
      minWidth = math.max(minWidth, childWidth);
      child = childParentData.nextSibling;
    }
    return minWidth * childCount;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    RenderBox? child = firstChild;
    double maxWidth = 0.0;
    while (child != null) {
      final _SegmentedButtonContainerBoxParentData childParentData =
          child.parentData! as _SegmentedButtonContainerBoxParentData;
      final double childWidth = child.getMaxIntrinsicWidth(height);
      maxWidth = math.max(maxWidth, childWidth);
      child = childParentData.nextSibling;
    }
    return maxWidth * childCount;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    RenderBox? child = firstChild;
    double minHeight = 0.0;
    while (child != null) {
      final _SegmentedButtonContainerBoxParentData childParentData =
          child.parentData! as _SegmentedButtonContainerBoxParentData;
      final double childHeight = child.getMinIntrinsicHeight(width);
      minHeight = math.max(minHeight, childHeight);
      child = childParentData.nextSibling;
    }
    return minHeight;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    RenderBox? child = firstChild;
    double maxHeight = 0.0;
    while (child != null) {
      final _SegmentedButtonContainerBoxParentData childParentData =
          child.parentData! as _SegmentedButtonContainerBoxParentData;
      final double childHeight = child.getMaxIntrinsicHeight(width);
      maxHeight = math.max(maxHeight, childHeight);
      child = childParentData.nextSibling;
    }
    return maxHeight;
  }

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) =>
      defaultComputeDistanceToHighestActualBaseline(baseline);

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _SegmentedButtonContainerBoxParentData) {
      child.parentData = _SegmentedButtonContainerBoxParentData();
    }
  }

  void _layoutRects(RenderBox? Function(RenderBox) nextChild, RenderBox? leftChild, RenderBox? rightChild) {
    RenderBox? child = leftChild;
    double start = 0.0;
    while (child != null) {
      final _SegmentedButtonContainerBoxParentData childParentData =
          child.parentData! as _SegmentedButtonContainerBoxParentData;
      late final RRect rChildRect;
      if (direction == Axis.vertical) {
        childParentData.offset = Offset(0.0, start);
        final Rect childRect = Rect.fromLTWH(0.0, childParentData.offset.dy, child.size.width, child.size.height);
        rChildRect = RRect.fromRectAndCorners(childRect);
        start += child.size.height;
      } else {
        childParentData.offset = Offset(start, 0.0);
        final Rect childRect = Rect.fromLTWH(start, 0.0, child.size.width, child.size.height);
        rChildRect = RRect.fromRectAndCorners(childRect);
        start += child.size.width;
      }
      childParentData.surroundingRect = rChildRect;
      child = nextChild(child);
    }
  }

  Size _calculateChildSize(BoxConstraints constraints) =>
      direction == Axis.horizontal
          ? _calculateHorizontalChildSize(constraints)
          : _calculateVerticalChildSize(constraints);

  Size _calculateHorizontalChildSize(BoxConstraints constraints) {
    double maxHeight = 0;
    RenderBox? child = firstChild;
    double childWidth;
    if (_isExpanded) {
      childWidth = constraints.maxWidth / childCount;
    } else {
      childWidth = constraints.minWidth / childCount;
      while (child != null) {
        childWidth = math.max(childWidth, child.getMaxIntrinsicWidth(double.infinity));
        child = childAfter(child);
      }
      childWidth = math.min(childWidth, constraints.maxWidth / childCount);
    }
    child = firstChild;
    while (child != null) {
      final double boxHeight = child.getMaxIntrinsicHeight(childWidth);
      maxHeight = math.max(maxHeight, boxHeight);
      child = childAfter(child);
    }
    return Size(childWidth, maxHeight);
  }

  Size _calculateVerticalChildSize(BoxConstraints constraints) {
    double maxWidth = 0;
    RenderBox? child = firstChild;
    double childHeight;
    if (_isExpanded) {
      childHeight = constraints.maxHeight / childCount;
    } else {
      childHeight = constraints.minHeight / childCount;
      while (child != null) {
        childHeight = math.max(childHeight, child.getMaxIntrinsicHeight(double.infinity));
        child = childAfter(child);
      }
      childHeight = math.min(childHeight, constraints.maxHeight / childCount);
    }
    child = firstChild;
    while (child != null) {
      final double boxWidth = child.getMaxIntrinsicWidth(maxWidth);
      maxWidth = math.max(maxWidth, boxWidth);
      child = childAfter(child);
    }
    return Size(maxWidth, childHeight);
  }

  Size _computeOverallSizeFromChildSize(Size childSize) {
    if (direction == Axis.vertical) {
      return constraints.constrain(Size(childSize.width, childSize.height * childCount));
    }
    return constraints.constrain(Size(childSize.width * childCount, childSize.height));
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final Size childSize = _calculateChildSize(constraints);
    return _computeOverallSizeFromChildSize(childSize);
  }

  @override
  double? computeDryBaseline(covariant BoxConstraints constraints, TextBaseline baseline) {
    final Size childSize = _calculateChildSize(constraints);
    final BoxConstraints childConstraints = BoxConstraints.tight(childSize);

    BaselineOffset baselineOffset = BaselineOffset.noBaseline;
    for (RenderBox? child = firstChild; child != null; child = childAfter(child)) {
      baselineOffset = baselineOffset.minOf(BaselineOffset(child.getDryBaseline(childConstraints, baseline)));
    }
    return baselineOffset.offset;
  }

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    final Size childSize = _calculateChildSize(constraints);

    final BoxConstraints childConstraints = BoxConstraints.tightFor(width: childSize.width, height: childSize.height);

    RenderBox? child = firstChild;
    while (child != null) {
      child.layout(childConstraints, parentUsesSize: true);
      child = childAfter(child);
    }

    switch (textDirection) {
      case TextDirection.rtl:
        _layoutRects(childBefore, lastChild, firstChild);
      case TextDirection.ltr:
        _layoutRects(childAfter, firstChild, lastChild);
    }

    size = _computeOverallSizeFromChildSize(childSize);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Rect borderRect =
        (offset + Offset(0, tapTargetVerticalPadding / 2)) & (Size(size.width, size.height - tapTargetVerticalPadding));
    final Path borderClipPath = enabledBorder.getInnerPath(borderRect, textDirection: textDirection);
    RenderBox? child = firstChild;
    RenderBox? previousChild;
    int index = 0;
    Path? enabledClipPath;
    Path? disabledClipPath;

    while (child != null) {
      final _SegmentedButtonContainerBoxParentData childParentData =
          child.parentData! as _SegmentedButtonContainerBoxParentData;
      final Rect childRect = childParentData.surroundingRect!.outerRect.shift(offset);

      context.canvas
        ..save()
        ..clipPath(borderClipPath);
      context.paintChild(child, childParentData.offset + offset);
      context.canvas.restore();

      // Compute a clip rect for the outer border of the child.
      final double segmentLeft;
      final double segmentRight;
      final double dividerPos;
      final double borderOutset = math.max(enabledBorder.side.strokeOutset, disabledBorder.side.strokeOutset);
      switch (textDirection) {
        case TextDirection.rtl:
          segmentLeft = child == lastChild ? borderRect.left - borderOutset : childRect.left;
          segmentRight = child == firstChild ? borderRect.right + borderOutset : childRect.right;
          dividerPos = segmentRight;
        case TextDirection.ltr:
          segmentLeft = child == firstChild ? borderRect.left - borderOutset : childRect.left;
          segmentRight = child == lastChild ? borderRect.right + borderOutset : childRect.right;
          dividerPos = segmentLeft;
      }
      final Rect segmentClipRect = Rect.fromLTRB(
        segmentLeft,
        borderRect.top - borderOutset,
        segmentRight,
        borderRect.bottom + borderOutset,
      );

      // Add the clip rect to the appropriate border clip path
      if (segments[index].enabled) {
        enabledClipPath = (enabledClipPath ?? Path())..addRect(segmentClipRect);
      } else {
        disabledClipPath = (disabledClipPath ?? Path())..addRect(segmentClipRect);
      }

      // Paint the divider between this segment and the previous one.
      if (previousChild != null) {
        final BorderSide divider =
            segments[index - 1].enabled || segments[index].enabled
                ? enabledBorder.side.copyWith(strokeAlign: 0.0)
                : disabledBorder.side.copyWith(strokeAlign: 0.0);
        if (direction == Axis.horizontal) {
          final Offset top = Offset(dividerPos, borderRect.top);
          final Offset bottom = Offset(dividerPos, borderRect.bottom);
          context.canvas.drawLine(top, bottom, divider.toPaint());
        } else if (direction == Axis.vertical) {
          final Offset start = Offset(borderRect.left, childRect.top);
          final Offset end = Offset(borderRect.right, childRect.top);
          context.canvas
            ..save()
            ..clipPath(borderClipPath);
          context.canvas.drawLine(start, end, divider.toPaint());
          context.canvas.restore();
        }
      }

      previousChild = child;
      child = childAfter(child);
      index += 1;
    }

    // Paint the outer border for both disabled and enabled clip rect if needed.
    if (disabledClipPath == null) {
      // Just paint the enabled border with no clip.
      enabledBorder.paint(context.canvas, borderRect, textDirection: textDirection);
    } else if (enabledClipPath == null) {
      // Just paint the disabled border with no.
      disabledBorder.paint(context.canvas, borderRect, textDirection: textDirection);
    } else {
      // Paint both of them clipped appropriately for the children segments.
      context.canvas
        ..save()
        ..clipPath(enabledClipPath);
      enabledBorder.paint(context.canvas, borderRect, textDirection: textDirection);
      context.canvas
        ..restore()
        ..save()
        ..clipPath(disabledClipPath);
      disabledBorder.paint(context.canvas, borderRect, textDirection: textDirection);
      context.canvas.restore();
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    RenderBox? child = lastChild;
    while (child != null) {
      final _SegmentedButtonContainerBoxParentData childParentData =
          child.parentData! as _SegmentedButtonContainerBoxParentData;
      if (childParentData.surroundingRect!.contains(position)) {
        return result.addWithPaintOffset(
          offset: childParentData.offset,
          position: position,
          hitTest: (result, localOffset) {
            assert(localOffset == position - childParentData.offset);
            return child!.hitTest(result, position: localOffset);
          },
        );
      }
      child = childParentData.previousSibling;
    }
    return false;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<ButtonSegment<T>>('segments', segments));
    properties.add(DiagnosticsProperty<OutlinedBorder>('enabledBorder', enabledBorder));
    properties.add(DiagnosticsProperty<OutlinedBorder>('disabledBorder', disabledBorder));
    properties.add(EnumProperty<TextDirection>('textDirection', textDirection));
    properties.add(EnumProperty<Axis>('direction', direction));
    properties.add(DoubleProperty('tapTargetVerticalPadding', tapTargetVerticalPadding));
    properties.add(DiagnosticsProperty<bool>('isExpanded', isExpanded));
  }
}

// BEGIN GENERATED TOKEN PROPERTIES - SegmentedButton

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// dart format off
class _SegmentedButtonDefaultsM3 extends SegmentedButtonThemeData {
  _SegmentedButtonDefaultsM3(this.context);
  final BuildContext context;
  late final ThemeData _theme = Theme.of(context);
  late final ColorScheme _colors = _theme.colorScheme;
  @override ButtonStyle? get style => ButtonStyle(
      textStyle: WidgetStatePropertyAll<TextStyle?>(Theme.of(context).textTheme.labelLarge),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return null;
        }
        if (states.contains(WidgetState.selected)) {
          return _colors.secondaryContainer;
        }
        return null;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return _colors.onSurface.withOpacity(0.38);
        }
        if (states.contains(WidgetState.selected)) {
          if (states.contains(WidgetState.pressed)) {
            return _colors.onSecondaryContainer;
          }
          if (states.contains(WidgetState.hovered)) {
            return _colors.onSecondaryContainer;
          }
          if (states.contains(WidgetState.focused)) {
            return _colors.onSecondaryContainer;
          }
          return _colors.onSecondaryContainer;
        } else {
          if (states.contains(WidgetState.pressed)) {
            return _colors.onSurface;
          }
          if (states.contains(WidgetState.hovered)) {
            return _colors.onSurface;
          }
          if (states.contains(WidgetState.focused)) {
            return _colors.onSurface;
          }
          return _colors.onSurface;
        }
      }),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          if (states.contains(WidgetState.pressed)) {
            return _colors.onSecondaryContainer.withOpacity(0.1);
          }
          if (states.contains(WidgetState.hovered)) {
            return _colors.onSecondaryContainer.withOpacity(0.08);
          }
          if (states.contains(WidgetState.focused)) {
            return _colors.onSecondaryContainer.withOpacity(0.1);
          }
        } else {
          if (states.contains(WidgetState.pressed)) {
            return _colors.onSurface.withOpacity(0.1);
          }
          if (states.contains(WidgetState.hovered)) {
            return _colors.onSurface.withOpacity(0.08);
          }
          if (states.contains(WidgetState.focused)) {
            return _colors.onSurface.withOpacity(0.1);
          }
        }
        return null;
      }),
      surfaceTintColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
      elevation: const WidgetStatePropertyAll<double>(0),
      iconSize: const WidgetStatePropertyAll<double?>(18.0),
      side: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return BorderSide(color: _colors.onSurface.withOpacity(0.12));
        }
        return BorderSide(color: _colors.outline);
      }),
      shape: const WidgetStatePropertyAll<OutlinedBorder>(StadiumBorder()),
      minimumSize: const WidgetStatePropertyAll<Size?>(Size.fromHeight(40.0)),
    );
  @override
  Widget? get selectedIcon => const Icon(Icons.check);

  static WidgetStateProperty<Color?> resolveStateColor(
    Color? unselectedColor,
    Color? selectedColor,
    Color? overlayColor,
  ) {
    final Color? selected = overlayColor ?? selectedColor;
    final Color? unselected = overlayColor ?? unselectedColor;
    return WidgetStateProperty<Color?>.fromMap(
      <WidgetStatesConstraint, Color?>{
        WidgetState.selected & WidgetState.pressed: selected?.withOpacity(0.1),
        WidgetState.selected & WidgetState.hovered: selected?.withOpacity(0.08),
        WidgetState.selected & WidgetState.focused: selected?.withOpacity(0.1),
        WidgetState.pressed: unselected?.withOpacity(0.1),
        WidgetState.hovered: unselected?.withOpacity(0.08),
        WidgetState.focused: unselected?.withOpacity(0.1),
        WidgetState.any: Colors.transparent,
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BuildContext>('context', context));
  }
}
// dart format on

// END GENERATED TOKEN PROPERTIES - SegmentedButton
