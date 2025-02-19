// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/button_style.dart';
import 'package:waveui/material/color_scheme.dart';
import 'package:waveui/material/colors.dart';
import 'package:waveui/material/input_decorator.dart';
import 'package:waveui/material/text_button.dart';
import 'package:waveui/src/theme/text_theme.dart';
import 'package:waveui/material/theme.dart';

// Examples can assume:
// late BuildContext context;

@immutable
class DatePickerThemeData with Diagnosticable {
  const DatePickerThemeData({
    this.backgroundColor,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.shape,
    this.headerBackgroundColor,
    this.headerForegroundColor,
    this.headerHeadlineStyle,
    this.headerHelpStyle,
    this.weekdayStyle,
    this.dayStyle,
    this.dayForegroundColor,
    this.dayBackgroundColor,
    this.dayOverlayColor,
    this.dayShape,
    this.todayForegroundColor,
    this.todayBackgroundColor,
    this.todayBorder,
    this.yearStyle,
    this.yearForegroundColor,
    this.yearBackgroundColor,
    this.yearOverlayColor,
    this.rangePickerBackgroundColor,
    this.rangePickerElevation,
    this.rangePickerShadowColor,
    this.rangePickerSurfaceTintColor,
    this.rangePickerShape,
    this.rangePickerHeaderBackgroundColor,
    this.rangePickerHeaderForegroundColor,
    this.rangePickerHeaderHeadlineStyle,
    this.rangePickerHeaderHelpStyle,
    this.rangeSelectionBackgroundColor,
    this.rangeSelectionOverlayColor,
    this.dividerColor,
    this.inputDecorationTheme,
    this.cancelButtonStyle,
    this.confirmButtonStyle,
    this.locale,
  });

  final Color? backgroundColor;

  final double? elevation;

  final Color? shadowColor;

  final Color? surfaceTintColor;

  final ShapeBorder? shape;

  final Color? headerBackgroundColor;

  final Color? headerForegroundColor;

  final TextStyle? headerHeadlineStyle;

  final TextStyle? headerHelpStyle;

  final TextStyle? weekdayStyle;

  final TextStyle? dayStyle;

  final WidgetStateProperty<Color?>? dayForegroundColor;

  final WidgetStateProperty<Color?>? dayBackgroundColor;

  final WidgetStateProperty<Color?>? dayOverlayColor;

  final WidgetStateProperty<OutlinedBorder?>? dayShape;

  final WidgetStateProperty<Color?>? todayForegroundColor;

  final WidgetStateProperty<Color?>? todayBackgroundColor;

  final BorderSide? todayBorder;

  final TextStyle? yearStyle;

  final WidgetStateProperty<Color?>? yearForegroundColor;

  final WidgetStateProperty<Color?>? yearBackgroundColor;

  final WidgetStateProperty<Color?>? yearOverlayColor;

  final Color? rangePickerBackgroundColor;

  final double? rangePickerElevation;

  final Color? rangePickerShadowColor;

  final Color? rangePickerSurfaceTintColor;

  final ShapeBorder? rangePickerShape;

  final Color? rangePickerHeaderBackgroundColor;

  final Color? rangePickerHeaderForegroundColor;

  final TextStyle? rangePickerHeaderHeadlineStyle;

  final TextStyle? rangePickerHeaderHelpStyle;

  final Color? rangeSelectionBackgroundColor;

  final WidgetStateProperty<Color?>? rangeSelectionOverlayColor;

  final Color? dividerColor;

  final InputDecorationTheme? inputDecorationTheme;

  final ButtonStyle? cancelButtonStyle;

  final ButtonStyle? confirmButtonStyle;

  final Locale? locale;

