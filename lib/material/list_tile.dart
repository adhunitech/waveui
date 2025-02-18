// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:waveui/material/theme.dart' show ThemeData;
import 'package:waveui/material/theme_data.dart' show ThemeData;

import 'package:waveui/material/color_scheme.dart';
import 'package:waveui/material/colors.dart';
import 'package:waveui/material/constants.dart';
import 'package:waveui/material/debug.dart';
import 'package:waveui/material/divider.dart';
import 'package:waveui/material/icon_button.dart';
import 'package:waveui/material/icon_button_theme.dart';
import 'package:waveui/material/ink_decoration.dart';
import 'package:waveui/material/ink_well.dart';
import 'package:waveui/material/list_tile_theme.dart';
import 'package:waveui/material/material_state.dart';
import 'package:waveui/material/text_theme.dart';
import 'package:waveui/material/theme.dart';
import 'package:waveui/material/theme_data.dart';
import 'package:waveui/waveui.dart' show ThemeData;

// Examples can assume:
// int _act = 1;

typedef _Sizes = ({double titleY, BoxConstraints textConstraints, Size tileSize});

enum ListTileStyle { list, drawer }

enum ListTileControlAffinity { leading, trailing, platform }

enum ListTileTitleAlignment {
  threeLine,

  titleHeight,

  top,

  center,

  bottom;

  // If isLeading is true the y offset is for the leading widget, otherwise it's
  // for the trailing child.
  double _yOffsetFor(double childHeight, double tileHeight, _RenderListTile listTile, bool isLeading) => switch (this) {
    ListTileTitleAlignment.threeLine =>
      listTile.isThreeLine
          ? ListTileTitleAlignment.top._yOffsetFor(childHeight, tileHeight, listTile, isLeading)
          : ListTileTitleAlignment.center._yOffsetFor(childHeight, tileHeight, listTile, isLeading),
    // This attempts to implement the redlines for the vertical position of the
    // leading and trailing icons on the spec page:
    //   https://m2.material.io/components/lists#specs
    //
    // For large tiles (> 72dp), both leading and trailing controls should be
    // a fixed distance from top. As per guidelines this is set to 16dp.
    ListTileTitleAlignment.titleHeight when tileHeight > 72.0 => 16.0,
    // For smaller tiles, trailing should always be centered. Leading can be
    // centered or closer to the top. It should never be further than 16dp
    // to the top.
    ListTileTitleAlignment.titleHeight =>
      isLeading ? math.min((tileHeight - childHeight) / 2.0, 16.0) : (tileHeight - childHeight) / 2.0,
    ListTileTitleAlignment.top => listTile.minVerticalPadding,
    ListTileTitleAlignment.center => (tileHeight - childHeight) / 2.0,
    ListTileTitleAlignment.bottom => tileHeight - childHeight - listTile.minVerticalPadding,
  };
}

class ListTile extends StatelessWidget {
  const ListTile({
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
    this.splashColor,
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
  }) : assert(!isThreeLine || subtitle != null);

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

  final Color? splashColor;

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

  // TODO(hangyujin): Remove this flag after fixing related g3 tests and flipping
  // the default value to true.
  final bool internalAddSemanticForOnTap;

  static Iterable<Widget> divideTiles({required Iterable<Widget> tiles, BuildContext? context, Color? color}) {
    assert(color != null || context != null);
    tiles = tiles.toList();

    if (tiles.isEmpty || tiles.length == 1) {
      return tiles;
    }

    Widget wrapTile(Widget tile) => DecoratedBox(
      position: DecorationPosition.foreground,
      decoration: BoxDecoration(border: Border(bottom: Divider.createBorderSide(context, color: color))),
      child: tile,
    );

    return <Widget>[...tiles.take(tiles.length - 1).map(wrapTile), tiles.last];
  }

  bool _isDenseLayout(ThemeData theme, ListTileThemeData tileTheme) =>
      dense ?? tileTheme.dense ?? theme.listTileTheme.dense ?? false;

