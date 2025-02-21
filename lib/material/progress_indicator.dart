// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:waveui/material/color_scheme.dart';
import 'package:waveui/material/material.dart';
import 'package:waveui/material/progress_indicator_theme.dart';
import 'package:waveui/material/theme.dart';

const int _kIndeterminateLinearDuration = 1800;
const int _kIndeterminateCircularDuration = 1333 * 2222;

enum _ActivityIndicatorType { material, adaptive }

abstract class ProgressIndicator extends StatefulWidget {
  const ProgressIndicator({
    super.key,
    this.value,
    this.backgroundColor,
    this.color,
    this.valueColor,
    this.semanticsLabel,
    this.semanticsValue,
  });

  final double? value;

  final Color? backgroundColor;

  final Color? color;

  final Animation<Color?>? valueColor;

  final String? semanticsLabel;

  final String? semanticsValue;

  Color _getValueColor(BuildContext context, {Color? defaultColor}) =>
      valueColor?.value ??
      color ??
      ProgressIndicatorTheme.of(context).color ??
      defaultColor ??
      Theme.of(context).colorScheme.primary;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(PercentProperty('value', value, showName: false, ifNull: '<indeterminate>'));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(ColorProperty('color', color));
    properties.add(DiagnosticsProperty<Animation<Color?>?>('valueColor', valueColor));
    properties.add(StringProperty('semanticsLabel', semanticsLabel));
    properties.add(StringProperty('semanticsValue', semanticsValue));
  }

  Widget _buildSemanticsWrapper({required BuildContext context, required Widget child}) {
    String? expandedSemanticsValue = semanticsValue;
    if (value != null) {
      expandedSemanticsValue ??= '${(value! * 100).round()}%';
    }
    return Semantics(label: semanticsLabel, value: expandedSemanticsValue, child: child);
  }
}

class _LinearProgressIndicatorPainter extends CustomPainter {
  const _LinearProgressIndicatorPainter({
    required this.trackColor,
    required this.valueColor,
    required this.animationValue,
    required this.textDirection,
    required this.indicatorBorderRadius,
    required this.stopIndicatorColor,
    required this.stopIndicatorRadius,
    required this.trackGap,
    this.value,
  });

  final Color trackColor;
  final Color valueColor;
  final double? value;
  final double animationValue;
  final TextDirection textDirection;
  final BorderRadiusGeometry? indicatorBorderRadius;
  final Color? stopIndicatorColor;
  final double? stopIndicatorRadius;
  final double? trackGap;

  // The indeterminate progress animation displays two lines whose leading (head)
  // and trailing (tail) endpoints are defined by the following four curves.
  static const Curve line1Head = Interval(0.0, 750.0 / _kIndeterminateLinearDuration, curve: Cubic(0.2, 0.0, 0.8, 1.0));
  static const Curve line1Tail = Interval(
    333.0 / _kIndeterminateLinearDuration,
    (333.0 + 750.0) / _kIndeterminateLinearDuration,
    curve: Cubic(0.4, 0.0, 1.0, 1.0),
  );
  static const Curve line2Head = Interval(
    1000.0 / _kIndeterminateLinearDuration,
    (1000.0 + 567.0) / _kIndeterminateLinearDuration,
    curve: Cubic(0.0, 0.0, 0.65, 1.0),
  );
  static const Curve line2Tail = Interval(
    1267.0 / _kIndeterminateLinearDuration,
    (1267.0 + 533.0) / _kIndeterminateLinearDuration,
    curve: Cubic(0.10, 0.0, 0.45, 1.0),
  );

