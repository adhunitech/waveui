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
/// This class is immutable. To modify a [WaveTheme] instance, use
/// [WaveTheme.copyWith].
@freezed
abstract class WaveTheme with Diagnosticable, _$WaveTheme {
  const WaveTheme._();

  const factory WaveTheme._internal({
    required WaveAppBarTheme appBarTheme,
    required WaveTextTheme textTheme,
    required ColorScheme colorScheme,
  }) = _WaveTheme;

  factory WaveTheme({WaveAppBarTheme? appBarTheme, ColorScheme? colorScheme, WaveTextTheme? textTheme}) {
    colorScheme ??= ColorScheme.light();
    textTheme ??= WaveTextTheme().apply(color: colorScheme.textPrimary);
    appBarTheme ??= WaveAppBarTheme(
      backgroundColor: colorScheme.surfacePrimary,
      foregroundColor: colorScheme.textPrimary,
      titleStyle: textTheme.h6,
    );

    return WaveTheme._internal(appBarTheme: appBarTheme, colorScheme: colorScheme, textTheme: textTheme);
  }

  /// Retrieves the [WaveTheme] from the nearest [WaveApp] ancestor.
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
  static WaveTheme of(BuildContext context) {
    final WaveApp? app = context.dependOnInheritedWidgetOfExactType<WaveApp>();
    assert(app != null, 'No WaveApp found in context');
    return app!.theme;
  }
}
