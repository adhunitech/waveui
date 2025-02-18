// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/theme_data.dart';

// Examples can assume:
// late Widget child;
// late BuildContext context;
// late MenuStyle style;
// @immutable
// class MyAppHome extends StatelessWidget {
//   const MyAppHome({super.key});
//   @override
//   Widget build(BuildContext context) => const SizedBox();
// }

@immutable
class MenuStyle with Diagnosticable {
  const MenuStyle({
    this.backgroundColor,
    this.shadowColor,
    this.surfaceTintColor,
    this.elevation,
    this.padding,
    this.minimumSize,
    this.fixedSize,
    this.maximumSize,
    this.side,
    this.shape,
    this.mouseCursor,
    this.visualDensity,
    this.alignment,
  });

  final WidgetStateProperty<Color?>? backgroundColor;

  final WidgetStateProperty<Color?>? shadowColor;

  final WidgetStateProperty<Color?>? surfaceTintColor;

  final WidgetStateProperty<double?>? elevation;

  final WidgetStateProperty<EdgeInsetsGeometry?>? padding;

  final WidgetStateProperty<Size?>? minimumSize;

  final WidgetStateProperty<Size?>? fixedSize;

  final WidgetStateProperty<Size?>? maximumSize;

  final WidgetStateProperty<BorderSide?>? side;

  final WidgetStateProperty<OutlinedBorder?>? shape;

  final WidgetStateProperty<MouseCursor?>? mouseCursor;

  final VisualDensity? visualDensity;

