// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/button.dart';
import 'package:waveui/material/color_scheme.dart';
import 'package:waveui/material/floating_action_button_theme.dart';
import 'package:waveui/src/theme/text_theme.dart';
import 'package:waveui/material/theme.dart';
import 'package:waveui/material/theme_data.dart';
import 'package:waveui/material/tooltip.dart';

class _DefaultHeroTag {
  const _DefaultHeroTag();
  @override
  String toString() => '<default FloatingActionButton tag>';
}

enum _FloatingActionButtonType { regular, small, large, extended }

class FloatingActionButton extends StatelessWidget {
  const FloatingActionButton({
    required this.onPressed,
    super.key,
    this.child,
    this.tooltip,
    this.foregroundColor,
    this.backgroundColor,
    this.focusColor,
    this.hoverColor,
    this.splashColor,
    this.heroTag = const _DefaultHeroTag(),
    this.elevation,
    this.focusElevation,
    this.hoverElevation,
    this.highlightElevation,
    this.disabledElevation,
    this.mouseCursor,
    this.mini = false,
    this.shape,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.autofocus = false,
    this.materialTapTargetSize,
    this.isExtended = false,
    this.enableFeedback,
  }) : assert(elevation == null || elevation >= 0.0),
       assert(focusElevation == null || focusElevation >= 0.0),
       assert(hoverElevation == null || hoverElevation >= 0.0),
       assert(highlightElevation == null || highlightElevation >= 0.0),
       assert(disabledElevation == null || disabledElevation >= 0.0),
       _floatingActionButtonType = mini ? _FloatingActionButtonType.small : _FloatingActionButtonType.regular,
       _extendedLabel = null,
       extendedIconLabelSpacing = null,
       extendedPadding = null,
       extendedTextStyle = null;

  const FloatingActionButton.small({
    required this.onPressed,
    super.key,
    this.child,
    this.tooltip,
    this.foregroundColor,
    this.backgroundColor,
    this.focusColor,
    this.hoverColor,
    this.splashColor,
    this.heroTag = const _DefaultHeroTag(),
    this.elevation,
    this.focusElevation,
    this.hoverElevation,
    this.highlightElevation,
    this.disabledElevation,
    this.mouseCursor,
    this.shape,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.autofocus = false,
    this.materialTapTargetSize,
    this.enableFeedback,
  }) : assert(elevation == null || elevation >= 0.0),
       assert(focusElevation == null || focusElevation >= 0.0),
       assert(hoverElevation == null || hoverElevation >= 0.0),
       assert(highlightElevation == null || highlightElevation >= 0.0),
       assert(disabledElevation == null || disabledElevation >= 0.0),
       _floatingActionButtonType = _FloatingActionButtonType.small,
       mini = true,
       isExtended = false,
       _extendedLabel = null,
       extendedIconLabelSpacing = null,
       extendedPadding = null,
       extendedTextStyle = null;

  const FloatingActionButton.large({
    required this.onPressed,
    super.key,
    this.child,
    this.tooltip,
    this.foregroundColor,
    this.backgroundColor,
    this.focusColor,
    this.hoverColor,
    this.splashColor,
    this.heroTag = const _DefaultHeroTag(),
    this.elevation,
    this.focusElevation,
    this.hoverElevation,
    this.highlightElevation,
    this.disabledElevation,
    this.mouseCursor,
    this.shape,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.autofocus = false,
    this.materialTapTargetSize,
    this.enableFeedback,
  }) : assert(elevation == null || elevation >= 0.0),
       assert(focusElevation == null || focusElevation >= 0.0),
       assert(hoverElevation == null || hoverElevation >= 0.0),
       assert(highlightElevation == null || highlightElevation >= 0.0),
       assert(disabledElevation == null || disabledElevation >= 0.0),
       _floatingActionButtonType = _FloatingActionButtonType.large,
       mini = false,
       isExtended = false,
       _extendedLabel = null,
       extendedIconLabelSpacing = null,
       extendedPadding = null,
       extendedTextStyle = null;

  const FloatingActionButton.extended({
    required this.onPressed,
    required Widget label,
    super.key,
    this.tooltip,
    this.foregroundColor,
    this.backgroundColor,
    this.focusColor,
    this.hoverColor,
    this.heroTag = const _DefaultHeroTag(),
    this.elevation,
    this.focusElevation,
    this.hoverElevation,
    this.splashColor,
    this.highlightElevation,
    this.disabledElevation,
    this.mouseCursor = SystemMouseCursors.click,
    this.shape,
    this.isExtended = true,
    this.materialTapTargetSize,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.autofocus = false,
    this.extendedIconLabelSpacing,
    this.extendedPadding,
    this.extendedTextStyle,
    Widget? icon,
    this.enableFeedback,
  }) : assert(elevation == null || elevation >= 0.0),
       assert(focusElevation == null || focusElevation >= 0.0),
       assert(hoverElevation == null || hoverElevation >= 0.0),
       assert(highlightElevation == null || highlightElevation >= 0.0),
       assert(disabledElevation == null || disabledElevation >= 0.0),
       mini = false,
       _floatingActionButtonType = _FloatingActionButtonType.extended,
       child = icon,
       _extendedLabel = label;

