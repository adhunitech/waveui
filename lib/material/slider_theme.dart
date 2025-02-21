// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;
import 'dart:ui' show Path, lerpDouble;

import 'package:flutter/foundation.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/colors.dart';
import 'package:waveui/material/slider.dart';
import 'package:waveui/material/theme.dart';

class SliderTheme extends InheritedTheme {
  const SliderTheme({required this.data, required super.child, super.key});

  final SliderThemeData data;

  static SliderThemeData of(BuildContext context) {
    final SliderTheme? inheritedTheme = context.dependOnInheritedWidgetOfExactType<SliderTheme>();
    return inheritedTheme != null ? inheritedTheme.data : Theme.of(context).sliderTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) => SliderTheme(data: data, child: child);

  @override
  bool updateShouldNotify(SliderTheme oldWidget) => data != oldWidget.data;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SliderThemeData>('data', data));
  }
}

enum ShowValueIndicator { onlyForDiscrete, onlyForContinuous, always, never }

enum Thumb { start, end }

@immutable
class SliderThemeData with Diagnosticable {
  const SliderThemeData({
    this.trackHeight,
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.secondaryActiveTrackColor,
    this.disabledActiveTrackColor,
    this.disabledInactiveTrackColor,
    this.disabledSecondaryActiveTrackColor,
    this.activeTickMarkColor,
    this.inactiveTickMarkColor,
    this.disabledActiveTickMarkColor,
    this.disabledInactiveTickMarkColor,
    this.thumbColor,
    this.overlappingShapeStrokeColor,
    this.disabledThumbColor,
    this.overlayColor,
    this.valueIndicatorColor,
    this.valueIndicatorStrokeColor,
    this.overlayShape,
    this.tickMarkShape,
    this.thumbShape,
    this.trackShape,
    this.valueIndicatorShape,
    this.rangeTickMarkShape,
    this.rangeThumbShape,
    this.rangeTrackShape,
    this.rangeValueIndicatorShape,
    this.showValueIndicator,
    this.valueIndicatorTextStyle,
    this.minThumbSeparation,
    this.thumbSelector,
    this.mouseCursor,
    this.allowedInteraction,
    this.padding,
    this.thumbSize,
    this.trackGap,
  });

  factory SliderThemeData.fromPrimaryColors({
    required Color primaryColor,
    required Color primaryColorDark,
    required Color primaryColorLight,
    required TextStyle valueIndicatorTextStyle,
  }) {
    // These are Material Design defaults, and are used to derive
    // component Colors (with opacity) from base colors.
    const int activeTrackAlpha = 0xff;
    const int inactiveTrackAlpha = 0x3d; // 24% opacity
    const int secondaryActiveTrackAlpha = 0x8a; // 54% opacity
    const int disabledActiveTrackAlpha = 0x52; // 32% opacity
    const int disabledInactiveTrackAlpha = 0x1f; // 12% opacity
    const int disabledSecondaryActiveTrackAlpha = 0x1f; // 12% opacity
    const int activeTickMarkAlpha = 0x8a; // 54% opacity
    const int inactiveTickMarkAlpha = 0x8a; // 54% opacity
    const int disabledActiveTickMarkAlpha = 0x1f; // 12% opacity
    const int disabledInactiveTickMarkAlpha = 0x1f; // 12% opacity
    const int thumbAlpha = 0xff;
    const int disabledThumbAlpha = 0x52; // 32% opacity
    const int overlayAlpha = 0x1f; // 12% opacity
    const int valueIndicatorAlpha = 0xff;

    return SliderThemeData(
      trackHeight: 2.0,
      activeTrackColor: primaryColor.withAlpha(activeTrackAlpha),
      inactiveTrackColor: primaryColor.withAlpha(inactiveTrackAlpha),
      secondaryActiveTrackColor: primaryColor.withAlpha(secondaryActiveTrackAlpha),
      disabledActiveTrackColor: primaryColorDark.withAlpha(disabledActiveTrackAlpha),
      disabledInactiveTrackColor: primaryColorDark.withAlpha(disabledInactiveTrackAlpha),
      disabledSecondaryActiveTrackColor: primaryColorDark.withAlpha(disabledSecondaryActiveTrackAlpha),
      activeTickMarkColor: primaryColorLight.withAlpha(activeTickMarkAlpha),
      inactiveTickMarkColor: primaryColor.withAlpha(inactiveTickMarkAlpha),
      disabledActiveTickMarkColor: primaryColorLight.withAlpha(disabledActiveTickMarkAlpha),
      disabledInactiveTickMarkColor: primaryColorDark.withAlpha(disabledInactiveTickMarkAlpha),
      thumbColor: primaryColor.withAlpha(thumbAlpha),
      overlappingShapeStrokeColor: Colors.white,
      disabledThumbColor: primaryColorDark.withAlpha(disabledThumbAlpha),
      overlayColor: primaryColor.withAlpha(overlayAlpha),
      valueIndicatorColor: primaryColor.withAlpha(valueIndicatorAlpha),
      valueIndicatorStrokeColor: primaryColor.withAlpha(valueIndicatorAlpha),
      overlayShape: const RoundSliderOverlayShape(),
      tickMarkShape: const RoundSliderTickMarkShape(),
      thumbShape: const RoundSliderThumbShape(),
      trackShape: const RoundedRectSliderTrackShape(),
      valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
      rangeTickMarkShape: const RoundRangeSliderTickMarkShape(),
      rangeThumbShape: const RoundRangeSliderThumbShape(),
      rangeTrackShape: const RoundedRectRangeSliderTrackShape(),
      rangeValueIndicatorShape: const PaddleRangeSliderValueIndicatorShape(),
      valueIndicatorTextStyle: valueIndicatorTextStyle,
      showValueIndicator: ShowValueIndicator.onlyForDiscrete,
    );
  }

  final double? trackHeight;

  final Color? activeTrackColor;

  final Color? inactiveTrackColor;

  final Color? secondaryActiveTrackColor;

  final Color? disabledActiveTrackColor;

  final Color? disabledSecondaryActiveTrackColor;

  final Color? disabledInactiveTrackColor;

  final Color? activeTickMarkColor;

  final Color? inactiveTickMarkColor;

  final Color? disabledActiveTickMarkColor;

  final Color? disabledInactiveTickMarkColor;

  final Color? thumbColor;

  final Color? overlappingShapeStrokeColor;

  final Color? disabledThumbColor;

  final Color? overlayColor;

  final Color? valueIndicatorColor;

  final Color? valueIndicatorStrokeColor;

  final SliderComponentShape? overlayShape;

  final SliderTickMarkShape? tickMarkShape;

  final SliderComponentShape? thumbShape;

  final SliderTrackShape? trackShape;

  final SliderComponentShape? valueIndicatorShape;

  final RangeSliderTickMarkShape? rangeTickMarkShape;

  final RangeSliderThumbShape? rangeThumbShape;

  final RangeSliderTrackShape? rangeTrackShape;

  final RangeSliderValueIndicatorShape? rangeValueIndicatorShape;

  final ShowValueIndicator? showValueIndicator;

  final TextStyle? valueIndicatorTextStyle;

  final double? minThumbSeparation;

  final RangeThumbSelector? thumbSelector;

  final WidgetStateProperty<MouseCursor?>? mouseCursor;

  final SliderInteraction? allowedInteraction;

  final EdgeInsetsGeometry? padding;

  final WidgetStateProperty<Size?>? thumbSize;

  final double? trackGap;

  SliderThemeData copyWith({
    double? trackHeight,
    Color? activeTrackColor,
    Color? inactiveTrackColor,
    Color? secondaryActiveTrackColor,
    Color? disabledActiveTrackColor,
    Color? disabledInactiveTrackColor,
    Color? disabledSecondaryActiveTrackColor,
    Color? activeTickMarkColor,
    Color? inactiveTickMarkColor,
    Color? disabledActiveTickMarkColor,
    Color? disabledInactiveTickMarkColor,
    Color? thumbColor,
    Color? overlappingShapeStrokeColor,
    Color? disabledThumbColor,
    Color? overlayColor,
    Color? valueIndicatorColor,
    Color? valueIndicatorStrokeColor,
    SliderComponentShape? overlayShape,
    SliderTickMarkShape? tickMarkShape,
    SliderComponentShape? thumbShape,
    SliderTrackShape? trackShape,
    SliderComponentShape? valueIndicatorShape,
    RangeSliderTickMarkShape? rangeTickMarkShape,
    RangeSliderThumbShape? rangeThumbShape,
    RangeSliderTrackShape? rangeTrackShape,
    RangeSliderValueIndicatorShape? rangeValueIndicatorShape,
    ShowValueIndicator? showValueIndicator,
    TextStyle? valueIndicatorTextStyle,
    double? minThumbSeparation,
    RangeThumbSelector? thumbSelector,
    WidgetStateProperty<MouseCursor?>? mouseCursor,
    SliderInteraction? allowedInteraction,
    EdgeInsetsGeometry? padding,
    WidgetStateProperty<Size?>? thumbSize,
    double? trackGap,
  }) => SliderThemeData(
    trackHeight: trackHeight ?? this.trackHeight,
    activeTrackColor: activeTrackColor ?? this.activeTrackColor,
    inactiveTrackColor: inactiveTrackColor ?? this.inactiveTrackColor,
    secondaryActiveTrackColor: secondaryActiveTrackColor ?? this.secondaryActiveTrackColor,
    disabledActiveTrackColor: disabledActiveTrackColor ?? this.disabledActiveTrackColor,
    disabledInactiveTrackColor: disabledInactiveTrackColor ?? this.disabledInactiveTrackColor,
    disabledSecondaryActiveTrackColor: disabledSecondaryActiveTrackColor ?? this.disabledSecondaryActiveTrackColor,
    activeTickMarkColor: activeTickMarkColor ?? this.activeTickMarkColor,
    inactiveTickMarkColor: inactiveTickMarkColor ?? this.inactiveTickMarkColor,
    disabledActiveTickMarkColor: disabledActiveTickMarkColor ?? this.disabledActiveTickMarkColor,
    disabledInactiveTickMarkColor: disabledInactiveTickMarkColor ?? this.disabledInactiveTickMarkColor,
    thumbColor: thumbColor ?? this.thumbColor,
    overlappingShapeStrokeColor: overlappingShapeStrokeColor ?? this.overlappingShapeStrokeColor,
    disabledThumbColor: disabledThumbColor ?? this.disabledThumbColor,
    overlayColor: overlayColor ?? this.overlayColor,
    valueIndicatorColor: valueIndicatorColor ?? this.valueIndicatorColor,
    valueIndicatorStrokeColor: valueIndicatorStrokeColor ?? this.valueIndicatorStrokeColor,
    overlayShape: overlayShape ?? this.overlayShape,
    tickMarkShape: tickMarkShape ?? this.tickMarkShape,
    thumbShape: thumbShape ?? this.thumbShape,
    trackShape: trackShape ?? this.trackShape,
    valueIndicatorShape: valueIndicatorShape ?? this.valueIndicatorShape,
    rangeTickMarkShape: rangeTickMarkShape ?? this.rangeTickMarkShape,
    rangeThumbShape: rangeThumbShape ?? this.rangeThumbShape,
    rangeTrackShape: rangeTrackShape ?? this.rangeTrackShape,
    rangeValueIndicatorShape: rangeValueIndicatorShape ?? this.rangeValueIndicatorShape,
    showValueIndicator: showValueIndicator ?? this.showValueIndicator,
    valueIndicatorTextStyle: valueIndicatorTextStyle ?? this.valueIndicatorTextStyle,
    minThumbSeparation: minThumbSeparation ?? this.minThumbSeparation,
    thumbSelector: thumbSelector ?? this.thumbSelector,
    mouseCursor: mouseCursor ?? this.mouseCursor,
    allowedInteraction: allowedInteraction ?? this.allowedInteraction,
    padding: padding ?? this.padding,
    thumbSize: thumbSize ?? this.thumbSize,
    trackGap: trackGap ?? this.trackGap,
  );

