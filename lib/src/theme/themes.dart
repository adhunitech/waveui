import 'package:flutter/material.dart';
import 'package:waveui/waveui.dart';

class WaveTheme {
  final WaveColorScheme colorScheme;
  final WaveTextTheme textTheme;

  const WaveTheme({required this.colorScheme, required this.textTheme});

  static WaveTheme of(BuildContext context) {
    final WaveTheme? waveTheme = context.dependOnInheritedWidgetOfExactType<WaveApp>()?.theme;
    assert(waveTheme != null, 'WaveTheme not found in context');
    return waveTheme!;
  }

  factory WaveTheme.light() => WaveTheme(
    colorScheme: WaveColorScheme.light(),
    textTheme: WaveTextTheme.fromColorScheme(WaveColorScheme.light()),
  );

  factory WaveTheme.dark() =>
      WaveTheme(colorScheme: WaveColorScheme.dark(), textTheme: WaveTextTheme.fromColorScheme(WaveColorScheme.dark()));
}
