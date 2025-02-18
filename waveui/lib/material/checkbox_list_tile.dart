// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/checkbox.dart';
import 'package:waveui/material/checkbox_theme.dart';
import 'package:waveui/material/list_tile.dart';
import 'package:waveui/material/list_tile_theme.dart';
import 'package:waveui/material/material_state.dart';
import 'package:waveui/material/theme.dart';
import 'package:waveui/material/theme_data.dart';

// Examples can assume:
// late bool? _throwShotAway;
// void setState(VoidCallback fn) { }

enum _CheckboxType { material, adaptive }

class CheckboxListTile extends StatelessWidget {
  const CheckboxListTile({
    required this.value,
    required this.onChanged,
    super.key,
    this.mouseCursor,
    this.activeColor,
    this.fillColor,
    this.checkColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.materialTapTargetSize,
    this.visualDensity,
    this.focusNode,
    this.autofocus = false,
    this.shape,
    this.side,
    this.isError = false,
    this.enabled,
    this.tileColor,
    this.title,
    this.subtitle,
    this.isThreeLine = false,
    this.dense,
    this.secondary,
    this.selected = false,
    this.controlAffinity,
    this.contentPadding,
    this.tristate = false,
    this.checkboxShape,
    this.selectedTileColor,
    this.onFocusChange,
    this.enableFeedback,
    this.checkboxSemanticLabel,
    this.checkboxScaleFactor = 1.0,
    this.internalAddSemanticForOnTap = false,
  }) : _checkboxType = _CheckboxType.material,
       assert(tristate || value != null),
       assert(!isThreeLine || subtitle != null);

  const CheckboxListTile.adaptive({
    required this.value,
    required this.onChanged,
    super.key,
    this.mouseCursor,
    this.activeColor,
    this.fillColor,
    this.checkColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.materialTapTargetSize,
    this.visualDensity,
    this.focusNode,
    this.autofocus = false,
    this.shape,
    this.side,
    this.isError = false,
    this.enabled,
    this.tileColor,
    this.title,
    this.subtitle,
    this.isThreeLine = false,
    this.dense,
    this.secondary,
    this.selected = false,
    this.controlAffinity,
    this.contentPadding,
    this.tristate = false,
    this.checkboxShape,
    this.selectedTileColor,
    this.onFocusChange,
    this.enableFeedback,
    this.checkboxSemanticLabel,
    this.checkboxScaleFactor = 1.0,
    this.internalAddSemanticForOnTap = false,
  }) : _checkboxType = _CheckboxType.adaptive,
       assert(tristate || value != null),
       assert(!isThreeLine || subtitle != null);

  final bool? value;

  final ValueChanged<bool?>? onChanged;

  final MouseCursor? mouseCursor;

  final Color? activeColor;

  final WidgetStateProperty<Color?>? fillColor;

  final Color? checkColor;

  final Color? hoverColor;

  final WidgetStateProperty<Color?>? overlayColor;

  final double? splashRadius;

  final MaterialTapTargetSize? materialTapTargetSize;

  final VisualDensity? visualDensity;

  final FocusNode? focusNode;

  final bool autofocus;

  final ShapeBorder? shape;

  final BorderSide? side;

  final bool isError;

  final Color? tileColor;

  final Widget? title;

  final Widget? subtitle;

  final Widget? secondary;

  final bool isThreeLine;

  final bool? dense;

  final bool selected;

  final ListTileControlAffinity? controlAffinity;

  final EdgeInsetsGeometry? contentPadding;

  final bool tristate;

  final OutlinedBorder? checkboxShape;

  final Color? selectedTileColor;

  final ValueChanged<bool>? onFocusChange;

  final bool? enableFeedback;

  final bool? enabled;

  // TODO(hangyujin): Remove this flag after fixing related g3 tests and flipping
  // the default value to true.
  final bool internalAddSemanticForOnTap;

  final double checkboxScaleFactor;

  final String? checkboxSemanticLabel;

  final _CheckboxType _checkboxType;

