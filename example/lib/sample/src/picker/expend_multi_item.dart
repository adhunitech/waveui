import 'package:waveui/waveui.dart';

class ExpendMultiSelectBottomPickerItem
    extends WaveMultiSelectBottomPickerItem {
  final String? attribute1;
  final String? attribute2;
  final String? attribute3;
  @override
  String code; //选项编号
  @override
  String content; //选项内容
  @override
  bool isChecked; //是否选中

  ExpendMultiSelectBottomPickerItem(
    this.code,
    this.content, {
    this.attribute1,
    this.attribute2,
    this.attribute3,
    this.isChecked = false,
  }) : super(code, content, isChecked: isChecked);
}
