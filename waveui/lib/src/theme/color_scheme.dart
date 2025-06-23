import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'color_scheme.freezed.dart';

enum UIState { hovered, pressed, focused, disabled, selected }

/// A color scheme defines the colors that represent the application's brand in styles.
/// It defines the colors that use in a proper and semantic way.
/// Used to represent the application's brand in styles.
@freezed
abstract class ColorScheme with Diagnosticable, _$ColorScheme {
  const ColorScheme._();

  /// Creates a instance of [ColorScheme].
  const factory ColorScheme({
    required Brightness brightness,
    required Color scrim,
    required Color canvas,
    // Brand color
    required Color brandPrimary,
    required Color onBrandPrimary,
    required Color brandSecondary,
    required Color onBrandSecondary,
    required Color brandTertiary,
    required Color onBrandTertiary,
    // text color
    required Color textPrimary,
    required Color textSecondary,
    required Color textTertiary,
    // Funtional color
    required Color statusSuccess,
    required Color statusError,
    required Color statusWarning,
    required Color statusInfo,
    // Container fill color
    required Color surfacePrimary,
    required Color surfaceSecondary,
    required Color surfaceTertiary,
    // Separator color
    required Color outlineStandard,
    required Color outlineDivider,
    // State opacity
    @Default(0.08) double stateHoverOpacity,
    @Default(0.12) double statePressedOpacity,
    @Default(0.24) double stateFocusOpacity,
    @Default(0.38) double stateDisabledOpacity,
  }) = _ColorScheme;

  /// Returns the state overlay color for the [base] on the [background].
  ///
  /// [ColorScheme.canvas] is used if [background] is not given.
  Color getStateOverlay(Color base, UIState state, [Color? background]) {
    final opacity = switch (state) {
      UIState.hovered => stateHoverOpacity,
      UIState.pressed => statePressedOpacity,
      UIState.focused => stateFocusOpacity,
      UIState.disabled => stateDisabledOpacity,
      UIState.selected => statePressedOpacity,
    };
    return Color.alphaBlend(base.withValues(alpha: opacity), background ?? canvas);
  }

  factory ColorScheme.light() => const ColorScheme(
    brightness: Brightness.light,
    scrim: Color(0x2B000000),
    canvas: Color(0xFFF5F5F5),
    brandPrimary: Color(0xFF0065FF),
    onBrandPrimary: Color(0xFFFFFFFF),
    brandSecondary: Color(0xFFF4F4F5),
    onBrandSecondary: Color(0xFF17171B),
    brandTertiary: Color(0xFF17171B),
    onBrandTertiary: Color(0xFFFFFFFF),
    textPrimary: Color(0xDD000000),
    textSecondary: Color(0xDD6B6B6B),
    textTertiary: Color(0x9F6B6B6B),
    statusSuccess: Color(0xFF00BD13),
    statusError: Color(0xFFDB372C),
    statusWarning: Color(0xFFFFB200),
    statusInfo: Color(0xFF0065FF),
    surfacePrimary: Color(0xFFFFFFFF),
    surfaceSecondary: Color(0xFFF5F5F5),
    surfaceTertiary: Color(0xFFFFFFFF),
    outlineStandard: Color(0x839E9E9E),
    outlineDivider: Color(0xFFEEEEEE),
  );
}
