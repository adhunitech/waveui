import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'color_scheme.freezed.dart';

/// A color scheme defines the colors that represent the application's brand in styles.
/// It defines the colors that use in a proper and semantic way.
/// Used to represent the application's brand in styles.
@freezed
abstract class WaveColorScheme with Diagnosticable, _$WaveColorScheme {
  const WaveColorScheme._();

  /// Creates a instance of [WaveColorScheme].
  const factory WaveColorScheme({
    required Brightness brightness,
    required Color barrier,
    required Color background,
    // Brand color
    required Color primary,
    required Color onPrimary,
    required Color secondary,
    required Color onSecondary,
    // Label color
    required Color labelPrimary,
    required Color labelSecondary,
    required Color labelTertiary,
    // Funtional color
    required Color success,
    required Color error,
    required Color warning,
    required Color tip,
    // Container fill color
    required Color contentPrimary,
    required Color contentSecondary,
    required Color contentTertiary,
    // Separator color
    required Color border,
    required Color divider,
    @Default(0.6) double hoveredOpacity,
    @Default(0.3) double disabledOpacity,
  }) = _WaveColorScheme;

  /// Returns a hovered color for the [foreground] on the [background].
  ///
  /// [WaveColorScheme.background] is used if [background] is not given.
  Color hover(Color foreground, [Color? background]) =>
      Color.alphaBlend(foreground.withValues(alpha: hoveredOpacity), background ?? this.background);

  /// Returns a disabled color for the [foreground] on the [background].
  ///
  /// [WaveColorScheme.background] is used if [background] is not given.
  Color disable(Color foreground, [Color? background]) =>
      Color.alphaBlend(foreground.withValues(alpha: disabledOpacity), background ?? this.background);

  factory WaveColorScheme.light() => const WaveColorScheme(
    brightness: Brightness.light,
    barrier: Color(0x2B000000),
    background: Color(0xFFF5F5F5),
    primary: Color(0xFF0065FF),
    onPrimary: Color(0xDDFFFFFF),
    secondary: Color(0xFFF4F4F5),
    onSecondary: Color(0xFF17171B),
    labelPrimary: Color(0xDD000000),
    labelSecondary: Color(0xDD6B6B6B),
    labelTertiary: Color(0x9F6B6B6B),
    success: Color(0xFF00BD13),
    error: Color(0xFFDB372C),
    warning: Color(0xFFFFB200),
    tip: Color(0xFF0065FF),
    contentPrimary: Color(0xFFFFFFFF),
    contentSecondary: Color(0xFFF5F5F5),
    contentTertiary: Color(0xFFFFFFFF),
    border: Color(0x839E9E9E),
    divider: Color(0xFFEEEEEE),
  );
}
