// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/theme.dart';

@immutable
class DialogTheme extends InheritedTheme with Diagnosticable {
  const DialogTheme({
    super.key,
    Color? backgroundColor,
    double? elevation,
    Color? shadowColor,
    Color? surfaceTintColor,
    ShapeBorder? shape,
    AlignmentGeometry? alignment,
    Color? iconColor,
    TextStyle? titleTextStyle,
    TextStyle? contentTextStyle,
    EdgeInsetsGeometry? actionsPadding,
    Color? barrierColor,
    EdgeInsets? insetPadding,
    Clip? clipBehavior,
    DialogThemeData? data,
    Widget? child,
  }) : assert(
         data == null ||
             (backgroundColor ??
                     elevation ??
                     shadowColor ??
                     surfaceTintColor ??
                     shape ??
                     alignment ??
                     iconColor ??
                     titleTextStyle ??
                     contentTextStyle ??
                     actionsPadding ??
                     barrierColor ??
                     insetPadding ??
                     clipBehavior) ==
                 null,
       ),
       _data = data,
       _backgroundColor = backgroundColor,
       _elevation = elevation,
       _shadowColor = shadowColor,
       _surfaceTintColor = surfaceTintColor,
       _shape = shape,
       _alignment = alignment,
       _iconColor = iconColor,
       _titleTextStyle = titleTextStyle,
       _contentTextStyle = contentTextStyle,
       _actionsPadding = actionsPadding,
       _barrierColor = barrierColor,
       _insetPadding = insetPadding,
       _clipBehavior = clipBehavior,
       super(child: child ?? const SizedBox());

  final DialogThemeData? _data;
  final Color? _backgroundColor;
  final double? _elevation;
  final Color? _shadowColor;
  final Color? _surfaceTintColor;
  final ShapeBorder? _shape;
  final AlignmentGeometry? _alignment;
  final TextStyle? _titleTextStyle;
  final TextStyle? _contentTextStyle;
  final EdgeInsetsGeometry? _actionsPadding;
  final Color? _iconColor;
  final Color? _barrierColor;
  final EdgeInsets? _insetPadding;
  final Clip? _clipBehavior;

  Color? get backgroundColor => _data != null ? _data.backgroundColor : _backgroundColor;

  double? get elevation => _data != null ? _data.elevation : _elevation;

  Color? get shadowColor => _data != null ? _data.shadowColor : _shadowColor;

  Color? get surfaceTintColor => _data != null ? _data.surfaceTintColor : _surfaceTintColor;

  ShapeBorder? get shape => _data != null ? _data.shape : _shape;

  AlignmentGeometry? get alignment => _data != null ? _data.alignment : _alignment;

  TextStyle? get titleTextStyle => _data != null ? _data.titleTextStyle : _titleTextStyle;

  TextStyle? get contentTextStyle => _data != null ? _data.contentTextStyle : _contentTextStyle;

  EdgeInsetsGeometry? get actionsPadding => _data != null ? _data.actionsPadding : _actionsPadding;

  Color? get iconColor => _data != null ? _data.iconColor : _iconColor;

  Color? get barrierColor => _data != null ? _data.barrierColor : _barrierColor;

  EdgeInsets? get insetPadding => _data != null ? _data.insetPadding : _insetPadding;

  Clip? get clipBehavior => _data != null ? _data.clipBehavior : _clipBehavior;

  DialogThemeData get data =>
      _data ??
      DialogThemeData(
        backgroundColor: _backgroundColor,
        elevation: _elevation,
        shadowColor: _shadowColor,
        surfaceTintColor: _surfaceTintColor,
        shape: _shape,
        alignment: _alignment,
        iconColor: _iconColor,
        titleTextStyle: _titleTextStyle,
        contentTextStyle: _contentTextStyle,
        actionsPadding: _actionsPadding,
        barrierColor: _barrierColor,
        insetPadding: _insetPadding,
        clipBehavior: _clipBehavior,
      );

  static DialogThemeData of(BuildContext context) {
    final DialogTheme? dialogTheme = context.dependOnInheritedWidgetOfExactType<DialogTheme>();
    return dialogTheme?.data ?? Theme.of(context).dialogTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) => DialogTheme(data: data, child: child);

  @override
  bool updateShouldNotify(DialogTheme oldWidget) => data != oldWidget.data;

