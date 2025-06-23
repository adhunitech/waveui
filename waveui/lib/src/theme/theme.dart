import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:waveui/waveui.dart';

part 'theme.freezed.dart';

/// A class that defines the theme data for Wave UI components.
///
/// The theme data includes configuration for various visual properties like colors,
/// typography, and other design elements used throughout the Wave UI framework.
///
/// Example:
/// ```dart
/// final theme = WaveTheme(
///   colorScheme: ColorScheme(...),
/// );
/// ```
///
/// This class is immutable. To modify a [WaveTheme] instance, use
/// [WaveTheme.copyWith].
@freezed
abstract class WaveTheme with Diagnosticable, _$WaveTheme {
  const WaveTheme._();

  const factory WaveTheme._internal({
    required WaveAppBarTheme appBarTheme,
    required WaveTextTheme textTheme,
    required ColorScheme colorScheme,
  }) = _WaveTheme;

  factory WaveTheme({WaveAppBarTheme? appBarTheme, ColorScheme? colorScheme, WaveTextTheme? textTheme}) {
    colorScheme ??= ColorScheme.light();
    appBarTheme ??= WaveAppBarTheme(
      backgroundColor: colorScheme.surfacePrimary,
      foregroundColor: colorScheme.textPrimary,
      titleStyle: TextStyle(),
    );

    textTheme ??= WaveTextTheme().withColor(colorScheme.textPrimary);

    return WaveTheme._internal(appBarTheme: appBarTheme, colorScheme: colorScheme, textTheme: textTheme);
  }
}
