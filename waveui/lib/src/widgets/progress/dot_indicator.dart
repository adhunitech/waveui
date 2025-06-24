import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Theme;
import 'package:waveui/waveui.dart';

class WaveDotIndicator extends StatelessWidget {
  final int count;
  final double currentIndex;
  final double dotSize;
  final double spacing;
  final Color? activeColor;
  final Color? inactiveColor;

  const WaveDotIndicator({
    required this.count,
    required this.currentIndex,
    super.key,
    this.dotSize = 12.0,
    this.spacing = 16.0,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CustomPaint(
      size: Size((dotSize + spacing) * count, dotSize),
      painter: _DotPainter(
        count: count,
        currentIndex: currentIndex,
        dotSize: dotSize,
        spacing: spacing,
        activeColor: activeColor ?? theme.colorScheme.brandPrimary,
        inactiveColor: inactiveColor ?? theme.colorScheme.outlineDivider,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('activeColor', activeColor))
      ..add(IntProperty('count', count))
      ..add(DoubleProperty('currentIndex', currentIndex))
      ..add(DoubleProperty('dotSize', dotSize))
      ..add(DoubleProperty('spacing', spacing))
      ..add(ColorProperty('inactiveColor', inactiveColor));
  }
}

class _DotPainter extends CustomPainter {
  final int count;
  final double currentIndex;
  final double dotSize;
  final double spacing;
  final Color activeColor;
  final Color inactiveColor;

  _DotPainter({
    required this.count,
    required this.currentIndex,
    required this.dotSize,
    required this.spacing,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    final double radius = dotSize / 2;

    for (int i = 0; i < count; i++) {
      final dx = i * (dotSize + spacing) + radius;
      final dy = size.height / 2;

      // Interpolate color between active and inactive
      final double t = 1.0 - (currentIndex - i).abs().clamp(0.0, 1.0);
      paint.color = Color.lerp(inactiveColor, activeColor, t)!;

      canvas.drawCircle(Offset(dx, dy), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DotPainter oldDelegate) => oldDelegate.currentIndex != currentIndex;
}
