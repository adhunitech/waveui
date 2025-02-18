// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/material.dart';
import 'package:waveui/material/text_selection_toolbar.dart';

// These values were measured from a screenshot of TextEdit on macOS 10.15.7 on
// a Macbook Pro.
const double _kToolbarScreenPadding = 8.0;
const double _kToolbarWidth = 222.0;

class DesktopTextSelectionToolbar extends StatelessWidget {
  const DesktopTextSelectionToolbar({required this.anchor, required this.children, super.key})
    : assert(children.length > 0);

  final Offset anchor;

  final List<Widget> children;

  // Builds a desktop toolbar in the Material style.
  static Widget _defaultToolbarBuilder(BuildContext context, Widget child) => SizedBox(
    width: _kToolbarWidth,
    child: Material(
      borderRadius: const BorderRadius.all(Radius.circular(7.0)),
      clipBehavior: Clip.antiAlias,
      elevation: 1.0,
      type: MaterialType.card,
      child: child,
    ),
  );

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));

    final double paddingAbove = MediaQuery.paddingOf(context).top + _kToolbarScreenPadding;
    final Offset localAdjustment = Offset(_kToolbarScreenPadding, paddingAbove);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        _kToolbarScreenPadding,
        paddingAbove,
        _kToolbarScreenPadding,
        _kToolbarScreenPadding,
      ),
      child: CustomSingleChildLayout(
        delegate: DesktopTextSelectionToolbarLayoutDelegate(anchor: anchor - localAdjustment),
        child: _defaultToolbarBuilder(context, Column(mainAxisSize: MainAxisSize.min, children: children)),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Offset>('anchor', anchor));
  }
}
