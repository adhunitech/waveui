import 'package:waveui/waveui.dart';

///多选按钮
class WaveCheckbox extends StatefulWidget {
  /// 标识当前Radio的Index
  final int radioIndex;

  /// value 选项发生变化产生的回调
  /// int 选项的index
  /// bool 选项的选中状态，true表示选中，false未选中
  final void Function(int, bool) onValueChangedAtIndex;

  /// 初始值，是否被选择
  /// 默认false
  final bool isSelected;

  /// 是否禁用当前选项
  /// 默认false
  final bool disable;

  /// 选择按钮的padding
  /// 默认EdgeInsets.all(5)
  final EdgeInsets? iconPadding;

  /// 配合使用的控件，比如卡片或者text
  final Widget? child;

  /// 控件是否在选择按钮的右边，
  /// true时 控件在选择按钮右边
  /// false时 控件在选择按钮的左边
  /// 默认true
  final bool childOnRight;

  /// 控件和选择按钮在row布局里面的alignment
  /// 默认值MainAxisAlignment.start
  final MainAxisAlignment mainAxisAlignment;

  /// 控件和选择按钮在row布局里面的crossAxisAlignment
  /// 默认值CrossAxisAlignment.center
  final CrossAxisAlignment crossAxisAlignment;

  /// 控件和选择按钮在row布局里面的mainAxisSize
  /// 默认值MainAxisSize.min
  final MainAxisSize mainAxisSize;

  /// 默认值HitTestBehavior.translucent。控制widget.onRadioItemClick触发的点击范围
  final HitTestBehavior behavior;

  const WaveCheckbox(
      {super.key,
      required this.radioIndex,
      required this.onValueChangedAtIndex,
      this.disable = false,
      this.isSelected = false,
      this.iconPadding,
      this.child,
      this.childOnRight = true,
      this.mainAxisAlignment = MainAxisAlignment.start,
      this.crossAxisAlignment = CrossAxisAlignment.center,
      this.mainAxisSize = MainAxisSize.min,
      this.behavior = HitTestBehavior.translucent});

  @override
  State<StatefulWidget> createState() {
    return WaveCheckboxState();
  }
}

class WaveCheckboxState extends State<WaveCheckbox> {
  late bool _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected;
  }

  @override
  void didUpdateWidget(covariant WaveCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isSelected != widget.isSelected) {
      _isSelected = widget.isSelected;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WaveRadioCore(
      radioIndex: widget.radioIndex,
      disable: widget.disable,
      isSelected: _isSelected,
      iconPadding: widget.iconPadding,
      childOnRight: widget.childOnRight,
      mainAxisAlignment: widget.mainAxisAlignment,
      crossAxisAlignment: widget.crossAxisAlignment,
      mainAxisSize: widget.mainAxisSize,
      selectedIcon: FluentIcons.radio_button_24_filled,
      unselectedIcon: FluentIcons.radio_button_24_regular,
      onRadioItemClick: () {
        setState(() {
          _isSelected = !_isSelected;
        });
        widget.onValueChangedAtIndex(widget.radioIndex, _isSelected);
      },
      behavior: widget.behavior,
      child: widget.child,
    );
  }
}
