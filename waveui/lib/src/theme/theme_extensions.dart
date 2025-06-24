import 'package:flutter/widgets.dart';

extension ThemeExtension on Color {
  Color darkerShade([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final dark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return dark.toColor();
  }
}
