import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:meta/meta.dart';

import 'package:forui/forui.dart';

/// Definitions for the various typographical styles that are part of a [FThemeData].
///
/// A [FTypography] contains scalar values for scaling a [TextStyle]'s corresponding properties. It also contains labelled
/// font sizes, such as [FTypography.caption].
///
/// The scaling is applied automatically in all Waveui widgets while the labelled font sizes are used as the defaults
/// for the corresponding properties of widget styles configured via `inherit(...)` constructors.
final class FTypography with Diagnosticable, FTransformable {
  /// The default font family. Defaults to [`packages/forui/Inter`](https://fonts.google.com/specimen/Inter).
  ///
  /// ## Contract:
  /// Throws an [AssertionError] if empty.
  final String defaultFontFamily;

  /// The font size for headline 1 text.
  ///
  /// Defaults to:
  /// * `fontSize` = 32.
  /// * `height` = 1.25.
  /// * `fontWeight` = FontWeight.bold.
  /// * `letterSpacing` = -0.5.
  final TextStyle h1;

  /// The font size for headline 2 text.
  ///
  /// Defaults to:
  /// * `fontSize` = 28.
  /// * `height` = 1.2857.
  /// * `fontWeight` = FontWeight.bold.
  /// * `letterSpacing` = -0.25.
  final TextStyle h2;

  /// The font size for headline 3 text.
  ///
  /// Defaults to:
  /// * `fontSize` = 24.
  /// * `height` = 1.3333.
  /// * `fontWeight` = FontWeight.w600.
  /// * `letterSpacing` = 0.0.
  final TextStyle h3;

  /// The font size for headline 4 text.
  ///
  /// Defaults to:
  /// * `fontSize` = 20.
  /// * `height` = 1.4.
  /// * `fontWeight` = FontWeight.w600.
  /// * `letterSpacing` = 0.15.
  final TextStyle h4;

  /// The font size for headline 5 text.
  ///
  /// Defaults to:
  /// * `fontSize` = 18.
  /// * `height` = 1.4444.
  /// * `fontWeight` = FontWeight.w500.
  /// * `letterSpacing` = 0.1.
  final TextStyle h5;

  /// The font size for headline 6 text.
  ///
  /// Defaults to:
  /// * `fontSize` = 16.
  /// * `height` = 1.5.
  /// * `fontWeight` = FontWeight.w500.
  /// * `letterSpacing` = 0.1.
  final TextStyle h6;

  /// The font size for Body Large text.
  ///
  /// Defaults to:
  /// * `fontSize` = 18.
  /// * `height` = 1.6.
  /// * `fontWeight` = FontWeight.w400.
  /// * `letterSpacing` = 0.1.
  final TextStyle bodyLarge;

  /// The font size for standard Body text.
  ///
  /// Defaults to:
  /// * `fontSize` = 16.
  /// * `height` = 1.6.
  /// * `fontWeight` = FontWeight.w400.
  /// * `letterSpacing` = 0.1.
  final TextStyle body;

  /// The font size for Caption text.
  ///
  /// Defaults to:
  /// * `fontSize` = 12.
  /// * `height` = 1.4.
  /// * `fontWeight` = FontWeight.w400.
  /// * `letterSpacing` = 0.1.
  final TextStyle caption;

  /// The font size for Muted Text.
  ///
  /// Defaults to:
  /// * `fontSize` = 14.
  /// * `height` = 1.4.
  /// * `fontWeight` = FontWeight.w400.
  /// * `letterSpacing` = 0.1.
  final TextStyle mutedText;

