import 'dart:ui';

class WaveColorScheme {
  final Color primary;
  final Color background;
  final Color surface;
  final Color primaryText;
  final Color secondaryText;
  final Color separator;

  const WaveColorScheme({
    required this.primary,
    required this.background,
    required this.surface,
    required this.primaryText,
    required this.secondaryText,
    required this.separator,
  });

  factory WaveColorScheme.light() => const WaveColorScheme(
    primary: Color(0xFF1869DF),
    background: Color(0xFFF1F3F5),
    surface: Color(0xFFFFFFFF),
    primaryText: Color(0xDD000000),
    secondaryText: Color(0x89000000),
    separator: Color(0x4B9E9E9E),
  );

  factory WaveColorScheme.dark() => const WaveColorScheme(
    primary: Color(0xFF1869DF),
    background: Color(0xFF0A0A0A),
    surface: Color(0xff121212),
    primaryText: Color(0xDDFFFFFF),
    secondaryText: Color(0x88FFFFFF),
    separator: Color(0x4B9E9E9E),
  );
}
