// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';

import 'package:flutter/widgets.dart';

import 'package:waveui/material/button_style.dart';
import 'package:waveui/material/button_style_button.dart';
import 'package:waveui/material/color_scheme.dart';
import 'package:waveui/material/colors.dart';
import 'package:waveui/material/constants.dart';
import 'package:waveui/material/ink_well.dart';
import 'package:waveui/material/outlined_button_theme.dart';
import 'package:waveui/material/theme.dart';
import 'package:waveui/material/theme_data.dart';

class OutlinedButton extends ButtonStyleButton {
  const OutlinedButton({
    required super.onPressed,
    required super.child,
    super.key,
    super.onLongPress,
    super.onHover,
    super.onFocusChange,
    super.style,
    super.focusNode,
    super.autofocus = false,
    super.clipBehavior,
    super.statesController,
  });

  factory OutlinedButton.icon({
    required VoidCallback? onPressed,
    required Widget label,
    Key? key,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool? autofocus,
    Clip? clipBehavior,
    WidgetStatesController? statesController,
    Widget? icon,
    IconAlignment? iconAlignment,
  }) {
    if (icon == null) {
      return OutlinedButton(
        key: key,
        onPressed: onPressed,
        onLongPress: onLongPress,
        onHover: onHover,
        onFocusChange: onFocusChange,
        style: style,
        focusNode: focusNode,
        autofocus: autofocus ?? false,
        clipBehavior: clipBehavior ?? Clip.none,
        statesController: statesController,
        child: label,
      );
    }
    return _OutlinedButtonWithIcon(
      key: key,
      onPressed: onPressed,
      onLongPress: onLongPress,
      onHover: onHover,
      onFocusChange: onFocusChange,
      style: style,
      focusNode: focusNode,
      autofocus: autofocus ?? false,
      clipBehavior: clipBehavior ?? Clip.none,
      statesController: statesController,
      icon: icon,
      label: label,
      iconAlignment: iconAlignment,
    );
  }

  static ButtonStyle styleFrom({
    Color? foregroundColor,
    Color? backgroundColor,
    Color? disabledForegroundColor,
    Color? disabledBackgroundColor,
    Color? shadowColor,
    Color? surfaceTintColor,
    Color? iconColor,
    double? iconSize,
    IconAlignment? iconAlignment,
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
    ButtonLayerBuilder? backgroundBuilder,
    ButtonLayerBuilder? foregroundBuilder,
  }) {
    final WidgetStateProperty<Color?>? backgroundColorProp = switch ((backgroundColor, disabledBackgroundColor)) {
      (_?, null) => WidgetStatePropertyAll<Color?>(backgroundColor),
      (_, _) => ButtonStyleButton.defaultColor(backgroundColor, disabledBackgroundColor),
    };
    final WidgetStateProperty<Color?>? overlayColorProp = switch ((foregroundColor, overlayColor)) {
      (null, null) => null,
      (_, Color(a: 0.0)) => WidgetStatePropertyAll<Color?>(overlayColor),
      (_, final Color color) || (final Color color, _) => WidgetStateProperty<Color?>.fromMap(<WidgetState, Color?>{
        WidgetState.pressed: color.withValues(alpha: 0.1),
        WidgetState.hovered: color.withValues(alpha: 0.08),
        WidgetState.focused: color.withValues(alpha: 0.1),
      }),
    };

    return ButtonStyle(
      textStyle: ButtonStyleButton.allOrNull<TextStyle>(textStyle),
      foregroundColor: ButtonStyleButton.defaultColor(foregroundColor, disabledForegroundColor),
      backgroundColor: backgroundColorProp,
      overlayColor: overlayColorProp,
      shadowColor: ButtonStyleButton.allOrNull<Color>(shadowColor),
      surfaceTintColor: ButtonStyleButton.allOrNull<Color>(surfaceTintColor),
      iconColor: ButtonStyleButton.defaultColor(iconColor, disabledIconColor),
      iconSize: ButtonStyleButton.allOrNull<double>(iconSize),
      iconAlignment: iconAlignment,
      elevation: ButtonStyleButton.allOrNull<double>(elevation),
      padding: ButtonStyleButton.allOrNull<EdgeInsetsGeometry>(padding),
      minimumSize: ButtonStyleButton.allOrNull<Size>(minimumSize),
      fixedSize: ButtonStyleButton.allOrNull<Size>(fixedSize),
      maximumSize: ButtonStyleButton.allOrNull<Size>(maximumSize),
      side: ButtonStyleButton.allOrNull<BorderSide>(side),
      shape: ButtonStyleButton.allOrNull<OutlinedBorder>(shape),
      mouseCursor: WidgetStateProperty<MouseCursor?>.fromMap(<WidgetStatesConstraint, MouseCursor?>{
        WidgetState.disabled: disabledMouseCursor,
        WidgetState.any: enabledMouseCursor,
      }),
      visualDensity: visualDensity,
      tapTargetSize: tapTargetSize,
      animationDuration: animationDuration,
      enableFeedback: enableFeedback,
      alignment: alignment,
      splashFactory: splashFactory,
      backgroundBuilder: backgroundBuilder,
      foregroundBuilder: foregroundBuilder,
    );
  }

