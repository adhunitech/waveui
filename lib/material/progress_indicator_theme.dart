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
class ProgressIndicatorThemeData with Diagnosticable {
  const ProgressIndicatorThemeData({
    this.color,
    this.linearTrackColor,
    this.linearMinHeight,
    this.circularTrackColor,
    this.refreshBackgroundColor,
    this.borderRadius,
    this.stopIndicatorColor,
    this.stopIndicatorRadius,
    this.strokeWidth,
    this.strokeAlign,
    this.strokeCap,
    this.constraints,
    this.trackGap,
    this.circularTrackPadding,
    @Deprecated(
      'Set this flag to false to opt into the 2024 progress indicator appearance. Defaults to true. '
      'In the future, this flag will default to false. Use ProgressIndicatorThemeData to customize individual properties. '
      'This feature was deprecated after v3.27.0-0.2.pre.',
    )
    this.year2023,
  });

  final Color? color;

  final Color? linearTrackColor;

  final double? linearMinHeight;

  final Color? circularTrackColor;

  final Color? refreshBackgroundColor;

  final BorderRadiusGeometry? borderRadius;

  final Color? stopIndicatorColor;

  final double? stopIndicatorRadius;

  final double? strokeWidth;

  final double? strokeAlign;

  final StrokeCap? strokeCap;

  final BoxConstraints? constraints;

  final double? trackGap;

  final EdgeInsetsGeometry? circularTrackPadding;

  @Deprecated(
    'Set this flag to false to opt into the 2024 progress indicator appearance. Defaults to true. '
    'In the future, this flag will default to false. Use ProgressIndicatorThemeData to customize individual properties. '
    'This feature was deprecated after v3.27.0-0.2.pre.',
  )
  final bool? year2023;

  ProgressIndicatorThemeData copyWith({
    Color? color,
    Color? linearTrackColor,
    double? linearMinHeight,
    Color? circularTrackColor,
    Color? refreshBackgroundColor,
    BorderRadiusGeometry? borderRadius,
    Color? stopIndicatorColor,
    double? stopIndicatorRadius,
    double? strokeWidth,
    double? strokeAlign,
    StrokeCap? strokeCap,
    BoxConstraints? constraints,
    double? trackGap,
    EdgeInsetsGeometry? circularTrackPadding,
    bool? year2023,
  }) => ProgressIndicatorThemeData(
    color: color ?? this.color,
    linearTrackColor: linearTrackColor ?? this.linearTrackColor,
    linearMinHeight: linearMinHeight ?? this.linearMinHeight,
    circularTrackColor: circularTrackColor ?? this.circularTrackColor,
    refreshBackgroundColor: refreshBackgroundColor ?? this.refreshBackgroundColor,
    borderRadius: borderRadius ?? this.borderRadius,
    stopIndicatorColor: stopIndicatorColor ?? this.stopIndicatorColor,
    stopIndicatorRadius: stopIndicatorRadius ?? this.stopIndicatorRadius,
    strokeWidth: strokeWidth ?? this.strokeWidth,
    strokeAlign: strokeAlign ?? this.strokeAlign,
    strokeCap: strokeCap ?? this.strokeCap,
    constraints: constraints ?? this.constraints,
    trackGap: trackGap ?? this.trackGap,
    circularTrackPadding: circularTrackPadding ?? this.circularTrackPadding,
    year2023: year2023 ?? this.year2023,
  );

  static ProgressIndicatorThemeData? lerp(ProgressIndicatorThemeData? a, ProgressIndicatorThemeData? b, double t) {
    if (identical(a, b)) {
      return a;
    }
    return ProgressIndicatorThemeData(
      color: Color.lerp(a?.color, b?.color, t),
      linearTrackColor: Color.lerp(a?.linearTrackColor, b?.linearTrackColor, t),
      linearMinHeight: lerpDouble(a?.linearMinHeight, b?.linearMinHeight, t),
      circularTrackColor: Color.lerp(a?.circularTrackColor, b?.circularTrackColor, t),
      refreshBackgroundColor: Color.lerp(a?.refreshBackgroundColor, b?.refreshBackgroundColor, t),
      borderRadius: BorderRadiusGeometry.lerp(a?.borderRadius, b?.borderRadius, t),
      stopIndicatorColor: Color.lerp(a?.stopIndicatorColor, b?.stopIndicatorColor, t),
      stopIndicatorRadius: lerpDouble(a?.stopIndicatorRadius, b?.stopIndicatorRadius, t),
      strokeWidth: lerpDouble(a?.strokeWidth, b?.strokeWidth, t),
      strokeAlign: lerpDouble(a?.strokeAlign, b?.strokeAlign, t),
      strokeCap: t < 0.5 ? a?.strokeCap : b?.strokeCap,
      constraints: BoxConstraints.lerp(a?.constraints, b?.constraints, t),
      trackGap: lerpDouble(a?.trackGap, b?.trackGap, t),
      circularTrackPadding: EdgeInsetsGeometry.lerp(a?.circularTrackPadding, b?.circularTrackPadding, t),
      year2023: t < 0.5 ? a?.year2023 : b?.year2023,
    );
  }

