// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/card_theme.dart';
import 'package:waveui/material/color_scheme.dart';
import 'package:waveui/material/colors.dart';
import 'package:waveui/material/material.dart';
import 'package:waveui/material/theme.dart';

enum _CardVariant { elevated, filled, outlined }

class Card extends StatelessWidget {
  const Card({
    super.key,
    this.color,
    this.shadowColor,
    this.surfaceTintColor,
    this.elevation,
    this.shape,
    this.borderOnForeground = true,
    this.margin,
    this.clipBehavior,
    this.child,
    this.semanticContainer = true,
  }) : assert(elevation == null || elevation >= 0.0),
       _variant = _CardVariant.elevated;

  const Card.filled({
    super.key,
    this.color,
    this.shadowColor,
    this.surfaceTintColor,
    this.elevation,
    this.shape,
    this.borderOnForeground = true,
    this.margin,
    this.clipBehavior,
    this.child,
    this.semanticContainer = true,
  }) : assert(elevation == null || elevation >= 0.0),
       _variant = _CardVariant.filled;

  const Card.outlined({
    super.key,
    this.color,
    this.shadowColor,
    this.surfaceTintColor,
    this.elevation,
    this.shape,
    this.borderOnForeground = true,
    this.margin,
    this.clipBehavior,
    this.child,
    this.semanticContainer = true,
  }) : assert(elevation == null || elevation >= 0.0),
       _variant = _CardVariant.outlined;

  final Color? color;

  final Color? shadowColor;

  final Color? surfaceTintColor;

  final double? elevation;

  final ShapeBorder? shape;

  final bool borderOnForeground;

  final Clip? clipBehavior;

  final EdgeInsetsGeometry? margin;

  final bool semanticContainer;

  final Widget? child;

  final _CardVariant _variant;

  @override
  Widget build(BuildContext context) {
    final CardThemeData cardTheme = CardTheme.of(context);
    final CardThemeData defaults;
    defaults = switch (_variant) {
      _CardVariant.elevated => _CardDefaultsM3(context),
      _CardVariant.filled => _FilledCardDefaultsM3(context),
      _CardVariant.outlined => _OutlinedCardDefaultsM3(context),
    };

    return Semantics(
      container: semanticContainer,
      child: Padding(
        padding: margin ?? cardTheme.margin ?? defaults.margin!,
        child: Material(
          type: MaterialType.card,
          color: color ?? cardTheme.color ?? defaults.color,
          shadowColor: shadowColor ?? cardTheme.shadowColor ?? defaults.shadowColor,
          surfaceTintColor: surfaceTintColor ?? cardTheme.surfaceTintColor ?? defaults.surfaceTintColor,
          elevation: elevation ?? cardTheme.elevation ?? defaults.elevation!,
          shape: shape ?? cardTheme.shape ?? defaults.shape,
          borderOnForeground: borderOnForeground,
          clipBehavior: clipBehavior ?? cardTheme.clipBehavior ?? defaults.clipBehavior!,
          child: Semantics(explicitChildNodes: !semanticContainer, child: child),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('color', color));
    properties.add(ColorProperty('shadowColor', shadowColor));
    properties.add(ColorProperty('surfaceTintColor', surfaceTintColor));
    properties.add(DoubleProperty('elevation', elevation));
    properties.add(DiagnosticsProperty<ShapeBorder?>('shape', shape));
    properties.add(DiagnosticsProperty<bool>('borderOnForeground', borderOnForeground));
    properties.add(EnumProperty<Clip?>('clipBehavior', clipBehavior));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('margin', margin));
    properties.add(DiagnosticsProperty<bool>('semanticContainer', semanticContainer));
  }
}

// BEGIN GENERATED TOKEN PROPERTIES - Card

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// dart format off
class _CardDefaultsM3 extends CardThemeData {
  _CardDefaultsM3(this.context)
    : super(
        clipBehavior: Clip.none,
        elevation: 1.0,
        margin: const EdgeInsets.all(4.0),
      );

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;

  @override
  Color? get color => _colors.surfaceContainerLow;

  @override
  Color? get shadowColor => _colors.shadow;

  @override
  Color? get surfaceTintColor => Colors.transparent;

  @override
  ShapeBorder? get shape =>const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0)));

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BuildContext>('context', context));
  }
}
// dart format on

// END GENERATED TOKEN PROPERTIES - Card

// BEGIN GENERATED TOKEN PROPERTIES - FilledCard

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// dart format off
class _FilledCardDefaultsM3 extends CardThemeData {
  _FilledCardDefaultsM3(this.context)
    : super(
        clipBehavior: Clip.none,
        elevation: 0.0,
        margin: const EdgeInsets.all(4.0),
      );

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;

  @override
  Color? get color => _colors.surfaceContainerHighest;

  @override
  Color? get shadowColor => _colors.shadow;

  @override
  Color? get surfaceTintColor => Colors.transparent;

  @override
  ShapeBorder? get shape =>const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0)));

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BuildContext>('context', context));
  }
}
// dart format on

// END GENERATED TOKEN PROPERTIES - FilledCard

// BEGIN GENERATED TOKEN PROPERTIES - OutlinedCard

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// dart format off
class _OutlinedCardDefaultsM3 extends CardThemeData {
  _OutlinedCardDefaultsM3(this.context)
    : super(
        clipBehavior: Clip.none,
        elevation: 0.0,
        margin: const EdgeInsets.all(4.0),
      );

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;

  @override
  Color? get color => _colors.surface;

  @override
  Color? get shadowColor => _colors.shadow;

  @override
  Color? get surfaceTintColor => Colors.transparent;

  @override
  ShapeBorder? get shape =>
    const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0))).copyWith(
      side: BorderSide(color: _colors.outlineVariant)
    );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BuildContext>('context', context));
  }
}
// dart format on

// END GENERATED TOKEN PROPERTIES - OutlinedCard
