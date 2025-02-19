// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';

import 'package:flutter/widgets.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

import 'package:waveui/material/colors.dart';
import 'package:waveui/material/theme.dart';

enum DynamicSchemeVariant {
  tonalSpot,

  fidelity,

  monochrome,

  neutral,

  vibrant,

  expressive,

  content,

  rainbow,

  fruitSalad,
}

@immutable
class ColorScheme with Diagnosticable {
  const ColorScheme({
    required this.brightness,
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.error,
    required this.onError,
    required this.surface,
    required this.onSurface,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? primaryFixed,
    Color? primaryFixedDim,
    Color? onPrimaryFixed,
    Color? onPrimaryFixedVariant,
    Color? secondaryContainer,
    Color? onSecondaryContainer,
    Color? secondaryFixed,
    Color? secondaryFixedDim,
    Color? onSecondaryFixed,
    Color? onSecondaryFixedVariant,
    Color? tertiary,
    Color? onTertiary,
    Color? tertiaryContainer,
    Color? onTertiaryContainer,
    Color? tertiaryFixed,
    Color? tertiaryFixedDim,
    Color? onTertiaryFixed,
    Color? onTertiaryFixedVariant,
    Color? errorContainer,
    Color? onErrorContainer,
    Color? surfaceDim,
    Color? surfaceBright,
    Color? surfaceContainerLowest,
    Color? surfaceContainerLow,
    Color? surfaceContainer,
    Color? surfaceContainerHigh,
    Color? surfaceContainerHighest,
    Color? onSurfaceVariant,
    Color? outline,
    Color? outlineVariant,
    Color? shadow,
    Color? scrim,
    Color? inverseSurface,
    Color? onInverseSurface,
    Color? inversePrimary,
    Color? surfaceTint,
    @Deprecated(
      'Use surface instead. '
      'This feature was deprecated after v3.18.0-0.1.pre.',
    )
    Color? background,
    @Deprecated(
      'Use onSurface instead. '
      'This feature was deprecated after v3.18.0-0.1.pre.',
    )
    Color? onBackground,
    @Deprecated(
      'Use surfaceContainerHighest instead. '
      'This feature was deprecated after v3.18.0-0.1.pre.',
    )
    Color? surfaceVariant,
  }) : _primaryContainer = primaryContainer,
       _onPrimaryContainer = onPrimaryContainer,
       _primaryFixed = primaryFixed,
       _primaryFixedDim = primaryFixedDim,
       _onPrimaryFixed = onPrimaryFixed,
       _onPrimaryFixedVariant = onPrimaryFixedVariant,
       _secondaryContainer = secondaryContainer,
       _onSecondaryContainer = onSecondaryContainer,
       _secondaryFixed = secondaryFixed,
       _secondaryFixedDim = secondaryFixedDim,
       _onSecondaryFixed = onSecondaryFixed,
       _onSecondaryFixedVariant = onSecondaryFixedVariant,
       _tertiary = tertiary,
       _onTertiary = onTertiary,
       _tertiaryContainer = tertiaryContainer,
       _onTertiaryContainer = onTertiaryContainer,
       _tertiaryFixed = tertiaryFixed,
       _tertiaryFixedDim = tertiaryFixedDim,
       _onTertiaryFixed = onTertiaryFixed,
       _onTertiaryFixedVariant = onTertiaryFixedVariant,
       _errorContainer = errorContainer,
       _onErrorContainer = onErrorContainer,
       _surfaceDim = surfaceDim,
       _surfaceBright = surfaceBright,
       _surfaceContainerLowest = surfaceContainerLowest,
       _surfaceContainerLow = surfaceContainerLow,
       _surfaceContainer = surfaceContainer,
       _surfaceContainerHigh = surfaceContainerHigh,
       _surfaceContainerHighest = surfaceContainerHighest,
       _onSurfaceVariant = onSurfaceVariant,
       _outline = outline,
       _outlineVariant = outlineVariant,
       _shadow = shadow,
       _scrim = scrim,
       _inverseSurface = inverseSurface,
       _onInverseSurface = onInverseSurface,
       _inversePrimary = inversePrimary,
       _surfaceTint = surfaceTint,
       // DEPRECATED (newest deprecations at the bottom)
       _background = background,
       _onBackground = onBackground,
       _surfaceVariant = surfaceVariant;

