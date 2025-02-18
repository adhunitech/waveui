// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/list_tile.dart';
import 'package:waveui/material/list_tile_theme.dart';
import 'package:waveui/material/radio.dart';
import 'package:waveui/material/radio_theme.dart';
import 'package:waveui/material/theme.dart';
import 'package:waveui/material/theme_data.dart';

// Examples can assume:
// void setState(VoidCallback fn) { }
// enum Meridiem { am, pm }
// enum SingingCharacter { lafayette }
// late SingingCharacter? _character;

enum _RadioType { material, adaptive }

class RadioListTile<T> extends StatelessWidget {
  const RadioListTile({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    super.key,
    this.mouseCursor,
    this.toggleable = false,
    this.activeColor,
    this.fillColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.materialTapTargetSize,
    this.title,
    this.subtitle,
    this.isThreeLine = false,
    this.dense,
    this.secondary,
    this.selected = false,
    this.controlAffinity,
    this.autofocus = false,
    this.contentPadding,
    this.shape,
    this.tileColor,
    this.selectedTileColor,
    this.visualDensity,
    this.focusNode,
    this.onFocusChange,
    this.enableFeedback,
    this.radioScaleFactor = 1.0,
    this.internalAddSemanticForOnTap = false,
  }) : _radioType = _RadioType.material,
       useCupertinoCheckmarkStyle = false,
       assert(!isThreeLine || subtitle != null);

  const RadioListTile.adaptive({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    super.key,
    this.mouseCursor,
    this.toggleable = false,
    this.activeColor,
    this.fillColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.materialTapTargetSize,
    this.title,
    this.subtitle,
    this.isThreeLine = false,
    this.dense,
    this.secondary,
    this.selected = false,
    this.controlAffinity,
    this.autofocus = false,
    this.contentPadding,
    this.shape,
    this.tileColor,
    this.selectedTileColor,
    this.visualDensity,
    this.focusNode,
    this.onFocusChange,
    this.enableFeedback,
    this.radioScaleFactor = 1.0,
    this.useCupertinoCheckmarkStyle = false,
    this.internalAddSemanticForOnTap = false,
  }) : _radioType = _RadioType.adaptive,
       assert(!isThreeLine || subtitle != null);

  final T value;

  final T? groupValue;

  final ValueChanged<T?>? onChanged;

  final MouseCursor? mouseCursor;

  final bool toggleable;

  final Color? activeColor;

  final WidgetStateProperty<Color?>? fillColor;

  final MaterialTapTargetSize? materialTapTargetSize;

  final Color? hoverColor;

  final WidgetStateProperty<Color?>? overlayColor;

  final double? splashRadius;

  final Widget? title;

  final Widget? subtitle;

  final Widget? secondary;

  final bool isThreeLine;

  final bool? dense;

  final bool selected;

  final ListTileControlAffinity? controlAffinity;

  final bool autofocus;

  final EdgeInsetsGeometry? contentPadding;

  bool get checked => value == groupValue;

  final ShapeBorder? shape;

  final Color? tileColor;

  final Color? selectedTileColor;

  final VisualDensity? visualDensity;

  final FocusNode? focusNode;

  final ValueChanged<bool>? onFocusChange;

  final bool? enableFeedback;

  final _RadioType _radioType;

  // TODO(hangyujin): Remove this flag after fixing related g3 tests and flipping
  // the default value to true.
  final bool internalAddSemanticForOnTap;

  final bool useCupertinoCheckmarkStyle;

  final double radioScaleFactor;

