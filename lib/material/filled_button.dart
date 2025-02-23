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
import 'package:waveui/material/filled_button_theme.dart';
import 'package:waveui/material/ink_well.dart';
import 'package:waveui/material/theme.dart';
import 'package:waveui/material/theme_data.dart';

enum _FilledButtonVariant { filled, tonal }

class FilledButton extends ButtonStyleButton {
  const FilledButton({
    required super.onPressed,
    required super.child,
    super.key,
    super.onLongPress,
    super.onHover,
    super.onFocusChange,
    super.style,
    super.focusNode,
    super.autofocus = false,
    super.clipBehavior = Clip.none,
    super.statesController,
  }) : _variant = _FilledButtonVariant.filled;

  factory FilledButton.icon({
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
      return FilledButton(
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
    return _FilledButtonWithIcon(
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

  const FilledButton.tonal({
    required super.onPressed,
    required super.child,
    super.key,
    super.onLongPress,
    super.onHover,
    super.onFocusChange,
    super.style,
    super.focusNode,
    super.autofocus = false,
    super.clipBehavior = Clip.none,
    super.statesController,
  }) : _variant = _FilledButtonVariant.tonal;

  factory FilledButton.tonalIcon({
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
      return FilledButton.tonal(
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
    return _FilledButtonWithIcon.tonal(
      key: key,
      onPressed: onPressed,
      onLongPress: onLongPress,
      onHover: onHover,
      onFocusChange: onFocusChange,
      style: style,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
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
      textStyle: WidgetStatePropertyAll<TextStyle?>(textStyle),
      backgroundColor: ButtonStyleButton.defaultColor(backgroundColor, disabledBackgroundColor),
      foregroundColor: ButtonStyleButton.defaultColor(foregroundColor, disabledForegroundColor),
      overlayColor: overlayColorProp,
      shadowColor: ButtonStyleButton.allOrNull<Color>(shadowColor),
      surfaceTintColor: ButtonStyleButton.allOrNull<Color>(surfaceTintColor),
      iconColor: ButtonStyleButton.defaultColor(iconColor, disabledIconColor),
      iconSize: ButtonStyleButton.allOrNull<double>(iconSize),
      iconAlignment: iconAlignment,
      elevation: ButtonStyleButton.allOrNull(elevation),
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

  final _FilledButtonVariant _variant;

  @override
  ButtonStyle defaultStyleOf(BuildContext context) => switch (_variant) {
    _FilledButtonVariant.filled => _FilledButtonDefaultsM3(context),
    _FilledButtonVariant.tonal => _FilledTonalButtonDefaultsM3(context),
  };

  @override
  ButtonStyle? themeStyleOf(BuildContext context) => FilledButtonTheme.of(context).style;
}

EdgeInsetsGeometry _scaledPadding(BuildContext context) {
  final ThemeData theme = Theme.of(context);
  final double defaultFontSize = theme.textTheme.labelLarge?.fontSize ?? 14.0;
  final double effectiveTextScale = MediaQuery.textScalerOf(context).scale(defaultFontSize) / 14.0;
  const double padding1x = 24.0;
  return ButtonStyleButton.scaledPadding(
    const EdgeInsets.symmetric(horizontal: padding1x),
    const EdgeInsets.symmetric(horizontal: padding1x / 2),
    const EdgeInsets.symmetric(horizontal: padding1x / 2 / 2),
    effectiveTextScale,
  );
}

class _FilledButtonWithIcon extends FilledButton {
  _FilledButtonWithIcon({
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
         child: _FilledButtonWithIconChild(icon: icon, label: label, buttonStyle: style, iconAlignment: iconAlignment),
       );

  _FilledButtonWithIcon.tonal({
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
  }) : super.tonal(
         autofocus: autofocus ?? false,
         child: _FilledButtonWithIconChild(icon: icon, label: label, buttonStyle: style, iconAlignment: iconAlignment),
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

class _FilledButtonWithIconChild extends StatelessWidget {
  const _FilledButtonWithIconChild({
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
    // Adjust the gap based on the text scale factor. Start at 8, and lerp
    // to 4 based on how large the text is.
    final double gap = lerpDouble(8, 4, scale)!;
    final FilledButtonThemeData filledButtonTheme = FilledButtonTheme.of(context);
    final IconAlignment effectiveIconAlignment =
        iconAlignment ?? filledButtonTheme.style?.iconAlignment ?? buttonStyle?.iconAlignment ?? IconAlignment.start;
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

// BEGIN GENERATED TOKEN PROPERTIES - FilledButton

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// dart format off
class _FilledButtonDefaultsM3 extends ButtonStyle {
  _FilledButtonDefaultsM3(this.context)
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
    WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return _colors.onSurface.withValues(alpha:0.12);
      }
      return _colors.primary;
    });

  @override
  WidgetStateProperty<Color?>? get foregroundColor =>
    WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return _colors.onSurface.withValues(alpha:0.38);
      }
      return _colors.onPrimary;
    });

  @override
  WidgetStateProperty<Color?>? get overlayColor =>
    WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.pressed)) {
        return _colors.onPrimary.withValues(alpha:0.1);
      }
      if (states.contains(WidgetState.hovered)) {
        return _colors.onPrimary.withValues(alpha:0.08);
      }
      if (states.contains(WidgetState.focused)) {
        return _colors.onPrimary.withValues(alpha:0.1);
      }
      return null;
    });

  @override
  WidgetStateProperty<Color>? get shadowColor =>
    WidgetStatePropertyAll<Color>(_colors.shadow);

  @override
  WidgetStateProperty<Color>? get surfaceTintColor =>
    const WidgetStatePropertyAll<Color>(Colors.transparent);

  @override
  WidgetStateProperty<double>? get elevation =>
    WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return 0.0;
      }
      if (states.contains(WidgetState.pressed)) {
        return 0.0;
      }
      if (states.contains(WidgetState.hovered)) {
        return 1.0;
      }
      if (states.contains(WidgetState.focused)) {
        return 0.0;
      }
      return 0.0;
    });

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
        return _colors.onPrimary;
      }
      if (states.contains(WidgetState.hovered)) {
        return _colors.onPrimary;
      }
      if (states.contains(WidgetState.focused)) {
        return _colors.onPrimary;
      }
      return _colors.onPrimary;
    });

  @override
  WidgetStateProperty<Size>? get maximumSize =>
    const WidgetStatePropertyAll<Size>(Size.infinite);

  // No default side

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