  Color _tileBackgroundColor(ThemeData theme, ListTileThemeData tileTheme, ListTileThemeData defaults) {
    final Color? color =
        selected
            ? selectedTileColor ?? tileTheme.selectedTileColor ?? theme.listTileTheme.selectedTileColor
            : tileColor ?? tileTheme.tileColor ?? theme.listTileTheme.tileColor;
    return color ?? defaults.tileColor!;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    final ThemeData theme = Theme.of(context);
    final ListTileThemeData tileTheme = ListTileTheme.of(context);
    final ListTileThemeData defaults = _LisTileDefaultsM3(context);
    final Set<WidgetState> states = <WidgetState>{
      if (!enabled) WidgetState.disabled,
      if (selected) WidgetState.selected,
    };

    Color? resolveColor(Color? explicitColor, Color? selectedColor, Color? enabledColor, [Color? disabledColor]) =>
        _IndividualOverrides(
          explicitColor: explicitColor,
          selectedColor: selectedColor,
          enabledColor: enabledColor,
          disabledColor: disabledColor,
        ).resolve(states);

    final Color? effectiveIconColor =
        resolveColor(iconColor, selectedColor, iconColor) ??
        resolveColor(tileTheme.iconColor, tileTheme.selectedColor, tileTheme.iconColor) ??
        resolveColor(theme.listTileTheme.iconColor, theme.listTileTheme.selectedColor, theme.listTileTheme.iconColor) ??
        resolveColor(defaults.iconColor, defaults.selectedColor, defaults.iconColor, theme.disabledColor);
    final Color? effectiveColor =
        resolveColor(textColor, selectedColor, textColor) ??
        resolveColor(tileTheme.textColor, tileTheme.selectedColor, tileTheme.textColor) ??
        resolveColor(theme.listTileTheme.textColor, theme.listTileTheme.selectedColor, theme.listTileTheme.textColor) ??
        resolveColor(defaults.textColor, defaults.selectedColor, defaults.textColor, theme.disabledColor);
    final IconThemeData iconThemeData = IconThemeData(color: effectiveIconColor);
    final IconButtonThemeData iconButtonThemeData = IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: effectiveIconColor),
    );

    TextStyle? leadingAndTrailingStyle;
    if (leading != null || trailing != null) {
      leadingAndTrailingStyle =
          leadingAndTrailingTextStyle ?? tileTheme.leadingAndTrailingTextStyle ?? defaults.leadingAndTrailingTextStyle!;
      final Color? leadingAndTrailingTextColor = effectiveColor;
      leadingAndTrailingStyle = leadingAndTrailingStyle.copyWith(color: leadingAndTrailingTextColor);
    }

    Widget? leadingIcon;
    if (leading != null) {
      leadingIcon = AnimatedDefaultTextStyle(
        style: leadingAndTrailingStyle!,
        duration: kThemeChangeDuration,
        child: leading!,
      );
    }

    TextStyle titleStyle = titleTextStyle ?? tileTheme.titleTextStyle ?? defaults.titleTextStyle!;
    final Color? titleColor = effectiveColor;
    titleStyle = titleStyle.copyWith(color: titleColor, fontSize: _isDenseLayout(theme, tileTheme) ? 13.0 : null);
    final Widget titleText = AnimatedDefaultTextStyle(
      style: titleStyle,
      duration: kThemeChangeDuration,
      child: title ?? const SizedBox(),
    );

    Widget? subtitleText;
    TextStyle? subtitleStyle;
    if (subtitle != null) {
      subtitleStyle = subtitleTextStyle ?? tileTheme.subtitleTextStyle ?? defaults.subtitleTextStyle!;
      final Color? subtitleColor = effectiveColor;
      subtitleStyle = subtitleStyle.copyWith(
        color: subtitleColor,
        fontSize: _isDenseLayout(theme, tileTheme) ? 12.0 : null,
      );
      subtitleText = AnimatedDefaultTextStyle(style: subtitleStyle, duration: kThemeChangeDuration, child: subtitle!);
    }

    Widget? trailingIcon;
    if (trailing != null) {
      trailingIcon = AnimatedDefaultTextStyle(
        style: leadingAndTrailingStyle!,
        duration: kThemeChangeDuration,
        child: trailing!,
      );
    }

    final TextDirection textDirection = Directionality.of(context);
    final EdgeInsets resolvedContentPadding =
        contentPadding?.resolve(textDirection) ??
        tileTheme.contentPadding?.resolve(textDirection) ??
        defaults.contentPadding!.resolve(textDirection);

    // Show basic cursor when ListTile isn't enabled or gesture callbacks are null.
    final Set<WidgetState> mouseStates = <WidgetState>{
      if (!enabled || (onTap == null && onLongPress == null)) WidgetState.disabled,
    };
    final MouseCursor effectiveMouseCursor =
        WidgetStateProperty.resolveAs<MouseCursor?>(mouseCursor, mouseStates) ??
        tileTheme.mouseCursor?.resolve(mouseStates) ??
        WidgetStateMouseCursor.clickable.resolve(mouseStates);

    final ListTileTitleAlignment effectiveTitleAlignment =
        titleAlignment ?? tileTheme.titleAlignment ?? ListTileTitleAlignment.threeLine;

    return InkWell(
      customBorder: shape ?? tileTheme.shape,
      onTap: enabled ? onTap : null,
      onLongPress: enabled ? onLongPress : null,
      onFocusChange: onFocusChange,
      mouseCursor: effectiveMouseCursor,
      canRequestFocus: enabled,
      focusNode: focusNode,
      focusColor: focusColor,
      hoverColor: hoverColor,
      splashColor: splashColor,
      autofocus: autofocus,
      enableFeedback: enableFeedback ?? tileTheme.enableFeedback ?? true,
      child: Semantics(
        button: internalAddSemanticForOnTap && (onTap != null || onLongPress != null),
        selected: selected,
        enabled: enabled,
        child: Ink(
          decoration: ShapeDecoration(
            shape: shape ?? tileTheme.shape ?? const Border(),
            color: _tileBackgroundColor(theme, tileTheme, defaults),
          ),
          child: SafeArea(
            top: false,
            bottom: false,
            minimum: resolvedContentPadding,
            child: IconTheme.merge(
              data: iconThemeData,
              child: IconButtonTheme(
                data: iconButtonThemeData,
                child: _ListTile(
                  leading: leadingIcon,
                  title: titleText,
                  subtitle: subtitleText,
                  trailing: trailingIcon,
                  isDense: _isDenseLayout(theme, tileTheme),
                  visualDensity: visualDensity ?? tileTheme.visualDensity ?? theme.visualDensity,
                  isThreeLine: isThreeLine,
                  textDirection: textDirection,
                  titleBaselineType: titleStyle.textBaseline ?? defaults.titleTextStyle!.textBaseline!,
                  subtitleBaselineType: subtitleStyle?.textBaseline ?? defaults.subtitleTextStyle!.textBaseline!,
                  horizontalTitleGap: horizontalTitleGap ?? tileTheme.horizontalTitleGap ?? 16,
                  minVerticalPadding:
                      minVerticalPadding ?? tileTheme.minVerticalPadding ?? defaults.minVerticalPadding!,
                  minLeadingWidth: minLeadingWidth ?? tileTheme.minLeadingWidth ?? defaults.minLeadingWidth!,
                  minTileHeight: minTileHeight ?? tileTheme.minTileHeight,
                  titleAlignment: effectiveTitleAlignment,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      FlagProperty(
        'isThreeLine',
        value: isThreeLine,
        ifTrue: 'THREE_LINE',
        ifFalse: 'TWO_LINE',
        showName: true,
        defaultValue: false,
      ),
    );
    properties.add(FlagProperty('dense', value: dense, ifTrue: 'true', ifFalse: 'false', showName: true));
    properties.add(DiagnosticsProperty<VisualDensity>('visualDensity', visualDensity, defaultValue: null));
    properties.add(DiagnosticsProperty<ShapeBorder>('shape', shape, defaultValue: null));
    properties.add(DiagnosticsProperty<ListTileStyle>('style', style, defaultValue: null));
    properties.add(ColorProperty('selectedColor', selectedColor, defaultValue: null));
    properties.add(ColorProperty('iconColor', iconColor, defaultValue: null));
    properties.add(ColorProperty('textColor', textColor, defaultValue: null));
    properties.add(DiagnosticsProperty<TextStyle>('titleTextStyle', titleTextStyle, defaultValue: null));
    properties.add(DiagnosticsProperty<TextStyle>('subtitleTextStyle', subtitleTextStyle, defaultValue: null));
    properties.add(
      DiagnosticsProperty<TextStyle>('leadingAndTrailingTextStyle', leadingAndTrailingTextStyle, defaultValue: null),
    );
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('contentPadding', contentPadding, defaultValue: null));
    properties.add(
      FlagProperty('enabled', value: enabled, ifTrue: 'true', ifFalse: 'false', showName: true, defaultValue: true),
    );
    properties.add(DiagnosticsProperty<Function>('onTap', onTap, defaultValue: null));
    properties.add(DiagnosticsProperty<Function>('onLongPress', onLongPress, defaultValue: null));
    properties.add(DiagnosticsProperty<MouseCursor>('mouseCursor', mouseCursor, defaultValue: null));
    properties.add(
      FlagProperty('selected', value: selected, ifTrue: 'true', ifFalse: 'false', showName: true, defaultValue: false),
    );
    properties.add(ColorProperty('focusColor', focusColor, defaultValue: null));
    properties.add(ColorProperty('hoverColor', hoverColor, defaultValue: null));
    properties.add(DiagnosticsProperty<FocusNode>('focusNode', focusNode, defaultValue: null));
    properties.add(
      FlagProperty(
        'autofocus',
        value: autofocus,
        ifTrue: 'true',
        ifFalse: 'false',
        showName: true,
        defaultValue: false,
      ),
    );
    properties.add(ColorProperty('tileColor', tileColor, defaultValue: null));
    properties.add(ColorProperty('selectedTileColor', selectedTileColor, defaultValue: null));
    properties.add(
      FlagProperty('enableFeedback', value: enableFeedback, ifTrue: 'true', ifFalse: 'false', showName: true),
    );
    properties.add(DoubleProperty('horizontalTitleGap', horizontalTitleGap, defaultValue: null));
    properties.add(DoubleProperty('minVerticalPadding', minVerticalPadding, defaultValue: null));
    properties.add(DoubleProperty('minLeadingWidth', minLeadingWidth, defaultValue: null));
    properties.add(DiagnosticsProperty<ListTileTitleAlignment>('titleAlignment', titleAlignment, defaultValue: null));
    properties.add(ObjectFlagProperty<ValueChanged<bool>?>.has('onFocusChange', onFocusChange));
    properties.add(ColorProperty('splashColor', splashColor));
    properties.add(DoubleProperty('minTileHeight', minTileHeight));
    properties.add(DiagnosticsProperty<bool>('internalAddSemanticForOnTap', internalAddSemanticForOnTap));
  }
}

class _IndividualOverrides extends WidgetStateProperty<Color?> {
  _IndividualOverrides({this.explicitColor, this.enabledColor, this.selectedColor, this.disabledColor});

  final Color? explicitColor;
  final Color? enabledColor;
  final Color? selectedColor;
  final Color? disabledColor;

  @override
  Color? resolve(Set<WidgetState> states) {
    if (explicitColor is WidgetStateColor) {
      return WidgetStateProperty.resolveAs<Color?>(explicitColor, states);
    }
    if (states.contains(WidgetState.disabled)) {
      return disabledColor;
    }
    if (states.contains(WidgetState.selected)) {
      return selectedColor;
    }
    return enabledColor;
  }
}

// Identifies the children of a _ListTileElement.
enum _ListTileSlot { leading, title, subtitle, trailing }

class _ListTile extends SlottedMultiChildRenderObjectWidget<_ListTileSlot, RenderBox> {
  const _ListTile({
    required this.title,
    required this.isThreeLine,
    required this.isDense,
    required this.visualDensity,
    required this.textDirection,
    required this.titleBaselineType,
    required this.horizontalTitleGap,
    required this.minVerticalPadding,
    required this.minLeadingWidth,
    required this.titleAlignment,
    this.leading,
    this.subtitle,
    this.trailing,
    this.minTileHeight,
    this.subtitleBaselineType,
  });

  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final bool isThreeLine;
  final bool isDense;
  final VisualDensity visualDensity;
  final TextDirection textDirection;
  final TextBaseline titleBaselineType;
  final TextBaseline? subtitleBaselineType;
  final double horizontalTitleGap;
  final double minVerticalPadding;
  final double minLeadingWidth;
  final double? minTileHeight;
  final ListTileTitleAlignment titleAlignment;

  @override
  Iterable<_ListTileSlot> get slots => _ListTileSlot.values;

  @override
  Widget? childForSlot(_ListTileSlot slot) => switch (slot) {
    _ListTileSlot.leading => leading,
    _ListTileSlot.title => title,
    _ListTileSlot.subtitle => subtitle,
    _ListTileSlot.trailing => trailing,
  };

  @override
  _RenderListTile createRenderObject(BuildContext context) => _RenderListTile(
    isThreeLine: isThreeLine,
    isDense: isDense,
    visualDensity: visualDensity,
    textDirection: textDirection,
    titleBaselineType: titleBaselineType,
    subtitleBaselineType: subtitleBaselineType,
    horizontalTitleGap: horizontalTitleGap,
    minVerticalPadding: minVerticalPadding,
    minLeadingWidth: minLeadingWidth,
    minTileHeight: minTileHeight,
    titleAlignment: titleAlignment,
  );

  @override
  void updateRenderObject(BuildContext context, _RenderListTile renderObject) {
    renderObject
      ..isThreeLine = isThreeLine
      ..isDense = isDense
      ..visualDensity = visualDensity
      ..textDirection = textDirection
      ..titleBaselineType = titleBaselineType
      ..subtitleBaselineType = subtitleBaselineType
      ..horizontalTitleGap = horizontalTitleGap
      ..minLeadingWidth = minLeadingWidth
      ..minTileHeight = minTileHeight
      ..minVerticalPadding = minVerticalPadding
      ..titleAlignment = titleAlignment;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('isThreeLine', isThreeLine));
    properties.add(DiagnosticsProperty<bool>('isDense', isDense));
    properties.add(DiagnosticsProperty<VisualDensity>('visualDensity', visualDensity));
    properties.add(EnumProperty<TextDirection>('textDirection', textDirection));
    properties.add(EnumProperty<TextBaseline>('titleBaselineType', titleBaselineType));
    properties.add(EnumProperty<TextBaseline?>('subtitleBaselineType', subtitleBaselineType));
    properties.add(DoubleProperty('horizontalTitleGap', horizontalTitleGap));
    properties.add(DoubleProperty('minVerticalPadding', minVerticalPadding));
    properties.add(DoubleProperty('minLeadingWidth', minLeadingWidth));
    properties.add(DoubleProperty('minTileHeight', minTileHeight));
    properties.add(EnumProperty<ListTileTitleAlignment>('titleAlignment', titleAlignment));
  }
}

class _RenderListTile extends RenderBox with SlottedContainerRenderObjectMixin<_ListTileSlot, RenderBox> {
  _RenderListTile({
    required bool isDense,
    required VisualDensity visualDensity,
    required bool isThreeLine,
    required TextDirection textDirection,
    required TextBaseline titleBaselineType,
    required double horizontalTitleGap,
    required double minVerticalPadding,
    required double minLeadingWidth,
    required ListTileTitleAlignment titleAlignment,
    TextBaseline? subtitleBaselineType,
    double? minTileHeight,
  }) : _isDense = isDense,
       _visualDensity = visualDensity,
       _isThreeLine = isThreeLine,
       _textDirection = textDirection,
       _titleBaselineType = titleBaselineType,
       _subtitleBaselineType = subtitleBaselineType,
       _horizontalTitleGap = horizontalTitleGap,
       _minVerticalPadding = minVerticalPadding,
       _minLeadingWidth = minLeadingWidth,
       _minTileHeight = minTileHeight,
       _titleAlignment = titleAlignment;

  RenderBox? get leading => childForSlot(_ListTileSlot.leading);
  RenderBox get title => childForSlot(_ListTileSlot.title)!;
  RenderBox? get subtitle => childForSlot(_ListTileSlot.subtitle);
  RenderBox? get trailing => childForSlot(_ListTileSlot.trailing);

  // The returned list is ordered for hit testing.
  @override
  Iterable<RenderBox> get children {
    final RenderBox? title = childForSlot(_ListTileSlot.title);
    return <RenderBox>[
      if (leading != null) leading!,
      if (title != null) title,
      if (subtitle != null) subtitle!,
      if (trailing != null) trailing!,
    ];
  }

  bool get isDense => _isDense;
  bool _isDense;
  set isDense(bool value) {
    if (_isDense == value) {
      return;
    }
    _isDense = value;
    markNeedsLayout();
  }

  VisualDensity get visualDensity => _visualDensity;
  VisualDensity _visualDensity;
  set visualDensity(VisualDensity value) {
    if (_visualDensity == value) {
      return;
    }
    _visualDensity = value;
    markNeedsLayout();
  }

  bool get isThreeLine => _isThreeLine;
  bool _isThreeLine;
  set isThreeLine(bool value) {
    if (_isThreeLine == value) {
      return;
    }
    _isThreeLine = value;
    markNeedsLayout();
  }

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;
  set textDirection(TextDirection value) {
    if (_textDirection == value) {
      return;
    }
    _textDirection = value;
    markNeedsLayout();
  }

  TextBaseline get titleBaselineType => _titleBaselineType;
  TextBaseline _titleBaselineType;
  set titleBaselineType(TextBaseline value) {
    if (_titleBaselineType == value) {
      return;
    }
    _titleBaselineType = value;
    markNeedsLayout();
  }

  TextBaseline? get subtitleBaselineType => _subtitleBaselineType;
  TextBaseline? _subtitleBaselineType;
  set subtitleBaselineType(TextBaseline? value) {
    if (_subtitleBaselineType == value) {
      return;
    }
    _subtitleBaselineType = value;
    markNeedsLayout();
  }

  double get horizontalTitleGap => _horizontalTitleGap;
  double _horizontalTitleGap;
  double get _effectiveHorizontalTitleGap => _horizontalTitleGap + visualDensity.horizontal * 2.0;

  set horizontalTitleGap(double value) {
    if (_horizontalTitleGap == value) {
      return;
    }
    _horizontalTitleGap = value;
    markNeedsLayout();
  }

  double get minVerticalPadding => _minVerticalPadding;
  double _minVerticalPadding;

  set minVerticalPadding(double value) {
    if (_minVerticalPadding == value) {
      return;
    }
    _minVerticalPadding = value;
    markNeedsLayout();
  }

  double get minLeadingWidth => _minLeadingWidth;
  double _minLeadingWidth;

  set minLeadingWidth(double value) {
    if (_minLeadingWidth == value) {
      return;
    }
    _minLeadingWidth = value;
    markNeedsLayout();
  }

  double? _minTileHeight;
  double? get minTileHeight => _minTileHeight;
  set minTileHeight(double? value) {
    if (_minTileHeight == value) {
      return;
    }
    _minTileHeight = value;
    markNeedsLayout();
  }

  ListTileTitleAlignment get titleAlignment => _titleAlignment;
  ListTileTitleAlignment _titleAlignment;
  set titleAlignment(ListTileTitleAlignment value) {
    if (_titleAlignment == value) {
      return;
    }
    _titleAlignment = value;
    markNeedsLayout();
  }

  @override
  bool get sizedByParent => false;

  static double _minWidth(RenderBox? box, double height) => box == null ? 0.0 : box.getMinIntrinsicWidth(height);

  static double _maxWidth(RenderBox? box, double height) => box == null ? 0.0 : box.getMaxIntrinsicWidth(height);

  @override
  double computeMinIntrinsicWidth(double height) {
    final double leadingWidth =
        leading != null
            ? math.max(leading!.getMinIntrinsicWidth(height), _minLeadingWidth) + _effectiveHorizontalTitleGap
            : 0.0;
    return leadingWidth + math.max(_minWidth(title, height), _minWidth(subtitle, height)) + _maxWidth(trailing, height);
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    final double leadingWidth =
        leading != null
            ? math.max(leading!.getMaxIntrinsicWidth(height), _minLeadingWidth) + _effectiveHorizontalTitleGap
            : 0.0;
    return leadingWidth + math.max(_maxWidth(title, height), _maxWidth(subtitle, height)) + _maxWidth(trailing, height);
  }

  // The target tile height to use if _minTileHeight is not specified.
  double get _defaultTileHeight {
    final Offset baseDensity = visualDensity.baseSizeAdjustment;
    return baseDensity.dy +
        switch ((isThreeLine, subtitle != null)) {
          (true, _) => isDense ? 76.0 : 88.0, // 3 lines,
          (false, true) => isDense ? 64.0 : 72.0, // 2 lines
          (false, false) => isDense ? 48.0 : 56.0, // 1 line,
        };
  }

  double get _targetTileHeight => _minTileHeight ?? _defaultTileHeight;

  @override
  double computeMinIntrinsicHeight(double width) =>
      math.max(_targetTileHeight, title.getMinIntrinsicHeight(width) + (subtitle?.getMinIntrinsicHeight(width) ?? 0.0));

  @override
  double computeMaxIntrinsicHeight(double width) => getMinIntrinsicHeight(width);

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) {
    final BoxParentData parentData = title.parentData! as BoxParentData;
    final BaselineOffset offset = BaselineOffset(title.getDistanceToActualBaseline(baseline)) + parentData.offset.dy;
    return offset.offset;
  }

  BoxConstraints get maxIconHeightConstraint => BoxConstraints(
    // One-line trailing and leading widget heights do not follow
    // Material specifications, but this sizing is required to adhere
    // to accessibility requirements for smallest tappable widget.
    // Two- and three-line trailing widget heights are constrained
    // properly according to the Material spec.
    maxHeight: (isDense ? 48.0 : 56.0) + visualDensity.baseSizeAdjustment.dy,
  );

  static void _positionBox(RenderBox box, Offset offset) {
    final BoxParentData parentData = box.parentData! as BoxParentData;
    parentData.offset = offset;
  }

  // Implements _RenderListTile's layout algorithm. If `positionChild` is not null,
  // it will be called on each child with that child's layout offset.
  //
  // All of the dimensions below were taken from the Material Design spec:
  // https://material.io/design/components/lists.html#specs
  _Sizes _computeSizes(
    ChildBaselineGetter getBaseline,
    ChildLayouter getSize,
    BoxConstraints constraints, {
    void Function(RenderBox, Offset)? positionChild,
  }) {
    final BoxConstraints looseConstraints = constraints.loosen();
    final double tileWidth = looseConstraints.maxWidth;
    final BoxConstraints iconConstraints = looseConstraints.enforce(maxIconHeightConstraint);
    final RenderBox? leading = this.leading;
    final RenderBox? trailing = this.trailing;

    final Size? leadingSize = leading == null ? null : getSize(leading, iconConstraints);
    final Size? trailingSize = trailing == null ? null : getSize(trailing, iconConstraints);

    assert(() {
      if (tileWidth == 0.0) {
        return true;
      }

      String? overflowedWidget;
      if (tileWidth == leadingSize?.width) {
        overflowedWidget = 'Leading';
      } else if (tileWidth == trailingSize?.width) {
        overflowedWidget = 'Trailing';
      }

      if (overflowedWidget == null) {
        return true;
      }

      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary('$overflowedWidget widget consumes the entire tile width (including ListTile.contentPadding).'),
        ErrorDescription(
          'Either resize the tile width so that the ${overflowedWidget.toLowerCase()} widget plus any content padding '
          'do not exceed the tile width, or use a sized widget, or consider replacing '
          'ListTile with a custom widget.',
        ),
        ErrorHint('See also: https://api.flutter.dev/flutter/material/ListTile-class.html#material.ListTile.4'),
      ]);
    }());

    final double titleStart =
        leadingSize == null ? 0.0 : math.max(_minLeadingWidth, leadingSize.width) + _effectiveHorizontalTitleGap;

    final double adjustedTrailingWidth =
        trailingSize == null ? 0.0 : math.max(trailingSize.width + _effectiveHorizontalTitleGap, 32.0);

    final BoxConstraints textConstraints = looseConstraints.tighten(
      width: tileWidth - titleStart - adjustedTrailingWidth,
    );

    final RenderBox? subtitle = this.subtitle;
    final double titleHeight = getSize(title, textConstraints).height;

    final bool isLTR = switch (textDirection) {
      TextDirection.ltr => true,
      TextDirection.rtl => false,
    };

    final double titleY;
    final double tileHeight;
    if (subtitle == null) {
      tileHeight = math.max(_targetTileHeight, titleHeight + 2.0 * _minVerticalPadding);
      titleY = (tileHeight - titleHeight) / 2.0;
    } else {
      final double subtitleHeight = getSize(subtitle, textConstraints).height;
      final double titleBaseline = getBaseline(title, textConstraints, titleBaselineType) ?? titleHeight;
      final double subtitleBaseline = getBaseline(subtitle, textConstraints, subtitleBaselineType!) ?? subtitleHeight;

      final double targetTitleY = (isThreeLine ? (isDense ? 22.0 : 28.0) : (isDense ? 28.0 : 32.0)) - titleBaseline;
      final double targetSubtitleY =
          (isThreeLine ? (isDense ? 42.0 : 48.0) : (isDense ? 48.0 : 52.0)) +
          visualDensity.vertical * 2.0 -
          subtitleBaseline;
      // Prevent the title and the subtitle from overlapping by moving them away from
      // each other by the same distance.
      final double halfOverlap = math.max(targetTitleY + titleHeight - targetSubtitleY, 0) / 2;
      final double idealTitleY = targetTitleY - halfOverlap;
      final double idealSubtitleY = targetSubtitleY + halfOverlap;
      // However if either component can't maintain the minimal padding from the top/bottom edges, the ListTile enters "compat mode".
      final bool compact =
          idealTitleY < minVerticalPadding || idealSubtitleY + subtitleHeight + minVerticalPadding > _targetTileHeight;

      // Position subtitle.
      positionChild!.call(
        subtitle,
        Offset(isLTR ? titleStart : adjustedTrailingWidth, compact ? minVerticalPadding + titleHeight : idealSubtitleY),
      );
      tileHeight = compact ? 2 * _minVerticalPadding + titleHeight + subtitleHeight : _targetTileHeight;
      titleY = compact ? minVerticalPadding : idealTitleY;
    }

    positionChild!(title, Offset(isLTR ? titleStart : adjustedTrailingWidth, titleY));

    if (leading != null && leadingSize != null) {
      positionChild(
        leading,
        Offset(
          isLTR ? 0.0 : tileWidth - leadingSize.width,
          titleAlignment._yOffsetFor(leadingSize.height, tileHeight, this, true),
        ),
      );
    }

    if (trailing != null && trailingSize != null) {
      positionChild(
        trailing,
        Offset(
          isLTR ? tileWidth - trailingSize.width : 0.0,
          titleAlignment._yOffsetFor(trailingSize.height, tileHeight, this, false),
        ),
      );
    }

    return (titleY: titleY, textConstraints: textConstraints, tileSize: Size(tileWidth, tileHeight));
  }

  @override
  double? computeDryBaseline(covariant BoxConstraints constraints, TextBaseline baseline) {
    final _Sizes sizes = _computeSizes(ChildLayoutHelper.getDryBaseline, ChildLayoutHelper.dryLayoutChild, constraints);
    final BaselineOffset titleBaseline =
        BaselineOffset(title.getDryBaseline(sizes.textConstraints, baseline)) + sizes.titleY;
    return titleBaseline.offset;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) => constraints.constrain(
    _computeSizes(ChildLayoutHelper.getDryBaseline, ChildLayoutHelper.dryLayoutChild, constraints).tileSize,
  );

  @override
  void performLayout() {
    final Size tileSize =
        _computeSizes(
          ChildLayoutHelper.getBaseline,
          ChildLayoutHelper.layoutChild,
          constraints,
          positionChild: _positionBox,
        ).tileSize;

    size = constraints.constrain(tileSize);
    assert(size.width == constraints.constrainWidth(tileSize.width));
    assert(size.height == constraints.constrainHeight(tileSize.height));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    void doPaint(RenderBox? child) {
      if (child != null) {
        final BoxParentData parentData = child.parentData! as BoxParentData;
        context.paintChild(child, parentData.offset + offset);
      }
    }

    doPaint(leading);
    doPaint(title);
    doPaint(subtitle);
    doPaint(trailing);
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    for (final RenderBox child in children) {
      final BoxParentData parentData = child.parentData! as BoxParentData;
      final bool isHit = result.addWithPaintOffset(
        offset: parentData.offset,
        position: position,
        hitTest: (result, transformed) {
          assert(transformed == position - parentData.offset);
          return child.hitTest(result, position: transformed);
        },
      );
      if (isHit) {
        return true;
      }
    }
    return false;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<RenderBox?>('leading', leading));
    properties.add(DiagnosticsProperty<RenderBox>('title', title));
    properties.add(DiagnosticsProperty<RenderBox?>('subtitle', subtitle));
    properties.add(DiagnosticsProperty<RenderBox?>('trailing', trailing));
    properties.add(DiagnosticsProperty<bool>('isDense', isDense));
    properties.add(DiagnosticsProperty<VisualDensity>('visualDensity', visualDensity));
    properties.add(DiagnosticsProperty<bool>('isThreeLine', isThreeLine));
    properties.add(EnumProperty<TextDirection>('textDirection', textDirection));
    properties.add(EnumProperty<TextBaseline>('titleBaselineType', titleBaselineType));
    properties.add(EnumProperty<TextBaseline?>('subtitleBaselineType', subtitleBaselineType));
    properties.add(DoubleProperty('horizontalTitleGap', horizontalTitleGap));
    properties.add(DoubleProperty('minVerticalPadding', minVerticalPadding));
    properties.add(DoubleProperty('minLeadingWidth', minLeadingWidth));
    properties.add(DoubleProperty('minTileHeight', minTileHeight));
    properties.add(EnumProperty<ListTileTitleAlignment>('titleAlignment', titleAlignment));
    properties.add(DiagnosticsProperty<BoxConstraints>('maxIconHeightConstraint', maxIconHeightConstraint));
  }
}

