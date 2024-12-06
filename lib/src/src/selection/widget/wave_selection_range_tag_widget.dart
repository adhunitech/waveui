import 'package:waveui/src/src/selection/wave_selection_util.dart';
import 'package:waveui/waveui.dart';

/// /// /// /// /// /// /// /// /// /
/// 描述: 多选 tag 组件
/// /// /// /// /// /// /// /// /// /
class WaveSelectionRangeTagWidget extends StatefulWidget {
  //tag 显示的文本
  @required
  final List<WaveSelectionEntity> tagFilterList;

  //初始选中的 Index 列表
  final List<bool>? initSelectStatus;

  //选择tag的回调
  final void Function(int, bool)? onSelect;
  final double spacing;
  final double verticalSpacing;
  final int tagWidth;
  final double tagHeight;
  final int initFocusedIndex;

  final WaveSelectionConfig themeData;

  const WaveSelectionRangeTagWidget(
      {Key? key,
      required this.tagFilterList,
      this.initSelectStatus,
      this.onSelect,
      this.spacing = 12,
      this.verticalSpacing = 10,
      this.tagWidth = 75,
      this.tagHeight = 34,
      required this.themeData,
      this.initFocusedIndex = -1})
      : super(key: key);

  @override
  _WaveSelectionRangeTagWidgetState createState() => _WaveSelectionRangeTagWidgetState();
}

class _WaveSelectionRangeTagWidgetState extends State<WaveSelectionRangeTagWidget> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: widget.verticalSpacing,
      spacing: widget.spacing,
      children: _tagWidgetList(context),
    );
  }

  List<Widget> _tagWidgetList(context) {
    List<Widget> list = [];
    for (int nameIndex = 0; nameIndex < widget.tagFilterList.length; nameIndex++) {
      Widget tagWidget = _tagWidgetAtIndex(nameIndex);
      GestureDetector gdt = GestureDetector(
          child: tagWidget,
          onTap: () {
            var selectedEntity = widget.tagFilterList[nameIndex];
            if (WaveSelectionFilterType.checkbox == selectedEntity.filterType && !selectedEntity.isSelected) {
              if (!WaveSelectionUtil.checkMaxSelectionCount(selectedEntity)) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(WaveIntl.of(context).localizedResource.filterConditionCountLimited)));
                return;
              }
            }
            WaveSelectionUtil.processBrotherItemSelectStatus(selectedEntity);
            if (null != widget.onSelect) {
              widget.onSelect!(nameIndex, selectedEntity.isSelected);
            }
            setState(() {});
          });
      list.add(gdt);
    }
    return list;
  }

  Widget _tagWidgetAtIndex(int nameIndex) {
    bool selected = widget.tagFilterList[nameIndex].isSelected || nameIndex == widget.initFocusedIndex;
    String text = widget.tagFilterList[nameIndex].title;
    if (widget.tagFilterList[nameIndex].filterType == WaveSelectionFilterType.date &&
        !WaveUITools.isEmpty(widget.tagFilterList[nameIndex].value)) {
      if (int.tryParse(widget.tagFilterList[nameIndex].value ?? '') != null) {
        DateTime? dateTime = DateTimeFormatter.convertIntValueToDateTime(widget.tagFilterList[nameIndex].value);
        text = DateTimeFormatter.formatDate(dateTime!, WaveIntl.of(context).localizedResource.dateFormate_yyyy_MM_dd);
      } else {
        text = widget.tagFilterList[nameIndex].value ?? '';
      }
    }

    Text tx = Text(text, style: selected ? _selectedTextStyle() : _tagTextStyle());
    Container tagItem = Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: selected ? widget.themeData.tagSelectedBackgroundColor : widget.themeData.tagNormalBackgroundColor,
          borderRadius: BorderRadius.circular(widget.themeData.tagRadius)),
      width: widget.tagWidth.toDouble(),
      height: widget.tagHeight,
      child: tx,
    );
    return tagItem;
  }

  TextStyle _tagTextStyle() {
    return widget.themeData.tagNormalTextStyle.generateTextStyle();
  }

  TextStyle _selectedTextStyle() {
    return widget.themeData.tagSelectedTextStyle.generateTextStyle();
  }
}
