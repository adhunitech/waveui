// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/theme.dart';
import 'package:waveui/material/theme_data.dart';

// Examples can assume:
// late BuildContext context;

@immutable
class SwitchThemeData with Diagnosticable {
  const SwitchThemeData({
    this.thumbColor,
    this.trackColor,
    this.trackOutlineColor,
    this.trackOutlineWidth,
    this.materialTapTargetSize,
    this.mouseCursor,
    this.overlayColor,
    this.splashRadius,
    this.thumbIcon,
    this.padding,
  });

  final WidgetStateProperty<Color?>? thumbColor;

  final WidgetStateProperty<Color?>? trackColor;

  final WidgetStateProperty<Color?>? trackOutlineColor;

  final WidgetStateProperty<double?>? trackOutlineWidth;

  final MaterialTapTargetSize? materialTapTargetSize;

  final WidgetStateProperty<MouseCursor?>? mouseCursor;

  final WidgetStateProperty<Color?>? overlayColor;

  final double? splashRadius;

  final WidgetStateProperty<Icon?>? thumbIcon;

  final EdgeInsetsGeometry? padding;

  SwitchThemeData copyWith({
    WidgetStateProperty<Color?>? thumbColor,
    WidgetStateProperty<Color?>? trackColor,
    WidgetStateProperty<Color?>? trackOutlineColor,
    WidgetStateProperty<double?>? trackOutlineWidth,
    MaterialTapTargetSize? materialTapTargetSize,
    WidgetStateProperty<MouseCursor?>? mouseCursor,
    WidgetStateProperty<Color?>? overlayColor,
    double? splashRadius,
    WidgetStateProperty<Icon?>? thumbIcon,
    EdgeInsetsGeometry? padding,
  }) => SwitchThemeData(
    thumbColor: thumbColor ?? this.thumbColor,
    trackColor: trackColor ?? this.trackColor,
    trackOutlineColor: trackOutlineColor ?? this.trackOutlineColor,
    trackOutlineWidth: trackOutlineWidth ?? this.trackOutlineWidth,
    materialTapTargetSize: materialTapTargetSize ?? this.materialTapTargetSize,
    mouseCursor: mouseCursor ?? this.mouseCursor,
    overlayColor: overlayColor ?? this.overlayColor,
    splashRadius: splashRadius ?? this.splashRadius,
    thumbIcon: thumbIcon ?? this.thumbIcon,
    padding: padding ?? this.padding,
  );

  static SwitchThemeData lerp(SwitchThemeData? a, SwitchThemeData? b, double t) {
    if (identical(a, b) && a != null) {
      return a;
    }
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.lerp<Color?>(a?.thumbColor, b?.thumbColor, t, Color.lerp),
      trackColor: WidgetStateProperty.lerp<Color?>(a?.trackColor, b?.trackColor, t, Color.lerp),
      trackOutlineColor: WidgetStateProperty.lerp<Color?>(a?.trackOutlineColor, b?.trackOutlineColor, t, Color.lerp),
      trackOutlineWidth: WidgetStateProperty.lerp<double?>(a?.trackOutlineWidth, b?.trackOutlineWidth, t, lerpDouble),
      materialTapTargetSize: t < 0.5 ? a?.materialTapTargetSize : b?.materialTapTargetSize,
      mouseCursor: t < 0.5 ? a?.mouseCursor : b?.mouseCursor,
      overlayColor: WidgetStateProperty.lerp<Color?>(a?.overlayColor, b?.overlayColor, t, Color.lerp),
      splashRadius: lerpDouble(a?.splashRadius, b?.splashRadius, t),
      thumbIcon: t < 0.5 ? a?.thumbIcon : b?.thumbIcon,
      padding: EdgeInsetsGeometry.lerp(a?.padding, b?.padding, t),
    );
  }

  @override
  int get hashCode => Object.hash(
    thumbColor,
    trackColor,
    trackOutlineColor,
    trackOutlineWidth,
    materialTapTargetSize,
    mouseCursor,
    overlayColor,
    splashRadius,
    thumbIcon,
    padding,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is SwitchThemeData &&
        other.thumbColor == thumbColor &&
        other.trackColor == trackColor &&
        other.trackOutlineColor == trackOutlineColor &&
        other.trackOutlineWidth == trackOutlineWidth &&
        other.materialTapTargetSize == materialTapTargetSize &&
        other.mouseCursor == mouseCursor &&
        other.overlayColor == overlayColor &&
        other.splashRadius == splashRadius &&
        other.thumbIcon == thumbIcon &&
        other.padding == padding;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<WidgetStateProperty<Color?>>('thumbColor', thumbColor, defaultValue: null));
    properties.add(DiagnosticsProperty<WidgetStateProperty<Color?>>('trackColor', trackColor, defaultValue: null));
    properties.add(
      DiagnosticsProperty<WidgetStateProperty<Color?>>('trackOutlineColor', trackOutlineColor, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty<WidgetStateProperty<double?>>('trackOutlineWidth', trackOutlineWidth, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty<MaterialTapTargetSize>('materialTapTargetSize', materialTapTargetSize, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty<WidgetStateProperty<MouseCursor?>>('mouseCursor', mouseCursor, defaultValue: null),
    );
    properties.add(DiagnosticsProperty<WidgetStateProperty<Color?>>('overlayColor', overlayColor, defaultValue: null));
    properties.add(DoubleProperty('splashRadius', splashRadius, defaultValue: null));
    properties.add(DiagnosticsProperty<WidgetStateProperty<Icon?>>('thumbIcon', thumbIcon, defaultValue: null));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding, defaultValue: null));
  }
}

class SwitchTheme extends InheritedWidget {
  const SwitchTheme({required this.data, required super.child, super.key});

  final SwitchThemeData data;

  static SwitchThemeData of(BuildContext context) {
    final SwitchTheme? switchTheme = context.dependOnInheritedWidgetOfExactType<SwitchTheme>();
    return switchTheme?.data ?? Theme.of(context).switchTheme;
  }

  @override
  bool updateShouldNotify(SwitchTheme oldWidget) => data != oldWidget.data;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SwitchThemeData>('data', data));
  }
}
