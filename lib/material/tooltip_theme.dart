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
class TooltipThemeData with Diagnosticable {
  const TooltipThemeData({
    this.height,
    this.padding,
    this.margin,
    this.verticalOffset,
    this.preferBelow,
    this.excludeFromSemantics,
    this.decoration,
    this.textStyle,
    this.textAlign,
    this.waitDuration,
    this.showDuration,
    this.exitDuration,
    this.triggerMode,
    this.enableFeedback,
  });

  final double? height;

  final EdgeInsetsGeometry? padding;

  final EdgeInsetsGeometry? margin;

  final double? verticalOffset;

  final bool? preferBelow;

  final bool? excludeFromSemantics;

  final Decoration? decoration;

  final TextStyle? textStyle;

  final TextAlign? textAlign;

  final Duration? waitDuration;

  final Duration? showDuration;

  final Duration? exitDuration;

  final TooltipTriggerMode? triggerMode;

  final bool? enableFeedback;

  TooltipThemeData copyWith({
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? verticalOffset,
    bool? preferBelow,
    bool? excludeFromSemantics,
    Decoration? decoration,
    TextStyle? textStyle,
    TextAlign? textAlign,
    Duration? waitDuration,
    Duration? showDuration,
    Duration? exitDuration,
    TooltipTriggerMode? triggerMode,
    bool? enableFeedback,
  }) => TooltipThemeData(
    height: height ?? this.height,
    padding: padding ?? this.padding,
    margin: margin ?? this.margin,
    verticalOffset: verticalOffset ?? this.verticalOffset,
    preferBelow: preferBelow ?? this.preferBelow,
    excludeFromSemantics: excludeFromSemantics ?? this.excludeFromSemantics,
    decoration: decoration ?? this.decoration,
    textStyle: textStyle ?? this.textStyle,
    textAlign: textAlign ?? this.textAlign,
    waitDuration: waitDuration ?? this.waitDuration,
    showDuration: showDuration ?? this.showDuration,
    triggerMode: triggerMode ?? this.triggerMode,
    enableFeedback: enableFeedback ?? this.enableFeedback,
  );

  static TooltipThemeData? lerp(TooltipThemeData? a, TooltipThemeData? b, double t) {
    if (identical(a, b)) {
      return a;
    }
    return TooltipThemeData(
      height: lerpDouble(a?.height, b?.height, t),
      padding: EdgeInsetsGeometry.lerp(a?.padding, b?.padding, t),
      margin: EdgeInsetsGeometry.lerp(a?.margin, b?.margin, t),
      verticalOffset: lerpDouble(a?.verticalOffset, b?.verticalOffset, t),
      preferBelow: t < 0.5 ? a?.preferBelow : b?.preferBelow,
      excludeFromSemantics: t < 0.5 ? a?.excludeFromSemantics : b?.excludeFromSemantics,
      decoration: Decoration.lerp(a?.decoration, b?.decoration, t),
      textStyle: TextStyle.lerp(a?.textStyle, b?.textStyle, t),
      textAlign: t < 0.5 ? a?.textAlign : b?.textAlign,
    );
  }

  @override
  int get hashCode => Object.hash(
    height,
    padding,
    margin,
    verticalOffset,
    preferBelow,
    excludeFromSemantics,
    decoration,
    textStyle,
    textAlign,
    waitDuration,
    showDuration,
    exitDuration,
    triggerMode,
    enableFeedback,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is TooltipThemeData &&
        other.height == height &&
        other.padding == padding &&
        other.margin == margin &&
        other.verticalOffset == verticalOffset &&
        other.preferBelow == preferBelow &&
        other.excludeFromSemantics == excludeFromSemantics &&
        other.decoration == decoration &&
        other.textStyle == textStyle &&
        other.textAlign == textAlign &&
        other.waitDuration == waitDuration &&
        other.showDuration == showDuration &&
        other.exitDuration == exitDuration &&
        other.triggerMode == triggerMode &&
        other.enableFeedback == enableFeedback;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('height', height, defaultValue: null))
      ..add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding, defaultValue: null))
      ..add(DiagnosticsProperty<EdgeInsetsGeometry>('margin', margin, defaultValue: null))
      ..add(DoubleProperty('vertical offset', verticalOffset, defaultValue: null))
      ..add(FlagProperty('position', value: preferBelow, ifTrue: 'below', ifFalse: 'above', showName: true))
      ..add(FlagProperty('semantics', value: excludeFromSemantics, ifTrue: 'excluded', showName: true))
      ..add(DiagnosticsProperty<Decoration>('decoration', decoration, defaultValue: null))
      ..add(DiagnosticsProperty<TextStyle>('textStyle', textStyle, defaultValue: null))
      ..add(DiagnosticsProperty<TextAlign>('textAlign', textAlign, defaultValue: null))
      ..add(DiagnosticsProperty<Duration>('wait duration', waitDuration, defaultValue: null))
      ..add(DiagnosticsProperty<Duration>('show duration', showDuration, defaultValue: null))
      ..add(DiagnosticsProperty<Duration>('exit duration', exitDuration, defaultValue: null))
      ..add(DiagnosticsProperty<TooltipTriggerMode>('triggerMode', triggerMode, defaultValue: null))
      ..add(FlagProperty('enableFeedback', value: enableFeedback, ifTrue: 'true', showName: true));
  }
}

class TooltipTheme extends InheritedTheme {
  const TooltipTheme({required this.data, required super.child, super.key});

  final TooltipThemeData data;

  static TooltipThemeData of(BuildContext context) {
    final TooltipTheme? tooltipTheme = context.dependOnInheritedWidgetOfExactType<TooltipTheme>();
    return tooltipTheme?.data ?? Theme.of(context).tooltipTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) => TooltipTheme(data: data, child: child);

  @override
  bool updateShouldNotify(TooltipTheme oldWidget) => data != oldWidget.data;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TooltipThemeData>('data', data));
  }
}

enum TooltipTriggerMode { manual, longPress, tap }
