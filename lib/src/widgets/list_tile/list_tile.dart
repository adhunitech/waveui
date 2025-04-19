import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:waveui/waveui.dart';

class WaveListTile extends StatefulWidget {
  final Widget? leading;

  final Widget? title;

  final Widget? subtitle;

  final Widget? trailing;

  final bool isThreeLine;

  final bool? dense;

  final VisualDensity? visualDensity;

  final ShapeBorder? shape;

  final Color? selectedColor;

  final Color? iconColor;

  final Color? textColor;

  final TextStyle? titleTextStyle;

  final TextStyle? subtitleTextStyle;

  final TextStyle? leadingAndTrailingTextStyle;

  final ListTileStyle? style;

  final EdgeInsetsGeometry? contentPadding;

  final bool enabled;

  final GestureTapCallback? onTap;

  final GestureLongPressCallback? onLongPress;

  final ValueChanged<bool>? onFocusChange;

  final MouseCursor? mouseCursor;

  final bool selected;

  final Color? focusColor;

  final Color? hoverColor;

  final FocusNode? focusNode;

  final bool autofocus;

  final Color? tileColor;

  final Color? selectedTileColor;

  final bool? enableFeedback;

  final double? horizontalTitleGap;

  final double? minVerticalPadding;

  final double? minLeadingWidth;

  final double? minTileHeight;

  final ListTileTitleAlignment? titleAlignment;

  final bool internalAddSemanticForOnTap;
  const WaveListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.isThreeLine = false,
    this.dense,
    this.visualDensity,
    this.shape,
    this.style,
    this.selectedColor,
    this.iconColor,
    this.textColor,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.leadingAndTrailingTextStyle,
    this.contentPadding,
    this.enabled = true,
    this.onTap,
    this.onLongPress,
    this.onFocusChange,
    this.mouseCursor,
    this.selected = false,
    this.focusColor,
    this.hoverColor,
    this.focusNode,
    this.autofocus = false,
    this.tileColor,
    this.selectedTileColor,
    this.enableFeedback,
    this.horizontalTitleGap,
    this.minVerticalPadding,
    this.minLeadingWidth,
    this.minTileHeight,
    this.titleAlignment,
    this.internalAddSemanticForOnTap = true,
  });

  @override
  State<WaveListTile> createState() => _WaveListTileState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('isThreeLine', isThreeLine))
      ..add(DiagnosticsProperty<bool?>('dense', dense))
      ..add(DiagnosticsProperty<VisualDensity?>('visualDensity', visualDensity))
      ..add(DiagnosticsProperty<ShapeBorder?>('shape', shape))
      ..add(ColorProperty('selectedColor', selectedColor))
      ..add(ColorProperty('iconColor', iconColor))
      ..add(ColorProperty('textColor', textColor))
      ..add(DiagnosticsProperty<TextStyle?>('titleTextStyle', titleTextStyle))
      ..add(DiagnosticsProperty<TextStyle?>('subtitleTextStyle', subtitleTextStyle))
      ..add(DiagnosticsProperty<TextStyle?>('leadingAndTrailingTextStyle', leadingAndTrailingTextStyle))
      ..add(EnumProperty<ListTileStyle?>('style', style))
      ..add(DiagnosticsProperty<EdgeInsetsGeometry?>('contentPadding', contentPadding))
      ..add(DiagnosticsProperty<bool>('enabled', enabled))
      ..add(ObjectFlagProperty<GestureTapCallback?>.has('onTap', onTap))
      ..add(ObjectFlagProperty<GestureLongPressCallback?>.has('onLongPress', onLongPress))
      ..add(ObjectFlagProperty<ValueChanged<bool>?>.has('onFocusChange', onFocusChange))
      ..add(DiagnosticsProperty<MouseCursor?>('mouseCursor', mouseCursor))
      ..add(DiagnosticsProperty<bool>('selected', selected))
      ..add(ColorProperty('focusColor', focusColor))
      ..add(ColorProperty('hoverColor', hoverColor))
      ..add(DiagnosticsProperty<FocusNode?>('focusNode', focusNode))
      ..add(DiagnosticsProperty<bool>('autofocus', autofocus))
      ..add(ColorProperty('tileColor', tileColor))
      ..add(ColorProperty('selectedTileColor', selectedTileColor))
      ..add(DiagnosticsProperty<bool?>('enableFeedback', enableFeedback))
      ..add(DoubleProperty('horizontalTitleGap', horizontalTitleGap))
      ..add(DoubleProperty('minVerticalPadding', minVerticalPadding))
      ..add(DoubleProperty('minLeadingWidth', minLeadingWidth))
      ..add(DoubleProperty('minTileHeight', minTileHeight))
      ..add(EnumProperty<ListTileTitleAlignment?>('titleAlignment', titleAlignment))
      ..add(DiagnosticsProperty<bool>('internalAddSemanticForOnTap', internalAddSemanticForOnTap));
  }
}

