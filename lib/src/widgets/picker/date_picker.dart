library;

import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide CalendarDatePicker, DatePickerDialog;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:waveui/src/widgets/picker/calendar_date_picker.dart';
import 'package:waveui/waveui.dart';

const Size _calendarPortraitDialogSizeM3 = Size(328.0, 512.0);
const Size _calendarLandscapeDialogSize = Size(496.0, 346.0);
const Size _inputPortraitDialogSizeM2 = Size(330.0, 270.0);
const Size _inputPortraitDialogSizeM3 = Size(328.0, 270.0);
const Size _inputLandscapeDialogSize = Size(496, 160.0);
const Size _inputRangeLandscapeDialogSize = Size(496, 164.0);
const Duration _dialogSizeAnimationDuration = Duration(milliseconds: 200);
const double _inputFormPortraitHeight = 98.0;
const double _inputFormLandscapeHeight = 108.0;

const double _kMaxTextScaleFactor = 3.0;

const double _kMaxRangeTextScaleFactor = 1.3;

const double _kMaxHeaderTextScaleFactor = 1.6;

const double _kMaxHeaderWithEntryTextScaleFactor = 1.4;

const double _kMaxHelpPortraitTextScaleFactor = 1.6;
const double _kMaxHelpLandscapeTextScaleFactor = 1.4;

const double _fontSizeToScale = 14.0;

Future<DateTime?> showWaveDatePicker({
  required BuildContext context,
  required DateTime firstDate,
  required DateTime lastDate,
  DateTime? initialDate,
  DateTime? currentDate,
  DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
  SelectableDayPredicate? selectableDayPredicate,
  String? helpText,
  String? cancelText,
  String? confirmText,
  Locale? locale,
  bool barrierDismissible = true,
  String? barrierLabel,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  TextDirection? textDirection,
  TransitionBuilder? builder,
  DatePickerMode initialDatePickerMode = DatePickerMode.day,
  String? errorFormatText,
  String? errorInvalidText,
  String? fieldHintText,
  String? fieldLabelText,
  TextInputType? keyboardType,
  Offset? anchorPoint,
  final ValueChanged<DatePickerEntryMode>? onDatePickerModeChange,
  final Icon? switchToInputEntryModeIcon,
  final Icon? switchToCalendarEntryModeIcon,
}) async {
  initialDate = initialDate == null ? null : DateUtils.dateOnly(initialDate);
  firstDate = DateUtils.dateOnly(firstDate);
  lastDate = DateUtils.dateOnly(lastDate);
  assert(!lastDate.isBefore(firstDate), 'lastDate $lastDate must be on or after firstDate $firstDate.');
  assert(
    initialDate == null || !initialDate.isBefore(firstDate),
    'initialDate $initialDate must be on or after firstDate $firstDate.',
  );
  assert(
    initialDate == null || !initialDate.isAfter(lastDate),
    'initialDate $initialDate must be on or before lastDate $lastDate.',
  );
  assert(
    selectableDayPredicate == null || initialDate == null || selectableDayPredicate(initialDate),
    'Provided initialDate $initialDate must satisfy provided selectableDayPredicate.',
  );
  assert(debugCheckHasMaterialLocalizations(context));

  Widget dialog = BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
    child: Container(
      width: double.infinity,
      height: double.infinity,

      child: Center(
        child: DatePickerDialog(
          initialDate: initialDate,
          firstDate: firstDate,
          lastDate: lastDate,
          currentDate: currentDate,
          initialEntryMode: initialEntryMode,
          selectableDayPredicate: selectableDayPredicate,
          helpText: helpText,
          cancelText: cancelText,
          confirmText: confirmText,
          initialCalendarMode: initialDatePickerMode,
          errorFormatText: errorFormatText,
          errorInvalidText: errorInvalidText,
          fieldHintText: fieldHintText,
          fieldLabelText: fieldLabelText,
          keyboardType: keyboardType,
          onDatePickerModeChange: onDatePickerModeChange,
          switchToInputEntryModeIcon: switchToInputEntryModeIcon,
          switchToCalendarEntryModeIcon: switchToCalendarEntryModeIcon,
        ),
      ),
    ),
  );

  if (textDirection != null) {
    dialog = Directionality(textDirection: textDirection, child: dialog);
  }

  if (locale != null) {
    dialog = Localizations.override(context: context, locale: locale, child: dialog);
  } else {
    final DatePickerThemeData datePickerTheme = DatePickerTheme.of(context);
    if (datePickerTheme.locale != null) {
      dialog = Localizations.override(context: context, locale: datePickerTheme.locale, child: dialog);
    }
  }

  return showDialog<DateTime>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: Colors.transparent,
    barrierLabel: barrierLabel,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    builder: (context) => builder == null ? dialog : builder(context, dialog),
    anchorPoint: anchorPoint,
  );
}

class DatePickerDialog extends StatefulWidget {
  DatePickerDialog({
    required DateTime firstDate,
    required DateTime lastDate,
    super.key,
    DateTime? initialDate,
    DateTime? currentDate,
    this.initialEntryMode = DatePickerEntryMode.calendar,
    this.selectableDayPredicate,
    this.cancelText,
    this.confirmText,
    this.helpText,
    this.initialCalendarMode = DatePickerMode.day,
    this.errorFormatText,
    this.errorInvalidText,
    this.fieldHintText,
    this.fieldLabelText,
    this.keyboardType,
    this.restorationId,
    this.onDatePickerModeChange,
    this.switchToInputEntryModeIcon,
    this.switchToCalendarEntryModeIcon,
    this.insetPadding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
  }) : initialDate = initialDate == null ? null : DateUtils.dateOnly(initialDate),
       firstDate = DateUtils.dateOnly(firstDate),
       lastDate = DateUtils.dateOnly(lastDate),
       currentDate = DateUtils.dateOnly(currentDate ?? DateTime.now()) {
    assert(
      !this.lastDate.isBefore(this.firstDate),
      'lastDate ${this.lastDate} must be on or after firstDate ${this.firstDate}.',
    );
    assert(
      initialDate == null || !this.initialDate!.isBefore(this.firstDate),
      'initialDate ${this.initialDate} must be on or after firstDate ${this.firstDate}.',
    );
    assert(
      initialDate == null || !this.initialDate!.isAfter(this.lastDate),
      'initialDate ${this.initialDate} must be on or before lastDate ${this.lastDate}.',
    );
    assert(
      selectableDayPredicate == null || initialDate == null || selectableDayPredicate!(this.initialDate!),
      'Provided initialDate ${this.initialDate} must satisfy provided selectableDayPredicate',
    );
  }

  final DateTime? initialDate;

  final DateTime firstDate;

  final DateTime lastDate;

  final DateTime currentDate;

  final DatePickerEntryMode initialEntryMode;

  final SelectableDayPredicate? selectableDayPredicate;

  final String? cancelText;

  final String? confirmText;

  final String? helpText;

  final DatePickerMode initialCalendarMode;

  final String? errorFormatText;

  final String? errorInvalidText;

  final String? fieldHintText;

  final String? fieldLabelText;

  final TextInputType? keyboardType;

  final String? restorationId;

  final ValueChanged<DatePickerEntryMode>? onDatePickerModeChange;

  final Icon? switchToInputEntryModeIcon;

  final Icon? switchToCalendarEntryModeIcon;

  final EdgeInsets insetPadding;

  @override
  State<DatePickerDialog> createState() => _DatePickerDialogState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<DateTime?>('initialDate', initialDate))
      ..add(DiagnosticsProperty<DateTime>('firstDate', firstDate))
      ..add(DiagnosticsProperty<DateTime>('lastDate', lastDate))
      ..add(DiagnosticsProperty<DateTime>('currentDate', currentDate))
      ..add(EnumProperty<DatePickerEntryMode>('initialEntryMode', initialEntryMode))
      ..add(ObjectFlagProperty<SelectableDayPredicate?>.has('selectableDayPredicate', selectableDayPredicate))
      ..add(StringProperty('cancelText', cancelText))
      ..add(StringProperty('confirmText', confirmText))
      ..add(StringProperty('helpText', helpText))
      ..add(EnumProperty<DatePickerMode>('initialCalendarMode', initialCalendarMode))
      ..add(StringProperty('errorFormatText', errorFormatText))
      ..add(StringProperty('errorInvalidText', errorInvalidText))
      ..add(StringProperty('fieldHintText', fieldHintText))
      ..add(StringProperty('fieldLabelText', fieldLabelText))
      ..add(DiagnosticsProperty<TextInputType?>('keyboardType', keyboardType))
      ..add(StringProperty('restorationId', restorationId))
      ..add(
        ObjectFlagProperty<ValueChanged<DatePickerEntryMode>?>.has('onDatePickerModeChange', onDatePickerModeChange),
      )
      ..add(DiagnosticsProperty<EdgeInsets>('insetPadding', insetPadding));
  }
}

class _DatePickerDialogState extends State<DatePickerDialog> with RestorationMixin {
  late final RestorableDateTimeN _selectedDate = RestorableDateTimeN(widget.initialDate);
  late final _RestorableDatePickerEntryMode _entryMode = _RestorableDatePickerEntryMode(widget.initialEntryMode);
  final _RestorableAutovalidateMode _autovalidateMode = _RestorableAutovalidateMode(AutovalidateMode.disabled);

