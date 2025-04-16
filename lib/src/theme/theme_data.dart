import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:waveui/src/theme/color_scheme.dart';

part 'theme_data.freezed.dart';

/// A class that defines the theme data for Wave UI components.
///
/// The theme data includes configuration for various visual properties like colors,
/// typography, and other design elements used throughout the Wave UI framework.
///
/// Example:
/// ```dart
/// final themeData = WaveThemeData(
///   colorScheme: WaveColorScheme(...),
/// );
/// ```
///
/// This class is immutable. To modify a [WaveThemeData] instance, use
/// [WaveThemeData.copyWith].
@freezed
abstract class WaveThemeData with Diagnosticable, _$WaveThemeData {
  const WaveThemeData._();

  /// Creates a [WaveThemeData]
  const factory WaveThemeData({required WaveColorScheme colorScheme}) = _WaveThemeData;
}