  static SliderThemeData lerp(SliderThemeData a, SliderThemeData b, double t) {
    if (identical(a, b)) {
      return a;
    }
    return SliderThemeData(
      trackHeight: lerpDouble(a.trackHeight, b.trackHeight, t),
      activeTrackColor: Color.lerp(a.activeTrackColor, b.activeTrackColor, t),
      inactiveTrackColor: Color.lerp(a.inactiveTrackColor, b.inactiveTrackColor, t),
      secondaryActiveTrackColor: Color.lerp(a.secondaryActiveTrackColor, b.secondaryActiveTrackColor, t),
      disabledActiveTrackColor: Color.lerp(a.disabledActiveTrackColor, b.disabledActiveTrackColor, t),
      disabledInactiveTrackColor: Color.lerp(a.disabledInactiveTrackColor, b.disabledInactiveTrackColor, t),
      disabledSecondaryActiveTrackColor: Color.lerp(
        a.disabledSecondaryActiveTrackColor,
        b.disabledSecondaryActiveTrackColor,
        t,
      ),
      activeTickMarkColor: Color.lerp(a.activeTickMarkColor, b.activeTickMarkColor, t),
      inactiveTickMarkColor: Color.lerp(a.inactiveTickMarkColor, b.inactiveTickMarkColor, t),
      disabledActiveTickMarkColor: Color.lerp(a.disabledActiveTickMarkColor, b.disabledActiveTickMarkColor, t),
      disabledInactiveTickMarkColor: Color.lerp(a.disabledInactiveTickMarkColor, b.disabledInactiveTickMarkColor, t),
      thumbColor: Color.lerp(a.thumbColor, b.thumbColor, t),
      overlappingShapeStrokeColor: Color.lerp(a.overlappingShapeStrokeColor, b.overlappingShapeStrokeColor, t),
      disabledThumbColor: Color.lerp(a.disabledThumbColor, b.disabledThumbColor, t),
      overlayColor: Color.lerp(a.overlayColor, b.overlayColor, t),
      valueIndicatorColor: Color.lerp(a.valueIndicatorColor, b.valueIndicatorColor, t),
      valueIndicatorStrokeColor: Color.lerp(a.valueIndicatorStrokeColor, b.valueIndicatorStrokeColor, t),
      overlayShape: t < 0.5 ? a.overlayShape : b.overlayShape,
      tickMarkShape: t < 0.5 ? a.tickMarkShape : b.tickMarkShape,
      thumbShape: t < 0.5 ? a.thumbShape : b.thumbShape,
      trackShape: t < 0.5 ? a.trackShape : b.trackShape,
      valueIndicatorShape: t < 0.5 ? a.valueIndicatorShape : b.valueIndicatorShape,
      rangeTickMarkShape: t < 0.5 ? a.rangeTickMarkShape : b.rangeTickMarkShape,
      rangeThumbShape: t < 0.5 ? a.rangeThumbShape : b.rangeThumbShape,
      rangeTrackShape: t < 0.5 ? a.rangeTrackShape : b.rangeTrackShape,
      rangeValueIndicatorShape: t < 0.5 ? a.rangeValueIndicatorShape : b.rangeValueIndicatorShape,
      showValueIndicator: t < 0.5 ? a.showValueIndicator : b.showValueIndicator,
      valueIndicatorTextStyle: TextStyle.lerp(a.valueIndicatorTextStyle, b.valueIndicatorTextStyle, t),
      minThumbSeparation: lerpDouble(a.minThumbSeparation, b.minThumbSeparation, t),
      thumbSelector: t < 0.5 ? a.thumbSelector : b.thumbSelector,
      mouseCursor: t < 0.5 ? a.mouseCursor : b.mouseCursor,
      allowedInteraction: t < 0.5 ? a.allowedInteraction : b.allowedInteraction,
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      thumbSize: WidgetStateProperty.lerp<Size?>(a.thumbSize, b.thumbSize, t, Size.lerp),
      trackGap: lerpDouble(a.trackGap, b.trackGap, t),
    );
  }

  @override
  int get hashCode => Object.hash(
    trackHeight,
    activeTrackColor,
    inactiveTrackColor,
    secondaryActiveTrackColor,
    disabledActiveTrackColor,
    disabledInactiveTrackColor,
    disabledSecondaryActiveTrackColor,
    activeTickMarkColor,
    inactiveTickMarkColor,
    disabledActiveTickMarkColor,
    disabledInactiveTickMarkColor,
    thumbColor,
    overlappingShapeStrokeColor,
    disabledThumbColor,
    overlayColor,
    valueIndicatorColor,
    overlayShape,
    tickMarkShape,
    thumbShape,
    Object.hash(
      trackShape,
      valueIndicatorShape,
      rangeTickMarkShape,
      rangeThumbShape,
      rangeTrackShape,
      rangeValueIndicatorShape,
      showValueIndicator,
      valueIndicatorTextStyle,
      minThumbSeparation,
      thumbSelector,
      mouseCursor,
      allowedInteraction,
      padding,
      thumbSize,
      trackGap,
    ),
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is SliderThemeData &&
        other.trackHeight == trackHeight &&
        other.activeTrackColor == activeTrackColor &&
        other.inactiveTrackColor == inactiveTrackColor &&
        other.secondaryActiveTrackColor == secondaryActiveTrackColor &&
        other.disabledActiveTrackColor == disabledActiveTrackColor &&
        other.disabledInactiveTrackColor == disabledInactiveTrackColor &&
        other.disabledSecondaryActiveTrackColor == disabledSecondaryActiveTrackColor &&
        other.activeTickMarkColor == activeTickMarkColor &&
        other.inactiveTickMarkColor == inactiveTickMarkColor &&
        other.disabledActiveTickMarkColor == disabledActiveTickMarkColor &&
        other.disabledInactiveTickMarkColor == disabledInactiveTickMarkColor &&
        other.thumbColor == thumbColor &&
        other.overlappingShapeStrokeColor == overlappingShapeStrokeColor &&
        other.disabledThumbColor == disabledThumbColor &&
        other.overlayColor == overlayColor &&
        other.valueIndicatorColor == valueIndicatorColor &&
        other.valueIndicatorStrokeColor == valueIndicatorStrokeColor &&
        other.overlayShape == overlayShape &&
        other.tickMarkShape == tickMarkShape &&
        other.thumbShape == thumbShape &&
        other.trackShape == trackShape &&
        other.valueIndicatorShape == valueIndicatorShape &&
        other.rangeTickMarkShape == rangeTickMarkShape &&
        other.rangeThumbShape == rangeThumbShape &&
        other.rangeTrackShape == rangeTrackShape &&
        other.rangeValueIndicatorShape == rangeValueIndicatorShape &&
        other.showValueIndicator == showValueIndicator &&
        other.valueIndicatorTextStyle == valueIndicatorTextStyle &&
        other.minThumbSeparation == minThumbSeparation &&
        other.thumbSelector == thumbSelector &&
        other.mouseCursor == mouseCursor &&
        other.allowedInteraction == allowedInteraction &&
        other.padding == padding &&
        other.thumbSize == thumbSize &&
        other.trackGap == trackGap;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    const SliderThemeData defaultData = SliderThemeData();
    properties.add(DoubleProperty('trackHeight', trackHeight, defaultValue: defaultData.trackHeight));
    properties.add(ColorProperty('activeTrackColor', activeTrackColor, defaultValue: defaultData.activeTrackColor));
    properties.add(
      ColorProperty('inactiveTrackColor', inactiveTrackColor, defaultValue: defaultData.inactiveTrackColor),
    );
    properties.add(
      ColorProperty(
        'secondaryActiveTrackColor',
        secondaryActiveTrackColor,
        defaultValue: defaultData.secondaryActiveTrackColor,
      ),
    );
    properties.add(
      ColorProperty(
        'disabledActiveTrackColor',
        disabledActiveTrackColor,
        defaultValue: defaultData.disabledActiveTrackColor,
      ),
    );
    properties.add(
      ColorProperty(
        'disabledInactiveTrackColor',
        disabledInactiveTrackColor,
        defaultValue: defaultData.disabledInactiveTrackColor,
      ),
    );
    properties.add(
      ColorProperty(
        'disabledSecondaryActiveTrackColor',
        disabledSecondaryActiveTrackColor,
        defaultValue: defaultData.disabledSecondaryActiveTrackColor,
      ),
    );
    properties.add(
      ColorProperty('activeTickMarkColor', activeTickMarkColor, defaultValue: defaultData.activeTickMarkColor),
    );
    properties.add(
      ColorProperty('inactiveTickMarkColor', inactiveTickMarkColor, defaultValue: defaultData.inactiveTickMarkColor),
    );
    properties.add(
      ColorProperty(
        'disabledActiveTickMarkColor',
        disabledActiveTickMarkColor,
        defaultValue: defaultData.disabledActiveTickMarkColor,
      ),
    );
    properties.add(
      ColorProperty(
        'disabledInactiveTickMarkColor',
        disabledInactiveTickMarkColor,
        defaultValue: defaultData.disabledInactiveTickMarkColor,
      ),
    );
    properties.add(ColorProperty('thumbColor', thumbColor, defaultValue: defaultData.thumbColor));
    properties.add(
      ColorProperty(
        'overlappingShapeStrokeColor',
        overlappingShapeStrokeColor,
        defaultValue: defaultData.overlappingShapeStrokeColor,
      ),
    );
    properties.add(
      ColorProperty('disabledThumbColor', disabledThumbColor, defaultValue: defaultData.disabledThumbColor),
    );
    properties.add(ColorProperty('overlayColor', overlayColor, defaultValue: defaultData.overlayColor));
    properties.add(
      ColorProperty('valueIndicatorColor', valueIndicatorColor, defaultValue: defaultData.valueIndicatorColor),
    );
    properties.add(
      ColorProperty(
        'valueIndicatorStrokeColor',
        valueIndicatorStrokeColor,
        defaultValue: defaultData.valueIndicatorStrokeColor,
      ),
    );
    properties.add(
      DiagnosticsProperty<SliderComponentShape>('overlayShape', overlayShape, defaultValue: defaultData.overlayShape),
    );
    properties.add(
      DiagnosticsProperty<SliderTickMarkShape>('tickMarkShape', tickMarkShape, defaultValue: defaultData.tickMarkShape),
    );
    properties.add(
      DiagnosticsProperty<SliderComponentShape>('thumbShape', thumbShape, defaultValue: defaultData.thumbShape),
    );
    properties.add(
      DiagnosticsProperty<SliderTrackShape>('trackShape', trackShape, defaultValue: defaultData.trackShape),
    );
    properties.add(
      DiagnosticsProperty<SliderComponentShape>(
        'valueIndicatorShape',
        valueIndicatorShape,
        defaultValue: defaultData.valueIndicatorShape,
      ),
    );
    properties.add(
      DiagnosticsProperty<RangeSliderTickMarkShape>(
        'rangeTickMarkShape',
        rangeTickMarkShape,
        defaultValue: defaultData.rangeTickMarkShape,
      ),
    );
    properties.add(
      DiagnosticsProperty<RangeSliderThumbShape>(
        'rangeThumbShape',
        rangeThumbShape,
        defaultValue: defaultData.rangeThumbShape,
      ),
    );
    properties.add(
      DiagnosticsProperty<RangeSliderTrackShape>(
        'rangeTrackShape',
        rangeTrackShape,
        defaultValue: defaultData.rangeTrackShape,
      ),
    );
    properties.add(
      DiagnosticsProperty<RangeSliderValueIndicatorShape>(
        'rangeValueIndicatorShape',
        rangeValueIndicatorShape,
        defaultValue: defaultData.rangeValueIndicatorShape,
      ),
    );
    properties.add(
      EnumProperty<ShowValueIndicator>(
        'showValueIndicator',
        showValueIndicator,
        defaultValue: defaultData.showValueIndicator,
      ),
    );
    properties.add(
      DiagnosticsProperty<TextStyle>(
        'valueIndicatorTextStyle',
        valueIndicatorTextStyle,
        defaultValue: defaultData.valueIndicatorTextStyle,
      ),
    );
    properties.add(
      DoubleProperty('minThumbSeparation', minThumbSeparation, defaultValue: defaultData.minThumbSeparation),
    );
    properties.add(
      DiagnosticsProperty<RangeThumbSelector>('thumbSelector', thumbSelector, defaultValue: defaultData.thumbSelector),
    );
    properties.add(
      DiagnosticsProperty<WidgetStateProperty<MouseCursor?>>(
        'mouseCursor',
        mouseCursor,
        defaultValue: defaultData.mouseCursor,
      ),
    );
    properties.add(
      EnumProperty<SliderInteraction>(
        'allowedInteraction',
        allowedInteraction,
        defaultValue: defaultData.allowedInteraction,
      ),
    );
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding, defaultValue: defaultData.padding));
    properties.add(
      DiagnosticsProperty<WidgetStateProperty<Size?>>('thumbSize', thumbSize, defaultValue: defaultData.thumbSize),
    );
    properties.add(DoubleProperty('trackGap', trackGap, defaultValue: defaultData.trackGap));
  }
}

