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
class DataTableThemeData with Diagnosticable {
  const DataTableThemeData({
    this.decoration,
    this.dataRowColor,
    @Deprecated(
      'Migrate to use dataRowMinHeight and dataRowMaxHeight instead. '
      'This feature was deprecated after v3.7.0-5.0.pre.',
    )
    double? dataRowHeight,
    double? dataRowMinHeight,
    double? dataRowMaxHeight,
    this.dataTextStyle,
    this.headingRowColor,
    this.headingRowHeight,
    this.headingTextStyle,
    this.horizontalMargin,
    this.columnSpacing,
    this.dividerThickness,
    this.checkboxHorizontalMargin,
    this.headingCellCursor,
    this.dataRowCursor,
    this.headingRowAlignment,
  }) : assert(dataRowMinHeight == null || dataRowMaxHeight == null || dataRowMaxHeight >= dataRowMinHeight),
       assert(
         dataRowHeight == null || (dataRowMinHeight == null && dataRowMaxHeight == null),
         'dataRowHeight ($dataRowHeight) must not be set if dataRowMinHeight ($dataRowMinHeight) or dataRowMaxHeight ($dataRowMaxHeight) are set.',
       ),
       dataRowMinHeight = dataRowHeight ?? dataRowMinHeight,
       dataRowMaxHeight = dataRowHeight ?? dataRowMaxHeight;

  final Decoration? decoration;

  final WidgetStateProperty<Color?>? dataRowColor;

  @Deprecated(
    'Migrate to use dataRowMinHeight and dataRowMaxHeight instead. '
    'This feature was deprecated after v3.7.0-5.0.pre.',
  )
  double? get dataRowHeight => dataRowMinHeight == dataRowMaxHeight ? dataRowMinHeight : null;

  final double? dataRowMinHeight;

  final double? dataRowMaxHeight;

  final TextStyle? dataTextStyle;

  final WidgetStateProperty<Color?>? headingRowColor;

  final double? headingRowHeight;

  final TextStyle? headingTextStyle;

  final double? horizontalMargin;

  final double? columnSpacing;

  final double? dividerThickness;

  final double? checkboxHorizontalMargin;

  final WidgetStateProperty<MouseCursor?>? headingCellCursor;

  final WidgetStateProperty<MouseCursor?>? dataRowCursor;

  final MainAxisAlignment? headingRowAlignment;

  DataTableThemeData copyWith({
    Decoration? decoration,
    WidgetStateProperty<Color?>? dataRowColor,
    @Deprecated(
      'Migrate to use dataRowMinHeight and dataRowMaxHeight instead. '
      'This feature was deprecated after v3.7.0-5.0.pre.',
    )
    double? dataRowHeight,
    double? dataRowMinHeight,
    double? dataRowMaxHeight,
    TextStyle? dataTextStyle,
    WidgetStateProperty<Color?>? headingRowColor,
    double? headingRowHeight,
    TextStyle? headingTextStyle,
    double? horizontalMargin,
    double? columnSpacing,
    double? dividerThickness,
    double? checkboxHorizontalMargin,
    WidgetStateProperty<MouseCursor?>? headingCellCursor,
    WidgetStateProperty<MouseCursor?>? dataRowCursor,
    MainAxisAlignment? headingRowAlignment,
  }) {
    assert(
      dataRowHeight == null || (dataRowMinHeight == null && dataRowMaxHeight == null),
      'dataRowHeight ($dataRowHeight) must not be set if dataRowMinHeight ($dataRowMinHeight) or dataRowMaxHeight ($dataRowMaxHeight) are set.',
    );
    dataRowMinHeight = dataRowHeight ?? dataRowMinHeight;
    dataRowMaxHeight = dataRowHeight ?? dataRowMaxHeight;

    return DataTableThemeData(
      decoration: decoration ?? this.decoration,
      dataRowColor: dataRowColor ?? this.dataRowColor,
      dataRowMinHeight: dataRowMinHeight ?? this.dataRowMinHeight,
      dataRowMaxHeight: dataRowMaxHeight ?? this.dataRowMaxHeight,
      dataTextStyle: dataTextStyle ?? this.dataTextStyle,
      headingRowColor: headingRowColor ?? this.headingRowColor,
      headingRowHeight: headingRowHeight ?? this.headingRowHeight,
      headingTextStyle: headingTextStyle ?? this.headingTextStyle,
      horizontalMargin: horizontalMargin ?? this.horizontalMargin,
      columnSpacing: columnSpacing ?? this.columnSpacing,
      dividerThickness: dividerThickness ?? this.dividerThickness,
      checkboxHorizontalMargin: checkboxHorizontalMargin ?? this.checkboxHorizontalMargin,
      headingCellCursor: headingCellCursor ?? this.headingCellCursor,
      dataRowCursor: dataRowCursor ?? this.dataRowCursor,
      headingRowAlignment: headingRowAlignment ?? this.headingRowAlignment,
    );
  }