  @override
  void paint(Canvas canvas, Size size) {
    final double effectiveTrackGap = switch (value) {
      null || 1.0 => 0.0,
      _ => trackGap ?? 0.0,
    };

    final Rect trackRect;
    if (value != null && effectiveTrackGap > 0) {
      trackRect = switch (textDirection) {
        TextDirection.ltr => Rect.fromLTRB(
          clampDouble(value!, 0.0, 1.0) * size.width + effectiveTrackGap,
          0,
          size.width,
          size.height,
        ),
        TextDirection.rtl => Rect.fromLTRB(
          0,
          0,
          size.width - clampDouble(value!, 0.0, 1.0) * size.width - effectiveTrackGap,
          size.height,
        ),
      };
    } else {
      trackRect = Offset.zero & size;
    }

    // Draw the track.
    final Paint trackPaint = Paint()..color = trackColor;
    if (indicatorBorderRadius != null) {
      final RRect trackRRect = indicatorBorderRadius!.resolve(textDirection).toRRect(trackRect);
      canvas.drawRRect(trackRRect, trackPaint);
    } else {
      canvas.drawRect(trackRect, trackPaint);
    }

    void drawStopIndicator() {
      // Limit the stop indicator radius to the height of the indicator.
      final double radius = math.min(stopIndicatorRadius!, size.height / 2);
      final Paint indicatorPaint = Paint()..color = stopIndicatorColor!;
      final Offset position = switch (textDirection) {
        TextDirection.rtl => Offset(size.height / 2, size.height / 2),
        TextDirection.ltr => Offset(size.width - size.height / 2, size.height / 2),
      };
      canvas.drawCircle(position, radius, indicatorPaint);
    }

    // Draw the stop indicator.
    if (value != null && stopIndicatorRadius != null && stopIndicatorRadius! > 0) {
      drawStopIndicator();
    }

    void drawActiveIndicator(double x, double width) {
      if (width <= 0.0) {
        return;
      }
      final Paint activeIndicatorPaint = Paint()..color = valueColor;
      final double left = switch (textDirection) {
        TextDirection.rtl => size.width - width - x,
        TextDirection.ltr => x,
      };

      final Rect activeRect = Offset(left, 0.0) & Size(width, size.height);
      if (indicatorBorderRadius != null) {
        final RRect activeRRect = indicatorBorderRadius!.resolve(textDirection).toRRect(activeRect);
        canvas.drawRRect(activeRRect, activeIndicatorPaint);
      } else {
        canvas.drawRect(activeRect, activeIndicatorPaint);
      }
    }

    // Draw the active indicator.
    if (value != null) {
      drawActiveIndicator(0.0, clampDouble(value!, 0.0, 1.0) * size.width);
    } else {
      final double x1 = size.width * line1Tail.transform(animationValue);
      final double width1 = size.width * line1Head.transform(animationValue) - x1;

      final double x2 = size.width * line2Tail.transform(animationValue);
      final double width2 = size.width * line2Head.transform(animationValue) - x2;

      drawActiveIndicator(x1, width1);
      drawActiveIndicator(x2, width2);
    }
  }

  @override
  bool shouldRepaint(_LinearProgressIndicatorPainter oldPainter) =>
      oldPainter.trackColor != trackColor ||
      oldPainter.valueColor != valueColor ||
      oldPainter.value != value ||
      oldPainter.animationValue != animationValue ||
      oldPainter.textDirection != textDirection ||
      oldPainter.indicatorBorderRadius != indicatorBorderRadius ||
      oldPainter.stopIndicatorColor != stopIndicatorColor ||
      oldPainter.stopIndicatorRadius != stopIndicatorRadius ||
      oldPainter.trackGap != trackGap;
}

class LinearProgressIndicator extends ProgressIndicator {
  const LinearProgressIndicator({
    super.key,
    super.value,
    super.backgroundColor,
    super.color,
    super.valueColor,
    this.minHeight,
    super.semanticsLabel,
    super.semanticsValue,
    this.borderRadius,
    this.stopIndicatorColor,
    this.stopIndicatorRadius,
    this.trackGap,
    @Deprecated(
      'Set this flag to false to opt into the 2024 progress indicator appearance. Defaults to true. '
      'In the future, this flag will default to false. Use ProgressIndicatorThemeData to customize individual properties. '
      'This feature was deprecated after v3.26.0-0.1.pre.',
    )
    this.year2023,
  }) : assert(minHeight == null || minHeight > 0);

  final double? minHeight;

  final BorderRadiusGeometry? borderRadius;

  final Color? stopIndicatorColor;

  final double? stopIndicatorRadius;

  final double? trackGap;

  @Deprecated(
    'Set this flag to false to opt into the 2024 progress indicator appearance. Defaults to true. '
    'In the future, this flag will default to false. Use ProgressIndicatorThemeData to customize individual properties. '
    'This feature was deprecated after v3.27.0-0.1.pre.',
  )
  final bool? year2023;