abstract class SliderComponentShape {
  const SliderComponentShape();

  Size getPreferredSize(bool isEnabled, bool isDiscrete);

  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  });

  static final SliderComponentShape noThumb = _EmptySliderComponentShape();

  static final SliderComponentShape noOverlay = _EmptySliderComponentShape();
}

abstract class SliderTickMarkShape {
  const SliderTickMarkShape();

  Size getPreferredSize({required SliderThemeData sliderTheme, required bool isEnabled});

  void paint(
    PaintingContext context,
    Offset center, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset thumbCenter,
    required bool isEnabled,
    required TextDirection textDirection,
  });

  static final SliderTickMarkShape noTickMark = _EmptySliderTickMarkShape();
}

abstract class SliderTrackShape {
  const SliderTrackShape();

  Rect getPreferredRect({
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    Offset offset = Offset.zero,
    bool isEnabled,
    bool isDiscrete,
  });

  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset thumbCenter,
    required TextDirection textDirection,
    Offset? secondaryOffset,
    bool isEnabled,
    bool isDiscrete,
  });

  bool get isRounded => false;
}

abstract class RangeSliderThumbShape {
  const RangeSliderThumbShape();

  Size getPreferredSize(bool isEnabled, bool isDiscrete);

  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required SliderThemeData sliderTheme,
    bool isDiscrete,
    bool isEnabled,
    bool isOnTop,
    TextDirection textDirection,
    Thumb thumb,
    bool isPressed,
  });
}

abstract class RangeSliderValueIndicatorShape {
  const RangeSliderValueIndicatorShape();

  Size getPreferredSize(
    bool isEnabled,
    bool isDiscrete, {
    required TextPainter labelPainter,
    required double textScaleFactor,
  });

  double getHorizontalShift({
    RenderBox? parentBox,
    Offset? center,
    TextPainter? labelPainter,
    Animation<double>? activationAnimation,
    double? textScaleFactor,
    Size? sizeWithOverflow,
  }) => 0;

  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    bool isDiscrete,
    bool isOnTop,
    double textScaleFactor,
    Size sizeWithOverflow,
    TextDirection textDirection,
    double value,
    Thumb thumb,
  });
}

abstract class RangeSliderTickMarkShape {
  const RangeSliderTickMarkShape();

  Size getPreferredSize({required SliderThemeData sliderTheme, bool isEnabled});

  void paint(
    PaintingContext context,
    Offset center, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset startThumbCenter,
    required Offset endThumbCenter,
    required TextDirection textDirection,
    bool isEnabled,
  });
}

abstract class RangeSliderTrackShape {
  const RangeSliderTrackShape();

  Rect getPreferredRect({
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    Offset offset = Offset.zero,
    bool isEnabled,
    bool isDiscrete,
  });

  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset startThumbCenter,
    required Offset endThumbCenter,
    required TextDirection textDirection,
    bool isEnabled = false,
    bool isDiscrete = false,
  });

  bool get isRounded => false;
}

mixin BaseSliderTrackShape {
  Rect getPreferredRect({
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    Offset offset = Offset.zero,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double thumbWidth = sliderTheme.thumbShape!.getPreferredSize(isEnabled, isDiscrete).width;
    final double overlayWidth = sliderTheme.overlayShape!.getPreferredSize(isEnabled, isDiscrete).width;
    double trackHeight = sliderTheme.trackHeight!;
    assert(overlayWidth >= 0);
    assert(trackHeight >= 0);

    // If the track colors are transparent, then override only the track height
    // to maintain overall Slider width.
    if (sliderTheme.activeTrackColor == Colors.transparent && sliderTheme.inactiveTrackColor == Colors.transparent) {
      trackHeight = 0;
    }

    final double trackLeft = offset.dx + (sliderTheme.padding == null ? math.max(overlayWidth / 2, thumbWidth / 2) : 0);
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackRight =
        trackLeft + parentBox.size.width - (sliderTheme.padding == null ? math.max(thumbWidth, overlayWidth) : 0);
    final double trackBottom = trackTop + trackHeight;
    // If the parentBox's size less than slider's size the trackRight will be less than trackLeft, so switch them.
    return Rect.fromLTRB(math.min(trackLeft, trackRight), trackTop, math.max(trackLeft, trackRight), trackBottom);
  }

  bool get isRounded => false;
}

class RectangularSliderTrackShape extends SliderTrackShape with BaseSliderTrackShape {
  const RectangularSliderTrackShape();

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
  }) {
    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.thumbShape != null);
    // If the slider [SliderThemeData.trackHeight] is less than or equal to 0,
    // then it makes no difference whether the track is painted or not,
    // therefore the painting can be a no-op.
    if (sliderTheme.trackHeight! <= 0) {
      return;
    }

    // Assign the track segment paints, which are left: active, right: inactive,
    // but reversed for right to left text.
    final ColorTween activeTrackColorTween = ColorTween(
      begin: sliderTheme.disabledActiveTrackColor,
      end: sliderTheme.activeTrackColor,
    );
    final ColorTween inactiveTrackColorTween = ColorTween(
      begin: sliderTheme.disabledInactiveTrackColor,
      end: sliderTheme.inactiveTrackColor,
    );
    final Paint activePaint = Paint()..color = activeTrackColorTween.evaluate(enableAnimation)!;
    final Paint inactivePaint = Paint()..color = inactiveTrackColorTween.evaluate(enableAnimation)!;
    final (Paint leftTrackPaint, Paint rightTrackPaint) = switch (textDirection) {
      TextDirection.ltr => (activePaint, inactivePaint),
      TextDirection.rtl => (inactivePaint, activePaint),
    };

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final Rect leftTrackSegment = Rect.fromLTRB(trackRect.left, trackRect.top, thumbCenter.dx, trackRect.bottom);
    if (!leftTrackSegment.isEmpty) {
      context.canvas.drawRect(leftTrackSegment, leftTrackPaint);
    }
    final Rect rightTrackSegment = Rect.fromLTRB(thumbCenter.dx, trackRect.top, trackRect.right, trackRect.bottom);
    if (!rightTrackSegment.isEmpty) {
      context.canvas.drawRect(rightTrackSegment, rightTrackPaint);
    }

    final bool showSecondaryTrack =
        secondaryOffset != null &&
        switch (textDirection) {
          TextDirection.rtl => secondaryOffset.dx < thumbCenter.dx,
          TextDirection.ltr => secondaryOffset.dx > thumbCenter.dx,
        };

    if (showSecondaryTrack) {
      final ColorTween secondaryTrackColorTween = ColorTween(
        begin: sliderTheme.disabledSecondaryActiveTrackColor,
        end: sliderTheme.secondaryActiveTrackColor,
      );
      final Paint secondaryTrackPaint = Paint()..color = secondaryTrackColorTween.evaluate(enableAnimation)!;
      final Rect secondaryTrackSegment = switch (textDirection) {
        TextDirection.rtl => Rect.fromLTRB(secondaryOffset.dx, trackRect.top, thumbCenter.dx, trackRect.bottom),
        TextDirection.ltr => Rect.fromLTRB(thumbCenter.dx, trackRect.top, secondaryOffset.dx, trackRect.bottom),
      };
      if (!secondaryTrackSegment.isEmpty) {
        context.canvas.drawRect(secondaryTrackSegment, secondaryTrackPaint);
      }
    }
  }
}

class RoundedRectSliderTrackShape extends SliderTrackShape with BaseSliderTrackShape {
  const RoundedRectSliderTrackShape();

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 2,
  }) {
    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.thumbShape != null);
    // If the slider [SliderThemeData.trackHeight] is less than or equal to 0,
    // then it makes no difference whether the track is painted or not,
    // therefore the painting can be a no-op.
    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }

    // Assign the track segment paints, which are leading: active and
    // trailing: inactive.
    final ColorTween activeTrackColorTween = ColorTween(
      begin: sliderTheme.disabledActiveTrackColor,
      end: sliderTheme.activeTrackColor,
    );
    final ColorTween inactiveTrackColorTween = ColorTween(
      begin: sliderTheme.disabledInactiveTrackColor,
      end: sliderTheme.inactiveTrackColor,
    );
    final Paint activePaint = Paint()..color = activeTrackColorTween.evaluate(enableAnimation)!;
    final Paint inactivePaint = Paint()..color = inactiveTrackColorTween.evaluate(enableAnimation)!;
    final (Paint leftTrackPaint, Paint rightTrackPaint) = switch (textDirection) {
      TextDirection.ltr => (activePaint, inactivePaint),
      TextDirection.rtl => (inactivePaint, activePaint),
    };

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    final Radius trackRadius = Radius.circular(trackRect.height / 2);
    final Radius activeTrackRadius = Radius.circular((trackRect.height + additionalActiveTrackHeight) / 2);
    final bool isLTR = textDirection == TextDirection.ltr;
    final bool isRTL = textDirection == TextDirection.rtl;

    final bool drawInactiveTrack = thumbCenter.dx < (trackRect.right - (sliderTheme.trackHeight! / 2));
    if (drawInactiveTrack) {
      // Draw the inactive track segment.
      context.canvas.drawRRect(
        RRect.fromLTRBR(
          thumbCenter.dx - (sliderTheme.trackHeight! / 2),
          isRTL ? trackRect.top - (additionalActiveTrackHeight / 2) : trackRect.top,
          trackRect.right,
          isRTL ? trackRect.bottom + (additionalActiveTrackHeight / 2) : trackRect.bottom,
          isLTR ? trackRadius : activeTrackRadius,
        ),
        rightTrackPaint,
      );
    }
    final bool drawActiveTrack = thumbCenter.dx > (trackRect.left + (sliderTheme.trackHeight! / 2));
    if (drawActiveTrack) {
      // Draw the active track segment.
      context.canvas.drawRRect(
        RRect.fromLTRBR(
          trackRect.left,
          isLTR ? trackRect.top - (additionalActiveTrackHeight / 2) : trackRect.top,
          thumbCenter.dx + (sliderTheme.trackHeight! / 2),
          isLTR ? trackRect.bottom + (additionalActiveTrackHeight / 2) : trackRect.bottom,
          isLTR ? activeTrackRadius : trackRadius,
        ),
        leftTrackPaint,
      );
    }

    final bool showSecondaryTrack =
        (secondaryOffset != null) &&
        (isLTR ? (secondaryOffset.dx > thumbCenter.dx) : (secondaryOffset.dx < thumbCenter.dx));

    if (showSecondaryTrack) {
      final ColorTween secondaryTrackColorTween = ColorTween(
        begin: sliderTheme.disabledSecondaryActiveTrackColor,
        end: sliderTheme.secondaryActiveTrackColor,
      );
      final Paint secondaryTrackPaint = Paint()..color = secondaryTrackColorTween.evaluate(enableAnimation)!;
      if (isLTR) {
        context.canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            thumbCenter.dx,
            trackRect.top,
            secondaryOffset.dx,
            trackRect.bottom,
            topRight: trackRadius,
            bottomRight: trackRadius,
          ),
          secondaryTrackPaint,
        );
      } else {
        context.canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            secondaryOffset.dx,
            trackRect.top,
            thumbCenter.dx,
            trackRect.bottom,
            topLeft: trackRadius,
            bottomLeft: trackRadius,
          ),
          secondaryTrackPaint,
        );
      }
    }
  }

  @override
  bool get isRounded => true;
}