  void _handleValueChange() {
    assert(onChanged != null);
    switch (value) {
      case false:
        onChanged!(true);
      case true:
        onChanged!(tristate ? null : false);
      case null:
        onChanged!(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget control;

    switch (_checkboxType) {
      case _CheckboxType.material:
        control = ExcludeFocus(
          child: Checkbox(
            value: value,
            onChanged: enabled ?? true ? onChanged : null,
            mouseCursor: mouseCursor,
            activeColor: activeColor,
            fillColor: fillColor,
            checkColor: checkColor,
            hoverColor: hoverColor,
            overlayColor: overlayColor,
            splashRadius: splashRadius,
            materialTapTargetSize: materialTapTargetSize ?? MaterialTapTargetSize.shrinkWrap,
            autofocus: autofocus,
            tristate: tristate,
            shape: checkboxShape,
            side: side,
            isError: isError,
            semanticLabel: checkboxSemanticLabel,
          ),
        );
      case _CheckboxType.adaptive:
        control = ExcludeFocus(
          child: Checkbox.adaptive(
            value: value,
            onChanged: enabled ?? true ? onChanged : null,
            mouseCursor: mouseCursor,
            activeColor: activeColor,
            fillColor: fillColor,
            checkColor: checkColor,
            hoverColor: hoverColor,
            overlayColor: overlayColor,
            splashRadius: splashRadius,
            materialTapTargetSize: materialTapTargetSize ?? MaterialTapTargetSize.shrinkWrap,
            autofocus: autofocus,
            tristate: tristate,
            shape: checkboxShape,
            side: side,
            isError: isError,
            semanticLabel: checkboxSemanticLabel,
          ),
        );
    }
    if (checkboxScaleFactor != 1.0) {
      control = Transform.scale(scale: checkboxScaleFactor, child: control);
    }

    final ListTileThemeData listTileTheme = ListTileTheme.of(context);
    final ListTileControlAffinity effectiveControlAffinity =
        controlAffinity ?? listTileTheme.controlAffinity ?? ListTileControlAffinity.platform;
    final (Widget? leading, Widget? trailing) = switch (effectiveControlAffinity) {
      ListTileControlAffinity.leading => (control, secondary),
      ListTileControlAffinity.trailing || ListTileControlAffinity.platform => (secondary, control),
    };

    final ThemeData theme = Theme.of(context);
    final CheckboxThemeData checkboxTheme = CheckboxTheme.of(context);
    final Set<WidgetState> states = <WidgetState>{if (selected) WidgetState.selected};
    final Color effectiveActiveColor =
        activeColor ?? checkboxTheme.fillColor?.resolve(states) ?? theme.colorScheme.secondary;
    return MergeSemantics(
      child: ListTile(
        selectedColor: effectiveActiveColor,
        leading: leading,
        title: title,
        subtitle: subtitle,
        trailing: trailing,
        isThreeLine: isThreeLine,
        dense: dense,
        enabled: enabled ?? onChanged != null,
        onTap: onChanged != null ? _handleValueChange : null,
        selected: selected,
        autofocus: autofocus,
        contentPadding: contentPadding,
        shape: shape,
        selectedTileColor: selectedTileColor,
        tileColor: tileColor,
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
    properties.add(DiagnosticsProperty<bool?>('value', value));
    properties.add(ObjectFlagProperty<ValueChanged<bool?>?>.has('onChanged', onChanged));
    properties.add(DiagnosticsProperty<MouseCursor?>('mouseCursor', mouseCursor));
    properties.add(ColorProperty('activeColor', activeColor));
    properties.add(DiagnosticsProperty<WidgetStateProperty<Color?>?>('fillColor', fillColor));
    properties.add(ColorProperty('checkColor', checkColor));
    properties.add(ColorProperty('hoverColor', hoverColor));
    properties.add(DiagnosticsProperty<WidgetStateProperty<Color?>?>('overlayColor', overlayColor));
    properties.add(DoubleProperty('splashRadius', splashRadius));
    properties.add(EnumProperty<MaterialTapTargetSize?>('materialTapTargetSize', materialTapTargetSize));
    properties.add(DiagnosticsProperty<VisualDensity?>('visualDensity', visualDensity));
    properties.add(DiagnosticsProperty<FocusNode?>('focusNode', focusNode));
    properties.add(DiagnosticsProperty<bool>('autofocus', autofocus));
    properties.add(DiagnosticsProperty<ShapeBorder?>('shape', shape));
    properties.add(DiagnosticsProperty<BorderSide?>('side', side));
    properties.add(DiagnosticsProperty<bool>('isError', isError));
    properties.add(ColorProperty('tileColor', tileColor));
    properties.add(DiagnosticsProperty<bool>('isThreeLine', isThreeLine));
    properties.add(DiagnosticsProperty<bool?>('dense', dense));
    properties.add(DiagnosticsProperty<bool>('selected', selected));
    properties.add(EnumProperty<ListTileControlAffinity?>('controlAffinity', controlAffinity));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('contentPadding', contentPadding));
    properties.add(DiagnosticsProperty<bool>('tristate', tristate));
    properties.add(DiagnosticsProperty<OutlinedBorder?>('checkboxShape', checkboxShape));
    properties.add(ColorProperty('selectedTileColor', selectedTileColor));
    properties.add(ObjectFlagProperty<ValueChanged<bool>?>.has('onFocusChange', onFocusChange));
    properties.add(DiagnosticsProperty<bool?>('enableFeedback', enableFeedback));
    properties.add(DiagnosticsProperty<bool?>('enabled', enabled));
    properties.add(DiagnosticsProperty<bool>('internalAddSemanticForOnTap', internalAddSemanticForOnTap));
    properties.add(DoubleProperty('checkboxScaleFactor', checkboxScaleFactor));
    properties.add(StringProperty('checkboxSemanticLabel', checkboxSemanticLabel));
  }
}
