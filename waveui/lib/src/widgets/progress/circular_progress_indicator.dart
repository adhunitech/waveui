import 'package:flutter/material.dart' as m;
import 'package:waveui/waveui.dart';

/// CircularProgressIndicator is a widget that displays a circular progress indicator.
class CircularProgressIndicator extends StatelessWidget {
  const CircularProgressIndicator({
    super.key,
    this.backgroundColor,
    this.color,
    this.strokeWidth = 4,
    this.value,
    this.size = 24,
  });
  final Color? backgroundColor;
  final Color? color;
  final double strokeWidth;
  final double? value;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = this.color ?? theme.colorScheme.brandPrimary;
    final backgroundColor =
        this.backgroundColor ?? color.withValues(alpha: 0.1);
    return SizedBox(
      width: size,
      height: size,
      child: m.CircularProgressIndicator(
        backgroundColor: backgroundColor,
        color: color,
        strokeWidth: strokeWidth,
        value: value,
      ),
    );
  }
}
