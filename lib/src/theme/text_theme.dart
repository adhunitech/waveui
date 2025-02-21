import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:waveui/material/theme.dart';

part 'text_theme.freezed.dart';

@freezed
class TextTheme with _$TextTheme {
  const factory TextTheme({
    TextStyle? displayLarge,
    TextStyle? displayMedium,
    TextStyle? displaySmall,
    TextStyle? headlineLarge,
    TextStyle? headlineMedium,
    TextStyle? headlineSmall,
    TextStyle? titleLarge,
    TextStyle? titleMedium,
    TextStyle? titleSmall,
    TextStyle? bodyLarge,
    TextStyle? bodyMedium,
    TextStyle? bodySmall,
    TextStyle? labelLarge,
    TextStyle? labelMedium,
    TextStyle? labelSmall,
  }) = _TextTheme;

  const TextTheme._();

  TextTheme merge(TextTheme? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      displayLarge: displayLarge?.merge(other.displayLarge) ?? other.displayLarge,
      displayMedium: displayMedium?.merge(other.displayMedium) ?? other.displayMedium,
      displaySmall: displaySmall?.merge(other.displaySmall) ?? other.displaySmall,
      headlineLarge: headlineLarge?.merge(other.headlineLarge) ?? other.headlineLarge,
      headlineMedium: headlineMedium?.merge(other.headlineMedium) ?? other.headlineMedium,
      headlineSmall: headlineSmall?.merge(other.headlineSmall) ?? other.headlineSmall,
      titleLarge: titleLarge?.merge(other.titleLarge) ?? other.titleLarge,
      titleMedium: titleMedium?.merge(other.titleMedium) ?? other.titleMedium,
      titleSmall: titleSmall?.merge(other.titleSmall) ?? other.titleSmall,
      bodyLarge: bodyLarge?.merge(other.bodyLarge) ?? other.bodyLarge,
      bodyMedium: bodyMedium?.merge(other.bodyMedium) ?? other.bodyMedium,
      bodySmall: bodySmall?.merge(other.bodySmall) ?? other.bodySmall,
      labelLarge: labelLarge?.merge(other.labelLarge) ?? other.labelLarge,
      labelMedium: labelMedium?.merge(other.labelMedium) ?? other.labelMedium,
      labelSmall: labelSmall?.merge(other.labelSmall) ?? other.labelSmall,
    );
  }

  TextTheme apply({
    String? fontFamily,
    List<String>? fontFamilyFallback,
    String? package,
    double fontSizeFactor = 1.0,
    double fontSizeDelta = 0.0,
    Color? displayColor,
    Color? bodyColor,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
  }) => TextTheme(
    displayLarge: displayLarge?.apply(
      color: displayColor,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      fontSizeFactor: fontSizeFactor,
      fontSizeDelta: fontSizeDelta,
      package: package,
    ),
    displayMedium: displayMedium?.apply(
      color: displayColor,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      fontSizeFactor: fontSizeFactor,
      fontSizeDelta: fontSizeDelta,
      package: package,
    ),
    displaySmall: displaySmall?.apply(
      color: displayColor,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      fontSizeFactor: fontSizeFactor,
      fontSizeDelta: fontSizeDelta,
      package: package,
    ),
    headlineLarge: headlineLarge?.apply(
      color: displayColor,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      fontSizeFactor: fontSizeFactor,
      fontSizeDelta: fontSizeDelta,
      package: package,
    ),
    headlineMedium: headlineMedium?.apply(
      color: displayColor,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      fontSizeFactor: fontSizeFactor,
      fontSizeDelta: fontSizeDelta,
      package: package,
    ),
    headlineSmall: headlineSmall?.apply(
      color: bodyColor,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      fontSizeFactor: fontSizeFactor,
      fontSizeDelta: fontSizeDelta,
      package: package,
    ),
    titleLarge: titleLarge?.apply(
      color: bodyColor,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      fontSizeFactor: fontSizeFactor,
      fontSizeDelta: fontSizeDelta,
      package: package,
    ),
    titleMedium: titleMedium?.apply(
      color: bodyColor,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      fontSizeFactor: fontSizeFactor,
      fontSizeDelta: fontSizeDelta,
      package: package,
    ),
    titleSmall: titleSmall?.apply(
      color: bodyColor,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      fontSizeFactor: fontSizeFactor,
      fontSizeDelta: fontSizeDelta,
      package: package,
    ),
    bodyLarge: bodyLarge?.apply(
      color: bodyColor,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      fontSizeFactor: fontSizeFactor,
      fontSizeDelta: fontSizeDelta,
      package: package,
    ),
    bodyMedium: bodyMedium?.apply(
      color: bodyColor,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      fontSizeFactor: fontSizeFactor,
      fontSizeDelta: fontSizeDelta,
      package: package,
    ),
    bodySmall: bodySmall?.apply(
      color: displayColor,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      fontSizeFactor: fontSizeFactor,
      fontSizeDelta: fontSizeDelta,
      package: package,
    ),
    labelLarge: labelLarge?.apply(
      color: bodyColor,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      fontSizeFactor: fontSizeFactor,
      fontSizeDelta: fontSizeDelta,
      package: package,
    ),
    labelMedium: labelMedium?.apply(
      color: bodyColor,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      fontSizeFactor: fontSizeFactor,
      fontSizeDelta: fontSizeDelta,
      package: package,
    ),
    labelSmall: labelSmall?.apply(
      color: bodyColor,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      fontSizeFactor: fontSizeFactor,
      fontSizeDelta: fontSizeDelta,
      package: package,
    ),
  );

  static TextTheme lerp(TextTheme? a, TextTheme? b, double t) {
    if (identical(a, b) && a != null) {
      return a;
    }
    return TextTheme(
      displayLarge: TextStyle.lerp(a?.displayLarge, b?.displayLarge, t),
      displayMedium: TextStyle.lerp(a?.displayMedium, b?.displayMedium, t),
      displaySmall: TextStyle.lerp(a?.displaySmall, b?.displaySmall, t),
      headlineLarge: TextStyle.lerp(a?.headlineLarge, b?.headlineLarge, t),
      headlineMedium: TextStyle.lerp(a?.headlineMedium, b?.headlineMedium, t),
      headlineSmall: TextStyle.lerp(a?.headlineSmall, b?.headlineSmall, t),
      titleLarge: TextStyle.lerp(a?.titleLarge, b?.titleLarge, t),
      titleMedium: TextStyle.lerp(a?.titleMedium, b?.titleMedium, t),
      titleSmall: TextStyle.lerp(a?.titleSmall, b?.titleSmall, t),
      bodyLarge: TextStyle.lerp(a?.bodyLarge, b?.bodyLarge, t),
      bodyMedium: TextStyle.lerp(a?.bodyMedium, b?.bodyMedium, t),
      bodySmall: TextStyle.lerp(a?.bodySmall, b?.bodySmall, t),
      labelLarge: TextStyle.lerp(a?.labelLarge, b?.labelLarge, t),
      labelMedium: TextStyle.lerp(a?.labelMedium, b?.labelMedium, t),
      labelSmall: TextStyle.lerp(a?.labelSmall, b?.labelSmall, t),
    );
  }

  static TextTheme of(BuildContext context) => Theme.of(context).textTheme;

  static TextTheme primaryOf(BuildContext context) => Theme.of(context).primaryTextTheme;
}
