import 'package:google_fonts/google_fonts.dart';
import 'package:waveui/waveui.dart';

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
  TextStyle? get bodyLarge => GoogleFonts.inter(
        fontSize: 18,
        height: 1.25,
        fontWeight: FontWeight.w400,
        color: WaveColors.textColor(darkMode: isDarkMode),
      );

  @override
  TextStyle? get bodyMedium => GoogleFonts.inter(
        fontSize: 16,
        height: 1.4,
        fontWeight: FontWeight.w400,
        color: WaveColors.textColor(darkMode: isDarkMode),
      );

  @override
  TextStyle? get bodySmall => GoogleFonts.inter(
        fontSize: 14,
        height: 1.25,
        fontWeight: FontWeight.w400,
        color: WaveColors.subtitleColor(darkMode: isDarkMode),
      );

  @override
  TextStyle? get titleLarge => GoogleFonts.inter(
        fontSize: 20,
        height: 1.25,
        fontWeight: FontWeight.w500,
        color: WaveColors.textColor(darkMode: isDarkMode),
      );

  @override
  TextStyle? get titleMedium => GoogleFonts.inter(
        fontSize: 18,
        height: 1.25,
        fontWeight: FontWeight.w500,
        color: WaveColors.textColor(darkMode: isDarkMode),
      );

  @override
  TextStyle? get titleSmall => GoogleFonts.inter(
        fontSize: 16,
        height: 1.25,
        fontWeight: FontWeight.w500,
        color: WaveColors.textColor(darkMode: isDarkMode),
      );

  @override
  TextStyle? get labelLarge => GoogleFonts.inter(
        fontSize: 15,
        height: 1,
        fontWeight: FontWeight.w500,
        color: WaveColors.textColor(darkMode: isDarkMode),
      );

  @override
  TextStyle? get labelMedium => GoogleFonts.inter(
        fontSize: 13,
        height: 1,
        fontWeight: FontWeight.w500,
        color: WaveColors.textColor(darkMode: isDarkMode),
      );

  @override
  TextStyle? get labelSmall => GoogleFonts.inter(
        fontSize: 11,
        height: 1,
        fontWeight: FontWeight.w500,
        color: WaveColors.textColor(darkMode: isDarkMode),
      );

  @override
  TextStyle? get headlineLarge => GoogleFonts.inter(
        fontSize: 32,
        height: 1.25,
        fontWeight: FontWeight.w700,
        color: WaveColors.textColor(darkMode: isDarkMode),
      );

  @override
  TextStyle? get headlineMedium => GoogleFonts.inter(
        fontSize: 28,
        height: 1.25,
        fontWeight: FontWeight.w700,
        color: WaveColors.textColor(darkMode: isDarkMode),
      );

  @override
  TextStyle? get headlineSmall => GoogleFonts.inter(
        fontSize: 24,
        height: 1.25,
        fontWeight: FontWeight.w700,
        color: WaveColors.textColor(darkMode: isDarkMode),
      );

  @override
  TextStyle? get displayLarge => GoogleFonts.inter(
        fontSize: 78,
        height: 1.25,
        fontWeight: FontWeight.w300,
        color: WaveColors.textColor(darkMode: isDarkMode),
      );

  @override
  TextStyle? get displayMedium => GoogleFonts.inter(
        fontSize: 64,
        height: 1.25,
        fontWeight: FontWeight.w300,
        color: WaveColors.textColor(darkMode: isDarkMode),
      );

  @override
  TextStyle? get displaySmall => GoogleFonts.inter(
        fontSize: 48,
        height: 1.25,
        fontWeight: FontWeight.w300,
        color: WaveColors.textColor(darkMode: isDarkMode),
      );
}
