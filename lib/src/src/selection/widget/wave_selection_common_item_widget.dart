import 'package:waveui/src/src/selection/bean/wave_selection_common_entity.dart';
import 'package:waveui/src/src/selection/wave_selection_util.dart';
import 'package:waveui/src/constants/wave_asset_constants.dart';
import 'package:waveui/src/theme/configs/wave_selection_config.dart';
import 'package:waveui/src/utils/wave_tools.dart';
import 'package:waveui/src/utils/css/wave_css_2_text.dart';
import 'package:flutter/material.dart';

class WaveSelectionCommonItemWidget extends StatelessWidget {
  final WaveSelectionEntity item;
  final Color? backgroundColor;
  final Color? selectedBackgroundColor;
  final bool isCurrentFocused;
  final bool isFirstLevel;
  final bool isMoreSelectionListType;

  final ValueChanged<WaveSelectionEntity>? itemSelectFunction;

  final WaveSelectionConfig? themeData;

  const WaveSelectionCommonItemWidget({
    Key? key,
    required this.item,
    this.backgroundColor,
    this.isFirstLevel = false,
    this.isMoreSelectionListType = false,
    this.itemSelectFunction,
    this.selectedBackgroundColor,
    this.isCurrentFocused = false,
    this.themeData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Container checkbox;
    if (!item.isUnLimit() && (item.children.isEmpty)) {
      if (item.isInLastLevel() && item.hasCheckBoxBrother()) {
        checkbox = Container(
          padding: const EdgeInsets.only(left: 6),
          width: 21,
          child: (item.isSelected)
              ? WaveUITools.getAssetImageWithBandColor(WaveAsset.iconMultiSelected)
              : WaveUITools.getAssetImage(WaveAsset.iconUnSelect),
        );
      } else {
        checkbox = Container();
      }
    } else {
      checkbox = Container();
    }

    return GestureDetector(
      onTap: () {
        if (itemSelectFunction != null) {
          itemSelectFunction!(item);
        }
      },
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        color: getItemBGColor(),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    child: Expanded(
                      child: Text(
                        item.title + getSelectedItemCount(item),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: getItemTextStyle(),
                      ),
                    ),
                  ),
                  checkbox
                ],
              ),
              Visibility(
                visible: !WaveUITools.isEmpty(item.subTitle),
                child: Padding(
                  padding: EdgeInsets.only(right: item.isInLastLevel() ? 21 : 0),
                  child: WaveCSS2Text.toTextView(item.subTitle ?? '',
                      defaultStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.none,
                          color: themeData?.commonConfig.colorTextSecondary),
                      maxLines: 1,
                      textOverflow: TextOverflow.ellipsis),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Color? getItemBGColor() {
    if (isCurrentFocused) {
      return selectedBackgroundColor;
    } else {
      return backgroundColor;
    }
  }

  bool isHighLight(WaveSelectionEntity item) {
    if (item.isInLastLevel()) {
      if (item.isUnLimit()) {
        return isCurrentFocused;
      } else {
        return item.isSelected;
      }
    } else {
      return isCurrentFocused;
    }
  }

  bool isBold(WaveSelectionEntity item) {
    if (isHighLight(item)) {
      return true;
    } else {
      return item.hasCheckBoxBrother() && item.selectedList().isNotEmpty;
    }
  }

  TextStyle? getItemTextStyle() {
    if (isHighLight(item)) {
      return themeData?.itemSelectedTextStyle.generateTextStyle();
    } else if (isBold(item)) {
      return themeData?.itemBoldTextStyle.generateTextStyle();
    }
    return themeData?.itemNormalTextStyle.generateTextStyle();
  }

  String getSelectedItemCount(WaveSelectionEntity item) {
    String itemCount = "";
    if ((WaveSelectionUtil.getTotalLevel(item) < 3 || !isFirstLevel) && item.children.isNotEmpty) {
      int count = item.children.where((f) => f.isSelected && !f.isUnLimit()).length;
      if (count > 1) {
        return '($count)';
      } else if (count == 1 && item.hasCheckBoxBrother()) {
        return '($count)';
      } else {
        var unLimited = item.children.where((f) => f.isSelected && f.isUnLimit()).toList();
        if (unLimited.isNotEmpty) {
          return '(全部)';
        }
      }
    }
    return itemCount;
  }
}
