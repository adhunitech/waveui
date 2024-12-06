import 'package:get/get.dart';
import 'package:waveui/src/src/picker/wave_tags_picker_config.dart';
import 'package:waveui/src/l10n/wave_intl.dart';
import 'package:waveui/src/theme/wave_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 描述: 标签组，支持多选

/// 标签组的样式
enum WaveMultiSelectStyle {
  /// 等分布局
  average,

  /// 流式布局
  auto,
}

/// 获取tag显示的内容
/// data tag对应的数据模型，根据data获取tag显示的内容
typedef WaveMultiSelectTagText<V> = String Function(V data);

///提交按钮事件回调
typedef WaveMultiSelectedTagsCallback = void Function(List<WaveTagItemBean> selectedTags);

class WaveMultiSelectTags extends StatefulWidget {
  ///当点击到最大数目时的点击事件
  final VoidCallback? onMaxSelectClick;

  ///一行多少个数据，默认 2
  final int waveCrossAxisCount;

  ///最多选择多少个item - 默认0，可以无限选
  final int maxSelectItemCount;

  /// 本类属性
  final WaveTagsPickerConfig tagPickerBean;

  /// 获取tag显示文案
  final WaveMultiSelectTagText<WaveTagItemBean> tagText;

  /// 已选中列表
  final WaveMultiSelectedTagsCallback? selectedTagsCallback;

  /// 没有数据时的样式
  final Widget? emptyWidget;

  /// 没有数据时的样式，如果为 null，默认 EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0, bottom: 0.0)
  final EdgeInsets padding;

  ///是等分样式还是流式布局样式 默认等分
  final WaveMultiSelectStyle tagStyle;

  /// 是否为多选
  final bool multiSelect;

  /// 滑动选项
  final ScrollPhysics? physics;

  /// 最小宽度，默认 75
  final double minWidth;

  const WaveMultiSelectTags({
    Key? key,
    required this.tagPickerBean,
    required this.tagText,
    this.onMaxSelectClick,
    this.maxSelectItemCount = 0,
    this.waveCrossAxisCount = 2,
    this.tagStyle = WaveMultiSelectStyle.average,
    this.selectedTagsCallback,
    this.emptyWidget,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
    this.multiSelect = true,
    this.physics,
    this.minWidth = 75,
  }) : super(key: key);

  @override
  _WaveMultiSelectTagsState createState() => _WaveMultiSelectTagsState();
}

class _WaveMultiSelectTagsState extends State<WaveMultiSelectTags> {
  /// 操作类型属性
  List<WaveTagItemBean> _selectedTags = [];
  List<WaveTagItemBean> _sourceTags = [];

  @override
  void initState() {
    super.initState();
    _dataSetup();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tagPickerBean.tagItemSource.isNotEmpty) {
      return _buildContent(context);
    } else {
      return widget.emptyWidget ??
          SizedBox(
            height: 200,
            child: Center(
              child: Text(WaveIntl.of(context).localizedResource.noTagDataTip),
            ),
          );
    }
  }

  Widget _buildContent(BuildContext context) {
    if (widget.tagStyle == WaveMultiSelectStyle.average) {
      return _buildGridViewWidget(context);
    } else {
      return _buildWrapViewWidget(context);
    }
  }

  ///等宽度的布局
  Widget _buildGridViewWidget(BuildContext context) {
    int waveCrossAxisCount = widget.waveCrossAxisCount;
    double width = (MediaQuery.of(context).size.width - (waveCrossAxisCount - 1) * 12 - 40) / waveCrossAxisCount;
    //计算宽高比
    double waveChildAspectRatio = width / 34.0;

    return Container(
      padding: widget.padding,
      constraints: const BoxConstraints(maxHeight: 322, minHeight: 120),
      child: GridView.count(
        shrinkWrap: true,
        physics: widget.physics,
        crossAxisCount: waveCrossAxisCount,
        //水平子Widget之间间距
        crossAxisSpacing: 12.0,
        //垂直子Widget之间间距
        mainAxisSpacing: 12.0,
        //宽高比
        childAspectRatio: waveChildAspectRatio,
        children: _sourceTags.map((choice) {
          return _getItem(choice, const EdgeInsets.only(left: 8, right: 8, bottom: 1));
        }).toList(),
      ),
    );
  }

  ///流式布局
  Widget _buildWrapViewWidget(BuildContext context) {
    return Container(
        padding: widget.padding,
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _sourceTags.map((choice) {
            return _getItem(choice, const EdgeInsets.only(left: 8, right: 8, top: 10.5, bottom: 11));
          }).toList(),
        ));
  }

  void _dataSetup() {
    List<WaveTagItemBean> tagItems = [];
    List<WaveTagItemBean> tagSelectItems = [];
    for (WaveTagItemBean item in widget.tagPickerBean.tagItemSource) {
      tagItems.add(item);
      //选中的按钮
      if (item.isSelect == true) {
        tagSelectItems.add(item);
      }
    }
    _sourceTags = tagItems;

    // 默认选中tags
    _selectedTags = tagSelectItems;
  }

  void _clickTag(bool selected, WaveTagItemBean tagName) {
    if (!widget.multiSelect) {
      /// 单选
      for (var tag in _sourceTags) {
        tag.isSelect = false;
      }
      _selectedTags.clear();
      tagName.isSelect = true;
      _selectedTags.add(tagName);
      if (widget.selectedTagsCallback != null) {
        widget.selectedTagsCallback!(_selectedTags);
      }
    } else {
      /// 多选
      if (selected) {
        tagName.isSelect = true;
        _selectedTags.add(tagName);
      } else {
        tagName.isSelect = false;
        _selectedTags.remove(tagName);
      }
      if (widget.selectedTagsCallback != null) {
        widget.selectedTagsCallback!(_selectedTags);
      }
    }
  }

  Widget _getItem(WaveTagItemBean choice, EdgeInsets padding) {
    Color selectedTagTitleColor = widget.tagPickerBean.selectedTagTitleColor ?? Get.theme.colorScheme.primary;
    Color tagTitleColor =
        widget.tagPickerBean.tagTitleColor ?? WaveThemeConfigurator.instance.getConfig().commonConfig.colorTextBase;
    Color tagBackgroundColor = widget.tagPickerBean.tagBackgroudColor ?? const Color(0xFFF8F8F8);
    Color selectedTagBackgroundColor =
        widget.tagPickerBean.selectedTagBackgroudColor ?? Get.theme.colorScheme.primary.withAlpha(0x14);

    bool selected = choice.isSelect;
    Color titleColor = selected ? selectedTagTitleColor : tagTitleColor;
    Color bgColor = selected ? selectedTagBackgroundColor : tagBackgroundColor;
    String textToDisplay = widget.tagText(choice);

    return GestureDetector(
      onTap: () {
        _clickTag(!selected, choice);
        setState(() {});
      },
      child: Container(
        constraints: BoxConstraints(minWidth: widget.minWidth),
        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(3.0)),
        padding: padding,
        alignment: widget.tagStyle == WaveMultiSelectStyle.average ? Alignment.center : null,
        child: Text(
          textToDisplay,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            fontSize: 12,
            color: titleColor,
          ),
        ),
      ),
    );
  }
}