  @override
  void dispose() {
    _selectedDate.dispose();
    _entryMode.dispose();
    _autovalidateMode.dispose();
    super.dispose();
  }

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(_autovalidateMode, 'autovalidateMode');
    registerForRestoration(_entryMode, 'calendar_entry_mode');
  }

  final GlobalKey _calendarPickerKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _handleOk() {
    if (_entryMode.value == DatePickerEntryMode.input || _entryMode.value == DatePickerEntryMode.inputOnly) {
      final FormState form = _formKey.currentState!;
      if (!form.validate()) {
        setState(() => _autovalidateMode.value = AutovalidateMode.always);
        return;
      }
      form.save();
    }
    Navigator.pop(context, _selectedDate.value);
  }

  void _handleCancel() {
    Navigator.pop(context);
  }

  void _handleOnDatePickerModeChange() {
    widget.onDatePickerModeChange?.call(_entryMode.value);
  }

  void _handleEntryModeToggle() {
    setState(() {
      switch (_entryMode.value) {
        case DatePickerEntryMode.calendar:
          _autovalidateMode.value = AutovalidateMode.disabled;
          _entryMode.value = DatePickerEntryMode.input;
          _handleOnDatePickerModeChange();
        case DatePickerEntryMode.input:
          _formKey.currentState!.save();
          _entryMode.value = DatePickerEntryMode.calendar;
          _handleOnDatePickerModeChange();
        case DatePickerEntryMode.calendarOnly:
        case DatePickerEntryMode.inputOnly:
          assert(false, 'Can not change entry mode from ${_entryMode.value}');
      }
    });
  }

  void _handleDateChanged(DateTime date) {
    setState(() => _selectedDate.value = date);
  }

  Size _dialogSize(BuildContext context) {
    final bool isCalendar = switch (_entryMode.value) {
      DatePickerEntryMode.calendar || DatePickerEntryMode.calendarOnly => true,
      DatePickerEntryMode.input || DatePickerEntryMode.inputOnly => false,
    };
    final Orientation orientation = MediaQuery.orientationOf(context);

    return switch ((isCalendar, orientation)) {
      (true, Orientation.portrait) => _calendarPortraitDialogSizeM3,
      (false, Orientation.portrait) => _inputPortraitDialogSizeM3,
      (true, Orientation.landscape) => _calendarLandscapeDialogSize,
      (false, Orientation.landscape) => _inputLandscapeDialogSize,
    };
  }

  static const Map<ShortcutActivator, Intent> _formShortcutMap = <ShortcutActivator, Intent>{
    SingleActivator(LogicalKeyboardKey.enter): NextFocusIntent(),
  };

  @override
  Widget build(BuildContext context) {
    final theme = WaveApp.themeOf(context);
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final Orientation orientation = MediaQuery.orientationOf(context);

    var headlineStyle = theme.textTheme.small;
    switch (_entryMode.value) {
      case DatePickerEntryMode.input:
      case DatePickerEntryMode.inputOnly:
        if (orientation == Orientation.landscape) {
          headlineStyle = theme.textTheme.small;
        }
      case DatePickerEntryMode.calendar:
      case DatePickerEntryMode.calendarOnly:
    }

    final Widget actions = Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Row(
        spacing: 8,
        children: <Widget>[
          Expanded(
            child: WaveButton(
              type: WaveButtonType.outline,
              onTap: _handleCancel,
              text: widget.cancelText ?? localizations.cancelButtonLabel,
            ),
          ),
          Expanded(child: WaveButton(onTap: _handleOk, text: widget.confirmText ?? localizations.okButtonLabel)),
        ],
      ),
    );

    CalendarDatePicker calendarDatePicker() => CalendarDatePicker(
      key: _calendarPickerKey,
      initialDate: _selectedDate.value,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      currentDate: widget.currentDate,
      onDateChanged: _handleDateChanged,
      selectableDayPredicate: widget.selectableDayPredicate,
      initialCalendarMode: widget.initialCalendarMode,
    );

    Form inputDatePicker() => Form(
      key: _formKey,
      autovalidateMode: _autovalidateMode.value,
      child: SizedBox(
        height: orientation == Orientation.portrait ? _inputFormPortraitHeight : _inputFormLandscapeHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Shortcuts(
            shortcuts: _formShortcutMap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: MediaQuery.withClampedTextScaling(
                    maxScaleFactor: 2.0,
                    child: InputDatePickerFormField(
                      initialDate: _selectedDate.value,
                      firstDate: widget.firstDate,
                      lastDate: widget.lastDate,
                      onDateSubmitted: _handleDateChanged,
                      onDateSaved: _handleDateChanged,
                      selectableDayPredicate: widget.selectableDayPredicate,
                      errorFormatText: widget.errorFormatText,
                      errorInvalidText: widget.errorInvalidText,
                      fieldHintText: widget.fieldHintText,
                      fieldLabelText: widget.fieldLabelText,
                      keyboardType: widget.keyboardType,
                      autofocus: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    final Widget picker;
    final Widget? entryModeButton;
    switch (_entryMode.value) {
      case DatePickerEntryMode.calendar:
        picker = calendarDatePicker();
        entryModeButton = IconButton(
          icon: widget.switchToInputEntryModeIcon ?? const Icon(WaveIcons.edit_24_regular),
          tooltip: localizations.inputDateModeButtonLabel,
          onPressed: _handleEntryModeToggle,
        );

      case DatePickerEntryMode.calendarOnly:
        picker = calendarDatePicker();
        entryModeButton = null;

      case DatePickerEntryMode.input:
        picker = inputDatePicker();
        entryModeButton = IconButton(
          icon: widget.switchToCalendarEntryModeIcon ?? const Icon(WaveIcons.calendar_24_regular),
          tooltip: localizations.calendarModeButtonLabel,
          onPressed: _handleEntryModeToggle,
        );

      case DatePickerEntryMode.inputOnly:
        picker = inputDatePicker();
        entryModeButton = null;
    }

    final Widget header = _DatePickerHeader(
      helpText: widget.helpText ?? localizations.datePickerHelpText,
      titleText: _selectedDate.value == null ? '' : localizations.formatMediumDate(_selectedDate.value!),
      titleStyle: headlineStyle,
      orientation: orientation,
      isShort: orientation == Orientation.landscape,
      entryModeButton: entryModeButton,
    );

    final double textScaleFactor =
        MediaQuery.textScalerOf(context).clamp(maxScaleFactor: _kMaxTextScaleFactor).scale(_fontSizeToScale) /
        _fontSizeToScale;
    final Size dialogSize = _dialogSize(context) * textScaleFactor;
    return Dialog(
      backgroundColor: theme.colorScheme.contentPrimary,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: widget.insetPadding,
      clipBehavior: Clip.antiAlias,
      child: AnimatedContainer(
        width: dialogSize.width,
        height: dialogSize.height,
        duration: _dialogSizeAnimationDuration,
        curve: Curves.easeIn,
        child: MediaQuery.withClampedTextScaling(
          maxScaleFactor: _kMaxTextScaleFactor,
          child: LayoutBuilder(
            builder: (context, constraints) {
              const Size portraitDialogSize = _inputPortraitDialogSizeM3;

              final bool isFullyPortrait =
                  constraints.maxHeight >= math.min(dialogSize.height, portraitDialogSize.height);

              switch (orientation) {
                case Orientation.portrait:
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      header,
                      Divider(height: 0, color: theme.colorScheme.divider),
                      if (isFullyPortrait) ...<Widget>[Expanded(child: picker), actions],
                    ],
                  );
                case Orientation.landscape:
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      header,
                      VerticalDivider(width: 0, color: theme.colorScheme.divider),
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[Expanded(child: picker), actions],
                        ),
                      ),
                    ],
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}

class _RestorableDatePickerEntryMode extends RestorableValue<DatePickerEntryMode> {
  _RestorableDatePickerEntryMode(DatePickerEntryMode defaultValue) : _defaultValue = defaultValue;

  final DatePickerEntryMode _defaultValue;

  @override
  DatePickerEntryMode createDefaultValue() => _defaultValue;

  @override
  void didUpdateValue(DatePickerEntryMode? oldValue) {
    assert(debugIsSerializableForRestoration(value.index));
    notifyListeners();
  }

  @override
  DatePickerEntryMode fromPrimitives(Object? data) => DatePickerEntryMode.values[data! as int];

  @override
  Object? toPrimitives() => value.index;
}

class _RestorableAutovalidateMode extends RestorableValue<AutovalidateMode> {
  _RestorableAutovalidateMode(AutovalidateMode defaultValue) : _defaultValue = defaultValue;

  final AutovalidateMode _defaultValue;

  @override
  AutovalidateMode createDefaultValue() => _defaultValue;

  @override
  void didUpdateValue(AutovalidateMode? oldValue) {
    assert(debugIsSerializableForRestoration(value.index));
    notifyListeners();
  }

  @override
  AutovalidateMode fromPrimitives(Object? data) => AutovalidateMode.values[data! as int];

  @override
  Object? toPrimitives() => value.index;
}

class _DatePickerHeader extends StatelessWidget {
  const _DatePickerHeader({
    required this.helpText,
    required this.titleText,
    required this.titleStyle,
    required this.orientation,
    this.titleSemanticsLabel,
    this.isShort = false,
    this.entryModeButton,
  });

  static const double _datePickerHeaderLandscapeWidth = 152.0;
  static const double _datePickerHeaderPortraitHeight = 120.0;
  static const double _headerPaddingLandscape = 16.0;

  final String helpText;

  final String titleText;

  final String? titleSemanticsLabel;

  final TextStyle? titleStyle;

  final Orientation orientation;

  final bool isShort;

  final Widget? entryModeButton;

  @override
  Widget build(BuildContext context) {
    final DatePickerThemeData datePickerTheme = DatePickerTheme.of(context);
    final DatePickerThemeData defaults = DatePickerTheme.defaults(context);
    final Color? backgroundColor = datePickerTheme.headerBackgroundColor ?? defaults.headerBackgroundColor;
    final Color? foregroundColor = datePickerTheme.headerForegroundColor ?? defaults.headerForegroundColor;
    final TextStyle? helpStyle = (datePickerTheme.headerHelpStyle ?? defaults.headerHelpStyle)?.copyWith(
      color: foregroundColor,
    );
    final double currentScale = MediaQuery.textScalerOf(context).scale(_fontSizeToScale) / _fontSizeToScale;
    final double maxHeaderTextScaleFactor = math.min(
      currentScale,
      entryModeButton != null ? _kMaxHeaderWithEntryTextScaleFactor : _kMaxHeaderTextScaleFactor,
    );
    final double textScaleFactor =
        MediaQuery.textScalerOf(context).clamp(maxScaleFactor: maxHeaderTextScaleFactor).scale(_fontSizeToScale) /
        _fontSizeToScale;
    final double scaledFontSize = MediaQuery.textScalerOf(context).scale(titleStyle?.fontSize ?? 32);
    final double headerScaleFactor = textScaleFactor > 1 ? textScaleFactor : 1.0;

    final Text help = Text(
      helpText,
      style: helpStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textScaler: MediaQuery.textScalerOf(context).clamp(
        maxScaleFactor: math.min(
          textScaleFactor,
          orientation == Orientation.portrait ? _kMaxHelpPortraitTextScaleFactor : _kMaxHelpLandscapeTextScaleFactor,
        ),
      ),
    );
    final Text title = Text(
      titleText,
      semanticsLabel: titleSemanticsLabel ?? titleText,
      style: titleStyle,
      maxLines:
          orientation == Orientation.portrait
              ? (scaledFontSize > 70 ? 2 : 1)
              : scaledFontSize > 40
              ? 3
              : 2,
      overflow: TextOverflow.ellipsis,
      textScaler: MediaQuery.textScalerOf(context).clamp(maxScaleFactor: textScaleFactor),
    );

    final double fontScaleAdjustedHeaderHeight = headerScaleFactor > 1.3 ? headerScaleFactor - 0.2 : 1.0;

    switch (orientation) {
      case Orientation.portrait:
        return Semantics(
          container: true,
          child: SizedBox(
            height: _datePickerHeaderPortraitHeight * fontScaleAdjustedHeaderHeight,
            child: Material(
              color: backgroundColor,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(start: 24, end: 12, bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 16),
                    help,
                    const Flexible(child: SizedBox(height: 38)),
                    Row(
                      children: <Widget>[
                        Expanded(child: title),
                        if (entryModeButton != null) Semantics(container: true, child: entryModeButton),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      case Orientation.landscape:
        return Semantics(
          container: true,
          child: SizedBox(
            width: _datePickerHeaderLandscapeWidth,
            child: Material(
              color: backgroundColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 16),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: _headerPaddingLandscape), child: help),
                  SizedBox(height: isShort ? 16 : 56),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: _headerPaddingLandscape),
                      child: title,
                    ),
                  ),
                  if (entryModeButton != null)
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 8.0, end: 4.0, bottom: 6.0),
                      child: Semantics(container: true, child: entryModeButton),
                    ),
                ],
              ),
            ),
          ),
        );
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('helpText', helpText))
      ..add(StringProperty('titleText', titleText))
      ..add(StringProperty('titleSemanticsLabel', titleSemanticsLabel))
      ..add(DiagnosticsProperty<TextStyle?>('titleStyle', titleStyle))
      ..add(EnumProperty<Orientation>('orientation', orientation))
      ..add(DiagnosticsProperty<bool>('isShort', isShort));
  }
}

