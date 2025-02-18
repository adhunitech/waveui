// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/list_tile.dart';
import 'package:waveui/material/list_tile_theme.dart';
import 'package:waveui/material/switch.dart';
import 'package:waveui/material/switch_theme.dart';
import 'package:waveui/material/theme.dart';
import 'package:waveui/material/theme_data.dart';

// Examples can assume:
// void setState(VoidCallback fn) { }
// bool _isSelected = true;

enum _SwitchListTileType { material, adaptive }

class SwitchListTile extends StatelessWidget {
  const SwitchListTile({
    required this.value,
    required this.onChanged,
    super.key,
    this.activeColor,
    this.activeTrackColor,
    this.inactiveThumbColor,
    this.inactiveTrackColor,
    this.activeThumbImage,
    this.onActiveThumbImageError,
    this.inactiveThumbImage,
    this.onInactiveThumbImageError,
    this.thumbColor,
    this.trackColor,
    this.trackOutlineColor,
    this.thumbIcon,
    this.materialTapTargetSize,
    this.dragStartBehavior = DragStartBehavior.start,
    this.mouseCursor,
    this.overlayColor,
    this.splashRadius,
    this.focusNode,
    this.onFocusChange,
    this.autofocus = false,
    this.tileColor,
    this.title,
    this.subtitle,
    this.isThreeLine = false,
    this.dense,
    this.contentPadding,
    this.secondary,
    this.selected = false,
    this.controlAffinity,
    this.shape,
    this.selectedTileColor,
    this.visualDensity,
    this.enableFeedback,
    this.hoverColor,
    this.internalAddSemanticForOnTap = false,
  }) : _switchListTileType = _SwitchListTileType.material,
       applyCupertinoTheme = false,
       assert(activeThumbImage != null || onActiveThumbImageError == null),
       assert(inactiveThumbImage != null || onInactiveThumbImageError == null),
       assert(!isThreeLine || subtitle != null);

  const SwitchListTile.adaptive({
    required this.value,
    required this.onChanged,
    super.key,
    this.activeColor,
    this.activeTrackColor,
    this.inactiveThumbColor,
    this.inactiveTrackColor,
    this.activeThumbImage,
    this.onActiveThumbImageError,
    this.inactiveThumbImage,
    this.onInactiveThumbImageError,
    this.thumbColor,
    this.trackColor,
    this.trackOutlineColor,
    this.thumbIcon,
    this.materialTapTargetSize,
    this.dragStartBehavior = DragStartBehavior.start,
    this.mouseCursor,
    this.overlayColor,
    this.splashRadius,
    this.focusNode,
    this.onFocusChange,
    this.autofocus = false,
    this.applyCupertinoTheme,
    this.tileColor,
    this.title,
    this.subtitle,
    this.isThreeLine = false,
    this.dense,
    this.contentPadding,
    this.secondary,
    this.selected = false,
    this.controlAffinity,
    this.shape,
    this.selectedTileColor,
    this.visualDensity,
    this.enableFeedback,
    this.hoverColor,
    this.internalAddSemanticForOnTap = false,
  }) : _switchListTileType = _SwitchListTileType.adaptive,
       assert(!isThreeLine || subtitle != null),
       assert(activeThumbImage != null || onActiveThumbImageError == null),
       assert(inactiveThumbImage != null || onInactiveThumbImageError == null);

  final bool value;

  final ValueChanged<bool>? onChanged;

  final Color? activeColor;

  final Color? activeTrackColor;

  final Color? inactiveThumbColor;

  final Color? inactiveTrackColor;

  final ImageProvider? activeThumbImage;

  final ImageErrorListener? onActiveThumbImageError;

  final ImageProvider? inactiveThumbImage;

  final ImageErrorListener? onInactiveThumbImageError;

  final WidgetStateProperty<Color?>? thumbColor;

  final WidgetStateProperty<Color?>? trackColor;

  final WidgetStateProperty<Color?>? trackOutlineColor;

  final WidgetStateProperty<Icon?>? thumbIcon;

  final MaterialTapTargetSize? materialTapTargetSize;