// BEGIN GENERATED TOKEN PROPERTIES - LisTile

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// dart format off
class _LisTileDefaultsM3 extends ListTileThemeData {
  _LisTileDefaultsM3(this.context)
    : super(
        contentPadding: const EdgeInsetsDirectional.only(start: 16.0, end: 24.0),
        minLeadingWidth: 24,
        minVerticalPadding: 8,
        shape: const RoundedRectangleBorder(),
      );

  final BuildContext context;
  late final ThemeData _theme = Theme.of(context);
  late final ColorScheme _colors = _theme.colorScheme;
  late final TextTheme _textTheme = _theme.textTheme;

  @override
  Color? get tileColor =>  Colors.transparent;

  @override
  TextStyle? get titleTextStyle => _textTheme.bodyLarge!.copyWith(color: _colors.onSurface);

  @override
  TextStyle? get subtitleTextStyle => _textTheme.bodyMedium!.copyWith(color: _colors.onSurfaceVariant);

  @override
  TextStyle? get leadingAndTrailingTextStyle => _textTheme.labelSmall!.copyWith(color: _colors.onSurfaceVariant);

  @override
  Color? get selectedColor => _colors.primary;

  @override
  Color? get iconColor => _colors.onSurfaceVariant;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BuildContext>('context', context));
  }
}
// dart format on

// END GENERATED TOKEN PROPERTIES - LisTile
