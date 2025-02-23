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
class BadgeThemeData with Diagnosticable {
  const BadgeThemeData({
    this.backgroundColor,
    this.textColor,
    this.smallSize,
    this.largeSize,
    this.textStyle,
    this.padding,
    this.alignment,
    this.offset,
  });

  final Color? backgroundColor;

  final Color? textColor;

  final double? smallSize;

  final double? largeSize;

  final TextStyle? textStyle;

  final EdgeInsetsGeometry? padding;

  final AlignmentGeometry? alignment;

  final Offset? offset;

  BadgeThemeData copyWith({
    Color? backgroundColor,
    Color? textColor,
    double? smallSize,
    double? largeSize,
    TextStyle? textStyle,
    EdgeInsetsGeometry? padding,
    AlignmentGeometry? alignment,
    Offset? offset,
  }) => BadgeThemeData(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    textColor: textColor ?? this.textColor,
    smallSize: smallSize ?? this.smallSize,
    largeSize: largeSize ?? this.largeSize,
    textStyle: textStyle ?? this.textStyle,
    padding: padding ?? this.padding,
    alignment: alignment ?? this.alignment,
    offset: offset ?? this.offset,
  );

  static BadgeThemeData lerp(BadgeThemeData? a, BadgeThemeData? b, double t) {
    if (identical(a, b) && a != null) {
      return a;
    }
    return BadgeThemeData(
      backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t),
      textColor: Color.lerp(a?.textColor, b?.textColor, t),
      smallSize: lerpDouble(a?.smallSize, b?.smallSize, t),
      largeSize: lerpDouble(a?.largeSize, b?.largeSize, t),
      textStyle: TextStyle.lerp(a?.textStyle, b?.textStyle, t),
      padding: EdgeInsetsGeometry.lerp(a?.padding, b?.padding, t),
      alignment: AlignmentGeometry.lerp(a?.alignment, b?.alignment, t),
      offset: Offset.lerp(a?.offset, b?.offset, t),
    );
  }

  @override
  int get hashCode =>
      Object.hash(backgroundColor, textColor, smallSize, largeSize, textStyle, padding, alignment, offset);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is BadgeThemeData &&
        other.backgroundColor == backgroundColor &&
        other.textColor == textColor &&
        other.smallSize == smallSize &&
        other.largeSize == largeSize &&
        other.textStyle == textStyle &&
        other.padding == padding &&
        other.alignment == alignment &&
        other.offset == offset;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('backgroundColor', backgroundColor, defaultValue: null))
      ..add(ColorProperty('textColor', textColor, defaultValue: null))
      ..add(DoubleProperty('smallSize', smallSize, defaultValue: null))
      ..add(DoubleProperty('largeSize', largeSize, defaultValue: null))
      ..add(DiagnosticsProperty<TextStyle>('textStyle', textStyle, defaultValue: null))
      ..add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding, defaultValue: null))
      ..add(DiagnosticsProperty<AlignmentGeometry>('alignment', alignment, defaultValue: null))
      ..add(DiagnosticsProperty<Offset>('offset', offset, defaultValue: null));
  }
}

class BadgeTheme extends InheritedTheme {
  const BadgeTheme({required this.data, required super.child, super.key});

  final BadgeThemeData data;

  static BadgeThemeData of(BuildContext context) {
    final BadgeTheme? badgeTheme = context.dependOnInheritedWidgetOfExactType<BadgeTheme>();
    return badgeTheme?.data ?? Theme.of(context).badgeTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) => BadgeTheme(data: data, child: child);

  @override
  bool updateShouldNotify(BadgeTheme oldWidget) => data != oldWidget.data;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BadgeThemeData>('data', data));
  }
}
