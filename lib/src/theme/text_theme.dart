import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'text_theme.freezed.dart';

@freezed
abstract class WaveTextTheme with Diagnosticable, _$WaveTextTheme {
  const WaveTextTheme._();
  factory WaveTextTheme({
    @Default(TextStyle(fontFamily: 'Inter', package: 'waveui', fontSize: 36, height: 1.2, fontWeight: FontWeight.w700))
    TextStyle h1,
    @Default(TextStyle(fontFamily: 'Inter', package: 'waveui', fontSize: 30, height: 1.2, fontWeight: FontWeight.w600))
    TextStyle h2,
    @Default(TextStyle(fontFamily: 'Inter', package: 'waveui', fontSize: 24, height: 1.3, fontWeight: FontWeight.w600))
    TextStyle h3,
    @Default(TextStyle(fontFamily: 'Inter', package: 'waveui', fontSize: 18, height: 1.4, fontWeight: FontWeight.w500))
    TextStyle h4,
    @Default(TextStyle(fontFamily: 'Inter', package: 'waveui', fontSize: 18, height: 1.4, fontWeight: FontWeight.w400))
    TextStyle large,
    @Default(TextStyle(fontFamily: 'Inter', package: 'waveui', fontSize: 16, height: 1.5, fontWeight: FontWeight.w400))
    TextStyle body,
    @Default(TextStyle(fontFamily: 'Inter', package: 'waveui', fontSize: 14, height: 1.4, fontWeight: FontWeight.w400))
    TextStyle small,
    @Default(TextStyle(fontFamily: 'Inter', package: 'waveui', fontSize: 16, height: 1.5, fontWeight: FontWeight.w500))
    TextStyle button,
  }) = _WaveTextTheme;
}
