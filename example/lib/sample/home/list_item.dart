import 'package:flutter/material.dart';

///list item
class ListItem extends StatelessWidget {
  ///click event
  final VoidCallback? onPressed;

  ///Title
  final String title;
  final double? titleFontSize;
  final Color? titleColor;

  ///describe
  final String describe;
  final Color? describeColor;

  ///Right side control
  final Widget? rightWidget;
  final bool isShowLine;

  ///Constructor
  const ListItem({
    super.key,
    this.onPressed,
    this.title = "",
    this.titleFontSize,
    this.titleColor,
    this.describe = "",
    this.describeColor,
    this.rightWidget,
    this.isShowLine = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isShowLine ? const Divider() : const SizedBox.shrink(),
        ListTile(
          onTap: onPressed,
          title: Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontSize: titleFontSize,
            ),
          ),
          subtitle: Text(describe),
          trailing: rightWidget,
        ),
      ],
    );
  }
}
