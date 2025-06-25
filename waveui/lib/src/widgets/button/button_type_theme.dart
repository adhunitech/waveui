import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'button_type_theme.freezed.dart';

@freezed
/// Defines the theme data for button types.
abstract class ButtonTypeTheme with Diagnosticable, _$ButtonTypeTheme {
  const ButtonTypeTheme._();

  /// Creates a [ButtonTypeTheme].
  const factory ButtonTypeTheme({
    @Default(EdgeInsets.symmetric(horizontal: 12, vertical: 10)) EdgeInsetsGeometry padding,
    @Default(BorderRadius.all(Radius.circular(12))) BorderRadiusGeometry borderRadius,
    Color? backgroundColor,
    Color? borderColor,
    TextStyle? labelStyle,
    IconThemeData? iconTheme,
  }) = _ButtonTypeTheme;
}
