import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:waveui/widgets/app.dart';

part 'color_scheme.freezed.dart';

/// Represents the various interactive states a UI element can be in.
enum UIState {
  /// The element is being hovered over by a pointer.
  hovered,

  /// The element is currently being pressed or tapped.
  pressed,

  /// The element is focused, typically via keyboard navigation.
  focused,

  /// The element is disabled and cannot be interacted with.
  disabled,

  /// The element is selected.
  selected,
}

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
    required Color shadow,
    // Brand color
    required Color brandPrimary,
    required Color onBrandPrimary,
    required Color brandSecondary,
    required Color onBrandSecondary,
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
    // Separator color
    required Color outlineStandard,
    required Color outlineDivider,
    // State opacity
    @Default(0.8) double stateHoverOpacity,
    @Default(0.7) double statePressedOpacity,
    @Default(0.9) double stateFocusOpacity,
    @Default(0.5) double stateDisabledOpacity,
  }) = _ColorScheme;

  /// Returns the state overlay color for the [base] on the [background].
  ///
  /// [ColorScheme.canvas] is used if [background] is not given.
  Color getStateOverlay(Color base, UIState state, [Color? background]) {
    final isTransparentOrWhite = base.a == 0 || base.toARGB32() == 0xFFFFFFFF;

    if (isTransparentOrWhite) {
      return const Color(0xFFF7F7F7);
    }

    final opacity = switch (state) {
      UIState.hovered => stateHoverOpacity,
      UIState.pressed => statePressedOpacity,
      UIState.focused => stateFocusOpacity,
      UIState.disabled => stateDisabledOpacity,
      UIState.selected => statePressedOpacity,
    };

    return Color.alphaBlend(base.withValues(alpha: opacity), background ?? canvas);
  }

  /// Returns a [ColorScheme] for light mode.
  factory ColorScheme.light() => const ColorScheme(
    brightness: Brightness.light,
    shadow: Color(0x1F000000),
    scrim: Color(0x2B000000),
    canvas: Color(0xFFF5F5F5),
    brandPrimary: Color(0xFF2463EB),
    onBrandPrimary: Color(0xFFFFFFFF),
    brandSecondary: Color(0xFFF5F5F5),
    onBrandSecondary: Color(0xFF17171B),
    textPrimary: Color(0xFF17171B),
    textSecondary: Color(0xDD6B6B6B),
    textTertiary: Color(0x9F6B6B6B),
    statusSuccess: Color(0xFF00BD13),
    statusError: Color(0xFFDB372C),
    statusWarning: Color(0xFFFFB200),
    statusInfo: Color(0xFF2463EB),
    surfacePrimary: Color(0xFFFFFFFF),
    surfaceSecondary: Color(0xFFF5F5F5),
    outlineStandard: Color(0xFFE5E5E5),
    outlineDivider: Color(0xFFEEEEEE),
  );

  /// Retrieves the [ColorScheme] from the nearest [WaveApp] ancestor.
  ///
  /// This function is used to access the theme data from any widget within the
  /// widget tree. It ensures that the theme is properly inherited and available
  /// to all components that need it.
  ///
  /// Example:
  /// ```dart
  /// final colorScheme = ColorScheme.of(context);
  /// ```
  ///
  static ColorScheme of(BuildContext context) {
    final WaveApp? app = context.dependOnInheritedWidgetOfExactType<WaveApp>();
    assert(app != null, 'No WaveApp found in context');
    return app!.theme.colorScheme;
  }
}