  static DataTableThemeData lerp(DataTableThemeData a, DataTableThemeData b, double t) {
    if (identical(a, b)) {
      return a;
    }
    return DataTableThemeData(
      decoration: Decoration.lerp(a.decoration, b.decoration, t),
      dataRowColor: WidgetStateProperty.lerp<Color?>(a.dataRowColor, b.dataRowColor, t, Color.lerp),
      dataRowMinHeight: lerpDouble(a.dataRowMinHeight, b.dataRowMinHeight, t),
      dataRowMaxHeight: lerpDouble(a.dataRowMaxHeight, b.dataRowMaxHeight, t),
      dataTextStyle: TextStyle.lerp(a.dataTextStyle, b.dataTextStyle, t),
      headingRowColor: WidgetStateProperty.lerp<Color?>(a.headingRowColor, b.headingRowColor, t, Color.lerp),
      headingRowHeight: lerpDouble(a.headingRowHeight, b.headingRowHeight, t),
      headingTextStyle: TextStyle.lerp(a.headingTextStyle, b.headingTextStyle, t),
      horizontalMargin: lerpDouble(a.horizontalMargin, b.horizontalMargin, t),
      columnSpacing: lerpDouble(a.columnSpacing, b.columnSpacing, t),
      dividerThickness: lerpDouble(a.dividerThickness, b.dividerThickness, t),
      checkboxHorizontalMargin: lerpDouble(a.checkboxHorizontalMargin, b.checkboxHorizontalMargin, t),
      headingCellCursor: t < 0.5 ? a.headingCellCursor : b.headingCellCursor,
      dataRowCursor: t < 0.5 ? a.dataRowCursor : b.dataRowCursor,
      headingRowAlignment: t < 0.5 ? a.headingRowAlignment : b.headingRowAlignment,
    );
  }

  @override
  int get hashCode => Object.hash(
    decoration,
    dataRowColor,
    dataRowMinHeight,
    dataRowMaxHeight,
    dataTextStyle,
    headingRowColor,
    headingRowHeight,
    headingTextStyle,
    horizontalMargin,
    columnSpacing,
    dividerThickness,
    checkboxHorizontalMargin,
    headingCellCursor,
    dataRowCursor,
    headingRowAlignment,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is DataTableThemeData &&
        other.decoration == decoration &&
        other.dataRowColor == dataRowColor &&
        other.dataRowMinHeight == dataRowMinHeight &&
        other.dataRowMaxHeight == dataRowMaxHeight &&
        other.dataTextStyle == dataTextStyle &&
        other.headingRowColor == headingRowColor &&
        other.headingRowHeight == headingRowHeight &&
        other.headingTextStyle == headingTextStyle &&
        other.horizontalMargin == horizontalMargin &&
        other.columnSpacing == columnSpacing &&
        other.dividerThickness == dividerThickness &&
        other.checkboxHorizontalMargin == checkboxHorizontalMargin &&
        other.headingCellCursor == headingCellCursor &&
        other.dataRowCursor == dataRowCursor &&
        other.headingRowAlignment == headingRowAlignment;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Decoration>('decoration', decoration, defaultValue: null));
    properties.add(DiagnosticsProperty<WidgetStateProperty<Color?>>('dataRowColor', dataRowColor, defaultValue: null));
    properties.add(DoubleProperty('dataRowMinHeight', dataRowMinHeight, defaultValue: null));
    properties.add(DoubleProperty('dataRowMaxHeight', dataRowMaxHeight, defaultValue: null));
    properties.add(DiagnosticsProperty<TextStyle>('dataTextStyle', dataTextStyle, defaultValue: null));
    properties.add(
      DiagnosticsProperty<WidgetStateProperty<Color?>>('headingRowColor', headingRowColor, defaultValue: null),
    );
    properties.add(DoubleProperty('headingRowHeight', headingRowHeight, defaultValue: null));
    properties.add(DiagnosticsProperty<TextStyle>('headingTextStyle', headingTextStyle, defaultValue: null));
    properties.add(DoubleProperty('horizontalMargin', horizontalMargin, defaultValue: null));
    properties.add(DoubleProperty('columnSpacing', columnSpacing, defaultValue: null));
    properties.add(DoubleProperty('dividerThickness', dividerThickness, defaultValue: null));
    properties.add(DoubleProperty('checkboxHorizontalMargin', checkboxHorizontalMargin, defaultValue: null));
    properties.add(
      DiagnosticsProperty<WidgetStateProperty<MouseCursor?>?>(
        'headingCellCursor',
        headingCellCursor,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<WidgetStateProperty<MouseCursor?>?>('dataRowCursor', dataRowCursor, defaultValue: null),
    );
    properties.add(EnumProperty<MainAxisAlignment>('headingRowAlignment', headingRowAlignment, defaultValue: null));
    properties.add(DoubleProperty('dataRowHeight', dataRowHeight));
  }
}

class DataTableTheme extends InheritedWidget {
  const DataTableTheme({required this.data, required super.child, super.key});

  final DataTableThemeData data;

  static DataTableThemeData of(BuildContext context) {
    final DataTableTheme? dataTableTheme = context.dependOnInheritedWidgetOfExactType<DataTableTheme>();
    return dataTableTheme?.data ?? Theme.of(context).dataTableTheme;
  }

  @override
  bool updateShouldNotify(DataTableTheme oldWidget) => data != oldWidget.data;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<DataTableThemeData>('data', data));
  }
}
