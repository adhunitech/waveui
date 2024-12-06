import 'package:get/get.dart';
import 'package:waveui/src/theme/wave_theme_configurator.dart';
import 'package:waveui/src/utils/css/wave_util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:xml/xml_events.dart' as xml;

/// 超链接的点击回调
typedef WaveHyperLinkCallback = void Function(String text, String? url);

/// 用于将标签转为 style
class WaveConvert {
  WaveConvert(
    String cssContent, {
    WaveHyperLinkCallback? linkCallBack,
    TextStyle? defaultStyle,
  }) {
    _eventList = xml.parseEvents(cssContent);
    _linkCallBack = linkCallBack;
    _defaultStyle = defaultStyle;
  }

  /// 超链接的点击回调
  WaveHyperLinkCallback? _linkCallBack;

  /// 外部传入的默认文本样式
  TextStyle? _defaultStyle;

  /// 标签的集合
  Iterable<xml.XmlEvent> _eventList = [];

  /// 标签对应的style
  List<_Tag> stack = [];

  /// 转换的思路：将 开始标签 的属性转为 合适的style, 并将其存入集合中
  ///             a开始标签支持的属性：href
  ///           文本标签 去获取style集合的最后一个元素 并应用style样式
  ///           结束标签 则将集合的最后一个元素删除
  List<TextSpan> convert() {
    // 优先使用外部提供的样式
    final TextStyle style = _defaultStyle ??
        TextStyle(
          fontSize: 14,
          decoration: TextDecoration.none,
          fontWeight: FontWeight.normal,
          color: WaveThemeConfigurator.instance
              .getConfig()
              .commonConfig
              .colorTextImportant,
        );

    final List<TextSpan> spans = [];
    for (var xmlEvent in _eventList) {
      if (xmlEvent is xml.XmlStartElementEvent) {
        if (!xmlEvent.isSelfClosing) {
          final _Tag tag = _Tag();
          TextStyle textStyle = style.copyWith();
          if (xmlEvent.name == 'font') {
            for (var attr in xmlEvent.attributes) {
              switch (attr.name) {
                case 'color':
                  textStyle = textStyle.apply(
                    color: WaveConvertUtil.generateColorByString(attr.value),
                  );
                  break;
                case 'weight':
                  FontWeight fontWeight =
                      WaveConvertUtil.generateFontWidgetByString(attr.value);
                  textStyle = textStyle.apply(
                    fontWeightDelta: fontWeight.index - FontWeight.normal.index,
                  );
                  break;
                case 'size':
                  textStyle = textStyle.apply(
                    fontSizeDelta:
                        WaveConvertUtil.generateFontSize(attr.value) - 13,
                  );
                  break;
              }
            }
            tag.isLink = false;
          }

          if (xmlEvent.name == 'strong') {
            tag.isLink = false;
            textStyle = textStyle.apply(fontWeightDelta: 2);
          }

          if (xmlEvent.name == 'a') {
            tag.isLink = true;
            for (var attr in xmlEvent.attributes) {
              switch (attr.name) {
                case 'href':
                  textStyle = textStyle.apply(
                    color: Get.theme.colorScheme.primary,
                  );
                  tag.linkUrl = attr.value;
                  break;
              }
            }
          }
          tag.name = xmlEvent.name;
          tag.style = textStyle;
          stack.add(tag);
        } else {
          if (xmlEvent.name == 'br') {
            spans.add(const TextSpan(text: '\n'));
          }
        }
      }

      if (xmlEvent is xml.XmlTextEvent) {
        _Tag tag = _Tag();
        tag.style = style.copyWith();
        if (stack.isNotEmpty) {
          tag = stack.last;
        }
        TextSpan textSpan = _createTextSpan(xmlEvent.text, tag);
        spans.add(textSpan);
      }

      if (xmlEvent is xml.XmlEndElementEvent) {
        _Tag top = stack.removeLast();
        if (top.name != xmlEvent.name) {
          debugPrint('Error format HTML');
          continue;
        }
      }
    }

    return spans;
  }

  TextSpan _createTextSpan(String text, _Tag tag) {
    if (text.isEmpty) return const TextSpan(text: '');
    final TapGestureRecognizer recognizer = TapGestureRecognizer()
      ..onTap = () {
        _linkCallBack?.call(text, tag.linkUrl);
      };
    return TextSpan(
      style: tag.style,
      text: text,
      recognizer: tag.isLink ? recognizer : null,
    );
  }
}

class _Tag {
  String? name;
  TextStyle? style;
  String? linkUrl;
  bool isLink = false;
}
