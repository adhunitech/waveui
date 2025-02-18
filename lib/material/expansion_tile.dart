// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/color_scheme.dart';
import 'package:waveui/material/colors.dart';
import 'package:waveui/material/expansion_tile_theme.dart';
import 'package:waveui/material/icons.dart';
import 'package:waveui/material/list_tile.dart';
import 'package:waveui/material/list_tile_theme.dart';
import 'package:waveui/material/material.dart';
import 'package:waveui/material/material_localizations.dart';
import 'package:waveui/material/theme.dart';
import 'package:waveui/material/theme_data.dart';

const Duration _kExpand = Duration(milliseconds: 200);

class ExpansionTileController {
  ExpansionTileController();

  _ExpansionTileState? _state;

  bool get isExpanded {
    assert(_state != null);
    return _state!._isExpanded;
  }

  void expand() {
    assert(_state != null);
    if (!isExpanded) {
      _state!._toggleExpansion();
    }
  }

  void collapse() {
    assert(_state != null);
    if (isExpanded) {
      _state!._toggleExpansion();
    }
  }

  static ExpansionTileController of(BuildContext context) {
    final _ExpansionTileState? result = context.findAncestorStateOfType<_ExpansionTileState>();
    if (result != null) {
      return result._tileController;
    }
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary('ExpansionTileController.of() called with a context that does not contain a ExpansionTile.'),
      ErrorDescription(
        'No ExpansionTile ancestor could be found starting from the context that was passed to ExpansionTileController.of(). '
        'This usually happens when the context provided is from the same StatefulWidget as that '
        'whose build function actually creates the ExpansionTile widget being sought.',
      ),
      ErrorHint(
        'There are several ways to avoid this problem. The simplest is to use a Builder to get a '
        'context that is "under" the ExpansionTile. For an example of this, please see the '
        'documentation for ExpansionTileController.of():\n'
        '  https://api.flutter.dev/flutter/material/ExpansionTile/of.html',
      ),
      ErrorHint(
        'A more efficient solution is to split your build function into several widgets. This '
        'introduces a new context from which you can obtain the ExpansionTile. In this solution, '
        'you would have an outer widget that creates the ExpansionTile populated by instances of '
        'your new inner widgets, and then in these inner widgets you would use ExpansionTileController.of().\n'
        'An other solution is assign a GlobalKey to the ExpansionTile, '
        'then use the key.currentState property to obtain the ExpansionTile rather than '
        'using the ExpansionTileController.of() function.',
      ),
      context.describeElement('The context used was'),
    ]);
  }

  static ExpansionTileController? maybeOf(BuildContext context) =>
      context.findAncestorStateOfType<_ExpansionTileState>()?._tileController;
}

class ExpansionTile extends StatefulWidget {
  const ExpansionTile({
    required this.title,
    super.key,
    this.leading,
    this.subtitle,
    this.onExpansionChanged,
    this.children = const <Widget>[],
    this.trailing,
    this.showTrailingIcon = true,
    this.initiallyExpanded = false,
    this.maintainState = false,
    this.tilePadding,
    this.expandedCrossAxisAlignment,
    this.expandedAlignment,
    this.childrenPadding,
    this.backgroundColor,
    this.collapsedBackgroundColor,
    this.textColor,
    this.collapsedTextColor,
    this.iconColor,
    this.collapsedIconColor,
    this.shape,
    this.collapsedShape,
    this.clipBehavior,
    this.controlAffinity,
    this.controller,
    this.dense,
    this.visualDensity,
    this.minTileHeight,
    this.enableFeedback = true,
    this.enabled = true,
    this.expansionAnimationStyle,
    this.internalAddSemanticForOnTap = false,
  }) : assert(
         expandedCrossAxisAlignment != CrossAxisAlignment.baseline,
         'CrossAxisAlignment.baseline is not supported since the expanded children '
         'are aligned in a column, not a row. Try to use another constant.',
       );

  final Widget? leading;

  final Widget title;

  final Widget? subtitle;

