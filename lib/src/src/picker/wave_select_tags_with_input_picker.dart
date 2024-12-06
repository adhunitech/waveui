import 'package:get/get.dart';
import 'package:waveui/src/src/picker/wave_picker_cliprrect.dart';
import 'package:waveui/src/constants/wave_asset_constants.dart';
import 'package:waveui/src/l10n/wave_intl.dart';
import 'package:waveui/src/theme/wave_theme_configurator.dart';
import 'package:waveui/src/utils/wave_tools.dart';
import 'package:flutter/material.dart';

///传入的泛型数据转换为值 以填充Widget
typedef SelectTagWithInputValueGetter<V> = String Function(V data);

///提交按钮事件回调
typedef WaveTagInputConfirmClickCallback = Future<void>? Function(
    BuildContext dialogContext, List<WaveTagInputItemBean>? selectedTags, String content);

///关闭 picker回调
typedef WaveTagInputCancelClickCallBack = void Function(BuildContext context);

/// 底部弹出的标签选择器，支持文本内容输入。支持单选、多选标签。
class WaveSelectTagsWithInputPicker extends Dialog {
  ///弹窗自定义标题
  final String title;

  ///输入框默认提示文案
  final String? hintText;

  ///输入框最大能输入的字符长度。默认值 200
  final int maxLength;

  ///输入内容事件回调
  final WaveTagInputConfirmClickCallback? confirm;

  ///关闭 picker 回调
  final WaveTagInputCancelClickCallBack? cancelCallBack;

  ///光标颜色
  final Color? cursorColor;

  /// 默认文本
  final String? defaultText;

  /// 用于对 TextField 更精细的控制，若传入该字段，[defaultText] 参数将失效，可使用 TextEditingController.text 进行赋值。
  final TextEditingController? textEditingController;

  /// 强制显示文本框
  final bool forceShowTextInput;

  /// 多选/单选
  final bool multiSelect;

  /// tags 数据源
  final WaveTagsInputPickerConfig tagPickerConfig;

  /// 动态获取标签的展示文本回调
  final SelectTagWithInputValueGetter<WaveTagInputItemBean> onTagValueGetter;

  const WaveSelectTagsWithInputPicker(
      {super.key,
      this.maxLength = 200,
      this.hintText,
      this.title = "",
      this.confirm,
      this.cancelCallBack,
      this.cursorColor,
      this.forceShowTextInput = false,
      this.multiSelect = false,
      this.defaultText,
      this.textEditingController,
      required this.tagPickerConfig,
      required this.onTagValueGetter});

  @override
  Widget build(BuildContext context) {
    return WaveSelectTagsWithInputPickerWidget(
      title: title,
      confirm: confirm,
      maxLength: maxLength,
      hintText: hintText ?? WaveIntl.of(context).localizedResource.pleaseEnter,
      cursorColor: cursorColor ?? Get.theme.colorScheme.primary,
      forceShowTextInput: forceShowTextInput,
      multiSelect: multiSelect,
      defaultText: defaultText,
      textEditingController: textEditingController,
      tagPickerBean: tagPickerConfig,
      onTagValueGetter: onTagValueGetter,
    );
  }
}

class WaveSelectTagsWithInputPickerWidget extends StatefulWidget {
  final String? title;
  final WaveTagInputConfirmClickCallback? confirm;
  final WaveTagInputCancelClickCallBack? cancelCallBack;
  final int? maxLength;
  final String? hintText;
  final Color? cursorColor;
  final bool forceShowTextInput;
  final bool multiSelect;
  final String? defaultText;
  final TextEditingController? textEditingController;
  final WaveTagsInputPickerConfig? tagPickerBean;
  final SelectTagWithInputValueGetter<WaveTagInputItemBean>? onTagValueGetter;

  const WaveSelectTagsWithInputPickerWidget(
      {Key? key,
      this.title,
      this.confirm,
      this.cancelCallBack,
      this.maxLength,
      this.hintText,
      this.cursorColor,
      this.forceShowTextInput = false,
      this.multiSelect = false,
      this.defaultText,
      this.textEditingController,
      this.tagPickerBean,
      this.onTagValueGetter})
      : super(key: key);

  @override
  _WaveSelectTagsWithInputPickerWidgetState createState() => _WaveSelectTagsWithInputPickerWidgetState();
}

