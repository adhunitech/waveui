// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

import 'package:waveui/material/adaptive_text_selection_toolbar.dart';
import 'package:waveui/material/debug.dart';
import 'package:waveui/material/desktop_text_selection.dart';
import 'package:waveui/material/magnifier.dart';
import 'package:waveui/material/text_selection.dart';
import 'package:waveui/material/theme.dart';

class SelectionArea extends StatefulWidget {
  const SelectionArea({
    required this.child,
    super.key,
    this.focusNode,
    this.selectionControls,
    this.contextMenuBuilder = _defaultContextMenuBuilder,
    this.magnifierConfiguration,
    this.onSelectionChanged,
  });

  final TextMagnifierConfiguration? magnifierConfiguration;

  final FocusNode? focusNode;

  final TextSelectionControls? selectionControls;

  final SelectableRegionContextMenuBuilder? contextMenuBuilder;

  final ValueChanged<SelectedContent?>? onSelectionChanged;

  final Widget child;

  static Widget _defaultContextMenuBuilder(BuildContext context, SelectableRegionState selectableRegionState) =>
      AdaptiveTextSelectionToolbar.selectableRegion(selectableRegionState: selectableRegionState);

  @override
  State<StatefulWidget> createState() => SelectionAreaState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextMagnifierConfiguration?>('magnifierConfiguration', magnifierConfiguration));
    properties.add(DiagnosticsProperty<FocusNode?>('focusNode', focusNode));
    properties.add(DiagnosticsProperty<TextSelectionControls?>('selectionControls', selectionControls));
    properties.add(
      ObjectFlagProperty<SelectableRegionContextMenuBuilder?>.has('contextMenuBuilder', contextMenuBuilder),
    );
    properties.add(ObjectFlagProperty<ValueChanged<SelectedContent?>?>.has('onSelectionChanged', onSelectionChanged));
  }
}

class SelectionAreaState extends State<SelectionArea> {
  final GlobalKey<SelectableRegionState> _selectableRegionKey = GlobalKey<SelectableRegionState>();

  SelectableRegionState get selectableRegion => _selectableRegionKey.currentState!;

  @protected
  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final TextSelectionControls controls =
        widget.selectionControls ??
        switch (Theme.of(context).platform) {
          TargetPlatform.android || TargetPlatform.fuchsia => materialTextSelectionHandleControls,
          TargetPlatform.linux || TargetPlatform.windows => desktopTextSelectionHandleControls,
          TargetPlatform.iOS => cupertinoTextSelectionHandleControls,
          TargetPlatform.macOS => cupertinoDesktopTextSelectionHandleControls,
        };
    return SelectableRegion(
      key: _selectableRegionKey,
      selectionControls: controls,
      focusNode: widget.focusNode,
      contextMenuBuilder: widget.contextMenuBuilder,
      magnifierConfiguration: widget.magnifierConfiguration ?? TextMagnifier.adaptiveMagnifierConfiguration,
      onSelectionChanged: widget.onSelectionChanged,
      child: widget.child,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SelectableRegionState>('selectableRegion', selectableRegion));
  }
}
