import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:waveui/waveui.dart';

class WaveDivider extends StatelessWidget {
  final Axis axis;

  /// Creates a [WaveDivider] widget.
  const WaveDivider({super.key, this.axis = Axis.horizontal});

  @override
  Widget build(BuildContext context) {
    final theme = WaveApp.themeOf(context);
    return axis == Axis.horizontal
        ? SizedBox(height: 1, width: double.infinity, child: ColoredBox(color: theme.colorScheme.divider))
        : SizedBox(width: 1, height: double.infinity, child: ColoredBox(color: theme.colorScheme.divider));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<Axis>('axis', axis));
  }
}