  @override
  int get hashCode => Object.hash(
    color,
    linearTrackColor,
    linearMinHeight,
    circularTrackColor,
    refreshBackgroundColor,
    borderRadius,
    stopIndicatorColor,
    stopIndicatorRadius,
    strokeAlign,
    strokeWidth,
    strokeCap,
    constraints,
    trackGap,
    circularTrackPadding,
    year2023,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is ProgressIndicatorThemeData &&
        other.color == color &&
        other.linearTrackColor == linearTrackColor &&
        other.linearMinHeight == linearMinHeight &&
        other.circularTrackColor == circularTrackColor &&
        other.refreshBackgroundColor == refreshBackgroundColor &&
        other.borderRadius == borderRadius &&
        other.stopIndicatorColor == stopIndicatorColor &&
        other.stopIndicatorRadius == stopIndicatorRadius &&
        other.strokeAlign == strokeAlign &&
        other.strokeWidth == strokeWidth &&
        other.strokeCap == strokeCap &&
        other.constraints == constraints &&
        other.trackGap == trackGap &&
        other.circularTrackPadding == circularTrackPadding &&
        other.year2023 == year2023;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('color', color, defaultValue: null));
    properties.add(ColorProperty('linearTrackColor', linearTrackColor, defaultValue: null));
    properties.add(DoubleProperty('linearMinHeight', linearMinHeight, defaultValue: null));
    properties.add(ColorProperty('circularTrackColor', circularTrackColor, defaultValue: null));
    properties.add(ColorProperty('refreshBackgroundColor', refreshBackgroundColor, defaultValue: null));
    properties.add(DiagnosticsProperty<BorderRadiusGeometry>('borderRadius', borderRadius, defaultValue: null));
    properties.add(ColorProperty('stopIndicatorColor', stopIndicatorColor, defaultValue: null));
    properties.add(DoubleProperty('stopIndicatorRadius', stopIndicatorRadius, defaultValue: null));
    properties.add(DoubleProperty('strokeWidth', strokeWidth, defaultValue: null));
    properties.add(DoubleProperty('strokeAlign', strokeAlign, defaultValue: null));
    properties.add(DiagnosticsProperty<StrokeCap>('strokeCap', strokeCap, defaultValue: null));
    properties.add(DiagnosticsProperty<BoxConstraints>('constraints', constraints, defaultValue: null));
    properties.add(DoubleProperty('trackGap', trackGap, defaultValue: null));
    properties.add(
      DiagnosticsProperty<EdgeInsetsGeometry>('circularTrackPadding', circularTrackPadding, defaultValue: null),
    );
    properties.add(DiagnosticsProperty<bool>('year2023', year2023, defaultValue: null));
  }
}

class ProgressIndicatorTheme extends InheritedTheme {
  const ProgressIndicatorTheme({required this.data, required super.child, super.key});

  final ProgressIndicatorThemeData data;

  static ProgressIndicatorThemeData of(BuildContext context) {
    final ProgressIndicatorTheme? progressIndicatorTheme =
        context.dependOnInheritedWidgetOfExactType<ProgressIndicatorTheme>();
    return progressIndicatorTheme?.data ?? Theme.of(context).progressIndicatorTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) => ProgressIndicatorTheme(data: data, child: child);

  @override
  bool updateShouldNotify(ProgressIndicatorTheme oldWidget) => data != oldWidget.data;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ProgressIndicatorThemeData>('data', data));
  }
}
