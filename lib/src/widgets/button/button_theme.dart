import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class WaveButtonTheme {
  final Color color;
  final TextStyle textStyle;

  WaveButtonTheme({required this.color, required this.textStyle});

  WaveButtonTheme copyWith({Color? color, TextStyle? textStyle}) =>
      WaveButtonTheme(color: color ?? this.color, textStyle: textStyle ?? this.textStyle);

  static WaveButtonTheme lerp(WaveButtonTheme a, WaveButtonTheme b, double t) => WaveButtonTheme(
    color: Color.lerp(a.color, b.color, t) ?? a.color,
    textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t) ?? a.textStyle,
  );
}
