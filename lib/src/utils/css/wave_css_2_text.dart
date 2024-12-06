import 'package:waveui/src/utils/css/wave_core_funtion.dart';
import 'package:flutter/material.dart';

/// 将CSS格式的标签转为文本
class WaveCSS2Text {
  const WaveCSS2Text._();

  static TextSpan toTextSpan(
    String htmlContent, {
    WaveHyperLinkCallback? linksCallback,
    TextStyle? defaultStyle,
  }) {
    return TextSpan(
      children: WaveConvert(
        htmlContent,
        linkCallBack: linksCallback,
        defaultStyle: defaultStyle,
      ).convert(),
    );
  }

  static Text toTextView(
    String htmlContent, {
    WaveHyperLinkCallback? linksCallback,
    TextStyle? defaultStyle,
    int? maxLines,
    TextAlign? textAlign,
    TextOverflow? textOverflow,
  }) {
    return Text.rich(
      toTextSpan(
        htmlContent,
        linksCallback: linksCallback,
        defaultStyle: defaultStyle,
      ),
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: textOverflow ?? TextOverflow.clip,
    );
  }
}