  DatePickerThemeData copyWith({
    Color? backgroundColor,
    double? elevation,
    Color? shadowColor,
    Color? surfaceTintColor,
    ShapeBorder? shape,
    Color? headerBackgroundColor,
    Color? headerForegroundColor,
    TextStyle? headerHeadlineStyle,
    TextStyle? headerHelpStyle,
    TextStyle? weekdayStyle,
    TextStyle? dayStyle,
    WidgetStateProperty<Color?>? dayForegroundColor,
    WidgetStateProperty<Color?>? dayBackgroundColor,
    WidgetStateProperty<Color?>? dayOverlayColor,
    WidgetStateProperty<OutlinedBorder?>? dayShape,
    WidgetStateProperty<Color?>? todayForegroundColor,
    WidgetStateProperty<Color?>? todayBackgroundColor,
    BorderSide? todayBorder,
    TextStyle? yearStyle,
    WidgetStateProperty<Color?>? yearForegroundColor,
    WidgetStateProperty<Color?>? yearBackgroundColor,
    WidgetStateProperty<Color?>? yearOverlayColor,
    Color? rangePickerBackgroundColor,
    double? rangePickerElevation,
    Color? rangePickerShadowColor,
    Color? rangePickerSurfaceTintColor,
    ShapeBorder? rangePickerShape,
    Color? rangePickerHeaderBackgroundColor,
    Color? rangePickerHeaderForegroundColor,
    TextStyle? rangePickerHeaderHeadlineStyle,
    TextStyle? rangePickerHeaderHelpStyle,
    Color? rangeSelectionBackgroundColor,
    WidgetStateProperty<Color?>? rangeSelectionOverlayColor,
    Color? dividerColor,
    InputDecorationTheme? inputDecorationTheme,
    ButtonStyle? cancelButtonStyle,
    ButtonStyle? confirmButtonStyle,
    Locale? locale,
  }) => DatePickerThemeData(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    elevation: elevation ?? this.elevation,
    shadowColor: shadowColor ?? this.shadowColor,
    surfaceTintColor: surfaceTintColor ?? this.surfaceTintColor,
    shape: shape ?? this.shape,
    headerBackgroundColor: headerBackgroundColor ?? this.headerBackgroundColor,
    headerForegroundColor: headerForegroundColor ?? this.headerForegroundColor,
    headerHeadlineStyle: headerHeadlineStyle ?? this.headerHeadlineStyle,
    headerHelpStyle: headerHelpStyle ?? this.headerHelpStyle,
    weekdayStyle: weekdayStyle ?? this.weekdayStyle,
    dayStyle: dayStyle ?? this.dayStyle,
    dayForegroundColor: dayForegroundColor ?? this.dayForegroundColor,
    dayBackgroundColor: dayBackgroundColor ?? this.dayBackgroundColor,
    dayOverlayColor: dayOverlayColor ?? this.dayOverlayColor,
    dayShape: dayShape ?? this.dayShape,
    todayForegroundColor: todayForegroundColor ?? this.todayForegroundColor,
    todayBackgroundColor: todayBackgroundColor ?? this.todayBackgroundColor,
    todayBorder: todayBorder ?? this.todayBorder,
    yearStyle: yearStyle ?? this.yearStyle,
    yearForegroundColor: yearForegroundColor ?? this.yearForegroundColor,
    yearBackgroundColor: yearBackgroundColor ?? this.yearBackgroundColor,
    yearOverlayColor: yearOverlayColor ?? this.yearOverlayColor,
    rangePickerBackgroundColor: rangePickerBackgroundColor ?? this.rangePickerBackgroundColor,
    rangePickerElevation: rangePickerElevation ?? this.rangePickerElevation,
    rangePickerShadowColor: rangePickerShadowColor ?? this.rangePickerShadowColor,
    rangePickerSurfaceTintColor: rangePickerSurfaceTintColor ?? this.rangePickerSurfaceTintColor,
    rangePickerShape: rangePickerShape ?? this.rangePickerShape,
    rangePickerHeaderBackgroundColor: rangePickerHeaderBackgroundColor ?? this.rangePickerHeaderBackgroundColor,
    rangePickerHeaderForegroundColor: rangePickerHeaderForegroundColor ?? this.rangePickerHeaderForegroundColor,
    rangePickerHeaderHeadlineStyle: rangePickerHeaderHeadlineStyle ?? this.rangePickerHeaderHeadlineStyle,
    rangePickerHeaderHelpStyle: rangePickerHeaderHelpStyle ?? this.rangePickerHeaderHelpStyle,
    rangeSelectionBackgroundColor: rangeSelectionBackgroundColor ?? this.rangeSelectionBackgroundColor,
    rangeSelectionOverlayColor: rangeSelectionOverlayColor ?? this.rangeSelectionOverlayColor,
    dividerColor: dividerColor ?? this.dividerColor,
    inputDecorationTheme: inputDecorationTheme ?? this.inputDecorationTheme,
    cancelButtonStyle: cancelButtonStyle ?? this.cancelButtonStyle,
    confirmButtonStyle: confirmButtonStyle ?? this.confirmButtonStyle,
    locale: locale ?? this.locale,
  );