  final Widget? child;

  final String? tooltip;

  final Color? foregroundColor;

  final Color? backgroundColor;

  final Color? focusColor;

  final Color? hoverColor;

  final Color? splashColor;

  final Object? heroTag;

  final VoidCallback? onPressed;

  final MouseCursor? mouseCursor;

  final double? elevation;

  final double? focusElevation;

  final double? hoverElevation;

  final double? highlightElevation;

  final double? disabledElevation;

  final bool mini;

  final ShapeBorder? shape;

  final Clip clipBehavior;

  final bool isExtended;

  final FocusNode? focusNode;

  final bool autofocus;

  final MaterialTapTargetSize? materialTapTargetSize;

  final bool? enableFeedback;

  final double? extendedIconLabelSpacing;

  final EdgeInsetsGeometry? extendedPadding;

  final TextStyle? extendedTextStyle;

  final _FloatingActionButtonType _floatingActionButtonType;

  final Widget? _extendedLabel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final FloatingActionButtonThemeData floatingActionButtonTheme = theme.floatingActionButtonTheme;
    final FloatingActionButtonThemeData defaults = _FABDefaultsM3(context, _floatingActionButtonType, child != null);

    final Color foregroundColor =
        this.foregroundColor ?? floatingActionButtonTheme.foregroundColor ?? defaults.foregroundColor!;
    final Color backgroundColor =
        this.backgroundColor ?? floatingActionButtonTheme.backgroundColor ?? defaults.backgroundColor!;
    final Color focusColor = this.focusColor ?? floatingActionButtonTheme.focusColor ?? defaults.focusColor!;
    final Color hoverColor = this.hoverColor ?? floatingActionButtonTheme.hoverColor ?? defaults.hoverColor!;
    final Color splashColor = this.splashColor ?? floatingActionButtonTheme.splashColor ?? defaults.splashColor!;
    final double elevation = this.elevation ?? floatingActionButtonTheme.elevation ?? defaults.elevation!;
    final double focusElevation =
        this.focusElevation ?? floatingActionButtonTheme.focusElevation ?? defaults.focusElevation!;
    final double hoverElevation =
        this.hoverElevation ?? floatingActionButtonTheme.hoverElevation ?? defaults.hoverElevation!;
    final double disabledElevation =
        this.disabledElevation ??
        floatingActionButtonTheme.disabledElevation ??
        defaults.disabledElevation ??
        elevation;
    final double highlightElevation =
        this.highlightElevation ?? floatingActionButtonTheme.highlightElevation ?? defaults.highlightElevation!;
    final MaterialTapTargetSize materialTapTargetSize = this.materialTapTargetSize ?? theme.materialTapTargetSize;
    final bool enableFeedback =
        this.enableFeedback ?? floatingActionButtonTheme.enableFeedback ?? defaults.enableFeedback!;
    final double iconSize = floatingActionButtonTheme.iconSize ?? defaults.iconSize!;
    final TextStyle extendedTextStyle = (this.extendedTextStyle ??
            floatingActionButtonTheme.extendedTextStyle ??
            defaults.extendedTextStyle!)
        .copyWith(color: foregroundColor);
    final ShapeBorder shape = this.shape ?? floatingActionButtonTheme.shape ?? defaults.shape!;

