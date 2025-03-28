import 'package:flutter/material.dart';
import 'package:waveui/waveui.dart';

class WaveThemeData extends ThemeExtension<WaveThemeData> {
  final WaveColorScheme colorScheme;
  final WaveButtonTheme buttonTheme;

  WaveThemeData({required this.buttonTheme, required this.colorScheme});

  @override
  WaveThemeData copyWith({WaveColorScheme? colorScheme, WaveButtonTheme? buttonTheme}) =>
      WaveThemeData(buttonTheme: buttonTheme ?? this.buttonTheme, colorScheme: colorScheme ?? this.colorScheme);

  @override
  WaveThemeData lerp(ThemeExtension<WaveThemeData>? other, double t) {
    if (other is! WaveThemeData) return this;
    return WaveThemeData(
      buttonTheme: WaveButtonTheme.lerp(buttonTheme, other.buttonTheme, t),
      colorScheme: WaveColorScheme.lerp(colorScheme, other.colorScheme, t),
    );
  }
}
