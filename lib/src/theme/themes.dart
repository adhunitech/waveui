import 'package:flutter/material.dart';
import 'package:waveui/src/theme/color_scheme.dart';
import 'package:waveui/waveui.dart';

class WaveTheme {
  final WaveColorScheme colorScheme;

  const WaveTheme({required this.colorScheme});

  static WaveTheme of(BuildContext context) {
    final WaveTheme? waveTheme = context.dependOnInheritedWidgetOfExactType<WaveApp>()?.theme;
    assert(waveTheme != null, 'WaveTheme not found in context');
    return waveTheme!;
  }
}
