import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'text_theme.freezed.dart';

@freezed
abstract class WaveTextTheme with Diagnosticable, _$WaveTextTheme {
  const WaveTextTheme._();
  const factory WaveTextTheme({required TextStyle body}) = _WaveTextTheme;
}
