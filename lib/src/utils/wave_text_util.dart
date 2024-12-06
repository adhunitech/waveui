import 'package:waveui/src/utils/wave_tools.dart';
import 'package:flutter/widgets.dart';

class WaveTextUtil {
  const WaveTextUtil._();

  /// 根据 TextStyle 计算 text 宽度。
  static Size textSize(String text, TextStyle style) {
    if (WaveUITools.isEmpty(text)) return const Size(0, 0);
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }
}