  final ValueChanged<bool>? onExpansionChanged;

  final List<Widget> children;

  final Color? backgroundColor;

  final Color? collapsedBackgroundColor;

  final Widget? trailing;

  final bool showTrailingIcon;

  final bool initiallyExpanded;

  final bool maintainState;

  final EdgeInsetsGeometry? tilePadding;

  final Alignment? expandedAlignment;

  final CrossAxisAlignment? expandedCrossAxisAlignment;

  final EdgeInsetsGeometry? childrenPadding;

  final Color? iconColor;

  final Color? collapsedIconColor;

  final Color? textColor;

  final Color? collapsedTextColor;

  final ShapeBorder? shape;

  final ShapeBorder? collapsedShape;

  final Clip? clipBehavior;

  final ListTileControlAffinity? controlAffinity;

  final ExpansionTileController? controller;

  final bool? dense;

  final VisualDensity? visualDensity;

  final double? minTileHeight;

  final bool? enableFeedback;

  final bool enabled;

  final AnimationStyle? expansionAnimationStyle;

  // TODO(hangyujin): Remove this flag after fixing related g3 tests and flipping
  // the default value to true.
  final bool internalAddSemanticForOnTap;

  @override
  State<ExpansionTile> createState() => _ExpansionTileState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<ValueChanged<bool>?>.has('onExpansionChanged', onExpansionChanged));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(ColorProperty('collapsedBackgroundColor', collapsedBackgroundColor));
    properties.add(DiagnosticsProperty<bool>('showTrailingIcon', showTrailingIcon));
    properties.add(DiagnosticsProperty<bool>('initiallyExpanded', initiallyExpanded));
    properties.add(DiagnosticsProperty<bool>('maintainState', maintainState));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('tilePadding', tilePadding));
    properties.add(DiagnosticsProperty<Alignment?>('expandedAlignment', expandedAlignment));
    properties.add(EnumProperty<CrossAxisAlignment?>('expandedCrossAxisAlignment', expandedCrossAxisAlignment));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('childrenPadding', childrenPadding));
    properties.add(ColorProperty('iconColor', iconColor));
    properties.add(ColorProperty('collapsedIconColor', collapsedIconColor));
    properties.add(ColorProperty('textColor', textColor));
    properties.add(ColorProperty('collapsedTextColor', collapsedTextColor));
    properties.add(DiagnosticsProperty<ShapeBorder?>('shape', shape));
    properties.add(DiagnosticsProperty<ShapeBorder?>('collapsedShape', collapsedShape));
    properties.add(EnumProperty<Clip?>('clipBehavior', clipBehavior));
    properties.add(EnumProperty<ListTileControlAffinity?>('controlAffinity', controlAffinity));
    properties.add(DiagnosticsProperty<ExpansionTileController?>('controller', controller));
    properties.add(DiagnosticsProperty<bool?>('dense', dense));
    properties.add(DiagnosticsProperty<VisualDensity?>('visualDensity', visualDensity));
    properties.add(DoubleProperty('minTileHeight', minTileHeight));
    properties.add(DiagnosticsProperty<bool?>('enableFeedback', enableFeedback));
    properties.add(DiagnosticsProperty<bool>('enabled', enabled));
    properties.add(DiagnosticsProperty<AnimationStyle?>('expansionAnimationStyle', expansionAnimationStyle));
    properties.add(DiagnosticsProperty<bool>('internalAddSemanticForOnTap', internalAddSemanticForOnTap));
  }
}

