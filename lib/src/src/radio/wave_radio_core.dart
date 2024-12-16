import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum WaveRadioType { multi, single }

class WaveRadioCore extends StatefulWidget {
  final int radioIndex;

  final bool isSelected;

  final bool disable;

  final EdgeInsets? iconPadding;

  final Widget? child;

  final bool childOnRight;

  final MainAxisAlignment mainAxisAlignment;

  final CrossAxisAlignment crossAxisAlignment;

  final MainAxisSize mainAxisSize;

  final IconData? selectedIcon;

  final IconData? unselectedIcon;

  final VoidCallback? onRadioItemClick;

  final HitTestBehavior behavior;

  const WaveRadioCore(
      {Key? key,
      required this.radioIndex,
      this.disable = false,
      this.isSelected = false,
      this.iconPadding,
      this.child,
      this.childOnRight = true,
      this.mainAxisAlignment = MainAxisAlignment.start,
      this.crossAxisAlignment = CrossAxisAlignment.center,
      this.mainAxisSize = MainAxisSize.min,
      this.selectedIcon,
      this.unselectedIcon,
      this.onRadioItemClick,
      this.behavior = HitTestBehavior.translucent})
      : super(key: key);

  @override
  _WaveRadioCoreState createState() => _WaveRadioCoreState();
}

class _WaveRadioCoreState extends State<WaveRadioCore> {
  late bool _isSelected;
  late bool _disable;

  @override
  void initState() {
    _isSelected = widget.isSelected;
    _disable = widget.disable;
    super.initState();
  }

  @override
  void didUpdateWidget(WaveRadioCore oldWidget) {
    super.didUpdateWidget(oldWidget);
    _isSelected = widget.isSelected;
    _disable = widget.disable;
  }

  @override
  Widget build(BuildContext context) {
    Widget icon = Container(
      padding: widget.iconPadding ?? const EdgeInsets.all(5),
      child: Icon(
        _isSelected ? widget.selectedIcon : widget.unselectedIcon,
        color: _isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).dividerColor,
        size: 24,
      ),
    );

    Widget radioWidget;
    if (widget.child == null) {
      radioWidget = icon;
    } else {
      List<Widget> list = [];
      if (widget.childOnRight) {
        list.add(icon);
        list.add(widget.child!);
      } else {
        list.add(widget.child!);
        list.add(icon);
      }
      radioWidget = Row(
        mainAxisSize: widget.mainAxisSize,
        mainAxisAlignment: widget.mainAxisAlignment,
        crossAxisAlignment: widget.crossAxisAlignment,
        children: list,
      );
    }

    return GestureDetector(
      behavior: widget.behavior,
      onTap: () {
        if (widget.disable == true) return;
        if (widget.onRadioItemClick != null) {
          widget.onRadioItemClick!();
        }
      },
      child: radioWidget,
    );
  }
}