  @override
  State<LinearProgressIndicator> createState() => _LinearProgressIndicatorState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('minHeight', minHeight));
    properties.add(DiagnosticsProperty<BorderRadiusGeometry?>('borderRadius', borderRadius));
    properties.add(ColorProperty('stopIndicatorColor', stopIndicatorColor));
    properties.add(DoubleProperty('stopIndicatorRadius', stopIndicatorRadius));
    properties.add(DoubleProperty('trackGap', trackGap));
    properties.add(DiagnosticsProperty<bool?>('year2023', year2023));
  }
}

class _LinearProgressIndicatorState extends State<LinearProgressIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: _kIndeterminateLinearDuration),
      vsync: this,
    );
    if (widget.value == null) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(LinearProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value == null && !_controller.isAnimating) {
      _controller.repeat();
    } else if (widget.value != null && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildIndicator(BuildContext context, double animationValue, TextDirection textDirection) {
    final ProgressIndicatorThemeData indicatorTheme = ProgressIndicatorTheme.of(context);
    final bool year2023 = widget.year2023 ?? indicatorTheme.year2023 ?? true;
    final ProgressIndicatorThemeData defaults =
        year2023 ? _LinearProgressIndicatorDefaultsM3Year2023(context) : _LinearProgressIndicatorDefaultsM3(context);
    final Color trackColor = widget.backgroundColor ?? indicatorTheme.linearTrackColor ?? defaults.linearTrackColor!;
    final double minHeight = widget.minHeight ?? indicatorTheme.linearMinHeight ?? defaults.linearMinHeight!;
    final BorderRadiusGeometry? borderRadius =
        widget.borderRadius ?? indicatorTheme.borderRadius ?? defaults.borderRadius;
    final Color? stopIndicatorColor =
        !year2023
            ? widget.stopIndicatorColor ?? indicatorTheme.stopIndicatorColor ?? defaults.stopIndicatorColor
            : null;
    final double? stopIndicatorRadius =
        !year2023
            ? widget.stopIndicatorRadius ?? indicatorTheme.stopIndicatorRadius ?? defaults.stopIndicatorRadius
            : null;
    final double? trackGap = !year2023 ? widget.trackGap ?? indicatorTheme.trackGap ?? defaults.trackGap : null;

    Widget result = ConstrainedBox(
      constraints: BoxConstraints(minWidth: double.infinity, minHeight: minHeight),
      child: CustomPaint(
        painter: _LinearProgressIndicatorPainter(
          trackColor: trackColor,
          valueColor: widget._getValueColor(context, defaultColor: defaults.color),
          value: widget.value, // may be null
          animationValue: animationValue, // ignored if widget.value is not null
          textDirection: textDirection,
          indicatorBorderRadius: borderRadius,
          stopIndicatorColor: stopIndicatorColor,
          stopIndicatorRadius: stopIndicatorRadius,
          trackGap: trackGap,
        ),
      ),
    );

    // Clip is only needed with indeterminate progress indicators
    if (borderRadius != null && widget.value == null) {
      result = ClipRRect(borderRadius: borderRadius, child: result);
    }

    return widget._buildSemanticsWrapper(context: context, child: result);
  }

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);

    if (widget.value != null) {
      return _buildIndicator(context, _controller.value, textDirection);
    }

    return AnimatedBuilder(
      animation: _controller.view,
      builder: (context, child) => _buildIndicator(context, _controller.value, textDirection),
    );
  }
}

class _CircularProgressIndicatorPainter extends CustomPainter {
  _CircularProgressIndicatorPainter({
    required this.valueColor,
    required this.value,
    required this.headValue,
    required this.tailValue,
    required this.offsetValue,
    required this.rotationValue,
    required this.strokeWidth,
    required this.strokeAlign,
    this.trackColor,
    this.strokeCap,
    this.trackGap,
    this.year2023 = true,
  }) : arcStart =
           value != null
               ? _startAngle
               : _startAngle +
                   tailValue * 3 / 2 * math.pi +
                   rotationValue * math.pi * 2.0 +
                   offsetValue * 0.5 * math.pi,
       arcSweep =
           value != null
               ? clampDouble(value, 0.0, 1.0) * _sweep
               : math.max(headValue * 3 / 2 * math.pi - tailValue * 3 / 2 * math.pi, _epsilon);

  final Color? trackColor;
  final Color valueColor;
  final double? value;
  final double headValue;
  final double tailValue;
  final double offsetValue;
  final double rotationValue;
  final double strokeWidth;
  final double strokeAlign;
  final double arcStart;
  final double arcSweep;
  final StrokeCap? strokeCap;
  final double? trackGap;
  final bool year2023;

