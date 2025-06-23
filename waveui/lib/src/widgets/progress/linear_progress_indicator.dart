import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:waveui/waveui.dart';

class WaveLinearProgressIndicator extends StatefulWidget {
  const WaveLinearProgressIndicator({super.key, this.backgroundColor, this.value, this.color, this.height = 5.0});

  final Color? backgroundColor;
  final Color? color;
  final double? value;
  final double height;

  @override
  State<WaveLinearProgressIndicator> createState() => _WaveLinearProgressIndicatorState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('backgroundColor', backgroundColor))
      ..add(ColorProperty('color', color))
      ..add(DoubleProperty('value', value))
      ..add(DoubleProperty('height', height));
  }
}

class _WaveLinearProgressIndicatorState extends State<WaveLinearProgressIndicator> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))..repeat();

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.8, curve: Curves.easeInOut)));
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
      animation: _animation,
      builder:
          (context, child) => SizedBox(
            height: widget.height,
            child: CustomPaint(
              painter: _LinearProgressPainter(
                backgroundColor: bgColor,
                progressColor: progressColor,
                value: widget.value,
                animationValue: widget.value == null ? _animation.value : null,
              ),
            ),
          ),
    );
  }
}

class _LinearProgressPainter extends CustomPainter {
  _LinearProgressPainter({
    required this.backgroundColor,
    required this.progressColor,
    required this.value,
    this.animationValue,
  });

  final Color backgroundColor;
  final Color progressColor;
  final double? value;
  final double? animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    // Draw background
    final backgroundPaint = Paint()..color = backgroundColor;
    canvas.drawRect(Offset.zero & size, backgroundPaint);

    // Draw progress
    if (value != null) {
      final progressPaint = Paint()..color = progressColor;
      final progressWidth = size.width * value!;
      canvas.drawRect(Offset.zero & Size(progressWidth, size.height), progressPaint);
    } else if (animationValue != null) {
      final progressPaint = Paint()..color = progressColor;
      final barWidth = size.width * 0.3; // Fixed width for the moving bar
      final startX = size.width * animationValue! - barWidth;

      // Draw the main bar
      canvas.drawRect(Offset(startX.clamp(0, size.width - barWidth), 0) & Size(barWidth, size.height), progressPaint);

      // Draw the trailing fade effect
      if (startX < 0) {
        final fadeWidth = -startX;
        final fadePaint =
            Paint()
              ..color = progressColor.withValues(alpha: 0.5)
              ..shader = LinearGradient(
                colors: [progressColor.withValues(alpha: 0), progressColor],
              ).createShader(Rect.fromLTWH(0, 0, fadeWidth, size.height));
        canvas.drawRect(Offset.zero & Size(fadeWidth, size.height), fadePaint);
      }
    }
  }

  @override
  bool shouldRepaint(_LinearProgressPainter oldDelegate) =>
      oldDelegate.backgroundColor != backgroundColor ||
      oldDelegate.progressColor != progressColor ||
      oldDelegate.value != value ||
      oldDelegate.animationValue != animationValue;
}
