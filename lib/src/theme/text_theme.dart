import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'text_theme.freezed.dart';

@freezed
abstract class WaveTextTheme with Diagnosticable, _$WaveTextTheme {
  const WaveTextTheme._();
  factory WaveTextTheme({
    required TextStyle h1,
    required TextStyle h2,
    required TextStyle h3,
    required TextStyle h4,
    required TextStyle large,
    required TextStyle body,
    required TextStyle small,
    required TextStyle button,
  }) = _WaveTextTheme;

  factory WaveTextTheme.inter() => WaveTextTheme(
    h1: TextStyle(fontFamily: 'Inter', fontSize: 36, height: 1.2, fontWeight: FontWeight.w700),
    h2: TextStyle(fontFamily: 'Inter', fontSize: 30, height: 1.2, fontWeight: FontWeight.w600),
    h3: TextStyle(fontFamily: 'Inter', fontSize: 24, height: 1.3, fontWeight: FontWeight.w600),
    h4: TextStyle(fontFamily: 'Inter', fontSize: 18, height: 1.4, fontWeight: FontWeight.w500),
    body: TextStyle(fontFamily: 'Inter', fontSize: 16, height: 1.5, fontWeight: FontWeight.w400),
    button: TextStyle(fontFamily: 'Inter', fontSize: 16, height: 1.5, fontWeight: FontWeight.w500),
    small: TextStyle(fontFamily: 'Inter', fontSize: 14, height: 1.4, fontWeight: FontWeight.w400),
    large: TextStyle(fontFamily: 'Inter', fontSize: 18, height: 1.4, fontWeight: FontWeight.w400),
  );
}
