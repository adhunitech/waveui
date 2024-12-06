import 'package:waveui/src/theme/wave_theme_configurator.dart';
import 'package:waveui/src/utils/wave_tools.dart';
import 'package:flutter/material.dart';

/// 气泡背景的文本
/// 气泡：背景色为Color(0xFFF8F8F8)的灰色Container
///      右上角为不规则小三角
///
/// ```dart
///   WaveInsertInfo(
///      infoText: '在文本的右下角有更多或者收起按钮',
///   )
///
///   WaveInsertInfo(
///      infoText: '具备展开收起功能的文字面板，在文本的右下角有更多或者收起按钮',
///      maxLines: 2,
///   )
///
/// ```
///
/// 相关文本组件如下:
///  * [WaveExpandableText], 气泡背景的展开收起文本组件
///  * [WaveBubbleText], 气泡背景的文本组件
///
class WaveInsertInfo extends StatelessWidget {
  final String infoText;
  final int maxLines;

  const WaveInsertInfo({Key? key, required this.infoText, this.maxLines = 2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Text tx = Text(
      infoText,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: WaveThemeConfigurator.instance
            .getConfig()
            .commonConfig
            .colorTextBase,
      ),
    );

    Color color = const Color(0xFFF8F8F8);
    Image image = WaveUITools.getAssetImage('icons/icon_right_top_pointer.png');

    Widget bubbleText = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                color: color,
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(4),
                    bottomLeft: Radius.circular(4),
                    bottomRight: Radius.circular(4))),
            padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 12),
            child: tx,
          ),
        )
      ],
    );
    return Container(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          image,
          bubbleText,
        ],
      ),
    );
  }
}
