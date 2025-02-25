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
class MaterialBannerThemeData with Diagnosticable {
  const MaterialBannerThemeData({
    this.backgroundColor,
    this.surfaceTintColor,
    this.shadowColor,
    this.dividerColor,
    this.contentTextStyle,
    this.elevation,
    this.padding,
    this.leadingPadding,
  });

  final Color? backgroundColor;

  final Color? surfaceTintColor;

  final Color? shadowColor;

  final Color? dividerColor;

  final TextStyle? contentTextStyle;

  //
  // If null, MaterialBanner uses a default of 0.0.
  final double? elevation;

  final EdgeInsetsGeometry? padding;

  final EdgeInsetsGeometry? leadingPadding;

  MaterialBannerThemeData copyWith({
    Color? backgroundColor,
    Color? surfaceTintColor,
    Color? shadowColor,
    Color? dividerColor,
    TextStyle? contentTextStyle,
    double? elevation,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? leadingPadding,
  }) => MaterialBannerThemeData(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    surfaceTintColor: surfaceTintColor ?? this.surfaceTintColor,
    shadowColor: shadowColor ?? this.shadowColor,
    dividerColor: dividerColor ?? this.dividerColor,
    contentTextStyle: contentTextStyle ?? this.contentTextStyle,
    elevation: elevation ?? this.elevation,
    padding: padding ?? this.padding,
    leadingPadding: leadingPadding ?? this.leadingPadding,
  );

  static MaterialBannerThemeData lerp(MaterialBannerThemeData? a, MaterialBannerThemeData? b, double t) =>
      MaterialBannerThemeData(
        backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t),
        surfaceTintColor: Color.lerp(a?.surfaceTintColor, b?.surfaceTintColor, t),
        shadowColor: Color.lerp(a?.shadowColor, b?.shadowColor, t),
        dividerColor: Color.lerp(a?.dividerColor, b?.dividerColor, t),
        contentTextStyle: TextStyle.lerp(a?.contentTextStyle, b?.contentTextStyle, t),
        elevation: lerpDouble(a?.elevation, b?.elevation, t),
        padding: EdgeInsetsGeometry.lerp(a?.padding, b?.padding, t),
        leadingPadding: EdgeInsetsGeometry.lerp(a?.leadingPadding, b?.leadingPadding, t),
      );

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    surfaceTintColor,
    shadowColor,
    dividerColor,
    contentTextStyle,
    elevation,
    padding,
    leadingPadding,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is MaterialBannerThemeData &&
        other.backgroundColor == backgroundColor &&
        other.surfaceTintColor == surfaceTintColor &&
        other.shadowColor == shadowColor &&
        other.dividerColor == dividerColor &&
        other.contentTextStyle == contentTextStyle &&
        other.elevation == elevation &&
        other.padding == padding &&
        other.leadingPadding == leadingPadding;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('backgroundColor', backgroundColor, defaultValue: null))
      ..add(ColorProperty('surfaceTintColor', surfaceTintColor, defaultValue: null))
      ..add(ColorProperty('shadowColor', shadowColor, defaultValue: null))
      ..add(ColorProperty('dividerColor', dividerColor, defaultValue: null))
      ..add(DiagnosticsProperty<TextStyle>('contentTextStyle', contentTextStyle, defaultValue: null))
      ..add(DoubleProperty('elevation', elevation, defaultValue: null))
      ..add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding, defaultValue: null))
      ..add(DiagnosticsProperty<EdgeInsetsGeometry>('leadingPadding', leadingPadding, defaultValue: null));
  }
}

class MaterialBannerTheme extends InheritedTheme {
  const MaterialBannerTheme({required super.child, super.key, this.data});

  final MaterialBannerThemeData? data;

  static MaterialBannerThemeData of(BuildContext context) {
    final MaterialBannerTheme? bannerTheme = context.dependOnInheritedWidgetOfExactType<MaterialBannerTheme>();
    return bannerTheme?.data ?? Theme.of(context).bannerTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) => MaterialBannerTheme(data: data, child: child);

  @override
  bool updateShouldNotify(MaterialBannerTheme oldWidget) => data != oldWidget.data;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<MaterialBannerThemeData?>('data', data));
  }
}
