// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/ink_well.dart';
import 'package:waveui/material/tabs.dart';
import 'package:waveui/material/theme.dart';

@immutable
class TabBarTheme extends InheritedTheme with Diagnosticable {
  const TabBarTheme({
    super.key,
    Decoration? indicator,
    Color? indicatorColor,
    TabBarIndicatorSize? indicatorSize,
    Color? dividerColor,
    double? dividerHeight,
    Color? labelColor,
    EdgeInsetsGeometry? labelPadding,
    TextStyle? labelStyle,
    Color? unselectedLabelColor,
    TextStyle? unselectedLabelStyle,
    WidgetStateProperty<Color?>? overlayColor,
    InteractiveInkFeatureFactory? splashFactory,
    WidgetStateProperty<MouseCursor?>? mouseCursor,
    TabAlignment? tabAlignment,
    TextScaler? textScaler,
    TabIndicatorAnimation? indicatorAnimation,
    TabBarThemeData? data,
    Widget? child,
  }) : assert(
         data == null ||
             (indicator ??
                     indicatorColor ??
                     indicatorSize ??
                     dividerColor ??
                     dividerHeight ??
                     labelColor ??
                     labelPadding ??
                     labelStyle ??
                     unselectedLabelColor ??
                     unselectedLabelStyle ??
                     overlayColor ??
                     splashFactory ??
                     mouseCursor ??
                     tabAlignment ??
                     textScaler ??
                     indicatorAnimation) ==
                 null,
       ),
       _indicator = indicator,
       _indicatorColor = indicatorColor,
       _indicatorSize = indicatorSize,
       _dividerColor = dividerColor,
       _dividerHeight = dividerHeight,
       _labelColor = labelColor,
       _labelPadding = labelPadding,
       _labelStyle = labelStyle,
       _unselectedLabelColor = unselectedLabelColor,
       _unselectedLabelStyle = unselectedLabelStyle,
       _overlayColor = overlayColor,
       _splashFactory = splashFactory,
       _mouseCursor = mouseCursor,
       _tabAlignment = tabAlignment,
       _textScaler = textScaler,
       _indicatorAnimation = indicatorAnimation,
       _data = data,
       super(child: child ?? const SizedBox());

  final TabBarThemeData? _data;
  final Decoration? _indicator;
  final Color? _indicatorColor;
  final TabBarIndicatorSize? _indicatorSize;
  final Color? _dividerColor;
  final double? _dividerHeight;
  final Color? _labelColor;
  final EdgeInsetsGeometry? _labelPadding;
  final TextStyle? _labelStyle;
  final Color? _unselectedLabelColor;
  final TextStyle? _unselectedLabelStyle;
  final WidgetStateProperty<Color?>? _overlayColor;
  final InteractiveInkFeatureFactory? _splashFactory;
  final WidgetStateProperty<MouseCursor?>? _mouseCursor;
  final TabAlignment? _tabAlignment;
  final TextScaler? _textScaler;
  final TabIndicatorAnimation? _indicatorAnimation;

  Decoration? get indicator => _data != null ? _data.indicator : _indicator;

  Color? get indicatorColor => _data != null ? _data.indicatorColor : _indicatorColor;

  TabBarIndicatorSize? get indicatorSize => _data != null ? _data.indicatorSize : _indicatorSize;

  Color? get dividerColor => _data != null ? _data.dividerColor : _dividerColor;

  double? get dividerHeight => _data != null ? _data.dividerHeight : _dividerHeight;

  Color? get labelColor => _data != null ? _data.labelColor : _labelColor;

  EdgeInsetsGeometry? get labelPadding => _data != null ? _data.labelPadding : _labelPadding;

  TextStyle? get labelStyle => _data != null ? _data.labelStyle : _labelStyle;

  Color? get unselectedLabelColor => _data != null ? _data.unselectedLabelColor : _unselectedLabelColor;

  TextStyle? get unselectedLabelStyle => _data != null ? _data.unselectedLabelStyle : _unselectedLabelStyle;

  WidgetStateProperty<Color?>? get overlayColor => _data != null ? _data.overlayColor : _overlayColor;

  InteractiveInkFeatureFactory? get splashFactory => _data != null ? _data.splashFactory : _splashFactory;

  WidgetStateProperty<MouseCursor?>? get mouseCursor => _data != null ? _data.mouseCursor : _mouseCursor;

  TabAlignment? get tabAlignment => _data != null ? _data.tabAlignment : _tabAlignment;

  TextScaler? get textScaler => _data != null ? _data.textScaler : _textScaler;

  TabIndicatorAnimation? get indicatorAnimation => _data != null ? _data.indicatorAnimation : _indicatorAnimation;

