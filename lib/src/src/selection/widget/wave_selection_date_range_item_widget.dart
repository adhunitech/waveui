import 'package:get/get.dart';
import 'package:waveui/src/src/picker/base/wave_picker_title_config.dart';
import 'package:waveui/src/src/picker/time_picker/wave_date_time_formatter.dart';
import 'package:waveui/src/src/picker/time_picker/date_picker/wave_date_widget.dart';
import 'package:waveui/src/src/selection/bean/wave_selection_common_entity.dart';
import 'package:waveui/src/src/selection/controller/wave_selection_view_date_picker_controller.dart';
import 'package:waveui/src/src/selection/widget/wave_selection_datepicker_animate_widget.dart';
import 'package:waveui/src/l10n/wave_intl.dart';
import 'package:waveui/src/theme/configs/wave_selection_config.dart';
import 'package:waveui/src/utils/wave_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const String _defaultDateFormat = 'yyyy年MM月dd日';

// ignore: must_be_immutable
class WaveSelectionDateRangeItemWidget extends StatefulWidget {
  final WaveSelectionEntity item;

  /// 输入框显示文字大小
  final double showTextSize;

  /// 是否需要标题
  final bool isNeedTitle;

  /// 日期格式
  final String dateFormat;

  final TextEditingController minTextEditingController;
  final TextEditingController maxTextEditingController;

  final VoidCallback? onTapped;

  WaveSelectionConfig themeData;

  WaveSelectionDateRangeItemWidget(
      {Key? key,
      required this.item,
      required this.minTextEditingController,
      required this.maxTextEditingController,
      this.isNeedTitle = true,
      this.showTextSize = 16,
      this.dateFormat = _defaultDateFormat,
      this.onTapped,
      required this.themeData})
      : super(key: key);

  @override
  _WaveSelectionDateRangeItemWidgetState createState() => _WaveSelectionDateRangeItemWidgetState();
}

class _WaveSelectionDateRangeItemWidgetState extends State<WaveSelectionDateRangeItemWidget> {
  final WaveSelectionDatePickerController _datePickerController = WaveSelectionDatePickerController();

