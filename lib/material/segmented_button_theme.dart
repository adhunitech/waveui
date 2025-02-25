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
class SegmentedButtonThemeData with Diagnosticable {
  const SegmentedButtonThemeData({this.style, this.selectedIcon});

  final ButtonStyle? style;

  final Widget? selectedIcon;

  SegmentedButtonThemeData copyWith({ButtonStyle? style, Widget? selectedIcon}) =>
      SegmentedButtonThemeData(style: style ?? this.style, selectedIcon: selectedIcon ?? this.selectedIcon);

  static SegmentedButtonThemeData lerp(SegmentedButtonThemeData? a, SegmentedButtonThemeData? b, double t) {
    if (identical(a, b) && a != null) {
      return a;
    }
    return SegmentedButtonThemeData(
      style: ButtonStyle.lerp(a?.style, b?.style, t),
      selectedIcon: t < 0.5 ? a?.selectedIcon : b?.selectedIcon,
    );
  }

  @override
  int get hashCode => Object.hash(style, selectedIcon);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is SegmentedButtonThemeData && other.style == style && other.selectedIcon == selectedIcon;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ButtonStyle>('style', style, defaultValue: null));
  }
}

class SegmentedButtonTheme extends InheritedTheme {
  const SegmentedButtonTheme({required this.data, required super.child, super.key});

  final SegmentedButtonThemeData data;

  static SegmentedButtonThemeData of(BuildContext context) =>
      maybeOf(context) ?? Theme.of(context).segmentedButtonTheme;

  static SegmentedButtonThemeData? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SegmentedButtonTheme>()?.data;

  @override
  Widget wrap(BuildContext context, Widget child) => SegmentedButtonTheme(data: data, child: child);

  @override
  bool updateShouldNotify(SegmentedButtonTheme oldWidget) => data != oldWidget.data;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SegmentedButtonThemeData>('data', data));
  }
}
