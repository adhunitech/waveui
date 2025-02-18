// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/debug.dart';
import 'package:waveui/material/divider.dart';
import 'package:waveui/material/theme.dart';

const double _kDrawerHeaderHeight = 160.0 + 1.0; // bottom edge

class DrawerHeader extends StatelessWidget {
  const DrawerHeader({
    required this.child,
    super.key,
    this.decoration,
    this.margin = const EdgeInsets.only(bottom: 8.0),
    this.padding = const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
    this.duration = const Duration(milliseconds: 250),
    this.curve = Curves.fastOutSlowIn,
  });

  final Decoration? decoration;

  final EdgeInsetsGeometry padding;

  final EdgeInsetsGeometry? margin;

  final Duration duration;

  final Curve curve;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMediaQuery(context));
    final ThemeData theme = Theme.of(context);
    final double statusBarHeight = MediaQuery.paddingOf(context).top;
    return Container(
      height: statusBarHeight + _kDrawerHeaderHeight,
      margin: margin,
      decoration: BoxDecoration(border: Border(bottom: Divider.createBorderSide(context))),
      child: AnimatedContainer(
        padding: padding.add(EdgeInsets.only(top: statusBarHeight)),
        decoration: decoration,
        duration: duration,
        curve: curve,
        child:
            child == null
                ? null
                : DefaultTextStyle(
                  style: theme.textTheme.bodyLarge!,
                  child: MediaQuery.removePadding(context: context, removeTop: true, child: child!),
                ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Decoration?>('decoration', decoration));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('margin', margin));
    properties.add(DiagnosticsProperty<Duration>('duration', duration));
    properties.add(DiagnosticsProperty<Curve>('curve', curve));
  }
}