  @override
  void initState() {
    DateTime? minDateTime;
    if (widget.item.customMap != null && widget.item.customMap!['min'] != null) {
      minDateTime = DateTimeFormatter.convertIntValueToDateTime(widget.item.customMap!['min']);
    }
    DateTime? maxDateTime;
    if (widget.item.customMap != null && widget.item.customMap!['max'] != null) {
      maxDateTime = DateTimeFormatter.convertIntValueToDateTime(widget.item.customMap!['max']);
    }
    widget.minTextEditingController.text =
        minDateTime != null ? DateTimeFormatter.formatDate(minDateTime, widget.dateFormat) : '';
    widget.maxTextEditingController.text =
        maxDateTime != null ? DateTimeFormatter.formatDate(maxDateTime, widget.dateFormat) : '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Column(
          children: <Widget>[
            widget.isNeedTitle
                ? Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.item.title.isEmpty
                          ? WaveIntl.of(context).localizedResource.customRange
                          : widget.item.title,
                      textAlign: TextAlign.left,
                      style: widget.themeData.rangeTitleTextStyle.generateTextStyle(),
                    ),
                  )
                : Container(),
            Row(
              children: <Widget>[
                getDateRangeTextField(false),
                Container(
                  child: Text(
                    WaveIntl.of(context).localizedResource.to,
                    style: widget.themeData.inputTextStyle.generateTextStyle(),
                  ),
                ),
                getDateRangeTextField(true),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget getDateRangeTextField(bool isMax) {
    return Expanded(
      child: TextField(
        enableInteractiveSelection: false,
        readOnly: true,
        onTap: () {
          if (widget.onTapped != null) {
            widget.onTapped!();
          }
          onTextTapped(isMax);
        },
        style: widget.themeData.inputTextStyle.generateTextStyle(),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: const TextInputType.numberWithOptions(),
        onChanged: (input) {
          widget.item.isSelected = true;
        },
        controller: isMax ? widget.maxTextEditingController : widget.minTextEditingController,
        cursorColor: Get.theme.colorScheme.primary,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintStyle: widget.themeData.hintTextStyle.generateTextStyle(),
          hintText: (!isMax
              ? WaveIntl.of(context).localizedResource.startDate
              : WaveIntl.of(context).localizedResource.endDate),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
            width: 1,
            color: widget.themeData.commonConfig.borderColorBase,
          )),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
            width: 1,
            color: widget.themeData.commonConfig.borderColorBase,
          )),
          contentPadding: const EdgeInsets.all(0),
        ),
      ),
    );
  }

  void onTextTapped(bool isMax) {
    if (_datePickerController.isShow) return;
    String format = 'yyyy年,MM月,dd日';
    DateTime? minDate = DateTimeFormatter.convertIntValueToDateTime((widget.item.extMap)['min']);
    DateTime? maxDate = DateTimeFormatter.convertIntValueToDateTime((widget.item.extMap)['max']);

    DateTime? minSelectedDateTime = WaveUITools.isEmpty(widget.item.customMap)
        ? null
        : DateTimeFormatter.convertIntValueToDateTime(widget.item.customMap!['min']);
    DateTime? maxSelectedDateTime = WaveUITools.isEmpty(widget.item.customMap)
        ? null
        : DateTimeFormatter.convertIntValueToDateTime(widget.item.customMap!['max']);

    DateTime? minDateTime;
    DateTime? maxDateTime;
    if (widget.item.customMap == null ||
        (widget.item.customMap!['min'] == null && widget.item.customMap!['max'] == null)) {
      // 如果开始时间和结束时间均未选择
      minDateTime = minDate;
      maxDateTime = maxDate;
    } else {
      minDateTime = !isMax ? minDate : (minSelectedDateTime ?? minDate);
      maxDateTime = isMax ? maxDate : (maxSelectedDateTime ?? maxDate);
    }

    Widget content = WaveDateWidget(
      canPop: false,
      minDateTime: minDateTime,
      maxDateTime: maxDateTime,
      initialDateTime: isMax ? maxSelectedDateTime : minSelectedDateTime,
      dateFormat: format,
      pickerTitleConfig: WavePickerTitleConfig(
          showTitle: true,
          // UI 规范规定高度按照比例设置，UI稿的比利为 240 / 812
          titleContent: isMax
              ? WaveIntl.of(context).localizedResource.selectEndDate
              : WaveIntl.of(context).localizedResource.selectStartDate),
      onCancel: () {
        closeSelectionPopupWindow();
      },
      onConfirm: (DateTime selectedDate, List<int> selectedIndex) {
        widget.item.isSelected = true;
        String selectedDateStr = DateTimeFormatter.formatDate(selectedDate, widget.dateFormat);
        if (isMax) {
          widget.maxTextEditingController.text = selectedDateStr;
        } else {
          widget.minTextEditingController.text = selectedDateStr;
        }
        widget.item.customMap ??= {};
        widget.item.customMap![isMax ? 'max' : 'min'] = selectedDate.millisecondsSinceEpoch.toString();
        closeSelectionPopupWindow();

        if (!isMax && WaveUITools.isEmpty(widget.maxTextEditingController.text)) {
          onTextTapped(true);
        }
        setState(() {});
      },
    );
    OverlayEntry entry = _createDatePickerEntry(context, content);
    Overlay.of(context).insert(entry);
    _datePickerController.entry = entry;
    _datePickerController.show();
  }

  OverlayEntry _createDatePickerEntry(BuildContext context, Widget content) {
    return OverlayEntry(builder: (context) {
      return GestureDetector(
        onTap: () {
          closeSelectionPopupWindow();
        },
        child: Container(
          color: const Color(0xB3000000),
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.bottomCenter,
          child: WaveSelectionDatePickerAnimationWidget(controller: _datePickerController, view: content),
        ),
      );
    });
  }

  void closeSelectionPopupWindow() {
    if (_datePickerController.isShow) {
      _datePickerController.hide();
    }
  }

  @override
  void dispose() {
    _datePickerController.hide();
    super.dispose();
  }
}
