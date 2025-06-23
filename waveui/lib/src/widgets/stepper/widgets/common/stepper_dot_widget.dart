import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:waveui/waveui.dart';

class StepperDot extends StatelessWidget {
  /// Default stepper dot
  const StepperDot({Key? key, required this.index, required this.totalLength, required this.activeIndex})
    : super(key: key);

  /// Index at which the item is present
  final int index;

  /// Total length of the list provided
  final int totalLength;

  /// Active index which needs to be highlighted and before that
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    final theme = WaveApp.themeOf(context);
    final color = (index <= activeIndex) ? theme.colorScheme.brandPrimary : theme.colorScheme.outlineStandard;
    return Container(
      height: 18,
      width: 18,
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: const BorderRadius.all(Radius.circular(30)),
      ),
      child: Container(
        height: 14,
        width: 14,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: color),
          borderRadius: const BorderRadius.all(Radius.circular(30)),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('index', index));
    properties.add(IntProperty('totalLength', totalLength));
    properties.add(IntProperty('activeIndex', activeIndex));
  }
}
