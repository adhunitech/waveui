import 'package:waveui/waveui.dart';

///Bubble background text panel with the function of expanding and collapsing
///Bubble: Gray Container with background color of Color(0xFFF8F8F8)
///The upper right corner is an irregular small triangle
///
///Layout rules:
///The background of the component is the bubble background
///Wraps the [WaveExpandableText] component, which has the ability to expand and collapse
///
///```dart
///WaveBubbleText(
///text: 'There are more or collapse buttons in the lower right corner of the text',
///)
///
///WaveBubbleText(
///text: 'A text panel with the function of expanding and collapsing, and there are more or collapsing buttons in the lower right corner of the text',
///maxLines: 2,
///)
///
///```
///
///Related text components are as follows:
///*[WaveExpandableText], the expanded and collapsed text component of the bubble background
///*[WaveInsertInfo], the text component of the bubble background
///
class WaveBubbleText extends StatelessWidget {
  ///Text to display
  final String text;

  ///Maximum number of rows to display
  final int? maxLines;

  ///Expand and collapse callback
  final TextExpandedCallback? onExpanded;

  ///The rounded corner of the bubble is 4 by default
  final double radius;

  final Color? bgColor;

  ///content text style
  final TextStyle? textStyle;

  const WaveBubbleText(
      {Key? key,
      this.text = '',
      this.maxLines,
      this.onExpanded,
      this.radius = 6,
      this.bgColor,
      this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Image image = WaveUITools.getAssetImageWithColor(
        'icons/icon_right_top_pointer.png', bgColor);
    Widget bubbleText = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        image,
        _buildExpandedWidget(),
      ],
    );
    return bubbleText;
  }

  Widget _buildExpandedWidget() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                color: bgColor ?? Get.theme.cardColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(0),
                    topRight: Radius.circular(radius),
                    bottomLeft: Radius.circular(radius),
                    bottomRight: Radius.circular(radius))),
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 12),
            child: WaveExpandableText(
              text: text,
              maxLines: maxLines,
              color: bgColor ?? Get.theme.cardColor,
              onExpanded: onExpanded,
              textStyle: textStyle ??
                  TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: WaveThemeConfigurator.instance
                        .getConfig()
                        .commonConfig
                        .colorTextBase,
                  ),
            ),
          ),
        )
      ],
    );
  }
}