    BoxConstraints sizeConstraints;
    Widget? resolvedChild = child != null ? IconTheme.merge(data: IconThemeData(size: iconSize), child: child!) : child;
    switch (_floatingActionButtonType) {
      case _FloatingActionButtonType.regular:
        sizeConstraints = floatingActionButtonTheme.sizeConstraints ?? defaults.sizeConstraints!;
      case _FloatingActionButtonType.small:
        sizeConstraints = floatingActionButtonTheme.smallSizeConstraints ?? defaults.smallSizeConstraints!;
      case _FloatingActionButtonType.large:
        sizeConstraints = floatingActionButtonTheme.largeSizeConstraints ?? defaults.largeSizeConstraints!;
      case _FloatingActionButtonType.extended:
        sizeConstraints = floatingActionButtonTheme.extendedSizeConstraints ?? defaults.extendedSizeConstraints!;
        final double iconLabelSpacing =
            extendedIconLabelSpacing ?? floatingActionButtonTheme.extendedIconLabelSpacing ?? 8.0;
        final EdgeInsetsGeometry padding =
            extendedPadding ?? floatingActionButtonTheme.extendedPadding ?? defaults.extendedPadding!;
        resolvedChild = _ChildOverflowBox(
          child: Padding(
            padding: padding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (child != null) child!,
                if (child != null && isExtended) SizedBox(width: iconLabelSpacing),
                if (isExtended) _extendedLabel!,
              ],
            ),
          ),
        );
    }

    Widget result = RawMaterialButton(
      onPressed: onPressed,
      mouseCursor: _EffectiveMouseCursor(mouseCursor, floatingActionButtonTheme.mouseCursor),
      elevation: elevation,
      focusElevation: focusElevation,
      hoverElevation: hoverElevation,
      highlightElevation: highlightElevation,
      disabledElevation: disabledElevation,
      constraints: sizeConstraints,
      materialTapTargetSize: materialTapTargetSize,
      fillColor: backgroundColor,
      focusColor: focusColor,
      hoverColor: hoverColor,
      splashColor: splashColor,
      textStyle: extendedTextStyle,
      shape: shape,
      clipBehavior: clipBehavior,
      focusNode: focusNode,
      autofocus: autofocus,
      enableFeedback: enableFeedback,
      child: resolvedChild,
    );

    if (tooltip != null) {
      result = Tooltip(message: tooltip, child: result);
    }

    if (heroTag != null) {
      result = Hero(tag: heroTag!, child: result);
    }

    return MergeSemantics(child: result);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<VoidCallback>('onPressed', onPressed, ifNull: 'disabled'));
    properties.add(StringProperty('tooltip', tooltip, defaultValue: null));
    properties.add(ColorProperty('foregroundColor', foregroundColor, defaultValue: null));
    properties.add(ColorProperty('backgroundColor', backgroundColor, defaultValue: null));
    properties.add(ColorProperty('focusColor', focusColor, defaultValue: null));
    properties.add(ColorProperty('hoverColor', hoverColor, defaultValue: null));
    properties.add(ColorProperty('splashColor', splashColor, defaultValue: null));
    properties.add(ObjectFlagProperty<Object>('heroTag', heroTag, ifPresent: 'hero'));
    properties.add(DoubleProperty('elevation', elevation, defaultValue: null));
    properties.add(DoubleProperty('focusElevation', focusElevation, defaultValue: null));
    properties.add(DoubleProperty('hoverElevation', hoverElevation, defaultValue: null));
    properties.add(DoubleProperty('highlightElevation', highlightElevation, defaultValue: null));
    properties.add(DoubleProperty('disabledElevation', disabledElevation, defaultValue: null));
    properties.add(DiagnosticsProperty<ShapeBorder>('shape', shape, defaultValue: null));
    properties.add(DiagnosticsProperty<FocusNode>('focusNode', focusNode, defaultValue: null));
    properties.add(FlagProperty('isExtended', value: isExtended, ifTrue: 'extended'));
    properties.add(
      DiagnosticsProperty<MaterialTapTargetSize>('materialTapTargetSize', materialTapTargetSize, defaultValue: null),
    );
    properties.add(DiagnosticsProperty<MouseCursor?>('mouseCursor', mouseCursor));
    properties.add(DiagnosticsProperty<bool>('mini', mini));
    properties.add(EnumProperty<Clip>('clipBehavior', clipBehavior));
    properties.add(DiagnosticsProperty<bool>('autofocus', autofocus));
    properties.add(DiagnosticsProperty<bool?>('enableFeedback', enableFeedback));
    properties.add(DoubleProperty('extendedIconLabelSpacing', extendedIconLabelSpacing));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('extendedPadding', extendedPadding));
    properties.add(DiagnosticsProperty<TextStyle?>('extendedTextStyle', extendedTextStyle));
  }
}

// This WidgetStateProperty is passed along to RawMaterialButton which
// resolves the property against WidgetState.pressed, WidgetState.hovered,
// WidgetState.focused, WidgetState.disabled.
class _EffectiveMouseCursor extends WidgetStateMouseCursor {
  const _EffectiveMouseCursor(this.widgetCursor, this.themeCursor);

  final MouseCursor? widgetCursor;
  final WidgetStateProperty<MouseCursor?>? themeCursor;

  @override
  MouseCursor resolve(Set<WidgetState> states) =>
      WidgetStateProperty.resolveAs<MouseCursor?>(widgetCursor, states) ??
      themeCursor?.resolve(states) ??
      WidgetStateMouseCursor.clickable.resolve(states);

