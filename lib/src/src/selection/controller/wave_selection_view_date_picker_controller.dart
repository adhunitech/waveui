import 'package:flutter/material.dart';

class WaveSelectionDatePickerController extends ChangeNotifier {
  bool isShow; //是否显示下拉筛选列表
  OverlayEntry? entry;

  WaveSelectionDatePickerController({
    this.isShow = false,
    this.entry,
  });

  void show() {
    isShow = true;
  }

  void hide() {
    isShow = false;
    entry?.remove();
    entry = null;
  }
}