  /// Creates a [FTypography].
  const FTypography({
    this.defaultFontFamily = 'packages/forui/Inter',
    this.h1 = const TextStyle(fontSize: 32, height: 1.25, fontWeight: FontWeight.bold, letterSpacing: -0.5),
    this.h2 = const TextStyle(fontSize: 28, height: 1.2857, fontWeight: FontWeight.bold, letterSpacing: -0.25),
    this.h3 = const TextStyle(fontSize: 24, height: 1.3333, fontWeight: FontWeight.w600, letterSpacing: 0.0),
    this.h4 = const TextStyle(fontSize: 20, height: 1.4, fontWeight: FontWeight.w600, letterSpacing: 0.15),
    this.h5 = const TextStyle(fontSize: 18, height: 1.4444, fontWeight: FontWeight.w500, letterSpacing: 0.1),
    this.h6 = const TextStyle(fontSize: 16, height: 1.5, fontWeight: FontWeight.w500, letterSpacing: 0.1),
    this.bodyLarge = const TextStyle(fontSize: 18, height: 1.6, fontWeight: FontWeight.w400, letterSpacing: 0.1),
    this.body = const TextStyle(fontSize: 16, height: 1.6, fontWeight: FontWeight.w400, letterSpacing: 0.1),
    this.caption = const TextStyle(fontSize: 12, height: 1.4, fontWeight: FontWeight.w400, letterSpacing: 0.1),
    this.mutedText = const TextStyle(fontSize: 14, height: 1.4, fontWeight: FontWeight.w400, letterSpacing: 0.1),
  }) : assert(0 < defaultFontFamily.length, 'The defaultFontFamily should not be empty.');