  @override
  ButtonStyle defaultStyleOf(BuildContext context) => _OutlinedButtonDefaultsM3(context);

  @override
  ButtonStyle? themeStyleOf(BuildContext context) => OutlinedButtonTheme.of(context).style;
}

EdgeInsetsGeometry _scaledPadding(BuildContext context) {
  final ThemeData theme = Theme.of(context);
  const double padding1x = 24.0;
  final double defaultFontSize = theme.textTheme.labelLarge?.fontSize ?? 14.0;
  final double effectiveTextScale = MediaQuery.textScalerOf(context).scale(defaultFontSize) / 14.0;
  return ButtonStyleButton.scaledPadding(
    const EdgeInsets.symmetric(horizontal: padding1x),
    const EdgeInsets.symmetric(horizontal: padding1x / 2),
    const EdgeInsets.symmetric(horizontal: padding1x / 2 / 2),
    effectiveTextScale,
  );
}

class _OutlinedButtonWithIcon extends OutlinedButton {
  _OutlinedButtonWithIcon({
    required super.onPressed,
    required Widget icon,
    required Widget label,
    super.key,
    super.onLongPress,
    super.onHover,
    super.onFocusChange,
    super.style,
    super.focusNode,
    bool? autofocus,
    super.clipBehavior,
    super.statesController,
    IconAlignment? iconAlignment,
  }) : super(
         autofocus: autofocus ?? false,
         child: _OutlinedButtonWithIconChild(
           icon: icon,
           label: label,
           buttonStyle: style,
           iconAlignment: iconAlignment,
         ),
       );

  @override
  ButtonStyle defaultStyleOf(BuildContext context) {
    final ButtonStyle buttonStyle = super.defaultStyleOf(context);
    final double defaultFontSize = buttonStyle.textStyle?.resolve(const <WidgetState>{})?.fontSize ?? 14.0;
    final double effectiveTextScale = MediaQuery.textScalerOf(context).scale(defaultFontSize) / 14.0;
    final EdgeInsetsGeometry scaledPadding = ButtonStyleButton.scaledPadding(
      const EdgeInsetsDirectional.fromSTEB(16, 0, 24, 0),
      const EdgeInsetsDirectional.fromSTEB(8, 0, 12, 0),
      const EdgeInsetsDirectional.fromSTEB(4, 0, 6, 0),
      effectiveTextScale,
    );
    return buttonStyle.copyWith(padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(scaledPadding));
  }
}

class _OutlinedButtonWithIconChild extends StatelessWidget {
  const _OutlinedButtonWithIconChild({
    required this.label,
    required this.icon,
    required this.buttonStyle,
    required this.iconAlignment,
  });

  final Widget label;
  final Widget icon;
  final ButtonStyle? buttonStyle;
  final IconAlignment? iconAlignment;

  @override
  Widget build(BuildContext context) {
    final double defaultFontSize = buttonStyle?.textStyle?.resolve(const <WidgetState>{})?.fontSize ?? 14.0;
    final double scale = clampDouble(MediaQuery.textScalerOf(context).scale(defaultFontSize) / 14.0, 1.0, 2.0) - 1.0;
    final double gap = lerpDouble(8, 4, scale)!;
    final OutlinedButtonThemeData outlinedButtonTheme = OutlinedButtonTheme.of(context);
    final IconAlignment effectiveIconAlignment =
        iconAlignment ?? outlinedButtonTheme.style?.iconAlignment ?? buttonStyle?.iconAlignment ?? IconAlignment.start;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children:
          effectiveIconAlignment == IconAlignment.start
              ? <Widget>[icon, SizedBox(width: gap), Flexible(child: label)]
              : <Widget>[Flexible(child: label), SizedBox(width: gap), icon],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ButtonStyle?>('buttonStyle', buttonStyle));
    properties.add(EnumProperty<IconAlignment?>('iconAlignment', iconAlignment));
  }
}