typedef SelectableDayForRangePredicate =
    bool Function(DateTime day, DateTime? selectedStartDay, DateTime? selectedEndDay);

Future<DateTimeRange?> showWaveDateRangePicker({
  required BuildContext context,
  required DateTime firstDate,
  required DateTime lastDate,
  DateTimeRange? initialDateRange,
  DateTime? currentDate,
  DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
  String? helpText,
  String? cancelText,
  String? confirmText,
  String? saveText,
  String? errorFormatText,
  String? errorInvalidText,
  String? errorInvalidRangeText,
  String? fieldStartHintText,
  String? fieldEndHintText,
  String? fieldStartLabelText,
  String? fieldEndLabelText,
  Locale? locale,
  bool barrierDismissible = true,
  Color? barrierColor,
  String? barrierLabel,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  TextDirection? textDirection,
  TransitionBuilder? builder,
  Offset? anchorPoint,
  TextInputType keyboardType = TextInputType.datetime,
  final Icon? switchToInputEntryModeIcon,
  final Icon? switchToCalendarEntryModeIcon,
  SelectableDayForRangePredicate? selectableDayPredicate,
}) async {
  initialDateRange = initialDateRange == null ? null : DateUtils.datesOnly(initialDateRange);
  firstDate = DateUtils.dateOnly(firstDate);
  lastDate = DateUtils.dateOnly(lastDate);
  assert(!lastDate.isBefore(firstDate), 'lastDate $lastDate must be on or after firstDate $firstDate.');
  assert(
    initialDateRange == null || !initialDateRange.start.isBefore(firstDate),
    "initialDateRange's start date must be on or after firstDate $firstDate.",
  );
  assert(
    initialDateRange == null || !initialDateRange.end.isBefore(firstDate),
    "initialDateRange's end date must be on or after firstDate $firstDate.",
  );
  assert(
    initialDateRange == null || !initialDateRange.start.isAfter(lastDate),
    "initialDateRange's start date must be on or before lastDate $lastDate.",
  );
  assert(
    initialDateRange == null || !initialDateRange.end.isAfter(lastDate),
    "initialDateRange's end date must be on or before lastDate $lastDate.",
  );
  assert(
    initialDateRange == null ||
        selectableDayPredicate == null ||
        selectableDayPredicate(initialDateRange.start, initialDateRange.start, initialDateRange.end),
    "initialDateRange's start date must be selectable.",
  );
  assert(
    initialDateRange == null ||
        selectableDayPredicate == null ||
        selectableDayPredicate(initialDateRange.end, initialDateRange.start, initialDateRange.end),
    "initialDateRange's end date must be selectable.",
  );
  currentDate = DateUtils.dateOnly(currentDate ?? DateTime.now());
  assert(debugCheckHasMaterialLocalizations(context));

  Widget dialog = DateRangePickerDialog(
    initialDateRange: initialDateRange,
    firstDate: firstDate,
    lastDate: lastDate,
    currentDate: currentDate,
    selectableDayPredicate: selectableDayPredicate,
    initialEntryMode: initialEntryMode,
    helpText: helpText,
    cancelText: cancelText,
    confirmText: confirmText,
    saveText: saveText,
    errorFormatText: errorFormatText,
    errorInvalidText: errorInvalidText,
    errorInvalidRangeText: errorInvalidRangeText,
    fieldStartHintText: fieldStartHintText,
    fieldEndHintText: fieldEndHintText,
    fieldStartLabelText: fieldStartLabelText,
    fieldEndLabelText: fieldEndLabelText,
    keyboardType: keyboardType,
    switchToInputEntryModeIcon: switchToInputEntryModeIcon,
    switchToCalendarEntryModeIcon: switchToCalendarEntryModeIcon,
  );

  if (textDirection != null) {
    dialog = Directionality(textDirection: textDirection, child: dialog);
  }

  if (locale != null) {
    dialog = Localizations.override(context: context, locale: locale, child: dialog);
  }

  return showDialog<DateTimeRange>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    barrierLabel: barrierLabel,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    useSafeArea: false,
    builder: (context) => builder == null ? dialog : builder(context, dialog),
    anchorPoint: anchorPoint,
  );
}

String _formatRangeStartDate(MaterialLocalizations localizations, DateTime? startDate, DateTime? endDate) =>
    startDate == null
        ? localizations.dateRangeStartLabel
        : (endDate == null || startDate.year == endDate.year)
        ? localizations.formatShortMonthDay(startDate)
        : localizations.formatShortDate(startDate);

String _formatRangeEndDate(
  MaterialLocalizations localizations,
  DateTime? startDate,
  DateTime? endDate,
  DateTime currentDate,
) =>
    endDate == null
        ? localizations.dateRangeEndLabel
        : (startDate != null && startDate.year == endDate.year && startDate.year == currentDate.year)
        ? localizations.formatShortMonthDay(endDate)
        : localizations.formatShortDate(endDate);

class DateRangePickerDialog extends StatefulWidget {
  const DateRangePickerDialog({
    required this.firstDate,
    required this.lastDate,
    super.key,
    this.initialDateRange,
    this.currentDate,
    this.initialEntryMode = DatePickerEntryMode.calendar,
    this.helpText,
    this.cancelText,
    this.confirmText,
    this.saveText,
    this.errorInvalidRangeText,
    this.errorFormatText,
    this.errorInvalidText,
    this.fieldStartHintText,
    this.fieldEndHintText,
    this.fieldStartLabelText,
    this.fieldEndLabelText,
    this.keyboardType = TextInputType.datetime,
    this.restorationId,
    this.switchToInputEntryModeIcon,
    this.switchToCalendarEntryModeIcon,
    this.selectableDayPredicate,
  });

  final DateTimeRange? initialDateRange;

  final DateTime firstDate;

  final DateTime lastDate;

  final DateTime? currentDate;

  final DatePickerEntryMode initialEntryMode;

  final String? cancelText;

  final String? confirmText;

  final String? saveText;

  final String? helpText;

  final String? errorInvalidRangeText;

  final String? errorFormatText;

  final String? errorInvalidText;

  final String? fieldStartHintText;

  final String? fieldEndHintText;

  final String? fieldStartLabelText;

  final String? fieldEndLabelText;

  final TextInputType keyboardType;

  final String? restorationId;

  final Icon? switchToInputEntryModeIcon;

  final Icon? switchToCalendarEntryModeIcon;

  final SelectableDayForRangePredicate? selectableDayPredicate;

  @override
  State<DateRangePickerDialog> createState() => _DateRangePickerDialogState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<DateTime>('firstDate', firstDate));
    properties.add(DiagnosticsProperty<DateTime>('lastDate', lastDate));
    properties.add(DiagnosticsProperty<DateTime?>('currentDate', currentDate));
    properties.add(EnumProperty<DatePickerEntryMode>('initialEntryMode', initialEntryMode));
    properties.add(StringProperty('cancelText', cancelText));
    properties.add(StringProperty('confirmText', confirmText));
    properties.add(StringProperty('saveText', saveText));
    properties.add(StringProperty('helpText', helpText));
    properties.add(StringProperty('errorInvalidRangeText', errorInvalidRangeText));
    properties.add(StringProperty('errorFormatText', errorFormatText));
    properties.add(StringProperty('errorInvalidText', errorInvalidText));
    properties.add(StringProperty('fieldStartHintText', fieldStartHintText));
    properties.add(StringProperty('fieldEndHintText', fieldEndHintText));
    properties.add(StringProperty('fieldStartLabelText', fieldStartLabelText));
    properties.add(StringProperty('fieldEndLabelText', fieldEndLabelText));
    properties.add(DiagnosticsProperty<TextInputType>('keyboardType', keyboardType));
    properties.add(StringProperty('restorationId', restorationId));
    properties.add(
      ObjectFlagProperty<SelectableDayForRangePredicate?>.has('selectableDayPredicate', selectableDayPredicate),
    );
  }
}

