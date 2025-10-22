import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Theme;
import 'package:waveui/waveui.dart';

class WaveSlider extends StatelessWidget {
  final double? value;
  final RangeValues? rangeValues;
  final ValueChanged<double>? onChanged;
  final ValueChanged<RangeValues>? onRangeChanged;
  final int? divisions;
  final double? min;
  final double? max;
  final bool isRange;
  const WaveSlider({
    this.value,
    this.rangeValues,
    super.key,
    this.onChanged,
    this.onRangeChanged,
    this.divisions,
    this.min,
    this.max,
    this.isRange = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SliderTheme(
      data: SliderThemeData(
        activeTrackColor: theme.colorScheme.brandPrimary,
        thumbColor: theme.colorScheme.onBrandPrimary,
        valueIndicatorColor: theme.colorScheme.brandPrimary,
        trackHeight: 10,
        thumbShape: const RoundSliderThumbShape(
          elevation: 0,
          enabledThumbRadius: 4,
        ),
        valueIndicatorShape: const RectangularSliderValueIndicatorShape(),
        valueIndicatorTextStyle: theme.textTheme.small.copyWith(
          color: theme.colorScheme.onBrandPrimary,
        ),
      ),
      child:
          isRange
              ? RangeSlider(
                values: rangeValues!,
                onChanged: onRangeChanged,
                divisions: divisions,
                min: min ?? 0,
                max: max ?? 1,
                labels: RangeLabels(
                  rangeValues!.start.toString().replaceFirst(
                    RegExp(r'\.?0+$'),
                    '',
                  ),
                  rangeValues!.end.toString().replaceFirst(
                    RegExp(r'\.?0+$'),
                    '',
                  ),
                ),
              )
              : Slider(
                label: value.toString().replaceFirst(RegExp(r'\.?0+$'), ''),
                value: value ?? min ?? max ?? 0,
                onChanged: onChanged,
                padding: EdgeInsets.zero,
                divisions: divisions,
                inactiveColor: theme.colorScheme.outlineDivider,
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
      ..add(
        ObjectFlagProperty<ValueChanged<RangeValues>?>.has(
          'onRangeChanged',
          onRangeChanged,
        ),
      )
      ..add(IntProperty('divisions', divisions))
      ..add(FlagProperty('isRange', value: isRange, ifTrue: 'range slider'))
      ..add(DiagnosticsProperty<RangeValues?>('rangeValues', rangeValues))
      ..add(DoubleProperty('min', min))
      ..add(DoubleProperty('max', max));
  }
}