  TabBarThemeData get data =>
      _data ??
      TabBarThemeData(
        indicator: _indicator,
        indicatorColor: _indicatorColor,
        indicatorSize: _indicatorSize,
        dividerColor: _dividerColor,
        dividerHeight: _dividerHeight,
        labelColor: _labelColor,
        labelPadding: _labelPadding,
        labelStyle: _labelStyle,
        unselectedLabelColor: _unselectedLabelColor,
        unselectedLabelStyle: _unselectedLabelStyle,
        overlayColor: _overlayColor,
        splashFactory: _splashFactory,
        mouseCursor: _mouseCursor,
        tabAlignment: _tabAlignment,
        textScaler: _textScaler,
        indicatorAnimation: _indicatorAnimation,
      );

  TabBarTheme copyWith({
    Decoration? indicator,
    Color? indicatorColor,
    TabBarIndicatorSize? indicatorSize,
    Color? dividerColor,
    double? dividerHeight,
    Color? labelColor,
    EdgeInsetsGeometry? labelPadding,
    TextStyle? labelStyle,
    Color? unselectedLabelColor,
    TextStyle? unselectedLabelStyle,
    WidgetStateProperty<Color?>? overlayColor,
    InteractiveInkFeatureFactory? splashFactory,
    WidgetStateProperty<MouseCursor?>? mouseCursor,
    TabAlignment? tabAlignment,
    TextScaler? textScaler,
    TabIndicatorAnimation? indicatorAnimation,
  }) => TabBarTheme(
    indicator: indicator ?? this.indicator,
    indicatorColor: indicatorColor ?? this.indicatorColor,
    indicatorSize: indicatorSize ?? this.indicatorSize,
    dividerColor: dividerColor ?? this.dividerColor,
    dividerHeight: dividerHeight ?? this.dividerHeight,
    labelColor: labelColor ?? this.labelColor,
    labelPadding: labelPadding ?? this.labelPadding,
    labelStyle: labelStyle ?? this.labelStyle,
    unselectedLabelColor: unselectedLabelColor ?? this.unselectedLabelColor,
    unselectedLabelStyle: unselectedLabelStyle ?? this.unselectedLabelStyle,
    overlayColor: overlayColor ?? this.overlayColor,
    splashFactory: splashFactory ?? this.splashFactory,
    mouseCursor: mouseCursor ?? this.mouseCursor,
    tabAlignment: tabAlignment ?? this.tabAlignment,
    textScaler: textScaler ?? this.textScaler,
    indicatorAnimation: indicatorAnimation ?? this.indicatorAnimation,
  );

  static TabBarThemeData of(BuildContext context) {
    final TabBarTheme? tabBarTheme = context.dependOnInheritedWidgetOfExactType<TabBarTheme>();
    return tabBarTheme?.data ?? Theme.of(context).tabBarTheme;
  }

  static TabBarTheme lerp(TabBarTheme a, TabBarTheme b, double t) {
    if (identical(a, b)) {
      return a;
    }
    return TabBarTheme(
      indicator: Decoration.lerp(a.indicator, b.indicator, t),
      indicatorColor: Color.lerp(a.indicatorColor, b.indicatorColor, t),
      indicatorSize: t < 0.5 ? a.indicatorSize : b.indicatorSize,
      dividerColor: Color.lerp(a.dividerColor, b.dividerColor, t),
      dividerHeight: t < 0.5 ? a.dividerHeight : b.dividerHeight,
      labelColor: Color.lerp(a.labelColor, b.labelColor, t),
      labelPadding: EdgeInsetsGeometry.lerp(a.labelPadding, b.labelPadding, t),
      labelStyle: TextStyle.lerp(a.labelStyle, b.labelStyle, t),
      unselectedLabelColor: Color.lerp(a.unselectedLabelColor, b.unselectedLabelColor, t),
      unselectedLabelStyle: TextStyle.lerp(a.unselectedLabelStyle, b.unselectedLabelStyle, t),
      overlayColor: WidgetStateProperty.lerp<Color?>(a.overlayColor, b.overlayColor, t, Color.lerp),
      splashFactory: t < 0.5 ? a.splashFactory : b.splashFactory,
      mouseCursor: t < 0.5 ? a.mouseCursor : b.mouseCursor,
      tabAlignment: t < 0.5 ? a.tabAlignment : b.tabAlignment,
      textScaler: t < 0.5 ? a.textScaler : b.textScaler,
      indicatorAnimation: t < 0.5 ? a.indicatorAnimation : b.indicatorAnimation,
    );
  }

