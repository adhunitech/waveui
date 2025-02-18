// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/theme.dart';

// Examples can assume:
// late BuildContext context;

@immutable
class SearchViewThemeData with Diagnosticable {
  const SearchViewThemeData({
    this.backgroundColor,
    this.elevation,
    this.surfaceTintColor,
    this.constraints,
    this.padding,
    this.barPadding,
    this.shrinkWrap,
    this.side,
    this.shape,
    this.headerHeight,
    this.headerTextStyle,
    this.headerHintStyle,
    this.dividerColor,
  });

  final Color? backgroundColor;

  final double? elevation;

  final Color? surfaceTintColor;

  final BorderSide? side;

  final OutlinedBorder? shape;

  final double? headerHeight;

  final TextStyle? headerTextStyle;

  final TextStyle? headerHintStyle;

  final BoxConstraints? constraints;

  final EdgeInsetsGeometry? padding;

  final EdgeInsetsGeometry? barPadding;

  final bool? shrinkWrap;

  final Color? dividerColor;

  SearchViewThemeData copyWith({
    Color? backgroundColor,
    double? elevation,
    Color? surfaceTintColor,
    BorderSide? side,
    OutlinedBorder? shape,
    double? headerHeight,
    TextStyle? headerTextStyle,
    TextStyle? headerHintStyle,
    BoxConstraints? constraints,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? barPadding,
    bool? shrinkWrap,
    Color? dividerColor,
  }) => SearchViewThemeData(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    elevation: elevation ?? this.elevation,
    surfaceTintColor: surfaceTintColor ?? this.surfaceTintColor,
    side: side ?? this.side,
    shape: shape ?? this.shape,
    headerHeight: headerHeight ?? this.headerHeight,
    headerTextStyle: headerTextStyle ?? this.headerTextStyle,
    headerHintStyle: headerHintStyle ?? this.headerHintStyle,
    constraints: constraints ?? this.constraints,
    padding: padding ?? this.padding,
    barPadding: barPadding ?? this.barPadding,
    shrinkWrap: shrinkWrap ?? this.shrinkWrap,
    dividerColor: dividerColor ?? this.dividerColor,
  );

  static SearchViewThemeData? lerp(SearchViewThemeData? a, SearchViewThemeData? b, double t) {
    if (identical(a, b)) {
      return a;
    }
    return SearchViewThemeData(
      backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t),
      elevation: lerpDouble(a?.elevation, b?.elevation, t),
      surfaceTintColor: Color.lerp(a?.surfaceTintColor, b?.surfaceTintColor, t),
      side: _lerpSides(a?.side, b?.side, t),
      shape: OutlinedBorder.lerp(a?.shape, b?.shape, t),
      headerHeight: lerpDouble(a?.headerHeight, b?.headerHeight, t),
      headerTextStyle: TextStyle.lerp(a?.headerTextStyle, b?.headerTextStyle, t),
      headerHintStyle: TextStyle.lerp(a?.headerTextStyle, b?.headerTextStyle, t),
      constraints: BoxConstraints.lerp(a?.constraints, b?.constraints, t),
      padding: EdgeInsetsGeometry.lerp(a?.padding, b?.padding, t),
      barPadding: EdgeInsetsGeometry.lerp(a?.barPadding, b?.barPadding, t),
      shrinkWrap: t < 0.5 ? a?.shrinkWrap : b?.shrinkWrap,
      dividerColor: Color.lerp(a?.dividerColor, b?.dividerColor, t),
    );
  }

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    elevation,
    surfaceTintColor,
    side,
    shape,
    headerHeight,
    headerTextStyle,
    headerHintStyle,
    constraints,
    padding,
    barPadding,
    shrinkWrap,
    dividerColor,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is SearchViewThemeData &&
        other.backgroundColor == backgroundColor &&
        other.elevation == elevation &&
        other.surfaceTintColor == surfaceTintColor &&
        other.side == side &&
        other.shape == shape &&
        other.headerHeight == headerHeight &&
        other.headerTextStyle == headerTextStyle &&
        other.headerHintStyle == headerHintStyle &&
        other.constraints == constraints &&
        other.padding == padding &&
        other.barPadding == barPadding &&
        other.shrinkWrap == shrinkWrap &&
        other.dividerColor == dividerColor;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Color?>('backgroundColor', backgroundColor, defaultValue: null));
    properties.add(DiagnosticsProperty<double?>('elevation', elevation, defaultValue: null));
    properties.add(DiagnosticsProperty<Color?>('surfaceTintColor', surfaceTintColor, defaultValue: null));
    properties.add(DiagnosticsProperty<BorderSide?>('side', side, defaultValue: null));
    properties.add(DiagnosticsProperty<OutlinedBorder?>('shape', shape, defaultValue: null));
    properties.add(DiagnosticsProperty<double?>('headerHeight', headerHeight, defaultValue: null));
    properties.add(DiagnosticsProperty<TextStyle?>('headerTextStyle', headerTextStyle, defaultValue: null));
    properties.add(DiagnosticsProperty<TextStyle?>('headerHintStyle', headerHintStyle, defaultValue: null));
    properties.add(DiagnosticsProperty<BoxConstraints>('constraints', constraints, defaultValue: null));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('padding', padding, defaultValue: null));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('barPadding', barPadding, defaultValue: null));
    properties.add(DiagnosticsProperty<bool?>('shrinkWrap', shrinkWrap, defaultValue: null));
    properties.add(DiagnosticsProperty<Color?>('dividerColor', dividerColor, defaultValue: null));
  }

  // Special case because BorderSide.lerp() doesn't support null arguments
  static BorderSide? _lerpSides(BorderSide? a, BorderSide? b, double t) {
    if (a == null || b == null) {
      return null;
    }
    if (identical(a, b)) {
      return a;
    }
    return BorderSide.lerp(a, b, t);
  }
}

class SearchViewTheme extends InheritedTheme {
  const SearchViewTheme({required this.data, required super.child, super.key});

  final SearchViewThemeData data;

  static SearchViewThemeData of(BuildContext context) {
    final SearchViewTheme? searchViewTheme = context.dependOnInheritedWidgetOfExactType<SearchViewTheme>();
    return searchViewTheme?.data ?? Theme.of(context).searchViewTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) => SearchViewTheme(data: data, child: child);

  @override
  bool updateShouldNotify(SearchViewTheme oldWidget) => data != oldWidget.data;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SearchViewThemeData>('data', data));
  }
}
