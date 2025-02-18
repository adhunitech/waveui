// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:waveui/material/theme.dart' show ThemeData;
import 'package:waveui/material/theme_data.dart' show ThemeData;

import 'package:waveui/material/colors.dart';
import 'package:waveui/material/debug.dart';
import 'package:waveui/material/icon_button.dart';
import 'package:waveui/material/icons.dart';
import 'package:waveui/material/material_localizations.dart';
import 'package:waveui/material/theme.dart';
import 'package:waveui/waveui.dart' show ThemeData;

class ExpandIcon extends StatefulWidget {
  const ExpandIcon({
    required this.onPressed,
    super.key,
    this.isExpanded = false,
    this.size = 24.0,
    this.padding = const EdgeInsets.all(8.0),
    this.color,
    this.disabledColor,
    this.expandedColor,
    this.splashColor,
    this.highlightColor,
  });

  final bool isExpanded;

  final double size;

  final ValueChanged<bool>? onPressed;

  final EdgeInsetsGeometry padding;

  final Color? color;

  final Color? disabledColor;

  final Color? expandedColor;

  final Color? splashColor;

  final Color? highlightColor;

  @override
  State<ExpandIcon> createState() => _ExpandIconState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('isExpanded', isExpanded));
    properties.add(DoubleProperty('size', size));
    properties.add(ObjectFlagProperty<ValueChanged<bool>?>.has('onPressed', onPressed));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding));
    properties.add(ColorProperty('color', color));
    properties.add(ColorProperty('disabledColor', disabledColor));
    properties.add(ColorProperty('expandedColor', expandedColor));
    properties.add(ColorProperty('splashColor', splashColor));
    properties.add(ColorProperty('highlightColor', highlightColor));
  }
}

class _ExpandIconState extends State<ExpandIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconTurns;

  static final Animatable<double> _iconTurnTween = Tween<double>(
    begin: 0.0,
    end: 0.5,
  ).chain(CurveTween(curve: Curves.fastOutSlowIn));

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: kThemeAnimationDuration, vsync: this);
    _iconTurns = _controller.drive(_iconTurnTween);
    // If the widget is initially expanded, rotate the icon without animating it.
    if (widget.isExpanded) {
      _controller.value = math.pi;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ExpandIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  void _handlePressed() {
    widget.onPressed?.call(widget.isExpanded);
  }

  Color get _iconColor {
    if (widget.isExpanded && widget.expandedColor != null) {
      return widget.expandedColor!;
    }

    if (widget.color != null) {
      return widget.color!;
    }

    return switch (Theme.of(context).brightness) {
      Brightness.light => Colors.black54,
      Brightness.dark => Colors.white60,
    };
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMaterialLocalizations(context));
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final String onTapHint = widget.isExpanded ? localizations.expandedIconTapHint : localizations.collapsedIconTapHint;

    return Semantics(
      onTapHint: widget.onPressed == null ? null : onTapHint,
      child: IconButton(
        padding: widget.padding,
        iconSize: widget.size,
        highlightColor: widget.highlightColor,
        splashColor: widget.splashColor,
        color: _iconColor,
        disabledColor: widget.disabledColor,
        onPressed: widget.onPressed == null ? null : _handlePressed,
        icon: RotationTransition(turns: _iconTurns, child: const Icon(Icons.expand_more)),
      ),
    );
  }
}
