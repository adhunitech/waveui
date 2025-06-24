import 'package:flutter/material.dart' hide Theme;
import 'package:waveui/src/widgets/stepper/stepper_item.dart';
import 'package:waveui/src/widgets/stepper/widgets/common/stepper_dot_widget.dart';

class DotProvider extends StatelessWidget {
  const DotProvider({
    Key? key,
    required this.index,
    required this.activeIndex,
    required this.item,
    required this.totalLength,
    this.iconHeight,
    this.iconWidth,
  }) : super(key: key);

  /// Stepper item of type [StepperItem] to inflate stepper with data
  final StepperItem item;

  /// Index at which the item is present
  final int index;

  /// Total length of the list provided
  final int totalLength;

  /// Active index which needs to be highlighted and before that
  final int activeIndex;

  /// Height of [StepperItem.iconWidget]
  final double? iconHeight;

  /// Width of [StepperItem.iconWidget]
  final double? iconWidth;

  @override
  Widget build(BuildContext context) {
    return index <= activeIndex
        ? SizedBox(
          height: iconHeight,
          width: iconWidth,
          child: item.iconWidget ?? StepperDot(index: index, totalLength: totalLength, activeIndex: activeIndex),
        )
        : item.iconWidget != null
        ? SizedBox(
          height: iconHeight,
          width: iconWidth,
          child: item.iconWidget ?? StepperDot(index: index, totalLength: totalLength, activeIndex: activeIndex),
        )
        : SizedBox(
          height: iconHeight,
          width: iconWidth,
          child: item.iconWidget ?? StepperDot(index: index, totalLength: totalLength, activeIndex: activeIndex),
        );
  }
}