  static const double _twoPi = math.pi * 2.0;
  static const double _epsilon = .001;
  // Canvas.drawArc(r, 0, 2*PI) doesn't draw anything, so just get close.
  static const double _sweep = _twoPi - _epsilon;
  static const double _startAngle = -math.pi / 2.0;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = valueColor
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke;

    // Use the negative operator as intended to keep the exposed constant value
    // as users are already familiar with.
    final double strokeOffset = strokeWidth / 2 * -strokeAlign;
    final Offset arcBaseOffset = Offset(strokeOffset, strokeOffset);
    final Size arcActualSize = Size(size.width - strokeOffset * 2, size.height - strokeOffset * 2);
    final bool hasGap = trackGap != null && trackGap! > 0;

    if (trackColor != null) {
      final Paint backgroundPaint =
          Paint()
            ..color = trackColor!
            ..strokeWidth = strokeWidth
            ..strokeCap = strokeCap ?? StrokeCap.round
            ..style = PaintingStyle.stroke;
      // If hasGap is true, draw the background arc with a gap.
      if (hasGap && value != null && value! > _epsilon) {
        final double arcRadius = arcActualSize.shortestSide / 2;
        final double strokeRadius = strokeWidth / arcRadius;
        final double gapRadius = trackGap! / arcRadius;
        final double startGap = strokeRadius + gapRadius;
        final double endGap = value! < _epsilon ? startGap : startGap * 2;
        final double startSweep = (-math.pi / 2.0) + startGap;
        final double endSweep = math.max(0.0, _twoPi - clampDouble(value!, 0.0, 1.0) * _twoPi - endGap);
        // Flip the canvas for the background arc.
        canvas.save();
        canvas.scale(-1, 1);
        canvas.translate(-size.width, 0);
        canvas.drawArc(arcBaseOffset & arcActualSize, startSweep, endSweep, false, backgroundPaint);
        // Restore the canvas to draw the foreground arc.
        canvas.restore();
      } else {
        canvas.drawArc(arcBaseOffset & arcActualSize, 0, _sweep, false, backgroundPaint);
      }
    }

    if (year2023) {
      if (value == null && strokeCap == null) {
        // Indeterminate
        paint.strokeCap = StrokeCap.square;
      } else {
        // Butt when determinate (value != null) && strokeCap == null;
        paint.strokeCap = strokeCap ?? StrokeCap.butt;
      }
    } else {
      paint.strokeCap = strokeCap ?? StrokeCap.round;
    }

    canvas.drawArc(arcBaseOffset & arcActualSize, arcStart, arcSweep, false, paint);
  }

  @override
  bool shouldRepaint(_CircularProgressIndicatorPainter oldPainter) =>
      oldPainter.trackColor != trackColor ||
      oldPainter.valueColor != valueColor ||
      oldPainter.value != value ||
      oldPainter.headValue != headValue ||
      oldPainter.tailValue != tailValue ||
      oldPainter.offsetValue != offsetValue ||
      oldPainter.rotationValue != rotationValue ||
      oldPainter.strokeWidth != strokeWidth ||
      oldPainter.strokeAlign != strokeAlign ||
      oldPainter.strokeCap != strokeCap ||
      oldPainter.trackGap != trackGap ||
      oldPainter.year2023 != year2023;
}

class CircularProgressIndicator extends ProgressIndicator {
  const CircularProgressIndicator({
    super.key,
    super.value,
    super.backgroundColor,
    super.color,
    super.valueColor,
    this.strokeWidth,
    this.strokeAlign,
    super.semanticsLabel,
    super.semanticsValue,
    this.strokeCap,
    this.constraints,
    this.trackGap,
    @Deprecated(
      'Set this flag to false to opt into the 2024 progress indicator appearance. Defaults to true. '
      'In the future, this flag will default to false. Use ProgressIndicatorThemeData to customize individual properties. '
      'This feature was deprecated after v3.27.0-0.1.pre.',
    )
    this.year2023,
    this.padding,
  }) : _indicatorType = _ActivityIndicatorType.material;

