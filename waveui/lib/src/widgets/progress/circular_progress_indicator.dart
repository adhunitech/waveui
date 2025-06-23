import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:waveui/waveui.dart';

class WaveCircularProgressIndicator extends StatefulWidget {
  const WaveCircularProgressIndicator({
    super.key,
    this.backgroundColor,
    this.value,
    this.color,
    this.strokeWidth = 4.0,
    this.size = 36.0,
  });

  final Color? backgroundColor;
  final Color? color;
  final double? value;
  final double strokeWidth;
  final double size;

  @override
  State<WaveCircularProgressIndicator> createState() => _WaveCircularProgressIndicatorState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('backgroundColor', backgroundColor))
      ..add(DoubleProperty('value', value))
      ..add(ColorProperty('color', color))
      ..add(DoubleProperty('strokeWidth', strokeWidth))
      ..add(DoubleProperty('size', size));
  }
}

class _WaveCircularProgressIndicatorState extends State<WaveCircularProgressIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = WaveApp.themeOf(context);
    final bgColor = widget.backgroundColor ?? theme.colorScheme.brandPrimary.withValues(alpha: 0.1);
    final progressColor = widget.color ?? theme.colorScheme.brandPrimary;

    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: _CircularProgressPainter(
              backgroundColor: bgColor,
              progressColor: progressColor,
              value: widget.value,
              strokeWidth: widget.strokeWidth,
              rotation: widget.value == null ? _rotationAnimation.value : 0,
            ),
          ),
        );
      },
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  _CircularProgressPainter({
    required this.backgroundColor,
    required this.progressColor,
    required this.value,
    required this.strokeWidth,
    this.rotation = 0,
  });

  final Color backgroundColor;
  final Color progressColor;
  final double? value;
  final double strokeWidth;
  final double rotation;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Draw background
    final backgroundPaint =
        Paint()
          ..color = backgroundColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw progress
    if (value != null) {
      final progressPaint =
          Paint()
            ..color = progressColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth
            ..strokeCap = StrokeCap.round;

      final sweepAngle = 2 * value! * 3.14159;
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -3.14159 / 2, sweepAngle, false, progressPaint);
    } else {
      final progressPaint =
          Paint()
            ..color = progressColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth
            ..strokeCap = StrokeCap.round;

      // Draw a rotating arc for indeterminate state
      final startAngle = -3.14159 / 2 + (rotation * 2 * 3.14159);
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, 3.14159 / 2, false, progressPaint);
    }
  }

  @override
  bool shouldRepaint(_CircularProgressPainter oldDelegate) =>
      oldDelegate.backgroundColor != backgroundColor ||
      oldDelegate.progressColor != progressColor ||
      oldDelegate.value != value ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.rotation != rotation;
}