class _DateRangePickerDialogState extends State<DateRangePickerDialog> with RestorationMixin {
  late final _RestorableDatePickerEntryMode _entryMode = _RestorableDatePickerEntryMode(widget.initialEntryMode);
  late final RestorableDateTimeN _selectedStart = RestorableDateTimeN(widget.initialDateRange?.start);
  late final RestorableDateTimeN _selectedEnd = RestorableDateTimeN(widget.initialDateRange?.end);
  final RestorableBool _autoValidate = RestorableBool(false);
  final GlobalKey _calendarPickerKey = GlobalKey();
  final GlobalKey<_InputDateRangePickerState> _inputPickerKey = GlobalKey<_InputDateRangePickerState>();

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_entryMode, 'entry_mode');
    registerForRestoration(_selectedStart, 'selected_start');
    registerForRestoration(_selectedEnd, 'selected_end');
    registerForRestoration(_autoValidate, 'autovalidate');
  }

  @override
  void dispose() {
    _entryMode.dispose();
    _selectedStart.dispose();
    _selectedEnd.dispose();
    _autoValidate.dispose();
    super.dispose();
  }

  void _handleOk() {
    if (_entryMode.value == DatePickerEntryMode.input || _entryMode.value == DatePickerEntryMode.inputOnly) {
      final _InputDateRangePickerState picker = _inputPickerKey.currentState!;
      if (!picker.validate()) {
        setState(() {
          _autoValidate.value = true;
        });
        return;
      }
    }
    final DateTimeRange? selectedRange =
        _hasSelectedDateRange ? DateTimeRange(start: _selectedStart.value!, end: _selectedEnd.value!) : null;

    Navigator.pop(context, selectedRange);
  }

  void _handleCancel() {
    Navigator.pop(context);
  }

  void _handleEntryModeToggle() {
    setState(() {
      switch (_entryMode.value) {
        case DatePickerEntryMode.calendar:
          _autoValidate.value = false;
          _entryMode.value = DatePickerEntryMode.input;

        case DatePickerEntryMode.input:
          if (_selectedStart.value != null &&
              _selectedEnd.value != null &&
              _selectedStart.value!.isAfter(_selectedEnd.value!)) {
            _selectedEnd.value = null;
          }
          if (_selectedStart.value != null && !_isDaySelectable(_selectedStart.value!)) {
            _selectedStart.value = null;

            _selectedEnd.value = null;
          } else if (_selectedEnd.value != null && !_isDaySelectable(_selectedEnd.value!)) {
            _selectedEnd.value = null;
          }
          _entryMode.value = DatePickerEntryMode.calendar;

        case DatePickerEntryMode.calendarOnly:
        case DatePickerEntryMode.inputOnly:
          assert(false, 'Can not change entry mode from $_entryMode');
      }
    });
  }

  bool _isDaySelectable(DateTime day) {
    if (day.isBefore(widget.firstDate) || day.isAfter(widget.lastDate)) {
      return false;
    }
    if (widget.selectableDayPredicate == null) {
      return true;
    }
    return widget.selectableDayPredicate!(day, _selectedStart.value, _selectedEnd.value);
  }

  void _handleStartDateChanged(DateTime? date) {
    setState(() => _selectedStart.value = date);
  }

  void _handleEndDateChanged(DateTime? date) {
    setState(() => _selectedEnd.value = date);
  }

  bool get _hasSelectedDateRange => _selectedStart.value != null && _selectedEnd.value != null;

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.orientationOf(context);
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final DatePickerThemeData datePickerTheme = DatePickerTheme.of(context);
    final DatePickerThemeData defaults = DatePickerTheme.defaults(context);

    final Widget contents;
    final Size size;
    final double? elevation;
    final Color? shadowColor;
    final Color? surfaceTintColor;
    final ShapeBorder? shape;
    final EdgeInsets insetPadding;
    final bool showEntryModeButton =
        _entryMode.value == DatePickerEntryMode.calendar || _entryMode.value == DatePickerEntryMode.input;
    switch (_entryMode.value) {
      case DatePickerEntryMode.calendar:
      case DatePickerEntryMode.calendarOnly:
        contents = _CalendarRangePickerDialog(
          key: _calendarPickerKey,
          selectedStartDate: _selectedStart.value,
          selectedEndDate: _selectedEnd.value,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          selectableDayPredicate: widget.selectableDayPredicate,
          currentDate: widget.currentDate,
          onStartDateChanged: _handleStartDateChanged,
          onEndDateChanged: _handleEndDateChanged,
          onConfirm: _hasSelectedDateRange ? _handleOk : null,
          onCancel: _handleCancel,
          entryModeButton:
              showEntryModeButton
                  ? IconButton(
                    icon: widget.switchToInputEntryModeIcon ?? const Icon(WaveIcons.edit_24_regular),
                    padding: EdgeInsets.zero,
                    tooltip: localizations.inputDateModeButtonLabel,
                    onPressed: _handleEntryModeToggle,
                  )
                  : null,
          confirmText: widget.saveText ?? localizations.saveButtonLabel,
          helpText: widget.helpText ?? localizations.dateRangePickerHelpText,
        );
        size = MediaQuery.sizeOf(context);
        insetPadding = EdgeInsets.zero;
        elevation = datePickerTheme.rangePickerElevation ?? defaults.rangePickerElevation!;
        shadowColor = datePickerTheme.rangePickerShadowColor ?? defaults.rangePickerShadowColor!;
        surfaceTintColor = datePickerTheme.rangePickerSurfaceTintColor ?? defaults.rangePickerSurfaceTintColor!;
        shape = datePickerTheme.rangePickerShape ?? defaults.rangePickerShape;

      case DatePickerEntryMode.input:
      case DatePickerEntryMode.inputOnly:
        contents = _InputDateRangePickerDialog(
          selectedStartDate: _selectedStart.value,
          selectedEndDate: _selectedEnd.value,
          currentDate: widget.currentDate,
          picker: SizedBox(
            height: orientation == Orientation.portrait ? _inputFormPortraitHeight : _inputFormLandscapeHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: <Widget>[
                  const Spacer(),
                  _InputDateRangePicker(
                    key: _inputPickerKey,
                    initialStartDate: _selectedStart.value,
                    initialEndDate: _selectedEnd.value,
                    firstDate: widget.firstDate,
                    lastDate: widget.lastDate,
                    selectableDayPredicate: widget.selectableDayPredicate,
                    onStartDateChanged: _handleStartDateChanged,
                    onEndDateChanged: _handleEndDateChanged,
                    autofocus: true,
                    autovalidate: _autoValidate.value,
                    helpText: widget.helpText,
                    errorInvalidRangeText: widget.errorInvalidRangeText,
                    errorFormatText: widget.errorFormatText,
                    errorInvalidText: widget.errorInvalidText,
                    fieldStartHintText: widget.fieldStartHintText,
                    fieldEndHintText: widget.fieldEndHintText,
                    fieldStartLabelText: widget.fieldStartLabelText,
                    fieldEndLabelText: widget.fieldEndLabelText,
                    keyboardType: widget.keyboardType,
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
          onConfirm: _handleOk,
          onCancel: _handleCancel,
          entryModeButton:
              showEntryModeButton
                  ? IconButton(
                    icon: widget.switchToCalendarEntryModeIcon ?? const Icon(WaveIcons.calendar_24_regular),
                    padding: EdgeInsets.zero,
                    tooltip: localizations.calendarModeButtonLabel,
                    onPressed: _handleEntryModeToggle,
                  )
                  : null,
          confirmText: widget.confirmText ?? localizations.okButtonLabel,
          cancelText: widget.cancelText ?? localizations.cancelButtonLabel,
          helpText: widget.helpText ?? localizations.dateRangePickerHelpText,
        );
        size = orientation == Orientation.portrait ? _inputPortraitDialogSizeM3 : _inputRangeLandscapeDialogSize;
        elevation = datePickerTheme.elevation ?? defaults.elevation!;
        shadowColor = datePickerTheme.shadowColor ?? defaults.shadowColor;
        surfaceTintColor = datePickerTheme.surfaceTintColor ?? defaults.surfaceTintColor;
        shape = datePickerTheme.shape ?? defaults.shape;

        insetPadding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0);
    }

    return Dialog(
      insetPadding: insetPadding,
      backgroundColor: datePickerTheme.backgroundColor ?? defaults.backgroundColor,
      elevation: elevation,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      shape: shape,
      clipBehavior: Clip.antiAlias,
      child: AnimatedContainer(
        width: size.width,
        height: size.height,
        duration: _dialogSizeAnimationDuration,
        curve: Curves.easeIn,
        child: MediaQuery.withClampedTextScaling(
          maxScaleFactor: _kMaxRangeTextScaleFactor,
          child: Builder(builder: (context) => contents),
        ),
      ),
    );
  }
}

class _CalendarRangePickerDialog extends StatelessWidget {
  const _CalendarRangePickerDialog({
    required this.selectedStartDate,
    required this.selectedEndDate,
    required this.firstDate,
    required this.lastDate,
    required this.currentDate,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.onConfirm,
    required this.onCancel,
    required this.confirmText,
    required this.helpText,
    required this.selectableDayPredicate,
    super.key,
    this.entryModeButton,
  });

  final DateTime? selectedStartDate;
  final DateTime? selectedEndDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final SelectableDayForRangePredicate? selectableDayPredicate;
  final DateTime? currentDate;
  final ValueChanged<DateTime> onStartDateChanged;
  final ValueChanged<DateTime?> onEndDateChanged;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final String confirmText;
  final String helpText;
  final Widget? entryModeButton;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool useMaterial3 = theme.useMaterial3;
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final Orientation orientation = MediaQuery.orientationOf(context);
    final DatePickerThemeData themeData = DatePickerTheme.of(context);
    final DatePickerThemeData defaults = DatePickerTheme.defaults(context);
    final Color? dialogBackground = themeData.rangePickerBackgroundColor ?? defaults.rangePickerBackgroundColor;
    final Color? headerBackground =
        themeData.rangePickerHeaderBackgroundColor ?? defaults.rangePickerHeaderBackgroundColor;
    final Color? headerForeground =
        themeData.rangePickerHeaderForegroundColor ?? defaults.rangePickerHeaderForegroundColor;
    final Color? headerDisabledForeground = headerForeground?.withOpacity(0.38);
    final TextStyle? headlineStyle =
        themeData.rangePickerHeaderHeadlineStyle ?? defaults.rangePickerHeaderHeadlineStyle;
    final TextStyle? headlineHelpStyle = (themeData.rangePickerHeaderHelpStyle ?? defaults.rangePickerHeaderHelpStyle)
        ?.apply(color: headerForeground);
    final String startDateText = _formatRangeStartDate(localizations, selectedStartDate, selectedEndDate);
    final String endDateText = _formatRangeEndDate(localizations, selectedStartDate, selectedEndDate, DateTime.now());
    final TextStyle? startDateStyle = headlineStyle?.apply(
      color: selectedStartDate != null ? headerForeground : headerDisabledForeground,
    );
    final TextStyle? endDateStyle = headlineStyle?.apply(
      color: selectedEndDate != null ? headerForeground : headerDisabledForeground,
    );
    final ButtonStyle buttonStyle = TextButton.styleFrom(
      foregroundColor: headerForeground,
      disabledForegroundColor: headerDisabledForeground,
    );
    final IconThemeData iconTheme = IconThemeData(color: headerForeground);

