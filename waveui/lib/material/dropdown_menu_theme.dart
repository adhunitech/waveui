// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:waveui/material/input_decorator.dart';
import 'package:waveui/material/menu_style.dart';
import 'package:waveui/material/theme.dart';

// Examples can assume:
// late BuildContext context;

@immutable
class DropdownMenuThemeData with Diagnosticable {
  const DropdownMenuThemeData({this.textStyle, this.inputDecorationTheme, this.menuStyle});

  final TextStyle? textStyle;

  final InputDecorationTheme? inputDecorationTheme;

  final MenuStyle? menuStyle;

  DropdownMenuThemeData copyWith({
    TextStyle? textStyle,
    InputDecorationTheme? inputDecorationTheme,
    MenuStyle? menuStyle,
  }) => DropdownMenuThemeData(
    textStyle: textStyle ?? this.textStyle,
    inputDecorationTheme: inputDecorationTheme ?? this.inputDecorationTheme,
    menuStyle: menuStyle ?? this.menuStyle,
  );

  static DropdownMenuThemeData lerp(DropdownMenuThemeData? a, DropdownMenuThemeData? b, double t) {
    if (identical(a, b) && a != null) {
      return a;
    }
    return DropdownMenuThemeData(
      textStyle: TextStyle.lerp(a?.textStyle, b?.textStyle, t),
      inputDecorationTheme: t < 0.5 ? a?.inputDecorationTheme : b?.inputDecorationTheme,
      menuStyle: MenuStyle.lerp(a?.menuStyle, b?.menuStyle, t),
    );
  }

  @override
  int get hashCode => Object.hash(textStyle, inputDecorationTheme, menuStyle);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is DropdownMenuThemeData &&
        other.textStyle == textStyle &&
        other.inputDecorationTheme == inputDecorationTheme &&
        other.menuStyle == menuStyle;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextStyle>('textStyle', textStyle, defaultValue: null));
    properties.add(
      DiagnosticsProperty<InputDecorationTheme>('inputDecorationTheme', inputDecorationTheme, defaultValue: null),
    );
    properties.add(DiagnosticsProperty<MenuStyle>('menuStyle', menuStyle, defaultValue: null));
  }
}

class DropdownMenuTheme extends InheritedTheme {
  const DropdownMenuTheme({required this.data, required super.child, super.key});

  final DropdownMenuThemeData data;

  static DropdownMenuThemeData of(BuildContext context) => maybeOf(context) ?? Theme.of(context).dropdownMenuTheme;

  static DropdownMenuThemeData? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DropdownMenuTheme>()?.data;

  @override
  Widget wrap(BuildContext context, Widget child) => DropdownMenuTheme(data: data, child: child);

  @override
  bool updateShouldNotify(DropdownMenuTheme oldWidget) => data != oldWidget.data;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<DropdownMenuThemeData>('data', data));
  }
}
