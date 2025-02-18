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
class TextButtonThemeData with Diagnosticable {
  const TextButtonThemeData({this.style});

  final ButtonStyle? style;

  static TextButtonThemeData? lerp(TextButtonThemeData? a, TextButtonThemeData? b, double t) {
    if (identical(a, b)) {
      return a;
    }
    return TextButtonThemeData(style: ButtonStyle.lerp(a?.style, b?.style, t));
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
    return other is TextButtonThemeData && other.style == style;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ButtonStyle>('style', style, defaultValue: null));
  }
}

class TextButtonTheme extends InheritedTheme {
  const TextButtonTheme({required this.data, required super.child, super.key});

  final TextButtonThemeData data;

  static TextButtonThemeData of(BuildContext context) {
    final TextButtonTheme? buttonTheme = context.dependOnInheritedWidgetOfExactType<TextButtonTheme>();
    return buttonTheme?.data ?? Theme.of(context).textButtonTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) => TextButtonTheme(data: data, child: child);

  @override
  bool updateShouldNotify(TextButtonTheme oldWidget) => data != oldWidget.data;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextButtonThemeData>('data', data));
  }
}
