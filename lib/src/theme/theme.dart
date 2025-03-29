import 'package:flutter/material.dart';
import 'package:waveui/waveui.dart';

class WaveThemeData extends ThemeExtension<WaveThemeData> {
  final WaveColorScheme colorScheme;

  WaveThemeData({required this.colorScheme});

  @override
  WaveThemeData copyWith({WaveColorScheme? colorScheme}) => WaveThemeData(colorScheme: colorScheme ?? this.colorScheme);

  @override
  WaveThemeData lerp(ThemeExtension<WaveThemeData>? other, double t) {
    if (other is! WaveThemeData) {
      return this;
    }
    return WaveThemeData(colorScheme: WaveColorScheme.lerp(colorScheme, other.colorScheme, t));
  }
}