mixin BaseRangeSliderTrackShape {
  Rect getPreferredRect({
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    Offset offset = Offset.zero,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    assert(sliderTheme.rangeThumbShape != null);
    assert(sliderTheme.overlayShape != null);
    assert(sliderTheme.trackHeight != null);
    final double thumbWidth = sliderTheme.rangeThumbShape!.getPreferredSize(isEnabled, isDiscrete).width;
    final double overlayWidth = sliderTheme.overlayShape!.getPreferredSize(isEnabled, isDiscrete).width;
    final double trackHeight = sliderTheme.trackHeight!;
    assert(overlayWidth >= 0);
    assert(trackHeight >= 0);

    final double trackLeft = offset.dx + math.max(overlayWidth / 2, thumbWidth / 2);
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackRight = trackLeft + parentBox.size.width - math.max(thumbWidth, overlayWidth);
    final double trackBottom = trackTop + trackHeight;
    // If the parentBox's size less than slider's size the trackRight will be less than trackLeft, so switch them.
    return Rect.fromLTRB(math.min(trackLeft, trackRight), trackTop, math.max(trackLeft, trackRight), trackBottom);
  }
}

class RectangularRangeSliderTrackShape extends RangeSliderTrackShape with BaseRangeSliderTrackShape {
  const RectangularRangeSliderTrackShape();

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double>? enableAnimation,
    required Offset startThumbCenter,
    required Offset endThumbCenter,
    required TextDirection textDirection,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.rangeThumbShape != null);
    assert(enableAnimation != null);
    // Assign the track segment paints, which are left: active, right: inactive,
    // but reversed for right to left text.
    final ColorTween activeTrackColorTween = ColorTween(
      begin: sliderTheme.disabledActiveTrackColor,
      end: sliderTheme.activeTrackColor,
    );
    final ColorTween inactiveTrackColorTween = ColorTween(
      begin: sliderTheme.disabledInactiveTrackColor,
      end: sliderTheme.inactiveTrackColor,
    );
    final Paint activePaint = Paint()..color = activeTrackColorTween.evaluate(enableAnimation!)!;
    final Paint inactivePaint = Paint()..color = inactiveTrackColorTween.evaluate(enableAnimation)!;

    final (Offset leftThumbOffset, Offset rightThumbOffset) = switch (textDirection) {
      TextDirection.ltr => (startThumbCenter, endThumbCenter),
      TextDirection.rtl => (endThumbCenter, startThumbCenter),
    };

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    final Rect leftTrackSegment = Rect.fromLTRB(trackRect.left, trackRect.top, leftThumbOffset.dx, trackRect.bottom);
    if (!leftTrackSegment.isEmpty) {
      context.canvas.drawRect(leftTrackSegment, inactivePaint);
    }
    final Rect middleTrackSegment = Rect.fromLTRB(
      leftThumbOffset.dx,
      trackRect.top,
      rightThumbOffset.dx,
      trackRect.bottom,
    );
    if (!middleTrackSegment.isEmpty) {
      context.canvas.drawRect(middleTrackSegment, activePaint);
    }
    final Rect rightTrackSegment = Rect.fromLTRB(rightThumbOffset.dx, trackRect.top, trackRect.right, trackRect.bottom);
    if (!rightTrackSegment.isEmpty) {
      context.canvas.drawRect(rightTrackSegment, inactivePaint);
    }
  }
}

class RoundedRectRangeSliderTrackShape extends RangeSliderTrackShape with BaseRangeSliderTrackShape {
  const RoundedRectRangeSliderTrackShape();

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset startThumbCenter,
    required Offset endThumbCenter,
    required TextDirection textDirection,
    bool isEnabled = false,
    bool isDiscrete = false,
    double additionalActiveTrackHeight = 2,
  }) {
    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.rangeThumbShape != null);

    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }

    // Assign the track segment paints, which are left: active, right: inactive,
    // but reversed for right to left text.
    final ColorTween activeTrackColorTween = ColorTween(
      begin: sliderTheme.disabledActiveTrackColor,
      end: sliderTheme.activeTrackColor,
    );
    final ColorTween inactiveTrackColorTween = ColorTween(
      begin: sliderTheme.disabledInactiveTrackColor,
      end: sliderTheme.inactiveTrackColor,
    );
    final Paint activePaint = Paint()..color = activeTrackColorTween.evaluate(enableAnimation)!;
    final Paint inactivePaint = Paint()..color = inactiveTrackColorTween.evaluate(enableAnimation)!;

    final (Offset leftThumbOffset, Offset rightThumbOffset) = switch (textDirection) {
      TextDirection.ltr => (startThumbCenter, endThumbCenter),
      TextDirection.rtl => (endThumbCenter, startThumbCenter),
    };
    final Size thumbSize = sliderTheme.rangeThumbShape!.getPreferredSize(isEnabled, isDiscrete);
    final double thumbRadius = thumbSize.width / 2;
    assert(thumbRadius > 0);

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final Radius trackRadius = Radius.circular(trackRect.height / 2);

    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        trackRect.left,
        trackRect.top,
        leftThumbOffset.dx,
        trackRect.bottom,
        topLeft: trackRadius,
        bottomLeft: trackRadius,
      ),
      inactivePaint,
    );
    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        rightThumbOffset.dx,
        trackRect.top,
        trackRect.right,
        trackRect.bottom,
        topRight: trackRadius,
        bottomRight: trackRadius,
      ),
      inactivePaint,
    );
    context.canvas.drawRRect(
      RRect.fromLTRBR(
        leftThumbOffset.dx - (sliderTheme.trackHeight! / 2),
        trackRect.top - (additionalActiveTrackHeight / 2),
        rightThumbOffset.dx + (sliderTheme.trackHeight! / 2),
        trackRect.bottom + (additionalActiveTrackHeight / 2),
        trackRadius,
      ),
      activePaint,
    );
  }

  @override
  bool get isRounded => true;
}

class RoundSliderTickMarkShape extends SliderTickMarkShape {
  const RoundSliderTickMarkShape({this.tickMarkRadius});

  final double? tickMarkRadius;

  @override
  Size getPreferredSize({required SliderThemeData sliderTheme, required bool isEnabled}) {
    assert(sliderTheme.trackHeight != null);
    // The tick marks are tiny circles. If no radius is provided, then the
    // radius is defaulted to be a fraction of the
    // [SliderThemeData.trackHeight]. The fraction is 1/4.
    return Size.fromRadius(tickMarkRadius ?? sliderTheme.trackHeight! / 4);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    required bool isEnabled,
  }) {
    assert(sliderTheme.disabledActiveTickMarkColor != null);
    assert(sliderTheme.disabledInactiveTickMarkColor != null);
    assert(sliderTheme.activeTickMarkColor != null);
    assert(sliderTheme.inactiveTickMarkColor != null);
    // The paint color of the tick mark depends on its position relative
    // to the thumb and the text direction.
    final double xOffset = center.dx - thumbCenter.dx;
    final (Color? begin, Color? end) = switch (textDirection) {
      TextDirection.ltr when xOffset > 0 => (
        sliderTheme.disabledInactiveTickMarkColor,
        sliderTheme.inactiveTickMarkColor,
      ),
      TextDirection.rtl when xOffset < 0 => (
        sliderTheme.disabledInactiveTickMarkColor,
        sliderTheme.inactiveTickMarkColor,
      ),
      TextDirection.ltr ||
      TextDirection.rtl => (sliderTheme.disabledActiveTickMarkColor, sliderTheme.activeTickMarkColor),
    };
    final Paint paint = Paint()..color = ColorTween(begin: begin, end: end).evaluate(enableAnimation)!;

    // The tick marks are tiny circles that are the same height as the track.
    final double tickMarkRadius = getPreferredSize(isEnabled: isEnabled, sliderTheme: sliderTheme).width / 2;
    if (tickMarkRadius > 0) {
      context.canvas.drawCircle(center, tickMarkRadius, paint);
    }
  }
}

class RoundRangeSliderTickMarkShape extends RangeSliderTickMarkShape {
  const RoundRangeSliderTickMarkShape({this.tickMarkRadius});

  final double? tickMarkRadius;

  @override
  Size getPreferredSize({required SliderThemeData sliderTheme, bool isEnabled = false}) {
    assert(sliderTheme.trackHeight != null);
    return Size.fromRadius(tickMarkRadius ?? sliderTheme.trackHeight! / 4);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset startThumbCenter,
    required Offset endThumbCenter,
    required TextDirection textDirection,
    bool isEnabled = false,
  }) {
    assert(sliderTheme.disabledActiveTickMarkColor != null);
    assert(sliderTheme.disabledInactiveTickMarkColor != null);
    assert(sliderTheme.activeTickMarkColor != null);
    assert(sliderTheme.inactiveTickMarkColor != null);

    final bool isBetweenThumbs = switch (textDirection) {
      TextDirection.ltr => startThumbCenter.dx < center.dx && center.dx < endThumbCenter.dx,
      TextDirection.rtl => endThumbCenter.dx < center.dx && center.dx < startThumbCenter.dx,
    };
    final Color? begin =
        isBetweenThumbs ? sliderTheme.disabledActiveTickMarkColor : sliderTheme.disabledInactiveTickMarkColor;
    final Color? end = isBetweenThumbs ? sliderTheme.activeTickMarkColor : sliderTheme.inactiveTickMarkColor;
    final Paint paint = Paint()..color = ColorTween(begin: begin, end: end).evaluate(enableAnimation)!;

    // The tick marks are tiny circles that are the same height as the track.
    final double tickMarkRadius = getPreferredSize(isEnabled: isEnabled, sliderTheme: sliderTheme).width / 2;
    if (tickMarkRadius > 0) {
      context.canvas.drawCircle(center, tickMarkRadius, paint);
    }
  }
}

