// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart' show DiagnosticsProperty, clampDouble;
import 'package:flutter/semantics.dart';

import 'package:flutter/widgets.dart';

import 'package:waveui/material/chip.dart';
import 'package:waveui/material/chip_theme.dart';
import 'package:waveui/material/color_scheme.dart';
import 'package:waveui/material/colors.dart';
import 'package:waveui/material/debug.dart';
import 'package:waveui/src/theme/text_theme.dart';
import 'package:waveui/material/theme.dart';
import 'package:waveui/material/theme_data.dart';

enum _ChipVariant { flat, elevated }

//

class ActionChip extends StatelessWidget implements ChipAttributes, TappableChipAttributes, DisabledChipAttributes {
  const ActionChip({
    required this.label,
    super.key,
    this.avatar,
    this.labelStyle,
    this.labelPadding,
    this.onPressed,
    this.pressElevation,
    this.tooltip,
    this.side,
    this.shape,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.autofocus = false,
    this.color,
    this.backgroundColor,
    this.disabledColor,
    this.padding,
    this.visualDensity,
    this.materialTapTargetSize,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.iconTheme,
    this.avatarBoxConstraints,
    this.chipAnimationStyle,
    this.mouseCursor,
  }) : assert(pressElevation == null || pressElevation >= 0.0),
       assert(elevation == null || elevation >= 0.0),
       _chipVariant = _ChipVariant.flat;

  const ActionChip.elevated({
    required this.label,
    super.key,
    this.avatar,
    this.labelStyle,
    this.labelPadding,
    this.onPressed,
    this.pressElevation,
    this.tooltip,
    this.side,
    this.shape,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.autofocus = false,
    this.color,
    this.backgroundColor,
    this.disabledColor,
    this.padding,
    this.visualDensity,
    this.materialTapTargetSize,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.iconTheme,
    this.avatarBoxConstraints,
    this.chipAnimationStyle,
    this.mouseCursor,
  }) : assert(pressElevation == null || pressElevation >= 0.0),
       assert(elevation == null || elevation >= 0.0),
       _chipVariant = _ChipVariant.elevated;

  @override
  final Widget? avatar;
  @override
  final Widget label;
  @override
  final TextStyle? labelStyle;
  @override
  final EdgeInsetsGeometry? labelPadding;
  @override
  final VoidCallback? onPressed;
  @override
  final double? pressElevation;
  @override
  final String? tooltip;
  @override
  final BorderSide? side;
  @override
  final OutlinedBorder? shape;
  @override
  final Clip clipBehavior;
  @override
  final FocusNode? focusNode;
  @override
  final bool autofocus;
  @override
  final WidgetStateProperty<Color?>? color;
  @override
  final Color? backgroundColor;
  @override
  final Color? disabledColor;
  @override
  final EdgeInsetsGeometry? padding;
  @override
  final VisualDensity? visualDensity;
  @override
  final MaterialTapTargetSize? materialTapTargetSize;
  @override
  final double? elevation;
  @override
  final Color? shadowColor;
  @override
  final Color? surfaceTintColor;
  @override
  final IconThemeData? iconTheme;
  @override
  final BoxConstraints? avatarBoxConstraints;
  @override
  final ChipAnimationStyle? chipAnimationStyle;
  @override
  final MouseCursor? mouseCursor;

  @override
  bool get isEnabled => onPressed != null;

  final _ChipVariant _chipVariant;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    final ChipThemeData defaults = _ActionChipDefaultsM3(context, isEnabled, _chipVariant);
    return RawChip(
      defaultProperties: defaults,
      avatar: avatar,
      label: label,
      onPressed: onPressed,
      pressElevation: pressElevation,
      tooltip: tooltip,
      labelStyle: labelStyle,
      color: color,
      backgroundColor: backgroundColor,
      side: side,
      shape: shape,
      clipBehavior: clipBehavior,
      focusNode: focusNode,
      autofocus: autofocus,
      disabledColor: disabledColor,
      padding: padding,
      visualDensity: visualDensity,
      isEnabled: isEnabled,
      labelPadding: labelPadding,
      materialTapTargetSize: materialTapTargetSize,
      elevation: elevation,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      iconTheme: iconTheme,
      avatarBoxConstraints: avatarBoxConstraints,
      chipAnimationStyle: chipAnimationStyle,
      mouseCursor: mouseCursor,
    );
  }
}

// BEGIN GENERATED TOKEN PROPERTIES - ActionChip

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// dart format off
class _ActionChipDefaultsM3 extends ChipThemeData {
  _ActionChipDefaultsM3(this.context, this.isEnabled, this._chipVariant)
    : super(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
        showCheckmark: true,
      );

  final BuildContext context;
  final bool isEnabled;
  final _ChipVariant _chipVariant;
  late final ColorScheme _colors = Theme.of(context).colorScheme;
  late final TextTheme _textTheme = Theme.of(context).textTheme;

  @override
  double? get elevation => _chipVariant == _ChipVariant.flat
    ? 0.0
    : isEnabled ? 1.0 : 0.0;

  @override
  double? get pressElevation => 1.0;

  @override
  TextStyle? get labelStyle => _textTheme.labelLarge?.copyWith(
    color: isEnabled
      ? _colors.onSurface
      : _colors.onSurface,
  );

  @override
  WidgetStateProperty<Color?>? get color =>
    WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return _chipVariant == _ChipVariant.flat
          ? null
          : _colors.onSurface.withValues(alpha:0.12);
      }
      return _chipVariant == _ChipVariant.flat
        ? null
        : _colors.surfaceContainerLow;
    });

  @override
  Color? get shadowColor => _chipVariant == _ChipVariant.flat
    ? Colors.transparent
    : _colors.shadow;

  @override
  Color? get surfaceTintColor => Colors.transparent;

  @override
  Color? get checkmarkColor => null;

  @override
  Color? get deleteIconColor => null;

  @override
  BorderSide? get side => _chipVariant == _ChipVariant.flat
    ? isEnabled
        ? BorderSide(color: _colors.outlineVariant)
        : BorderSide(color: _colors.onSurface.withValues(alpha:0.12))
    : const BorderSide(color: Colors.transparent);

  @override
  IconThemeData? get iconTheme => IconThemeData(
    color: isEnabled
      ? _colors.primary
      : _colors.onSurface,
    size: 18.0,
  );

  @override
  EdgeInsetsGeometry? get padding => const EdgeInsets.all(8.0);

  
  
  
  
  
  
  
  
  @override
  EdgeInsetsGeometry? get labelPadding {
    final double fontSize = labelStyle?.fontSize ?? 14.0;
    final double fontSizeRatio = MediaQuery.textScalerOf(context).scale(fontSize) / 14.0;
    return EdgeInsets.lerp(
      const EdgeInsets.symmetric(horizontal: 8.0),
      const EdgeInsets.symmetric(horizontal: 4.0),
      clampDouble(fontSizeRatio - 1.0, 0.0, 1.0),
    )!;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty<BuildContext>('context', context))
    ..add(DiagnosticsProperty<bool>('isEnabled', isEnabled));
  }


}
// dart format on

// END GENERATED TOKEN PROPERTIES - ActionChip
