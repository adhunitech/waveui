// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/theme.dart';

// Examples can assume:
// late BuildContext context;

@immutable
class SearchBarThemeData with Diagnosticable {
  const SearchBarThemeData({
    this.elevation,
    this.backgroundColor,
    this.shadowColor,
    this.surfaceTintColor,
    this.overlayColor,
    this.side,
    this.shape,
    this.padding,
    this.textStyle,
    this.hintStyle,
    this.constraints,
    this.textCapitalization,
  });

  final WidgetStateProperty<double?>? elevation;

  final WidgetStateProperty<Color?>? backgroundColor;

  final WidgetStateProperty<Color?>? shadowColor;

  final WidgetStateProperty<Color?>? surfaceTintColor;

  final WidgetStateProperty<Color?>? overlayColor;

  final WidgetStateProperty<BorderSide?>? side;

  final WidgetStateProperty<OutlinedBorder?>? shape;

  final WidgetStateProperty<EdgeInsetsGeometry?>? padding;

  final WidgetStateProperty<TextStyle?>? textStyle;

  final WidgetStateProperty<TextStyle?>? hintStyle;

  final BoxConstraints? constraints;

  final TextCapitalization? textCapitalization;

  SearchBarThemeData copyWith({
    WidgetStateProperty<double?>? elevation,
    WidgetStateProperty<Color?>? backgroundColor,
    WidgetStateProperty<Color?>? shadowColor,
    WidgetStateProperty<Color?>? surfaceTintColor,
    WidgetStateProperty<Color?>? overlayColor,
    WidgetStateProperty<BorderSide?>? side,
    WidgetStateProperty<OutlinedBorder?>? shape,
    WidgetStateProperty<EdgeInsetsGeometry?>? padding,
    WidgetStateProperty<TextStyle?>? textStyle,
    WidgetStateProperty<TextStyle?>? hintStyle,
    BoxConstraints? constraints,
    TextCapitalization? textCapitalization,
  }) => SearchBarThemeData(
    elevation: elevation ?? this.elevation,
    backgroundColor: backgroundColor ?? this.backgroundColor,
    shadowColor: shadowColor ?? this.shadowColor,
    surfaceTintColor: surfaceTintColor ?? this.surfaceTintColor,
    overlayColor: overlayColor ?? this.overlayColor,
    side: side ?? this.side,
    shape: shape ?? this.shape,
    padding: padding ?? this.padding,
    textStyle: textStyle ?? this.textStyle,
    hintStyle: hintStyle ?? this.hintStyle,
    constraints: constraints ?? this.constraints,
    textCapitalization: textCapitalization ?? this.textCapitalization,
  );

  static SearchBarThemeData? lerp(SearchBarThemeData? a, SearchBarThemeData? b, double t) {
    if (identical(a, b)) {
      return a;
    }
    return SearchBarThemeData(
      elevation: WidgetStateProperty.lerp<double?>(a?.elevation, b?.elevation, t, lerpDouble),
      backgroundColor: WidgetStateProperty.lerp<Color?>(a?.backgroundColor, b?.backgroundColor, t, Color.lerp),
      shadowColor: WidgetStateProperty.lerp<Color?>(a?.shadowColor, b?.shadowColor, t, Color.lerp),
      surfaceTintColor: WidgetStateProperty.lerp<Color?>(a?.surfaceTintColor, b?.surfaceTintColor, t, Color.lerp),
      overlayColor: WidgetStateProperty.lerp<Color?>(a?.overlayColor, b?.overlayColor, t, Color.lerp),
      side: _lerpSides(a?.side, b?.side, t),
      shape: WidgetStateProperty.lerp<OutlinedBorder?>(a?.shape, b?.shape, t, OutlinedBorder.lerp),
      padding: WidgetStateProperty.lerp<EdgeInsetsGeometry?>(a?.padding, b?.padding, t, EdgeInsetsGeometry.lerp),
      textStyle: WidgetStateProperty.lerp<TextStyle?>(a?.textStyle, b?.textStyle, t, TextStyle.lerp),
      hintStyle: WidgetStateProperty.lerp<TextStyle?>(a?.hintStyle, b?.hintStyle, t, TextStyle.lerp),
      constraints: BoxConstraints.lerp(a?.constraints, b?.constraints, t),
      textCapitalization: t < 0.5 ? a?.textCapitalization : b?.textCapitalization,
    );
  }