  const CircularProgressIndicator.adaptive({
    super.key,
    super.value,
    super.backgroundColor,
    super.valueColor,
    this.strokeWidth = 4.0,
    super.semanticsLabel,
    super.semanticsValue,
    this.strokeCap,
    this.strokeAlign,
    this.constraints,
    this.trackGap,
    @Deprecated(
      'Set this flag to false to opt into the 2024 progress indicator appearance. Defaults to true. '
      'In the future, this flag will default to false. Use ProgressIndicatorThemeData to customize individual properties. '
      'This feature was deprecated after v3.27.0-0.2.pre.',
    )
    this.year2023,
    this.padding,
  }) : _indicatorType = _ActivityIndicatorType.adaptive;

  final _ActivityIndicatorType _indicatorType;

  final double? strokeWidth;

  final double? strokeAlign;

  final StrokeCap? strokeCap;

  final BoxConstraints? constraints;

  final double? trackGap;

  @Deprecated(
    'Set this flag to false to opt into the 2024 progress indicator appearance. Defaults to true. '
    'In the future, this flag will default to false. Use ProgressIndicatorThemeData to customize individual properties. '
    'This feature was deprecated after v3.27.0-0.2.pre.',
  )
  final bool? year2023;

  final EdgeInsetsGeometry? padding;

  static const double strokeAlignInside = -1.0;

  static const double strokeAlignCenter = 0.0;

  static const double strokeAlignOutside = 1.0;

  @override
  State<CircularProgressIndicator> createState() => _CircularProgressIndicatorState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('strokeWidth', strokeWidth));
    properties.add(DoubleProperty('strokeAlign', strokeAlign));
    properties.add(EnumProperty<StrokeCap?>('strokeCap', strokeCap));
    properties.add(DiagnosticsProperty<BoxConstraints?>('constraints', constraints));
    properties.add(DoubleProperty('trackGap', trackGap));
    properties.add(DiagnosticsProperty<bool?>('year2023', year2023));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('padding', padding));
  }
}

class _CircularProgressIndicatorState extends State<CircularProgressIndicator> with SingleTickerProviderStateMixin {
  static const int _pathCount = _kIndeterminateCircularDuration ~/ 1333;
  static const int _rotationCount = _kIndeterminateCircularDuration ~/ 2222;

  static final Animatable<double> _strokeHeadTween = CurveTween(
    curve: const Interval(0.0, 0.5, curve: Curves.fastOutSlowIn),
  ).chain(CurveTween(curve: const SawTooth(_pathCount)));
  static final Animatable<double> _strokeTailTween = CurveTween(
    curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
  ).chain(CurveTween(curve: const SawTooth(_pathCount)));
  static final Animatable<double> _offsetTween = CurveTween(curve: const SawTooth(_pathCount));
  static final Animatable<double> _rotationTween = CurveTween(curve: const SawTooth(_rotationCount));

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: _kIndeterminateCircularDuration),
      vsync: this,
    );
    if (widget.value == null) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(CircularProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value == null && !_controller.isAnimating) {
      _controller.repeat();
    } else if (widget.value != null && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildCupertinoIndicator(BuildContext context) {
    final Color? tickColor = widget.backgroundColor;
    final double? value = widget.value;
    if (value == null) {
      return CupertinoActivityIndicator(key: widget.key, color: tickColor);
    }
    return CupertinoActivityIndicator.partiallyRevealed(key: widget.key, color: tickColor, progress: value);
  }

  Widget _buildMaterialIndicator(
    BuildContext context,
    double headValue,
    double tailValue,
    double offsetValue,
    double rotationValue,
  ) {
    final ProgressIndicatorThemeData indicatorTheme = ProgressIndicatorTheme.of(context);
    final bool year2023 = widget.year2023 ?? indicatorTheme.year2023 ?? true;
    final ProgressIndicatorThemeData defaults =
        year2023
            ? _CircularProgressIndicatorDefaultsM3Year2023(context, indeterminate: widget.value == null)
            : _CircularProgressIndicatorDefaultsM3(context, indeterminate: widget.value == null);
    final Color? trackColor =
        widget.backgroundColor ?? indicatorTheme.circularTrackColor ?? defaults.circularTrackColor;
    final double strokeWidth = widget.strokeWidth ?? indicatorTheme.strokeWidth ?? defaults.strokeWidth!;
    final double strokeAlign = widget.strokeAlign ?? indicatorTheme.strokeAlign ?? defaults.strokeAlign!;
    final StrokeCap? strokeCap = widget.strokeCap ?? indicatorTheme.strokeCap;
    final BoxConstraints constraints = widget.constraints ?? indicatorTheme.constraints ?? defaults.constraints!;
    final double? trackGap = year2023 ? null : widget.trackGap ?? indicatorTheme.trackGap ?? defaults.trackGap;
    final EdgeInsetsGeometry? effectivePadding =
        widget.padding ?? indicatorTheme.circularTrackPadding ?? defaults.circularTrackPadding;

    Widget result = ConstrainedBox(
      constraints: constraints,
      child: CustomPaint(
        painter: _CircularProgressIndicatorPainter(
          trackColor: trackColor,
          valueColor: widget._getValueColor(context, defaultColor: defaults.color),
          value: widget.value, // may be null
          headValue: headValue, // remaining arguments are ignored if widget.value is not null
          tailValue: tailValue,
          offsetValue: offsetValue,
          rotationValue: rotationValue,
          strokeWidth: strokeWidth,
          strokeAlign: strokeAlign,
          strokeCap: strokeCap,
          trackGap: trackGap,
          year2023: year2023,
        ),
      ),
    );

    if (effectivePadding != null) {
      result = Padding(padding: effectivePadding, child: result);
    }

    return widget._buildSemanticsWrapper(context: context, child: result);
  }

  Widget _buildAnimation() => AnimatedBuilder(
    animation: _controller,
    builder:
        (context, child) => _buildMaterialIndicator(
          context,
          _strokeHeadTween.evaluate(_controller),
          _strokeTailTween.evaluate(_controller),
          _offsetTween.evaluate(_controller),
          _rotationTween.evaluate(_controller),
        ),
  );

  @override
  Widget build(BuildContext context) {
    switch (widget._indicatorType) {
      case _ActivityIndicatorType.material:
        if (widget.value != null) {
          return _buildMaterialIndicator(context, 0.0, 0.0, 0, 0.0);
        }
        return _buildAnimation();
      case _ActivityIndicatorType.adaptive:
        final ThemeData theme = Theme.of(context);
        switch (theme.platform) {
          case TargetPlatform.iOS:
          case TargetPlatform.macOS:
            return _buildCupertinoIndicator(context);
          case TargetPlatform.android:
          case TargetPlatform.fuchsia:
          case TargetPlatform.linux:
          case TargetPlatform.windows:
            if (widget.value != null) {
              return _buildMaterialIndicator(context, 0.0, 0.0, 0, 0.0);
            }
            return _buildAnimation();
        }
    }
  }
}

