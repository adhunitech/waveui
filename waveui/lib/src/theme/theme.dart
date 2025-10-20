import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:waveui/waveui.dart';

part 'theme.freezed.dart';

/// A class that defines the theme data for Wave UI components.
///
/// The theme data includes configuration for various visual properties like colors,
/// typography, and other design elements used throughout the Wave UI framework.
///
/// Example:
/// ```dart
/// final theme = Theme(
///   colorScheme: ColorScheme(...),
/// );
/// ```
///
/// This class is immutable. To modify a [Theme] instance, use
/// [Theme.copyWith].
@freezed
abstract class Theme with DiagnosticableTreeMixin, _$Theme {
  const Theme._();

  const factory Theme({
    required WaveAppBarTheme appBarTheme,
    required TextTheme textTheme,
    required ColorScheme colorScheme,
    required ButtonTheme buttonTheme,
  }) = _Theme;

  /// Creates a [Theme].
  ///
  /// If any parameter is omitted, a default value is used.
  factory Theme.light({
    WaveAppBarTheme? appBarTheme,
    ColorScheme? colorScheme,
    TextTheme? textTheme,
    ButtonTheme? buttonTheme,
  }) {
    colorScheme ??= ColorScheme.light();
    textTheme ??= TextTheme().apply(color: colorScheme.textPrimary);
    appBarTheme ??= WaveAppBarTheme(
      backgroundColor: colorScheme.surfacePrimary,
      foregroundColor: colorScheme.textPrimary,
      titleStyle: textTheme.h4,
    );

    buttonTheme ??= ButtonTheme(
      primaryButton: ButtonTypeTheme(
        labelStyle: textTheme.h6.copyWith(color: colorScheme.onBrandPrimary),
        iconTheme: IconThemeData(size: 20, color: colorScheme.onBrandPrimary),
        backgroundColor: colorScheme.brandPrimary,
        borderColor: colorScheme.brandPrimary.darkerShade(0.05),
      ),
      secondaryButton: ButtonTypeTheme(
        labelStyle: textTheme.h6.copyWith(color: colorScheme.onBrandSecondary),
        iconTheme: IconThemeData(size: 20, color: colorScheme.onBrandSecondary),
        backgroundColor: colorScheme.brandSecondary,
      ),
      ghostButton: ButtonTypeTheme(
        labelStyle: textTheme.h6.copyWith(color: colorScheme.textPrimary),
        iconTheme: IconThemeData(size: 20, color: colorScheme.textPrimary),
        backgroundColor: colorScheme.surfacePrimary,
      ),
      outlineButton: ButtonTypeTheme(
        labelStyle: textTheme.h6.copyWith(color: colorScheme.textPrimary),
        iconTheme: IconThemeData(size: 20, color: colorScheme.textPrimary),
        backgroundColor: colorScheme.surfacePrimary,
        borderColor: colorScheme.outlineStandard,
      ),
      destructiveButton: ButtonTypeTheme(
        labelStyle: textTheme.h6.copyWith(color: colorScheme.onBrandPrimary),
        iconTheme: IconThemeData(size: 20, color: colorScheme.onBrandPrimary),
        backgroundColor: colorScheme.statusError,
        borderColor: colorScheme.statusError.darkerShade(0.05),
      ),
    );

    return Theme(appBarTheme: appBarTheme, colorScheme: colorScheme, textTheme: textTheme, buttonTheme: buttonTheme);
  }

  /// Retrieves the [Theme] from the nearest [WaveApp] ancestor.
  ///
  /// This function is used to access the theme data from any widget within the
  /// widget tree. It ensures that the theme is properly inherited and available
  /// to all components that need it.
  ///
  /// Example:
  /// ```dart
  /// final theme = Theme.of(context);
  /// ```
  static Theme of(BuildContext context) {
    final WaveApp? app = context.dependOnInheritedWidgetOfExactType<WaveApp>();
    assert(app != null, 'No WaveApp found in context');
    return app!.theme;
  }
}
