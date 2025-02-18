// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/theme.dart';

class CardTheme extends InheritedWidget with Diagnosticable {
  const CardTheme({
    super.key,
    Clip? clipBehavior,
    Color? color,
    Color? surfaceTintColor,
    Color? shadowColor,
    double? elevation,
    EdgeInsetsGeometry? margin,
    ShapeBorder? shape,
    CardThemeData? data,
    Widget? child,
  }) : assert(
         data == null ||
             (clipBehavior ?? color ?? surfaceTintColor ?? shadowColor ?? elevation ?? margin ?? shape) == null,
       ),
       assert(elevation == null || elevation >= 0.0),
       _data = data,
       _clipBehavior = clipBehavior,
       _color = color,
       _surfaceTintColor = surfaceTintColor,
       _shadowColor = shadowColor,
       _elevation = elevation,
       _margin = margin,
       _shape = shape,
       super(child: child ?? const SizedBox());

  final CardThemeData? _data;
  final Clip? _clipBehavior;
  final Color? _color;
  final Color? _surfaceTintColor;
  final Color? _shadowColor;
  final double? _elevation;
  final EdgeInsetsGeometry? _margin;
  final ShapeBorder? _shape;

  Clip? get clipBehavior => _data != null ? _data.clipBehavior : _clipBehavior;

  Color? get color => _data != null ? _data.color : _color;

  Color? get surfaceTintColor => _data != null ? _data.surfaceTintColor : _surfaceTintColor;

  Color? get shadowColor => _data != null ? _data.shadowColor : _shadowColor;

  double? get elevation => _data != null ? _data.elevation : _elevation;

  EdgeInsetsGeometry? get margin => _data != null ? _data.margin : _margin;

  ShapeBorder? get shape => _data != null ? _data.shape : _shape;

  CardThemeData get data =>
      _data ??
      CardThemeData(
        clipBehavior: _clipBehavior,
        color: _color,
        surfaceTintColor: _surfaceTintColor,
        shadowColor: _shadowColor,
        elevation: _elevation,
        margin: _margin,
        shape: _shape,
      );

  CardTheme copyWith({
    Clip? clipBehavior,
    Color? color,
    Color? shadowColor,
    Color? surfaceTintColor,
    double? elevation,
    EdgeInsetsGeometry? margin,
    ShapeBorder? shape,
  }) => CardTheme(
    clipBehavior: clipBehavior ?? this.clipBehavior,
    color: color ?? this.color,
    shadowColor: shadowColor ?? this.shadowColor,
    surfaceTintColor: surfaceTintColor ?? this.surfaceTintColor,
    elevation: elevation ?? this.elevation,
    margin: margin ?? this.margin,
    shape: shape ?? this.shape,
  );

  static CardThemeData of(BuildContext context) {
    final CardTheme? cardTheme = context.dependOnInheritedWidgetOfExactType<CardTheme>();
    return cardTheme?.data ?? Theme.of(context).cardTheme;
  }

  @override
  bool updateShouldNotify(CardTheme oldWidget) => data != oldWidget.data;

  static CardTheme lerp(CardTheme? a, CardTheme? b, double t) {
    if (identical(a, b) && a != null) {
      return a;
    }
    return CardTheme(
      clipBehavior: t < 0.5 ? a?.clipBehavior : b?.clipBehavior,
      color: Color.lerp(a?.color, b?.color, t),
      shadowColor: Color.lerp(a?.shadowColor, b?.shadowColor, t),
      surfaceTintColor: Color.lerp(a?.surfaceTintColor, b?.surfaceTintColor, t),
      elevation: lerpDouble(a?.elevation, b?.elevation, t),
      margin: EdgeInsetsGeometry.lerp(a?.margin, b?.margin, t),
      shape: ShapeBorder.lerp(a?.shape, b?.shape, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Clip>('clipBehavior', clipBehavior, defaultValue: null));
    properties.add(ColorProperty('color', color, defaultValue: null));
    properties.add(ColorProperty('shadowColor', shadowColor, defaultValue: null));
    properties.add(ColorProperty('surfaceTintColor', surfaceTintColor, defaultValue: null));
    properties.add(DiagnosticsProperty<double>('elevation', elevation, defaultValue: null));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('margin', margin, defaultValue: null));
    properties.add(DiagnosticsProperty<ShapeBorder>('shape', shape, defaultValue: null));
    properties.add(DiagnosticsProperty<CardThemeData>('data', data));
  }
}

@immutable
class CardThemeData with Diagnosticable {
  const CardThemeData({
    this.clipBehavior,
    this.color,
    this.shadowColor,
    this.surfaceTintColor,
    this.elevation,
    this.margin,
    this.shape,
  }) : assert(elevation == null || elevation >= 0.0);

  final Clip? clipBehavior;

  final Color? color;

  final Color? shadowColor;

  final Color? surfaceTintColor;

  final double? elevation;

  final EdgeInsetsGeometry? margin;

  final ShapeBorder? shape;

  CardThemeData copyWith({
    Clip? clipBehavior,
    Color? color,
    Color? shadowColor,
    Color? surfaceTintColor,
    double? elevation,
    EdgeInsetsGeometry? margin,
    ShapeBorder? shape,
  }) => CardThemeData(
    clipBehavior: clipBehavior ?? this.clipBehavior,
    color: color ?? this.color,
    shadowColor: shadowColor ?? this.shadowColor,
    surfaceTintColor: surfaceTintColor ?? this.surfaceTintColor,
    elevation: elevation ?? this.elevation,
    margin: margin ?? this.margin,
    shape: shape ?? this.shape,
  );

  static CardThemeData lerp(CardThemeData? a, CardThemeData? b, double t) {
    if (identical(a, b) && a != null) {
      return a;
    }
    return CardThemeData(
      clipBehavior: t < 0.5 ? a?.clipBehavior : b?.clipBehavior,
      color: Color.lerp(a?.color, b?.color, t),
      shadowColor: Color.lerp(a?.shadowColor, b?.shadowColor, t),
      surfaceTintColor: Color.lerp(a?.surfaceTintColor, b?.surfaceTintColor, t),
      elevation: lerpDouble(a?.elevation, b?.elevation, t),
      margin: EdgeInsetsGeometry.lerp(a?.margin, b?.margin, t),
      shape: ShapeBorder.lerp(a?.shape, b?.shape, t),
    );
  }

  @override
  int get hashCode => Object.hash(clipBehavior, color, shadowColor, surfaceTintColor, elevation, margin, shape);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is CardThemeData &&
        other.clipBehavior == clipBehavior &&
        other.color == color &&
        other.shadowColor == shadowColor &&
        other.surfaceTintColor == surfaceTintColor &&
        other.elevation == elevation &&
        other.margin == margin &&
        other.shape == shape;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Clip>('clipBehavior', clipBehavior, defaultValue: null));
    properties.add(ColorProperty('color', color, defaultValue: null));
    properties.add(ColorProperty('shadowColor', shadowColor, defaultValue: null));
    properties.add(ColorProperty('surfaceTintColor', surfaceTintColor, defaultValue: null));
    properties.add(DiagnosticsProperty<double>('elevation', elevation, defaultValue: null));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('margin', margin, defaultValue: null));
    properties.add(DiagnosticsProperty<ShapeBorder>('shape', shape, defaultValue: null));
  }
}
