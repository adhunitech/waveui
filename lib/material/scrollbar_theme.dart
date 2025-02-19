// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/theme.dart';

// Examples can assume:
// late BuildContext context;

@immutable
class ScrollbarThemeData with Diagnosticable {
  const ScrollbarThemeData({
    this.thumbVisibility,
    this.thickness,
    this.trackVisibility,
    this.radius,
    this.thumbColor,
    this.trackColor,
    this.trackBorderColor,
    this.crossAxisMargin,
    this.mainAxisMargin,
    this.minThumbLength,
    this.interactive,
  });

  final WidgetStateProperty<bool?>? thumbVisibility;

  final WidgetStateProperty<double?>? thickness;

  final WidgetStateProperty<bool?>? trackVisibility;

  final bool? interactive;

  final Radius? radius;

  final WidgetStateProperty<Color?>? thumbColor;

  final WidgetStateProperty<Color?>? trackColor;

  final WidgetStateProperty<Color?>? trackBorderColor;

  final double? crossAxisMargin;

  final double? mainAxisMargin;

  final double? minThumbLength;

  ScrollbarThemeData copyWith({
    WidgetStateProperty<bool?>? thumbVisibility,
    WidgetStateProperty<double?>? thickness,
    WidgetStateProperty<bool?>? trackVisibility,
    bool? interactive,
    Radius? radius,
    WidgetStateProperty<Color?>? thumbColor,
    WidgetStateProperty<Color?>? trackColor,
    WidgetStateProperty<Color?>? trackBorderColor,
    double? crossAxisMargin,
    double? mainAxisMargin,
    double? minThumbLength,
  }) => ScrollbarThemeData(
    thumbVisibility: thumbVisibility ?? this.thumbVisibility,
    thickness: thickness ?? this.thickness,
    trackVisibility: trackVisibility ?? this.trackVisibility,
    interactive: interactive ?? this.interactive,
    radius: radius ?? this.radius,
    thumbColor: thumbColor ?? this.thumbColor,
    trackColor: trackColor ?? this.trackColor,
    trackBorderColor: trackBorderColor ?? this.trackBorderColor,
    crossAxisMargin: crossAxisMargin ?? this.crossAxisMargin,
    mainAxisMargin: mainAxisMargin ?? this.mainAxisMargin,
    minThumbLength: minThumbLength ?? this.minThumbLength,
  );

  static ScrollbarThemeData lerp(ScrollbarThemeData? a, ScrollbarThemeData? b, double t) {
    if (identical(a, b) && a != null) {
      return a;
    }
    return ScrollbarThemeData(
      thumbVisibility: WidgetStateProperty.lerp<bool?>(a?.thumbVisibility, b?.thumbVisibility, t, _lerpBool),
      thickness: WidgetStateProperty.lerp<double?>(a?.thickness, b?.thickness, t, lerpDouble),
      trackVisibility: WidgetStateProperty.lerp<bool?>(a?.trackVisibility, b?.trackVisibility, t, _lerpBool),
      interactive: _lerpBool(a?.interactive, b?.interactive, t),
      radius: Radius.lerp(a?.radius, b?.radius, t),
      thumbColor: WidgetStateProperty.lerp<Color?>(a?.thumbColor, b?.thumbColor, t, Color.lerp),
      trackColor: WidgetStateProperty.lerp<Color?>(a?.trackColor, b?.trackColor, t, Color.lerp),
      trackBorderColor: WidgetStateProperty.lerp<Color?>(a?.trackBorderColor, b?.trackBorderColor, t, Color.lerp),
      crossAxisMargin: lerpDouble(a?.crossAxisMargin, b?.crossAxisMargin, t),
      mainAxisMargin: lerpDouble(a?.mainAxisMargin, b?.mainAxisMargin, t),
      minThumbLength: lerpDouble(a?.minThumbLength, b?.minThumbLength, t),
    );
  }

  @override
  int get hashCode => Object.hash(
    thumbVisibility,
    thickness,
    trackVisibility,
    interactive,
    radius,
    thumbColor,
    trackColor,
    trackBorderColor,
    crossAxisMargin,
    mainAxisMargin,
    minThumbLength,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is ScrollbarThemeData &&
        other.thumbVisibility == thumbVisibility &&
        other.thickness == thickness &&
        other.trackVisibility == trackVisibility &&
        other.interactive == interactive &&
        other.radius == radius &&
        other.thumbColor == thumbColor &&
        other.trackColor == trackColor &&
        other.trackBorderColor == trackBorderColor &&
        other.crossAxisMargin == crossAxisMargin &&
        other.mainAxisMargin == mainAxisMargin &&
        other.minThumbLength == minThumbLength;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<WidgetStateProperty<bool?>>('thumbVisibility', thumbVisibility, defaultValue: null),
    );
    properties.add(DiagnosticsProperty<WidgetStateProperty<double?>>('thickness', thickness, defaultValue: null));
    properties.add(
      DiagnosticsProperty<WidgetStateProperty<bool?>>('trackVisibility', trackVisibility, defaultValue: null),
    );
    properties.add(DiagnosticsProperty<bool>('interactive', interactive, defaultValue: null));
    properties.add(DiagnosticsProperty<Radius>('radius', radius, defaultValue: null));
    properties.add(DiagnosticsProperty<WidgetStateProperty<Color?>>('thumbColor', thumbColor, defaultValue: null));
    properties.add(DiagnosticsProperty<WidgetStateProperty<Color?>>('trackColor', trackColor, defaultValue: null));
    properties.add(
      DiagnosticsProperty<WidgetStateProperty<Color?>>('trackBorderColor', trackBorderColor, defaultValue: null),
    );
    properties.add(DiagnosticsProperty<double>('crossAxisMargin', crossAxisMargin, defaultValue: null));
    properties.add(DiagnosticsProperty<double>('mainAxisMargin', mainAxisMargin, defaultValue: null));
    properties.add(DiagnosticsProperty<double>('minThumbLength', minThumbLength, defaultValue: null));
  }
}

bool? _lerpBool(bool? a, bool? b, double t) => t < 0.5 ? a : b;

class ScrollbarTheme extends InheritedTheme {
  const ScrollbarTheme({required this.data, required super.child, super.key});

  final ScrollbarThemeData data;

  static ScrollbarThemeData of(BuildContext context) {
    final ScrollbarTheme? scrollbarTheme = context.dependOnInheritedWidgetOfExactType<ScrollbarTheme>();
    return scrollbarTheme?.data ?? Theme.of(context).scrollbarTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) => ScrollbarTheme(data: data, child: child);

  @override
  bool updateShouldNotify(ScrollbarTheme oldWidget) => data != oldWidget.data;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ScrollbarThemeData>('data', data));
  }
}