    return SafeArea(
      top: false,
      left: false,
      right: false,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: iconTheme,
          actionsIconTheme: iconTheme,
          elevation: useMaterial3 ? 0 : null,
          scrolledUnderElevation: useMaterial3 ? 0 : null,
          backgroundColor: headerBackground,
          leading: CloseButton(onPressed: onCancel),
          actions: <Widget>[
            if (orientation == Orientation.landscape && entryModeButton != null) entryModeButton!,
            TextButton(style: buttonStyle, onPressed: onConfirm, child: Text(confirmText)),
            const SizedBox(width: 8),
          ],
          bottom: PreferredSize(
            preferredSize: const Size(double.infinity, 64),
            child: Row(
              children: <Widget>[
                SizedBox(width: MediaQuery.sizeOf(context).width < 360 ? 42 : 72),
                Expanded(
                  child: Semantics(
                    label: '$helpText $startDateText to $endDateText',
                    excludeSemantics: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(helpText, style: headlineHelpStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 8),
                        Row(
                          children: <Widget>[
                            Text(startDateText, style: startDateStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
                            Text(' – ', style: startDateStyle),
                            Flexible(
                              child: Text(
                                endDateText,
                                style: endDateStyle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                if (orientation == Orientation.portrait && entryModeButton != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: IconTheme(data: iconTheme, child: entryModeButton!),
                  ),
              ],
            ),
          ),
        ),
        backgroundColor: dialogBackground,
        body: _CalendarDateRangePicker(
          initialStartDate: selectedStartDate,
          initialEndDate: selectedEndDate,
          firstDate: firstDate,
          lastDate: lastDate,
          currentDate: currentDate,
          onStartDateChanged: onStartDateChanged,
          onEndDateChanged: onEndDateChanged,
          selectableDayPredicate: selectableDayPredicate,
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<DateTime?>('selectedStartDate', selectedStartDate));
    properties.add(DiagnosticsProperty<DateTime?>('selectedEndDate', selectedEndDate));
    properties.add(DiagnosticsProperty<DateTime>('firstDate', firstDate));
    properties.add(DiagnosticsProperty<DateTime>('lastDate', lastDate));
    properties.add(
      ObjectFlagProperty<SelectableDayForRangePredicate?>.has('selectableDayPredicate', selectableDayPredicate),
    );
    properties.add(DiagnosticsProperty<DateTime?>('currentDate', currentDate));
    properties.add(ObjectFlagProperty<ValueChanged<DateTime>>.has('onStartDateChanged', onStartDateChanged));
    properties.add(ObjectFlagProperty<ValueChanged<DateTime?>>.has('onEndDateChanged', onEndDateChanged));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onConfirm', onConfirm));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onCancel', onCancel));
    properties.add(StringProperty('confirmText', confirmText));
    properties.add(StringProperty('helpText', helpText));
  }
}

const Duration _monthScrollDuration = Duration(milliseconds: 200);

const double _monthItemHeaderHeight = 58.0;
const double _monthItemFooterHeight = 12.0;
const double _monthItemRowHeight = 42.0;
const double _monthItemSpaceBetweenRows = 8.0;
const double _horizontalPadding = 8.0;
const double _maxCalendarWidthLandscape = 384.0;
const double _maxCalendarWidthPortrait = 480.0;

class _CalendarDateRangePicker extends StatefulWidget {
  _CalendarDateRangePicker({
    required DateTime firstDate,
    required DateTime lastDate,
    required this.selectableDayPredicate,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    DateTime? initialStartDate,
    DateTime? initialEndDate,
    DateTime? currentDate,
  }) : initialStartDate = initialStartDate != null ? DateUtils.dateOnly(initialStartDate) : null,
       initialEndDate = initialEndDate != null ? DateUtils.dateOnly(initialEndDate) : null,
       firstDate = DateUtils.dateOnly(firstDate),
       lastDate = DateUtils.dateOnly(lastDate),
       currentDate = DateUtils.dateOnly(currentDate ?? DateTime.now()) {
    assert(
      this.initialStartDate == null || this.initialEndDate == null || !this.initialStartDate!.isAfter(initialEndDate!),
      'initialStartDate must be on or before initialEndDate.',
    );
    assert(!this.lastDate.isBefore(this.firstDate), 'firstDate must be on or before lastDate.');
  }

  final DateTime? initialStartDate;

  final DateTime? initialEndDate;

  final DateTime firstDate;

  final DateTime lastDate;

  final SelectableDayForRangePredicate? selectableDayPredicate;

  final DateTime currentDate;

  final ValueChanged<DateTime>? onStartDateChanged;

  final ValueChanged<DateTime?>? onEndDateChanged;

  @override
  State<_CalendarDateRangePicker> createState() => _CalendarDateRangePickerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<DateTime?>('initialStartDate', initialStartDate));
    properties.add(DiagnosticsProperty<DateTime?>('initialEndDate', initialEndDate));
    properties.add(DiagnosticsProperty<DateTime>('firstDate', firstDate));
    properties.add(DiagnosticsProperty<DateTime>('lastDate', lastDate));
    properties.add(
      ObjectFlagProperty<SelectableDayForRangePredicate?>.has('selectableDayPredicate', selectableDayPredicate),
    );
    properties.add(DiagnosticsProperty<DateTime>('currentDate', currentDate));
    properties.add(ObjectFlagProperty<ValueChanged<DateTime>?>.has('onStartDateChanged', onStartDateChanged));
    properties.add(ObjectFlagProperty<ValueChanged<DateTime?>?>.has('onEndDateChanged', onEndDateChanged));
  }
}

class _CalendarDateRangePickerState extends State<_CalendarDateRangePicker> {
  final GlobalKey _scrollViewKey = GlobalKey();
  DateTime? _startDate;
  DateTime? _endDate;
  int _initialMonthIndex = 0;
  late ScrollController _controller;
  late bool _showWeekBottomDivider;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);

    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;

    final DateTime initialDate = widget.initialStartDate ?? widget.currentDate;
    if (!initialDate.isBefore(widget.firstDate) && !initialDate.isAfter(widget.lastDate)) {
      _initialMonthIndex = DateUtils.monthDelta(widget.firstDate, initialDate);
    }

    _showWeekBottomDivider = _initialMonthIndex != 0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_controller.offset <= _controller.position.minScrollExtent) {
      setState(() {
        _showWeekBottomDivider = false;
      });
    } else if (!_showWeekBottomDivider) {
      setState(() {
        _showWeekBottomDivider = true;
      });
    }
  }

  int get _numberOfMonths => DateUtils.monthDelta(widget.firstDate, widget.lastDate) + 1;

  void _vibrate() {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        HapticFeedback.vibrate();
      case TargetPlatform.iOS:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        break;
    }
  }

  void _updateSelection(DateTime date) {
    _vibrate();
    setState(() {
      if (_startDate != null && _endDate == null && !date.isBefore(_startDate!)) {
        _endDate = date;
        widget.onEndDateChanged?.call(_endDate);
      } else {
        _startDate = date;
        widget.onStartDateChanged?.call(_startDate!);
        if (_endDate != null) {
          _endDate = null;
          widget.onEndDateChanged?.call(_endDate);
        }
      }
    });
  }

  Widget _buildMonthItem(BuildContext context, int index, bool beforeInitialMonth) {
    final int monthIndex = beforeInitialMonth ? _initialMonthIndex - index - 1 : _initialMonthIndex + index;
    final DateTime month = DateUtils.addMonthsToMonthDate(widget.firstDate, monthIndex);
    return _MonthItem(
      selectedDateStart: _startDate,
      selectedDateEnd: _endDate,
      currentDate: widget.currentDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      displayedMonth: month,
      onChanged: _updateSelection,
      selectableDayPredicate: widget.selectableDayPredicate,
    );
  }

  @override
  Widget build(BuildContext context) {
    const Key sliverAfterKey = Key('sliverAfterKey');

    return Column(
      children: <Widget>[
        const _DayHeaders(),
        if (_showWeekBottomDivider) const Divider(height: 0),
        Expanded(
          child: _CalendarKeyboardNavigator(
            firstDate: widget.firstDate,
            lastDate: widget.lastDate,
            initialFocusedDay: _startDate ?? widget.initialStartDate ?? widget.currentDate,

            child: CustomScrollView(
              key: _scrollViewKey,
              controller: _controller,
              center: sliverAfterKey,
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildMonthItem(context, index, true),
                    childCount: _initialMonthIndex,
                  ),
                ),
                SliverList(
                  key: sliverAfterKey,
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildMonthItem(context, index, false),
                    childCount: _numberOfMonths - _initialMonthIndex,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CalendarKeyboardNavigator extends StatefulWidget {
  const _CalendarKeyboardNavigator({
    required this.child,
    required this.firstDate,
    required this.lastDate,
    required this.initialFocusedDay,
  });

  final Widget child;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime initialFocusedDay;

  @override
  _CalendarKeyboardNavigatorState createState() => _CalendarKeyboardNavigatorState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<DateTime>('firstDate', firstDate));
    properties.add(DiagnosticsProperty<DateTime>('lastDate', lastDate));
    properties.add(DiagnosticsProperty<DateTime>('initialFocusedDay', initialFocusedDay));
  }
}

class _CalendarKeyboardNavigatorState extends State<_CalendarKeyboardNavigator> {
  final Map<ShortcutActivator, Intent> _shortcutMap = const <ShortcutActivator, Intent>{
    SingleActivator(LogicalKeyboardKey.arrowLeft): DirectionalFocusIntent(TraversalDirection.left),
    SingleActivator(LogicalKeyboardKey.arrowRight): DirectionalFocusIntent(TraversalDirection.right),
    SingleActivator(LogicalKeyboardKey.arrowDown): DirectionalFocusIntent(TraversalDirection.down),
    SingleActivator(LogicalKeyboardKey.arrowUp): DirectionalFocusIntent(TraversalDirection.up),
  };
  late Map<Type, Action<Intent>> _actionMap;
  late FocusNode _dayGridFocus;
  TraversalDirection? _dayTraversalDirection;
  DateTime? _focusedDay;

  @override
  void initState() {
    super.initState();

    _actionMap = <Type, Action<Intent>>{
      NextFocusIntent: CallbackAction<NextFocusIntent>(onInvoke: _handleGridNextFocus),
      PreviousFocusIntent: CallbackAction<PreviousFocusIntent>(onInvoke: _handleGridPreviousFocus),
      DirectionalFocusIntent: CallbackAction<DirectionalFocusIntent>(onInvoke: _handleDirectionFocus),
    };
    _dayGridFocus = FocusNode(debugLabel: 'Day Grid');
  }

  @override
  void dispose() {
    _dayGridFocus.dispose();
    super.dispose();
  }

  void _handleGridFocusChange(bool focused) {
    setState(() {
      if (focused) {
        _focusedDay ??= widget.initialFocusedDay;
      }
    });
  }

  void _handleGridNextFocus(NextFocusIntent intent) {
    _dayGridFocus.requestFocus();
    _dayGridFocus.nextFocus();
  }

  void _handleGridPreviousFocus(PreviousFocusIntent intent) {
    _dayGridFocus.requestFocus();
    _dayGridFocus.previousFocus();
  }

  void _handleDirectionFocus(DirectionalFocusIntent intent) {
    assert(_focusedDay != null);
    setState(() {
      final DateTime? nextDate = _nextDateInDirection(_focusedDay!, intent.direction);
      if (nextDate != null) {
        _focusedDay = nextDate;
        _dayTraversalDirection = intent.direction;
      }
    });
  }

  static const Map<TraversalDirection, int> _directionOffset = <TraversalDirection, int>{
    TraversalDirection.up: -DateTime.daysPerWeek,
    TraversalDirection.right: 1,
    TraversalDirection.down: DateTime.daysPerWeek,
    TraversalDirection.left: -1,
  };

  int _dayDirectionOffset(TraversalDirection traversalDirection, TextDirection textDirection) {
    if (textDirection == TextDirection.rtl) {
      if (traversalDirection == TraversalDirection.left) {
        traversalDirection = TraversalDirection.right;
      } else if (traversalDirection == TraversalDirection.right) {
        traversalDirection = TraversalDirection.left;
      }
    }
    return _directionOffset[traversalDirection]!;
  }

  DateTime? _nextDateInDirection(DateTime date, TraversalDirection direction) {
    final TextDirection textDirection = Directionality.of(context);
    final DateTime nextDate = DateUtils.addDaysToDate(date, _dayDirectionOffset(direction, textDirection));
    if (!nextDate.isBefore(widget.firstDate) && !nextDate.isAfter(widget.lastDate)) {
      return nextDate;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) => FocusableActionDetector(
    shortcuts: _shortcutMap,
    actions: _actionMap,
    focusNode: _dayGridFocus,
    onFocusChange: _handleGridFocusChange,
    child: _FocusedDate(
      date: _dayGridFocus.hasFocus ? _focusedDay : null,
      scrollDirection: _dayGridFocus.hasFocus ? _dayTraversalDirection : null,
      child: widget.child,
    ),
  );
}

class _FocusedDate extends InheritedWidget {
  const _FocusedDate({required super.child, this.date, this.scrollDirection});

  final DateTime? date;
  final TraversalDirection? scrollDirection;

  @override
  bool updateShouldNotify(_FocusedDate oldWidget) =>
      !DateUtils.isSameDay(date, oldWidget.date) || scrollDirection != oldWidget.scrollDirection;

  static _FocusedDate? maybeOf(BuildContext context) => context.dependOnInheritedWidgetOfExactType<_FocusedDate>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<DateTime?>('date', date))
      ..add(EnumProperty<TraversalDirection?>('scrollDirection', scrollDirection));
  }
}

class _DayHeaders extends StatelessWidget {
  const _DayHeaders();

  List<Widget> _getDayHeaders(TextStyle headerStyle, MaterialLocalizations localizations) {
    final List<Widget> result = <Widget>[];
    for (
      int i = localizations.firstDayOfWeekIndex;
      result.length < DateTime.daysPerWeek;
      i = (i + 1) % DateTime.daysPerWeek
    ) {
      final String weekday = localizations.narrowWeekdays[i];
      result.add(ExcludeSemantics(child: Center(child: Text(weekday, style: headerStyle))));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final themeData = WaveApp.themeOf(context);
    final colorScheme = themeData.colorScheme;
    final textStyle = themeData.textTheme.h4;
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final List<Widget> labels = _getDayHeaders(textStyle, localizations);

    labels.insert(0, const SizedBox.shrink());
    labels.add(const SizedBox.shrink());

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth:
            MediaQuery.orientationOf(context) == Orientation.landscape
                ? _maxCalendarWidthLandscape
                : _maxCalendarWidthPortrait,
        maxHeight: _monthItemRowHeight,
      ),
      child: GridView.custom(
        shrinkWrap: true,
        gridDelegate: _monthItemGridDelegate,
        childrenDelegate: SliverChildListDelegate(labels, addRepaintBoundaries: false),
      ),
    );
  }
}

class _MonthItemGridDelegate extends SliverGridDelegate {
  const _MonthItemGridDelegate();

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    final double tileWidth = (constraints.crossAxisExtent - 2 * _horizontalPadding) / DateTime.daysPerWeek;
    return _MonthSliverGridLayout(
      crossAxisCount: DateTime.daysPerWeek + 2,
      dayChildWidth: tileWidth,
      edgeChildWidth: _horizontalPadding,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(_MonthItemGridDelegate oldDelegate) => false;
}

const _MonthItemGridDelegate _monthItemGridDelegate = _MonthItemGridDelegate();

class _MonthSliverGridLayout extends SliverGridLayout {
  const _MonthSliverGridLayout({
    required this.crossAxisCount,
    required this.dayChildWidth,
    required this.edgeChildWidth,
    required this.reverseCrossAxis,
  }) : assert(crossAxisCount > 0),
       assert(dayChildWidth >= 0),
       assert(edgeChildWidth >= 0);

  final int crossAxisCount;

  final double dayChildWidth;

  final double edgeChildWidth;

  final bool reverseCrossAxis;

  double get _rowHeight => _monthItemRowHeight + _monthItemSpaceBetweenRows;

  double get _childHeight => _monthItemRowHeight;

  @override
  int getMinChildIndexForScrollOffset(double scrollOffset) => crossAxisCount * (scrollOffset ~/ _rowHeight);

  @override
  int getMaxChildIndexForScrollOffset(double scrollOffset) {
    final int mainAxisCount = (scrollOffset / _rowHeight).ceil();
    return math.max(0, crossAxisCount * mainAxisCount - 1);
  }

  double _getCrossAxisOffset(double crossAxisStart, bool isPadding) {
    if (reverseCrossAxis) {
      return ((crossAxisCount - 2) * dayChildWidth + 2 * edgeChildWidth) -
          crossAxisStart -
          (isPadding ? edgeChildWidth : dayChildWidth);
    }
    return crossAxisStart;
  }

  @override
  SliverGridGeometry getGeometryForChildIndex(int index) {
    final int adjustedIndex = index % crossAxisCount;
    final bool isEdge = adjustedIndex == 0 || adjustedIndex == crossAxisCount - 1;
    final double crossAxisStart = math.max(0, (adjustedIndex - 1) * dayChildWidth + edgeChildWidth);

    return SliverGridGeometry(
      scrollOffset: (index ~/ crossAxisCount) * _rowHeight,
      crossAxisOffset: _getCrossAxisOffset(crossAxisStart, isEdge),
      mainAxisExtent: _childHeight,
      crossAxisExtent: isEdge ? edgeChildWidth : dayChildWidth,
    );
  }

  @override
  double computeMaxScrollOffset(int childCount) {
    assert(childCount >= 0);
    final int mainAxisCount = ((childCount - 1) ~/ crossAxisCount) + 1;
    final double mainAxisSpacing = _rowHeight - _childHeight;
    return _rowHeight * mainAxisCount - mainAxisSpacing;
  }
}

class _MonthItem extends StatefulWidget {
  _MonthItem({
    required this.selectedDateStart,
    required this.selectedDateEnd,
    required this.currentDate,
    required this.onChanged,
    required this.firstDate,
    required this.lastDate,
    required this.displayedMonth,
    required this.selectableDayPredicate,
  }) : assert(!firstDate.isAfter(lastDate)),
       assert(selectedDateStart == null || !selectedDateStart.isBefore(firstDate)),
       assert(selectedDateEnd == null || !selectedDateEnd.isBefore(firstDate)),
       assert(selectedDateStart == null || !selectedDateStart.isAfter(lastDate)),
       assert(selectedDateEnd == null || !selectedDateEnd.isAfter(lastDate)),
       assert(selectedDateStart == null || selectedDateEnd == null || !selectedDateStart.isAfter(selectedDateEnd));

  final DateTime? selectedDateStart;

  final DateTime? selectedDateEnd;

  final DateTime currentDate;

  final ValueChanged<DateTime> onChanged;

  final DateTime firstDate;

  final DateTime lastDate;

  final DateTime displayedMonth;

  final SelectableDayForRangePredicate? selectableDayPredicate;

  @override
  _MonthItemState createState() => _MonthItemState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<DateTime?>('selectedDateStart', selectedDateStart));
    properties.add(DiagnosticsProperty<DateTime?>('selectedDateEnd', selectedDateEnd));
    properties.add(DiagnosticsProperty<DateTime>('currentDate', currentDate));
    properties.add(ObjectFlagProperty<ValueChanged<DateTime>>.has('onChanged', onChanged));
    properties.add(DiagnosticsProperty<DateTime>('firstDate', firstDate));
    properties.add(DiagnosticsProperty<DateTime>('lastDate', lastDate));
    properties.add(DiagnosticsProperty<DateTime>('displayedMonth', displayedMonth));
    properties.add(
      ObjectFlagProperty<SelectableDayForRangePredicate?>.has('selectableDayPredicate', selectableDayPredicate),
    );
  }
}

