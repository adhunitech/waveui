import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Theme;
import 'package:intl/intl.dart';
import 'package:waveui/waveui.dart';

class DateRangeConstraint {
  final DateTime minDate;
  final DateTime maxDate;
  final DateTime? initialDate;

  const DateRangeConstraint({required this.minDate, required this.maxDate, this.initialDate});

  bool isWithin(DateTime date) => !date.isBefore(minDate) && !date.isAfter(maxDate);

  DateTime clamp(DateTime date) {
    if (date.isBefore(minDate)) {
      return minDate;
    }
    if (date.isAfter(maxDate)) {
      return maxDate;
    }
    return date;
  }
}

class CustomWheelDateTimePicker extends StatefulWidget {
  final DateRangeConstraint range;
  final String? title;
  final void Function(DateTime) onDateTimeSelected;
  final bool includeTime;

  const CustomWheelDateTimePicker({
    required this.range,
    required this.onDateTimeSelected,
    this.includeTime = false,
    super.key,
    this.title,
  });

  @override
  State<CustomWheelDateTimePicker> createState() => _CustomWheelDateTimePickerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<DateRangeConstraint>('range', range))
      ..add(ObjectFlagProperty<void Function(DateTime p1)>.has('onDateTimeSelected', onDateTimeSelected))
      ..add(DiagnosticsProperty<bool>('includeTime', includeTime));
  }
}

class _CustomWheelDateTimePickerState extends State<CustomWheelDateTimePicker> {
  late DateTime selectedDateTime;
  late DateTime initialDate;

  late FixedExtentScrollController yearCtrl;
  late FixedExtentScrollController monthCtrl;
  late FixedExtentScrollController dayCtrl;
  late FixedExtentScrollController hourCtrl;
  late FixedExtentScrollController minuteCtrl;

  late List<int> yearList;
  late List<int> monthList;
  late List<int> dayList;
  late List<int> hourList;
  late List<int> minuteList;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    initialDate = widget.range.clamp(DateTime.now());
    selectedDateTime = initialDate;

    yearList = [for (int y = widget.range.minDate.year; y <= widget.range.maxDate.year; y++) y];
    monthList = _computeValidMonths(selectedDateTime.year);
    dayList = _computeValidDays(selectedDateTime.year, selectedDateTime.month);
    hourList = List.generate(24, (i) => i);
    minuteList = List.generate(60, (i) => i);

