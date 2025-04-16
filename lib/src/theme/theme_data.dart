import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:waveui/src/theme/color_scheme.dart';

part 'theme_data.freezed.dart';

@freezed
abstract class WaveThemeData with Diagnosticable, _$WaveThemeData {
  const WaveThemeData._();

  /// Creates [WaveThemeData]
  const factory WaveThemeData({required WaveColorScheme colorScheme}) = _WaveThemeData;
}