  static DatePickerThemeData lerp(DatePickerThemeData? a, DatePickerThemeData? b, double t) {
    if (identical(a, b) && a != null) {
      return a;
    }
    return DatePickerThemeData(
      backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t),
      elevation: lerpDouble(a?.elevation, b?.elevation, t),
      shadowColor: Color.lerp(a?.shadowColor, b?.shadowColor, t),
      surfaceTintColor: Color.lerp(a?.surfaceTintColor, b?.surfaceTintColor, t),
      shape: ShapeBorder.lerp(a?.shape, b?.shape, t),
      headerBackgroundColor: Color.lerp(a?.headerBackgroundColor, b?.headerBackgroundColor, t),
      headerForegroundColor: Color.lerp(a?.headerForegroundColor, b?.headerForegroundColor, t),
      headerHeadlineStyle: TextStyle.lerp(a?.headerHeadlineStyle, b?.headerHeadlineStyle, t),
      headerHelpStyle: TextStyle.lerp(a?.headerHelpStyle, b?.headerHelpStyle, t),
      weekdayStyle: TextStyle.lerp(a?.weekdayStyle, b?.weekdayStyle, t),
      dayStyle: TextStyle.lerp(a?.dayStyle, b?.dayStyle, t),
      dayForegroundColor: WidgetStateProperty.lerp<Color?>(a?.dayForegroundColor, b?.dayForegroundColor, t, Color.lerp),
      dayBackgroundColor: WidgetStateProperty.lerp<Color?>(a?.dayBackgroundColor, b?.dayBackgroundColor, t, Color.lerp),
      dayOverlayColor: WidgetStateProperty.lerp<Color?>(a?.dayOverlayColor, b?.dayOverlayColor, t, Color.lerp),
      dayShape: WidgetStateProperty.lerp<OutlinedBorder?>(a?.dayShape, b?.dayShape, t, OutlinedBorder.lerp),
      todayForegroundColor: WidgetStateProperty.lerp<Color?>(
        a?.todayForegroundColor,
        b?.todayForegroundColor,
        t,
        Color.lerp,
      ),
      todayBackgroundColor: WidgetStateProperty.lerp<Color?>(
        a?.todayBackgroundColor,
        b?.todayBackgroundColor,
        t,
        Color.lerp,
      ),
      todayBorder: _lerpBorderSide(a?.todayBorder, b?.todayBorder, t),
      yearStyle: TextStyle.lerp(a?.yearStyle, b?.yearStyle, t),
      yearForegroundColor: WidgetStateProperty.lerp<Color?>(
        a?.yearForegroundColor,
        b?.yearForegroundColor,
        t,
        Color.lerp,
      ),
      yearBackgroundColor: WidgetStateProperty.lerp<Color?>(
        a?.yearBackgroundColor,
        b?.yearBackgroundColor,
        t,
        Color.lerp,
      ),
      yearOverlayColor: WidgetStateProperty.lerp<Color?>(a?.yearOverlayColor, b?.yearOverlayColor, t, Color.lerp),
      rangePickerBackgroundColor: Color.lerp(a?.rangePickerBackgroundColor, b?.rangePickerBackgroundColor, t),
      rangePickerElevation: lerpDouble(a?.rangePickerElevation, b?.rangePickerElevation, t),
      rangePickerShadowColor: Color.lerp(a?.rangePickerShadowColor, b?.rangePickerShadowColor, t),
      rangePickerSurfaceTintColor: Color.lerp(a?.rangePickerSurfaceTintColor, b?.rangePickerSurfaceTintColor, t),
      rangePickerShape: ShapeBorder.lerp(a?.rangePickerShape, b?.rangePickerShape, t),
      rangePickerHeaderBackgroundColor: Color.lerp(
        a?.rangePickerHeaderBackgroundColor,
        b?.rangePickerHeaderBackgroundColor,
        t,
      ),
      rangePickerHeaderForegroundColor: Color.lerp(
        a?.rangePickerHeaderForegroundColor,
        b?.rangePickerHeaderForegroundColor,
        t,
      ),
      rangePickerHeaderHeadlineStyle: TextStyle.lerp(
        a?.rangePickerHeaderHeadlineStyle,
        b?.rangePickerHeaderHeadlineStyle,
        t,
      ),
      rangePickerHeaderHelpStyle: TextStyle.lerp(a?.rangePickerHeaderHelpStyle, b?.rangePickerHeaderHelpStyle, t),
      rangeSelectionBackgroundColor: Color.lerp(a?.rangeSelectionBackgroundColor, b?.rangeSelectionBackgroundColor, t),
      rangeSelectionOverlayColor: WidgetStateProperty.lerp<Color?>(
        a?.rangeSelectionOverlayColor,
        b?.rangeSelectionOverlayColor,
        t,
        Color.lerp,
      ),
      dividerColor: Color.lerp(a?.dividerColor, b?.dividerColor, t),
      inputDecorationTheme: t < 0.5 ? a?.inputDecorationTheme : b?.inputDecorationTheme,
      cancelButtonStyle: ButtonStyle.lerp(a?.cancelButtonStyle, b?.cancelButtonStyle, t),
      confirmButtonStyle: ButtonStyle.lerp(a?.confirmButtonStyle, b?.confirmButtonStyle, t),
      locale: t < 0.5 ? a?.locale : b?.locale,
    );
  }

  static BorderSide? _lerpBorderSide(BorderSide? a, BorderSide? b, double t) {
    if (identical(a, b)) {
      return a;
    }
    if (a == null) {
      return BorderSide.lerp(BorderSide(width: 0, color: b!.color.withAlpha(0)), b, t);
    }
    return BorderSide.lerp(a, BorderSide(width: 0, color: a.color.withAlpha(0)), t);
  }

  @override
  int get hashCode => Object.hashAll(<Object?>[
    backgroundColor,
    elevation,
    shadowColor,
    surfaceTintColor,
    shape,
    headerBackgroundColor,
    headerForegroundColor,
    headerHeadlineStyle,
    headerHelpStyle,
    weekdayStyle,
    dayStyle,
    dayForegroundColor,
    dayBackgroundColor,
    dayOverlayColor,
    dayShape,
    todayForegroundColor,
    todayBackgroundColor,
    todayBorder,
    yearStyle,
    yearForegroundColor,
    yearBackgroundColor,
    yearOverlayColor,
    rangePickerBackgroundColor,
    rangePickerElevation,
    rangePickerShadowColor,
    rangePickerSurfaceTintColor,
    rangePickerShape,
    rangePickerHeaderBackgroundColor,
    rangePickerHeaderForegroundColor,
    rangePickerHeaderHeadlineStyle,
    rangePickerHeaderHelpStyle,
    rangeSelectionBackgroundColor,
    rangeSelectionOverlayColor,
    dividerColor,
    inputDecorationTheme,
    cancelButtonStyle,
    confirmButtonStyle,
    locale,
  ]);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is DatePickerThemeData &&
        other.backgroundColor == backgroundColor &&
        other.elevation == elevation &&
        other.shadowColor == shadowColor &&
        other.surfaceTintColor == surfaceTintColor &&
        other.shape == shape &&
        other.headerBackgroundColor == headerBackgroundColor &&
        other.headerForegroundColor == headerForegroundColor &&
        other.headerHeadlineStyle == headerHeadlineStyle &&
        other.headerHelpStyle == headerHelpStyle &&
        other.weekdayStyle == weekdayStyle &&
        other.dayStyle == dayStyle &&
        other.dayForegroundColor == dayForegroundColor &&
        other.dayBackgroundColor == dayBackgroundColor &&
        other.dayOverlayColor == dayOverlayColor &&
        other.dayShape == dayShape &&
        other.todayForegroundColor == todayForegroundColor &&
        other.todayBackgroundColor == todayBackgroundColor &&
        other.todayBorder == todayBorder &&
        other.yearStyle == yearStyle &&
        other.yearForegroundColor == yearForegroundColor &&
        other.yearBackgroundColor == yearBackgroundColor &&
        other.yearOverlayColor == yearOverlayColor &&
        other.rangePickerBackgroundColor == rangePickerBackgroundColor &&
        other.rangePickerElevation == rangePickerElevation &&
        other.rangePickerShadowColor == rangePickerShadowColor &&
        other.rangePickerSurfaceTintColor == rangePickerSurfaceTintColor &&
        other.rangePickerShape == rangePickerShape &&
        other.rangePickerHeaderBackgroundColor == rangePickerHeaderBackgroundColor &&
        other.rangePickerHeaderForegroundColor == rangePickerHeaderForegroundColor &&
        other.rangePickerHeaderHeadlineStyle == rangePickerHeaderHeadlineStyle &&
        other.rangePickerHeaderHelpStyle == rangePickerHeaderHelpStyle &&
        other.rangeSelectionBackgroundColor == rangeSelectionBackgroundColor &&
        other.rangeSelectionOverlayColor == rangeSelectionOverlayColor &&
        other.dividerColor == dividerColor &&
        other.inputDecorationTheme == inputDecorationTheme &&
        other.cancelButtonStyle == cancelButtonStyle &&
        other.confirmButtonStyle == confirmButtonStyle &&
        other.locale == locale;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('backgroundColor', backgroundColor, defaultValue: null))
      ..add(DoubleProperty('elevation', elevation, defaultValue: null))
      ..add(ColorProperty('shadowColor', shadowColor, defaultValue: null))
      ..add(ColorProperty('surfaceTintColor', surfaceTintColor, defaultValue: null))
      ..add(DiagnosticsProperty<ShapeBorder>('shape', shape, defaultValue: null))
      ..add(ColorProperty('headerBackgroundColor', headerBackgroundColor, defaultValue: null))
      ..add(ColorProperty('headerForegroundColor', headerForegroundColor, defaultValue: null))
      ..add(DiagnosticsProperty<TextStyle>('headerHeadlineStyle', headerHeadlineStyle, defaultValue: null))
      ..add(DiagnosticsProperty<TextStyle>('headerHelpStyle', headerHelpStyle, defaultValue: null))
      ..add(DiagnosticsProperty<TextStyle>('weekDayStyle', weekdayStyle, defaultValue: null))
      ..add(DiagnosticsProperty<TextStyle>('dayStyle', dayStyle, defaultValue: null))
      ..add(
        DiagnosticsProperty<WidgetStateProperty<Color?>>('dayForegroundColor', dayForegroundColor, defaultValue: null),
      )
      ..add(
        DiagnosticsProperty<WidgetStateProperty<Color?>>('dayBackgroundColor', dayBackgroundColor, defaultValue: null),
      )
      ..add(DiagnosticsProperty<WidgetStateProperty<Color?>>('dayOverlayColor', dayOverlayColor, defaultValue: null))
      ..add(DiagnosticsProperty<WidgetStateProperty<OutlinedBorder?>>('dayShape', dayShape, defaultValue: null))
      ..add(
        DiagnosticsProperty<WidgetStateProperty<Color?>>(
          'todayForegroundColor',
          todayForegroundColor,
          defaultValue: null,
        ),
      )
      ..add(
        DiagnosticsProperty<WidgetStateProperty<Color?>>(
          'todayBackgroundColor',
          todayBackgroundColor,
          defaultValue: null,
        ),
      )
      ..add(DiagnosticsProperty<BorderSide?>('todayBorder', todayBorder, defaultValue: null))
      ..add(DiagnosticsProperty<TextStyle>('yearStyle', yearStyle, defaultValue: null))
      ..add(
        DiagnosticsProperty<WidgetStateProperty<Color?>>(
          'yearForegroundColor',
          yearForegroundColor,
          defaultValue: null,
        ),
      )
      ..add(
        DiagnosticsProperty<WidgetStateProperty<Color?>>(
          'yearBackgroundColor',
          yearBackgroundColor,
          defaultValue: null,
        ),
      )
      ..add(DiagnosticsProperty<WidgetStateProperty<Color?>>('yearOverlayColor', yearOverlayColor, defaultValue: null))
      ..add(ColorProperty('rangePickerBackgroundColor', rangePickerBackgroundColor, defaultValue: null))
      ..add(DoubleProperty('rangePickerElevation', rangePickerElevation, defaultValue: null))
      ..add(ColorProperty('rangePickerShadowColor', rangePickerShadowColor, defaultValue: null))
      ..add(ColorProperty('rangePickerSurfaceTintColor', rangePickerSurfaceTintColor, defaultValue: null))
      ..add(DiagnosticsProperty<ShapeBorder>('rangePickerShape', rangePickerShape, defaultValue: null))
      ..add(ColorProperty('rangePickerHeaderBackgroundColor', rangePickerHeaderBackgroundColor, defaultValue: null))
      ..add(ColorProperty('rangePickerHeaderForegroundColor', rangePickerHeaderForegroundColor, defaultValue: null))
      ..add(
        DiagnosticsProperty<TextStyle>(
          'rangePickerHeaderHeadlineStyle',
          rangePickerHeaderHeadlineStyle,
          defaultValue: null,
        ),
      )
      ..add(
        DiagnosticsProperty<TextStyle>('rangePickerHeaderHelpStyle', rangePickerHeaderHelpStyle, defaultValue: null),
      )
      ..add(ColorProperty('rangeSelectionBackgroundColor', rangeSelectionBackgroundColor, defaultValue: null))
      ..add(
        DiagnosticsProperty<WidgetStateProperty<Color?>>(
          'rangeSelectionOverlayColor',
          rangeSelectionOverlayColor,
          defaultValue: null,
        ),
      )
      ..add(ColorProperty('dividerColor', dividerColor, defaultValue: null))
      ..add(DiagnosticsProperty<InputDecorationTheme>('inputDecorationTheme', inputDecorationTheme, defaultValue: null))
      ..add(DiagnosticsProperty<ButtonStyle>('cancelButtonStyle', cancelButtonStyle, defaultValue: null))
      ..add(DiagnosticsProperty<ButtonStyle>('confirmButtonStyle', confirmButtonStyle, defaultValue: null))
      ..add(DiagnosticsProperty<Locale>('locale', locale, defaultValue: null));
  }
}

