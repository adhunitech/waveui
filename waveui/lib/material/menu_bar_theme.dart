// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/menu_anchor.dart';
import 'package:waveui/material/menu_style.dart';
import 'package:waveui/material/menu_theme.dart';
import 'package:waveui/material/theme.dart';

// Examples can assume:
// late Widget child;

@immutable
class MenuBarThemeData extends MenuThemeData {
  const MenuBarThemeData({super.style});

  static MenuBarThemeData? lerp(MenuBarThemeData? a, MenuBarThemeData? b, double t) {
    if (identical(a, b)) {
      return a;
    }
    return MenuBarThemeData(style: MenuStyle.lerp(a?.style, b?.style, t));
  }
}

class MenuBarTheme extends InheritedTheme {
  const MenuBarTheme({required this.data, required super.child, super.key});

  final MenuBarThemeData data;

  static MenuBarThemeData of(BuildContext context) {
    final MenuBarTheme? menuBarTheme = context.dependOnInheritedWidgetOfExactType<MenuBarTheme>();
    return menuBarTheme?.data ?? Theme.of(context).menuBarTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) => MenuBarTheme(data: data, child: child);

  @override
  bool updateShouldNotify(MenuBarTheme oldWidget) => data != oldWidget.data;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<MenuBarThemeData>('data', data));
  }
}
