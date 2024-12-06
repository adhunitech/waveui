import 'package:get/get.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

typedef TextExpandedCallback = Function(bool);

///A text panel with the function of expanding and collapsing
///
///Layout rules:
///There are more or collapse buttons in the lower right corner of the text
///When the text exceeds the specified [maxLines], the remaining text is hidden
///Click more to display all text
///
///```dart
///WaveExpandableText(
///text: 'There are more or collapse buttons in the lower right corner of the text',
///)
///
///WaveExpandableText(
///text: 'A text panel with the function of expanding and collapsing, and there are more or collapsing buttons in the lower right corner of the text',
///maxLines: 2,
///onExpanded: (value) {
///},
///)
///
///
///```
///
///Related text components are as follows:
///*[WaveBubbleText], expand and collapse the text component of the bubble background
///*[WaveInsertInfo], the text component of the bubble background
///
class WaveExpandableText extends StatefulWidget {
  ///Text to display
  final String text;

  ///Maximum number of rows to display
  final int? maxLines;

  ///Text style
  final TextStyle? textStyle;

  ///Callback when unfolding or collapsing
  final TextExpandedCallback? onExpanded;

  ///The initial color of the gradient color of the more button Default white
  final Color? color;

  const WaveExpandableText(
      {Key? key,
      required this.text,
      this.maxLines = 3,
      this.textStyle,
      this.onExpanded,
      this.color})
      : super(key: key);

  @override
  _WaveExpandableTextState createState() => _WaveExpandableTextState();
}

class _WaveExpandableTextState extends State<WaveExpandableText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, size) {
        final span = TextSpan(text: widget.text, style: _defaultTextStyle());
        final tp = TextPainter(
            text: span,
            maxLines: widget.maxLines,
            textDirection: TextDirection.ltr,
            ellipsis: 'EllipseText');
        tp.layout(maxWidth: size.maxWidth);
        if (tp.didExceedMaxLines) {
          if (_expanded) {
            return _expandedText(widget.text);
          } else {
            return _foldedText(context, widget.text);
          }
        } else {
          return _regularText(widget.text, _defaultTextStyle());
        }
      },
    );
  }

  Widget _foldedText(context, String text) {
    return Stack(
      children: <Widget>[
        Text(
          widget.text,
          style: _defaultTextStyle(),
          maxLines: widget.maxLines,
          overflow: TextOverflow.clip,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: _clickExpandTextWidget(context),
        )
      ],
    );
  }

  Widget _clickExpandTextWidget(context) {
    Color btnColor = widget.color ?? Get.theme.cardColor;

    Text tx = Text(
      "Read more",
      style: TextStyle(color: Get.theme.colorScheme.primary, fontSize: 14),
    );
    Container cnt = Container(
      padding: const EdgeInsets.only(left: 22),
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [btnColor.withAlpha(100), btnColor, btnColor],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      )),
      child: tx,
    );
    return GestureDetector(
      child: cnt,
      onTap: () {
        setState(() {
          _expanded = true;
          if (null != widget.onExpanded) {
            widget.onExpanded!(_expanded);
          }
        });
      },
    );
  }

  Widget _expandedText(String text) {
    return RichText(
        text: TextSpan(text: text, style: _defaultTextStyle(), children: [
      _foldButtonSpan(),
    ]));
  }

  TextStyle? _defaultTextStyle() {
    TextStyle? style = widget.textStyle ?? Get.theme.textTheme.bodyMedium;
    return style;
  }

  InlineSpan _foldButtonSpan() {
    return TextSpan(
        text: ' ' "Collapse",
        style: TextStyle(
          color: Get.theme.colorScheme.primary,
          fontSize: 14,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            setState(() {
              _expanded = false;
              if (null != widget.onExpanded) {
                widget.onExpanded!(_expanded);
              }
            });
          });
  }

  Widget _regularText(text, style) {
    return Text(text, style: style);
  }
}