  /// Creates a [FTypography] that inherits its properties from [colorScheme].
  FTypography.inherit({required FColorScheme colorScheme, this.defaultFontFamily = 'packages/forui/Inter'})
    : h1 = TextStyle(
        color: colorScheme.foreground,
        fontFamily: defaultFontFamily,
        fontSize: 32,
        height: 1.25,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
      ),
      h2 = TextStyle(
        color: colorScheme.foreground,
        fontFamily: defaultFontFamily,
        fontSize: 28,
        height: 1.2857,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.25,
      ),
      h3 = TextStyle(
        color: colorScheme.foreground,
        fontFamily: defaultFontFamily,
        fontSize: 24,
        height: 1.3333,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.0,
      ),
      h4 = TextStyle(
        color: colorScheme.foreground,
        fontFamily: defaultFontFamily,
        fontSize: 20,
        height: 1.4,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
      ),
      h5 = TextStyle(
        color: colorScheme.foreground,
        fontFamily: defaultFontFamily,
        fontSize: 18,
        height: 1.4444,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      h6 = TextStyle(
        color: colorScheme.foreground,
        fontFamily: defaultFontFamily,
        fontSize: 16,
        height: 1.5,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      bodyLarge = TextStyle(
        color: colorScheme.foreground,
        fontFamily: defaultFontFamily,
        fontSize: 18,
        height: 1.6,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
      ),
      body = TextStyle(
        color: colorScheme.foreground,
        fontFamily: defaultFontFamily,
        fontSize: 16,
        height: 1.6,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
      ),
      caption = TextStyle(
        color: colorScheme.foreground,
        fontFamily: defaultFontFamily,
        fontSize: 12,
        height: 1.4,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
      ),
      mutedText = TextStyle(
        color: colorScheme.mutedForeground,
        fontFamily: defaultFontFamily,
        fontSize: 14,
        height: 1.4,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
      ),
      assert(defaultFontFamily.isNotEmpty, 'The defaultFontFamily should not be empty.');

  /// Scales the fields of this [FTypography] by the given fields.
  ///
  /// ```dart
  /// const typography = FTypography(
  ///   sm: TextStyle(fontSize: 10),
  ///   base: TextStyle(fontSize: 20),
  /// );
  ///
  /// final scaled = typography.scale(sizeScalar: 1.5);
  ///
  /// print(scaled.sm.fontSize); // 15
  /// print(scaled.base.fontSize); // 30
  /// ```
  @useResult
  FTypography scale({double sizeScalar = 1}) => FTypography(
    defaultFontFamily: defaultFontFamily,
    h1: _scaleTextStyle(style: h1, sizeScalar: sizeScalar),
    h2: _scaleTextStyle(style: h2, sizeScalar: sizeScalar),
    h3: _scaleTextStyle(style: h3, sizeScalar: sizeScalar),
    h4: _scaleTextStyle(style: h4, sizeScalar: sizeScalar),
    h5: _scaleTextStyle(style: h5, sizeScalar: sizeScalar),
    h6: _scaleTextStyle(style: h6, sizeScalar: sizeScalar),
    bodyLarge: _scaleTextStyle(style: bodyLarge, sizeScalar: sizeScalar),
    body: _scaleTextStyle(style: body, sizeScalar: sizeScalar),
    caption: _scaleTextStyle(style: caption, sizeScalar: sizeScalar),
    mutedText: _scaleTextStyle(style: mutedText, sizeScalar: sizeScalar),
  );

  // default font size: https://api.flutter.dev/flutter/painting/TextStyle/fontSize.html
  TextStyle _scaleTextStyle({required TextStyle style, required double sizeScalar}) =>
      style.copyWith(fontSize: (style.fontSize ?? 14) * sizeScalar);

  /// Returns a copy of this [FTypography] with the given properties replaced.
  ///
  /// ```dart
  /// const typography = FTypography(
  ///   defaultFontFamily: 'packages/forui/my-font',
  ///   sm: TextStyle(fontSize: 10),
  ///   base: TextStyle(fontSize: 20),
  /// );
  ///
  /// final copy = typography.copyWith(defaultFontFamily: 'packages/forui/another-font');
  ///
  /// print(copy.defaultFontFamily); // 'packages/forui/another-font'
  /// print(copy.sm.fontSize); // 10
  /// print(copy.base.fontSize); // 20
  /// ```
  @useResult
  FTypography copyWith({
    String? defaultFontFamily,
    TextStyle? xs,
    TextStyle? sm,
    TextStyle? base,
    TextStyle? lg,
    TextStyle? xl,
    TextStyle? xl2,
    TextStyle? xl3,
    TextStyle? h1,
    TextStyle? h2,
    TextStyle? h3,
    TextStyle? h4,
    TextStyle? h5,
    TextStyle? h6,
    TextStyle? bodyLarge,
    TextStyle? body,
    TextStyle? caption,
    TextStyle? mutedText,
  }) => FTypography(
    defaultFontFamily: defaultFontFamily ?? this.defaultFontFamily,
    h1: h1 ?? this.h1,
    h2: h2 ?? this.h2,
    h3: h3 ?? this.h3,
    h4: h4 ?? this.h4,
    h5: h5 ?? this.h5,
    h6: h6 ?? this.h6,
    bodyLarge: bodyLarge ?? this.bodyLarge,
    body: body ?? this.body,
    caption: caption ?? this.caption,
    mutedText: mutedText ?? this.mutedText,
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('defaultFontFamily', defaultFontFamily, defaultValue: 'packages/forui/Inter'))
      ..add(DiagnosticsProperty('h1', h1))
      ..add(DiagnosticsProperty('h2', h2))
      ..add(DiagnosticsProperty('h3', h3))
      ..add(DiagnosticsProperty('h4', h4))
      ..add(DiagnosticsProperty('h5', h5))
      ..add(DiagnosticsProperty('h6', h6))
      ..add(DiagnosticsProperty('bodyLarge', bodyLarge))
      ..add(DiagnosticsProperty('body', body))
      ..add(DiagnosticsProperty('caption', caption))
      ..add(DiagnosticsProperty('mutedText', mutedText));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FTypography &&
          runtimeType == other.runtimeType &&
          defaultFontFamily == other.defaultFontFamily &&
          h1 == other.h1 &&
          h2 == other.h2 &&
          h3 == other.h3 &&
          h4 == other.h4 &&
          h5 == other.h5 &&
          h6 == other.h6 &&
          bodyLarge == other.bodyLarge &&
          body == other.body &&
          caption == other.caption &&
          mutedText == other.mutedText;

  @override
  int get hashCode =>
      defaultFontFamily.hashCode ^
      h1.hashCode ^
      h2.hashCode ^
      h3.hashCode ^
      h4.hashCode ^
      h5.hashCode ^
      h6.hashCode ^
      bodyLarge.hashCode ^
      body.hashCode ^
      caption.hashCode ^
      mutedText.hashCode;
}