class _MonthItemState extends State<_MonthItem> {
  late List<FocusNode> _dayFocusNodes;

  @override
  void initState() {
    super.initState();
    final int daysInMonth = DateUtils.getDaysInMonth(widget.displayedMonth.year, widget.displayedMonth.month);
    _dayFocusNodes = List<FocusNode>.generate(
      daysInMonth,
      (index) => FocusNode(skipTraversal: true, debugLabel: 'Day ${index + 1}'),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final DateTime? focusedDate = _FocusedDate.maybeOf(context)?.date;
    if (focusedDate != null && DateUtils.isSameMonth(widget.displayedMonth, focusedDate)) {
      _dayFocusNodes[focusedDate.day - 1].requestFocus();
    }
  }

  @override
  void dispose() {
    for (final FocusNode node in _dayFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  Color _highlightColor(BuildContext context) =>
      DatePickerTheme.of(context).rangeSelectionBackgroundColor ??
      DatePickerTheme.defaults(context).rangeSelectionBackgroundColor!;

  void _dayFocusChanged(bool focused) {
    if (focused) {
      final TraversalDirection? focusDirection = _FocusedDate.maybeOf(context)?.scrollDirection;
      if (focusDirection != null) {
        ScrollPositionAlignmentPolicy policy = ScrollPositionAlignmentPolicy.explicit;
        switch (focusDirection) {
          case TraversalDirection.up:
          case TraversalDirection.left:
            policy = ScrollPositionAlignmentPolicy.keepVisibleAtStart;
          case TraversalDirection.right:
          case TraversalDirection.down:
            policy = ScrollPositionAlignmentPolicy.keepVisibleAtEnd;
        }
        Scrollable.ensureVisible(primaryFocus!.context!, duration: _monthScrollDuration, alignmentPolicy: policy);
      }
    }
  }

  Widget _buildDayItem(BuildContext context, DateTime dayToBuild, int firstDayOffset, int daysInMonth) {
    final int day = dayToBuild.day;

    final bool isDisabled =
        dayToBuild.isAfter(widget.lastDate) ||
        dayToBuild.isBefore(widget.firstDate) ||
        widget.selectableDayPredicate != null &&
            !widget.selectableDayPredicate!(dayToBuild, widget.selectedDateStart, widget.selectedDateEnd);
    final bool isRangeSelected = widget.selectedDateStart != null && widget.selectedDateEnd != null;
    final bool isSelectedDayStart =
        widget.selectedDateStart != null && dayToBuild.isAtSameMomentAs(widget.selectedDateStart!);
    final bool isSelectedDayEnd =
        widget.selectedDateEnd != null && dayToBuild.isAtSameMomentAs(widget.selectedDateEnd!);
    final bool isInRange =
        isRangeSelected &&
        dayToBuild.isAfter(widget.selectedDateStart!) &&
        dayToBuild.isBefore(widget.selectedDateEnd!);
    final bool isOneDayRange = isRangeSelected && widget.selectedDateStart == widget.selectedDateEnd;
    final bool isToday = DateUtils.isSameDay(widget.currentDate, dayToBuild);

    return _DayItem(
      day: dayToBuild,
      focusNode: _dayFocusNodes[day - 1],
      onChanged: widget.onChanged,
      onFocusChange: _dayFocusChanged,
      highlightColor: _highlightColor(context),
      isDisabled: isDisabled,
      isRangeSelected: isRangeSelected,
      isSelectedDayStart: isSelectedDayStart,
      isSelectedDayEnd: isSelectedDayEnd,
      isInRange: isInRange,
      isOneDayRange: isOneDayRange,
      isToday: isToday,
    );
  }

  Widget _buildEdgeBox(BuildContext context, bool isHighlighted) {
    const Widget empty = LimitedBox(maxWidth: 0.0, maxHeight: 0.0, child: SizedBox.expand());
    return isHighlighted ? ColoredBox(color: _highlightColor(context), child: empty) : empty;
  }

  @override
  Widget build(BuildContext context) {
    final theme = WaveApp.themeOf(context);
    final textTheme = theme.textTheme;
    final localizations = MaterialLocalizations.of(context);
    final int year = widget.displayedMonth.year;
    final int month = widget.displayedMonth.month;
    final int daysInMonth = DateUtils.getDaysInMonth(year, month);
    final int dayOffset = DateUtils.firstDayOffset(year, month, localizations);
    final int weeks = ((daysInMonth + dayOffset) / DateTime.daysPerWeek).ceil();
    final double gridHeight = weeks * _monthItemRowHeight + (weeks - 1) * _monthItemSpaceBetweenRows;
    final List<Widget> dayItems = <Widget>[];

    for (int day = 0 - dayOffset + 1; day <= daysInMonth; day += 1) {
      if (day < 1) {
        dayItems.add(const LimitedBox(maxWidth: 0.0, maxHeight: 0.0, child: SizedBox.expand()));
      } else {
        final DateTime dayToBuild = DateTime(year, month, day);
        final Widget dayItem = _buildDayItem(context, dayToBuild, dayOffset, daysInMonth);
        dayItems.add(dayItem);
      }
    }

    final List<Widget> paddedDayItems = <Widget>[];
    for (int i = 0; i < weeks; i++) {
      final int start = i * DateTime.daysPerWeek;
      final int end = math.min(start + DateTime.daysPerWeek, dayItems.length);
      final List<Widget> weekList = dayItems.sublist(start, end);

      final DateTime dateAfterLeadingPadding = DateTime(year, month, start - dayOffset + 1);

      final bool isLeadingInRange =
          !(dayOffset > 0 && i == 0) &&
          widget.selectedDateStart != null &&
          widget.selectedDateEnd != null &&
          dateAfterLeadingPadding.isAfter(widget.selectedDateStart!) &&
          !dateAfterLeadingPadding.isAfter(widget.selectedDateEnd!);
      weekList.insert(0, _buildEdgeBox(context, isLeadingInRange));

      if (end < dayItems.length || (end == dayItems.length && dayItems.length % DateTime.daysPerWeek == 0)) {
        final DateTime dateBeforeTrailingPadding = DateTime(year, month, end - dayOffset);

        final bool isTrailingInRange =
            widget.selectedDateStart != null &&
            widget.selectedDateEnd != null &&
            !dateBeforeTrailingPadding.isBefore(widget.selectedDateStart!) &&
            dateBeforeTrailingPadding.isBefore(widget.selectedDateEnd!);
        weekList.add(_buildEdgeBox(context, isTrailingInRange));
      }

      paddedDayItems.addAll(weekList);
    }

    final double maxWidth =
        MediaQuery.orientationOf(context) == Orientation.landscape
            ? _maxCalendarWidthLandscape
            : _maxCalendarWidthPortrait;
    return Column(
      children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth).tighten(height: _monthItemHeaderHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: ExcludeSemantics(
                child: Text(localizations.formatMonthYear(widget.displayedMonth), style: textTheme.body),
              ),
            ),
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: gridHeight),
          child: GridView.custom(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: _monthItemGridDelegate,
            childrenDelegate: SliverChildListDelegate(paddedDayItems, addRepaintBoundaries: false),
          ),
        ),
        const SizedBox(height: _monthItemFooterHeight),
      ],
    );
  }
}

