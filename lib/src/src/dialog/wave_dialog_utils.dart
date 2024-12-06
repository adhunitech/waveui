import 'package:waveui/src/theme/configs/wave_dialog_config.dart';
import 'package:flutter/material.dart';

class WaveDialogUtils {
  /// dialog标题配置
  static TextStyle getDialogTitleStyle(WaveDialogConfig themeData) {
    return themeData.titleTextStyle.generateTextStyle();
  }

  /// dialog圆角配置
  static double getDialogRadius(WaveDialogConfig themeData) {
    return themeData.radius;
  }
}
