import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:waveui/waveui.dart';

class WaveLinearProgressIndicator extends StatelessWidget {
  const WaveLinearProgressIndicator({super.key, this.backgroundColor, this.value, this.color});
  final Color? backgroundColor;
  final Color? color;
  final double? value;

  @override
  Widget build(BuildContext context) {
    final theme = WaveApp.themeOf(context);
    return LinearProgressIndicator(
      backgroundColor: backgroundColor ?? theme.colorScheme.primary.withValues(alpha: .1),
      color: color ?? theme.colorScheme.primary,
      value: value,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('backgroundColor', backgroundColor))
      ..add(DoubleProperty('value', value))
      ..add(ColorProperty('color', color));
  }
}