class _ExpansionTileState extends State<ExpansionTile> with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeOutTween = CurveTween(curve: Curves.easeOut);
  static final Animatable<double> _easeInTween = CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween = Tween<double>(begin: 0.0, end: 0.5);

  final ShapeBorderTween _borderTween = ShapeBorderTween();
  final ColorTween _headerColorTween = ColorTween();
  final ColorTween _iconColorTween = ColorTween();
  final ColorTween _backgroundColorTween = ColorTween();
  final Tween<double> _heightFactorTween = Tween<double>(begin: 0.0, end: 1.0);

  late AnimationController _animationController;
  late Animation<double> _iconTurns;
  late CurvedAnimation _heightFactor;
  late Animation<ShapeBorder?> _border;
  late Animation<Color?> _headerColor;
  late Animation<Color?> _iconColor;
  late Animation<Color?> _backgroundColor;

  bool _isExpanded = false;
  late ExpansionTileController _tileController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = CurvedAnimation(parent: _animationController.drive(_heightFactorTween), curve: Curves.easeIn);
    _iconTurns = _animationController.drive(_halfTween.chain(_easeInTween));
    _border = _animationController.drive(_borderTween.chain(_easeOutTween));
    _headerColor = _animationController.drive(_headerColorTween.chain(_easeInTween));
    _iconColor = _animationController.drive(_iconColorTween.chain(_easeInTween));
    _backgroundColor = _animationController.drive(_backgroundColorTween.chain(_easeOutTween));

    _isExpanded = PageStorage.maybeOf(context)?.readState(context) as bool? ?? widget.initiallyExpanded;
    if (_isExpanded) {
      _animationController.value = 1.0;
    }

    assert(widget.controller?._state == null);
    _tileController = widget.controller ?? ExpansionTileController();
    _tileController._state = this;
  }

  @override
  void dispose() {
    _tileController._state = null;
    _animationController.dispose();
    _heightFactor.dispose();
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  void _toggleExpansion() {
    final TextDirection textDirection = WidgetsLocalizations.of(context).textDirection;
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final String stateHint = _isExpanded ? localizations.expandedHint : localizations.collapsedHint;
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse().then<void>((value) {
          if (!mounted) {
            return;
          }
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
      PageStorage.maybeOf(context)?.writeState(context, _isExpanded);
    });
    widget.onExpansionChanged?.call(_isExpanded);

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      // TODO(tahatesser): This is a workaround for VoiceOver interrupting
      // semantic announcements on iOS. https://github.com/flutter/flutter/issues/122101.
      _timer?.cancel();
      _timer = Timer(const Duration(seconds: 1), () {
        SemanticsService.announce(stateHint, textDirection);
        _timer?.cancel();
        _timer = null;
      });
    } else {
      SemanticsService.announce(stateHint, textDirection);
    }
  }

  void _handleTap() {
    _toggleExpansion();
  }

  // Platform or null affinity defaults to trailing.
  ListTileControlAffinity _effectiveAffinity() {
    final ListTileThemeData listTileTheme = ListTileTheme.of(context);
    final ListTileControlAffinity affinity =
        widget.controlAffinity ?? listTileTheme.controlAffinity ?? ListTileControlAffinity.trailing;
    switch (affinity) {
      case ListTileControlAffinity.leading:
        return ListTileControlAffinity.leading;
      case ListTileControlAffinity.trailing:
      case ListTileControlAffinity.platform:
        return ListTileControlAffinity.trailing;
    }
  }

  Widget? _buildIcon(BuildContext context) =>
      RotationTransition(turns: _iconTurns, child: const Icon(Icons.expand_more));

  Widget? _buildLeadingIcon(BuildContext context) {
    if (_effectiveAffinity() != ListTileControlAffinity.leading) {
      return null;
    }
    return _buildIcon(context);
  }

  Widget? _buildTrailingIcon(BuildContext context) {
    if (_effectiveAffinity() != ListTileControlAffinity.trailing) {
      return null;
    }
    return _buildIcon(context);
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    final ThemeData theme = Theme.of(context);
    final ExpansionTileThemeData expansionTileTheme = ExpansionTileTheme.of(context);
    final Color backgroundColor = _backgroundColor.value ?? expansionTileTheme.backgroundColor ?? Colors.transparent;
    final ShapeBorder expansionTileBorder =
        _border.value ??
        const Border(top: BorderSide(color: Colors.transparent), bottom: BorderSide(color: Colors.transparent));
    final Clip clipBehavior = widget.clipBehavior ?? expansionTileTheme.clipBehavior ?? Clip.antiAlias;
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final String onTapHint =
        _isExpanded ? localizations.expansionTileExpandedTapHint : localizations.expansionTileCollapsedTapHint;
    String? semanticsHint;
    switch (theme.platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        semanticsHint =
            _isExpanded
                ? '${localizations.collapsedHint}\n ${localizations.expansionTileExpandedHint}'
                : '${localizations.expandedHint}\n ${localizations.expansionTileCollapsedHint}';
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        break;
    }

    final Decoration decoration = ShapeDecoration(color: backgroundColor, shape: expansionTileBorder);

    final Widget tile = Padding(
      padding: decoration.padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Semantics(
            hint: semanticsHint,
            onTapHint: onTapHint,
            child: ListTileTheme.merge(
              iconColor: _iconColor.value ?? expansionTileTheme.iconColor,
              textColor: _headerColor.value,
              child: ListTile(
                enabled: widget.enabled,
                onTap: _handleTap,
                dense: widget.dense,
                visualDensity: widget.visualDensity,
                enableFeedback: widget.enableFeedback,
                contentPadding: widget.tilePadding ?? expansionTileTheme.tilePadding,
                leading: widget.leading ?? _buildLeadingIcon(context),
                title: widget.title,
                subtitle: widget.subtitle,
                trailing: widget.showTrailingIcon ? widget.trailing ?? _buildTrailingIcon(context) : null,
                minTileHeight: widget.minTileHeight,
                internalAddSemanticForOnTap: widget.internalAddSemanticForOnTap,
              ),
            ),
          ),
          ClipRect(
            child: Align(
              alignment: widget.expandedAlignment ?? expansionTileTheme.expandedAlignment ?? Alignment.center,
              heightFactor: _heightFactor.value,
              child: child,
            ),
          ),
        ],
      ),
    );

    final bool isShapeProvided =
        widget.shape != null ||
        expansionTileTheme.shape != null ||
        widget.collapsedShape != null ||
        expansionTileTheme.collapsedShape != null;

    if (isShapeProvided) {
      return Material(clipBehavior: clipBehavior, color: backgroundColor, shape: expansionTileBorder, child: tile);
    }

    return DecoratedBox(decoration: decoration, child: tile);
  }

  @override
  void didUpdateWidget(covariant ExpansionTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    final ThemeData theme = Theme.of(context);
    final ExpansionTileThemeData expansionTileTheme = ExpansionTileTheme.of(context);
    final ExpansionTileThemeData defaults = _ExpansionTileDefaultsM3(context);
    if (widget.collapsedShape != oldWidget.collapsedShape || widget.shape != oldWidget.shape) {
      _updateShapeBorder(expansionTileTheme, theme);
    }
    if (widget.collapsedTextColor != oldWidget.collapsedTextColor || widget.textColor != oldWidget.textColor) {
      _updateHeaderColor(expansionTileTheme, defaults);
    }
    if (widget.collapsedIconColor != oldWidget.collapsedIconColor || widget.iconColor != oldWidget.iconColor) {
      _updateIconColor(expansionTileTheme, defaults);
    }
    if (widget.backgroundColor != oldWidget.backgroundColor ||
        widget.collapsedBackgroundColor != oldWidget.collapsedBackgroundColor) {
      _updateBackgroundColor(expansionTileTheme);
    }
    if (widget.expansionAnimationStyle != oldWidget.expansionAnimationStyle) {
      _updateAnimationDuration(expansionTileTheme);
      _updateHeightFactorCurve(expansionTileTheme);
    }
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    final ExpansionTileThemeData expansionTileTheme = ExpansionTileTheme.of(context);
    final ExpansionTileThemeData defaults = _ExpansionTileDefaultsM3(context);
    _updateAnimationDuration(expansionTileTheme);
    _updateShapeBorder(expansionTileTheme, theme);
    _updateHeaderColor(expansionTileTheme, defaults);
    _updateIconColor(expansionTileTheme, defaults);
    _updateBackgroundColor(expansionTileTheme);
    _updateHeightFactorCurve(expansionTileTheme);
    super.didChangeDependencies();
  }

  void _updateAnimationDuration(ExpansionTileThemeData expansionTileTheme) {
    _animationController.duration =
        widget.expansionAnimationStyle?.duration ?? expansionTileTheme.expansionAnimationStyle?.duration ?? _kExpand;
  }

  void _updateShapeBorder(ExpansionTileThemeData expansionTileTheme, ThemeData theme) {
    _borderTween
      ..begin =
          widget.collapsedShape ??
          expansionTileTheme.collapsedShape ??
          const Border(top: BorderSide(color: Colors.transparent), bottom: BorderSide(color: Colors.transparent))
      ..end =
          widget.shape ??
          expansionTileTheme.shape ??
          Border(top: BorderSide(color: theme.dividerColor), bottom: BorderSide(color: theme.dividerColor));
  }

  void _updateHeaderColor(ExpansionTileThemeData expansionTileTheme, ExpansionTileThemeData defaults) {
    _headerColorTween
      ..begin = widget.collapsedTextColor ?? expansionTileTheme.collapsedTextColor ?? defaults.collapsedTextColor
      ..end = widget.textColor ?? expansionTileTheme.textColor ?? defaults.textColor;
  }

  void _updateIconColor(ExpansionTileThemeData expansionTileTheme, ExpansionTileThemeData defaults) {
    _iconColorTween
      ..begin = widget.collapsedIconColor ?? expansionTileTheme.collapsedIconColor ?? defaults.collapsedIconColor
      ..end = widget.iconColor ?? expansionTileTheme.iconColor ?? defaults.iconColor;
  }

  void _updateBackgroundColor(ExpansionTileThemeData expansionTileTheme) {
    _backgroundColorTween
      ..begin = widget.collapsedBackgroundColor ?? expansionTileTheme.collapsedBackgroundColor
      ..end = widget.backgroundColor ?? expansionTileTheme.backgroundColor;
  }

  void _updateHeightFactorCurve(ExpansionTileThemeData expansionTileTheme) {
    _heightFactor.curve =
        widget.expansionAnimationStyle?.curve ?? expansionTileTheme.expansionAnimationStyle?.curve ?? Curves.easeIn;
    _heightFactor.reverseCurve =
        widget.expansionAnimationStyle?.reverseCurve ?? expansionTileTheme.expansionAnimationStyle?.reverseCurve;
  }

  @override
  Widget build(BuildContext context) {
    final ExpansionTileThemeData expansionTileTheme = ExpansionTileTheme.of(context);
    final bool closed = !_isExpanded && _animationController.isDismissed;
    final bool shouldRemoveChildren = closed && !widget.maintainState;

    final Widget result = Offstage(
      offstage: closed,
      child: TickerMode(
        enabled: !closed,
        child: Padding(
          padding: widget.childrenPadding ?? expansionTileTheme.childrenPadding ?? EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: widget.expandedCrossAxisAlignment ?? CrossAxisAlignment.center,
            children: widget.children,
          ),
        ),
      ),
    );

    return AnimatedBuilder(
      animation: _animationController.view,
      builder: _buildChildren,
      child: shouldRemoveChildren ? null : result,
    );
  }
}
// BEGIN GENERATED TOKEN PROPERTIES - ExpansionTile

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// dart format off
class _ExpansionTileDefaultsM3 extends ExpansionTileThemeData {
  _ExpansionTileDefaultsM3(this.context);

  final BuildContext context;
  late final ThemeData _theme = Theme.of(context);
  late final ColorScheme _colors = _theme.colorScheme;

  @override
  Color? get textColor => _colors.onSurface;

  @override
  Color? get iconColor => _colors.primary;

  @override
  Color? get collapsedTextColor => _colors.onSurface;

  @override
  Color? get collapsedIconColor => _colors.onSurfaceVariant;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BuildContext>('context', context));
  }
}
// dart format on

// END GENERATED TOKEN PROPERTIES - ExpansionTile