  final AlignmentGeometry? alignment;

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      backgroundColor,
      shadowColor,
      surfaceTintColor,
      elevation,
      padding,
      minimumSize,
      fixedSize,
      maximumSize,
      side,
      shape,
      mouseCursor,
      visualDensity,
      alignment,
    ];
    return Object.hashAll(values);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is MenuStyle &&
        other.backgroundColor == backgroundColor &&
        other.shadowColor == shadowColor &&
        other.surfaceTintColor == surfaceTintColor &&
        other.elevation == elevation &&
        other.padding == padding &&
        other.minimumSize == minimumSize &&
        other.fixedSize == fixedSize &&
        other.maximumSize == maximumSize &&
        other.side == side &&
        other.shape == shape &&
        other.mouseCursor == mouseCursor &&
        other.visualDensity == visualDensity &&
        other.alignment == alignment;
  }

  MenuStyle copyWith({
    WidgetStateProperty<Color?>? backgroundColor,
    WidgetStateProperty<Color?>? shadowColor,
    WidgetStateProperty<Color?>? surfaceTintColor,
    WidgetStateProperty<double?>? elevation,
    WidgetStateProperty<EdgeInsetsGeometry?>? padding,
    WidgetStateProperty<Size?>? minimumSize,
    WidgetStateProperty<Size?>? fixedSize,
    WidgetStateProperty<Size?>? maximumSize,
    WidgetStateProperty<BorderSide?>? side,
    WidgetStateProperty<OutlinedBorder?>? shape,
    WidgetStateProperty<MouseCursor?>? mouseCursor,
    VisualDensity? visualDensity,
    AlignmentGeometry? alignment,
  }) => MenuStyle(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    shadowColor: shadowColor ?? this.shadowColor,
    surfaceTintColor: surfaceTintColor ?? this.surfaceTintColor,
    elevation: elevation ?? this.elevation,
    padding: padding ?? this.padding,
    minimumSize: minimumSize ?? this.minimumSize,
    fixedSize: fixedSize ?? this.fixedSize,
    maximumSize: maximumSize ?? this.maximumSize,
    side: side ?? this.side,
    shape: shape ?? this.shape,
    mouseCursor: mouseCursor ?? this.mouseCursor,
    visualDensity: visualDensity ?? this.visualDensity,
    alignment: alignment ?? this.alignment,
  );

  MenuStyle merge(MenuStyle? style) {
    if (style == null) {
      return this;
    }
    return copyWith(
      backgroundColor: backgroundColor ?? style.backgroundColor,
      shadowColor: shadowColor ?? style.shadowColor,
      surfaceTintColor: surfaceTintColor ?? style.surfaceTintColor,
      elevation: elevation ?? style.elevation,
      padding: padding ?? style.padding,
      minimumSize: minimumSize ?? style.minimumSize,
      fixedSize: fixedSize ?? style.fixedSize,
      maximumSize: maximumSize ?? style.maximumSize,
      side: side ?? style.side,
      shape: shape ?? style.shape,
      mouseCursor: mouseCursor ?? style.mouseCursor,
      visualDensity: visualDensity ?? style.visualDensity,
      alignment: alignment ?? style.alignment,
    );
  }

  static MenuStyle? lerp(MenuStyle? a, MenuStyle? b, double t) {
    if (identical(a, b)) {
      return a;
    }
    return MenuStyle(
      backgroundColor: WidgetStateProperty.lerp<Color?>(a?.backgroundColor, b?.backgroundColor, t, Color.lerp),
      shadowColor: WidgetStateProperty.lerp<Color?>(a?.shadowColor, b?.shadowColor, t, Color.lerp),
      surfaceTintColor: WidgetStateProperty.lerp<Color?>(a?.surfaceTintColor, b?.surfaceTintColor, t, Color.lerp),
      elevation: WidgetStateProperty.lerp<double?>(a?.elevation, b?.elevation, t, lerpDouble),
      padding: WidgetStateProperty.lerp<EdgeInsetsGeometry?>(a?.padding, b?.padding, t, EdgeInsetsGeometry.lerp),
      minimumSize: WidgetStateProperty.lerp<Size?>(a?.minimumSize, b?.minimumSize, t, Size.lerp),
      fixedSize: WidgetStateProperty.lerp<Size?>(a?.fixedSize, b?.fixedSize, t, Size.lerp),
      maximumSize: WidgetStateProperty.lerp<Size?>(a?.maximumSize, b?.maximumSize, t, Size.lerp),
      side: WidgetStateBorderSide.lerp(a?.side, b?.side, t),
      shape: WidgetStateProperty.lerp<OutlinedBorder?>(a?.shape, b?.shape, t, OutlinedBorder.lerp),
      mouseCursor: t < 0.5 ? a?.mouseCursor : b?.mouseCursor,
      visualDensity: t < 0.5 ? a?.visualDensity : b?.visualDensity,
      alignment: AlignmentGeometry.lerp(a?.alignment, b?.alignment, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<WidgetStateProperty<Color?>>('backgroundColor', backgroundColor, defaultValue: null),
    );
    properties.add(DiagnosticsProperty<WidgetStateProperty<Color?>>('shadowColor', shadowColor, defaultValue: null));
    properties.add(
      DiagnosticsProperty<WidgetStateProperty<Color?>>('surfaceTintColor', surfaceTintColor, defaultValue: null),
    );
    properties.add(DiagnosticsProperty<WidgetStateProperty<double?>>('elevation', elevation, defaultValue: null));
    properties.add(
      DiagnosticsProperty<WidgetStateProperty<EdgeInsetsGeometry?>>('padding', padding, defaultValue: null),
    );
    properties.add(DiagnosticsProperty<WidgetStateProperty<Size?>>('minimumSize', minimumSize, defaultValue: null));
    properties.add(DiagnosticsProperty<WidgetStateProperty<Size?>>('fixedSize', fixedSize, defaultValue: null));
    properties.add(DiagnosticsProperty<WidgetStateProperty<Size?>>('maximumSize', maximumSize, defaultValue: null));
    properties.add(DiagnosticsProperty<WidgetStateProperty<BorderSide?>>('side', side, defaultValue: null));
    properties.add(DiagnosticsProperty<WidgetStateProperty<OutlinedBorder?>>('shape', shape, defaultValue: null));
    properties.add(
      DiagnosticsProperty<WidgetStateProperty<MouseCursor?>>('mouseCursor', mouseCursor, defaultValue: null),
    );
    properties.add(DiagnosticsProperty<VisualDensity>('visualDensity', visualDensity, defaultValue: null));
    properties.add(DiagnosticsProperty<AlignmentGeometry>('alignment', alignment, defaultValue: null));
  }
}