class _EmptySliderTickMarkShape extends SliderTickMarkShape {
  @override
  Size getPreferredSize({required SliderThemeData sliderTheme, required bool isEnabled}) => Size.zero;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset thumbCenter,
    required bool isEnabled,
    required TextDirection textDirection,
  }) {
    // no-op.
  }
}

class _EmptySliderComponentShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.zero;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    // no-op.
  }
}

class RoundSliderThumbShape extends SliderComponentShape {
  const RoundSliderThumbShape({
    this.enabledThumbRadius = 10.0,
    this.disabledThumbRadius,
    this.elevation = 1.0,
    this.pressedElevation = 6.0,
  });

  final double enabledThumbRadius;

  final double? disabledThumbRadius;
  double get _disabledThumbRadius => disabledThumbRadius ?? enabledThumbRadius;

  final double elevation;

  final double pressedElevation;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      Size.fromRadius(isEnabled ? enabledThumbRadius : _disabledThumbRadius);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    assert(sliderTheme.disabledThumbColor != null);
    assert(sliderTheme.thumbColor != null);

    final Canvas canvas = context.canvas;
    final Tween<double> radiusTween = Tween<double>(begin: _disabledThumbRadius, end: enabledThumbRadius);
    final ColorTween colorTween = ColorTween(begin: sliderTheme.disabledThumbColor, end: sliderTheme.thumbColor);

    final Color color = colorTween.evaluate(enableAnimation)!;
    final double radius = radiusTween.evaluate(enableAnimation);

    final Tween<double> elevationTween = Tween<double>(begin: elevation, end: pressedElevation);

    final double evaluatedElevation = elevationTween.evaluate(activationAnimation);
    final Path path =
        Path()..addArc(Rect.fromCenter(center: center, width: 2 * radius, height: 2 * radius), 0, math.pi * 2);

    bool paintShadows = true;
    assert(() {
      if (debugDisableShadows) {
        _debugDrawShadow(canvas, path, evaluatedElevation);
        paintShadows = false;
      }
      return true;
    }());

    if (paintShadows) {
      canvas.drawShadow(path, Colors.black, evaluatedElevation, true);
    }

    canvas.drawCircle(center, radius, Paint()..color = color);
  }
}

class RoundRangeSliderThumbShape extends RangeSliderThumbShape {
  const RoundRangeSliderThumbShape({
    this.enabledThumbRadius = 10.0,
    this.disabledThumbRadius,
    this.elevation = 1.0,
    this.pressedElevation = 6.0,
  });

  final double enabledThumbRadius;

  final double? disabledThumbRadius;
  double get _disabledThumbRadius => disabledThumbRadius ?? enabledThumbRadius;

  final double elevation;

  final double pressedElevation;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      Size.fromRadius(isEnabled ? enabledThumbRadius : _disabledThumbRadius);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required SliderThemeData sliderTheme,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool? isOnTop,
    TextDirection? textDirection,
    Thumb? thumb,
    bool? isPressed,
  }) {
    assert(sliderTheme.showValueIndicator != null);
    assert(sliderTheme.overlappingShapeStrokeColor != null);
    final Canvas canvas = context.canvas;
    final Tween<double> radiusTween = Tween<double>(begin: _disabledThumbRadius, end: enabledThumbRadius);
    final ColorTween colorTween = ColorTween(begin: sliderTheme.disabledThumbColor, end: sliderTheme.thumbColor);
    final double radius = radiusTween.evaluate(enableAnimation);
    final Tween<double> elevationTween = Tween<double>(begin: elevation, end: pressedElevation);

    // Add a stroke of 1dp around the circle if this thumb would overlap
    // the other thumb.
    if (isOnTop ?? false) {
      final Paint strokePaint =
          Paint()
            ..color = sliderTheme.overlappingShapeStrokeColor!
            ..strokeWidth = 1.0
            ..style = PaintingStyle.stroke;
      canvas.drawCircle(center, radius, strokePaint);
    }

    final Color color = colorTween.evaluate(enableAnimation)!;

    final double evaluatedElevation = isPressed! ? elevationTween.evaluate(activationAnimation) : elevation;
    final Path shadowPath =
        Path()..addArc(Rect.fromCenter(center: center, width: 2 * radius, height: 2 * radius), 0, math.pi * 2);

    bool paintShadows = true;
    assert(() {
      if (debugDisableShadows) {
        _debugDrawShadow(canvas, shadowPath, evaluatedElevation);
        paintShadows = false;
      }
      return true;
    }());

    if (paintShadows) {
      canvas.drawShadow(shadowPath, Colors.black, evaluatedElevation, true);
    }

    canvas.drawCircle(center, radius, Paint()..color = color);
  }
}

class RoundSliderOverlayShape extends SliderComponentShape {
  const RoundSliderOverlayShape({this.overlayRadius = 24.0});

  final double overlayRadius;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.fromRadius(overlayRadius);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;
    final Tween<double> radiusTween = Tween<double>(begin: 0.0, end: overlayRadius);

    canvas.drawCircle(center, radiusTween.evaluate(activationAnimation), Paint()..color = sliderTheme.overlayColor!);
  }
}

class RectangularSliderValueIndicatorShape extends SliderComponentShape {
  const RectangularSliderValueIndicatorShape();

  static const _RectangularSliderValueIndicatorPathPainter _pathPainter = _RectangularSliderValueIndicatorPathPainter();

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete, {TextPainter? labelPainter, double? textScaleFactor}) {
    assert(labelPainter != null);
    assert(textScaleFactor != null && textScaleFactor >= 0);
    return _pathPainter.getPreferredSize(labelPainter!, textScaleFactor!);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;
    final double scale = activationAnimation.value;
    _pathPainter.paint(
      parentBox: parentBox,
      canvas: canvas,
      center: center,
      scale: scale,
      labelPainter: labelPainter,
      textScaleFactor: textScaleFactor,
      sizeWithOverflow: sizeWithOverflow,
      backgroundPaintColor: sliderTheme.valueIndicatorColor!,
      strokePaintColor: sliderTheme.valueIndicatorStrokeColor,
    );
  }
}

class RectangularRangeSliderValueIndicatorShape extends RangeSliderValueIndicatorShape {
  const RectangularRangeSliderValueIndicatorShape();

  static const _RectangularSliderValueIndicatorPathPainter _pathPainter = _RectangularSliderValueIndicatorPathPainter();

  @override
  Size getPreferredSize(
    bool isEnabled,
    bool isDiscrete, {
    required TextPainter labelPainter,
    required double textScaleFactor,
  }) {
    assert(textScaleFactor >= 0);
    return _pathPainter.getPreferredSize(labelPainter, textScaleFactor);
  }

  @override
  double getHorizontalShift({
    RenderBox? parentBox,
    Offset? center,
    TextPainter? labelPainter,
    Animation<double>? activationAnimation,
    double? textScaleFactor,
    Size? sizeWithOverflow,
  }) => _pathPainter.getHorizontalShift(
    parentBox: parentBox!,
    center: center!,
    labelPainter: labelPainter!,
    textScaleFactor: textScaleFactor!,
    sizeWithOverflow: sizeWithOverflow!,
    scale: activationAnimation!.value,
  );

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    Animation<double>? activationAnimation,
    Animation<double>? enableAnimation,
    bool? isDiscrete,
    bool? isOnTop,
    TextPainter? labelPainter,
    double? textScaleFactor,
    Size? sizeWithOverflow,
    RenderBox? parentBox,
    SliderThemeData? sliderTheme,
    TextDirection? textDirection,
    double? value,
    Thumb? thumb,
  }) {
    final Canvas canvas = context.canvas;
    final double scale = activationAnimation!.value;
    _pathPainter.paint(
      parentBox: parentBox!,
      canvas: canvas,
      center: center,
      scale: scale,
      labelPainter: labelPainter!,
      textScaleFactor: textScaleFactor!,
      sizeWithOverflow: sizeWithOverflow!,
      backgroundPaintColor: sliderTheme!.valueIndicatorColor!,
      strokePaintColor: isOnTop! ? sliderTheme.overlappingShapeStrokeColor : sliderTheme.valueIndicatorStrokeColor,
    );
  }
}

class _RectangularSliderValueIndicatorPathPainter {
  const _RectangularSliderValueIndicatorPathPainter();

  static const double _triangleHeight = 8.0;
  static const double _labelPadding = 16.0;
  static const double _preferredHeight = 32.0;
  static const double _minLabelWidth = 16.0;
  static const double _bottomTipYOffset = 14.0;
  static const double _preferredHalfHeight = _preferredHeight / 2;
  static const double _upperRectRadius = 4;

  Size getPreferredSize(TextPainter labelPainter, double textScaleFactor) =>
      Size(_upperRectangleWidth(labelPainter, 1, textScaleFactor), labelPainter.height + _labelPadding);

  double getHorizontalShift({
    required RenderBox parentBox,
    required Offset center,
    required TextPainter labelPainter,
    required double textScaleFactor,
    required Size sizeWithOverflow,
    required double scale,
  }) {
    assert(!sizeWithOverflow.isEmpty);

    const double edgePadding = 8.0;
    final double rectangleWidth = _upperRectangleWidth(labelPainter, scale, textScaleFactor);

    final Offset globalCenter = parentBox.localToGlobal(center);

    // The rectangle must be shifted towards the center so that it minimizes the
    // chance of it rendering outside the bounds of the render box. If the shift
    // is negative, then the lobe is shifted from right to left, and if it is
    // positive, then the lobe is shifted from left to right.
    final double overflowLeft = math.max(0, rectangleWidth / 2 - globalCenter.dx + edgePadding);
    final double overflowRight = math.max(
      0,
      rectangleWidth / 2 - (sizeWithOverflow.width - globalCenter.dx - edgePadding),
    );

    if (rectangleWidth < sizeWithOverflow.width) {
      return overflowLeft - overflowRight;
    } else if (overflowLeft - overflowRight > 0) {
      return overflowLeft - (edgePadding * textScaleFactor);
    } else {
      return -overflowRight + (edgePadding * textScaleFactor);
    }
  }

  double _upperRectangleWidth(TextPainter labelPainter, double scale, double textScaleFactor) {
    final double unscaledWidth = math.max(_minLabelWidth * textScaleFactor, labelPainter.width) + _labelPadding * 2;
    return unscaledWidth * scale;
  }