  factory ColorScheme.fromSeed({
    required Color seedColor,
    Brightness brightness = Brightness.light,
    DynamicSchemeVariant dynamicSchemeVariant = DynamicSchemeVariant.tonalSpot,
    double contrastLevel = 0.0,
    Color? primary,
    Color? onPrimary,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? primaryFixed,
    Color? primaryFixedDim,
    Color? onPrimaryFixed,
    Color? onPrimaryFixedVariant,
    Color? secondary,
    Color? onSecondary,
    Color? secondaryContainer,
    Color? onSecondaryContainer,
    Color? secondaryFixed,
    Color? secondaryFixedDim,
    Color? onSecondaryFixed,
    Color? onSecondaryFixedVariant,
    Color? tertiary,
    Color? onTertiary,
    Color? tertiaryContainer,
    Color? onTertiaryContainer,
    Color? tertiaryFixed,
    Color? tertiaryFixedDim,
    Color? onTertiaryFixed,
    Color? onTertiaryFixedVariant,
    Color? error,
    Color? onError,
    Color? errorContainer,
    Color? onErrorContainer,
    Color? outline,
    Color? outlineVariant,
    Color? surface,
    Color? onSurface,
    Color? surfaceDim,
    Color? surfaceBright,
    Color? surfaceContainerLowest,
    Color? surfaceContainerLow,
    Color? surfaceContainer,
    Color? surfaceContainerHigh,
    Color? surfaceContainerHighest,
    Color? onSurfaceVariant,
    Color? inverseSurface,
    Color? onInverseSurface,
    Color? inversePrimary,
    Color? shadow,
    Color? scrim,
    Color? surfaceTint,
    @Deprecated(
      'Use surface instead. '
      'This feature was deprecated after v3.18.0-0.1.pre.',
    )
    Color? background,
    @Deprecated(
      'Use onSurface instead. '
      'This feature was deprecated after v3.18.0-0.1.pre.',
    )
    Color? onBackground,
    @Deprecated(
      'Use surfaceContainerHighest instead. '
      'This feature was deprecated after v3.18.0-0.1.pre.',
    )
    Color? surfaceVariant,
  }) {
    final DynamicScheme scheme = _buildDynamicScheme(brightness, seedColor, dynamicSchemeVariant, contrastLevel);

    return ColorScheme(
      primary: primary ?? Color(MaterialDynamicColors.primary.getArgb(scheme)),
      onPrimary: onPrimary ?? Color(MaterialDynamicColors.onPrimary.getArgb(scheme)),
      primaryContainer: primaryContainer ?? Color(MaterialDynamicColors.primaryContainer.getArgb(scheme)),
      onPrimaryContainer: onPrimaryContainer ?? Color(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme)),
      primaryFixed: primaryFixed ?? Color(MaterialDynamicColors.primaryFixed.getArgb(scheme)),
      primaryFixedDim: primaryFixedDim ?? Color(MaterialDynamicColors.primaryFixedDim.getArgb(scheme)),
      onPrimaryFixed: onPrimaryFixed ?? Color(MaterialDynamicColors.onPrimaryFixed.getArgb(scheme)),
      onPrimaryFixedVariant:
          onPrimaryFixedVariant ?? Color(MaterialDynamicColors.onPrimaryFixedVariant.getArgb(scheme)),
      secondary: secondary ?? Color(MaterialDynamicColors.secondary.getArgb(scheme)),
      onSecondary: onSecondary ?? Color(MaterialDynamicColors.onSecondary.getArgb(scheme)),
      secondaryContainer: secondaryContainer ?? Color(MaterialDynamicColors.secondaryContainer.getArgb(scheme)),
      onSecondaryContainer: onSecondaryContainer ?? Color(MaterialDynamicColors.onSecondaryContainer.getArgb(scheme)),
      secondaryFixed: secondaryFixed ?? Color(MaterialDynamicColors.secondaryFixed.getArgb(scheme)),
      secondaryFixedDim: secondaryFixedDim ?? Color(MaterialDynamicColors.secondaryFixedDim.getArgb(scheme)),
      onSecondaryFixed: onSecondaryFixed ?? Color(MaterialDynamicColors.onSecondaryFixed.getArgb(scheme)),
      onSecondaryFixedVariant:
          onSecondaryFixedVariant ?? Color(MaterialDynamicColors.onSecondaryFixedVariant.getArgb(scheme)),
      tertiary: tertiary ?? Color(MaterialDynamicColors.tertiary.getArgb(scheme)),
      onTertiary: onTertiary ?? Color(MaterialDynamicColors.onTertiary.getArgb(scheme)),
      tertiaryContainer: tertiaryContainer ?? Color(MaterialDynamicColors.tertiaryContainer.getArgb(scheme)),
      onTertiaryContainer: onTertiaryContainer ?? Color(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme)),
      tertiaryFixed: tertiaryFixed ?? Color(MaterialDynamicColors.tertiaryFixed.getArgb(scheme)),
      tertiaryFixedDim: tertiaryFixedDim ?? Color(MaterialDynamicColors.tertiaryFixedDim.getArgb(scheme)),
      onTertiaryFixed: onTertiaryFixed ?? Color(MaterialDynamicColors.onTertiaryFixed.getArgb(scheme)),
      onTertiaryFixedVariant:
          onTertiaryFixedVariant ?? Color(MaterialDynamicColors.onTertiaryFixedVariant.getArgb(scheme)),
      error: error ?? Color(MaterialDynamicColors.error.getArgb(scheme)),
      onError: onError ?? Color(MaterialDynamicColors.onError.getArgb(scheme)),
      errorContainer: errorContainer ?? Color(MaterialDynamicColors.errorContainer.getArgb(scheme)),
      onErrorContainer: onErrorContainer ?? Color(MaterialDynamicColors.onErrorContainer.getArgb(scheme)),
      outline: outline ?? Color(MaterialDynamicColors.outline.getArgb(scheme)),
      outlineVariant: outlineVariant ?? Color(MaterialDynamicColors.outlineVariant.getArgb(scheme)),
      surface: surface ?? Color(MaterialDynamicColors.surface.getArgb(scheme)),
      surfaceDim: surfaceDim ?? Color(MaterialDynamicColors.surfaceDim.getArgb(scheme)),
      surfaceBright: surfaceBright ?? Color(MaterialDynamicColors.surfaceBright.getArgb(scheme)),
      surfaceContainerLowest:
          surfaceContainerLowest ?? Color(MaterialDynamicColors.surfaceContainerLowest.getArgb(scheme)),
      surfaceContainerLow: surfaceContainerLow ?? Color(MaterialDynamicColors.surfaceContainerLow.getArgb(scheme)),
      surfaceContainer: surfaceContainer ?? Color(MaterialDynamicColors.surfaceContainer.getArgb(scheme)),
      surfaceContainerHigh: surfaceContainerHigh ?? Color(MaterialDynamicColors.surfaceContainerHigh.getArgb(scheme)),
      surfaceContainerHighest:
          surfaceContainerHighest ?? Color(MaterialDynamicColors.surfaceContainerHighest.getArgb(scheme)),
      onSurface: onSurface ?? Color(MaterialDynamicColors.onSurface.getArgb(scheme)),
      onSurfaceVariant: onSurfaceVariant ?? Color(MaterialDynamicColors.onSurfaceVariant.getArgb(scheme)),
      inverseSurface: inverseSurface ?? Color(MaterialDynamicColors.inverseSurface.getArgb(scheme)),
      onInverseSurface: onInverseSurface ?? Color(MaterialDynamicColors.inverseOnSurface.getArgb(scheme)),
      inversePrimary: inversePrimary ?? Color(MaterialDynamicColors.inversePrimary.getArgb(scheme)),
      shadow: shadow ?? Color(MaterialDynamicColors.shadow.getArgb(scheme)),
      scrim: scrim ?? Color(MaterialDynamicColors.scrim.getArgb(scheme)),
      surfaceTint: surfaceTint ?? Color(MaterialDynamicColors.primary.getArgb(scheme)),
      brightness: brightness,
    );
  }

  const ColorScheme.light({
    this.brightness = Brightness.light,
    this.primary = const Color(0xff6200ee),
    this.onPrimary = Colors.white,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? primaryFixed,
    Color? primaryFixedDim,
    Color? onPrimaryFixed,
    Color? onPrimaryFixedVariant,
    this.secondary = const Color(0xff03dac6),
    this.onSecondary = Colors.black,
    Color? secondaryContainer,
    Color? onSecondaryContainer,
    Color? secondaryFixed,
    Color? secondaryFixedDim,
    Color? onSecondaryFixed,
    Color? onSecondaryFixedVariant,
    Color? tertiary,
    Color? onTertiary,
    Color? tertiaryContainer,
    Color? onTertiaryContainer,
    Color? tertiaryFixed,
    Color? tertiaryFixedDim,
    Color? onTertiaryFixed,
    Color? onTertiaryFixedVariant,
    this.error = const Color(0xffb00020),
    this.onError = Colors.white,
    Color? errorContainer,
    Color? onErrorContainer,
    this.surface = Colors.white,
    this.onSurface = Colors.black,
    Color? surfaceDim,
    Color? surfaceBright,
    Color? surfaceContainerLowest,
    Color? surfaceContainerLow,
    Color? surfaceContainer,
    Color? surfaceContainerHigh,
    Color? surfaceContainerHighest,
    Color? onSurfaceVariant,
    Color? outline,
    Color? outlineVariant,
    Color? shadow,
    Color? scrim,
    Color? inverseSurface,
    Color? onInverseSurface,
    Color? inversePrimary,
    Color? surfaceTint,
    @Deprecated(
      'Use surface instead. '
      'This feature was deprecated after v3.18.0-0.1.pre.',
    )
    Color? background = Colors.white,
    @Deprecated(
      'Use onSurface instead. '
      'This feature was deprecated after v3.18.0-0.1.pre.',
    )
    Color? onBackground = Colors.black,
    @Deprecated(
      'Use surfaceContainerHighest instead. '
      'This feature was deprecated after v3.18.0-0.1.pre.',
    )
    Color? surfaceVariant,
  }) : _primaryContainer = primaryContainer,
       _onPrimaryContainer = onPrimaryContainer,
       _primaryFixed = primaryFixed,
       _primaryFixedDim = primaryFixedDim,
       _onPrimaryFixed = onPrimaryFixed,
       _onPrimaryFixedVariant = onPrimaryFixedVariant,
       _secondaryContainer = secondaryContainer,
       _onSecondaryContainer = onSecondaryContainer,
       _secondaryFixed = secondaryFixed,
       _secondaryFixedDim = secondaryFixedDim,
       _onSecondaryFixed = onSecondaryFixed,
       _onSecondaryFixedVariant = onSecondaryFixedVariant,
       _tertiary = tertiary,
       _onTertiary = onTertiary,
       _tertiaryContainer = tertiaryContainer,
       _onTertiaryContainer = onTertiaryContainer,
       _tertiaryFixed = tertiaryFixed,
       _tertiaryFixedDim = tertiaryFixedDim,
       _onTertiaryFixed = onTertiaryFixed,
       _onTertiaryFixedVariant = onTertiaryFixedVariant,
       _errorContainer = errorContainer,
       _onErrorContainer = onErrorContainer,
       _surfaceDim = surfaceDim,
       _surfaceBright = surfaceBright,
       _surfaceContainerLowest = surfaceContainerLowest,
       _surfaceContainerLow = surfaceContainerLow,
       _surfaceContainer = surfaceContainer,
       _surfaceContainerHigh = surfaceContainerHigh,
       _surfaceContainerHighest = surfaceContainerHighest,
       _onSurfaceVariant = onSurfaceVariant,
       _outline = outline,
       _outlineVariant = outlineVariant,
       _shadow = shadow,
       _scrim = scrim,
       _inverseSurface = inverseSurface,
       _onInverseSurface = onInverseSurface,
       _inversePrimary = inversePrimary,
       _surfaceTint = surfaceTint,
       // DEPRECATED (newest deprecations at the bottom)
       _background = background,
       _onBackground = onBackground,
       _surfaceVariant = surfaceVariant;

  const ColorScheme.dark({
    this.brightness = Brightness.dark,
    this.primary = const Color(0xffbb86fc),
    this.onPrimary = Colors.black,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? primaryFixed,
    Color? primaryFixedDim,
    Color? onPrimaryFixed,
    Color? onPrimaryFixedVariant,
    this.secondary = const Color(0xff03dac6),
    this.onSecondary = Colors.black,
    Color? secondaryContainer,
    Color? onSecondaryContainer,
    Color? secondaryFixed,
    Color? secondaryFixedDim,
    Color? onSecondaryFixed,
    Color? onSecondaryFixedVariant,
    Color? tertiary,
    Color? onTertiary,
    Color? tertiaryContainer,
    Color? onTertiaryContainer,
    Color? tertiaryFixed,
    Color? tertiaryFixedDim,
    Color? onTertiaryFixed,
    Color? onTertiaryFixedVariant,
    this.error = const Color(0xffcf6679),
    this.onError = Colors.black,
    Color? errorContainer,
    Color? onErrorContainer,
    this.surface = const Color(0xff121212),
    this.onSurface = Colors.white,
    Color? surfaceDim,
    Color? surfaceBright,
    Color? surfaceContainerLowest,
    Color? surfaceContainerLow,
    Color? surfaceContainer,
    Color? surfaceContainerHigh,
    Color? surfaceContainerHighest,
    Color? onSurfaceVariant,
    Color? outline,
    Color? outlineVariant,
    Color? shadow,
    Color? scrim,
    Color? inverseSurface,
    Color? onInverseSurface,
    Color? inversePrimary,
    Color? surfaceTint,
    @Deprecated(
      'Use surface instead. '
      'This feature was deprecated after v3.18.0-0.1.pre.',
    )
    Color? background = const Color(0xff121212),
    @Deprecated(
      'Use onSurface instead. '
      'This feature was deprecated after v3.18.0-0.1.pre.',
    )
    Color? onBackground = Colors.white,
    @Deprecated(
      'Use surfaceContainerHighest instead. '
      'This feature was deprecated after v3.18.0-0.1.pre.',
    )
    Color? surfaceVariant,
  }) : _primaryContainer = primaryContainer,
       _onPrimaryContainer = onPrimaryContainer,
       _primaryFixed = primaryFixed,
       _primaryFixedDim = primaryFixedDim,
       _onPrimaryFixed = onPrimaryFixed,
       _onPrimaryFixedVariant = onPrimaryFixedVariant,
       _secondaryContainer = secondaryContainer,
       _onSecondaryContainer = onSecondaryContainer,
       _secondaryFixed = secondaryFixed,
       _secondaryFixedDim = secondaryFixedDim,
       _onSecondaryFixed = onSecondaryFixed,
       _onSecondaryFixedVariant = onSecondaryFixedVariant,
       _tertiary = tertiary,
       _onTertiary = onTertiary,
       _tertiaryContainer = tertiaryContainer,
       _onTertiaryContainer = onTertiaryContainer,
       _tertiaryFixed = tertiaryFixed,
       _tertiaryFixedDim = tertiaryFixedDim,
       _onTertiaryFixed = onTertiaryFixed,
       _onTertiaryFixedVariant = onTertiaryFixedVariant,
       _errorContainer = errorContainer,
       _onErrorContainer = onErrorContainer,
       _surfaceDim = surfaceDim,
       _surfaceBright = surfaceBright,
       _surfaceContainerLowest = surfaceContainerLowest,
       _surfaceContainerLow = surfaceContainerLow,
       _surfaceContainer = surfaceContainer,
       _surfaceContainerHigh = surfaceContainerHigh,
       _surfaceContainerHighest = surfaceContainerHighest,
       _onSurfaceVariant = onSurfaceVariant,
       _outline = outline,
       _outlineVariant = outlineVariant,
       _shadow = shadow,
       _scrim = scrim,
       _inverseSurface = inverseSurface,
       _onInverseSurface = onInverseSurface,
       _inversePrimary = inversePrimary,
       _surfaceTint = surfaceTint,
       // DEPRECATED (newest deprecations at the bottom)
       _background = background,
       _onBackground = onBackground,
       _surfaceVariant = surfaceVariant;

  const ColorScheme.highContrastLight({
    this.brightness = Brightness.light,
    this.primary = const Color(0xff0000ba),
    this.onPrimary = Colors.white,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? primaryFixed,
    Color? primaryFixedDim,
    Color? onPrimaryFixed,
    Color? onPrimaryFixedVariant,
    this.secondary = const Color(0xff66fff9),
    this.onSecondary = Colors.black,
    Color? secondaryContainer,
    Color? onSecondaryContainer,
    Color? secondaryFixed,
    Color? secondaryFixedDim,
    Color? onSecondaryFixed,
    Color? onSecondaryFixedVariant,
    Color? tertiary,
    Color? onTertiary,
    Color? tertiaryContainer,
    Color? onTertiaryContainer,
    Color? tertiaryFixed,
    Color? tertiaryFixedDim,
    Color? onTertiaryFixed,
    Color? onTertiaryFixedVariant,
    this.error = const Color(0xff790000),
    this.onError = Colors.white,
    Color? errorContainer,
    Color? onErrorContainer,
    this.surface = Colors.white,
    this.onSurface = Colors.black,
    Color? surfaceDim,
    Color? surfaceBright,
    Color? surfaceContainerLowest,
    Color? surfaceContainerLow,
    Color? surfaceContainer,
    Color? surfaceContainerHigh,
    Color? surfaceContainerHighest,
    Color? onSurfaceVariant,
    Color? outline,
    Color? outlineVariant,
    Color? shadow,
    Color? scrim,
    Color? inverseSurface,
    Color? onInverseSurface,
    Color? inversePrimary,
    Color? surfaceTint,
    @Deprecated(
      'Use surface instead. '
      'This feature was deprecated after v3.18.0-0.1.pre.',
    )
    Color? background = Colors.white,
    @Deprecated(
      'Use onSurface instead. '
      'This feature was deprecated after v3.18.0-0.1.pre.',
    )
    Color? onBackground = Colors.black,
    @Deprecated(
      'Use surfaceContainerHighest instead. '
      'This feature was deprecated after v3.18.0-0.1.pre.',
    )
    Color? surfaceVariant,
  }) : _primaryContainer = primaryContainer,
       _onPrimaryContainer = onPrimaryContainer,
       _primaryFixed = primaryFixed,
       _primaryFixedDim = primaryFixedDim,
       _onPrimaryFixed = onPrimaryFixed,
       _onPrimaryFixedVariant = onPrimaryFixedVariant,
       _secondaryContainer = secondaryContainer,
       _onSecondaryContainer = onSecondaryContainer,
       _secondaryFixed = secondaryFixed,
       _secondaryFixedDim = secondaryFixedDim,
       _onSecondaryFixed = onSecondaryFixed,
       _onSecondaryFixedVariant = onSecondaryFixedVariant,
       _tertiary = tertiary,
       _onTertiary = onTertiary,
       _tertiaryContainer = tertiaryContainer,
       _onTertiaryContainer = onTertiaryContainer,
       _tertiaryFixed = tertiaryFixed,
       _tertiaryFixedDim = tertiaryFixedDim,
       _onTertiaryFixed = onTertiaryFixed,
       _onTertiaryFixedVariant = onTertiaryFixedVariant,
       _errorContainer = errorContainer,
       _onErrorContainer = onErrorContainer,
       _surfaceDim = surfaceDim,
       _surfaceBright = surfaceBright,
       _surfaceContainerLowest = surfaceContainerLowest,
       _surfaceContainerLow = surfaceContainerLow,
       _surfaceContainer = surfaceContainer,
       _surfaceContainerHigh = surfaceContainerHigh,
       _surfaceContainerHighest = surfaceContainerHighest,
       _onSurfaceVariant = onSurfaceVariant,
       _outline = outline,
       _outlineVariant = outlineVariant,
       _shadow = shadow,
       _scrim = scrim,
       _inverseSurface = inverseSurface,
       _onInverseSurface = onInverseSurface,
       _inversePrimary = inversePrimary,
       _surfaceTint = surfaceTint,
       // DEPRECATED (newest deprecations at the bottom)
       _background = background,
       _onBackground = onBackground,
       _surfaceVariant = surfaceVariant;

  const ColorScheme.highContrastDark({
    this.brightness = Brightness.dark,
    this.primary = const Color(0xffefb7ff),
    this.onPrimary = Colors.black,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? primaryFixed,
    Color? primaryFixedDim,
    Color? onPrimaryFixed,
    Color? onPrimaryFixedVariant,
    this.secondary = const Color(0xff66fff9),
    this.onSecondary = Colors.black,
    Color? secondaryContainer,
    Color? onSecondaryContainer,
    Color? secondaryFixed,
    Color? secondaryFixedDim,
    Color? onSecondaryFixed,
    Color? onSecondaryFixedVariant,
    Color? tertiary,
    Color? onTertiary,
    Color? tertiaryContainer,
    Color? onTertiaryContainer,
    Color? tertiaryFixed,
    Color? tertiaryFixedDim,
    Color? onTertiaryFixed,
    Color? onTertiaryFixedVariant,
    this.error = const Color(0xff9b374d),
    this.onError = Colors.black,
    Color? errorContainer,
    Color? onErrorContainer,
    this.surface = const Color(0xff121212),
    this.onSurface = Colors.white,
    Color? surfaceDim,
    Color? surfaceBright,
    Color? surfaceContainerLowest,
    Color? surfaceContainerLow,
    Color? surfaceContainer,
    Color? surfaceContainerHigh,
    Color? surfaceContainerHighest,
    Color? onSurfaceVariant,
    Color? outline,
    Color? outlineVariant,
    Color? shadow,
    Color? scrim,
    Color? inverseSurface,
    Color? onInverseSurface,
    Color? inversePrimary,
    Color? surfaceTint,
    @Deprecated(
      'Use surface instead. '
      'This feature was deprecated after v3.18.0-0.1.pre.',
    )
    Color? background = const Color(0xff121212),
    @Deprecated(
      'Use onSurface instead. '
      'This feature was deprecated after v3.18.0-0.1.pre.',
    )
    Color? onBackground = Colors.white,
    @Deprecated(
      'Use surfaceContainerHighest instead. '
      'This feature was deprecated after v3.18.0-0.1.pre.',
    )
    Color? surfaceVariant,
  }) : _primaryContainer = primaryContainer,
       _onPrimaryContainer = onPrimaryContainer,
       _primaryFixed = primaryFixed,
       _primaryFixedDim = primaryFixedDim,
       _onPrimaryFixed = onPrimaryFixed,
       _onPrimaryFixedVariant = onPrimaryFixedVariant,
       _secondaryContainer = secondaryContainer,
       _onSecondaryContainer = onSecondaryContainer,
       _secondaryFixed = secondaryFixed,
       _secondaryFixedDim = secondaryFixedDim,
       _onSecondaryFixed = onSecondaryFixed,
       _onSecondaryFixedVariant = onSecondaryFixedVariant,
       _tertiary = tertiary,
       _onTertiary = onTertiary,
       _tertiaryContainer = tertiaryContainer,
       _onTertiaryContainer = onTertiaryContainer,
       _tertiaryFixed = tertiaryFixed,
       _tertiaryFixedDim = tertiaryFixedDim,
       _onTertiaryFixed = onTertiaryFixed,
       _onTertiaryFixedVariant = onTertiaryFixedVariant,
       _errorContainer = errorContainer,
       _onErrorContainer = onErrorContainer,
       _surfaceDim = surfaceDim,
       _surfaceBright = surfaceBright,
       _surfaceContainerLowest = surfaceContainerLowest,
       _surfaceContainerLow = surfaceContainerLow,
       _surfaceContainer = surfaceContainer,
       _surfaceContainerHigh = surfaceContainerHigh,
       _surfaceContainerHighest = surfaceContainerHighest,
       _onSurfaceVariant = onSurfaceVariant,
       _outline = outline,
       _outlineVariant = outlineVariant,
       _shadow = shadow,
       _scrim = scrim,
       _inverseSurface = inverseSurface,
       _onInverseSurface = onInverseSurface,
       _inversePrimary = inversePrimary,
       _surfaceTint = surfaceTint,
       // DEPRECATED (newest deprecations at the bottom)
       _background = background,
       _onBackground = onBackground,
       _surfaceVariant = surfaceVariant;

  factory ColorScheme.fromSwatch({
    MaterialColor primarySwatch = Colors.blue,
    Color? accentColor,
    Color? cardColor,
    Color? errorColor,
    Brightness brightness = Brightness.light, required ui.Color backgroundColor,
  }) {
    final bool isDark = brightness == Brightness.dark;
    final bool primaryIsDark = _brightnessFor(primarySwatch) == Brightness.dark;
    final Color secondary = accentColor ?? (isDark ? Colors.tealAccent[200]! : primarySwatch);
    final bool secondaryIsDark = _brightnessFor(secondary) == Brightness.dark;

    return ColorScheme(
      primary: primarySwatch,
      secondary: secondary,
      surface: cardColor ?? (isDark ? Colors.grey[800]! : Colors.white),
      error: errorColor ?? Colors.red[700]!,
      onPrimary: primaryIsDark ? Colors.white : Colors.black,
      onSecondary: secondaryIsDark ? Colors.white : Colors.black,
      onSurface: isDark ? Colors.white : Colors.black,
      onError: isDark ? Colors.black : Colors.white,
      brightness: brightness,
    );
  }

  static Brightness _brightnessFor(Color color) => ThemeData.estimateBrightnessForColor(color);

  final Brightness brightness;

  final Color primary;

  final Color onPrimary;

  final Color? _primaryContainer;

  Color get primaryContainer => _primaryContainer ?? primary;

  final Color? _onPrimaryContainer;

  Color get onPrimaryContainer => _onPrimaryContainer ?? onPrimary;

  final Color? _primaryFixed;

  Color get primaryFixed => _primaryFixed ?? primary;

  final Color? _primaryFixedDim;

  Color get primaryFixedDim => _primaryFixedDim ?? primary;

  final Color? _onPrimaryFixed;

  Color get onPrimaryFixed => _onPrimaryFixed ?? onPrimary;

  final Color? _onPrimaryFixedVariant;

  Color get onPrimaryFixedVariant => _onPrimaryFixedVariant ?? onPrimary;

  final Color secondary;

  final Color onSecondary;

  final Color? _secondaryContainer;

  Color get secondaryContainer => _secondaryContainer ?? secondary;

  final Color? _onSecondaryContainer;

  Color get onSecondaryContainer => _onSecondaryContainer ?? onSecondary;

  final Color? _secondaryFixed;

  Color get secondaryFixed => _secondaryFixed ?? secondary;

  final Color? _secondaryFixedDim;

  Color get secondaryFixedDim => _secondaryFixedDim ?? secondary;

  final Color? _onSecondaryFixed;

  Color get onSecondaryFixed => _onSecondaryFixed ?? onSecondary;

  final Color? _onSecondaryFixedVariant;

  Color get onSecondaryFixedVariant => _onSecondaryFixedVariant ?? onSecondary;

  final Color? _tertiary;

  Color get tertiary => _tertiary ?? secondary;

  final Color? _onTertiary;

  Color get onTertiary => _onTertiary ?? onSecondary;

  final Color? _tertiaryContainer;

  Color get tertiaryContainer => _tertiaryContainer ?? tertiary;

  final Color? _onTertiaryContainer;

  Color get onTertiaryContainer => _onTertiaryContainer ?? onTertiary;

  final Color? _tertiaryFixed;

  Color get tertiaryFixed => _tertiaryFixed ?? tertiary;

  final Color? _tertiaryFixedDim;

  Color get tertiaryFixedDim => _tertiaryFixedDim ?? tertiary;

  final Color? _onTertiaryFixed;

  Color get onTertiaryFixed => _onTertiaryFixed ?? onTertiary;

  final Color? _onTertiaryFixedVariant;

  Color get onTertiaryFixedVariant => _onTertiaryFixedVariant ?? onTertiary;

  final Color error;

  final Color onError;

  final Color? _errorContainer;

  Color get errorContainer => _errorContainer ?? error;

  final Color? _onErrorContainer;

  Color get onErrorContainer => _onErrorContainer ?? onError;

  final Color surface;

  final Color onSurface;

  final Color? _surfaceVariant;

  @Deprecated(
    'Use surfaceContainerHighest instead. '
    'This feature was deprecated after v3.18.0-0.1.pre.',
  )
  Color get surfaceVariant => _surfaceVariant ?? surface;

  final Color? _surfaceDim;

  Color get surfaceDim => _surfaceDim ?? surface;

  final Color? _surfaceBright;

  Color get surfaceBright => _surfaceBright ?? surface;

  final Color? _surfaceContainerLowest;

  Color get surfaceContainerLowest => _surfaceContainerLowest ?? surface;

  final Color? _surfaceContainerLow;

  Color get surfaceContainerLow => _surfaceContainerLow ?? surface;

  final Color? _surfaceContainer;

  Color get surfaceContainer => _surfaceContainer ?? surface;

  final Color? _surfaceContainerHigh;

  Color get surfaceContainerHigh => _surfaceContainerHigh ?? surface;

  final Color? _surfaceContainerHighest;

  Color get surfaceContainerHighest => _surfaceContainerHighest ?? surface;

  final Color? _onSurfaceVariant;

  Color get onSurfaceVariant => _onSurfaceVariant ?? onSurface;

  final Color? _outline;

  Color get outline => _outline ?? onSurface;

  final Color? _outlineVariant;

  Color get outlineVariant => _outlineVariant ?? onSurface;

  final Color? _shadow;

  Color get shadow => _shadow ?? const Color(0xff000000);

  final Color? _scrim;

  Color get scrim => _scrim ?? const Color(0xff000000);

  final Color? _inverseSurface;

  Color get inverseSurface => _inverseSurface ?? onSurface;

  final Color? _onInverseSurface;

  Color get onInverseSurface => _onInverseSurface ?? surface;

  final Color? _inversePrimary;

  Color get inversePrimary => _inversePrimary ?? onPrimary;

  final Color? _surfaceTint;

  Color get surfaceTint => _surfaceTint ?? primary;

  final Color? _background;

  @Deprecated(
    'Use surface instead. '
    'This feature was deprecated after v3.18.0-0.1.pre.',
  )
  Color get background => _background ?? surface;

  final Color? _onBackground;

  @Deprecated(
    'Use onSurface instead. '
    'This feature was deprecated after v3.18.0-0.1.pre.',
  )
  Color get onBackground => _onBackground ?? onSurface;

  ColorScheme copyWith({
    Brightness? brightness,
    Color? primary,
    Color? onPrimary,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? primaryFixed,
    Color? primaryFixedDim,
    Color? onPrimaryFixed,
    Color? onPrimaryFixedVariant,
    Color? secondary,
    Color? onSecondary,
    Color? secondaryContainer,
    Color? onSecondaryContainer,
    Color? secondaryFixed,
    Color? secondaryFixedDim,
    Color? onSecondaryFixed,
    Color? onSecondaryFixedVariant,
    Color? tertiary,
    Color? onTertiary,
    Color? tertiaryContainer,
    Color? onTertiaryContainer,
    Color? tertiaryFixed,
    Color? tertiaryFixedDim,
    Color? onTertiaryFixed,
    Color? onTertiaryFixedVariant,
    Color? error,
    Color? onError,
    Color? errorContainer,
    Color? onErrorContainer,
    Color? surface,
    Color? onSurface,
    Color? surfaceDim,
    Color? surfaceBright,
    Color? surfaceContainerLowest,
    Color? surfaceContainerLow,
    Color? surfaceContainer,
    Color? surfaceContainerHigh,
    Color? surfaceContainerHighest,
    Color? onSurfaceVariant,
    Color? outline,
    Color? outlineVariant,
    Color? shadow,
    Color? scrim,
    Color? inverseSurface,
    Color? onInverseSurface,
    Color? inversePrimary,
    Color? surfaceTint,
    @Deprecated(
      'Use surface instead. '
      'This feature was deprecated after v3.18.0-0.1.pre.',
    )
    Color? background,
    @Deprecated(
      'Use onSurface instead. '
      'This feature was deprecated after v3.18.0-0.1.pre.',
    )
    Color? onBackground,
    @Deprecated(
      'Use surfaceContainerHighest instead. '
      'This feature was deprecated after v3.18.0-0.1.pre.',
    )
    Color? surfaceVariant,
  }) => ColorScheme(
    brightness: brightness ?? this.brightness,
    primary: primary ?? this.primary,
    onPrimary: onPrimary ?? this.onPrimary,
    primaryContainer: primaryContainer ?? this.primaryContainer,
    onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
    primaryFixed: primaryFixed ?? this.primaryFixed,
    primaryFixedDim: primaryFixedDim ?? this.primaryFixedDim,
    onPrimaryFixed: onPrimaryFixed ?? this.onPrimaryFixed,
    onPrimaryFixedVariant: onPrimaryFixedVariant ?? this.onPrimaryFixedVariant,
    secondary: secondary ?? this.secondary,
    onSecondary: onSecondary ?? this.onSecondary,
    secondaryContainer: secondaryContainer ?? this.secondaryContainer,
    onSecondaryContainer: onSecondaryContainer ?? this.onSecondaryContainer,
    secondaryFixed: secondaryFixed ?? this.secondaryFixed,
    secondaryFixedDim: secondaryFixedDim ?? this.secondaryFixedDim,
    onSecondaryFixed: onSecondaryFixed ?? this.onSecondaryFixed,
    onSecondaryFixedVariant: onSecondaryFixedVariant ?? this.onSecondaryFixedVariant,
    tertiary: tertiary ?? this.tertiary,
    onTertiary: onTertiary ?? this.onTertiary,
    tertiaryContainer: tertiaryContainer ?? this.tertiaryContainer,
    onTertiaryContainer: onTertiaryContainer ?? this.onTertiaryContainer,
    tertiaryFixed: tertiaryFixed ?? this.tertiaryFixed,
    tertiaryFixedDim: tertiaryFixedDim ?? this.tertiaryFixedDim,
    onTertiaryFixed: onTertiaryFixed ?? this.onTertiaryFixed,
    onTertiaryFixedVariant: onTertiaryFixedVariant ?? this.onTertiaryFixedVariant,
    error: error ?? this.error,
    onError: onError ?? this.onError,
    errorContainer: errorContainer ?? this.errorContainer,
    onErrorContainer: onErrorContainer ?? this.onErrorContainer,
    surface: surface ?? this.surface,
    onSurface: onSurface ?? this.onSurface,
    surfaceDim: surfaceDim ?? this.surfaceDim,
    surfaceBright: surfaceBright ?? this.surfaceBright,
    surfaceContainerLowest: surfaceContainerLowest ?? this.surfaceContainerLowest,
    surfaceContainerLow: surfaceContainerLow ?? this.surfaceContainerLow,
    surfaceContainer: surfaceContainer ?? this.surfaceContainer,
    surfaceContainerHigh: surfaceContainerHigh ?? this.surfaceContainerHigh,
    surfaceContainerHighest: surfaceContainerHighest ?? this.surfaceContainerHighest,
    onSurfaceVariant: onSurfaceVariant ?? this.onSurfaceVariant,
    outline: outline ?? this.outline,
    outlineVariant: outlineVariant ?? this.outlineVariant,
    shadow: shadow ?? this.shadow,
    scrim: scrim ?? this.scrim,
    inverseSurface: inverseSurface ?? this.inverseSurface,
    onInverseSurface: onInverseSurface ?? this.onInverseSurface,
    inversePrimary: inversePrimary ?? this.inversePrimary,
    surfaceTint: surfaceTint ?? this.surfaceTint,
  );

  static ColorScheme lerp(ColorScheme a, ColorScheme b, double t) {
    if (identical(a, b)) {
      return a;
    }
    return ColorScheme(
      brightness: t < 0.5 ? a.brightness : b.brightness,
      primary: Color.lerp(a.primary, b.primary, t)!,
      onPrimary: Color.lerp(a.onPrimary, b.onPrimary, t)!,
      primaryContainer: Color.lerp(a.primaryContainer, b.primaryContainer, t),
      onPrimaryContainer: Color.lerp(a.onPrimaryContainer, b.onPrimaryContainer, t),
      primaryFixed: Color.lerp(a.primaryFixed, b.primaryFixed, t),
      primaryFixedDim: Color.lerp(a.primaryFixedDim, b.primaryFixedDim, t),
      onPrimaryFixed: Color.lerp(a.onPrimaryFixed, b.onPrimaryFixed, t),
      onPrimaryFixedVariant: Color.lerp(a.onPrimaryFixedVariant, b.onPrimaryFixedVariant, t),
      secondary: Color.lerp(a.secondary, b.secondary, t)!,
      onSecondary: Color.lerp(a.onSecondary, b.onSecondary, t)!,
      secondaryContainer: Color.lerp(a.secondaryContainer, b.secondaryContainer, t),
      onSecondaryContainer: Color.lerp(a.onSecondaryContainer, b.onSecondaryContainer, t),
      secondaryFixed: Color.lerp(a.secondaryFixed, b.secondaryFixed, t),
      secondaryFixedDim: Color.lerp(a.secondaryFixedDim, b.secondaryFixedDim, t),
      onSecondaryFixed: Color.lerp(a.onSecondaryFixed, b.onSecondaryFixed, t),
      onSecondaryFixedVariant: Color.lerp(a.onSecondaryFixedVariant, b.onSecondaryFixedVariant, t),
      tertiary: Color.lerp(a.tertiary, b.tertiary, t),
      onTertiary: Color.lerp(a.onTertiary, b.onTertiary, t),
      tertiaryContainer: Color.lerp(a.tertiaryContainer, b.tertiaryContainer, t),
      onTertiaryContainer: Color.lerp(a.onTertiaryContainer, b.onTertiaryContainer, t),
      tertiaryFixed: Color.lerp(a.tertiaryFixed, b.tertiaryFixed, t),
      tertiaryFixedDim: Color.lerp(a.tertiaryFixedDim, b.tertiaryFixedDim, t),
      onTertiaryFixed: Color.lerp(a.onTertiaryFixed, b.onTertiaryFixed, t),
      onTertiaryFixedVariant: Color.lerp(a.onTertiaryFixedVariant, b.onTertiaryFixedVariant, t),
      error: Color.lerp(a.error, b.error, t)!,
      onError: Color.lerp(a.onError, b.onError, t)!,
      errorContainer: Color.lerp(a.errorContainer, b.errorContainer, t),
      onErrorContainer: Color.lerp(a.onErrorContainer, b.onErrorContainer, t),
      surface: Color.lerp(a.surface, b.surface, t)!,
      onSurface: Color.lerp(a.onSurface, b.onSurface, t)!,
      surfaceDim: Color.lerp(a.surfaceDim, b.surfaceDim, t),
      surfaceBright: Color.lerp(a.surfaceBright, b.surfaceBright, t),
      surfaceContainerLowest: Color.lerp(a.surfaceContainerLowest, b.surfaceContainerLowest, t),
      surfaceContainerLow: Color.lerp(a.surfaceContainerLow, b.surfaceContainerLow, t),
      surfaceContainer: Color.lerp(a.surfaceContainer, b.surfaceContainer, t),
      surfaceContainerHigh: Color.lerp(a.surfaceContainerHigh, b.surfaceContainerHigh, t),
      surfaceContainerHighest: Color.lerp(a.surfaceContainerHighest, b.surfaceContainerHighest, t),
      onSurfaceVariant: Color.lerp(a.onSurfaceVariant, b.onSurfaceVariant, t),
      outline: Color.lerp(a.outline, b.outline, t),
      outlineVariant: Color.lerp(a.outlineVariant, b.outlineVariant, t),
      shadow: Color.lerp(a.shadow, b.shadow, t),
      scrim: Color.lerp(a.scrim, b.scrim, t),
      inverseSurface: Color.lerp(a.inverseSurface, b.inverseSurface, t),
      onInverseSurface: Color.lerp(a.onInverseSurface, b.onInverseSurface, t),
      inversePrimary: Color.lerp(a.inversePrimary, b.inversePrimary, t),
      surfaceTint: Color.lerp(a.surfaceTint, b.surfaceTint, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is ColorScheme &&
        other.brightness == brightness &&
        other.primary == primary &&
        other.onPrimary == onPrimary &&
        other.primaryContainer == primaryContainer &&
        other.onPrimaryContainer == onPrimaryContainer &&
        other.primaryFixed == primaryFixed &&
        other.primaryFixedDim == primaryFixedDim &&
        other.onPrimaryFixed == onPrimaryFixed &&
        other.onPrimaryFixedVariant == onPrimaryFixedVariant &&
        other.secondary == secondary &&
        other.onSecondary == onSecondary &&
        other.secondaryContainer == secondaryContainer &&
        other.onSecondaryContainer == onSecondaryContainer &&
        other.secondaryFixed == secondaryFixed &&
        other.secondaryFixedDim == secondaryFixedDim &&
        other.onSecondaryFixed == onSecondaryFixed &&
        other.onSecondaryFixedVariant == onSecondaryFixedVariant &&
        other.tertiary == tertiary &&
        other.onTertiary == onTertiary &&
        other.tertiaryContainer == tertiaryContainer &&
        other.onTertiaryContainer == onTertiaryContainer &&
        other.tertiaryFixed == tertiaryFixed &&
        other.tertiaryFixedDim == tertiaryFixedDim &&
        other.onTertiaryFixed == onTertiaryFixed &&
        other.onTertiaryFixedVariant == onTertiaryFixedVariant &&
        other.error == error &&
        other.onError == onError &&
        other.errorContainer == errorContainer &&
        other.onErrorContainer == onErrorContainer &&
        other.surface == surface &&
        other.onSurface == onSurface &&
        other.surfaceDim == surfaceDim &&
        other.surfaceBright == surfaceBright &&
        other.surfaceContainerLowest == surfaceContainerLowest &&
        other.surfaceContainerLow == surfaceContainerLow &&
        other.surfaceContainer == surfaceContainer &&
        other.surfaceContainerHigh == surfaceContainerHigh &&
        other.surfaceContainerHighest == surfaceContainerHighest &&
        other.onSurfaceVariant == onSurfaceVariant &&
        other.outline == outline &&
        other.outlineVariant == outlineVariant &&
        other.shadow == shadow &&
        other.scrim == scrim &&
        other.inverseSurface == inverseSurface &&
        other.onInverseSurface == onInverseSurface &&
        other.inversePrimary == inversePrimary &&
        other.surfaceTint == surfaceTint
        // DEPRECATED (newest deprecations at the bottom)
        &&
        other.surface == surface &&
        other.onSurface == onSurface &&
        other.surfaceContainerHighest == surfaceContainerHighest;
  }

  @override
  int get hashCode => Object.hash(
    brightness,
    primary,
    onPrimary,
    primaryContainer,
    onPrimaryContainer,
    secondary,
    onSecondary,
    secondaryContainer,
    onSecondaryContainer,
    tertiary,
    onTertiary,
    tertiaryContainer,
    onTertiaryContainer,
    error,
    onError,
    errorContainer,
    onErrorContainer,
    Object.hash(
      surface,
      onSurface,
      surfaceDim,
      surfaceBright,
      surfaceContainerLowest,
      surfaceContainerLow,
      surfaceContainer,
      surfaceContainerHigh,
      surfaceContainerHighest,
      onSurfaceVariant,
      outline,
      outlineVariant,
      shadow,
      scrim,
      inverseSurface,
      onInverseSurface,
      inversePrimary,
      surfaceTint,
      Object.hash(
        primaryFixed,
        primaryFixedDim,
        onPrimaryFixed,
        onPrimaryFixedVariant,
        secondaryFixed,
        secondaryFixedDim,
        onSecondaryFixed,
        onSecondaryFixedVariant,
        tertiaryFixed,
        tertiaryFixedDim,
        onTertiaryFixed,
        onTertiaryFixedVariant,
        // DEPRECATED (newest deprecations at the bottom)
        surface,
        onSurface,
        surfaceContainerHighest,
      ),
    ),
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    const ColorScheme defaultScheme = ColorScheme.light();
    properties.add(DiagnosticsProperty<Brightness>('brightness', brightness, defaultValue: defaultScheme.brightness));
    properties.add(ColorProperty('primary', primary, defaultValue: defaultScheme.primary));
    properties.add(ColorProperty('onPrimary', onPrimary, defaultValue: defaultScheme.onPrimary));
    properties.add(ColorProperty('primaryContainer', primaryContainer, defaultValue: defaultScheme.primaryContainer));
    properties.add(
      ColorProperty('onPrimaryContainer', onPrimaryContainer, defaultValue: defaultScheme.onPrimaryContainer),
    );
    properties.add(ColorProperty('primaryFixed', primaryFixed, defaultValue: defaultScheme.primaryFixed));
    properties.add(ColorProperty('primaryFixedDim', primaryFixedDim, defaultValue: defaultScheme.primaryFixedDim));
    properties.add(ColorProperty('onPrimaryFixed', onPrimaryFixed, defaultValue: defaultScheme.onPrimaryFixed));
    properties.add(
      ColorProperty('onPrimaryFixedVariant', onPrimaryFixedVariant, defaultValue: defaultScheme.onPrimaryFixedVariant),
    );
    properties.add(ColorProperty('secondary', secondary, defaultValue: defaultScheme.secondary));
    properties.add(ColorProperty('onSecondary', onSecondary, defaultValue: defaultScheme.onSecondary));
    properties.add(
      ColorProperty('secondaryContainer', secondaryContainer, defaultValue: defaultScheme.secondaryContainer),
    );
    properties.add(
      ColorProperty('onSecondaryContainer', onSecondaryContainer, defaultValue: defaultScheme.onSecondaryContainer),
    );
    properties.add(ColorProperty('secondaryFixed', secondaryFixed, defaultValue: defaultScheme.secondaryFixed));
    properties.add(
      ColorProperty('secondaryFixedDim', secondaryFixedDim, defaultValue: defaultScheme.secondaryFixedDim),
    );
    properties.add(ColorProperty('onSecondaryFixed', onSecondaryFixed, defaultValue: defaultScheme.onSecondaryFixed));
    properties.add(
      ColorProperty(
        'onSecondaryFixedVariant',
        onSecondaryFixedVariant,
        defaultValue: defaultScheme.onSecondaryFixedVariant,
      ),
    );
    properties.add(ColorProperty('tertiary', tertiary, defaultValue: defaultScheme.tertiary));
    properties.add(ColorProperty('onTertiary', onTertiary, defaultValue: defaultScheme.onTertiary));
    properties.add(
      ColorProperty('tertiaryContainer', tertiaryContainer, defaultValue: defaultScheme.tertiaryContainer),
    );
    properties.add(
      ColorProperty('onTertiaryContainer', onTertiaryContainer, defaultValue: defaultScheme.onTertiaryContainer),
    );
    properties.add(ColorProperty('tertiaryFixed', tertiaryFixed, defaultValue: defaultScheme.tertiaryFixed));
    properties.add(ColorProperty('tertiaryFixedDim', tertiaryFixedDim, defaultValue: defaultScheme.tertiaryFixedDim));
    properties.add(ColorProperty('onTertiaryFixed', onTertiaryFixed, defaultValue: defaultScheme.onTertiaryFixed));
    properties.add(
      ColorProperty(
        'onTertiaryFixedVariant',
        onTertiaryFixedVariant,
        defaultValue: defaultScheme.onTertiaryFixedVariant,
      ),
    );
    properties.add(ColorProperty('error', error, defaultValue: defaultScheme.error));
    properties.add(ColorProperty('onError', onError, defaultValue: defaultScheme.onError));
    properties.add(ColorProperty('errorContainer', errorContainer, defaultValue: defaultScheme.errorContainer));
    properties.add(ColorProperty('onErrorContainer', onErrorContainer, defaultValue: defaultScheme.onErrorContainer));
    properties.add(ColorProperty('surface', surface, defaultValue: defaultScheme.surface));
    properties.add(ColorProperty('onSurface', onSurface, defaultValue: defaultScheme.onSurface));
    properties.add(ColorProperty('surfaceDim', surfaceDim, defaultValue: defaultScheme.surfaceDim));
    properties.add(ColorProperty('surfaceBright', surfaceBright, defaultValue: defaultScheme.surfaceBright));
    properties.add(
      ColorProperty(
        'surfaceContainerLowest',
        surfaceContainerLowest,
        defaultValue: defaultScheme.surfaceContainerLowest,
      ),
    );
    properties.add(
      ColorProperty('surfaceContainerLow', surfaceContainerLow, defaultValue: defaultScheme.surfaceContainerLow),
    );
    properties.add(ColorProperty('surfaceContainer', surfaceContainer, defaultValue: defaultScheme.surfaceContainer));
    properties.add(
      ColorProperty('surfaceContainerHigh', surfaceContainerHigh, defaultValue: defaultScheme.surfaceContainerHigh),
    );
    properties.add(
      ColorProperty(
        'surfaceContainerHighest',
        surfaceContainerHighest,
        defaultValue: defaultScheme.surfaceContainerHighest,
      ),
    );
    properties.add(ColorProperty('onSurfaceVariant', onSurfaceVariant, defaultValue: defaultScheme.onSurfaceVariant));
    properties.add(ColorProperty('outline', outline, defaultValue: defaultScheme.outline));
    properties.add(ColorProperty('outlineVariant', outlineVariant, defaultValue: defaultScheme.outlineVariant));
    properties.add(ColorProperty('shadow', shadow, defaultValue: defaultScheme.shadow));
    properties.add(ColorProperty('scrim', scrim, defaultValue: defaultScheme.scrim));
    properties.add(ColorProperty('inverseSurface', inverseSurface, defaultValue: defaultScheme.inverseSurface));
    properties.add(ColorProperty('onInverseSurface', onInverseSurface, defaultValue: defaultScheme.onInverseSurface));
    properties.add(ColorProperty('inversePrimary', inversePrimary, defaultValue: defaultScheme.inversePrimary));
    properties.add(ColorProperty('surfaceTint', surfaceTint, defaultValue: defaultScheme.surfaceTint));
    // DEPRECATED (newest deprecations at the bottom)
    properties.add(ColorProperty('background', surface, defaultValue: defaultScheme.surface));
    properties.add(ColorProperty('onBackground', onSurface, defaultValue: defaultScheme.onSurface));
    properties.add(
      ColorProperty('surfaceVariant', surfaceContainerHighest, defaultValue: defaultScheme.surfaceContainerHighest),
    );
    properties.add(ColorProperty('surfaceVariant', surfaceContainerHighest));
    properties.add(ColorProperty('background', surface));
    properties.add(ColorProperty('onBackground', onSurface));
    properties.add(ColorProperty('surfaceVariant', surfaceVariant));
    properties.add(ColorProperty('background', background));
    properties.add(ColorProperty('onBackground', onBackground));
  }

  static Future<ColorScheme> fromImageProvider({
    required ImageProvider provider,
    Brightness brightness = Brightness.light,
    DynamicSchemeVariant dynamicSchemeVariant = DynamicSchemeVariant.tonalSpot,
    double contrastLevel = 0.0,
    Color? primary,
    Color? onPrimary,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? primaryFixed,
    Color? primaryFixedDim,
    Color? onPrimaryFixed,
    Color? onPrimaryFixedVariant,
    Color? secondary,
    Color? onSecondary,
    Color? secondaryContainer,
    Color? onSecondaryContainer,
    Color? secondaryFixed,
    Color? secondaryFixedDim,
    Color? onSecondaryFixed,
    Color? onSecondaryFixedVariant,
    Color? tertiary,
    Color? onTertiary,
    Color? tertiaryContainer,
    Color? onTertiaryContainer,
    Color? tertiaryFixed,
    Color? tertiaryFixedDim,
    Color? onTertiaryFixed,
    Color? onTertiaryFixedVariant,
    Color? error,
    Color? onError,
    Color? errorContainer,
    Color? onErrorContainer,
    Color? outline,
    Color? outlineVariant,
    Color? surface,
    Color? onSurface,
    Color? surfaceDim,
    Color? surfaceBright,
    Color? surfaceContainerLowest,
    Color? surfaceContainerLow,
    Color? surfaceContainer,
    Color? surfaceContainerHigh,
    Color? surfaceContainerHighest,
    Color? onSurfaceVariant,
    Color? inverseSurface,
    Color? onInverseSurface,
    Color? inversePrimary,
    Color? shadow,
    Color? scrim,
    Color? surfaceTint,
    @Deprecated(
      'Use surface instead. '
      'This feature was deprecated after v3.18.0-0.1.pre.',
    )
    Color? background,
    @Deprecated(
      'Use onSurface instead. '
      'This feature was deprecated after v3.18.0-0.1.pre.',
    )
    Color? onBackground,
    @Deprecated(
      'Use surfaceContainerHighest instead. '
      'This feature was deprecated after v3.18.0-0.1.pre.',
    )
    Color? surfaceVariant,
  }) async {
    // Extract dominant colors from image.
    final QuantizerResult quantizerResult = await _extractColorsFromImageProvider(provider);
    final Map<int, int> colorToCount = quantizerResult.colorToCount.map(
      (key, value) => MapEntry<int, int>(_getArgbFromAbgr(key), value),
    );

    // Score colors for color scheme suitability.
    final List<int> scoredResults = Score.score(colorToCount, desired: 1);
    final ui.Color baseColor = Color(scoredResults.first);

    final DynamicScheme scheme = _buildDynamicScheme(brightness, baseColor, dynamicSchemeVariant, contrastLevel);

    return ColorScheme(
      primary: primary ?? Color(MaterialDynamicColors.primary.getArgb(scheme)),
      onPrimary: onPrimary ?? Color(MaterialDynamicColors.onPrimary.getArgb(scheme)),
      primaryContainer: primaryContainer ?? Color(MaterialDynamicColors.primaryContainer.getArgb(scheme)),
      onPrimaryContainer: onPrimaryContainer ?? Color(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme)),
      primaryFixed: primaryFixed ?? Color(MaterialDynamicColors.primaryFixed.getArgb(scheme)),
      primaryFixedDim: primaryFixedDim ?? Color(MaterialDynamicColors.primaryFixedDim.getArgb(scheme)),
      onPrimaryFixed: onPrimaryFixed ?? Color(MaterialDynamicColors.onPrimaryFixed.getArgb(scheme)),
      onPrimaryFixedVariant:
          onPrimaryFixedVariant ?? Color(MaterialDynamicColors.onPrimaryFixedVariant.getArgb(scheme)),
      secondary: secondary ?? Color(MaterialDynamicColors.secondary.getArgb(scheme)),
      onSecondary: onSecondary ?? Color(MaterialDynamicColors.onSecondary.getArgb(scheme)),
      secondaryContainer: secondaryContainer ?? Color(MaterialDynamicColors.secondaryContainer.getArgb(scheme)),
      onSecondaryContainer: onSecondaryContainer ?? Color(MaterialDynamicColors.onSecondaryContainer.getArgb(scheme)),
      secondaryFixed: secondaryFixed ?? Color(MaterialDynamicColors.secondaryFixed.getArgb(scheme)),
      secondaryFixedDim: secondaryFixedDim ?? Color(MaterialDynamicColors.secondaryFixedDim.getArgb(scheme)),
      onSecondaryFixed: onSecondaryFixed ?? Color(MaterialDynamicColors.onSecondaryFixed.getArgb(scheme)),
      onSecondaryFixedVariant:
          onSecondaryFixedVariant ?? Color(MaterialDynamicColors.onSecondaryFixedVariant.getArgb(scheme)),
      tertiary: tertiary ?? Color(MaterialDynamicColors.tertiary.getArgb(scheme)),
      onTertiary: onTertiary ?? Color(MaterialDynamicColors.onTertiary.getArgb(scheme)),
      tertiaryContainer: tertiaryContainer ?? Color(MaterialDynamicColors.tertiaryContainer.getArgb(scheme)),
      onTertiaryContainer: onTertiaryContainer ?? Color(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme)),
      tertiaryFixed: tertiaryFixed ?? Color(MaterialDynamicColors.tertiaryFixed.getArgb(scheme)),
      tertiaryFixedDim: tertiaryFixedDim ?? Color(MaterialDynamicColors.tertiaryFixedDim.getArgb(scheme)),
      onTertiaryFixed: onTertiaryFixed ?? Color(MaterialDynamicColors.onTertiaryFixed.getArgb(scheme)),
      onTertiaryFixedVariant:
          onTertiaryFixedVariant ?? Color(MaterialDynamicColors.onTertiaryFixedVariant.getArgb(scheme)),
      error: error ?? Color(MaterialDynamicColors.error.getArgb(scheme)),
      onError: onError ?? Color(MaterialDynamicColors.onError.getArgb(scheme)),
      errorContainer: errorContainer ?? Color(MaterialDynamicColors.errorContainer.getArgb(scheme)),
      onErrorContainer: onErrorContainer ?? Color(MaterialDynamicColors.onErrorContainer.getArgb(scheme)),
      outline: outline ?? Color(MaterialDynamicColors.outline.getArgb(scheme)),
      outlineVariant: outlineVariant ?? Color(MaterialDynamicColors.outlineVariant.getArgb(scheme)),
      surface: surface ?? Color(MaterialDynamicColors.surface.getArgb(scheme)),
      surfaceDim: surfaceDim ?? Color(MaterialDynamicColors.surfaceDim.getArgb(scheme)),
      surfaceBright: surfaceBright ?? Color(MaterialDynamicColors.surfaceBright.getArgb(scheme)),
      surfaceContainerLowest:
          surfaceContainerLowest ?? Color(MaterialDynamicColors.surfaceContainerLowest.getArgb(scheme)),
      surfaceContainerLow: surfaceContainerLow ?? Color(MaterialDynamicColors.surfaceContainerLow.getArgb(scheme)),
      surfaceContainer: surfaceContainer ?? Color(MaterialDynamicColors.surfaceContainer.getArgb(scheme)),
      surfaceContainerHigh: surfaceContainerHigh ?? Color(MaterialDynamicColors.surfaceContainerHigh.getArgb(scheme)),
      surfaceContainerHighest:
          surfaceContainerHighest ?? Color(MaterialDynamicColors.surfaceContainerHighest.getArgb(scheme)),
      onSurface: onSurface ?? Color(MaterialDynamicColors.onSurface.getArgb(scheme)),
      onSurfaceVariant: onSurfaceVariant ?? Color(MaterialDynamicColors.onSurfaceVariant.getArgb(scheme)),
      inverseSurface: inverseSurface ?? Color(MaterialDynamicColors.inverseSurface.getArgb(scheme)),
      onInverseSurface: onInverseSurface ?? Color(MaterialDynamicColors.inverseOnSurface.getArgb(scheme)),
      inversePrimary: inversePrimary ?? Color(MaterialDynamicColors.inversePrimary.getArgb(scheme)),
      shadow: shadow ?? Color(MaterialDynamicColors.shadow.getArgb(scheme)),
      scrim: scrim ?? Color(MaterialDynamicColors.scrim.getArgb(scheme)),
      surfaceTint: surfaceTint ?? Color(MaterialDynamicColors.primary.getArgb(scheme)),
      brightness: brightness,
    );
  }

  // ColorScheme.fromImageProvider() utilities.

  // Extracts bytes from an [ImageProvider] and returns a [QuantizerResult]
  // containing the most dominant colors.
  static Future<QuantizerResult> _extractColorsFromImageProvider(ImageProvider imageProvider) async {
    final ui.Image scaledImage = await _imageProviderToScaled(imageProvider);
    final ByteData? imageBytes = await scaledImage.toByteData();

    final QuantizerResult quantizerResult = await QuantizerCelebi().quantize(
      imageBytes!.buffer.asUint32List(),
      128,
      returnInputPixelToClusterPixel: true,
    );
    return quantizerResult;
  }

  // Scale image size down to reduce computation time of color extraction.
  static Future<ui.Image> _imageProviderToScaled(ImageProvider imageProvider) async {
    const double maxDimension = 112.0;
    final ImageStream stream = imageProvider.resolve(const ImageConfiguration(size: Size(maxDimension, maxDimension)));
    final Completer<ui.Image> imageCompleter = Completer<ui.Image>();
    late ImageStreamListener listener;
    late ui.Image scaledImage;
    Timer? loadFailureTimeout;

    listener = ImageStreamListener(
      (info, sync) async {
        loadFailureTimeout?.cancel();
        stream.removeListener(listener);
        final ui.Image image = info.image;
        final int width = image.width;
        final int height = image.height;
        double paintWidth = width.toDouble();
        double paintHeight = height.toDouble();
        assert(width > 0 && height > 0);

        final bool rescale = width > maxDimension || height > maxDimension;
        if (rescale) {
          paintWidth = (width > height) ? maxDimension : (maxDimension / height) * width;
          paintHeight = (height > width) ? maxDimension : (maxDimension / width) * height;
        }
        final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
        final Canvas canvas = Canvas(pictureRecorder);
        paintImage(
          canvas: canvas,
          rect: Rect.fromLTRB(0, 0, paintWidth, paintHeight),
          image: image,
          filterQuality: FilterQuality.none,
        );

        final ui.Picture picture = pictureRecorder.endRecording();
        scaledImage = await picture.toImage(paintWidth.toInt(), paintHeight.toInt());
        imageCompleter.complete(info.image);
      },
      onError: (exception, stackTrace) {
        stream.removeListener(listener);
        throw Exception('Failed to render image: $exception');
      },
    );

    loadFailureTimeout = Timer(const Duration(seconds: 5), () {
      stream.removeListener(listener);
      imageCompleter.completeError(TimeoutException('Timeout occurred trying to load image'));
    });

    stream.addListener(listener);
    await imageCompleter.future;
    return scaledImage;
  }

  // Converts AABBGGRR color int to AARRGGBB format.
  static int _getArgbFromAbgr(int abgr) {
    const int exceptRMask = 0xFF00FFFF;
    const int onlyRMask = ~exceptRMask;
    const int exceptBMask = 0xFFFFFF00;
    const int onlyBMask = ~exceptBMask;
    final int r = (abgr & onlyRMask) >> 16;
    final int b = abgr & onlyBMask;
    return (abgr & exceptRMask & exceptBMask) | (b << 16) | r;
  }

  static DynamicScheme _buildDynamicScheme(
    Brightness brightness,
    Color seedColor,
    DynamicSchemeVariant schemeVariant,
    double contrastLevel,
  ) {
    assert(contrastLevel >= -1.0 && contrastLevel <= 1.0, 'contrastLevel must be between -1.0 and 1.0 inclusive.');
    final bool isDark = brightness == Brightness.dark;
    final Hct sourceColor = Hct.fromInt(seedColor.value);
    return switch (schemeVariant) {
      DynamicSchemeVariant.tonalSpot => SchemeTonalSpot(
        sourceColorHct: sourceColor,
        isDark: isDark,
        contrastLevel: contrastLevel,
      ),
      DynamicSchemeVariant.fidelity => SchemeFidelity(
        sourceColorHct: sourceColor,
        isDark: isDark,
        contrastLevel: contrastLevel,
      ),
      DynamicSchemeVariant.content => SchemeContent(
        sourceColorHct: sourceColor,
        isDark: isDark,
        contrastLevel: contrastLevel,
      ),
      DynamicSchemeVariant.monochrome => SchemeMonochrome(
        sourceColorHct: sourceColor,
        isDark: isDark,
        contrastLevel: contrastLevel,
      ),
      DynamicSchemeVariant.neutral => SchemeNeutral(
        sourceColorHct: sourceColor,
        isDark: isDark,
        contrastLevel: contrastLevel,
      ),
      DynamicSchemeVariant.vibrant => SchemeVibrant(
        sourceColorHct: sourceColor,
        isDark: isDark,
        contrastLevel: contrastLevel,
      ),
      DynamicSchemeVariant.expressive => SchemeExpressive(
        sourceColorHct: sourceColor,
        isDark: isDark,
        contrastLevel: contrastLevel,
      ),
      DynamicSchemeVariant.rainbow => SchemeRainbow(
        sourceColorHct: sourceColor,
        isDark: isDark,
        contrastLevel: contrastLevel,
      ),
      DynamicSchemeVariant.fruitSalad => SchemeFruitSalad(
        sourceColorHct: sourceColor,
        isDark: isDark,
        contrastLevel: contrastLevel,
      ),
    };
  }

  static ColorScheme of(BuildContext context) => Theme.of(context).colorScheme;
}