  DialogTheme copyWith({
    Color? backgroundColor,
    double? elevation,
    Color? shadowColor,
    Color? surfaceTintColor,
    ShapeBorder? shape,
    AlignmentGeometry? alignment,
    Color? iconColor,
    TextStyle? titleTextStyle,
    TextStyle? contentTextStyle,
    EdgeInsetsGeometry? actionsPadding,
    Color? barrierColor,
    EdgeInsets? insetPadding,
    Clip? clipBehavior,
  }) => DialogTheme(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    elevation: elevation ?? this.elevation,
    shadowColor: shadowColor ?? this.shadowColor,
    surfaceTintColor: surfaceTintColor ?? this.surfaceTintColor,
    shape: shape ?? this.shape,
    alignment: alignment ?? this.alignment,
    iconColor: iconColor ?? this.iconColor,
    titleTextStyle: titleTextStyle ?? this.titleTextStyle,
    contentTextStyle: contentTextStyle ?? this.contentTextStyle,
    actionsPadding: actionsPadding ?? this.actionsPadding,
    barrierColor: barrierColor ?? this.barrierColor,
    insetPadding: insetPadding ?? this.insetPadding,
    clipBehavior: clipBehavior ?? this.clipBehavior,
  );

  static DialogTheme lerp(DialogTheme? a, DialogTheme? b, double t) {
    if (identical(a, b) && a != null) {
      return a;
    }
    return DialogTheme(
      backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t),
      elevation: lerpDouble(a?.elevation, b?.elevation, t),
      shadowColor: Color.lerp(a?.shadowColor, b?.shadowColor, t),
      surfaceTintColor: Color.lerp(a?.surfaceTintColor, b?.surfaceTintColor, t),
      shape: ShapeBorder.lerp(a?.shape, b?.shape, t),
      alignment: AlignmentGeometry.lerp(a?.alignment, b?.alignment, t),
      iconColor: Color.lerp(a?.iconColor, b?.iconColor, t),
      titleTextStyle: TextStyle.lerp(a?.titleTextStyle, b?.titleTextStyle, t),
      contentTextStyle: TextStyle.lerp(a?.contentTextStyle, b?.contentTextStyle, t),
      actionsPadding: EdgeInsetsGeometry.lerp(a?.actionsPadding, b?.actionsPadding, t),
      barrierColor: Color.lerp(a?.barrierColor, b?.barrierColor, t),
      insetPadding: EdgeInsets.lerp(a?.insetPadding, b?.insetPadding, t),
      clipBehavior: t < 0.5 ? a?.clipBehavior : b?.clipBehavior,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('backgroundColor', backgroundColor, defaultValue: null));
    properties.add(DoubleProperty('elevation', elevation, defaultValue: null));
    properties.add(ColorProperty('shadowColor', shadowColor, defaultValue: null));
    properties.add(ColorProperty('surfaceTintColor', surfaceTintColor, defaultValue: null));
    properties.add(DiagnosticsProperty<ShapeBorder>('shape', shape, defaultValue: null));
    properties.add(DiagnosticsProperty<AlignmentGeometry>('alignment', alignment, defaultValue: null));
    properties.add(ColorProperty('iconColor', iconColor, defaultValue: null));
    properties.add(DiagnosticsProperty<TextStyle>('titleTextStyle', titleTextStyle, defaultValue: null));
    properties.add(DiagnosticsProperty<TextStyle>('contentTextStyle', contentTextStyle, defaultValue: null));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('actionsPadding', actionsPadding, defaultValue: null));
    properties.add(ColorProperty('barrierColor', barrierColor, defaultValue: null));
    properties.add(DiagnosticsProperty<EdgeInsets>('insetPadding', insetPadding, defaultValue: null));
    properties.add(DiagnosticsProperty<Clip>('clipBehavior', clipBehavior, defaultValue: null));
    properties.add(DiagnosticsProperty<DialogThemeData>('data', data));
  }
}

@immutable
class DialogThemeData with Diagnosticable {
  const DialogThemeData({
    this.backgroundColor,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.shape,
    this.alignment,
    this.iconColor,
    this.titleTextStyle,
    this.contentTextStyle,
    this.actionsPadding,
    this.barrierColor,
    this.insetPadding,
    this.clipBehavior,
  });

  final Color? backgroundColor;

  final double? elevation;

  final Color? shadowColor;

  final Color? surfaceTintColor;

  final ShapeBorder? shape;

  final AlignmentGeometry? alignment;

  final TextStyle? titleTextStyle;

  final TextStyle? contentTextStyle;

  final EdgeInsetsGeometry? actionsPadding;

  final Color? iconColor;

  final Color? barrierColor;

  final EdgeInsets? insetPadding;

  final Clip? clipBehavior;