class _WaveListTileState extends State<WaveListTile> {
  bool _isTouched = false;

  void _handleTapDown() {
    if (widget.onTap != null) {
      _setTouched(true);
    }
  }

  void _handleTapUp() {
    if (widget.onTap != null) {
      _setTouched(false);
      widget.onTap?.call();
    }
  }

  void _setTouched(bool touched) {
    setState(() => _isTouched = touched);
  }

  @override
  Widget build(BuildContext context) {
    final theme = WaveApp.themeOf(context);
    final tileColor = widget.tileColor ?? theme.colorScheme.contentPrimary;
    //TODO: Fix the hover color. This is just an workaround. It does not work
    // as expected when the tile is dark or other color than white.
    final hoverColor = theme.colorScheme.hover(widget.hoverColor ?? Colors.grey.shade100, tileColor);
    return GestureDetector(
      onTapDown: (_) => _handleTapDown(),
      onTapUp: (_) => _handleTapUp(),
      onTapCancel: () => _setTouched(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        color: _isTouched ? hoverColor : tileColor,
        curve: Curves.easeOut,
        child: ListTile(
          key: widget.key,
          leading: widget.leading,
          title: widget.title,
          subtitle:
              widget.subtitle == null ? null : Padding(padding: const EdgeInsets.only(top: 2), child: widget.subtitle),
          trailing: widget.trailing,
          isThreeLine: widget.isThreeLine,
          dense: widget.dense,
          visualDensity: widget.visualDensity,
          shape: widget.shape,
          selectedColor: widget.selectedColor,
          focusColor: widget.focusColor,
          autofocus: widget.autofocus,
          contentPadding: widget.contentPadding,
          enableFeedback: widget.enableFeedback,
          mouseCursor: widget.mouseCursor,
          selected: widget.selected,
          hoverColor: widget.hoverColor,
          splashColor: Colors.transparent,
          enabled: widget.enabled,
          onLongPress: widget.onLongPress,
          onFocusChange: widget.onFocusChange,
          textColor: widget.textColor,
          iconColor: widget.iconColor,
          titleTextStyle: widget.titleTextStyle ?? theme.textTheme.body,
          subtitleTextStyle:
              widget.subtitleTextStyle ?? theme.textTheme.small.copyWith(color: theme.colorScheme.labelSecondary),
          leadingAndTrailingTextStyle: widget.leadingAndTrailingTextStyle,
          style: widget.style,
          horizontalTitleGap: widget.horizontalTitleGap,
          minVerticalPadding: widget.minVerticalPadding,
          minLeadingWidth: widget.minLeadingWidth,
          minTileHeight: widget.minTileHeight,
          titleAlignment: widget.titleAlignment,
          internalAddSemanticForOnTap: widget.internalAddSemanticForOnTap,
          focusNode: widget.focusNode,
          selectedTileColor: widget.selectedTileColor,
        ),
      ),
    );
  }
}
