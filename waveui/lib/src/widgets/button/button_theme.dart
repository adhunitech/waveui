import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:waveui/waveui.dart';

part 'button_theme.freezed.dart';

@freezed
abstract class ButtonTheme with Diagnosticable, _$ButtonTheme {
  const ButtonTheme._();

  const factory ButtonTheme({
    required ButtonTypeTheme primaryButton,
    required ButtonTypeTheme secondaryButton,
    required ButtonTypeTheme tertiaryButton,
    required ButtonTypeTheme destructiveButton,
    required ButtonTypeTheme outlineButton,
    required ButtonTypeTheme ghostButton,
    required ButtonTypeTheme linkButton,
  }) = _ButtonTheme;

  /// Retrieves the [ButtonTheme] from the nearest [WaveApp] ancestor.
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
  static ButtonTheme of(BuildContext context) {
    final WaveApp? app = context.dependOnInheritedWidgetOfExactType<WaveApp>();
    assert(app != null, 'No WaveApp found in context');
    return app!.theme.buttonTheme;
  }
}