class _DayItem extends StatefulWidget {
  const _DayItem({
    required this.day,
    required this.focusNode,
    required this.onChanged,
    required this.onFocusChange,
    required this.highlightColor,
    required this.isDisabled,
    required this.isRangeSelected,
    required this.isSelectedDayStart,
    required this.isSelectedDayEnd,
    required this.isInRange,
    required this.isOneDayRange,
    required this.isToday,
  });

  final DateTime day;

  final FocusNode focusNode;

  final ValueChanged<DateTime> onChanged;

  final ValueChanged<bool> onFocusChange;

  final Color highlightColor;

  final bool isDisabled;

  final bool isRangeSelected;

  final bool isSelectedDayStart;

  final bool isSelectedDayEnd;

  final bool isInRange;

  final bool isOneDayRange;

  final bool isToday;

  @override
  State<_DayItem> createState() => _DayItemState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<DateTime>('day', day))
      ..add(DiagnosticsProperty<FocusNode>('focusNode', focusNode))
      ..add(ObjectFlagProperty<ValueChanged<DateTime>>.has('onChanged', onChanged))
      ..add(ObjectFlagProperty<ValueChanged<bool>>.has('onFocusChange', onFocusChange))
      ..add(ColorProperty('highlightColor', highlightColor))
      ..add(DiagnosticsProperty<bool>('isDisabled', isDisabled))
      ..add(DiagnosticsProperty<bool>('isRangeSelected', isRangeSelected))
      ..add(DiagnosticsProperty<bool>('isSelectedDayStart', isSelectedDayStart))
      ..add(DiagnosticsProperty<bool>('isSelectedDayEnd', isSelectedDayEnd))
      ..add(DiagnosticsProperty<bool>('isInRange', isInRange))
      ..add(DiagnosticsProperty<bool>('isOneDayRange', isOneDayRange))
      ..add(DiagnosticsProperty<bool>('isToday', isToday));
  }
}

class _DayItemState extends State<_DayItem> {
  final MaterialStatesController _statesController = MaterialStatesController();

  @override
  void dispose() {
    _statesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = WaveApp.themeOf(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final DatePickerThemeData datePickerTheme = DatePickerTheme.of(context);
    final DatePickerThemeData defaults = DatePickerTheme.defaults(context);
    final TextDirection textDirection = Directionality.of(context);
    final Color highlightColor = widget.highlightColor;

    BoxDecoration? decoration;
    TextStyle? itemStyle = textTheme.body;

    T? effectiveValue<T>(T? Function(DatePickerThemeData? theme) getProperty) =>
        getProperty(datePickerTheme) ?? getProperty(defaults);

    T? resolve<T>(
      MaterialStateProperty<T>? Function(DatePickerThemeData? theme) getProperty,
      Set<MaterialState> states,
    ) => effectiveValue((theme) {
      return getProperty(theme)?.resolve(states);
    });

    final Set<MaterialState> states = <MaterialState>{
      if (widget.isDisabled) MaterialState.disabled,
      if (widget.isSelectedDayStart || widget.isSelectedDayEnd) MaterialState.selected,
    };

    _statesController.value = states;

    final Color? dayForegroundColor = resolve<Color?>((theme) => theme?.dayForegroundColor, states);
    final Color? dayBackgroundColor = resolve<Color?>((theme) => theme?.dayBackgroundColor, states);
    final MaterialStateProperty<Color?> dayOverlayColor = MaterialStateProperty.resolveWith<Color?>(
      (states) => effectiveValue(
        (theme) =>
            widget.isInRange
                ? theme?.rangeSelectionOverlayColor?.resolve(states)
                : theme?.dayOverlayColor?.resolve(states),
      ),
    );

    _HighlightPainter? highlightPainter;

    if (widget.isSelectedDayStart || widget.isSelectedDayEnd) {
      itemStyle = itemStyle.apply(color: dayForegroundColor);
      decoration = BoxDecoration(color: dayBackgroundColor, shape: BoxShape.circle);

      if (widget.isRangeSelected && !widget.isOneDayRange) {
        final _HighlightPainterStyle style =
            widget.isSelectedDayStart
                ? _HighlightPainterStyle.highlightTrailing
                : _HighlightPainterStyle.highlightLeading;
        highlightPainter = _HighlightPainter(color: highlightColor, style: style, textDirection: textDirection);
      }
    } else if (widget.isInRange) {
      highlightPainter = _HighlightPainter(
        color: highlightColor,
        style: _HighlightPainterStyle.highlightAll,
        textDirection: textDirection,
      );
      if (widget.isDisabled) {
        itemStyle = itemStyle.apply(color: colorScheme.contentPrimary.withOpacity(0.38));
      }
    } else if (widget.isDisabled) {
      itemStyle = itemStyle.apply(color: colorScheme.contentPrimary.withOpacity(0.38));
    } else if (widget.isToday) {
      itemStyle = itemStyle.apply(color: colorScheme.primary);
      decoration = BoxDecoration(border: Border.all(color: colorScheme.primary), shape: BoxShape.circle);
    }

    final String dayText = localizations.formatDecimal(widget.day.day);

    final String semanticLabelSuffix = widget.isToday ? ', ${localizations.currentDateLabel}' : '';
    String semanticLabel = '$dayText, ${localizations.formatFullDate(widget.day)}$semanticLabelSuffix';
    if (widget.isSelectedDayStart) {
      semanticLabel = localizations.dateRangeStartDateSemanticLabel(semanticLabel);
    } else if (widget.isSelectedDayEnd) {
      semanticLabel = localizations.dateRangeEndDateSemanticLabel(semanticLabel);
    }

    Widget dayWidget = Container(
      decoration: decoration,
      alignment: Alignment.center,
      child: Semantics(
        label: semanticLabel,
        selected: widget.isSelectedDayStart || widget.isSelectedDayEnd,
        child: ExcludeSemantics(child: Text(dayText, style: itemStyle)),
      ),
    );

    if (highlightPainter != null) {
      dayWidget = CustomPaint(painter: highlightPainter, child: dayWidget);
    }

    if (!widget.isDisabled) {
      dayWidget = InkResponse(
        focusNode: widget.focusNode,
        onTap: () => widget.onChanged(widget.day),
        radius: _monthItemRowHeight / 2 + 4,
        statesController: _statesController,
        overlayColor: dayOverlayColor,
        onFocusChange: widget.onFocusChange,
        child: dayWidget,
      );
    }

    return dayWidget;
  }
}

enum _HighlightPainterStyle { none, highlightLeading, highlightTrailing, highlightAll }

class _HighlightPainter extends CustomPainter {
  _HighlightPainter({required this.color, this.style = _HighlightPainterStyle.none, this.textDirection});

  final Color color;
  final _HighlightPainterStyle style;
  final TextDirection? textDirection;