  @override
  Widget build(BuildContext context) {
    Widget control;
    switch (_radioType) {
      case _RadioType.material:
        control = ExcludeFocus(
          child: Radio<T>(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
            toggleable: toggleable,
            activeColor: activeColor,
            materialTapTargetSize: materialTapTargetSize ?? MaterialTapTargetSize.shrinkWrap,
            autofocus: autofocus,
            fillColor: fillColor,
            mouseCursor: mouseCursor,
            hoverColor: hoverColor,
            overlayColor: overlayColor,
            splashRadius: splashRadius,
          ),
        );
      case _RadioType.adaptive:
        control = ExcludeFocus(
          child: Radio<T>.adaptive(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
            toggleable: toggleable,
            activeColor: activeColor,
            materialTapTargetSize: materialTapTargetSize ?? MaterialTapTargetSize.shrinkWrap,
            autofocus: autofocus,
            fillColor: fillColor,
            mouseCursor: mouseCursor,
            hoverColor: hoverColor,
            overlayColor: overlayColor,
            splashRadius: splashRadius,
            useCupertinoCheckmarkStyle: useCupertinoCheckmarkStyle,
          ),
        );
    }

    if (radioScaleFactor != 1.0) {
      control = Transform.scale(scale: radioScaleFactor, child: control);
    }

    final ListTileThemeData listTileTheme = ListTileTheme.of(context);
    final ListTileControlAffinity effectiveControlAffinity =
        controlAffinity ?? listTileTheme.controlAffinity ?? ListTileControlAffinity.platform;
    Widget? leading;
    Widget? trailing;
    (leading, trailing) = switch (effectiveControlAffinity) {
      ListTileControlAffinity.leading || ListTileControlAffinity.platform => (control, secondary),
      ListTileControlAffinity.trailing => (secondary, control),
    };

    final ThemeData theme = Theme.of(context);
    final RadioThemeData radioThemeData = RadioTheme.of(context);
    final Set<WidgetState> states = <WidgetState>{if (selected) WidgetState.selected};
    final Color effectiveActiveColor =
        activeColor ?? radioThemeData.fillColor?.resolve(states) ?? theme.colorScheme.secondary;
    return MergeSemantics(
      child: ListTile(
        selectedColor: effectiveActiveColor,
        leading: leading,
        title: title,
        subtitle: subtitle,
        trailing: trailing,
        isThreeLine: isThreeLine,
        dense: dense,
        enabled: onChanged != null,
        shape: shape,
        tileColor: tileColor,
        selectedTileColor: selectedTileColor,
        onTap:
            onChanged != null
                ? () {
                  if (toggleable && checked) {
                    onChanged!(null);
                    return;
                  }
                  if (!checked) {
                    onChanged!(value);
                  }
                }
                : null,
        selected: selected,
        autofocus: autofocus,
        contentPadding: contentPadding,
        visualDensity: visualDensity,
        focusNode: focusNode,
        onFocusChange: onFocusChange,
        enableFeedback: enableFeedback,
        internalAddSemanticForOnTap: internalAddSemanticForOnTap,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<T>('value', value));
    properties.add(DiagnosticsProperty<T?>('groupValue', groupValue));
    properties.add(ObjectFlagProperty<ValueChanged<T?>?>.has('onChanged', onChanged));
    properties.add(DiagnosticsProperty<MouseCursor?>('mouseCursor', mouseCursor));
    properties.add(DiagnosticsProperty<bool>('toggleable', toggleable));
    properties.add(ColorProperty('activeColor', activeColor));
    properties.add(DiagnosticsProperty<WidgetStateProperty<Color?>?>('fillColor', fillColor));
    properties.add(EnumProperty<MaterialTapTargetSize?>('materialTapTargetSize', materialTapTargetSize));
    properties.add(ColorProperty('hoverColor', hoverColor));
    properties.add(DiagnosticsProperty<WidgetStateProperty<Color?>?>('overlayColor', overlayColor));
    properties.add(DoubleProperty('splashRadius', splashRadius));
    properties.add(DiagnosticsProperty<bool>('isThreeLine', isThreeLine));
    properties.add(DiagnosticsProperty<bool?>('dense', dense));
    properties.add(DiagnosticsProperty<bool>('selected', selected));
    properties.add(EnumProperty<ListTileControlAffinity?>('controlAffinity', controlAffinity));
    properties.add(DiagnosticsProperty<bool>('autofocus', autofocus));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('contentPadding', contentPadding));
    properties.add(DiagnosticsProperty<bool>('checked', checked));
    properties.add(DiagnosticsProperty<ShapeBorder?>('shape', shape));
    properties.add(ColorProperty('tileColor', tileColor));
    properties.add(ColorProperty('selectedTileColor', selectedTileColor));
    properties.add(DiagnosticsProperty<VisualDensity?>('visualDensity', visualDensity));
    properties.add(DiagnosticsProperty<FocusNode?>('focusNode', focusNode));
    properties.add(ObjectFlagProperty<ValueChanged<bool>?>.has('onFocusChange', onFocusChange));
    properties.add(DiagnosticsProperty<bool?>('enableFeedback', enableFeedback));
    properties.add(DiagnosticsProperty<bool>('internalAddSemanticForOnTap', internalAddSemanticForOnTap));
    properties.add(DiagnosticsProperty<bool>('useCupertinoCheckmarkStyle', useCupertinoCheckmarkStyle));
    properties.add(DoubleProperty('radioScaleFactor', radioScaleFactor));
  }
}