    yearCtrl = FixedExtentScrollController(initialItem: yearList.indexOf(selectedDateTime.year));
    monthCtrl = FixedExtentScrollController(initialItem: monthList.indexOf(selectedDateTime.month));
    dayCtrl = FixedExtentScrollController(initialItem: dayList.indexOf(selectedDateTime.day));
    hourCtrl = FixedExtentScrollController(initialItem: selectedDateTime.hour);
    minuteCtrl = FixedExtentScrollController(initialItem: selectedDateTime.minute);
  }

  List<int> _computeValidMonths(int year) {
    if (year == widget.range.minDate.year && year == widget.range.maxDate.year) {
      return [for (int m = widget.range.minDate.month; m <= widget.range.maxDate.month; m++) m];
    } else if (year == widget.range.minDate.year) {
      return [for (int m = widget.range.minDate.month; m <= 12; m++) m];
    } else if (year == widget.range.maxDate.year) {
      return [for (int m = 1; m <= widget.range.maxDate.month; m++) m];
    } else {
      return List.generate(12, (i) => i + 1);
    }
  }

  List<int> _computeValidDays(int year, int month) {
    int minDay = 1;
    int maxDay = DateTime(year, month + 1, 0).day;

    if (year == widget.range.minDate.year && month == widget.range.minDate.month) {
      minDay = widget.range.minDate.day;
    }
    if (year == widget.range.maxDate.year && month == widget.range.maxDate.month) {
      maxDay = widget.range.maxDate.day;
    }

    return [for (int d = minDay; d <= maxDay; d++) d];
  }

  void _onScrollChangeDebounced() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 100), _onScrollChange);
  }

  void _onScrollChange() {
    final year = yearList[yearCtrl.selectedItem];
    final months = _computeValidMonths(year);
    final month = months[monthCtrl.selectedItem.clamp(0, months.length - 1)];
    final days = _computeValidDays(year, month);
    final day = days[dayCtrl.selectedItem.clamp(0, days.length - 1)];
    final hour = widget.includeTime ? hourCtrl.selectedItem.clamp(0, 23) : 0;
    final minute = widget.includeTime ? minuteCtrl.selectedItem.clamp(0, 59) : 0;

    final candidate = DateTime(year, month, day, hour, minute);
    final clamped = widget.range.clamp(candidate);

    setState(() {
      selectedDateTime = clamped;
      monthList = months;
      dayList = days;
    });

    if (candidate != clamped) {
      yearCtrl.jumpToItem(yearList.indexOf(clamped.year));
      monthCtrl.jumpToItem(monthList.indexOf(clamped.month));
      dayCtrl.jumpToItem(dayList.indexOf(clamped.day));
      if (widget.includeTime) {
        hourCtrl.jumpToItem(clamped.hour);
        minuteCtrl.jumpToItem(clamped.minute);
      }
    }
  }

  Widget _buildWheel(List<int> values, FixedExtentScrollController controller, String type) {
    final theme = Theme.of(context);
    return Expanded(
      child: ShaderMask(
        shaderCallback:
            (rect) => LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFFFFFFFF).withOpacity(0.00),
                const Color(0xFFFFFFFF).withOpacity(0.05),
                const Color(0xFFFFFFFF),
                const Color(0xFFFFFFFF),
                const Color(0xFFFFFFFF).withOpacity(0.05),
                const Color(0xFFFFFFFF).withOpacity(0.00),
              ],
              stops: const [0.0, 0.1, 0.25, 0.75, 0.9, 1.0],
            ).createShader(rect),
        blendMode: BlendMode.dstIn,
        child: ListWheelScrollView.useDelegate(
          controller: controller,
          itemExtent: 40,
          diameterRatio: 1.2,
          physics: const FixedExtentScrollPhysics(),
          onSelectedItemChanged: (_) => _onScrollChangeDebounced(),
          childDelegate: ListWheelChildBuilderDelegate(
            childCount: values.length,
            builder: (context, index) {
              final isSelected = controller.selectedItem == index;
              String displayValue;
              if (type == 'month') {
                displayValue = DateFormat.MMM(
                  Localizations.localeOf(context).toString(),
                ).format(DateTime(0, values[index]));
              } else {
                displayValue = values[index].toString().padLeft(2, '0');
              }
              return Center(
                child: Text(
                  displayValue,
                  style: theme.textTheme.body.copyWith(
                    fontSize: 18,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected ? theme.colorScheme.brandPrimary : theme.colorScheme.textSecondary,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isChanged = selectedDateTime != initialDate;
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfacePrimary,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(widget.title ?? 'Select Date', style: Theme.of(context).textTheme.h4),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(WaveIcons.dismiss_24_regular),
                ),
              ],
            ),
            SizedBox(
              height: widget.includeTime ? 300 : 250,
              child: Row(
                children: [
                  _buildWheel(yearList, yearCtrl, 'year'),
                  _buildWheel(monthList, monthCtrl, 'month'),
                  _buildWheel(dayList, dayCtrl, 'day'),
                  if (widget.includeTime) _buildWheel(hourList, hourCtrl, 'hour'),
                  if (widget.includeTime) _buildWheel(minuteList, minuteCtrl, 'minute'),
                ],
              ),
            ),
            WaveButton(
              text: 'Confirm',
              onTap:
                  !isChanged
                      ? null
                      : () {
                        widget.onDateTimeSelected(selectedDateTime);
                        Navigator.of(context).pop();
                      },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    yearCtrl.dispose();
    monthCtrl.dispose();
    dayCtrl.dispose();
    if (widget.includeTime) {
      hourCtrl.dispose();
      minuteCtrl.dispose();
    }
    super.dispose();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<DateTime>('selectedDateTime', selectedDateTime))
      ..add(DiagnosticsProperty<DateTime>('initialDate', initialDate))
      ..add(DiagnosticsProperty<FixedExtentScrollController>('yearCtrl', yearCtrl))
      ..add(DiagnosticsProperty<FixedExtentScrollController>('monthCtrl', monthCtrl))
      ..add(DiagnosticsProperty<FixedExtentScrollController>('dayCtrl', dayCtrl))
      ..add(DiagnosticsProperty<FixedExtentScrollController>('hourCtrl', hourCtrl))
      ..add(DiagnosticsProperty<FixedExtentScrollController>('minuteCtrl', minuteCtrl))
      ..add(IterableProperty<int>('yearList', yearList))
      ..add(IterableProperty<int>('monthList', monthList))
      ..add(IterableProperty<int>('dayList', dayList))
      ..add(IterableProperty<int>('hourList', hourList))
      ..add(IterableProperty<int>('minuteList', minuteList));
  }
}

Future<void> showWaveDatePicker({
  required BuildContext context,
  required DateRangeConstraint range,
  required void Function(DateTime) onDateSelected,
  String? title,
}) async {
  var theme = Theme.of(context);
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: theme.colorScheme.surfacePrimary,
    builder:
        (_) => CustomWheelDateTimePicker(
          range: range,
          onDateTimeSelected: onDateSelected,
          includeTime: false,
          title: title ?? 'Select Date',
        ),
  );
}

Future<void> showWaveDateTimePicker({
  required BuildContext context,
  required DateRangeConstraint range,
  required void Function(DateTime) onDateTimeSelected,
  String? title,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder:
        (_) => CustomWheelDateTimePicker(
          range: range,
          onDateTimeSelected: onDateTimeSelected,
          includeTime: true,
          title: title ?? 'Select Date and Time',
        ),
  );
}
