// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/theme.dart';

// Examples can assume:
// late BuildContext context;

enum PopupMenuPosition { over, under }

@immutable
class PopupMenuThemeData with Diagnosticable {
  const PopupMenuThemeData({
    this.color,
    this.shape,
    this.menuPadding,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.textStyle,
    this.labelTextStyle,
    this.enableFeedback,
    this.mouseCursor,
    this.position,
    this.iconColor,
    this.iconSize,
  });

  final Color? color;

  final ShapeBorder? shape;

  final EdgeInsetsGeometry? menuPadding;

  final double? elevation;

  final Color? shadowColor;

  final Color? surfaceTintColor;

  final TextStyle? textStyle;

  final WidgetStateProperty<TextStyle?>? labelTextStyle;

  final bool? enableFeedback;

  final WidgetStateProperty<MouseCursor?>? mouseCursor;

  final PopupMenuPosition? position;

  final Color? iconColor;

  final double? iconSize;

  PopupMenuThemeData copyWith({
    Color? color,
    ShapeBorder? shape,
    EdgeInsetsGeometry? menuPadding,
    double? elevation,
    Color? shadowColor,
    Color? surfaceTintColor,
    TextStyle? textStyle,
    WidgetStateProperty<TextStyle?>? labelTextStyle,
    bool? enableFeedback,
    WidgetStateProperty<MouseCursor?>? mouseCursor,
    PopupMenuPosition? position,
    Color? iconColor,
    double? iconSize,
  }) => PopupMenuThemeData(
    color: color ?? this.color,
    shape: shape ?? this.shape,
    menuPadding: menuPadding ?? this.menuPadding,
    elevation: elevation ?? this.elevation,
    shadowColor: shadowColor ?? this.shadowColor,
    surfaceTintColor: surfaceTintColor ?? this.surfaceTintColor,
    textStyle: textStyle ?? this.textStyle,
    labelTextStyle: labelTextStyle ?? this.labelTextStyle,
    enableFeedback: enableFeedback ?? this.enableFeedback,
    mouseCursor: mouseCursor ?? this.mouseCursor,
    position: position ?? this.position,
    iconColor: iconColor ?? this.iconColor,
    iconSize: iconSize ?? this.iconSize,
  );

  static PopupMenuThemeData? lerp(PopupMenuThemeData? a, PopupMenuThemeData? b, double t) {
    if (identical(a, b)) {
      return a;
    }
    return PopupMenuThemeData(
      color: Color.lerp(a?.color, b?.color, t),
      shape: ShapeBorder.lerp(a?.shape, b?.shape, t),
      menuPadding: EdgeInsetsGeometry.lerp(a?.menuPadding, b?.menuPadding, t),
      elevation: lerpDouble(a?.elevation, b?.elevation, t),
      shadowColor: Color.lerp(a?.shadowColor, b?.shadowColor, t),
      surfaceTintColor: Color.lerp(a?.surfaceTintColor, b?.surfaceTintColor, t),
      textStyle: TextStyle.lerp(a?.textStyle, b?.textStyle, t),
      labelTextStyle: WidgetStateProperty.lerp<TextStyle?>(a?.labelTextStyle, b?.labelTextStyle, t, TextStyle.lerp),
      enableFeedback: t < 0.5 ? a?.enableFeedback : b?.enableFeedback,
      mouseCursor: t < 0.5 ? a?.mouseCursor : b?.mouseCursor,
      position: t < 0.5 ? a?.position : b?.position,
      iconColor: Color.lerp(a?.iconColor, b?.iconColor, t),
      iconSize: lerpDouble(a?.iconSize, b?.iconSize, t),
    );
  }

  @override
  int get hashCode => Object.hash(
    color,
    shape,
    menuPadding,
    elevation,
    shadowColor,
    surfaceTintColor,
    textStyle,
    labelTextStyle,
    enableFeedback,
    mouseCursor,
    position,
    iconColor,
    iconSize,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is PopupMenuThemeData &&
        other.color == color &&
        other.shape == shape &&
        other.menuPadding == menuPadding &&
        other.elevation == elevation &&
        other.shadowColor == shadowColor &&
        other.surfaceTintColor == surfaceTintColor &&
        other.textStyle == textStyle &&
        other.labelTextStyle == labelTextStyle &&
        other.enableFeedback == enableFeedback &&
        other.mouseCursor == mouseCursor &&
        other.position == position &&
        other.iconColor == iconColor &&
        other.iconSize == iconSize;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('color', color, defaultValue: null));
    properties.add(DiagnosticsProperty<ShapeBorder>('shape', shape, defaultValue: null));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('menuPadding', menuPadding, defaultValue: null));
    properties.add(DoubleProperty('elevation', elevation, defaultValue: null));
    properties.add(ColorProperty('shadowColor', shadowColor, defaultValue: null));
    properties.add(ColorProperty('surfaceTintColor', surfaceTintColor, defaultValue: null));
    properties.add(DiagnosticsProperty<TextStyle>('text style', textStyle, defaultValue: null));
    properties.add(
      DiagnosticsProperty<WidgetStateProperty<TextStyle?>>('labelTextStyle', labelTextStyle, defaultValue: null),
    );
    properties.add(DiagnosticsProperty<bool>('enableFeedback', enableFeedback, defaultValue: null));
    properties.add(
      DiagnosticsProperty<WidgetStateProperty<MouseCursor?>>('mouseCursor', mouseCursor, defaultValue: null),
    );
    properties.add(EnumProperty<PopupMenuPosition?>('position', position, defaultValue: null));
    properties.add(ColorProperty('iconColor', iconColor, defaultValue: null));
    properties.add(DoubleProperty('iconSize', iconSize, defaultValue: null));
  }
}

class PopupMenuTheme extends InheritedTheme {
  const PopupMenuTheme({required this.data, required super.child, super.key});

  final PopupMenuThemeData data;

  static PopupMenuThemeData of(BuildContext context) {
    final PopupMenuTheme? popupMenuTheme = context.dependOnInheritedWidgetOfExactType<PopupMenuTheme>();
    return popupMenuTheme?.data ?? Theme.of(context).popupMenuTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) => PopupMenuTheme(data: data, child: child);

  @override
  bool updateShouldNotify(PopupMenuTheme oldWidget) => data != oldWidget.data;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<PopupMenuThemeData>('data', data));
  }
}
