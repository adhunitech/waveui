import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:waveui/waveui.dart';

class WaveDivider extends StatelessWidget {
  final Axis axis;
  final Color? color;

  /// Creates a [WaveDivider] widget.
  const WaveDivider({super.key, this.axis = Axis.horizontal, this.color});

  @override
  Widget build(BuildContext context) {
    final theme = WaveApp.themeOf(context);
    return axis == Axis.horizontal
        ? SizedBox(height: 1, width: double.infinity, child: ColoredBox(color: color ?? theme.colorScheme.divider))
        : SizedBox(width: 1, height: double.infinity, child: ColoredBox(color: color ?? theme.colorScheme.divider));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<Axis>('axis', axis))
      ..add(ColorProperty('color', color));
  }
}