class DatePickerTheme extends InheritedTheme {
  const DatePickerTheme({required this.data, required super.child, super.key});

  final DatePickerThemeData data;

  static DatePickerThemeData of(BuildContext context) => maybeOf(context) ?? Theme.of(context).datePickerTheme;

  static DatePickerThemeData? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DatePickerTheme>()?.data;

  static DatePickerThemeData defaults(BuildContext context) => _DatePickerDefaultsM3(context);

  @override
  Widget wrap(BuildContext context, Widget child) => DatePickerTheme(data: data, child: child);

  @override
  bool updateShouldNotify(DatePickerTheme oldWidget) => data != oldWidget.data;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<DatePickerThemeData>('data', data));
  }
}

// BEGIN GENERATED TOKEN PROPERTIES - DatePicker

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// dart format off
class _DatePickerDefaultsM3 extends DatePickerThemeData {
  _DatePickerDefaultsM3(this.context)
    : super(
        elevation: 6.0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(28.0))),
        // TODO(tahatesser): Update this to use token when gen_defaults
        // supports `CircleBorder` for fully rounded corners.
        dayShape: const WidgetStatePropertyAll<OutlinedBorder>(CircleBorder()),
        rangePickerElevation: 0.0,
        rangePickerShape: const RoundedRectangleBorder(),
      );

  final BuildContext context;
  late final ThemeData _theme = Theme.of(context);
  late final ColorScheme _colors = _theme.colorScheme;
  late final TextTheme _textTheme = _theme.textTheme;

  @override
  Color? get backgroundColor => _colors.surfaceContainerHigh;

  @override
  ButtonStyle get cancelButtonStyle => TextButton.styleFrom();

  @override
  ButtonStyle get confirmButtonStyle => TextButton.styleFrom();

  @override
  Color? get shadowColor => Colors.transparent;

  @override
  Color? get surfaceTintColor => Colors.transparent;

  @override
  Color? get headerBackgroundColor => Colors.transparent;

  @override
  Color? get headerForegroundColor => _colors.onSurfaceVariant;

  @override
  TextStyle? get headerHeadlineStyle => _textTheme.headlineLarge;

  @override
  TextStyle? get headerHelpStyle => _textTheme.labelLarge;

  @override
  TextStyle? get weekdayStyle => _textTheme.bodyLarge?.apply(
    color: _colors.onSurface,
  );

  @override
  TextStyle? get dayStyle => _textTheme.bodyLarge;

  @override
  WidgetStateProperty<Color?>? get dayForegroundColor =>
    WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return _colors.onPrimary;
      } else if (states.contains(WidgetState.disabled)) {
        return _colors.onSurface.withOpacity(0.38);
      }
      return _colors.onSurface;
    });

  @override
  WidgetStateProperty<Color?>? get dayBackgroundColor =>
    WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return _colors.primary;
      }
      return null;
    });

  @override
  WidgetStateProperty<Color?>? get dayOverlayColor =>
    WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        if (states.contains(WidgetState.pressed)) {
          return _colors.onPrimary.withOpacity(0.1);
        }
        if (states.contains(WidgetState.hovered)) {
          return _colors.onPrimary.withOpacity(0.08);
        }
        if (states.contains(WidgetState.focused)) {
          return _colors.onPrimary.withOpacity(0.1);
        }
      } else {
        if (states.contains(WidgetState.pressed)) {
          return _colors.onSurfaceVariant.withOpacity(0.1);
        }
        if (states.contains(WidgetState.hovered)) {
          return _colors.onSurfaceVariant.withOpacity(0.08);
        }
        if (states.contains(WidgetState.focused)) {
          return _colors.onSurfaceVariant.withOpacity(0.1);
        }
      }
      return null;
    });

  @override
  WidgetStateProperty<Color?>? get todayForegroundColor =>
    WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return _colors.onPrimary;
      } else if (states.contains(WidgetState.disabled)) {
        return _colors.primary.withOpacity(0.38);
      }
      return _colors.primary;
    });

  @override
  WidgetStateProperty<Color?>? get todayBackgroundColor => dayBackgroundColor;

  @override
  BorderSide? get todayBorder => BorderSide(color: _colors.primary);

  @override
  TextStyle? get yearStyle => _textTheme.bodyLarge;

  @override
  WidgetStateProperty<Color?>? get yearForegroundColor =>
    WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return _colors.onPrimary;
      } else if (states.contains(WidgetState.disabled)) {
        return _colors.onSurfaceVariant.withOpacity(0.38);
      }
      return _colors.onSurfaceVariant;
    });

  @override
  WidgetStateProperty<Color?>? get yearBackgroundColor =>
    WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return _colors.primary;
      }
      return null;
    });

  @override
  WidgetStateProperty<Color?>? get yearOverlayColor =>
    WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        if (states.contains(WidgetState.pressed)) {
          return _colors.onPrimary.withOpacity(0.1);
        }
        if (states.contains(WidgetState.hovered)) {
          return _colors.onPrimary.withOpacity(0.08);
        }
        if (states.contains(WidgetState.focused)) {
          return _colors.onPrimary.withOpacity(0.1);
        }
      } else {
        if (states.contains(WidgetState.pressed)) {
          return _colors.onSurfaceVariant.withOpacity(0.1);
        }
        if (states.contains(WidgetState.hovered)) {
          return _colors.onSurfaceVariant.withOpacity(0.08);
        }
        if (states.contains(WidgetState.focused)) {
          return _colors.onSurfaceVariant.withOpacity(0.1);
        }
      }
      return null;
    });

    @override
    Color? get rangePickerShadowColor => Colors.transparent;

    @override
    Color? get rangePickerSurfaceTintColor => Colors.transparent;

    @override
    Color? get rangeSelectionBackgroundColor => _colors.secondaryContainer;

  @override
  WidgetStateProperty<Color?>? get rangeSelectionOverlayColor =>
    WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.pressed)) {
        return _colors.onPrimaryContainer.withOpacity(0.1);
      }
      if (states.contains(WidgetState.hovered)) {
        return _colors.onPrimaryContainer.withOpacity(0.08);
      }
      if (states.contains(WidgetState.focused)) {
        return _colors.onPrimaryContainer.withOpacity(0.1);
      }
      return null;
    });

  @override
  Color? get rangePickerHeaderBackgroundColor => Colors.transparent;

  @override
  Color? get rangePickerHeaderForegroundColor => _colors.onSurfaceVariant;

  @override
  TextStyle? get rangePickerHeaderHeadlineStyle => _textTheme.titleLarge;

  @override
  TextStyle? get rangePickerHeaderHelpStyle => _textTheme.titleSmall;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BuildContext>('context', context));
  }
}
// dart format on

// END GENERATED TOKEN PROPERTIES - DatePicker
