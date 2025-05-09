import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:waveui/waveui.dart';

class WaveSlider extends StatelessWidget {
  final double? value;
  final ValueChanged<double>? onChanged;
  final int? divisions;
  final double? min;
  final double? max;
  const WaveSlider({
    this.value,
    super.key,
    this.onChanged,
    this.divisions,
    this.min,
    this.max,
  });

  @override
  Widget build(BuildContext context) {
    final theme = WaveApp.themeOf(context);
    return SliderTheme(
      data: SliderThemeData(
        activeTrackColor: theme.colorScheme.primary.withValues(alpha: 0.3),
        thumbColor: theme.colorScheme.primary,
        overlayColor: theme.colorScheme.primary.withValues(alpha: 0.1),
        valueIndicatorColor: theme.colorScheme.primary,
        trackHeight: 6,
        valueIndicatorShape: const RectangularSliderValueIndicatorShape(),
        valueIndicatorTextStyle: theme.textTheme.small.copyWith(
          color: theme.colorScheme.onPrimary,
        ),
      ),
      child: Slider(
        label: value.toString().replaceFirst(RegExp(r'\.?0+$'), ''),
        value: value ?? min ?? max ?? 0,
        onChanged: onChanged,
        padding: EdgeInsets.zero,
        divisions: divisions,
        inactiveColor: theme.colorScheme.divider,
        min: min ?? 0,
        max: max ?? 1,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('value', value))
      ..add(
        ObjectFlagProperty<ValueChanged<double>?>.has('onChanged', onChanged),
      )
      ..add(IntProperty('divisions', divisions));
  }
}