  @override
  bool updateShouldNotify(TabBarTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) => TabBarTheme(data: data, child: child);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Decoration?>('indicator', indicator));
    properties.add(ColorProperty('indicatorColor', indicatorColor));
    properties.add(EnumProperty<TabBarIndicatorSize?>('indicatorSize', indicatorSize));
    properties.add(ColorProperty('dividerColor', dividerColor));
    properties.add(DoubleProperty('dividerHeight', dividerHeight));
    properties.add(ColorProperty('labelColor', labelColor));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('labelPadding', labelPadding));
    properties.add(DiagnosticsProperty<TextStyle?>('labelStyle', labelStyle));
    properties.add(ColorProperty('unselectedLabelColor', unselectedLabelColor));
    properties.add(DiagnosticsProperty<TextStyle?>('unselectedLabelStyle', unselectedLabelStyle));
    properties.add(DiagnosticsProperty<WidgetStateProperty<Color?>?>('overlayColor', overlayColor));
    properties.add(DiagnosticsProperty<InteractiveInkFeatureFactory?>('splashFactory', splashFactory));
    properties.add(DiagnosticsProperty<WidgetStateProperty<MouseCursor?>?>('mouseCursor', mouseCursor));
    properties.add(EnumProperty<TabAlignment?>('tabAlignment', tabAlignment));
    properties.add(DiagnosticsProperty<TextScaler?>('textScaler', textScaler));
    properties.add(EnumProperty<TabIndicatorAnimation?>('indicatorAnimation', indicatorAnimation));
    properties.add(DiagnosticsProperty<TabBarThemeData>('data', data));
  }
}

@immutable
class TabBarThemeData with Diagnosticable {
  const TabBarThemeData({
    this.indicator,
    this.indicatorColor,
    this.indicatorSize,
    this.dividerColor,
    this.dividerHeight,
    this.labelColor,
    this.labelPadding,
    this.labelStyle,
    this.unselectedLabelColor,
    this.unselectedLabelStyle,
    this.overlayColor,
    this.splashFactory,
    this.mouseCursor,
    this.tabAlignment,
    this.textScaler,
    this.indicatorAnimation,
    this.splashBorderRadius,
  });

  final Decoration? indicator;

  final Color? indicatorColor;

  final TabBarIndicatorSize? indicatorSize;

  final Color? dividerColor;

  final double? dividerHeight;

  final Color? labelColor;

  final EdgeInsetsGeometry? labelPadding;

  final TextStyle? labelStyle;

  final Color? unselectedLabelColor;

  final TextStyle? unselectedLabelStyle;

  final WidgetStateProperty<Color?>? overlayColor;

  final InteractiveInkFeatureFactory? splashFactory;

  final WidgetStateProperty<MouseCursor?>? mouseCursor;

  final TabAlignment? tabAlignment;

  final TextScaler? textScaler;

  final TabIndicatorAnimation? indicatorAnimation;

  final BorderRadius? splashBorderRadius;

  TabBarThemeData copyWith({
    Decoration? indicator,
    Color? indicatorColor,
    TabBarIndicatorSize? indicatorSize,
    Color? dividerColor,
    double? dividerHeight,
    Color? labelColor,
    EdgeInsetsGeometry? labelPadding,
    TextStyle? labelStyle,
    Color? unselectedLabelColor,
    TextStyle? unselectedLabelStyle,
    WidgetStateProperty<Color?>? overlayColor,
    InteractiveInkFeatureFactory? splashFactory,
    WidgetStateProperty<MouseCursor?>? mouseCursor,
    TabAlignment? tabAlignment,
    TextScaler? textScaler,
    TabIndicatorAnimation? indicatorAnimation,
    BorderRadius? splashBorderRadius,
  }) => TabBarThemeData(
    indicator: indicator ?? this.indicator,
    indicatorColor: indicatorColor ?? this.indicatorColor,
    indicatorSize: indicatorSize ?? this.indicatorSize,
    dividerColor: dividerColor ?? this.dividerColor,
    dividerHeight: dividerHeight ?? this.dividerHeight,
    labelColor: labelColor ?? this.labelColor,
    labelPadding: labelPadding ?? this.labelPadding,
    labelStyle: labelStyle ?? this.labelStyle,
    unselectedLabelColor: unselectedLabelColor ?? this.unselectedLabelColor,
    unselectedLabelStyle: unselectedLabelStyle ?? this.unselectedLabelStyle,
    overlayColor: overlayColor ?? this.overlayColor,
    splashFactory: splashFactory ?? this.splashFactory,
    mouseCursor: mouseCursor ?? this.mouseCursor,
    tabAlignment: tabAlignment ?? this.tabAlignment,
    textScaler: textScaler ?? this.textScaler,
    indicatorAnimation: indicatorAnimation ?? this.indicatorAnimation,
    splashBorderRadius: splashBorderRadius ?? this.splashBorderRadius,
  );