  void paint({
    required RenderBox parentBox,
    required Canvas canvas,
    required Offset center,
    required double scale,
    required TextPainter labelPainter,
    required double textScaleFactor,
    required Size sizeWithOverflow,
    required Color backgroundPaintColor,
    Color? strokePaintColor,
  }) {
    if (scale == 0.0) {
      // Zero scale essentially means "do not draw anything", so it's safe to just return.
      return;
    }
    assert(!sizeWithOverflow.isEmpty);

    final double rectangleWidth = _upperRectangleWidth(labelPainter, scale, textScaleFactor);
    final double horizontalShift = getHorizontalShift(
      parentBox: parentBox,
      center: center,
      labelPainter: labelPainter,
      textScaleFactor: textScaleFactor,
      sizeWithOverflow: sizeWithOverflow,
      scale: scale,
    );

    final double rectHeight = labelPainter.height + _labelPadding;
    final Rect upperRect = Rect.fromLTWH(
      -rectangleWidth / 2 + horizontalShift,
      -_triangleHeight - rectHeight,
      rectangleWidth,
      rectHeight,
    );

    final Path trianglePath =
        Path()
          ..lineTo(-_triangleHeight, -_triangleHeight)
          ..lineTo(_triangleHeight, -_triangleHeight)
          ..close();
    final Paint fillPaint = Paint()..color = backgroundPaintColor;
    final RRect upperRRect = RRect.fromRectAndRadius(upperRect, const Radius.circular(_upperRectRadius));
    trianglePath.addRRect(upperRRect);

    canvas.save();
    // Prepare the canvas for the base of the tooltip, which is relative to the
    // center of the thumb.
    canvas.translate(center.dx, center.dy - _bottomTipYOffset);
    canvas.scale(scale, scale);
    if (strokePaintColor != null) {
      final Paint strokePaint =
          Paint()
            ..color = strokePaintColor
            ..strokeWidth = 1.0
            ..style = PaintingStyle.stroke;
      canvas.drawPath(trianglePath, strokePaint);
    }
    canvas.drawPath(trianglePath, fillPaint);

    // The label text is centered within the value indicator.
    final double bottomTipToUpperRectTranslateY = -_preferredHalfHeight / 2 - upperRect.height;
    canvas.translate(0, bottomTipToUpperRectTranslateY);
    final Offset boxCenter = Offset(horizontalShift, upperRect.height / 2);
    final Offset halfLabelPainterOffset = Offset(labelPainter.width / 2, labelPainter.height / 2);
    final Offset labelOffset = boxCenter - halfLabelPainterOffset;
    labelPainter.paint(canvas, labelOffset);
    canvas.restore();
  }
}

class PaddleSliderValueIndicatorShape extends SliderComponentShape {
  const PaddleSliderValueIndicatorShape();

  static const _PaddleSliderValueIndicatorPathPainter _pathPainter = _PaddleSliderValueIndicatorPathPainter();

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete, {TextPainter? labelPainter, double? textScaleFactor}) {
    assert(labelPainter != null);
    assert(textScaleFactor != null && textScaleFactor >= 0);
    return _pathPainter.getPreferredSize(labelPainter!, textScaleFactor!);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    assert(!sizeWithOverflow.isEmpty);
    final ColorTween enableColor = ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.valueIndicatorColor,
    );
    _pathPainter.paint(
      context.canvas,
      center,
      Paint()..color = enableColor.evaluate(enableAnimation)!,
      activationAnimation.value,
      labelPainter,
      textScaleFactor,
      sizeWithOverflow,
      sliderTheme.valueIndicatorStrokeColor,
    );
  }
}

class PaddleRangeSliderValueIndicatorShape extends RangeSliderValueIndicatorShape {
  const PaddleRangeSliderValueIndicatorShape();

  static const _PaddleSliderValueIndicatorPathPainter _pathPainter = _PaddleSliderValueIndicatorPathPainter();

  @override
  Size getPreferredSize(
    bool isEnabled,
    bool isDiscrete, {
    required TextPainter labelPainter,
    required double textScaleFactor,
  }) {
    assert(textScaleFactor >= 0);
    return _pathPainter.getPreferredSize(labelPainter, textScaleFactor);
  }

  @override
  double getHorizontalShift({
    RenderBox? parentBox,
    Offset? center,
    TextPainter? labelPainter,
    Animation<double>? activationAnimation,
    double? textScaleFactor,
    Size? sizeWithOverflow,
  }) => _pathPainter.getHorizontalShift(
    center: center!,
    labelPainter: labelPainter!,
    scale: activationAnimation!.value,
    textScaleFactor: textScaleFactor!,
    sizeWithOverflow: sizeWithOverflow!,
  );

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    bool? isDiscrete,
    bool isOnTop = false,
    TextDirection? textDirection,
    Thumb? thumb,
    double? value,
    double? textScaleFactor,
    Size? sizeWithOverflow,
  }) {
    assert(!sizeWithOverflow!.isEmpty);
    final ColorTween enableColor = ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.valueIndicatorColor,
    );
    // Add a stroke of 1dp around the top paddle.
    _pathPainter.paint(
      context.canvas,
      center,
      Paint()..color = enableColor.evaluate(enableAnimation)!,
      activationAnimation.value,
      labelPainter,
      textScaleFactor!,
      sizeWithOverflow!,
      isOnTop ? sliderTheme.overlappingShapeStrokeColor : sliderTheme.valueIndicatorStrokeColor,
    );
  }
}

class _PaddleSliderValueIndicatorPathPainter {
  const _PaddleSliderValueIndicatorPathPainter();

  // These constants define the shape of the default value indicator.
  // The value indicator changes shape based on the size of
  // the label: The top lobe spreads horizontally, and the
  // top arc on the neck moves down to keep it merging smoothly
  // with the top lobe as it expands.

  // Radius of the top lobe of the value indicator.
  static const double _topLobeRadius = 16.0;
  static const double _minLabelWidth = 16.0;
  // Radius of the bottom lobe of the value indicator.
  static const double _bottomLobeRadius = 10.0;
  static const double _labelPadding = 8.0;
  static const double _distanceBetweenTopBottomCenters = 40.0;
  static const double _middleNeckWidth = 3.0;
  static const double _bottomNeckRadius = 4.5;
  // The base of the triangle between the top lobe center and the centers of
  // the two top neck arcs.
  static const double _neckTriangleBase = _topNeckRadius + _middleNeckWidth / 2;
  static const double _rightBottomNeckCenterX = _middleNeckWidth / 2 + _bottomNeckRadius;
  static const double _rightBottomNeckAngleStart = math.pi;
  static const Offset _topLobeCenter = Offset(0.0, -_distanceBetweenTopBottomCenters);
  static const double _topNeckRadius = 13.0;
  // The length of the hypotenuse of the triangle formed by the center
  // of the left top lobe arc and the center of the top left neck arc.
  // Used to calculate the position of the center of the arc.
  static const double _neckTriangleHypotenuse = _topLobeRadius + _topNeckRadius;
  // Some convenience values to help readability.
  static const double _twoSeventyDegrees = 3.0 * math.pi / 2.0;
  static const double _ninetyDegrees = math.pi / 2.0;
  static const double _thirtyDegrees = math.pi / 6.0;
  static const double _preferredHeight = _distanceBetweenTopBottomCenters + _topLobeRadius + _bottomLobeRadius;
  // Set to true if you want a rectangle to be drawn around the label bubble.
  // This helps with building tests that check that the label draws in the right
  // place (because it prints the rect in the failed test output). It should not
  // be checked in while set to "true".
  static const bool _debuggingLabelLocation = false;

  Size getPreferredSize(TextPainter labelPainter, double textScaleFactor) {
    assert(textScaleFactor >= 0);
    final double width =
        math.max(_minLabelWidth * textScaleFactor, labelPainter.width) + _labelPadding * 2 * textScaleFactor;
    return Size(width, _preferredHeight * textScaleFactor);
  }

  // Adds an arc to the path that has the attributes passed in. This is
  // a convenience to make adding arcs have less boilerplate.
  static void _addArc(Path path, Offset center, double radius, double startAngle, double endAngle) {
    assert(center.isFinite);
    final Rect arcRect = Rect.fromCircle(center: center, radius: radius);
    path.arcTo(arcRect, startAngle, endAngle - startAngle, false);
  }

  double getHorizontalShift({
    required Offset center,
    required TextPainter labelPainter,
    required double scale,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    assert(!sizeWithOverflow.isEmpty);
    final double inverseTextScale = textScaleFactor != 0 ? 1.0 / textScaleFactor : 0.0;
    final double labelHalfWidth = labelPainter.width / 2.0;
    final double halfWidthNeeded = math.max(0.0, inverseTextScale * labelHalfWidth - (_topLobeRadius - _labelPadding));
    final double shift = _getIdealOffset(halfWidthNeeded, textScaleFactor * scale, center, sizeWithOverflow.width);
    return shift * textScaleFactor;
  }

  // Determines the "best" offset to keep the bubble within the slider. The
  // calling code will bound that with the available movement in the paddle shape.
  double _getIdealOffset(double halfWidthNeeded, double scale, Offset center, double widthWithOverflow) {
    const double edgeMargin = 8.0;
    final Rect topLobeRect = Rect.fromLTWH(
      -_topLobeRadius - halfWidthNeeded,
      -_topLobeRadius - _distanceBetweenTopBottomCenters,
      2.0 * (_topLobeRadius + halfWidthNeeded),
      2.0 * _topLobeRadius,
    );
    // We can just multiply by scale instead of a transform, since we're scaling
    // around (0, 0).
    final Offset topLeft = (topLobeRect.topLeft * scale) + center;
    final Offset bottomRight = (topLobeRect.bottomRight * scale) + center;
    double shift = 0.0;

    if (topLeft.dx < edgeMargin) {
      shift = edgeMargin - topLeft.dx;
    }

    final double endGlobal = widthWithOverflow;
    if (bottomRight.dx > endGlobal - edgeMargin) {
      shift = endGlobal - edgeMargin - bottomRight.dx;
    }

    shift = scale == 0.0 ? 0.0 : shift / scale;
    if (shift < 0.0) {
      // Shifting to the left.
      shift = math.max(shift, -halfWidthNeeded);
    } else {
      // Shifting to the right.
      shift = math.min(shift, halfWidthNeeded);
    }
    return shift;
  }

  void paint(
    Canvas canvas,
    Offset center,
    Paint paint,
    double scale,
    TextPainter labelPainter,
    double textScaleFactor,
    Size sizeWithOverflow,
    Color? strokePaintColor,
  ) {
    if (scale == 0.0) {
      // Zero scale essentially means "do not draw anything", so it's safe to just return. Otherwise,
      // our math below will attempt to divide by zero and send needless NaNs to the engine.
      return;
    }
    assert(!sizeWithOverflow.isEmpty);

    // The entire value indicator should scale with the size of the label,
    // to keep it large enough to encompass the label text.
    final double overallScale = scale * textScaleFactor;
    final double inverseTextScale = textScaleFactor != 0 ? 1.0 / textScaleFactor : 0.0;
    final double labelHalfWidth = labelPainter.width / 2.0;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(overallScale, overallScale);

    final double bottomNeckTriangleHypotenuse = _bottomNeckRadius + _bottomLobeRadius / overallScale;
    final double rightBottomNeckCenterY =
        -math.sqrt(math.pow(bottomNeckTriangleHypotenuse, 2) - math.pow(_rightBottomNeckCenterX, 2));
    final double rightBottomNeckAngleEnd = math.pi + math.atan(rightBottomNeckCenterY / _rightBottomNeckCenterX);
    final Path path = Path()..moveTo(_middleNeckWidth / 2, rightBottomNeckCenterY);
    _addArc(
      path,
      Offset(_rightBottomNeckCenterX, rightBottomNeckCenterY),
      _bottomNeckRadius,
      _rightBottomNeckAngleStart,
      rightBottomNeckAngleEnd,
    );
    _addArc(
      path,
      Offset.zero,
      _bottomLobeRadius / overallScale,
      rightBottomNeckAngleEnd - math.pi,
      2 * math.pi - rightBottomNeckAngleEnd,
    );
    _addArc(
      path,
      Offset(-_rightBottomNeckCenterX, rightBottomNeckCenterY),
      _bottomNeckRadius,
      math.pi - rightBottomNeckAngleEnd,
      0,
    );

    // This is the needed extra width for the label. It is only positive when
    // the label exceeds the minimum size contained by the round top lobe.
    final double halfWidthNeeded = math.max(0.0, inverseTextScale * labelHalfWidth - (_topLobeRadius - _labelPadding));

    final double shift = _getIdealOffset(halfWidthNeeded, overallScale, center, sizeWithOverflow.width);
    final double leftWidthNeeded = halfWidthNeeded - shift;
    final double rightWidthNeeded = halfWidthNeeded + shift;

    // The parameter that describes how far along the transition from round to
    // stretched we are.
    final double leftAmount = math.max(0.0, math.min(1.0, leftWidthNeeded / _neckTriangleBase));
    final double rightAmount = math.max(0.0, math.min(1.0, rightWidthNeeded / _neckTriangleBase));
    // The angle between the top neck arc's center and the top lobe's center
    // and vertical. The base amount is chosen so that the neck is smooth,
    // even when the lobe is shifted due to its size.
    final double leftTheta = (1.0 - leftAmount) * _thirtyDegrees;
    final double rightTheta = (1.0 - rightAmount) * _thirtyDegrees;
    // The center of the top left neck arc.
    final Offset leftTopNeckCenter = Offset(
      -_neckTriangleBase,
      _topLobeCenter.dy + math.cos(leftTheta) * _neckTriangleHypotenuse,
    );
    final Offset neckRightCenter = Offset(
      _neckTriangleBase,
      _topLobeCenter.dy + math.cos(rightTheta) * _neckTriangleHypotenuse,
    );
    final double leftNeckArcAngle = _ninetyDegrees - leftTheta;
    final double rightNeckArcAngle = math.pi + _ninetyDegrees - rightTheta;
    // The distance between the end of the bottom neck arc and the beginning of
    // the top neck arc. We use this to shrink/expand it based on the scale
    // factor of the value indicator.
    final double neckStretchBaseline = math.max(
      0.0,
      rightBottomNeckCenterY - math.max(leftTopNeckCenter.dy, neckRightCenter.dy),
    );
    final double t = math.pow(inverseTextScale, 3.0) as double;
    final double stretch = clampDouble(neckStretchBaseline * t, 0.0, 10.0 * neckStretchBaseline);
    final Offset neckStretch = Offset(0.0, neckStretchBaseline - stretch);

    assert(
      !_debuggingLabelLocation ||
          () {
            final Offset leftCenter = _topLobeCenter - Offset(leftWidthNeeded, 0.0) + neckStretch;
            final Offset rightCenter = _topLobeCenter + Offset(rightWidthNeeded, 0.0) + neckStretch;
            final Rect valueRect = Rect.fromLTRB(
              leftCenter.dx - _topLobeRadius,
              leftCenter.dy - _topLobeRadius,
              rightCenter.dx + _topLobeRadius,
              rightCenter.dy + _topLobeRadius,
            );
            final Paint outlinePaint =
                Paint()
                  ..color = const Color(0xffff0000)
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 1.0;
            canvas.drawRect(valueRect, outlinePaint);
            return true;
          }(),
    );

    _addArc(path, leftTopNeckCenter + neckStretch, _topNeckRadius, 0.0, -leftNeckArcAngle);
    _addArc(
      path,
      _topLobeCenter - Offset(leftWidthNeeded, 0.0) + neckStretch,
      _topLobeRadius,
      _ninetyDegrees + leftTheta,
      _twoSeventyDegrees,
    );
    _addArc(
      path,
      _topLobeCenter + Offset(rightWidthNeeded, 0.0) + neckStretch,
      _topLobeRadius,
      _twoSeventyDegrees,
      _twoSeventyDegrees + math.pi - rightTheta,
    );
    _addArc(path, neckRightCenter + neckStretch, _topNeckRadius, rightNeckArcAngle, math.pi);

    if (strokePaintColor != null) {
      final Paint strokePaint =
          Paint()
            ..color = strokePaintColor
            ..strokeWidth = 1.0
            ..style = PaintingStyle.stroke;
      canvas.drawPath(path, strokePaint);
    }

    canvas.drawPath(path, paint);

    // Draw the label.
    canvas.save();
    canvas.translate(shift, -_distanceBetweenTopBottomCenters + neckStretch.dy);
    canvas.scale(inverseTextScale, inverseTextScale);
    labelPainter.paint(canvas, Offset.zero - Offset(labelHalfWidth, labelPainter.height / 2.0));
    canvas.restore();
    canvas.restore();
  }
}

typedef SemanticFormatterCallback = String Function(double value);

typedef RangeThumbSelector =
    Thumb? Function(
      TextDirection textDirection,
      RangeValues values,
      double tapValue,
      Size thumbSize,
      Size trackSize,
      double dx,
    );

@immutable
class RangeValues {
  const RangeValues(this.start, this.end);