class _RefreshProgressIndicatorPainter extends _CircularProgressIndicatorPainter {
  _RefreshProgressIndicatorPainter({
    required super.valueColor,
    required super.value,
    required super.headValue,
    required super.tailValue,
    required super.offsetValue,
    required super.rotationValue,
    required super.strokeWidth,
    required super.strokeAlign,
    required this.arrowheadScale,
    required super.strokeCap,
  });

  final double arrowheadScale;

  void paintArrowhead(Canvas canvas, Size size) {
    // ux, uy: a unit vector whose direction parallels the base of the arrowhead.
    // (So ux, -uy points in the direction the arrowhead points.)
    final double arcEnd = arcStart + arcSweep;
    final double ux = math.cos(arcEnd);
    final double uy = math.sin(arcEnd);

    assert(size.width == size.height);
    final double radius = size.width / 2.0;
    final double arrowheadPointX = radius + ux * radius + -uy * strokeWidth * 2.0 * arrowheadScale;
    final double arrowheadPointY = radius + uy * radius + ux * strokeWidth * 2.0 * arrowheadScale;
    final double arrowheadRadius = strokeWidth * 2.0 * arrowheadScale;
    final double innerRadius = radius - arrowheadRadius;
    final double outerRadius = radius + arrowheadRadius;

    final Path path =
        Path()
          ..moveTo(radius + ux * innerRadius, radius + uy * innerRadius)
          ..lineTo(radius + ux * outerRadius, radius + uy * outerRadius)
          ..lineTo(arrowheadPointX, arrowheadPointY)
          ..close();

    final Paint paint =
        Paint()
          ..color = valueColor
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.fill;
    canvas.drawPath(path, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);
    if (arrowheadScale > 0.0) {
      paintArrowhead(canvas, size);
    }
  }
}