  DialogThemeData copyWith({
    Color? backgroundColor,
    double? elevation,
    Color? shadowColor,
    Color? surfaceTintColor,
    ShapeBorder? shape,
    AlignmentGeometry? alignment,
    Color? iconColor,
    TextStyle? titleTextStyle,
    TextStyle? contentTextStyle,
    EdgeInsetsGeometry? actionsPadding,
    Color? barrierColor,
    EdgeInsets? insetPadding,
    Clip? clipBehavior,
  }) => DialogThemeData(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    elevation: elevation ?? this.elevation,
    shadowColor: shadowColor ?? this.shadowColor,
    surfaceTintColor: surfaceTintColor ?? this.surfaceTintColor,
    shape: shape ?? this.shape,
    alignment: alignment ?? this.alignment,
    iconColor: iconColor ?? this.iconColor,
    titleTextStyle: titleTextStyle ?? this.titleTextStyle,
    contentTextStyle: contentTextStyle ?? this.contentTextStyle,
    actionsPadding: actionsPadding ?? this.actionsPadding,
    barrierColor: barrierColor ?? this.barrierColor,
    insetPadding: insetPadding ?? this.insetPadding,
    clipBehavior: clipBehavior ?? this.clipBehavior,
  );

  static DialogThemeData lerp(DialogThemeData? a, DialogThemeData? b, double t) {
    if (identical(a, b) && a != null) {
      return a;
    }
    return DialogThemeData(
      backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t),
      elevation: lerpDouble(a?.elevation, b?.elevation, t),
      shadowColor: Color.lerp(a?.shadowColor, b?.shadowColor, t),
      surfaceTintColor: Color.lerp(a?.surfaceTintColor, b?.surfaceTintColor, t),
      shape: ShapeBorder.lerp(a?.shape, b?.shape, t),
      alignment: AlignmentGeometry.lerp(a?.alignment, b?.alignment, t),
      iconColor: Color.lerp(a?.iconColor, b?.iconColor, t),
      titleTextStyle: TextStyle.lerp(a?.titleTextStyle, b?.titleTextStyle, t),
      contentTextStyle: TextStyle.lerp(a?.contentTextStyle, b?.contentTextStyle, t),
      actionsPadding: EdgeInsetsGeometry.lerp(a?.actionsPadding, b?.actionsPadding, t),
      barrierColor: Color.lerp(a?.barrierColor, b?.barrierColor, t),
      insetPadding: EdgeInsets.lerp(a?.insetPadding, b?.insetPadding, t),
      clipBehavior: t < 0.5 ? a?.clipBehavior : b?.clipBehavior,
    );
  }

  @override
  int get hashCode => Object.hashAll(<Object?>[
    backgroundColor,
    elevation,
    shadowColor,
    surfaceTintColor,
    shape,
    alignment,
    iconColor,
    titleTextStyle,
    contentTextStyle,
    actionsPadding,
    barrierColor,
    insetPadding,
    clipBehavior,
  ]);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is DialogThemeData &&
        other.backgroundColor == backgroundColor &&
        other.elevation == elevation &&
        other.shadowColor == shadowColor &&
        other.surfaceTintColor == surfaceTintColor &&
        other.shape == shape &&
        other.alignment == alignment &&
        other.iconColor == iconColor &&
        other.titleTextStyle == titleTextStyle &&
        other.contentTextStyle == contentTextStyle &&
        other.actionsPadding == actionsPadding &&
        other.barrierColor == barrierColor &&
        other.insetPadding == insetPadding &&
        other.clipBehavior == clipBehavior;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('backgroundColor', backgroundColor, defaultValue: null));
    properties.add(DoubleProperty('elevation', elevation, defaultValue: null));
    properties.add(ColorProperty('shadowColor', shadowColor, defaultValue: null));
    properties.add(ColorProperty('surfaceTintColor', surfaceTintColor, defaultValue: null));
    properties.add(DiagnosticsProperty<ShapeBorder>('shape', shape, defaultValue: null));
    properties.add(DiagnosticsProperty<AlignmentGeometry>('alignment', alignment, defaultValue: null));
    properties.add(ColorProperty('iconColor', iconColor, defaultValue: null));
    properties.add(DiagnosticsProperty<TextStyle>('titleTextStyle', titleTextStyle, defaultValue: null));
    properties.add(DiagnosticsProperty<TextStyle>('contentTextStyle', contentTextStyle, defaultValue: null));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('actionsPadding', actionsPadding, defaultValue: null));
    properties.add(ColorProperty('barrierColor', barrierColor, defaultValue: null));
    properties.add(DiagnosticsProperty<EdgeInsets>('insetPadding', insetPadding, defaultValue: null));
    properties.add(DiagnosticsProperty<Clip>('clipBehavior', clipBehavior, defaultValue: null));
  }
}
