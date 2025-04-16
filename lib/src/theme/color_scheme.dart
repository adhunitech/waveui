import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'color_scheme.freezed.dart';

/// A set of colors that is part of a [WaveThemeData]. It is used to configure the color properties of Waveui widgets.
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
    @Default(0.9) double enabledHoveredOpacity,
    @Default(0.5) double disabledOpacity,
  }) = _WaveColorScheme;

  /// Returns a hovered color for the [foreground] on the [background].
  ///
  /// [WaveColorScheme.background] is used if [background] is not given.
  Color hover(Color foreground, [Color? background]) =>
      Color.alphaBlend(foreground.withValues(alpha: enabledHoveredOpacity), background ?? this.background);

  /// Returns a disabled color for the [foreground] on the [background].
  ///
  /// [WaveColorScheme.background] is used if [background] is not given.
  Color disable(Color foreground, [Color? background]) =>
      Color.alphaBlend(foreground.withValues(alpha: disabledOpacity), background ?? this.background);
}
