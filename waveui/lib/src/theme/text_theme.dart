import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:waveui/widgets/app.dart';
part 'text_theme.freezed.dart';

@freezed
/// Defines the text styles used throughout the application.
abstract class TextTheme with Diagnosticable, _$TextTheme {
  const TextTheme._();

  /// Creates a [TextTheme].
  factory TextTheme({
    @Default(TextStyle(fontFamily: 'Inter', package: 'waveui', fontSize: 36, height: 1.2, fontWeight: FontWeight.w700))
    TextStyle h1,
    @Default(TextStyle(fontFamily: 'Inter', package: 'waveui', fontSize: 30, height: 1.2, fontWeight: FontWeight.w600))
    TextStyle h2,
    @Default(TextStyle(fontFamily: 'Inter', package: 'waveui', fontSize: 24, height: 1.3, fontWeight: FontWeight.w600))
    TextStyle h3,
    @Default(TextStyle(fontFamily: 'Inter', package: 'waveui', fontSize: 18, height: 1.4, fontWeight: FontWeight.w500))
    TextStyle h4,
    @Default(TextStyle(fontFamily: 'Inter', package: 'waveui', fontSize: 16, height: 1.4, fontWeight: FontWeight.w500))
    TextStyle h5,
    @Default(TextStyle(fontFamily: 'Inter', package: 'waveui', fontSize: 14, height: 1.4, fontWeight: FontWeight.w500))
    TextStyle h6,
    @Default(TextStyle(fontFamily: 'Inter', package: 'waveui', fontSize: 18, height: 1.4, fontWeight: FontWeight.w400))
    TextStyle large,
    @Default(TextStyle(fontFamily: 'Inter', package: 'waveui', fontSize: 16, height: 1.5, fontWeight: FontWeight.w400))
    TextStyle body,
    @Default(TextStyle(fontFamily: 'Inter', package: 'waveui', fontSize: 14, height: 1.4, fontWeight: FontWeight.w400))
    TextStyle small,
  }) = _TextTheme;

  /// Returns a copy of this [TextTheme] with the given [color] applied to all text styles.
  TextTheme apply({Color? color}) => copyWith(
    h1: h1.copyWith(color: color),
    h2: h2.copyWith(color: color),
    h3: h3.copyWith(color: color),
    h4: h4.copyWith(color: color),
    h5: h5.copyWith(color: color),
    h6: h6.copyWith(color: color),
    large: large.copyWith(color: color),
    body: body.copyWith(color: color),
    small: small.copyWith(color: color),
  );

  /// Retrieves the [TextTheme] from the nearest [WaveApp] ancestor.
  ///
  /// This function is used to access the theme data from any widget within the
  /// widget tree. It ensures that the theme is properly inherited and available
  /// to all components that need it.
  ///
  /// Example:
  /// ```dart
  /// final textTheme = TextTheme.of(context);
  /// ```
  ///
  static TextTheme of(BuildContext context) {
    final WaveApp? app = context.dependOnInheritedWidgetOfExactType<WaveApp>();
    assert(app != null, 'No WaveApp found in context');
    return app!.theme.textTheme;
  }
}
