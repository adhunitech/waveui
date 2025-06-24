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
    @Default(EdgeInsets.symmetric(horizontal: 24, vertical: 10)) EdgeInsetsGeometry padding,
    @Default(12) double borderRadius,
    @Default(16) double iconSize,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? borderColor,
    TextStyle? labelStyle,
  }) = _ButtonTypeTheme;
}