  final DragStartBehavior dragStartBehavior;

  final MouseCursor? mouseCursor;

  final WidgetStateProperty<Color?>? overlayColor;

  final double? splashRadius;

  final FocusNode? focusNode;

  final ValueChanged<bool>? onFocusChange;

  final bool autofocus;

  final Color? tileColor;

  final Widget? title;

  final Widget? subtitle;

  final Widget? secondary;

  final bool isThreeLine;

  final bool? dense;

  final EdgeInsetsGeometry? contentPadding;

  final bool selected;

  final _SwitchListTileType _switchListTileType;

  final ListTileControlAffinity? controlAffinity;

  final ShapeBorder? shape;

  final Color? selectedTileColor;

  final VisualDensity? visualDensity;

  final bool? enableFeedback;

  final Color? hoverColor;

  final bool? applyCupertinoTheme;

  // TODO(hangyujin): Remove this flag after fixing related g3 tests and flipping
  // the default value to true.
  final bool internalAddSemanticForOnTap;
  @override
  Widget build(BuildContext context) {
    final Widget control;
    switch (_switchListTileType) {
      case _SwitchListTileType.adaptive:
        control = ExcludeFocus(
          child: Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: activeColor,
            activeThumbImage: activeThumbImage,
            inactiveThumbImage: inactiveThumbImage,
            materialTapTargetSize: materialTapTargetSize ?? MaterialTapTargetSize.shrinkWrap,
            activeTrackColor: activeTrackColor,
            inactiveTrackColor: inactiveTrackColor,
            inactiveThumbColor: inactiveThumbColor,
            autofocus: autofocus,
            onFocusChange: onFocusChange,
            onActiveThumbImageError: onActiveThumbImageError,
            onInactiveThumbImageError: onInactiveThumbImageError,
            thumbColor: thumbColor,
            trackColor: trackColor,
            trackOutlineColor: trackOutlineColor,
            thumbIcon: thumbIcon,
            applyCupertinoTheme: applyCupertinoTheme,
            dragStartBehavior: dragStartBehavior,
            mouseCursor: mouseCursor,
            splashRadius: splashRadius,
            overlayColor: overlayColor,
          ),
        );

      case _SwitchListTileType.material:
        control = ExcludeFocus(
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: activeColor,
            activeThumbImage: activeThumbImage,
            inactiveThumbImage: inactiveThumbImage,
            materialTapTargetSize: materialTapTargetSize ?? MaterialTapTargetSize.shrinkWrap,
            activeTrackColor: activeTrackColor,
            inactiveTrackColor: inactiveTrackColor,
            inactiveThumbColor: inactiveThumbColor,
            autofocus: autofocus,
            onFocusChange: onFocusChange,
            onActiveThumbImageError: onActiveThumbImageError,
            onInactiveThumbImageError: onInactiveThumbImageError,
            thumbColor: thumbColor,
            trackColor: trackColor,
            trackOutlineColor: trackOutlineColor,
            thumbIcon: thumbIcon,
            dragStartBehavior: dragStartBehavior,
            mouseCursor: mouseCursor,
            splashRadius: splashRadius,
            overlayColor: overlayColor,
          ),
        );
    }

    final ListTileThemeData listTileTheme = ListTileTheme.of(context);
    final ListTileControlAffinity effectiveControlAffinity =
        controlAffinity ?? listTileTheme.controlAffinity ?? ListTileControlAffinity.platform;
    Widget? leading;
    Widget? trailing;
    (leading, trailing) = switch (effectiveControlAffinity) {
      ListTileControlAffinity.leading => (control, secondary),
      ListTileControlAffinity.trailing || ListTileControlAffinity.platform => (secondary, control),
    };

    final ThemeData theme = Theme.of(context);
    final SwitchThemeData switchTheme = SwitchTheme.of(context);
    final Set<WidgetState> states = <WidgetState>{if (selected) WidgetState.selected};
    final Color effectiveActiveColor =
        activeColor ?? switchTheme.thumbColor?.resolve(states) ?? theme.colorScheme.secondary;
    return MergeSemantics(
      child: ListTile(
        selectedColor: effectiveActiveColor,
        leading: leading,
        title: title,
        subtitle: subtitle,
        trailing: trailing,
        isThreeLine: isThreeLine,
        dense: dense,
        contentPadding: contentPadding,
        enabled: onChanged != null,
        onTap:
            onChanged != null
                ? () {
                  onChanged!(!value);
                }
                : null,
        selected: selected,
        selectedTileColor: selectedTileColor,
        autofocus: autofocus,
        shape: shape,
        tileColor: tileColor,
        visualDensity: visualDensity,
        focusNode: focusNode,
        onFocusChange: onFocusChange,
        enableFeedback: enableFeedback,
        hoverColor: hoverColor,
        internalAddSemanticForOnTap: internalAddSemanticForOnTap,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('value', value));
    properties.add(ObjectFlagProperty<ValueChanged<bool>?>.has('onChanged', onChanged));
    properties.add(ColorProperty('activeColor', activeColor));
    properties.add(ColorProperty('activeTrackColor', activeTrackColor));
    properties.add(ColorProperty('inactiveThumbColor', inactiveThumbColor));
    properties.add(ColorProperty('inactiveTrackColor', inactiveTrackColor));
    properties.add(DiagnosticsProperty<ImageProvider<Object>?>('activeThumbImage', activeThumbImage));
    properties.add(ObjectFlagProperty<ImageErrorListener?>.has('onActiveThumbImageError', onActiveThumbImageError));
    properties.add(DiagnosticsProperty<ImageProvider<Object>?>('inactiveThumbImage', inactiveThumbImage));
    properties.add(ObjectFlagProperty<ImageErrorListener?>.has('onInactiveThumbImageError', onInactiveThumbImageError));
    properties.add(DiagnosticsProperty<WidgetStateProperty<Color?>?>('thumbColor', thumbColor));
    properties.add(DiagnosticsProperty<WidgetStateProperty<Color?>?>('trackColor', trackColor));
    properties.add(DiagnosticsProperty<WidgetStateProperty<Color?>?>('trackOutlineColor', trackOutlineColor));
    properties.add(DiagnosticsProperty<WidgetStateProperty<Icon?>?>('thumbIcon', thumbIcon));
    properties.add(EnumProperty<MaterialTapTargetSize?>('materialTapTargetSize', materialTapTargetSize));
    properties.add(EnumProperty<DragStartBehavior>('dragStartBehavior', dragStartBehavior));
    properties.add(DiagnosticsProperty<MouseCursor?>('mouseCursor', mouseCursor));
    properties.add(DiagnosticsProperty<WidgetStateProperty<Color?>?>('overlayColor', overlayColor));
    properties.add(DoubleProperty('splashRadius', splashRadius));
    properties.add(DiagnosticsProperty<FocusNode?>('focusNode', focusNode));
    properties.add(ObjectFlagProperty<ValueChanged<bool>?>.has('onFocusChange', onFocusChange));
    properties.add(DiagnosticsProperty<bool>('autofocus', autofocus));
    properties.add(ColorProperty('tileColor', tileColor));
    properties.add(DiagnosticsProperty<bool>('isThreeLine', isThreeLine));
    properties.add(DiagnosticsProperty<bool?>('dense', dense));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('contentPadding', contentPadding));
    properties.add(DiagnosticsProperty<bool>('selected', selected));
    properties.add(EnumProperty<ListTileControlAffinity?>('controlAffinity', controlAffinity));
    properties.add(DiagnosticsProperty<ShapeBorder?>('shape', shape));
    properties.add(ColorProperty('selectedTileColor', selectedTileColor));
    properties.add(DiagnosticsProperty<VisualDensity?>('visualDensity', visualDensity));
    properties.add(DiagnosticsProperty<bool?>('enableFeedback', enableFeedback));
    properties.add(ColorProperty('hoverColor', hoverColor));
    properties.add(DiagnosticsProperty<bool?>('applyCupertinoTheme', applyCupertinoTheme));
    properties.add(DiagnosticsProperty<bool>('internalAddSemanticForOnTap', internalAddSemanticForOnTap));
  }
}