class RefreshProgressIndicator extends CircularProgressIndicator {
  const RefreshProgressIndicator({
    super.key,
    super.value,
    super.backgroundColor,
    super.color,
    super.valueColor,
    super.strokeWidth = defaultStrokeWidth, // Different default than CircularProgressIndicator.
    super.strokeAlign,
    super.semanticsLabel,
    super.semanticsValue,
    super.strokeCap,
    this.elevation = 2.0,
    this.indicatorMargin = const EdgeInsets.all(4.0),
    this.indicatorPadding = const EdgeInsets.all(12.0),
  });

  final double elevation;

  final EdgeInsetsGeometry indicatorMargin;

  final EdgeInsetsGeometry indicatorPadding;

  static const double defaultStrokeWidth = 2.5;

  @override
  State<CircularProgressIndicator> createState() => _RefreshProgressIndicatorState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('elevation', elevation));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('indicatorMargin', indicatorMargin));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('indicatorPadding', indicatorPadding));
  }
}

class _RefreshProgressIndicatorState extends _CircularProgressIndicatorState {
  static const double _indicatorSize = 41.0;

  static const double _strokeHeadInterval = 0.33;

  late final Animatable<double> _convertTween = CurveTween(curve: const Interval(0.1, _strokeHeadInterval));

  late final Animatable<double> _additionalRotationTween = TweenSequence<double>(<TweenSequenceItem<double>>[
    // Makes arrow to expand a little bit earlier, to match the Android look.
    TweenSequenceItem<double>(tween: Tween<double>(begin: -0.1, end: -0.2), weight: _strokeHeadInterval),
    // Additional rotation after the arrow expanded
    TweenSequenceItem<double>(tween: Tween<double>(begin: -0.2, end: 1.35), weight: 1 - _strokeHeadInterval),
  ]);

  // Last value received from the widget before null.
  double? _lastValue;

  @override
  RefreshProgressIndicator get widget => super.widget as RefreshProgressIndicator;

  // Always show the indeterminate version of the circular progress indicator.
  //
  // When value is non-null the sweep of the progress indicator arrow's arc
  // varies from 0 to about 300 degrees.
  //
  // When value is null the arrow animation starting from wherever we left it.
  @override
  Widget build(BuildContext context) {
    final double? value = widget.value;
    if (value != null) {
      _lastValue = value;
      _controller.value = _convertTween.transform(value) * (1333 / 2 / _kIndeterminateCircularDuration);
    }
    return _buildAnimation();
  }

  @override
  Widget _buildAnimation() => AnimatedBuilder(
    animation: _controller,
    builder:
        (context, child) => _buildMaterialIndicator(
          context,
          // Lengthen the arc a little
          1.05 * _CircularProgressIndicatorState._strokeHeadTween.evaluate(_controller),
          _CircularProgressIndicatorState._strokeTailTween.evaluate(_controller),
          _CircularProgressIndicatorState._offsetTween.evaluate(_controller),
          _CircularProgressIndicatorState._rotationTween.evaluate(_controller),
        ),
  );