  final double start;

  final double end;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is RangeValues && other.start == start && other.end == end;
  }

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => '${objectRuntimeType(this, 'RangeValues')}($start, $end)';
}

@immutable
class RangeLabels {
  const RangeLabels(this.start, this.end);

  final String start;

  final String end;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is RangeLabels && other.start == start && other.end == end;
  }

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => '${objectRuntimeType(this, 'RangeLabels')}($start, $end)';
}

void _debugDrawShadow(Canvas canvas, Path path, double elevation) {
  if (elevation > 0.0) {
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = elevation * 2.0,
    );
  }
}

class DropSliderValueIndicatorShape extends SliderComponentShape {
  const DropSliderValueIndicatorShape();

  static const _DropSliderValueIndicatorPathPainter _pathPainter = _DropSliderValueIndicatorPathPainter();

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete, {TextPainter? labelPainter, double? textScaleFactor}) {
    assert(labelPainter != null);
    assert(textScaleFactor != null && textScaleFactor >= 0);
    return _pathPainter.getPreferredSize(labelPainter!, textScaleFactor!);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;
    final double scale = activationAnimation.value;
    _pathPainter.paint(
      parentBox: parentBox,
      canvas: canvas,
      center: center,
      scale: scale,
      labelPainter: labelPainter,
      textScaleFactor: textScaleFactor,
      sizeWithOverflow: sizeWithOverflow,
      backgroundPaintColor: sliderTheme.valueIndicatorColor!,
      strokePaintColor: sliderTheme.valueIndicatorStrokeColor,
    );
  }
}

class _DropSliderValueIndicatorPathPainter {
  const _DropSliderValueIndicatorPathPainter();

  static const double _triangleHeight = 10.0;
  static const double _labelPadding = 8.0;
  static const double _preferredHeight = 32.0;
  static const double _minLabelWidth = 20.0;
  static const double _minRectHeight = 28.0;
  static const double _rectYOffset = 6.0;
  static const double _bottomTipYOffset = 16.0;
  static const double _preferredHalfHeight = _preferredHeight / 2;
  static const double _upperRectRadius = 4;

  Size getPreferredSize(TextPainter labelPainter, double textScaleFactor) {
    final double width = math.max(_minLabelWidth, labelPainter.width) + _labelPadding * 2 * textScaleFactor;
    return Size(width, _preferredHeight * textScaleFactor);
  }

  double getHorizontalShift({
    required RenderBox parentBox,
    required Offset center,
    required TextPainter labelPainter,
    required double textScaleFactor,
    required Size sizeWithOverflow,
    required double scale,
  }) {
    assert(!sizeWithOverflow.isEmpty);

    const double edgePadding = 8.0;
    final double rectangleWidth = _upperRectangleWidth(labelPainter, scale);

    final Offset globalCenter = parentBox.localToGlobal(center);

    // The rectangle must be shifted towards the center so that it minimizes the
    // chance of it rendering outside the bounds of the render box. If the shift
    // is negative, then the lobe is shifted from right to left, and if it is
    // positive, then the lobe is shifted from left to right.
    final double overflowLeft = math.max(0, rectangleWidth / 2 - globalCenter.dx + edgePadding);
    final double overflowRight = math.max(
      0,
      rectangleWidth / 2 - (sizeWithOverflow.width - globalCenter.dx - edgePadding),
    );

    if (rectangleWidth < sizeWithOverflow.width) {
      return overflowLeft - overflowRight;
    } else if (overflowLeft - overflowRight > 0) {
      return overflowLeft - (edgePadding * textScaleFactor);
    } else {
      return -overflowRight + (edgePadding * textScaleFactor);
    }
  }

  double _upperRectangleWidth(TextPainter labelPainter, double scale) {
    final double unscaledWidth = math.max(_minLabelWidth, labelPainter.width) + _labelPadding;
    return unscaledWidth * scale;
  }

  BorderRadius _adjustBorderRadius(Rect rect) {
    const double rectness = 0.0;
    return BorderRadius.lerp(
      BorderRadius.circular(_upperRectRadius),
      BorderRadius.all(Radius.circular(rect.shortestSide / 2.0)),
      1.0 - rectness,
    )!;
  }

  void paint({
    required RenderBox parentBox,
    required Canvas canvas,
    required Offset center,
    required double scale,
    required TextPainter labelPainter,
    required double textScaleFactor,
    required Size sizeWithOverflow,
    required Color backgroundPaintColor,
    Color? strokePaintColor,
  }) {
    if (scale == 0.0) {
      // Zero scale essentially means "do not draw anything", so it's safe to just return.
      return;
    }
    assert(!sizeWithOverflow.isEmpty);
    final double rectangleWidth = _upperRectangleWidth(labelPainter, scale);
    final double horizontalShift = getHorizontalShift(
      parentBox: parentBox,
      center: center,
      labelPainter: labelPainter,
      textScaleFactor: textScaleFactor,
      sizeWithOverflow: sizeWithOverflow,
      scale: scale,
    );
    final Rect upperRect = Rect.fromLTWH(
      -rectangleWidth / 2 + horizontalShift,
      -_rectYOffset - _minRectHeight,
      rectangleWidth,
      _minRectHeight,
    );

    final Paint fillPaint = Paint()..color = backgroundPaintColor;

    canvas.save();
    canvas.translate(center.dx, center.dy - _bottomTipYOffset);
    canvas.scale(scale, scale);

    final BorderRadius adjustedBorderRadius = _adjustBorderRadius(upperRect);
    final RRect borderRect = adjustedBorderRadius.resolve(labelPainter.textDirection).toRRect(upperRect);
    final Path trianglePath =
        Path()
          ..lineTo(-_triangleHeight, -_triangleHeight)
          ..lineTo(_triangleHeight, -_triangleHeight)
          ..close();
    trianglePath.addRRect(borderRect);

    if (strokePaintColor != null) {
      final Paint strokePaint =
          Paint()
            ..color = strokePaintColor
            ..strokeWidth = 1.0
            ..style = PaintingStyle.stroke;
      canvas.drawPath(trianglePath, strokePaint);
    }

    canvas.drawPath(trianglePath, fillPaint);

    // The label text is centered within the value indicator.
    final double bottomTipToUpperRectTranslateY = -_preferredHalfHeight / 2 - upperRect.height;
    canvas.translate(0, bottomTipToUpperRectTranslateY);
    final Offset boxCenter = Offset(horizontalShift, upperRect.height / 1.75);
    final Offset halfLabelPainterOffset = Offset(labelPainter.width / 2, labelPainter.height / 2);
    final Offset labelOffset = boxCenter - halfLabelPainterOffset;
    labelPainter.paint(canvas, labelOffset);
    canvas.restore();
  }
}

class HandleThumbShape extends SliderComponentShape {
  const HandleThumbShape();

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => const Size(4.0, 44.0);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    assert(sliderTheme.disabledThumbColor != null);
    assert(sliderTheme.thumbColor != null);
    assert(sliderTheme.thumbSize != null);

    final ColorTween colorTween = ColorTween(begin: sliderTheme.disabledThumbColor, end: sliderTheme.thumbColor);
    final Color color = colorTween.evaluate(enableAnimation)!;

