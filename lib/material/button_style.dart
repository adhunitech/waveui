// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/button_style_button.dart';
import 'package:waveui/material/ink_well.dart';
import 'package:waveui/material/theme_data.dart';

// Examples can assume:
// late BuildContext context;
// typedef MyAppHome = Placeholder;

typedef ButtonLayerBuilder = Widget Function(BuildContext context, Set<WidgetState> states, Widget? child);

@immutable
class ButtonStyle with Diagnosticable {
  const ButtonStyle({
    this.textStyle,
    this.backgroundColor,
    this.foregroundColor,
    this.overlayColor,
    this.shadowColor,
    this.surfaceTintColor,
    this.elevation,
    this.padding,
    this.minimumSize,
    this.fixedSize,
    this.maximumSize,
    this.iconColor,
    this.iconSize,
    this.iconAlignment,
    this.side,
    this.shape,
    this.mouseCursor,
    this.visualDensity,
    this.tapTargetSize,
    this.animationDuration,
    this.enableFeedback,
    this.alignment,
    this.splashFactory,
    this.backgroundBuilder,
    this.foregroundBuilder,
  });

  final WidgetStateProperty<TextStyle?>? textStyle;

  final WidgetStateProperty<Color?>? backgroundColor;

  final WidgetStateProperty<Color?>? foregroundColor;

  final WidgetStateProperty<Color?>? overlayColor;

  final WidgetStateProperty<Color?>? shadowColor;

  final WidgetStateProperty<Color?>? surfaceTintColor;

  final WidgetStateProperty<double?>? elevation;

  final WidgetStateProperty<EdgeInsetsGeometry?>? padding;

  final WidgetStateProperty<Size?>? minimumSize;

  final WidgetStateProperty<Size?>? fixedSize;

  final WidgetStateProperty<Size?>? maximumSize;

  final WidgetStateProperty<Color?>? iconColor;

  final WidgetStateProperty<double?>? iconSize;

  final IconAlignment? iconAlignment;

  final WidgetStateProperty<BorderSide?>? side;

  final WidgetStateProperty<OutlinedBorder?>? shape;

  final WidgetStateProperty<MouseCursor?>? mouseCursor;

  final VisualDensity? visualDensity;

  final MaterialTapTargetSize? tapTargetSize;

  final Duration? animationDuration;

  final bool? enableFeedback;

  final AlignmentGeometry? alignment;

  final InteractiveInkFeatureFactory? splashFactory;

  final ButtonLayerBuilder? backgroundBuilder;

  final ButtonLayerBuilder? foregroundBuilder;

  ButtonStyle copyWith({
    WidgetStateProperty<TextStyle?>? textStyle,
    WidgetStateProperty<Color?>? backgroundColor,
    WidgetStateProperty<Color?>? foregroundColor,
    WidgetStateProperty<Color?>? overlayColor,
    WidgetStateProperty<Color?>? shadowColor,
    WidgetStateProperty<Color?>? surfaceTintColor,
    WidgetStateProperty<double?>? elevation,
    WidgetStateProperty<EdgeInsetsGeometry?>? padding,
    WidgetStateProperty<Size?>? minimumSize,
    WidgetStateProperty<Size?>? fixedSize,
    WidgetStateProperty<Size?>? maximumSize,
    WidgetStateProperty<Color?>? iconColor,
    WidgetStateProperty<double?>? iconSize,
    IconAlignment? iconAlignment,
    WidgetStateProperty<BorderSide?>? side,
    WidgetStateProperty<OutlinedBorder?>? shape,
    WidgetStateProperty<MouseCursor?>? mouseCursor,
    VisualDensity? visualDensity,
    MaterialTapTargetSize? tapTargetSize,
    Duration? animationDuration,
    bool? enableFeedback,
    AlignmentGeometry? alignment,
    InteractiveInkFeatureFactory? splashFactory,
    ButtonLayerBuilder? backgroundBuilder,
    ButtonLayerBuilder? foregroundBuilder,
  }) => ButtonStyle(
    textStyle: textStyle ?? this.textStyle,
    backgroundColor: backgroundColor ?? this.backgroundColor,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    overlayColor: overlayColor ?? this.overlayColor,
    shadowColor: shadowColor ?? this.shadowColor,
    surfaceTintColor: surfaceTintColor ?? this.surfaceTintColor,
    elevation: elevation ?? this.elevation,
    padding: padding ?? this.padding,
    minimumSize: minimumSize ?? this.minimumSize,
    fixedSize: fixedSize ?? this.fixedSize,
    maximumSize: maximumSize ?? this.maximumSize,
    iconColor: iconColor ?? this.iconColor,
    iconSize: iconSize ?? this.iconSize,
    iconAlignment: iconAlignment ?? this.iconAlignment,
    side: side ?? this.side,
    shape: shape ?? this.shape,
    mouseCursor: mouseCursor ?? this.mouseCursor,
    visualDensity: visualDensity ?? this.visualDensity,
    tapTargetSize: tapTargetSize ?? this.tapTargetSize,
    animationDuration: animationDuration ?? this.animationDuration,
    enableFeedback: enableFeedback ?? this.enableFeedback,
    alignment: alignment ?? this.alignment,
    splashFactory: splashFactory ?? this.splashFactory,
    backgroundBuilder: backgroundBuilder ?? this.backgroundBuilder,
    foregroundBuilder: foregroundBuilder ?? this.foregroundBuilder,
  );