// END GENERATED TOKEN PROPERTIES - FilledButton

// BEGIN GENERATED TOKEN PROPERTIES - FilledTonalButton

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// dart format off
class _FilledTonalButtonDefaultsM3 extends ButtonStyle {
  _FilledTonalButtonDefaultsM3(this.context)
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
    WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return _colors.onSurface.withValues(alpha:0.12);
      }
      return _colors.secondaryContainer;
    });

  @override
  WidgetStateProperty<Color?>? get foregroundColor =>
    WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return _colors.onSurface.withValues(alpha:0.38);
      }
      return _colors.onSecondaryContainer;
    });

  @override
  WidgetStateProperty<Color?>? get overlayColor =>
    WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.pressed)) {
        return _colors.onSecondaryContainer.withValues(alpha:0.1);
      }
      if (states.contains(WidgetState.hovered)) {
        return _colors.onSecondaryContainer.withValues(alpha:0.08);
      }
      if (states.contains(WidgetState.focused)) {
        return _colors.onSecondaryContainer.withValues(alpha:0.1);
      }
      return null;
    });

  @override
  WidgetStateProperty<Color>? get shadowColor =>
    WidgetStatePropertyAll<Color>(_colors.shadow);

  @override
  WidgetStateProperty<Color>? get surfaceTintColor =>
    const WidgetStatePropertyAll<Color>(Colors.transparent);

  @override
  WidgetStateProperty<double>? get elevation =>
    WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return 0.0;
      }
      if (states.contains(WidgetState.pressed)) {
        return 0.0;
      }
      if (states.contains(WidgetState.hovered)) {
        return 1.0;
      }
      if (states.contains(WidgetState.focused)) {
        return 0.0;
      }
      return 0.0;
    });

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
        return _colors.onSecondaryContainer;
      }
      if (states.contains(WidgetState.hovered)) {
        return _colors.onSecondaryContainer;
      }
      if (states.contains(WidgetState.focused)) {
        return _colors.onSecondaryContainer;
      }
      return _colors.onSecondaryContainer;
    });

  @override
  WidgetStateProperty<Size>? get maximumSize =>
    const WidgetStatePropertyAll<Size>(Size.infinite);

  // No default side

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

// END GENERATED TOKEN PROPERTIES - FilledTonalButton
