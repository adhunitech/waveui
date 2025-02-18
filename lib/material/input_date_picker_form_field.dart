// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/date.dart';
import 'package:waveui/material/date_picker_theme.dart';
import 'package:waveui/material/input_border.dart';
import 'package:waveui/material/input_decorator.dart';
import 'package:waveui/material/material_localizations.dart';
import 'package:waveui/material/text_form_field.dart';
import 'package:waveui/material/theme.dart';

class InputDatePickerFormField extends StatefulWidget {
  InputDatePickerFormField({
    required DateTime firstDate,
    required DateTime lastDate,
    super.key,
    DateTime? initialDate,
    this.onDateSubmitted,
    this.onDateSaved,
    this.selectableDayPredicate,
    this.errorFormatText,
    this.errorInvalidText,
    this.fieldHintText,
    this.fieldLabelText,
    this.keyboardType,
    this.autofocus = false,
    this.acceptEmptyDate = false,
    this.focusNode,
  }) : initialDate = initialDate != null ? DateUtils.dateOnly(initialDate) : null,
       firstDate = DateUtils.dateOnly(firstDate),
       lastDate = DateUtils.dateOnly(lastDate) {
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
      'Provided initialDate ${this.initialDate} must satisfy provided selectableDayPredicate.',
    );
  }

  final DateTime? initialDate;

  final DateTime firstDate;

  final DateTime lastDate;

  final ValueChanged<DateTime>? onDateSubmitted;

  final ValueChanged<DateTime>? onDateSaved;

  final SelectableDayPredicate? selectableDayPredicate;

  final String? errorFormatText;

  final String? errorInvalidText;

  final String? fieldHintText;

  final String? fieldLabelText;

  final TextInputType? keyboardType;

  final bool autofocus;

  final bool acceptEmptyDate;

  final FocusNode? focusNode;

  @override
  State<InputDatePickerFormField> createState() => _InputDatePickerFormFieldState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<DateTime?>('initialDate', initialDate));
    properties.add(DiagnosticsProperty<DateTime>('firstDate', firstDate));
    properties.add(DiagnosticsProperty<DateTime>('lastDate', lastDate));
    properties.add(ObjectFlagProperty<ValueChanged<DateTime>?>.has('onDateSubmitted', onDateSubmitted));
    properties.add(ObjectFlagProperty<ValueChanged<DateTime>?>.has('onDateSaved', onDateSaved));
    properties.add(ObjectFlagProperty<SelectableDayPredicate?>.has('selectableDayPredicate', selectableDayPredicate));
    properties.add(StringProperty('errorFormatText', errorFormatText));
    properties.add(StringProperty('errorInvalidText', errorInvalidText));
    properties.add(StringProperty('fieldHintText', fieldHintText));
    properties.add(StringProperty('fieldLabelText', fieldLabelText));
    properties.add(DiagnosticsProperty<TextInputType?>('keyboardType', keyboardType));
    properties.add(DiagnosticsProperty<bool>('autofocus', autofocus));
    properties.add(DiagnosticsProperty<bool>('acceptEmptyDate', acceptEmptyDate));
    properties.add(DiagnosticsProperty<FocusNode?>('focusNode', focusNode));
  }
}

class _InputDatePickerFormFieldState extends State<InputDatePickerFormField> {
  final TextEditingController _controller = TextEditingController();
  DateTime? _selectedDate;
  String? _inputText;
  bool _autoSelected = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateValueForSelectedDate();
  }

  @override
  void didUpdateWidget(InputDatePickerFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialDate != oldWidget.initialDate) {
      // Can't update the form field in the middle of a build, so do it next frame
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {
          _selectedDate = widget.initialDate;
          _updateValueForSelectedDate();
        });
      }, debugLabel: 'InputDatePickerFormField.update');
    }
  }

  void _updateValueForSelectedDate() {
    if (_selectedDate != null) {
      final MaterialLocalizations localizations = MaterialLocalizations.of(context);
      _inputText = localizations.formatCompactDate(_selectedDate!);
      TextEditingValue textEditingValue = TextEditingValue(text: _inputText!);
      // Select the new text if we are auto focused and haven't selected the text before.
      if (widget.autofocus && !_autoSelected) {
        textEditingValue = textEditingValue.copyWith(
          selection: TextSelection(baseOffset: 0, extentOffset: _inputText!.length),
        );
        _autoSelected = true;
      }
      _controller.value = textEditingValue;
    } else {
      _inputText = '';
      _controller.value = TextEditingValue(text: _inputText!);
    }
  }

  DateTime? _parseDate(String? text) {
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    return localizations.parseCompactDate(text);
  }

  bool _isValidAcceptableDate(DateTime? date) =>
      date != null &&
      !date.isBefore(widget.firstDate) &&
      !date.isAfter(widget.lastDate) &&
      (widget.selectableDayPredicate == null || widget.selectableDayPredicate!(date));

  String? _validateDate(String? text) {
    if ((text == null || text.isEmpty) && widget.acceptEmptyDate) {
      return null;
    }
    final DateTime? date = _parseDate(text);
    if (date == null) {
      return widget.errorFormatText ?? MaterialLocalizations.of(context).invalidDateFormatLabel;
    } else if (!_isValidAcceptableDate(date)) {
      return widget.errorInvalidText ?? MaterialLocalizations.of(context).dateOutOfRangeLabel;
    }
    return null;
  }

  void _updateDate(String? text, ValueChanged<DateTime>? callback) {
    final DateTime? date = _parseDate(text);
    if (_isValidAcceptableDate(date)) {
      _selectedDate = date;
      _inputText = text;
      callback?.call(_selectedDate!);
    }
  }

  void _handleSaved(String? text) {
    _updateDate(text, widget.onDateSaved);
  }

  void _handleSubmitted(String text) {
    _updateDate(text, widget.onDateSubmitted);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final DatePickerThemeData datePickerTheme = theme.datePickerTheme;
    final InputDecorationTheme inputTheme = theme.inputDecorationTheme;
    final InputBorder effectiveInputBorder =
        datePickerTheme.inputDecorationTheme?.border ?? theme.inputDecorationTheme.border ?? const OutlineInputBorder();

    return Semantics(
      container: true,
      child: TextFormField(
        decoration: InputDecoration(
          hintText: widget.fieldHintText ?? localizations.dateHelpText,
          labelText: widget.fieldLabelText ?? localizations.dateInputLabel,
        ).applyDefaults(inputTheme.merge(datePickerTheme.inputDecorationTheme).copyWith(border: effectiveInputBorder)),
        validator: _validateDate,
        keyboardType: widget.keyboardType ?? TextInputType.datetime,
        onSaved: _handleSaved,
        onFieldSubmitted: _handleSubmitted,
        autofocus: widget.autofocus,
        controller: _controller,
        focusNode: widget.focusNode,
      ),
    );
  }
}
