import 'package:flutter/material.dart';
import 'package:waveui/src/theme/colors.dart';

class WaveTextTheme extends TextTheme {
  final bool isDarkMode;

  const WaveTextTheme({
    super.displayLarge,
    super.displayMedium,
    super.displaySmall,
    super.headlineLarge,
    super.headlineMedium,
    super.headlineSmall,
    super.titleLarge,
    super.titleMedium,
    super.titleSmall,
    super.bodyLarge,
    super.bodyMedium,
    super.bodySmall,
    super.labelLarge,
    super.labelMedium,
    super.labelSmall,
    required this.isDarkMode,
  });

  @override
  TextStyle? get bodyLarge => TextStyle(
    fontSize: 18,
    height: 1.25,
    fontWeight: FontWeight.w400,
    color: WaveColors.textColor(darkMode: isDarkMode),
  );

  @override
  TextStyle? get bodyMedium => TextStyle(
    fontSize: 16,
    height: 1.4,
    fontWeight: FontWeight.w400,
    color: WaveColors.textColor(darkMode: isDarkMode),
  );

  @override
  TextStyle? get bodySmall => TextStyle(
    fontSize: 14,
    height: 1.25,
    fontWeight: FontWeight.w400,
    color: WaveColors.subtitleColor(darkMode: isDarkMode),
  );

  @override
  TextStyle? get titleLarge => TextStyle(
    fontSize: 20,
    height: 1.25,
    fontWeight: FontWeight.w500,
    color: WaveColors.textColor(darkMode: isDarkMode),
  );

  @override
  TextStyle? get titleMedium => TextStyle(
    fontSize: 18,
    height: 1.25,
    fontWeight: FontWeight.w500,
    color: WaveColors.textColor(darkMode: isDarkMode),
  );

  @override
  TextStyle? get titleSmall => TextStyle(
    fontSize: 16,
    height: 1.25,
    fontWeight: FontWeight.w500,
    color: WaveColors.textColor(darkMode: isDarkMode),
  );

  @override
  TextStyle? get labelLarge => TextStyle(
    fontSize: 15,
    height: 1,
    fontWeight: FontWeight.w500,
    color: WaveColors.textColor(darkMode: isDarkMode),
  );

  @override
  TextStyle? get labelMedium => TextStyle(
    fontSize: 13,
    height: 1,
    fontWeight: FontWeight.w500,
    color: WaveColors.textColor(darkMode: isDarkMode),
  );

  @override
  TextStyle? get labelSmall => TextStyle(
    fontSize: 11,
    height: 1,
    fontWeight: FontWeight.w500,
    color: WaveColors.textColor(darkMode: isDarkMode),
  );

  @override
  TextStyle? get headlineLarge => TextStyle(
    fontSize: 32,
    height: 1.25,
    fontWeight: FontWeight.w700,
    color: WaveColors.textColor(darkMode: isDarkMode),
  );

  @override
  TextStyle? get headlineMedium => TextStyle(
    fontSize: 28,
    height: 1.25,
    fontWeight: FontWeight.w700,
    color: WaveColors.textColor(darkMode: isDarkMode),
  );

  @override
  TextStyle? get headlineSmall => TextStyle(
    fontSize: 24,
    height: 1.25,
    fontWeight: FontWeight.w700,
    color: WaveColors.textColor(darkMode: isDarkMode),
  );

  @override
  TextStyle? get displayLarge => TextStyle(height: 1.25, color: WaveColors.textColor(darkMode: isDarkMode));

  @override
  TextStyle? get displayMedium => TextStyle(height: 1.25, color: WaveColors.textColor(darkMode: isDarkMode));

  @override
  TextStyle? get displaySmall => TextStyle(height: 1.25, color: WaveColors.textColor(darkMode: isDarkMode));
}
