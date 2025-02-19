// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/menu_style.dart';
import 'package:waveui/material/theme.dart';

// Examples can assume:
// late Widget child;

@immutable
class MenuThemeData with Diagnosticable {
  const MenuThemeData({this.style, this.submenuIcon});

  final MenuStyle? style;

  final WidgetStateProperty<Widget?>? submenuIcon;

  static MenuThemeData? lerp(MenuThemeData? a, MenuThemeData? b, double t) {
    if (identical(a, b)) {
      return a;
    }
    return MenuThemeData(
      style: MenuStyle.lerp(a?.style, b?.style, t),
      submenuIcon: t < 0.5 ? a?.submenuIcon : b?.submenuIcon,
    );
  }

  @override
  int get hashCode => Object.hash(style, submenuIcon);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is MenuThemeData && other.style == style && other.submenuIcon == submenuIcon;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<MenuStyle>('style', style, defaultValue: null));
    properties.add(DiagnosticsProperty<WidgetStateProperty<Widget?>>('submenuIcon', submenuIcon, defaultValue: null));
  }
}

class MenuTheme extends InheritedTheme {
  const MenuTheme({required this.data, required super.child, super.key});

  final MenuThemeData data;

  static MenuThemeData of(BuildContext context) {
    final MenuTheme? menuTheme = context.dependOnInheritedWidgetOfExactType<MenuTheme>();
    return menuTheme?.data ?? Theme.of(context).menuTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) => MenuTheme(data: data, child: child);

  @override
  bool updateShouldNotify(MenuTheme oldWidget) => data != oldWidget.data;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<MenuThemeData>('data', data));
  }
}
