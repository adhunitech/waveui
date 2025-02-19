import 'dart:ui' show lerpDouble;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:waveui/material/theme.dart';

part 'theme.freezed.dart';

@freezed
class AppBarTheme with _$AppBarTheme {
  const factory AppBarTheme({
    Color? backgroundColor,
    Color? foregroundColor,
    double? elevation,
    double? scrolledUnderElevation,
    Color? shadowColor,
    Color? surfaceTintColor,
    ShapeBorder? shape,
    IconThemeData? iconTheme,
    IconThemeData? actionsIconTheme,
    bool? centerTitle,
    double? titleSpacing,
    double? leadingWidth,
    double? toolbarHeight,
    TextStyle? toolbarTextStyle,
    TextStyle? titleTextStyle,
    SystemUiOverlayStyle? systemOverlayStyle,
    EdgeInsetsGeometry? actionsPadding,
  }) = _AppBarTheme;

  factory AppBarTheme.lerp(AppBarTheme? a, AppBarTheme? b, double t) => AppBarTheme(
    backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t),
    foregroundColor: Color.lerp(a?.foregroundColor, b?.foregroundColor, t),
    elevation: lerpDouble(a?.elevation, b?.elevation, t),
    scrolledUnderElevation: lerpDouble(a?.scrolledUnderElevation, b?.scrolledUnderElevation, t),
    shadowColor: Color.lerp(a?.shadowColor, b?.shadowColor, t),
    surfaceTintColor: Color.lerp(a?.surfaceTintColor, b?.surfaceTintColor, t),
    shape: ShapeBorder.lerp(a?.shape, b?.shape, t),
    iconTheme: IconThemeData.lerp(a?.iconTheme, b?.iconTheme, t),
    actionsIconTheme: IconThemeData.lerp(a?.actionsIconTheme, b?.actionsIconTheme, t),
    centerTitle: t < 0.5 ? a?.centerTitle : b?.centerTitle,
    titleSpacing: lerpDouble(a?.titleSpacing, b?.titleSpacing, t),
    leadingWidth: lerpDouble(a?.leadingWidth, b?.leadingWidth, t),
    toolbarHeight: lerpDouble(a?.toolbarHeight, b?.toolbarHeight, t),
    toolbarTextStyle: TextStyle.lerp(a?.toolbarTextStyle, b?.toolbarTextStyle, t),
    titleTextStyle: TextStyle.lerp(a?.titleTextStyle, b?.titleTextStyle, t),
    systemOverlayStyle: t < 0.5 ? a?.systemOverlayStyle : b?.systemOverlayStyle,
    actionsPadding: EdgeInsetsGeometry.lerp(a?.actionsPadding, b?.actionsPadding, t),
  );

  static AppBarTheme of(BuildContext context) => Theme.of(context).appBarTheme;
}
