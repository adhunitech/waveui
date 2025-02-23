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
class OutlinedButtonThemeData with Diagnosticable {
  const OutlinedButtonThemeData({this.style});

  final ButtonStyle? style;

  static OutlinedButtonThemeData? lerp(OutlinedButtonThemeData? a, OutlinedButtonThemeData? b, double t) {
    if (identical(a, b)) {
      return a;
    }
    return OutlinedButtonThemeData(style: ButtonStyle.lerp(a?.style, b?.style, t));
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
    return other is OutlinedButtonThemeData && other.style == style;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ButtonStyle>('style', style, defaultValue: null));
  }
}

class OutlinedButtonTheme extends InheritedTheme {
  const OutlinedButtonTheme({required this.data, required super.child, super.key});

  final OutlinedButtonThemeData data;

  static OutlinedButtonThemeData of(BuildContext context) {
    final OutlinedButtonTheme? buttonTheme = context.dependOnInheritedWidgetOfExactType<OutlinedButtonTheme>();
    return buttonTheme?.data ?? Theme.of(context).outlinedButtonTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) => OutlinedButtonTheme(data: data, child: child);

  @override
  bool updateShouldNotify(OutlinedButtonTheme oldWidget) => data != oldWidget.data;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<OutlinedButtonThemeData>('data', data));
  }
}