  @override
  void paint(Canvas canvas, Size size) {
    if (style == _HighlightPainterStyle.none) {
      return;
    }

    final Paint paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final bool rtl = switch (textDirection) {
      TextDirection.rtl || null => true,
      TextDirection.ltr => false,
    };

    switch (style) {
      case _HighlightPainterStyle.highlightLeading when rtl:
      case _HighlightPainterStyle.highlightTrailing when !rtl:
        canvas.drawRect(Rect.fromLTWH(size.width / 2, 0, size.width / 2, size.height), paint);
      case _HighlightPainterStyle.highlightLeading:
      case _HighlightPainterStyle.highlightTrailing:
        canvas.drawRect(Rect.fromLTWH(0, 0, size.width / 2, size.height), paint);
      case _HighlightPainterStyle.highlightAll:
        canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
      case _HighlightPainterStyle.none:
        break;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _InputDateRangePickerDialog extends StatelessWidget {
  const _InputDateRangePickerDialog({
    required this.selectedStartDate,
    required this.selectedEndDate,
    required this.currentDate,
    required this.picker,
    required this.onConfirm,
    required this.onCancel,
    required this.confirmText,
    required this.cancelText,
    required this.helpText,
    required this.entryModeButton,
  });

  final DateTime? selectedStartDate;
  final DateTime? selectedEndDate;
  final DateTime? currentDate;
  final Widget picker;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final String? confirmText;
  final String? cancelText;
  final String? helpText;
  final Widget? entryModeButton;

  String _formatDateRange(BuildContext context, DateTime? start, DateTime? end, DateTime now) {
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final String startText = _formatRangeStartDate(localizations, start, end);
    final String endText = _formatRangeEndDate(localizations, start, end, now);
    if (start == null || end == null) {
      return localizations.unspecifiedDateRange;
    }
    return switch (Directionality.of(context)) {
      TextDirection.rtl => '$endText – $startText',
      TextDirection.ltr => '$startText – $endText',
    };
  }

  @override
  Widget build(BuildContext context) {
    final bool useMaterial3 = Theme.of(context).useMaterial3;
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final Orientation orientation = MediaQuery.orientationOf(context);
    final DatePickerThemeData datePickerTheme = DatePickerTheme.of(context);
    final DatePickerThemeData defaults = DatePickerTheme.defaults(context);

    TextStyle? headlineStyle =
        (orientation == Orientation.portrait)
            ? datePickerTheme.headerHeadlineStyle ?? defaults.headerHeadlineStyle
            : Theme.of(context).textTheme.headlineSmall;

    final Color? headerForegroundColor = datePickerTheme.headerForegroundColor ?? defaults.headerForegroundColor;
    headlineStyle = headlineStyle?.copyWith(color: headerForegroundColor);

    final String dateText = _formatDateRange(context, selectedStartDate, selectedEndDate, currentDate!);
    final String semanticDateText =
        selectedStartDate != null && selectedEndDate != null
            ? '${localizations.formatMediumDate(selectedStartDate!)} – ${localizations.formatMediumDate(selectedEndDate!)}'
            : '';

    final Widget header = _DatePickerHeader(
      helpText:
          helpText ??
          (useMaterial3 ? localizations.dateRangePickerHelpText : localizations.dateRangePickerHelpText.toUpperCase()),
      titleText: dateText,
      titleSemanticsLabel: semanticDateText,
      titleStyle: headlineStyle,
      orientation: orientation,
      isShort: orientation == Orientation.landscape,
      entryModeButton: entryModeButton,
    );

    final Widget actions = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 52.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Align(
          alignment: AlignmentDirectional.centerEnd,
          child: OverflowBar(
            spacing: 8,
            children: <Widget>[
              TextButton(
                onPressed: onCancel,
                child: Text(
                  cancelText ??
                      (useMaterial3 ? localizations.cancelButtonLabel : localizations.cancelButtonLabel.toUpperCase()),
                ),
              ),
              TextButton(onPressed: onConfirm, child: Text(confirmText ?? localizations.okButtonLabel)),
            ],
          ),
        ),
      ),
    );

    final double textScaleFactor =
        MediaQuery.textScalerOf(context).clamp(maxScaleFactor: _kMaxRangeTextScaleFactor).scale(_fontSizeToScale) /
        _fontSizeToScale;
    final Size dialogSize = (useMaterial3 ? _inputPortraitDialogSizeM3 : _inputPortraitDialogSizeM2) * textScaleFactor;
    switch (orientation) {
      case Orientation.portrait:
        return LayoutBuilder(
          builder: (context, constraints) {
            final Size portraitDialogSize = useMaterial3 ? _inputPortraitDialogSizeM3 : _inputPortraitDialogSizeM2;

            final bool isFullyPortrait =
                constraints.maxHeight >= math.min(dialogSize.height, portraitDialogSize.height);

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                header,
                if (isFullyPortrait) ...<Widget>[Expanded(child: picker), actions],
              ],
            );
          },
        );

      case Orientation.landscape:
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            header,
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[Expanded(child: picker), actions],
              ),
            ),
          ],
        );
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<DateTime?>('selectedStartDate', selectedStartDate))
      ..add(DiagnosticsProperty<DateTime?>('selectedEndDate', selectedEndDate))
      ..add(DiagnosticsProperty<DateTime?>('currentDate', currentDate))
      ..add(ObjectFlagProperty<VoidCallback>.has('onConfirm', onConfirm))
      ..add(ObjectFlagProperty<VoidCallback>.has('onCancel', onCancel))
      ..add(StringProperty('confirmText', confirmText))
      ..add(StringProperty('cancelText', cancelText))
      ..add(StringProperty('helpText', helpText));
  }
}

class _InputDateRangePicker extends StatefulWidget {
  _InputDateRangePicker({
    required DateTime firstDate,
    required DateTime lastDate,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.selectableDayPredicate,
    super.key,
    DateTime? initialStartDate,
    DateTime? initialEndDate,
    this.helpText,
    this.errorFormatText,
    this.errorInvalidText,
    this.errorInvalidRangeText,
    this.fieldStartHintText,
    this.fieldEndHintText,
    this.fieldStartLabelText,
    this.fieldEndLabelText,
    this.autofocus = false,
    this.autovalidate = false,
    this.keyboardType = TextInputType.datetime,
  }) : initialStartDate = initialStartDate == null ? null : DateUtils.dateOnly(initialStartDate),
       initialEndDate = initialEndDate == null ? null : DateUtils.dateOnly(initialEndDate),
       firstDate = DateUtils.dateOnly(firstDate),
       lastDate = DateUtils.dateOnly(lastDate);

  final DateTime? initialStartDate;

  final DateTime? initialEndDate;

  final DateTime firstDate;

  final DateTime lastDate;

  final ValueChanged<DateTime?>? onStartDateChanged;

  final ValueChanged<DateTime?>? onEndDateChanged;

  final String? helpText;

  final String? errorFormatText;

  final String? errorInvalidText;

  final String? errorInvalidRangeText;

  final String? fieldStartHintText;

  final String? fieldEndHintText;

  final String? fieldStartLabelText;

  final String? fieldEndLabelText;

  final bool autofocus;

  final bool autovalidate;

  final TextInputType keyboardType;

  final SelectableDayForRangePredicate? selectableDayPredicate;

  @override
  _InputDateRangePickerState createState() => _InputDateRangePickerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<DateTime?>('initialStartDate', initialStartDate))
      ..add(DiagnosticsProperty<DateTime?>('initialEndDate', initialEndDate))
      ..add(DiagnosticsProperty<DateTime>('firstDate', firstDate))
      ..add(DiagnosticsProperty<DateTime>('lastDate', lastDate))
      ..add(ObjectFlagProperty<ValueChanged<DateTime?>?>.has('onStartDateChanged', onStartDateChanged))
      ..add(ObjectFlagProperty<ValueChanged<DateTime?>?>.has('onEndDateChanged', onEndDateChanged))
      ..add(StringProperty('helpText', helpText))
      ..add(StringProperty('errorFormatText', errorFormatText))
      ..add(StringProperty('errorInvalidText', errorInvalidText))
      ..add(StringProperty('errorInvalidRangeText', errorInvalidRangeText))
      ..add(StringProperty('fieldStartHintText', fieldStartHintText))
      ..add(StringProperty('fieldEndHintText', fieldEndHintText))
      ..add(StringProperty('fieldStartLabelText', fieldStartLabelText))
      ..add(StringProperty('fieldEndLabelText', fieldEndLabelText))
      ..add(DiagnosticsProperty<bool>('autofocus', autofocus))
      ..add(DiagnosticsProperty<bool>('autovalidate', autovalidate))
      ..add(DiagnosticsProperty<TextInputType>('keyboardType', keyboardType))
      ..add(ObjectFlagProperty<SelectableDayForRangePredicate?>.has('selectableDayPredicate', selectableDayPredicate));
  }
}

class _InputDateRangePickerState extends State<_InputDateRangePicker> {
  late String _startInputText;
  late String _endInputText;
  DateTime? _startDate;
  DateTime? _endDate;
  late TextEditingController _startController;
  late TextEditingController _endController;
  String? _startErrorText;
  String? _endErrorText;
  bool _autoSelected = false;

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialStartDate;
    _startController = TextEditingController();
    _endDate = widget.initialEndDate;
    _endController = TextEditingController();
  }

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    if (_startDate != null) {
      _startInputText = localizations.formatCompactDate(_startDate!);
      final bool selectText = widget.autofocus && !_autoSelected;
      _updateController(_startController, _startInputText, selectText);
      _autoSelected = selectText;
    }

    if (_endDate != null) {
      _endInputText = localizations.formatCompactDate(_endDate!);
      _updateController(_endController, _endInputText, false);
    }
  }

  bool validate() {
    String? startError = _validateDate(_startDate);
    final String? endError = _validateDate(_endDate);
    if (startError == null && endError == null) {
      if (_startDate!.isAfter(_endDate!)) {
        startError = widget.errorInvalidRangeText ?? MaterialLocalizations.of(context).invalidDateRangeLabel;
      }
    }
    setState(() {
      _startErrorText = startError;
      _endErrorText = endError;
    });
    return startError == null && endError == null;
  }

  DateTime? _parseDate(String? text) {
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    return localizations.parseCompactDate(text);
  }

  String? _validateDate(DateTime? date) {
    if (date == null) {
      return widget.errorFormatText ?? MaterialLocalizations.of(context).invalidDateFormatLabel;
    } else if (!_isDaySelectable(date)) {
      return widget.errorInvalidText ?? MaterialLocalizations.of(context).dateOutOfRangeLabel;
    }
    return null;
  }

  bool _isDaySelectable(DateTime day) {
    if (day.isBefore(widget.firstDate) || day.isAfter(widget.lastDate)) {
      return false;
    }
    if (widget.selectableDayPredicate == null) {
      return true;
    }
    return widget.selectableDayPredicate!(day, _startDate, _endDate);
  }

  void _updateController(TextEditingController controller, String text, bool selectText) {
    TextEditingValue textEditingValue = controller.value.copyWith(text: text);
    if (selectText) {
      textEditingValue = textEditingValue.copyWith(selection: TextSelection(baseOffset: 0, extentOffset: text.length));
    }
    controller.value = textEditingValue;
  }

  void _handleStartChanged(String text) {
    setState(() {
      _startInputText = text;
      _startDate = _parseDate(text);
      widget.onStartDateChanged?.call(_startDate);
    });
    if (widget.autovalidate) {
      validate();
    }
  }

  void _handleEndChanged(String text) {
    setState(() {
      _endInputText = text;
      _endDate = _parseDate(text);
      widget.onEndDateChanged?.call(_endDate);
    });
    if (widget.autovalidate) {
      validate();
    }
  }

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: WaveTextFormField(
            controller: _startController,
            hintText: widget.fieldStartHintText ?? localizations.dateHelpText,
            title: widget.fieldStartLabelText ?? localizations.dateRangeStartLabel,
            errorText: _startErrorText,
            keyboardType: widget.keyboardType,
            onChanged: _handleStartChanged,
            autofocus: widget.autofocus,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: WaveTextFormField(
            controller: _endController,
            hintText: widget.fieldEndHintText ?? localizations.dateHelpText,
            title: widget.fieldEndLabelText ?? localizations.dateRangeEndLabel,
            errorText: _endErrorText,
            keyboardType: widget.keyboardType,
            onChanged: _handleEndChanged,
          ),
        ),
      ],
    );
  }
}