    final Canvas canvas = context.canvas;
    final Size thumbSize = sliderTheme.thumbSize!.resolve(<WidgetState>{})!; // This is resolved in the paint method.
    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: thumbSize.width, height: thumbSize.height),
      Radius.circular(thumbSize.shortestSide / 2),
    );
    canvas.drawRRect(rrect, Paint()..color = color);
  }
}

class GappedSliderTrackShape extends SliderTrackShape with BaseSliderTrackShape {
  const GappedSliderTrackShape();

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 2,
  }) {
    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.thumbShape != null);
    assert(sliderTheme.trackGap != null);
    assert(!sliderTheme.trackGap!.isNegative);
    // If the slider [SliderThemeData.trackHeight] is less than or equal to 0,
    // then it makes no difference whether the track is painted or not,
    // therefore the painting can be a no-op.
    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }

    // Assign the track segment paints, which are left: active, right: inactive,
    // but reversed for right to left text.
    final ColorTween activeTrackColorTween = ColorTween(
      begin: sliderTheme.disabledActiveTrackColor,
      end: sliderTheme.activeTrackColor,
    );
    final ColorTween inactiveTrackColorTween = ColorTween(
      begin: sliderTheme.disabledInactiveTrackColor,
      end: sliderTheme.inactiveTrackColor,
    );
    final Paint activePaint = Paint()..color = activeTrackColorTween.evaluate(enableAnimation)!;
    final Paint inactivePaint = Paint()..color = inactiveTrackColorTween.evaluate(enableAnimation)!;
    final Paint leftTrackPaint;
    final Paint rightTrackPaint;
    switch (textDirection) {
      case TextDirection.ltr:
        leftTrackPaint = activePaint;
        rightTrackPaint = inactivePaint;
      case TextDirection.rtl:
        leftTrackPaint = inactivePaint;
        rightTrackPaint = activePaint;
    }

    // Gap, starting from the middle of the thumb.
    final double trackGap = sliderTheme.trackGap!;

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final Radius trackCornerRadius = Radius.circular(trackRect.shortestSide / 2);
    const Radius trackInsideCornerRadius = Radius.circular(2.0);

    final RRect trackRRect = RRect.fromRectAndCorners(
      trackRect,
      topLeft: trackCornerRadius,
      bottomLeft: trackCornerRadius,
      topRight: trackCornerRadius,
      bottomRight: trackCornerRadius,
    );

    final RRect leftRRect = RRect.fromLTRBAndCorners(
      trackRect.left,
      trackRect.top,
      math.max(trackRect.left, thumbCenter.dx - trackGap),
      trackRect.bottom,
      topLeft: trackCornerRadius,
      bottomLeft: trackCornerRadius,
      topRight: trackInsideCornerRadius,
      bottomRight: trackInsideCornerRadius,
    );

    final RRect rightRRect = RRect.fromLTRBAndCorners(
      thumbCenter.dx + trackGap,
      trackRect.top,
      trackRect.right,
      trackRect.bottom,
      topRight: trackCornerRadius,
      bottomRight: trackCornerRadius,
      topLeft: trackInsideCornerRadius,
      bottomLeft: trackInsideCornerRadius,
    );

    context.canvas
      ..save()
      ..clipRRect(trackRRect);
    final bool drawLeftTrack = thumbCenter.dx > (leftRRect.left + (sliderTheme.trackHeight! / 2));
    final bool drawRightTrack = thumbCenter.dx < (rightRRect.right - (sliderTheme.trackHeight! / 2));
    if (drawLeftTrack) {
      context.canvas.drawRRect(leftRRect, leftTrackPaint);
    }
    if (drawRightTrack) {
      context.canvas.drawRRect(rightRRect, rightTrackPaint);
    }

    final bool isLTR = textDirection == TextDirection.ltr;
    final bool showSecondaryTrack =
        (secondaryOffset != null) &&
        switch (isLTR) {
          true => secondaryOffset.dx > thumbCenter.dx + trackGap,
          false => secondaryOffset.dx < thumbCenter.dx - trackGap,
        };

    if (showSecondaryTrack) {
      final ColorTween secondaryTrackColorTween = ColorTween(
        begin: sliderTheme.disabledSecondaryActiveTrackColor,
        end: sliderTheme.secondaryActiveTrackColor,
      );
      final Paint secondaryTrackPaint = Paint()..color = secondaryTrackColorTween.evaluate(enableAnimation)!;
      if (isLTR) {
        context.canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            thumbCenter.dx + trackGap,
            trackRect.top,
            secondaryOffset.dx,
            trackRect.bottom,
            topLeft: trackInsideCornerRadius,
            bottomLeft: trackInsideCornerRadius,
            topRight: trackCornerRadius,
            bottomRight: trackCornerRadius,
          ),
          secondaryTrackPaint,
        );
      } else {
        context.canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            secondaryOffset.dx - trackGap,
            trackRect.top,
            thumbCenter.dx,
            trackRect.bottom,
            topLeft: trackInsideCornerRadius,
            bottomLeft: trackInsideCornerRadius,
            topRight: trackCornerRadius,
            bottomRight: trackCornerRadius,
          ),
          secondaryTrackPaint,
        );
      }
    }
    context.canvas.restore();

    const double stopIndicatorRadius = 2.0;
    final double stopIndicatorTrailingSpace = sliderTheme.trackHeight! / 2;
    final Offset stopIndicatorOffset = Offset(
      (textDirection == TextDirection.ltr)
          ? trackRect.centerRight.dx - stopIndicatorTrailingSpace
          : trackRect.centerLeft.dx + stopIndicatorTrailingSpace,
      trackRect.center.dy,
    );

    final bool showStopIndicator =
        (textDirection == TextDirection.ltr)
            ? thumbCenter.dx < stopIndicatorOffset.dx
            : thumbCenter.dx > stopIndicatorOffset.dx;
    if (showStopIndicator && !isDiscrete) {
      final Rect stopIndicatorRect = Rect.fromCircle(center: stopIndicatorOffset, radius: stopIndicatorRadius);
      context.canvas.drawCircle(stopIndicatorRect.center, stopIndicatorRadius, activePaint);
    }
  }

  @override
  bool get isRounded => true;
}

class RoundedRectSliderValueIndicatorShape extends SliderComponentShape {
  const RoundedRectSliderValueIndicatorShape();

  static const _RoundedRectSliderValueIndicatorPathPainter _pathPainter = _RoundedRectSliderValueIndicatorPathPainter();

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete, {TextPainter? labelPainter, double? textScaleFactor}) {
    assert(labelPainter != null);
    assert(textScaleFactor != null && textScaleFactor >= 0);
    return _pathPainter.getPreferredSize(labelPainter!, textScaleFactor!);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;
    final double scale = activationAnimation.value;
    _pathPainter.paint(
      parentBox: parentBox,
      canvas: canvas,
      center: center,
      scale: scale,
      labelPainter: labelPainter,
      textScaleFactor: textScaleFactor,
      sizeWithOverflow: sizeWithOverflow,
      backgroundPaintColor: sliderTheme.valueIndicatorColor!,
      strokePaintColor: sliderTheme.valueIndicatorStrokeColor,
    );
  }
}

class _RoundedRectSliderValueIndicatorPathPainter {
  const _RoundedRectSliderValueIndicatorPathPainter();

  static const double _labelPadding = 10.0;
  static const double _preferredHeight = 32.0;
  static const double _minLabelWidth = 16.0;
  static const double _rectYOffset = 10.0;
  static const double _bottomTipYOffset = 16.0;
  static const double _preferredHalfHeight = _preferredHeight / 2;

  Size getPreferredSize(TextPainter labelPainter, double textScaleFactor) {
    final double width = math.max(_minLabelWidth, labelPainter.width) + (_labelPadding * 2) * textScaleFactor;
    return Size(width, _preferredHeight * textScaleFactor);
  }

  double getHorizontalShift({
    required RenderBox parentBox,
    required Offset center,
    required TextPainter labelPainter,
    required double textScaleFactor,
    required Size sizeWithOverflow,
    required double scale,
  }) {
    assert(!sizeWithOverflow.isEmpty);

    const double edgePadding = 8.0;
    final double rectangleWidth = _upperRectangleWidth(labelPainter, scale);

    final Offset globalCenter = parentBox.localToGlobal(center);

    // The rectangle must be shifted towards the center so that it minimizes the
    // chance of it rendering outside the bounds of the render box. If the shift
    // is negative, then the lobe is shifted from right to left, and if it is
    // positive, then the lobe is shifted from left to right.
    final double overflowLeft = math.max(0, rectangleWidth / 2 - globalCenter.dx + edgePadding);
    final double overflowRight = math.max(
      0,
      rectangleWidth / 2 - (sizeWithOverflow.width - globalCenter.dx - edgePadding),
    );

    if (rectangleWidth < sizeWithOverflow.width) {
      return overflowLeft - overflowRight;
    } else if (overflowLeft - overflowRight > 0) {
      return overflowLeft - (edgePadding * textScaleFactor);
    } else {
      return -overflowRight + (edgePadding * textScaleFactor);
    }
  }

  double _upperRectangleWidth(TextPainter labelPainter, double scale) {
    final double unscaledWidth = math.max(_minLabelWidth, labelPainter.width) + (_labelPadding * 2);
    return unscaledWidth * scale;
  }

  void paint({
    required RenderBox parentBox,
    required Canvas canvas,
    required Offset center,
    required double scale,
    required TextPainter labelPainter,
    required double textScaleFactor,
    required Size sizeWithOverflow,
    required Color backgroundPaintColor,
    Color? strokePaintColor,
  }) {
    if (scale == 0.0) {
      // Zero scale essentially means "do not draw anything", so it's safe to just return.
      return;
    }
    assert(!sizeWithOverflow.isEmpty);

    final double rectangleWidth = _upperRectangleWidth(labelPainter, scale);
    final double horizontalShift = getHorizontalShift(
      parentBox: parentBox,
      center: center,
      labelPainter: labelPainter,
      textScaleFactor: textScaleFactor,
      sizeWithOverflow: sizeWithOverflow,
      scale: scale,
    );

    final Rect upperRect = Rect.fromLTWH(
      -rectangleWidth / 2 + horizontalShift,
      -_rectYOffset - _preferredHeight,
      rectangleWidth,
      _preferredHeight,
    );

    final Paint fillPaint = Paint()..color = backgroundPaintColor;

    canvas.save();
    // Prepare the canvas for the base of the tooltip, which is relative to the
    // center of the thumb.
    canvas.translate(center.dx, center.dy - _bottomTipYOffset);
    canvas.scale(scale, scale);

    final RRect rrect = RRect.fromRectAndRadius(upperRect, Radius.circular(upperRect.height / 2));
    if (strokePaintColor != null) {
      final Paint strokePaint =
          Paint()
            ..color = strokePaintColor
            ..strokeWidth = 1.0
            ..style = PaintingStyle.stroke;
      canvas.drawRRect(rrect, strokePaint);
    }

    canvas.drawRRect(rrect, fillPaint);

    // The label text is centered within the value indicator.
    final double bottomTipToUpperRectTranslateY = -_preferredHalfHeight / 2 - upperRect.height;
    canvas.translate(0, bottomTipToUpperRectTranslateY);
    final Offset boxCenter = Offset(horizontalShift, upperRect.height / 2.3);
    final Offset halfLabelPainterOffset = Offset(labelPainter.width / 2, labelPainter.height / 2);
    final Offset labelOffset = boxCenter - halfLabelPainterOffset;
    labelPainter.paint(canvas, labelOffset);
    canvas.restore();
  }
}
