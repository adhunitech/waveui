import 'package:get/get.dart';
import 'package:waveui/src/src/selection/bean/wave_selection_common_entity.dart';
import 'package:waveui/src/l10n/wave_intl.dart';
import 'package:waveui/src/theme/configs/wave_selection_config.dart';
import 'package:waveui/src/utils/wave_event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef RangeChangedCallback = void Function(String minInput, String maxInput);

/// 清空自定义范围输入框焦点的事件类
class ClearSelectionFocusEvent {}

class WaveSelectionRangeItemWidget extends StatefulWidget {
  final WaveSelectionEntity item;

  final RangeChangedCallback? onRangeChanged;
  final ValueChanged<bool>? onFocusChanged;

  final bool isShouldClearText;

  final TextEditingController minTextEditingController;
  final TextEditingController maxTextEditingController;

  final WaveSelectionConfig themeData;

  const WaveSelectionRangeItemWidget({
    Key? key,
    required this.item,
    required this.minTextEditingController,
    required this.maxTextEditingController,
    this.isShouldClearText = false,
    this.onRangeChanged,
    this.onFocusChanged,
    required this.themeData,
  }) : super(key: key);

  @override
  _WaveSelectionRangeItemWidgetState createState() => _WaveSelectionRangeItemWidgetState();
}

class _WaveSelectionRangeItemWidgetState extends State<WaveSelectionRangeItemWidget> {
  final FocusNode _minFocusNode = FocusNode();
  final FocusNode _maxFocusNode = FocusNode();

  @override
  void initState() {
    widget.minTextEditingController.text = (widget.item.customMap != null && widget.item.customMap!['min'] != null)
        ? widget.item.customMap!['min']?.toString() ?? ''
        : '';
    widget.maxTextEditingController.text = (widget.item.customMap != null && widget.item.customMap!['max'] != null)
        ? widget.item.customMap!['max']?.toString() ?? ''
        : '';

    //输入框焦点
    _minFocusNode.addListener(() {
      if (widget.onFocusChanged != null) {
        widget.onFocusChanged!(_minFocusNode.hasFocus || _maxFocusNode.hasFocus);
      }
    });

    _maxFocusNode.addListener(() {
      if (widget.onFocusChanged != null) {
        widget.onFocusChanged!(_minFocusNode.hasFocus || _maxFocusNode.hasFocus);
      }
    });

    widget.minTextEditingController.addListener(() {
      String minInput = widget.minTextEditingController.text;

      widget.item.customMap ??= {};
      widget.item.customMap!['min'] = minInput;
      widget.item.isSelected = true;
    });

    widget.maxTextEditingController.addListener(() {
      String maxInput = widget.maxTextEditingController.text;
      widget.item.customMap ??= {};
      widget.item.customMap!['max'] = maxInput;
      widget.item.isSelected = true;
    });

    EventBus.instance.on<ClearSelectionFocusEvent>().listen((ClearSelectionFocusEvent event) {
      _minFocusNode.unfocus();
      _maxFocusNode.unfocus();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 5),
              alignment: Alignment.centerLeft,
              child: Text(
                "${widget.item.title.isNotEmpty ? widget.item.title : WaveIntl.of(context).localizedResource.customRange}(${widget.item.extMap['unit']?.toString() ?? ''})",
                textAlign: TextAlign.left,
                style: widget.themeData.rangeTitleTextStyle.generateTextStyle(),
              ),
            ),
            Row(
              children: <Widget>[
                getRangeTextField(false),
                Container(
                  child: Text(
                    WaveIntl.of(context).localizedResource.to,
                    style: widget.themeData.inputTextStyle.generateTextStyle(),
                  ),
                ),
                getRangeTextField(true),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget getRangeTextField(bool isMax) {
    return Expanded(
      child: TextFormField(
        style: widget.themeData.inputTextStyle.generateTextStyle(),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: const TextInputType.numberWithOptions(),
        onChanged: (input) {
          widget.item.isSelected = true;
        },
        focusNode: isMax ? _maxFocusNode : _minFocusNode,
        controller: isMax ? widget.maxTextEditingController : widget.minTextEditingController,
        cursorColor: Get.theme.colorScheme.primary,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintStyle: widget.themeData.hintTextStyle.generateTextStyle(),
          hintText: (isMax
              ? WaveIntl.of(context).localizedResource.maxValue
              : WaveIntl.of(context).localizedResource.minValue),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
            width: 1,
            color: widget.themeData.commonConfig.dividerColorBase,
          )),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
            width: 1,
            color: widget.themeData.commonConfig.dividerColorBase,
          )),
          contentPadding: const EdgeInsets.all(0),
        ),
      ),
    );
  }
}
