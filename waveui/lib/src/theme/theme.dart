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
/// final theme = WaveTheme(
///   colorScheme: ColorScheme(...),
/// );
/// ```
///
/// This class is immutable. To modify a [Theme] instance, use
/// [Theme.copyWith].
@freezed
abstract class Theme with Diagnosticable, _$Theme {
  const Theme._();

  const factory Theme._internal({
    required WaveAppBarTheme appBarTheme,
    required TextTheme textTheme,
    required ColorScheme colorScheme,
  }) = _WaveTheme;

  /// Creates a [Theme].
  ///
  /// If any parameter is omitted, a default value is used.
  factory Theme({WaveAppBarTheme? appBarTheme, ColorScheme? colorScheme, TextTheme? textTheme}) {
    colorScheme ??= ColorScheme.light();
    textTheme ??= TextTheme().apply(color: colorScheme.textPrimary);
    appBarTheme ??= WaveAppBarTheme(
      backgroundColor: colorScheme.surfacePrimary,
      foregroundColor: colorScheme.textPrimary,
      titleStyle: textTheme.h6,
    );

    return Theme._internal(appBarTheme: appBarTheme, colorScheme: colorScheme, textTheme: textTheme);
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
  ///
  static Theme of(BuildContext context) {
    final WaveApp? app = context.dependOnInheritedWidgetOfExactType<WaveApp>();
    assert(app != null, 'No WaveApp found in context');
    return app!.theme;
  }
}
