import 'package:waveui/src/src/noticebar/wave_marquee_text.dart';
import 'package:flutter/material.dart';

///Description: Left label, right button notification
///1. Support ten default styles
///2. Support setting or hiding left and right icons
///3. Support marquee

class WaveNoticeBarWithButton extends StatelessWidget {
  ///The content of the notification
  final String content;

  ///The background color of the notification
  final Color? backgroundColor;

  ///Notification text color
  final Color? contentTextColor;

  ///The text of the left label
  final String? leftTagText;

  ///The text color of the left label
  final Color? leftTagTextColor;

  ///The background color of the left label
  final Color? leftTagBackgroundColor;

  ///Customize the control on the left
  final Widget? leftWidget;

  ///The text of the right button
  final String? rightButtonText;

  ///The text color of the right button
  final Color? rightButtonTextColor;

  ///The border color of the right button
  final Color? rightButtonBorderColor;

  ///Customize the control on the right
  final Widget? rightWidget;

  ///Marquee
  ///The default value is false
  final bool marquee;

  ///Right button click callback
  final VoidCallback? onRightButtonTap;

  ///Minimum height. When both leftWidget and rightWidget are empty, the minimum height of the restriction.
  ///The height of the component can be controlled through this property, and the content will be automatically centered vertically. The default value is 54.
  final double minHeight;

  ///The padding of the content
  final EdgeInsets? padding;

  const WaveNoticeBarWithButton(
      {Key? key,
      required this.content,
      this.backgroundColor,
      this.contentTextColor,
      this.leftTagText,
      this.leftTagBackgroundColor,
      this.leftTagTextColor,
      this.rightButtonBorderColor,
      this.rightButtonText,
      this.rightButtonTextColor,
      this.onRightButtonTap,
      this.marquee = false,
      this.leftWidget,
      this.rightWidget,
      this.padding,
      this.minHeight = 54})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //If there is no custom view, set the minimum height
    return Container(
      constraints: BoxConstraints(minHeight: minHeight),
      color: backgroundColor ?? const Color(0x14FA5741),
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildLeftTag(),
          Expanded(
            child: _buildContent(),
          ),
          _buildRightBtn(),
        ],
      ),
    );
  }

  /// left label
  Widget _buildLeftTag() {
    if (leftWidget != null) {
      return leftWidget!;
    }

    if (leftTagText?.isEmpty ?? true) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(right: 8, top: 2),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: leftTagBackgroundColor ?? const Color(0xFFFA5741),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Center(
          child: Text(
            leftTagText!,
            style: TextStyle(
              color: leftTagTextColor ?? Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (content.isEmpty) {
      return Container();
    }

    if (marquee) {
      return WaveMarqueeText(
        height: 20,
        text: content,
        textStyle: TextStyle(
          color: contentTextColor ?? const Color(0xFF333333),
          fontSize: 14,
        ),
      );
    } else {
      return Text(
        content,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: contentTextColor ?? const Color(0xFF333333),
          fontSize: 14,
        ),
      );
    }
  }

  ///Right button
  Widget _buildRightBtn() {
    if (rightWidget != null) {
      return rightWidget!;
    }

    if (rightButtonText?.isEmpty ?? true) {
      return Container();
    }
    return GestureDetector(
      onTap: () {
        if (onRightButtonTap != null) {
          onRightButtonTap!();
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Container(
          height: 30,
          alignment: Alignment.center,
          constraints: const BoxConstraints(
            minWidth: 56,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: rightButtonBorderColor ?? const Color(0xFFFA5741),
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Center(
            child: Text(
              rightButtonText!,
              style: TextStyle(
                color: rightButtonTextColor ?? const Color(0xFFFA5741),
                fontSize: 12,
                height: 1,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
