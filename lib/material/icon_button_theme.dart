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
class IconButtonThemeData with Diagnosticable {
  const IconButtonThemeData({this.style});

  final ButtonStyle? style;

  static IconButtonThemeData? lerp(IconButtonThemeData? a, IconButtonThemeData? b, double t) {
    if (identical(a, b)) {
      return a;
    }
    return IconButtonThemeData(style: ButtonStyle.lerp(a?.style, b?.style, t));
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
    return other is IconButtonThemeData && other.style == style;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ButtonStyle>('style', style, defaultValue: null));
  }
}

class IconButtonTheme extends InheritedTheme {
  const IconButtonTheme({required this.data, required super.child, super.key});

  final IconButtonThemeData data;

  static IconButtonThemeData of(BuildContext context) {
    final IconButtonTheme? buttonTheme = context.dependOnInheritedWidgetOfExactType<IconButtonTheme>();
    return buttonTheme?.data ?? Theme.of(context).iconButtonTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) => IconButtonTheme(data: data, child: child);

  @override
  bool updateShouldNotify(IconButtonTheme oldWidget) => data != oldWidget.data;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<IconButtonThemeData>('data', data));
  }
}
