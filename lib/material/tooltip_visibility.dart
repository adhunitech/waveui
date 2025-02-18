// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class _TooltipVisibilityScope extends InheritedWidget {
  const _TooltipVisibilityScope({required super.child, required this.visible});

  final bool visible;

  @override
  bool updateShouldNotify(_TooltipVisibilityScope old) => old.visible != visible;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('visible', visible));
  }
}

class TooltipVisibility extends StatelessWidget {
  const TooltipVisibility({required this.visible, required this.child, super.key});

  final Widget child;

  final bool visible;

  static bool of(BuildContext context) {
    final _TooltipVisibilityScope? visibility = context.dependOnInheritedWidgetOfExactType<_TooltipVisibilityScope>();
    return visibility?.visible ?? true;
  }

  @override
  Widget build(BuildContext context) => _TooltipVisibilityScope(visible: visible, child: child);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('visible', visible));
  }
}
