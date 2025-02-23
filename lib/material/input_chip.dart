// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart' show clampDouble;
import 'package:flutter/rendering.dart';

import 'package:flutter/widgets.dart';
import 'package:waveui/material/theme.dart' show ThemeData;
import 'package:waveui/material/theme_data.dart' show ThemeData;

import 'package:waveui/material/chip.dart';
import 'package:waveui/material/chip_theme.dart';
import 'package:waveui/material/color_scheme.dart';
import 'package:waveui/material/colors.dart';
import 'package:waveui/material/debug.dart';
import 'package:waveui/material/icons.dart';
import 'package:waveui/material/material_state.dart';
import 'package:waveui/src/theme/text_theme.dart';
import 'package:waveui/material/theme.dart';
import 'package:waveui/material/theme_data.dart';
import 'package:waveui/waveui.dart' show ThemeData;

class InputChip extends StatelessWidget
    implements
        ChipAttributes,
        DeletableChipAttributes,
        SelectableChipAttributes,
        CheckmarkableChipAttributes,
        DisabledChipAttributes,
        TappableChipAttributes {
  const InputChip({
    required this.label,
    super.key,
    this.avatar,
    this.labelStyle,
    this.labelPadding,
    this.selected = false,
    this.isEnabled = true,
    this.onSelected,
    this.deleteIcon,
    this.onDeleted,
    this.deleteIconColor,
    this.deleteButtonTooltipMessage,
    this.onPressed,
    this.pressElevation,
    this.disabledColor,
    this.selectedColor,
    this.tooltip,
    this.side,
    this.shape,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.autofocus = false,
    this.color,
    this.backgroundColor,
    this.padding,
    this.visualDensity,
    this.materialTapTargetSize,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.iconTheme,
    this.selectedShadowColor,
    this.showCheckmark,
    this.checkmarkColor,
    this.avatarBorder = const CircleBorder(),
    this.avatarBoxConstraints,
    this.deleteIconBoxConstraints,
    this.chipAnimationStyle,
    this.mouseCursor,
  }) : assert(pressElevation == null || pressElevation >= 0.0),
       assert(elevation == null || elevation >= 0.0);

  @override
  final Widget? avatar;
  @override
  final Widget label;
  @override
  final TextStyle? labelStyle;
  @override
  final EdgeInsetsGeometry? labelPadding;
  @override
  final bool selected;
  @override
  final bool isEnabled;
  @override
  final ValueChanged<bool>? onSelected;
  @override
  final Widget? deleteIcon;
  @override
  final VoidCallback? onDeleted;
  @override
  final Color? deleteIconColor;
  @override
  final String? deleteButtonTooltipMessage;
  @override
  final VoidCallback? onPressed;
  @override
  final double? pressElevation;
  @override
  final Color? disabledColor;
  @override
  final Color? selectedColor;
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
  final Color? selectedShadowColor;
  @override
  final bool? showCheckmark;
  @override
  final Color? checkmarkColor;
  @override
  final ShapeBorder avatarBorder;
  @override
  final IconThemeData? iconTheme;
  @override
  final BoxConstraints? avatarBoxConstraints;
  @override
  final BoxConstraints? deleteIconBoxConstraints;
  @override
  final ChipAnimationStyle? chipAnimationStyle;
  @override
  final MouseCursor? mouseCursor;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    final ChipThemeData defaults = _InputChipDefaultsM3(context, isEnabled, selected);
    const Widget resolvedDeleteIcon = Icon(Icons.clear, size: 18);
    return RawChip(
      defaultProperties: defaults,
      avatar: avatar,
      label: label,
      labelStyle: labelStyle,
      labelPadding: labelPadding,
      deleteIcon: resolvedDeleteIcon,
      onDeleted: onDeleted,
      deleteIconColor: deleteIconColor,
      deleteButtonTooltipMessage: deleteButtonTooltipMessage,
      onSelected: onSelected,
      onPressed: onPressed,
      pressElevation: pressElevation,
      selected: selected,
      disabledColor: disabledColor,
      selectedColor: selectedColor,
      tooltip: tooltip,
      side: side,
      shape: shape,
      clipBehavior: clipBehavior,
      focusNode: focusNode,
      autofocus: autofocus,
      color: color,
      backgroundColor: backgroundColor,
      padding: padding,
      visualDensity: visualDensity,
      materialTapTargetSize: materialTapTargetSize,
      elevation: elevation,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      selectedShadowColor: selectedShadowColor,
      showCheckmark: showCheckmark,
      checkmarkColor: checkmarkColor,
      isEnabled: isEnabled && (onSelected != null || onDeleted != null || onPressed != null),
      avatarBorder: avatarBorder,
      iconTheme: iconTheme,
      avatarBoxConstraints: avatarBoxConstraints,
      deleteIconBoxConstraints: deleteIconBoxConstraints,
      chipAnimationStyle: chipAnimationStyle,
      mouseCursor: mouseCursor,
    );
  }
}

// BEGIN GENERATED TOKEN PROPERTIES - InputChip

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// dart format off
class _InputChipDefaultsM3 extends ChipThemeData {
  _InputChipDefaultsM3(this.context, this.isEnabled, this.isSelected)
    : super(
        elevation: 0.0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
        showCheckmark: true,
      );

  final BuildContext context;
  final bool isEnabled;
  final bool isSelected;
  late final ColorScheme _colors = Theme.of(context).colorScheme;
  late final TextTheme _textTheme = Theme.of(context).textTheme;

  @override
  TextStyle? get labelStyle => _textTheme.labelLarge?.copyWith(
    color: isEnabled
      ? isSelected
        ? _colors.onSecondaryContainer
        : _colors.onSurfaceVariant
      : _colors.onSurface,
  );

  @override
  WidgetStateProperty<Color?>? get color =>
    WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected) && states.contains(WidgetState.disabled)) {
        return _colors.onSurface.withValues(alpha:0.12);
      }
      if (states.contains(WidgetState.disabled)) {
        return null;
      }
      if (states.contains(WidgetState.selected)) {
        return _colors.secondaryContainer;
      }
      return null;
    });

  @override
  Color? get shadowColor => Colors.transparent;

  @override
  Color? get surfaceTintColor => Colors.transparent;

  @override
  Color? get checkmarkColor => isEnabled
    ? isSelected
      ? _colors.primary
      : _colors.onSurfaceVariant
    : _colors.onSurface;

  @override
  Color? get deleteIconColor => isEnabled
    ? isSelected
      ? _colors.onSecondaryContainer
      : _colors.onSurfaceVariant
    : _colors.onSurface;

  @override
  BorderSide? get side => !isSelected
    ? isEnabled
      ? BorderSide(color: _colors.outlineVariant)
      : BorderSide(color: _colors.onSurface.withValues(alpha:0.12))
    : const BorderSide(color: Colors.transparent);

  @override
  IconThemeData? get iconTheme => IconThemeData(
    color: isEnabled
      ? isSelected
        ? _colors.primary
        : _colors.onSurfaceVariant
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
    properties.add(DiagnosticsProperty<BuildContext>('context', context));
    properties.add(DiagnosticsProperty<bool>('isEnabled', isEnabled));
    properties.add(DiagnosticsProperty<bool>('isSelected', isSelected));
  }
}
// dart format on

// END GENERATED TOKEN PROPERTIES - InputChip
