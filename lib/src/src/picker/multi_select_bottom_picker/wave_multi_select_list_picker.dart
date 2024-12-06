import 'package:get/get.dart';
import 'package:waveui/src/src/line/wave_line.dart';
import 'package:waveui/src/src/picker/base/wave_picker_constants.dart';
import 'package:waveui/src/src/picker/base/wave_picker_title.dart';
import 'package:waveui/src/src/picker/base/wave_picker_title_config.dart';
import 'package:waveui/src/src/picker/wave_picker_cliprrect.dart';
import 'package:waveui/src/src/picker/multi_select_bottom_picker/wave_multi_select_data.dart';
import 'package:waveui/src/constants/wave_asset_constants.dart';
import 'package:waveui/src/theme/wave_theme_configurator.dart';
import 'package:waveui/src/utils/wave_tools.dart';
import 'package:flutter/material.dart';

/// 点击确定时的回调
/// [checkedItems] 被选中的 item 集合
typedef WaveMultiSelectListPickerSubmit<T> = void Function(List<T> checkedItems);

/// item 被点击时的回调
/// [index] item 的索引
typedef WaveMultiSelectListPickerItemClick = void Function(BuildContext context, int index);

/// 多选列表 Picker

class WaveMultiSelectListPicker<T extends WaveMultiSelectBottomPickerItem> extends StatefulWidget {
  final String? title;
  final List<T> items;
  final WaveMultiSelectListPickerSubmit<T>? onSubmit;
  final VoidCallback? onCancel;
  final WaveMultiSelectListPickerItemClick? onItemClick;
  final WavePickerTitleConfig pickerTitleConfig;

  static void show<T extends WaveMultiSelectBottomPickerItem>(
    BuildContext context, {
    required List<T> items,
    WaveMultiSelectListPickerSubmit<T>? onSubmit,
    VoidCallback? onCancel,
    WaveMultiSelectListPickerItemClick? onItemClick,
    WavePickerTitleConfig pickerTitleConfig = WavePickerTitleConfig.Default,
    bool isDismissible = true,
  }) {
    showModalBottomSheet(
      context: context,
      isDismissible: isDismissible,
      backgroundColor: Colors.transparent,
      builder: (BuildContext dialogContext) {
        return WaveMultiSelectListPicker<T>(
          items: items,
          onSubmit: onSubmit,
          onCancel: onCancel,
          onItemClick: onItemClick,
          pickerTitleConfig: pickerTitleConfig,
        );
      },
    );
  }

  const WaveMultiSelectListPicker({
    Key? key,
    this.title,
    required this.items,
    this.pickerTitleConfig = WavePickerTitleConfig.Default,
    this.onSubmit,
    this.onCancel,
    this.onItemClick,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MultiSelectDialogWidgetState<T>();
  }
}

class MultiSelectDialogWidgetState<T extends WaveMultiSelectBottomPickerItem>
    extends State<WaveMultiSelectListPicker<T>> {
  @override
  Widget build(BuildContext context) {
    return WavePickerClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(WaveThemeConfigurator.instance.getConfig().pickerConfig.cornerRadius),
        topRight: Radius.circular(WaveThemeConfigurator.instance.getConfig().pickerConfig.cornerRadius),
      ),
      child: Container(
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Offstage(
                  offstage: !widget.pickerTitleConfig.showTitle,
                  child: WavePickerTitle(
                    pickerTitleConfig: widget.pickerTitleConfig,
                    onConfirm: () {
                      List<T> selectedItems = [];
                      if (widget.onSubmit != null) {
                        for (int i = 0; i < widget.items.length; i++) {
                          if (widget.items[i].isChecked) {
                            selectedItems.add(widget.items[i]);
                          }
                        }
                        if (widget.onSubmit != null) {
                          widget.onSubmit!(selectedItems);
                        }
                      }
                    },
                    onCancel: widget.onCancel ??
                        () {
                          Navigator.of(context).pop();
                        },
                  ),
                ),
                LimitedBox(
                    maxWidth: double.infinity,
                    maxHeight: pickerHeight,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) => _buildItem(context, index),
                        itemCount: widget.items.length)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            widget.items[index].isChecked = !widget.items[index].isChecked;
          });
          if (widget.onItemClick != null) {
            widget.onItemClick!(context, index);
          }
        },
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Text(widget.items[index].content,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: widget.items[index].isChecked ? FontWeight.w600 : FontWeight.normal,
                              color: widget.items[index].isChecked
                                  ? Get.theme.colorScheme.primary
                                  : WaveThemeConfigurator.instance.getConfig().commonConfig.colorTextBase))),
                  Container(
                      alignment: Alignment.center,
                      height: 50,
                      child: widget.items[index].isChecked
                          ? WaveUITools.getAssetImageWithBandColor(WaveAsset.iconMultiSelected)
                          : WaveUITools.getAssetImage(WaveAsset.iconUnSelect)),
                ],
              ),
            ),
            index != widget.items.length - 1
                ? const Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 0), child: WaveLine())
                : const SizedBox.shrink()
          ],
        ));
  }
}
