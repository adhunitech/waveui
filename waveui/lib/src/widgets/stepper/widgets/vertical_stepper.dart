import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:waveui/src/widgets/stepper/widgets/common/dot_provider.dart';
import 'package:waveui/waveui.dart';

class VerticalStepperItem extends StatelessWidget {
  /// Stepper Item to show vertical stepper
  const VerticalStepperItem({
    Key? key,
    required this.item,
    required this.index,
    required this.totalLength,
    required this.gap,
    required this.activeIndex,
    required this.isInverted,
    required this.activeBarColor,
    required this.inActiveBarColor,
    required this.barWidth,
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

  /// Gap between the items in the stepper
  final double gap;

  /// Inverts the stepper with text that is being used
  final bool isInverted;

  /// Bar color for active step
  final Color activeBarColor;

  /// Bar color for inactive step
  final Color inActiveBarColor;

  /// Bar width/thickness
  final double barWidth;

  /// Height of [StepperItem.iconWidget]
  final double iconHeight;

  /// Width of [StepperItem.iconWidget]
  final double iconWidth;

  @override
  Widget build(BuildContext context) => Row(children: isInverted ? getInvertedChildren(context) : getChildren(context));

  List<Widget> getChildren(BuildContext context) {
    final theme = WaveTheme.of(context);
    return [
      Column(
        children: [
          Container(
            color: index == 0 ? Colors.transparent : (index <= activeIndex ? activeBarColor : inActiveBarColor),
            width: barWidth,
            height: gap,
          ),
          DotProvider(
            activeIndex: activeIndex,
            index: index,
            item: item,
            totalLength: totalLength,
            iconHeight: iconHeight,
            iconWidth: iconWidth,
          ),
          Container(
            color:
                index == totalLength - 1
                    ? Colors.transparent
                    : (index < activeIndex ? activeBarColor : inActiveBarColor),
            width: barWidth,
            height: gap,
          ),
        ],
      ),
      const SizedBox(width: 8),
      Expanded(
        child: Column(
          crossAxisAlignment: isInverted ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (item.title != null) ...[DefaultTextStyle(style: theme.textTheme.body, child: item.title!)],
            if (item.subtitle != null) ...[
              const SizedBox(height: 8),
              DefaultTextStyle(
                style: theme.textTheme.small.copyWith(color: theme.colorScheme.textSecondary),
                child: item.subtitle!,
              ),
            ],
          ],
        ),
      ),
    ];
  }

  List<Widget> getInvertedChildren(BuildContext context) => getChildren(context).reversed.toList();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<StepperItem>('item', item))
      ..add(IntProperty('index', index))
      ..add(IntProperty('totalLength', totalLength))
      ..add(IntProperty('activeIndex', activeIndex))
      ..add(DoubleProperty('gap', gap))
      ..add(DiagnosticsProperty<bool>('isInverted', isInverted))
      ..add(ColorProperty('activeBarColor', activeBarColor))
      ..add(ColorProperty('inActiveBarColor', inActiveBarColor))
      ..add(DoubleProperty('barWidth', barWidth))
      ..add(DoubleProperty('iconHeight', iconHeight))
      ..add(DoubleProperty('iconWidth', iconWidth));
  }
}