  @override
  String get debugDescription => 'WidgetStateMouseCursor(FloatActionButton)';

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<MouseCursor?>('widgetCursor', widgetCursor));
    properties.add(DiagnosticsProperty<WidgetStateProperty<MouseCursor?>?>('themeCursor', themeCursor));
  }
}

// This widget's size matches its child's size unless its constraints
// force it to be larger or smaller. The child is centered.
//
// Used to encapsulate extended FABs whose size is fixed, using Row
// and MainAxisSize.min, to be as wide as their label and icon.
class _ChildOverflowBox extends SingleChildRenderObjectWidget {
  const _ChildOverflowBox({super.child});

  @override
  _RenderChildOverflowBox createRenderObject(BuildContext context) =>
      _RenderChildOverflowBox(textDirection: Directionality.of(context));

  @override
  void updateRenderObject(BuildContext context, _RenderChildOverflowBox renderObject) {
    renderObject.textDirection = Directionality.of(context);
  }
}

class _RenderChildOverflowBox extends RenderAligningShiftedBox {
  _RenderChildOverflowBox({super.textDirection}) : super(alignment: Alignment.center);

  @override
  double computeMinIntrinsicWidth(double height) => 0.0;

  @override
  double computeMinIntrinsicHeight(double width) => 0.0;

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    if (child != null) {
      final Size childSize = child!.getDryLayout(const BoxConstraints());
      return Size(
        math.max(constraints.minWidth, math.min(constraints.maxWidth, childSize.width)),
        math.max(constraints.minHeight, math.min(constraints.maxHeight, childSize.height)),
      );
    } else {
      return constraints.biggest;
    }
  }

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    if (child != null) {
      child!.layout(const BoxConstraints(), parentUsesSize: true);
      size = Size(
        math.max(constraints.minWidth, math.min(constraints.maxWidth, child!.size.width)),
        math.max(constraints.minHeight, math.min(constraints.maxHeight, child!.size.height)),
      );
      alignChild();
    } else {
      size = constraints.biggest;
    }
  }
}

// BEGIN GENERATED TOKEN PROPERTIES - FAB

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// dart format off
class _FABDefaultsM3 extends FloatingActionButtonThemeData {
  _FABDefaultsM3(this.context, this.type, this.hasChild)
    : super(
        elevation: 6.0,
        focusElevation: 6.0,
        hoverElevation: 8.0,
        highlightElevation: 6.0,
        enableFeedback: true,
        sizeConstraints: const BoxConstraints.tightFor(
          width: 56.0,
          height: 56.0,
        ),
        smallSizeConstraints: const BoxConstraints.tightFor(
          width: 40.0,
          height: 40.0,
        ),
        largeSizeConstraints: const BoxConstraints.tightFor(
          width: 96.0,
          height: 96.0,
        ),
        extendedSizeConstraints: const BoxConstraints.tightFor(
          height: 56.0,
        ),
        extendedIconLabelSpacing: 8.0,
      );

  final BuildContext context;
  final _FloatingActionButtonType type;
  final bool hasChild;
  late final ColorScheme _colors = Theme.of(context).colorScheme;
  late final TextTheme _textTheme = Theme.of(context).textTheme;

  bool get _isExtended => type == _FloatingActionButtonType.extended;

  @override Color? get foregroundColor => _colors.onPrimaryContainer;
  @override Color? get backgroundColor => _colors.primaryContainer;
  @override Color? get splashColor => _colors.onPrimaryContainer.withValues(alpha:0.1);
  @override Color? get focusColor => _colors.onPrimaryContainer.withValues(alpha:0.1);
  @override Color? get hoverColor => _colors.onPrimaryContainer.withValues(alpha:0.08);

  @override
  ShapeBorder? get shape => switch (type) {
    _FloatingActionButtonType.regular  => const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
    _FloatingActionButtonType.small    => const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0))),
    _FloatingActionButtonType.large    => const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(28.0))),
    _FloatingActionButtonType.extended => const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
  };

  @override
  double? get iconSize => switch (type) {
    _FloatingActionButtonType.regular  => 24.0,
    _FloatingActionButtonType.small    => 24.0,
    _FloatingActionButtonType.large    => 36.0,
    _FloatingActionButtonType.extended => 24.0,
  };

  @override EdgeInsetsGeometry? get extendedPadding => EdgeInsetsDirectional.only(start: hasChild && _isExtended ? 16.0 : 20.0, end: 20.0);
  @override TextStyle? get extendedTextStyle => _textTheme.labelLarge;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BuildContext>('context', context));
    properties.add(EnumProperty<_FloatingActionButtonType>('type', type));
    properties.add(DiagnosticsProperty<bool>('hasChild', hasChild));
  }
}
// dart format on

// END GENERATED TOKEN PROPERTIES - FAB