class _WaveSelectTagsWithInputPickerWidgetState extends State<WaveSelectTagsWithInputPickerWidget>
    with AutomaticKeepAliveClientMixin {
  TextEditingController? _textEditingController;

  /// 暂定只支持两列标签
  int waveCrossAxisCount = 2;

  late List<WaveTagInputItemBean> _selectedTags;
  late List<WaveTagInputItemBean> _sourceTags;

  @override
  void initState() {
    super.initState();
    _dataSetup();
    _textEditingController = widget.textEditingController ??
        TextEditingController.fromValue(TextEditingValue(
            text: widget.defaultText == null ? "" : widget.defaultText!,
            selection: TextSelection.fromPosition(TextPosition(
                affinity: TextAffinity.downstream,
                offset: widget.defaultText != null ? widget.defaultText!.length : 0))));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0x33999999),
      body: Container(
        alignment: Alignment.bottomCenter,
        child: WavePickerClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(WaveThemeConfigurator.instance.getConfig().pickerConfig.cornerRadius),
            topRight: Radius.circular(WaveThemeConfigurator.instance.getConfig().pickerConfig.cornerRadius),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: (widget.tagPickerBean?.tagItemSource.isNotEmpty ?? false)
                ? _buildBody(context)
                : _buildNoTagsBody(context),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildNoTagsBody(BuildContext context) {
    return [
      _headerArea(context),
      Container(
        color: Colors.white,
        height: 200,
        child: Center(
          child: Text(WaveIntl.of(context).localizedResource.noTagDataTip),
        ),
      ),
    ];
  }

  List<Widget> _buildBody(BuildContext context) {
    return [
      _headerArea(context),
      Container(
        color: Colors.white,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 220),
          child: ListView(
            shrinkWrap: true,
            controller: ScrollController(keepScrollOffset: false),
            children: <Widget>[
              _tagsArea(context),
              Offstage(
                offstage: !isShowTextInput(),
                child: _inputArea(context),
              ),
            ],
          ),
        ),
      ),
      _confirmButton(context),
    ];
  }

  void _dataSetup() {
    List<WaveTagInputItemBean> tagItems = [];
    List<WaveTagInputItemBean> tagSelectedItems = [];
    if (widget.tagPickerBean != null) {
      for (WaveTagInputItemBean item in widget.tagPickerBean!.tagItemSource) {
        tagItems.add(item);
        //选中的按钮
        if (item.isSelect == true) {
          tagSelectedItems.add(item);
        }
      }
    }

    _sourceTags = tagItems;
    // 重新排序，name 越长，越靠后
    _sourceTags.sort((left, right) {
      return (left.name.length).compareTo(right.name.length);
    });

    // 默认选中tags
    _selectedTags = tagSelectedItems;
  }

  Widget _headerArea(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            widget.title ?? '',
            style: TextStyle(
              color: WaveThemeConfigurator.instance.getConfig().commonConfig.colorTextBase,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          GestureDetector(
              onTap: () {
                if (widget.cancelCallBack != null) {
                  widget.cancelCallBack!(context);
                }
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: WaveUITools.getAssetImage(WaveAsset.iconPickerClose),
              ))
        ],
      ),
    );
  }

  double paintWidthWithTextStyle(String content, TextStyle style) {
    final TextPainter textPainter =
        TextPainter(text: TextSpan(text: content, style: style), maxLines: 1, textDirection: TextDirection.ltr)
          ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size.width;
  }

  double preferredWidthWithText(String content) {
    double originalTextWidth =
        paintWidthWithTextStyle(content, TextStyle(fontSize: widget.tagPickerBean!.tagTitleFontSize));
    double maxTextWidthInHalf =
        (MediaQuery.of(context).size.width - (waveCrossAxisCount - 1) * 12 - 20 * 2) / waveCrossAxisCount - 16;
    return originalTextWidth > maxTextWidthInHalf
        ? (MediaQuery.of(context).size.width - 20 * 2 - 8 * 2)
        : maxTextWidthInHalf;
  }

  Widget _tagsArea(BuildContext context) {
    Color selectedTagTitleColor = widget.tagPickerBean?.selectedTagTitleColor ?? Get.theme.colorScheme.primary;
    Color tagTitleColor = widget.tagPickerBean?.tagTitleColor ??
        WaveThemeConfigurator.instance.getConfig().commonConfig.colorTextImportant;
    Color tagBackgroundColor = widget.tagPickerBean?.tagBackgroundColor ?? const Color(0xffF8F8F8);
    Color selectedTagBackgroundColor =
        widget.tagPickerBean?.selectedTagBackgroundColor ?? Get.theme.colorScheme.primary;

    return Container(
        color: Colors.white,
        padding: const EdgeInsets.only(left: 20, right: 10, bottom: 12),
        child: Wrap(
          spacing: 12.0,
          children: _sourceTags.map((choice) {
            bool selected = choice.isSelect;
            Color titleColor = selected ? selectedTagTitleColor : tagTitleColor;
            String textToDisplay = widget.onTagValueGetter!(choice);
            return ChoiceChip(
              selected: selected,
              backgroundColor: tagBackgroundColor,
              selectedColor: selectedTagBackgroundColor,
              pressElevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
              padding: EdgeInsets.zero,
              labelPadding: const EdgeInsets.only(left: 8, right: 8),
              labelStyle: TextStyle(
                  color: titleColor,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  fontSize: widget.tagPickerBean!.tagTitleFontSize),
              label: SizedBox(
                width: preferredWidthWithText(textToDisplay),
                child: Text(
                  textToDisplay,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              onSelected: (bool value) {
                _clickTag(value, choice);
                setState(() {});
              },
            );
          }).toList(),
        ));
  }

  void _clickTag(bool selected, WaveTagInputItemBean tagName) {
    if (selected) {
      if (!widget.multiSelect) {
        for (var tagItem in _selectedTags) {
          tagItem.isSelect = false;
        }
        _selectedTags.clear();
      }
      tagName.isSelect = true;
      _selectedTags.add(tagName);
    } else {
      tagName.isSelect = false;
      _selectedTags.remove(tagName);
    }
  }

  Widget _inputArea(BuildContext context) {
    return Container(
      height: 100,
      color: Colors.white,
      child: Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xfff8f8f8),
          borderRadius: BorderRadius.circular(4),
        ),
        child: TextField(
            style:
                TextStyle(fontSize: 16, color: WaveThemeConfigurator.instance.getConfig().commonConfig.colorTextBase),
            controller: _textEditingController,
            maxLines: 6,
            maxLength: widget.maxLength,
            cursorColor: widget.cursorColor,
            onChanged: (text) {
              setState(() {});
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              hintStyle:
                  TextStyle(fontSize: 16, color: WaveThemeConfigurator.instance.getConfig().commonConfig.colorTextHint),
              counterStyle:
                  TextStyle(fontSize: 12, color: WaveThemeConfigurator.instance.getConfig().commonConfig.colorTextHint),
              hintText: widget.hintText,
            )),
      ),
    );
  }

  Widget _confirmButton(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 72,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 16),
        child: GestureDetector(
          onTap: () {
            if (!isCommitBtnEnable()) return;
            if (widget.confirm != null) {
              widget.confirm!(context, _selectedTags, _textEditingController!.text);
            }
          },
          child: Container(
            height: 48,
            decoration: BoxDecoration(
                color: isCommitBtnEnable() ? Get.theme.colorScheme.primary : const Color(0xffcccccc),
                borderRadius: const BorderRadius.all(Radius.circular(4))),
            child: Center(
              child: Text(
                WaveIntl.of(context).localizedResource.submit,
                style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool isCommitBtnEnable() {
    bool needExpend = false;
    for (int i = 0; i < _selectedTags.length; i++) {
      WaveTagInputItemBean waveTagInputItemBean = _selectedTags[i];
      if (true == waveTagInputItemBean.needExpend) {
        needExpend = true;
        break;
      }
    }
    return _selectedTags.isNotEmpty && (needExpend ? _textEditingController!.text.isNotEmpty : true);
  }

  bool isShowTextInput() {
    if (widget.forceShowTextInput) {
      return true;
    }
    for (int i = 0; i < _selectedTags.length; i++) {
      WaveTagInputItemBean waveTagInputItemBean = _selectedTags[i];
      if (true == waveTagInputItemBean.needExpend) {
        return true;
      }
    }
    _textEditingController!.clear();
    return false;
  }

  @override
  bool get wantKeepAlive => true;
}

/// 数据源
class WaveTagInputItemBean {
  /// 标签展示的文案
  String name;

  ///选中状态
  bool isSelect;

  ///选中tag的index
  int? index;

  /// 选中后是否展示文本输入框
  bool needExpend;

  /// 附带的更多数据，方便在点击回调中取用。
  Map? ext;

  WaveTagInputItemBean({
    this.name = '',
    this.isSelect = false,
    this.index,
    this.needExpend = false,
    this.ext,
  });
}

class WaveTagsInputPickerConfig {
  WaveTagsInputPickerConfig(
      {this.tagTitleFontSize = 16.0,
      this.tagTitleColor,
      this.selectedTagTitleColor,
      this.tagBackgroundColor,
      this.selectedTagBackgroundColor,
      this.tagItemSource = const []}) {
    tagTitleColor = WaveThemeConfigurator.instance.getConfig().commonConfig.colorTextBase;
  }

  double tagTitleFontSize;
  Color? tagTitleColor;
  Color? selectedTagTitleColor;
  Color? tagBackgroundColor;
  Color? selectedTagBackgroundColor;

  List<WaveTagInputItemBean> tagItemSource;
}
