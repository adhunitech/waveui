import 'package:flutter/widgets.dart';
import 'package:waveui/theme.dart';

class WaveTextTheme {
  final TextStyle base;

  WaveTextTheme({required this.base});

  factory WaveTextTheme.fromColorScheme(WaveColorScheme colorScheme) =>
      WaveTextTheme(base: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: colorScheme.primaryText));
}
