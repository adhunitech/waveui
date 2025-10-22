import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_bar_theme.freezed.dart';

@freezed
abstract class WaveAppBarTheme with Diagnosticable, _$WaveAppBarTheme {
  const WaveAppBarTheme._();
  const factory WaveAppBarTheme({
    required Color backgroundColor,
    required Color foregroundColor,
    required TextStyle titleStyle,
    @Default(true) bool isCenteredTitle,
  }) = _WaveAppBarTheme;
}