  ButtonStyle merge(ButtonStyle? style) {
    if (style == null) {
      return this;
    }
    return copyWith(
      textStyle: textStyle ?? style.textStyle,
      backgroundColor: backgroundColor ?? style.backgroundColor,
      foregroundColor: foregroundColor ?? style.foregroundColor,
      overlayColor: overlayColor ?? style.overlayColor,
      shadowColor: shadowColor ?? style.shadowColor,
      surfaceTintColor: surfaceTintColor ?? style.surfaceTintColor,
      elevation: elevation ?? style.elevation,
      padding: padding ?? style.padding,
      minimumSize: minimumSize ?? style.minimumSize,
      fixedSize: fixedSize ?? style.fixedSize,
      maximumSize: maximumSize ?? style.maximumSize,
      iconColor: iconColor ?? style.iconColor,
      iconSize: iconSize ?? style.iconSize,
      iconAlignment: iconAlignment ?? style.iconAlignment,
      side: side ?? style.side,
      shape: shape ?? style.shape,
      mouseCursor: mouseCursor ?? style.mouseCursor,
      visualDensity: visualDensity ?? style.visualDensity,
      tapTargetSize: tapTargetSize ?? style.tapTargetSize,
      animationDuration: animationDuration ?? style.animationDuration,
      enableFeedback: enableFeedback ?? style.enableFeedback,
      alignment: alignment ?? style.alignment,
      splashFactory: splashFactory ?? style.splashFactory,
      backgroundBuilder: backgroundBuilder ?? style.backgroundBuilder,
      foregroundBuilder: foregroundBuilder ?? style.foregroundBuilder,
    );
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      textStyle,
      backgroundColor,
      foregroundColor,
      overlayColor,
      shadowColor,
      surfaceTintColor,
      elevation,
      padding,
      minimumSize,
      fixedSize,
      maximumSize,
      iconColor,
      iconSize,
      iconAlignment,
      side,
      shape,
      mouseCursor,
      visualDensity,
      tapTargetSize,
      animationDuration,
      enableFeedback,
      alignment,
      splashFactory,
      backgroundBuilder,
      foregroundBuilder,
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
    return other is ButtonStyle &&
        other.textStyle == textStyle &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor &&
        other.overlayColor == overlayColor &&
        other.shadowColor == shadowColor &&
        other.surfaceTintColor == surfaceTintColor &&
        other.elevation == elevation &&
        other.padding == padding &&
        other.minimumSize == minimumSize &&
        other.fixedSize == fixedSize &&
        other.maximumSize == maximumSize &&
        other.iconColor == iconColor &&
        other.iconSize == iconSize &&
        other.iconAlignment == iconAlignment &&
        other.side == side &&
        other.shape == shape &&
        other.mouseCursor == mouseCursor &&
        other.visualDensity == visualDensity &&
        other.tapTargetSize == tapTargetSize &&
        other.animationDuration == animationDuration &&
        other.enableFeedback == enableFeedback &&
        other.alignment == alignment &&
        other.splashFactory == splashFactory &&
        other.backgroundBuilder == backgroundBuilder &&
        other.foregroundBuilder == foregroundBuilder;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<WidgetStateProperty<TextStyle?>>('textStyle', textStyle, defaultValue: null));
    properties.add(
      DiagnosticsProperty<WidgetStateProperty<Color?>>('backgroundColor', backgroundColor, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty<WidgetStateProperty<Color?>>('foregroundColor', foregroundColor, defaultValue: null),
    );
    properties.add(DiagnosticsProperty<WidgetStateProperty<Color?>>('overlayColor', overlayColor, defaultValue: null));
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
    properties.add(DiagnosticsProperty<WidgetStateProperty<Color?>>('iconColor', iconColor, defaultValue: null));
    properties.add(DiagnosticsProperty<WidgetStateProperty<double?>>('iconSize', iconSize, defaultValue: null));
    properties.add(EnumProperty<IconAlignment>('iconAlignment', iconAlignment, defaultValue: null));
    properties.add(DiagnosticsProperty<WidgetStateProperty<BorderSide?>>('side', side, defaultValue: null));
    properties.add(DiagnosticsProperty<WidgetStateProperty<OutlinedBorder?>>('shape', shape, defaultValue: null));
    properties.add(
      DiagnosticsProperty<WidgetStateProperty<MouseCursor?>>('mouseCursor', mouseCursor, defaultValue: null),
    );
    properties.add(DiagnosticsProperty<VisualDensity>('visualDensity', visualDensity, defaultValue: null));
    properties.add(EnumProperty<MaterialTapTargetSize>('tapTargetSize', tapTargetSize, defaultValue: null));
    properties.add(DiagnosticsProperty<Duration>('animationDuration', animationDuration, defaultValue: null));
    properties.add(DiagnosticsProperty<bool>('enableFeedback', enableFeedback, defaultValue: null));
    properties.add(DiagnosticsProperty<AlignmentGeometry>('alignment', alignment, defaultValue: null));
    properties.add(DiagnosticsProperty<ButtonLayerBuilder>('backgroundBuilder', backgroundBuilder, defaultValue: null));
    properties.add(DiagnosticsProperty<ButtonLayerBuilder>('foregroundBuilder', foregroundBuilder, defaultValue: null));
    properties.add(DiagnosticsProperty<InteractiveInkFeatureFactory?>('splashFactory', splashFactory));
  }

