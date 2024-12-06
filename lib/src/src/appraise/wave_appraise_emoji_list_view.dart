import 'package:waveui/src/src/appraise/wave_appraise_emoji_item.dart';
import 'package:waveui/src/constants/wave_asset_constants.dart';
import 'package:flutter/material.dart';
import 'package:waveui/src/src/appraise/wave_appraise_interface.dart';

/// 描述: 表情评价列表
///       最多支持5个表情，默认也是5个，支持选择任意个数，
///       传入@indexes就可以选择想要的任意位置的表情了

class WaveAppraiseEmojiListView extends StatefulWidget {
  /// 所需表情包的index列表，index最大值为4
  final List<int> indexes;

  /// 自定义文案，list长度为5，不足5个时请在对应位置补空字符串
  List<String>? titles;

  /// 点击回调
  final WaveAppraiseIconClick? onTap;

  WaveAppraiseEmojiListView({Key? key, this.indexes = const [0, 1, 2, 3, 4], this.titles, this.onTap})
      : assert(indexes.isNotEmpty),
        super(key: key) {
    titles ??= ["Worst", "Bad", "Nevermind", "Good", "Best"];
    assert(titles != null && titles!.length == 5);
  }

  @override
  _WaveAppraiseEmojiListViewState createState() => _WaveAppraiseEmojiListViewState();
}

class _WaveAppraiseEmojiListViewState extends State<WaveAppraiseEmojiListView> {
  /// 未选中表情，灰色
  final List _unselectedIcons = [
    WaveAsset.iconAppraiseBadUnselected,
    WaveAsset.iconAppraiseNotGoodUnselected,
    WaveAsset.iconAppraiseOkUnselected,
    WaveAsset.iconAppraiseGoodUnselected,
    WaveAsset.iconAppraiseSurpriseUnselected,
  ];

  /// 默认表情，黄色
  final List _defaultIcons = [
    WaveAsset.iconAppraiseBadDefault,
    WaveAsset.iconAppraiseNotGoodDefault,
    WaveAsset.iconAppraiseOkDefault,
    WaveAsset.iconAppraiseGoodDefault,
    WaveAsset.iconAppraiseSurpriseDefault,
  ];

  /// 选中表情，gif
  final List _selectedIcons = [
    WaveAsset.iconAppraiseBadSelected,
    WaveAsset.iconAppraiseNotGoodSelected,
    WaveAsset.iconAppraiseOkSelected,
    WaveAsset.iconAppraiseGoodSelected,
    WaveAsset.iconAppraiseSurpriseSelected,
  ];

  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.indexes.isEmpty) {
      return const SizedBox.shrink();
    }

    List<WaveAppraiseEmojiItem> list = [];
    for (int i = 0; i < widget.indexes.length; i++) {
      list.add(WaveAppraiseEmojiItem(
        selectedName: _selectedIcons[widget.indexes[i]],
        unselectedName: _unselectedIcons[widget.indexes[i]],
        defaultName: _defaultIcons[widget.indexes[i]],
        index: i,
        padding: EdgeInsets.symmetric(horizontal: 7.0 * (6 - widget.indexes.length)),
        selectedIndex: _selectedIndex,
        title: widget.titles![widget.indexes[i]],
        onTap: (index) {
          _selectedIndex = index;
          if (widget.onTap != null) {
            widget.onTap!(_selectedIndex);
          }
        },
      ));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: list,
    );
  }
}
