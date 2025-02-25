// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/debug.dart';
import 'package:waveui/material/material_localizations.dart';
import 'package:waveui/material/text_selection_theme.dart';
import 'package:waveui/material/text_selection_toolbar.dart';
import 'package:waveui/material/text_selection_toolbar_text_button.dart';
import 'package:waveui/material/theme.dart';

const double _kHandleSize = 22.0;

// Padding between the toolbar and the anchor.
const double _kToolbarContentDistanceBelow = _kHandleSize - 2.0;
const double _kToolbarContentDistance = 8.0;

@Deprecated(
  'Use `MaterialTextSelectionControls`. '
  'This feature was deprecated after v3.3.0-0.5.pre.',
)
class MaterialTextSelectionHandleControls extends MaterialTextSelectionControls with TextSelectionHandleControls {}

class MaterialTextSelectionControls extends TextSelectionControls {
  @override
  Size getHandleSize(double textLineHeight) => const Size(_kHandleSize, _kHandleSize);

  @Deprecated(
    'Use `contextMenuBuilder` instead. '
    'This feature was deprecated after v3.3.0-0.5.pre.',
  )
  @override
  Widget buildToolbar(
    BuildContext context,
    Rect globalEditableRegion,
    double textLineHeight,
    Offset selectionMidpoint,
    List<TextSelectionPoint> endpoints,
    TextSelectionDelegate delegate,
    ValueListenable<ClipboardStatus>? clipboardStatus,
    Offset? lastSecondaryTapDownPosition,
  ) => _TextSelectionControlsToolbar(
    globalEditableRegion: globalEditableRegion,
    textLineHeight: textLineHeight,
    selectionMidpoint: selectionMidpoint,
    endpoints: endpoints,
    delegate: delegate,
    clipboardStatus: clipboardStatus,
    handleCut: canCut(delegate) ? () => handleCut(delegate) : null,
    handleCopy: canCopy(delegate) ? () => handleCopy(delegate) : null,
    handlePaste: canPaste(delegate) ? () => handlePaste(delegate) : null,
    handleSelectAll: canSelectAll(delegate) ? () => handleSelectAll(delegate) : null,
  );

  @override
  Widget buildHandle(BuildContext context, TextSelectionHandleType type, double textHeight, [VoidCallback? onTap]) {
    final ThemeData theme = Theme.of(context);
    final Color handleColor = TextSelectionTheme.of(context).selectionHandleColor ?? theme.colorScheme.primary;
    final Widget handle = SizedBox(
      width: _kHandleSize,
      height: _kHandleSize,
      child: CustomPaint(
        painter: _TextSelectionHandlePainter(color: handleColor),
        child: GestureDetector(onTap: onTap, behavior: HitTestBehavior.translucent),
      ),
    );

    // [handle] is a circle, with a rectangle in the top left quadrant of that
    // circle (an onion pointing to 10:30). We rotate [handle] to point
    // straight up or up-right depending on the handle type.
    return switch (type) {
      TextSelectionHandleType.left => Transform.rotate(angle: math.pi / 2.0, child: handle), // points up-right
      TextSelectionHandleType.right => handle, // points up-left
      TextSelectionHandleType.collapsed => Transform.rotate(angle: math.pi / 4.0, child: handle), // points up
    };
  }

  @override
  Offset getHandleAnchor(TextSelectionHandleType type, double textLineHeight) => switch (type) {
    TextSelectionHandleType.collapsed => const Offset(_kHandleSize / 2, -4),
    TextSelectionHandleType.left => const Offset(_kHandleSize, 0),
    TextSelectionHandleType.right => Offset.zero,
  };

  @Deprecated(
    'Use `contextMenuBuilder` instead. '
    'This feature was deprecated after v3.3.0-0.5.pre.',
  )
  @override
  bool canSelectAll(TextSelectionDelegate delegate) {
    // Android allows SelectAll when selection is not collapsed, unless
    // everything has already been selected.
    final TextEditingValue value = delegate.textEditingValue;
    return delegate.selectAllEnabled &&
        value.text.isNotEmpty &&
        !(value.selection.start == 0 && value.selection.end == value.text.length);
  }
}

// The label and callback for the available default text selection menu buttons.
class _TextSelectionToolbarItemData {
  const _TextSelectionToolbarItemData({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;
}

// The highest level toolbar widget, built directly by buildToolbar.
class _TextSelectionControlsToolbar extends StatefulWidget {
  const _TextSelectionControlsToolbar({
    required this.clipboardStatus,
    required this.delegate,
    required this.endpoints,
    required this.globalEditableRegion,
    required this.handleCut,
    required this.handleCopy,
    required this.handlePaste,
    required this.handleSelectAll,
    required this.selectionMidpoint,
    required this.textLineHeight,
  });

  final ValueListenable<ClipboardStatus>? clipboardStatus;
  final TextSelectionDelegate delegate;
  final List<TextSelectionPoint> endpoints;
  final Rect globalEditableRegion;
  final VoidCallback? handleCut;
  final VoidCallback? handleCopy;
  final VoidCallback? handlePaste;
  final VoidCallback? handleSelectAll;
  final Offset selectionMidpoint;
  final double textLineHeight;

  @override
  _TextSelectionControlsToolbarState createState() => _TextSelectionControlsToolbarState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ValueListenable<ClipboardStatus>?>('clipboardStatus', clipboardStatus));
    properties.add(DiagnosticsProperty<TextSelectionDelegate>('delegate', delegate));
    properties.add(IterableProperty<TextSelectionPoint>('endpoints', endpoints));
    properties.add(DiagnosticsProperty<Rect>('globalEditableRegion', globalEditableRegion));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('handleCut', handleCut));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('handleCopy', handleCopy));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('handlePaste', handlePaste));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('handleSelectAll', handleSelectAll));
    properties.add(DiagnosticsProperty<Offset>('selectionMidpoint', selectionMidpoint));
    properties.add(DoubleProperty('textLineHeight', textLineHeight));
  }
}

