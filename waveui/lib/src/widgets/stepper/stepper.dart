import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Theme;
import 'package:waveui/src/widgets/stepper/widgets/horizontal_stepper.dart';
import 'package:waveui/src/widgets/stepper/widgets/vertical_stepper.dart';
import 'package:waveui/waveui.dart';

class WaveStepper extends StatelessWidget {
  /// Another stepper is a package, which helps build
  /// customizable and easy to manage steppers.
  ///
  /// The package can be used to build horizontal as well
  /// as vertical steppers just by providing [Axis] in the [stepperDirection] parameter.
  const WaveStepper({
    required this.stepperList,
    required this.stepperDirection,
    super.key,
    this.verticalGap = 40,
    this.activeIndex = 0,
    this.inverted = false,
    this.activeBarColor,
    this.inActiveBarColor,
    this.barThickness = 2,
    this.scrollPhysics,
    this.iconHeight = 20,
    this.iconWidth = 20,
  }) : assert(verticalGap >= 0);

  /// Stepper [List] of type [StepperItem] to render the Stepper on the UI with data
  final List<StepperItem> stepperList;

  /// Gap between the items in the stepper, Default = 40
  /// (Use it to give fixed height of stepper bar when using [Axis.vertical])
  final double verticalGap;

  /// Active index - till which [index] the stepper will be highlighted
  ///
  /// Note : When using the [iconWidget] from [StepperItem] to pass
  /// your custom dotWidget, you need to pass the dotWidget decoration to make it look active.
  /// In the above case only the stepper bar color will change to [activeBarColor]
  final int activeIndex;

  /// Stepper direction takes [Axis]
  /// Use [Axis.horizontal] to get horizontal stepper
  /// Use [Axis.vertical] to get vertical stepper
  final Axis stepperDirection;

  /// Inverts the stepper with text that is being used
  final bool inverted;

  /// Bar color for active step
  final Color? activeBarColor;

  /// Bar color for inactive step
  final Color? inActiveBarColor;

  /// Bar width/thickness/height
  final double barThickness;

  /// Height of [StepperItem.iconWidget]
  ///
  /// Default value = 20
  final double iconHeight;

  /// Width of [StepperItem.iconWidget]
  ///
  /// Default value = 20
  final double iconWidth;

  /// Scroll physics for listview if it is nested with some kind of Scrolling Widget
  final ScrollPhysics? scrollPhysics;

  @override
  Widget build(BuildContext context) {
    var crossAxisAlign = stepperDirection == Axis.horizontal ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    if (inverted) {
      // invert Alignment in case of [Axis.vertical]
      crossAxisAlign = crossAxisAlign == CrossAxisAlignment.end ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    }
    final Iterable<int> iterable = Iterable<int>.generate(stepperList.length);
    return Flex(
      crossAxisAlignment: crossAxisAlign,
      direction: stepperDirection,
      children: iterable.map((index) => _getPreferredStepper(context, index: index)).toList(),
    );
  }

  Widget _getPreferredStepper(BuildContext context, {required int index}) {
    final theme = Theme.of(context);
    if (stepperDirection == Axis.horizontal) {
      return HorizontalStepperItem(
        index: index,
        item: stepperList[index],
        totalLength: stepperList.length,
        activeIndex: activeIndex,
        isInverted: inverted,
        inActiveBarColor: inActiveBarColor ?? theme.colorScheme.outlineStandard,
        activeBarColor: activeBarColor ?? theme.colorScheme.brandPrimary,
        barHeight: barThickness,
        iconHeight: iconHeight,
        iconWidth: iconWidth,
      );
    } else {
      return VerticalStepperItem(
        index: index,
        item: stepperList[index],
        totalLength: stepperList.length,
        gap: verticalGap,
        activeIndex: activeIndex,
        isInverted: inverted,
        inActiveBarColor: inActiveBarColor ?? theme.colorScheme.outlineStandard,
        activeBarColor: activeBarColor ?? theme.colorScheme.brandPrimary,
        barWidth: barThickness,
        iconHeight: iconHeight,
        iconWidth: iconWidth,
      );
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<ScrollPhysics?>('scrollPhysics', scrollPhysics))
      ..add(IterableProperty<StepperItem>('stepperList', stepperList))
      ..add(DoubleProperty('verticalGap', verticalGap))
      ..add(IntProperty('activeIndex', activeIndex))
      ..add(EnumProperty<Axis>('stepperDirection', stepperDirection))
      ..add(DiagnosticsProperty<bool>('inverted', inverted))
      ..add(ColorProperty('activeBarColor', activeBarColor))
      ..add(ColorProperty('inActiveBarColor', inActiveBarColor))
      ..add(DoubleProperty('barThickness', barThickness))
      ..add(DoubleProperty('iconHeight', iconHeight))
      ..add(DoubleProperty('iconWidth', iconWidth));
  }
}
