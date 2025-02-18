// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

import 'package:waveui/material/debug.dart';
import 'package:waveui/material/desktop_text_selection_toolbar.dart';
import 'package:waveui/material/desktop_text_selection_toolbar_button.dart';
import 'package:waveui/material/material_localizations.dart';
import 'package:waveui/material/text_selection_toolbar.dart';
import 'package:waveui/material/text_selection_toolbar_text_button.dart';
import 'package:waveui/material/theme.dart';

class AdaptiveTextSelectionToolbar extends StatelessWidget {
  const AdaptiveTextSelectionToolbar({required this.children, required this.anchors, super.key}) : buttonItems = null;

  const AdaptiveTextSelectionToolbar.buttonItems({required this.buttonItems, required this.anchors, super.key})
    : children = null;

  AdaptiveTextSelectionToolbar.editable({
    required ClipboardStatus clipboardStatus,
    required VoidCallback? onCopy,
    required VoidCallback? onCut,
    required VoidCallback? onPaste,
    required VoidCallback? onSelectAll,
    required VoidCallback? onLookUp,
    required VoidCallback? onSearchWeb,
    required VoidCallback? onShare,
    required VoidCallback? onLiveTextInput,
    required this.anchors,
    super.key,
  }) : children = null,
       buttonItems = EditableText.getEditableButtonItems(
         clipboardStatus: clipboardStatus,
         onCopy: onCopy,
         onCut: onCut,
         onPaste: onPaste,
         onSelectAll: onSelectAll,
         onLookUp: onLookUp,
         onSearchWeb: onSearchWeb,
         onShare: onShare,
         onLiveTextInput: onLiveTextInput,
       );

  AdaptiveTextSelectionToolbar.editableText({required EditableTextState editableTextState, super.key})
    : children = null,
      buttonItems = editableTextState.contextMenuButtonItems,
      anchors = editableTextState.contextMenuAnchors;

  AdaptiveTextSelectionToolbar.selectable({
    required VoidCallback onCopy,
    required VoidCallback onSelectAll,
    required VoidCallback? onShare,
    required SelectionGeometry selectionGeometry,
    required this.anchors,
    super.key,
  }) : children = null,
       buttonItems = SelectableRegion.getSelectableButtonItems(
         selectionGeometry: selectionGeometry,
         onCopy: onCopy,
         onSelectAll: onSelectAll,
         onShare: onShare,
       );

  AdaptiveTextSelectionToolbar.selectableRegion({required SelectableRegionState selectableRegionState, super.key})
    : children = null,
      buttonItems = selectableRegionState.contextMenuButtonItems,
      anchors = selectableRegionState.contextMenuAnchors;

  final List<ContextMenuButtonItem>? buttonItems;

  final List<Widget>? children;

  final TextSelectionToolbarAnchors anchors;

  static String getButtonLabel(BuildContext context, ContextMenuButtonItem buttonItem) {
    if (buttonItem.label != null) {
      return buttonItem.label!;
    }

    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return CupertinoTextSelectionToolbarButton.getButtonLabel(context, buttonItem);
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        assert(debugCheckHasMaterialLocalizations(context));
        final MaterialLocalizations localizations = MaterialLocalizations.of(context);
        return switch (buttonItem.type) {
          ContextMenuButtonType.cut => localizations.cutButtonLabel,
          ContextMenuButtonType.copy => localizations.copyButtonLabel,
          ContextMenuButtonType.paste => localizations.pasteButtonLabel,
          ContextMenuButtonType.selectAll => localizations.selectAllButtonLabel,
          ContextMenuButtonType.delete => localizations.deleteButtonTooltip.toUpperCase(),
          ContextMenuButtonType.lookUp => localizations.lookUpButtonLabel,
          ContextMenuButtonType.searchWeb => localizations.searchWebButtonLabel,
          ContextMenuButtonType.share => localizations.shareButtonLabel,
          ContextMenuButtonType.liveTextInput => localizations.scanTextButtonLabel,
          ContextMenuButtonType.custom => '',
        };
    }
  }

  static Iterable<Widget> getAdaptiveButtons(BuildContext context, List<ContextMenuButtonItem> buttonItems) {
    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
        return buttonItems.map((buttonItem) => CupertinoTextSelectionToolbarButton.buttonItem(buttonItem: buttonItem));
      case TargetPlatform.fuchsia:
      case TargetPlatform.android:
        final List<Widget> buttons = <Widget>[];
        for (int i = 0; i < buttonItems.length; i++) {
          final ContextMenuButtonItem buttonItem = buttonItems[i];
          buttons.add(
            TextSelectionToolbarTextButton(
              padding: TextSelectionToolbarTextButton.getPadding(i, buttonItems.length),
              onPressed: buttonItem.onPressed,
              alignment: AlignmentDirectional.centerStart,
              child: Text(getButtonLabel(context, buttonItem)),
            ),
          );
        }
        return buttons;
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return buttonItems.map(
          (buttonItem) => DesktopTextSelectionToolbarButton.text(
            context: context,
            onPressed: buttonItem.onPressed,
            text: getButtonLabel(context, buttonItem),
          ),
        );
      case TargetPlatform.macOS:
        return buttonItems.map(
          (buttonItem) => CupertinoDesktopTextSelectionToolbarButton.text(
            onPressed: buttonItem.onPressed,
            text: getButtonLabel(context, buttonItem),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    // If there aren't any buttons to build, build an empty toolbar.
    if ((children != null && children!.isEmpty) || (buttonItems != null && buttonItems!.isEmpty)) {
      return const SizedBox.shrink();
    }

    final List<Widget> resultChildren =
        children != null ? children! : getAdaptiveButtons(context, buttonItems!).toList();

    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
        return CupertinoTextSelectionToolbar(
          anchorAbove: anchors.primaryAnchor,
          anchorBelow: anchors.secondaryAnchor == null ? anchors.primaryAnchor : anchors.secondaryAnchor!,
          children: resultChildren,
        );
      case TargetPlatform.android:
        return TextSelectionToolbar(
          anchorAbove: anchors.primaryAnchor,
          anchorBelow: anchors.secondaryAnchor == null ? anchors.primaryAnchor : anchors.secondaryAnchor!,
          children: resultChildren,
        );
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return DesktopTextSelectionToolbar(anchor: anchors.primaryAnchor, children: resultChildren);
      case TargetPlatform.macOS:
        return CupertinoDesktopTextSelectionToolbar(anchor: anchors.primaryAnchor, children: resultChildren);
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<ContextMenuButtonItem>('buttonItems', buttonItems));
    properties.add(DiagnosticsProperty<TextSelectionToolbarAnchors>('anchors', anchors));
  }
}
