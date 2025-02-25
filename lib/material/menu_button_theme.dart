// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/button_style.dart';
import 'package:waveui/material/theme.dart';

// Examples can assume:
// late BuildContext context;

@immutable
class MenuButtonThemeData with Diagnosticable {
  const MenuButtonThemeData({this.style});

  final ButtonStyle? style;

  static MenuButtonThemeData? lerp(MenuButtonThemeData? a, MenuButtonThemeData? b, double t) {
    if (identical(a, b)) {
      return a;
    }
    return MenuButtonThemeData(style: ButtonStyle.lerp(a?.style, b?.style, t));
  }

  @override
  int get hashCode => style.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is MenuButtonThemeData && other.style == style;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ButtonStyle>('style', style, defaultValue: null));
  }
}

class MenuButtonTheme extends InheritedTheme {
  const MenuButtonTheme({required this.data, required super.child, super.key});

  final MenuButtonThemeData data;

  static MenuButtonThemeData of(BuildContext context) {
    final MenuButtonTheme? buttonTheme = context.dependOnInheritedWidgetOfExactType<MenuButtonTheme>();
    return buttonTheme?.data ?? Theme.of(context).menuButtonTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) => MenuButtonTheme(data: data, child: child);

  @override
  bool updateShouldNotify(MenuButtonTheme oldWidget) => data != oldWidget.data;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<MenuButtonThemeData>('data', data));
  }
}