class _TextSelectionControlsToolbarState extends State<_TextSelectionControlsToolbar> with TickerProviderStateMixin {
  void _onChangedClipboardStatus() {
    setState(() {
      // Inform the widget that the value of clipboardStatus has changed.
    });
  }

  @override
  void initState() {
    super.initState();
    widget.clipboardStatus?.addListener(_onChangedClipboardStatus);
  }

  @override
  void didUpdateWidget(_TextSelectionControlsToolbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.clipboardStatus != oldWidget.clipboardStatus) {
      widget.clipboardStatus?.addListener(_onChangedClipboardStatus);
      oldWidget.clipboardStatus?.removeListener(_onChangedClipboardStatus);
    }
  }

  @override
  void dispose() {
    widget.clipboardStatus?.removeListener(_onChangedClipboardStatus);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If there are no buttons to be shown, don't render anything.
    if (widget.handleCut == null &&
        widget.handleCopy == null &&
        widget.handlePaste == null &&
        widget.handleSelectAll == null) {
      return const SizedBox.shrink();
    }
    // If the paste button is desired, don't render anything until the state of
    // the clipboard is known, since it's used to determine if paste is shown.
    if (widget.handlePaste != null && widget.clipboardStatus?.value == ClipboardStatus.unknown) {
      return const SizedBox.shrink();
    }

    // Calculate the positioning of the menu. It is placed above the selection
    // if there is enough room, or otherwise below.
    final TextSelectionPoint startTextSelectionPoint = widget.endpoints[0];
    final TextSelectionPoint endTextSelectionPoint =
        widget.endpoints.length > 1 ? widget.endpoints[1] : widget.endpoints[0];
    final double topAmountInEditableRegion = startTextSelectionPoint.point.dy - widget.textLineHeight;
    final double anchorTop =
        math.max(topAmountInEditableRegion, 0) + widget.globalEditableRegion.top - _kToolbarContentDistance;

    final Offset anchorAbove = Offset(widget.globalEditableRegion.left + widget.selectionMidpoint.dx, anchorTop);
    final Offset anchorBelow = Offset(
      widget.globalEditableRegion.left + widget.selectionMidpoint.dx,
      widget.globalEditableRegion.top + endTextSelectionPoint.point.dy + _kToolbarContentDistanceBelow,
    );

    // Determine which buttons will appear so that the order and total number is
    // known. A button's position in the menu can slightly affect its
    // appearance.
    assert(debugCheckHasMaterialLocalizations(context));
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final List<_TextSelectionToolbarItemData> itemDatas = <_TextSelectionToolbarItemData>[
      if (widget.handleCut != null)
        _TextSelectionToolbarItemData(label: localizations.cutButtonLabel, onPressed: widget.handleCut!),
      if (widget.handleCopy != null)
        _TextSelectionToolbarItemData(label: localizations.copyButtonLabel, onPressed: widget.handleCopy!),
      if (widget.handlePaste != null && widget.clipboardStatus?.value == ClipboardStatus.pasteable)
        _TextSelectionToolbarItemData(label: localizations.pasteButtonLabel, onPressed: widget.handlePaste!),
      if (widget.handleSelectAll != null)
        _TextSelectionToolbarItemData(label: localizations.selectAllButtonLabel, onPressed: widget.handleSelectAll!),
    ];

    // If there is no option available, build an empty widget.
    if (itemDatas.isEmpty) {
      return const SizedBox.shrink();
    }

    return TextSelectionToolbar(
      anchorAbove: anchorAbove,
      anchorBelow: anchorBelow,
      children:
          itemDatas
              .asMap()
              .entries
              .map(
                (entry) => TextSelectionToolbarTextButton(
                  padding: TextSelectionToolbarTextButton.getPadding(entry.key, itemDatas.length),
                  alignment: AlignmentDirectional.centerStart,
                  onPressed: entry.value.onPressed,
                  child: Text(entry.value.label),
                ),
              )
              .toList(),
    );
  }
}

class _TextSelectionHandlePainter extends CustomPainter {
  _TextSelectionHandlePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;
    final double radius = size.width / 2.0;
    final Rect circle = Rect.fromCircle(center: Offset(radius, radius), radius: radius);
    final Rect point = Rect.fromLTWH(0.0, 0.0, radius, radius);
    final Path path =
        Path()
          ..addOval(circle)
          ..addRect(point);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_TextSelectionHandlePainter oldPainter) => color != oldPainter.color;
}

// TODO(justinmc): Deprecate this after TextSelectionControls.buildToolbar is
// deleted, when users should migrate back to materialTextSelectionControls.
// See https://github.com/flutter/flutter/pull/124262

final TextSelectionControls materialTextSelectionHandleControls = MaterialTextSelectionHandleControls();

final TextSelectionControls materialTextSelectionControls = MaterialTextSelectionControls();