// BEGIN GENERATED TOKEN PROPERTIES - OutlinedButton

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// dart format off
class _OutlinedButtonDefaultsM3 extends ButtonStyle {
  _OutlinedButtonDefaultsM3(this.context)
   : super(
       animationDuration: kThemeChangeDuration,
       enableFeedback: true,
       alignment: Alignment.center,
     );

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;

  @override
  WidgetStateProperty<TextStyle?> get textStyle =>
    WidgetStatePropertyAll<TextStyle?>(Theme.of(context).textTheme.labelLarge);

  @override
  WidgetStateProperty<Color?>? get backgroundColor =>
    const WidgetStatePropertyAll<Color>(Colors.transparent);

  @override
  WidgetStateProperty<Color?>? get foregroundColor =>
    WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return _colors.onSurface.withValues(alpha:0.38);
      }
      return _colors.primary;
    });

  @override
  WidgetStateProperty<Color?>? get overlayColor =>
    WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.pressed)) {
        return _colors.primary.withValues(alpha:0.1);
      }
      if (states.contains(WidgetState.hovered)) {
        return _colors.primary.withValues(alpha:0.08);
      }
      if (states.contains(WidgetState.focused)) {
        return _colors.primary.withValues(alpha:0.1);
      }
      return null;
    });

  @override
  WidgetStateProperty<Color>? get shadowColor =>
    const WidgetStatePropertyAll<Color>(Colors.transparent);

  @override
  WidgetStateProperty<Color>? get surfaceTintColor =>
    const WidgetStatePropertyAll<Color>(Colors.transparent);

  @override
  WidgetStateProperty<double>? get elevation =>
    const WidgetStatePropertyAll<double>(0.0);

  @override
  WidgetStateProperty<EdgeInsetsGeometry>? get padding =>
    WidgetStatePropertyAll<EdgeInsetsGeometry>(_scaledPadding(context));

  @override
  WidgetStateProperty<Size>? get minimumSize =>
    const WidgetStatePropertyAll<Size>(Size(64.0, 40.0));

  // No default fixedSize

  @override
  WidgetStateProperty<double>? get iconSize =>
    const WidgetStatePropertyAll<double>(18.0);

  @override
  WidgetStateProperty<Color>? get iconColor => WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return _colors.onSurface.withValues(alpha:0.38);
      }
      if (states.contains(WidgetState.pressed)) {
        return _colors.primary;
      }
      if (states.contains(WidgetState.hovered)) {
        return _colors.primary;
      }
      if (states.contains(WidgetState.focused)) {
        return _colors.primary;
      }
      return _colors.primary;
    });

  @override
  WidgetStateProperty<Size>? get maximumSize =>
    const WidgetStatePropertyAll<Size>(Size.infinite);

  @override
  WidgetStateProperty<BorderSide>? get side =>
    WidgetStateProperty.resolveWith((states) {
    if (states.contains(WidgetState.disabled)) {
      return BorderSide(color: _colors.onSurface.withValues(alpha:0.12));
    }
    if (states.contains(WidgetState.focused)) {
      return BorderSide(color: _colors.primary);
    }
    return BorderSide(color: _colors.outline);
  });

  @override
  WidgetStateProperty<OutlinedBorder>? get shape =>
    const WidgetStatePropertyAll<OutlinedBorder>(StadiumBorder());

  @override
  WidgetStateProperty<MouseCursor?>? get mouseCursor =>
    WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return SystemMouseCursors.basic;
      }
      return SystemMouseCursors.click;
    });

  @override
  VisualDensity? get visualDensity => Theme.of(context).visualDensity;

  @override
  MaterialTapTargetSize? get tapTargetSize => Theme.of(context).materialTapTargetSize;

  @override
  InteractiveInkFeatureFactory? get splashFactory => Theme.of(context).splashFactory;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BuildContext>('context', context));
  }
}
// dart format on

// END GENERATED TOKEN PROPERTIES - OutlinedButton