  @override
  int get hashCode => Object.hash(
    elevation,
    backgroundColor,
    shadowColor,
    surfaceTintColor,
    overlayColor,
    side,
    shape,
    padding,
    textStyle,
    hintStyle,
    constraints,
    textCapitalization,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is SearchBarThemeData &&
        other.elevation == elevation &&
        other.backgroundColor == backgroundColor &&
        other.shadowColor == shadowColor &&
        other.surfaceTintColor == surfaceTintColor &&
        other.overlayColor == overlayColor &&
        other.side == side &&
        other.shape == shape &&
        other.padding == padding &&
        other.textStyle == textStyle &&
        other.hintStyle == hintStyle &&
        other.constraints == constraints &&
        other.textCapitalization == textCapitalization;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<WidgetStateProperty<double?>>('elevation', elevation, defaultValue: null));
    properties.add(
      DiagnosticsProperty<WidgetStateProperty<Color?>>('backgroundColor', backgroundColor, defaultValue: null),
    );
    properties.add(DiagnosticsProperty<WidgetStateProperty<Color?>>('shadowColor', shadowColor, defaultValue: null));
    properties.add(
      DiagnosticsProperty<WidgetStateProperty<Color?>>('surfaceTintColor', surfaceTintColor, defaultValue: null),
    );
    properties.add(DiagnosticsProperty<WidgetStateProperty<Color?>>('overlayColor', overlayColor, defaultValue: null));
    properties.add(DiagnosticsProperty<WidgetStateProperty<BorderSide?>>('side', side, defaultValue: null));
    properties.add(DiagnosticsProperty<WidgetStateProperty<OutlinedBorder?>>('shape', shape, defaultValue: null));
    properties.add(
      DiagnosticsProperty<WidgetStateProperty<EdgeInsetsGeometry?>>('padding', padding, defaultValue: null),
    );
    properties.add(DiagnosticsProperty<WidgetStateProperty<TextStyle?>>('textStyle', textStyle, defaultValue: null));
    properties.add(DiagnosticsProperty<WidgetStateProperty<TextStyle?>>('hintStyle', hintStyle, defaultValue: null));
    properties.add(DiagnosticsProperty<BoxConstraints>('constraints', constraints, defaultValue: null));
    properties.add(
      DiagnosticsProperty<TextCapitalization>('textCapitalization', textCapitalization, defaultValue: null),
    );
  }

  // Special case because BorderSide.lerp() doesn't support null arguments
  static WidgetStateProperty<BorderSide?>? _lerpSides(
    WidgetStateProperty<BorderSide?>? a,
    WidgetStateProperty<BorderSide?>? b,
    double t,
  ) {
    if (identical(a, b)) {
      return a;
    }
    return WidgetStateBorderSide.lerp(a, b, t);
  }
}

class SearchBarTheme extends InheritedWidget {
  const SearchBarTheme({required this.data, required super.child, super.key});

  final SearchBarThemeData data;

  static SearchBarThemeData of(BuildContext context) {
    final SearchBarTheme? searchBarTheme = context.dependOnInheritedWidgetOfExactType<SearchBarTheme>();
    return searchBarTheme?.data ?? Theme.of(context).searchBarTheme;
  }

  @override
  bool updateShouldNotify(SearchBarTheme oldWidget) => data != oldWidget.data;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SearchBarThemeData>('data', data));
  }
}