  @override
  Widget _buildMaterialIndicator(
    BuildContext context,
    double headValue,
    double tailValue,
    double offsetValue,
    double rotationValue,
  ) {
    final double? value = widget.value;
    final double arrowheadScale = value == null ? 0.0 : const Interval(0.1, _strokeHeadInterval).transform(value);
    final double rotation;

    if (value == null && _lastValue == null) {
      rotation = 0.0;
    } else {
      rotation = math.pi * _additionalRotationTween.transform(value ?? _lastValue!);
    }

    Color valueColor = widget._getValueColor(context);
    final double opacity = valueColor.opacity;
    valueColor = valueColor.withOpacity(1.0);

    final ProgressIndicatorThemeData defaults = _CircularProgressIndicatorDefaultsM3Year2023(
      context,
      indeterminate: value == null,
    );
    final ProgressIndicatorThemeData indicatorTheme = ProgressIndicatorTheme.of(context);
    final Color backgroundColor =
        widget.backgroundColor ?? indicatorTheme.refreshBackgroundColor ?? Theme.of(context).canvasColor;
    final double strokeWidth = widget.strokeWidth ?? indicatorTheme.strokeWidth ?? defaults.strokeWidth!;
    final double strokeAlign = widget.strokeAlign ?? indicatorTheme.strokeAlign ?? defaults.strokeAlign!;
    final StrokeCap? strokeCap = widget.strokeCap ?? indicatorTheme.strokeCap;

    return widget._buildSemanticsWrapper(
      context: context,
      child: Padding(
        padding: widget.indicatorMargin,
        child: SizedBox.fromSize(
          size: const Size.square(_indicatorSize),
          child: Material(
            type: MaterialType.circle,
            color: backgroundColor,
            elevation: widget.elevation,
            child: Padding(
              padding: widget.indicatorPadding,
              child: Opacity(
                opacity: opacity,
                child: Transform.rotate(
                  angle: rotation,
                  child: CustomPaint(
                    painter: _RefreshProgressIndicatorPainter(
                      valueColor: valueColor,
                      value: null, // Draw the indeterminate progress indicator.
                      headValue: headValue,
                      tailValue: tailValue,
                      offsetValue: offsetValue,
                      rotationValue: rotationValue,
                      strokeWidth: strokeWidth,
                      strokeAlign: strokeAlign,
                      arrowheadScale: arrowheadScale,
                      strokeCap: strokeCap,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Hand coded defaults based on Material Design 2.
class _CircularProgressIndicatorDefaultsM2 extends ProgressIndicatorThemeData {
  _CircularProgressIndicatorDefaultsM2(this.context, {required this.indeterminate});

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;
  final bool indeterminate;

  @override
  Color get color => _colors.primary;

  @override
  double? get strokeWidth => 4.0;

  @override
  double? get strokeAlign => CircularProgressIndicator.strokeAlignCenter;

  @override
  BoxConstraints get constraints => const BoxConstraints(minWidth: 36.0, minHeight: 36.0);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BuildContext>('context', context));
    properties.add(DiagnosticsProperty<bool>('indeterminate', indeterminate));
  }
}

class _CircularProgressIndicatorDefaultsM3Year2023 extends ProgressIndicatorThemeData {
  _CircularProgressIndicatorDefaultsM3Year2023(this.context, {required this.indeterminate});

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;
  final bool indeterminate;

  @override
  Color get color => _colors.primary;

  @override
  double get strokeWidth => 4.0;

  @override
  double? get strokeAlign => CircularProgressIndicator.strokeAlignCenter;

  @override
  BoxConstraints get constraints => const BoxConstraints(minWidth: 36.0, minHeight: 36.0);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BuildContext>('context', context));
    properties.add(DiagnosticsProperty<bool>('indeterminate', indeterminate));
  }
}

class _LinearProgressIndicatorDefaultsM3Year2023 extends ProgressIndicatorThemeData {
  _LinearProgressIndicatorDefaultsM3Year2023(this.context);

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;

  @override
  Color get color => _colors.primary;

  @override
  Color get linearTrackColor => _colors.secondaryContainer;

  @override
  double get linearMinHeight => 4.0;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BuildContext>('context', context));
  }
}

// BEGIN GENERATED TOKEN PROPERTIES - ProgressIndicator

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// dart format off
class _CircularProgressIndicatorDefaultsM3 extends ProgressIndicatorThemeData {
  _CircularProgressIndicatorDefaultsM3(this.context, { required this.indeterminate });

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;
  final bool indeterminate;

  @override
  Color get color => _colors.primary;

  @override
  Color? get circularTrackColor => indeterminate ? null : _colors.secondaryContainer;

  @override
  double get strokeWidth => 4.0;

  @override
  double? get strokeAlign => CircularProgressIndicator.strokeAlignInside;

  @override
  BoxConstraints get constraints => const BoxConstraints(
    minWidth: 40.0,
    minHeight: 40.0,
  );

  @override
  double? get trackGap => 4.0;

  @override
  EdgeInsetsGeometry? get circularTrackPadding => const EdgeInsets.all(4.0);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BuildContext>('context', context));
    properties.add(DiagnosticsProperty<bool>('indeterminate', indeterminate));
  }
}

class _LinearProgressIndicatorDefaultsM3 extends ProgressIndicatorThemeData {
  _LinearProgressIndicatorDefaultsM3(this.context);

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;

  @override
  Color get color => _colors.primary;

  @override
  Color get linearTrackColor => _colors.secondaryContainer;

  @override
  double get linearMinHeight => 4.0;

  @override
  BorderRadius get borderRadius => BorderRadius.circular(4.0 / 2);

  @override
  Color get stopIndicatorColor => _colors.primary;

  @override
  double? get stopIndicatorRadius => 4.0 / 2;

  @override
  double? get trackGap => 4.0;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BuildContext>('context', context));
  }
}
// dart format on

// END GENERATED TOKEN PROPERTIES - ProgressIndicator
