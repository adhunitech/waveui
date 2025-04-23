import 'package:flutter/material.dart';
import 'package:waveui/waveui.dart';

import 'package:waveui/src/widgets/date_time_picker/board_datetime_options.dart';
import 'package:waveui/src/widgets/date_time_picker/utils/board_enum.dart';

extension BoardDateTimeOptionsExtension on BoardDateTimeOptions {
  Color getBackgroundColor(BuildContext context) =>
      backgroundColor ?? WaveApp.themeOf(context).colorScheme.contentPrimary;

  Color getForegroundColor(BuildContext context) =>
      foregroundColor ?? WaveApp.themeOf(context).colorScheme.contentPrimary;

  Color? getTextColor(BuildContext context) => textColor ?? WaveApp.themeOf(context).colorScheme.labelPrimary;

  Color getActiveColor(BuildContext context) => activeColor ?? WaveApp.themeOf(context).colorScheme.primary;

  Color getActiveTextColor(BuildContext context) => activeTextColor ?? Colors.white;

  bool get isTopTitleHeader => (boardTitleBuilder != null || boardTitle != null) && showDateButton;

  /// Obtain the title to be displayed on the item.
  /// Correct with default value only if it exists in the middle.
  String? getSubTitle(DateType type) {
    if (pickerSubTitles == null || pickerSubTitles!.notSpecified) {
      return null;
    }

    switch (type) {
      case DateType.year:
        return pickerSubTitles?.year ?? 'Year';
      case DateType.month:
        return pickerSubTitles?.month ?? 'Month';
      case DateType.day:
        return pickerSubTitles?.day ?? 'Day';
      case DateType.hour:
        return pickerSubTitles?.hour ?? 'Hour';
      case DateType.minute:
        return pickerSubTitles?.minute ?? 'Minute';
      case DateType.second:
        return pickerSubTitles?.second ?? 'Second';
    }
  }
}
