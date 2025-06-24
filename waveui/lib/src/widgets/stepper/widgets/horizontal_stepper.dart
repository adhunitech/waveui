import 'package:flutter/material.dart';
import 'package:waveui/src/widgets/stepper/widgets/common/dot_provider.dart';
import 'package:waveui/waveui.dart';

class HorizontalStepperItem extends StatelessWidget {
  /// Stepper Item to show horizontal stepper
  const HorizontalStepperItem({
    Key? key,
    required this.item,
    required this.index,
    required this.totalLength,
    required this.activeIndex,
    required this.isInverted,
    required this.activeBarColor,
    required this.inActiveBarColor,
    required this.barHeight,
    required this.iconHeight,
    required this.iconWidth,
  }) : super(key: key);

  /// Stepper item of type [StepperItem] to inflate stepper with data
  final StepperItem item;

  /// Index at which the item is present
  final int index;

  /// Total length of the list provided
  final int totalLength;

  /// Active index which needs to be highlighted and before that
  final int activeIndex;

  /// Inverts the stepper with text that is being used
  final bool isInverted;

  /// Bar color for active step
  final Color activeBarColor;

  /// Bar color for inactive step
  final Color inActiveBarColor;

  /// Bar height/thickness
  final double barHeight;

  /// Height of [StepperItem.iconWidget]
  final double iconHeight;

  /// Width of [StepperItem.iconWidget]
  final double iconWidth;

  @override
  Widget build(BuildContext context) => Flexible(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: isInverted ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: isInverted ? getInvertedChildren(context) : getChildren(context),
    ),
  );

  List<Widget> getChildren(BuildContext context) {
    final theme = WaveTheme.of(context);
    return [
      if (item.title != null) ...[
        DefaultTextStyle(style: theme.textTheme.body, child: item.title!),
        const SizedBox(height: 6),
      ],
      if (item.subtitle != null) ...[
        DefaultTextStyle(
          style: theme.textTheme.small.copyWith(color: theme.colorScheme.textSecondary),
          child: item.subtitle!,
        ),
        const SizedBox(height: 8),
      ],
      Row(
        children: [
          Flexible(
            child: Container(
              color: index == 0 ? Colors.transparent : (index <= activeIndex ? activeBarColor : inActiveBarColor),
              height: barHeight,
            ),
          ),
          DotProvider(
            activeIndex: activeIndex,
            index: index,
            item: item,
            totalLength: totalLength,
            iconHeight: iconHeight,
            iconWidth: iconWidth,
          ),
          Flexible(
            child: Container(
              color:
                  index == totalLength - 1
                      ? Colors.transparent
                      : (index < activeIndex ? activeBarColor : inActiveBarColor),
              height: barHeight,
            ),
          ),
        ],
      ),
    ];
  }

  List<Widget> getInvertedChildren(BuildContext context) => getChildren(context).reversed.toList();
}