  static ButtonStyle? lerp(ButtonStyle? a, ButtonStyle? b, double t) {
    if (identical(a, b)) {
      return a;
    }
    return ButtonStyle(
      textStyle: WidgetStateProperty.lerp<TextStyle?>(a?.textStyle, b?.textStyle, t, TextStyle.lerp),
      backgroundColor: WidgetStateProperty.lerp<Color?>(a?.backgroundColor, b?.backgroundColor, t, Color.lerp),
      foregroundColor: WidgetStateProperty.lerp<Color?>(a?.foregroundColor, b?.foregroundColor, t, Color.lerp),
      overlayColor: WidgetStateProperty.lerp<Color?>(a?.overlayColor, b?.overlayColor, t, Color.lerp),
      shadowColor: WidgetStateProperty.lerp<Color?>(a?.shadowColor, b?.shadowColor, t, Color.lerp),
      surfaceTintColor: WidgetStateProperty.lerp<Color?>(a?.surfaceTintColor, b?.surfaceTintColor, t, Color.lerp),
      elevation: WidgetStateProperty.lerp<double?>(a?.elevation, b?.elevation, t, lerpDouble),
      padding: WidgetStateProperty.lerp<EdgeInsetsGeometry?>(a?.padding, b?.padding, t, EdgeInsetsGeometry.lerp),
      minimumSize: WidgetStateProperty.lerp<Size?>(a?.minimumSize, b?.minimumSize, t, Size.lerp),
      fixedSize: WidgetStateProperty.lerp<Size?>(a?.fixedSize, b?.fixedSize, t, Size.lerp),
      maximumSize: WidgetStateProperty.lerp<Size?>(a?.maximumSize, b?.maximumSize, t, Size.lerp),
      iconColor: WidgetStateProperty.lerp<Color?>(a?.iconColor, b?.iconColor, t, Color.lerp),
      iconSize: WidgetStateProperty.lerp<double?>(a?.iconSize, b?.iconSize, t, lerpDouble),
      iconAlignment: t < 0.5 ? a?.iconAlignment : b?.iconAlignment,
      side: _lerpSides(a?.side, b?.side, t),
      shape: WidgetStateProperty.lerp<OutlinedBorder?>(a?.shape, b?.shape, t, OutlinedBorder.lerp),
      mouseCursor: t < 0.5 ? a?.mouseCursor : b?.mouseCursor,
      visualDensity: t < 0.5 ? a?.visualDensity : b?.visualDensity,
      tapTargetSize: t < 0.5 ? a?.tapTargetSize : b?.tapTargetSize,
      animationDuration: t < 0.5 ? a?.animationDuration : b?.animationDuration,
      enableFeedback: t < 0.5 ? a?.enableFeedback : b?.enableFeedback,
      alignment: AlignmentGeometry.lerp(a?.alignment, b?.alignment, t),
      splashFactory: t < 0.5 ? a?.splashFactory : b?.splashFactory,
      backgroundBuilder: t < 0.5 ? a?.backgroundBuilder : b?.backgroundBuilder,
      foregroundBuilder: t < 0.5 ? a?.foregroundBuilder : b?.foregroundBuilder,
    );
  }

  // Special case because BorderSide.lerp() doesn't support null arguments
  static WidgetStateProperty<BorderSide?>? _lerpSides(
    WidgetStateProperty<BorderSide?>? a,
    WidgetStateProperty<BorderSide?>? b,
    double t,
  ) {
    if (a == null && b == null) {
      return null;
    }
    return WidgetStateBorderSide.lerp(a, b, t);
  }
}