  static TabBarThemeData lerp(TabBarThemeData a, TabBarThemeData b, double t) {
    if (identical(a, b)) {
      return a;
    }
    return TabBarThemeData(
      indicator: Decoration.lerp(a.indicator, b.indicator, t),
      indicatorColor: Color.lerp(a.indicatorColor, b.indicatorColor, t),
      indicatorSize: t < 0.5 ? a.indicatorSize : b.indicatorSize,
      dividerColor: Color.lerp(a.dividerColor, b.dividerColor, t),
      dividerHeight: t < 0.5 ? a.dividerHeight : b.dividerHeight,
      labelColor: Color.lerp(a.labelColor, b.labelColor, t),
      labelPadding: EdgeInsetsGeometry.lerp(a.labelPadding, b.labelPadding, t),
      labelStyle: TextStyle.lerp(a.labelStyle, b.labelStyle, t),
      unselectedLabelColor: Color.lerp(a.unselectedLabelColor, b.unselectedLabelColor, t),
      unselectedLabelStyle: TextStyle.lerp(a.unselectedLabelStyle, b.unselectedLabelStyle, t),
      overlayColor: WidgetStateProperty.lerp<Color?>(a.overlayColor, b.overlayColor, t, Color.lerp),
      splashFactory: t < 0.5 ? a.splashFactory : b.splashFactory,
      mouseCursor: t < 0.5 ? a.mouseCursor : b.mouseCursor,
      tabAlignment: t < 0.5 ? a.tabAlignment : b.tabAlignment,
      textScaler: t < 0.5 ? a.textScaler : b.textScaler,
      indicatorAnimation: t < 0.5 ? a.indicatorAnimation : b.indicatorAnimation,
      splashBorderRadius: BorderRadius.lerp(a.splashBorderRadius, a.splashBorderRadius, t),
    );
  }

  @override
  int get hashCode => Object.hash(
    indicator,
    indicatorColor,
    indicatorSize,
    dividerColor,
    dividerHeight,
    labelColor,
    labelPadding,
    labelStyle,
    unselectedLabelColor,
    unselectedLabelStyle,
    overlayColor,
    splashFactory,
    mouseCursor,
    tabAlignment,
    textScaler,
    indicatorAnimation,
    splashBorderRadius,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is TabBarThemeData &&
        other.indicator == indicator &&
        other.indicatorColor == indicatorColor &&
        other.indicatorSize == indicatorSize &&
        other.dividerColor == dividerColor &&
        other.dividerHeight == dividerHeight &&
        other.labelColor == labelColor &&
        other.labelPadding == labelPadding &&
        other.labelStyle == labelStyle &&
        other.unselectedLabelColor == unselectedLabelColor &&
        other.unselectedLabelStyle == unselectedLabelStyle &&
        other.overlayColor == overlayColor &&
        other.splashFactory == splashFactory &&
        other.mouseCursor == mouseCursor &&
        other.tabAlignment == tabAlignment &&
        other.textScaler == textScaler &&
        other.indicatorAnimation == indicatorAnimation &&
        other.splashBorderRadius == splashBorderRadius;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Decoration?>('indicator', indicator, defaultValue: null));
    properties.add(DiagnosticsProperty<Color?>('indicatorColor', indicatorColor, defaultValue: null));
    properties.add(DiagnosticsProperty<TabBarIndicatorSize?>('indicatorSize', indicatorSize, defaultValue: null));
    properties.add(DiagnosticsProperty<Color?>('dividerColor', dividerColor, defaultValue: null));
    properties.add(DiagnosticsProperty<double?>('dividerHeight', dividerHeight, defaultValue: null));
    properties.add(DiagnosticsProperty<Color?>('labelColor', labelColor, defaultValue: null));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('labelPadding', labelPadding, defaultValue: null));
    properties.add(DiagnosticsProperty<TextStyle?>('labelStyle', labelStyle, defaultValue: null));
    properties.add(DiagnosticsProperty<Color?>('unselectedLabelColor', unselectedLabelColor, defaultValue: null));
    properties.add(DiagnosticsProperty<TextStyle?>('unselectedLabelStyle', unselectedLabelStyle, defaultValue: null));
    properties.add(DiagnosticsProperty<WidgetStateProperty<Color?>?>('overlayColor', overlayColor, defaultValue: null));
    properties.add(
      DiagnosticsProperty<InteractiveInkFeatureFactory?>('splashFactory', splashFactory, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty<WidgetStateProperty<MouseCursor?>?>('mouseCursor', mouseCursor, defaultValue: null),
    );
    properties.add(DiagnosticsProperty<TabAlignment?>('tabAlignment', tabAlignment, defaultValue: null));
    properties.add(DiagnosticsProperty<TextScaler?>('textScaler', textScaler, defaultValue: null));
    properties.add(
      DiagnosticsProperty<TabIndicatorAnimation?>('indicatorAnimation', indicatorAnimation, defaultValue: null),
    );
    properties.add(DiagnosticsProperty<BorderRadius?>('splashBorderRadius', splashBorderRadius, defaultValue: null));
  }
}
