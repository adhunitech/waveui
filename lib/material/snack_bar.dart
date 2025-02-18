// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/color_scheme.dart';
import 'package:waveui/material/colors.dart';
import 'package:waveui/material/icon_button.dart';
import 'package:waveui/material/icons.dart';
import 'package:waveui/material/material.dart';
import 'package:waveui/material/material_localizations.dart';
import 'package:waveui/material/scaffold.dart';
import 'package:waveui/material/snack_bar_theme.dart';
import 'package:waveui/material/text_button.dart';
import 'package:waveui/material/text_button_theme.dart';
import 'package:waveui/material/theme.dart';

// Examples can assume:
// late BuildContext context;

const double _singleLineVerticalPadding = 14.0;
const Duration _snackBarTransitionDuration = Duration(milliseconds: 250);
const Duration _snackBarDisplayDuration = Duration(milliseconds: 4000);
const Curve _snackBarHeightCurve = Curves.fastOutSlowIn;
const Curve _snackBarM3HeightCurve = Curves.easeInOutQuart;

const Curve _snackBarFadeInCurve = Interval(0.4, 1.0);
const Curve _snackBarM3FadeInCurve = Interval(0.4, 0.6, curve: Curves.easeInCirc);
const Curve _snackBarFadeOutCurve = Interval(0.72, 1.0, curve: Curves.fastOutSlowIn);

enum SnackBarClosedReason { action, dismiss, swipe, hide, remove, timeout }

class SnackBarAction extends StatefulWidget {
  const SnackBarAction({
    required this.label,
    required this.onPressed,
    super.key,
    this.textColor,
    this.disabledTextColor,
    this.backgroundColor,
    this.disabledBackgroundColor,
  }) : assert(
         backgroundColor is! WidgetStateColor || disabledBackgroundColor == null,
         'disabledBackgroundColor must not be provided when background color is '
         'a WidgetStateColor',
       );

  final Color? textColor;

  final Color? backgroundColor;

  final Color? disabledTextColor;

  final Color? disabledBackgroundColor;

  final String label;

  final VoidCallback onPressed;

  @override
  State<SnackBarAction> createState() => _SnackBarActionState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('textColor', textColor));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(ColorProperty('disabledTextColor', disabledTextColor));
    properties.add(ColorProperty('disabledBackgroundColor', disabledBackgroundColor));
    properties.add(StringProperty('label', label));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onPressed', onPressed));
  }
}

class _SnackBarActionState extends State<SnackBarAction> {
  bool _haveTriggeredAction = false;

  void _handlePressed() {
    if (_haveTriggeredAction) {
      return;
    }
    setState(() {
      _haveTriggeredAction = true;
    });
    widget.onPressed();
    ScaffoldMessenger.of(context).hideCurrentSnackBar(reason: SnackBarClosedReason.action);
  }

  @override
  Widget build(BuildContext context) {
    final SnackBarThemeData defaults = _SnackbarDefaultsM3(context);
    final SnackBarThemeData snackBarTheme = Theme.of(context).snackBarTheme;

    WidgetStateColor resolveForegroundColor() {
      if (widget.textColor != null) {
        if (widget.textColor is WidgetStateColor) {
          return widget.textColor! as WidgetStateColor;
        }
      } else if (snackBarTheme.actionTextColor != null) {
        if (snackBarTheme.actionTextColor is WidgetStateColor) {
          return snackBarTheme.actionTextColor! as WidgetStateColor;
        }
      } else if (defaults.actionTextColor != null) {
        if (defaults.actionTextColor is WidgetStateColor) {
          return defaults.actionTextColor! as WidgetStateColor;
        }
      }

      return WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return widget.disabledTextColor ?? snackBarTheme.disabledActionTextColor ?? defaults.disabledActionTextColor!;
        }
        return widget.textColor ?? snackBarTheme.actionTextColor ?? defaults.actionTextColor!;
      });
    }

    WidgetStateColor? resolveBackgroundColor() {
      if (widget.backgroundColor is WidgetStateColor) {
        return widget.backgroundColor! as WidgetStateColor;
      }
      if (snackBarTheme.actionBackgroundColor is WidgetStateColor) {
        return snackBarTheme.actionBackgroundColor! as WidgetStateColor;
      }
      return WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return widget.disabledBackgroundColor ?? snackBarTheme.disabledActionBackgroundColor ?? Colors.transparent;
        }
        return widget.backgroundColor ?? snackBarTheme.actionBackgroundColor ?? Colors.transparent;
      });
    }

    return TextButton(
      style: TextButton.styleFrom(
        overlayColor: resolveForegroundColor(),
      ).copyWith(foregroundColor: resolveForegroundColor(), backgroundColor: resolveBackgroundColor()),
      onPressed: _haveTriggeredAction ? null : _handlePressed,
      child: Text(widget.label),
    );
  }
}

class SnackBar extends StatefulWidget {
  const SnackBar({
    required this.content,
    super.key,
    this.backgroundColor,
    this.elevation,
    this.margin,
    this.padding,
    this.width,
    this.shape,
    this.hitTestBehavior,
    this.behavior,
    this.action,
    this.actionOverflowThreshold,
    this.showCloseIcon,
    this.closeIconColor,
    this.duration = _snackBarDisplayDuration,
    this.animation,
    this.onVisible,
    this.dismissDirection,
    this.clipBehavior = Clip.hardEdge,
  }) : assert(elevation == null || elevation >= 0.0),
       assert(width == null || margin == null, 'Width and margin can not be used together'),
       assert(
         actionOverflowThreshold == null || (actionOverflowThreshold >= 0 && actionOverflowThreshold <= 1),
         'Action overflow threshold must be between 0 and 1 inclusive',
       );

  final Widget content;

  final Color? backgroundColor;

  final double? elevation;

  final EdgeInsetsGeometry? margin;

  final EdgeInsetsGeometry? padding;

  final double? width;

  final ShapeBorder? shape;

  final HitTestBehavior? hitTestBehavior;

  final SnackBarBehavior? behavior;

  final SnackBarAction? action;

  final double? actionOverflowThreshold;

  final bool? showCloseIcon;

  final Color? closeIconColor;

  final Duration duration;

  final Animation<double>? animation;

  final VoidCallback? onVisible;

  final DismissDirection? dismissDirection;

  final Clip clipBehavior;

  // API for ScaffoldMessengerState.showSnackBar():

  static AnimationController createAnimationController({
    required TickerProvider vsync,
    Duration? duration,
    Duration? reverseDuration,
  }) => AnimationController(
    duration: duration ?? _snackBarTransitionDuration,
    reverseDuration: reverseDuration,
    debugLabel: 'SnackBar',
    vsync: vsync,
  );

  SnackBar withAnimation(Animation<double> newAnimation, {Key? fallbackKey}) => SnackBar(
    key: key ?? fallbackKey,
    content: content,
    backgroundColor: backgroundColor,
    elevation: elevation,
    margin: margin,
    padding: padding,
    width: width,
    shape: shape,
    hitTestBehavior: hitTestBehavior,
    behavior: behavior,
    action: action,
    actionOverflowThreshold: actionOverflowThreshold,
    showCloseIcon: showCloseIcon,
    closeIconColor: closeIconColor,
    duration: duration,
    animation: newAnimation,
    onVisible: onVisible,
    dismissDirection: dismissDirection,
    clipBehavior: clipBehavior,
  );

  @override
  State<SnackBar> createState() => _SnackBarState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(DoubleProperty('elevation', elevation));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('margin', margin));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('padding', padding));
    properties.add(DoubleProperty('width', width));
    properties.add(DiagnosticsProperty<ShapeBorder?>('shape', shape));
    properties.add(EnumProperty<HitTestBehavior?>('hitTestBehavior', hitTestBehavior));
    properties.add(EnumProperty<SnackBarBehavior?>('behavior', behavior));
    properties.add(DoubleProperty('actionOverflowThreshold', actionOverflowThreshold));
    properties.add(DiagnosticsProperty<bool?>('showCloseIcon', showCloseIcon));
    properties.add(ColorProperty('closeIconColor', closeIconColor));
    properties.add(DiagnosticsProperty<Duration>('duration', duration));
    properties.add(DiagnosticsProperty<Animation<double>?>('animation', animation));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onVisible', onVisible));
    properties.add(EnumProperty<DismissDirection?>('dismissDirection', dismissDirection));
    properties.add(EnumProperty<Clip>('clipBehavior', clipBehavior));
  }
}

class _SnackBarState extends State<SnackBar> {
  bool _wasVisible = false;

  CurvedAnimation? _heightAnimation;
  CurvedAnimation? _fadeInAnimation;
  CurvedAnimation? _fadeInM3Animation;
  CurvedAnimation? _fadeOutAnimation;
  CurvedAnimation? _heightM3Animation;

  @override
  void initState() {
    super.initState();
    widget.animation!.addStatusListener(_onAnimationStatusChanged);
    _setAnimations();
  }

  @override
  void didUpdateWidget(SnackBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animation != oldWidget.animation) {
      oldWidget.animation!.removeStatusListener(_onAnimationStatusChanged);
      widget.animation!.addStatusListener(_onAnimationStatusChanged);
      _disposeAnimations();
      _setAnimations();
    }
  }

  void _setAnimations() {
    assert(widget.animation != null);
    _heightAnimation = CurvedAnimation(parent: widget.animation!, curve: _snackBarHeightCurve);
    _fadeInAnimation = CurvedAnimation(parent: widget.animation!, curve: _snackBarFadeInCurve);
    _fadeInM3Animation = CurvedAnimation(parent: widget.animation!, curve: _snackBarM3FadeInCurve);
    _fadeOutAnimation = CurvedAnimation(
      parent: widget.animation!,
      curve: _snackBarFadeOutCurve,
      reverseCurve: const Threshold(0.0),
    );
    // Material 3 Animation has a height animation on entry, but a direct fade out on exit.
    _heightM3Animation = CurvedAnimation(
      parent: widget.animation!,
      curve: _snackBarM3HeightCurve,
      reverseCurve: const Threshold(0.0),
    );
  }

  void _disposeAnimations() {
    _heightAnimation?.dispose();
    _fadeInAnimation?.dispose();
    _fadeInM3Animation?.dispose();
    _fadeOutAnimation?.dispose();
    _heightM3Animation?.dispose();
    _heightAnimation = null;
    _fadeInAnimation = null;
    _fadeInM3Animation = null;
    _fadeOutAnimation = null;
    _heightM3Animation = null;
  }

  @override
  void dispose() {
    widget.animation!.removeStatusListener(_onAnimationStatusChanged);
    _disposeAnimations();
    super.dispose();
  }

  void _onAnimationStatusChanged(AnimationStatus animationStatus) {
    if (animationStatus.isCompleted) {
      if (widget.onVisible != null && !_wasVisible) {
        widget.onVisible!();
      }
      _wasVisible = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    final bool accessibleNavigation = MediaQuery.accessibleNavigationOf(context);
    assert(widget.animation != null);
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final SnackBarThemeData snackBarTheme = theme.snackBarTheme;
    final bool isThemeDark = theme.brightness == Brightness.dark;
    final Color buttonColor = isThemeDark ? colorScheme.primary : colorScheme.secondary;
    final SnackBarThemeData defaults = _SnackbarDefaultsM3(context);

    // Invert the theme values for Material 2. Material 3 values are tokenized to pre-inverted values.
    final ThemeData effectiveTheme = theme;

    final TextStyle? contentTextStyle = snackBarTheme.contentTextStyle ?? defaults.contentTextStyle;
    final SnackBarBehavior snackBarBehavior = widget.behavior ?? snackBarTheme.behavior ?? defaults.behavior!;
    final double? width = widget.width ?? snackBarTheme.width;
    assert(() {
      // Whether the behavior is set through the constructor or the theme,
      // assert that other properties are configured properly.
      if (snackBarBehavior != SnackBarBehavior.floating) {
        String message(String parameter) {
          final String prefix = '$parameter can only be used with floating behavior.';
          if (widget.behavior != null) {
            return '$prefix SnackBarBehavior.fixed was set in the SnackBar constructor.';
          } else if (snackBarTheme.behavior != null) {
            return '$prefix SnackBarBehavior.fixed was set by the inherited SnackBarThemeData.';
          } else {
            return '$prefix SnackBarBehavior.fixed was set by default.';
          }
        }

        assert(widget.margin == null, message('Margin'));
        assert(width == null, message('Width'));
      }
      return true;
    }());

    final bool showCloseIcon = widget.showCloseIcon ?? snackBarTheme.showCloseIcon ?? defaults.showCloseIcon!;

    final bool isFloatingSnackBar = snackBarBehavior == SnackBarBehavior.floating;
    final double horizontalPadding = isFloatingSnackBar ? 16.0 : 24.0;
    final EdgeInsetsGeometry padding =
        widget.padding ??
        EdgeInsetsDirectional.only(
          start: horizontalPadding,
          end: widget.action != null || showCloseIcon ? 0 : horizontalPadding,
        );

    final double actionHorizontalMargin = (widget.padding?.resolve(TextDirection.ltr).right ?? horizontalPadding) / 2;
    final double iconHorizontalMargin = (widget.padding?.resolve(TextDirection.ltr).right ?? horizontalPadding) / 12.0;

    final IconButton? iconButton =
        showCloseIcon
            ? IconButton(
              key: StandardComponentType.closeButton.key,
              icon: const Icon(Icons.close),
              iconSize: 24.0,
              color: widget.closeIconColor ?? snackBarTheme.closeIconColor ?? defaults.closeIconColor,
              onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(reason: SnackBarClosedReason.dismiss),
              tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
            )
            : null;

    // Calculate combined width of Action, Icon, and their padding, if they are present.
    final TextPainter actionTextPainter = TextPainter(
      text: TextSpan(text: widget.action?.label ?? '', style: Theme.of(context).textTheme.labelLarge),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    final double actionAndIconWidth =
        actionTextPainter.size.width +
        (widget.action != null ? actionHorizontalMargin : 0) +
        (showCloseIcon ? (iconButton?.iconSize ?? 0 + iconHorizontalMargin) : 0);
    actionTextPainter.dispose();

    final EdgeInsets margin =
        widget.margin?.resolve(TextDirection.ltr) ?? snackBarTheme.insetPadding ?? defaults.insetPadding!;

    final double snackBarWidth = widget.width ?? MediaQuery.sizeOf(context).width - (margin.left + margin.right);
    final double actionOverflowThreshold =
        widget.actionOverflowThreshold ?? snackBarTheme.actionOverflowThreshold ?? defaults.actionOverflowThreshold!;

    final bool willOverflowAction = actionAndIconWidth / snackBarWidth > actionOverflowThreshold;

    final List<Widget> maybeActionAndIcon = <Widget>[
      if (widget.action != null)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: actionHorizontalMargin),
          child: TextButtonTheme(
            data: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: buttonColor,
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              ),
            ),
            child: widget.action!,
          ),
        ),
      if (showCloseIcon) Padding(padding: EdgeInsets.symmetric(horizontal: iconHorizontalMargin), child: iconButton),
    ];

    Widget snackBar = Padding(
      padding: padding,
      child: Wrap(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding:
                      widget.padding == null
                          ? const EdgeInsets.symmetric(vertical: _singleLineVerticalPadding)
                          : EdgeInsets.zero,
                  child: DefaultTextStyle(style: contentTextStyle!, child: widget.content),
                ),
              ),
              if (!willOverflowAction) ...maybeActionAndIcon,
              if (willOverflowAction) SizedBox(width: snackBarWidth * 0.4),
            ],
          ),
          if (willOverflowAction)
            Padding(
              padding: const EdgeInsets.only(bottom: _singleLineVerticalPadding),
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: maybeActionAndIcon),
            ),
        ],
      ),
    );

    if (!isFloatingSnackBar) {
      snackBar = SafeArea(top: false, child: snackBar);
    }

    final double elevation = widget.elevation ?? snackBarTheme.elevation ?? defaults.elevation!;
    final Color backgroundColor = widget.backgroundColor ?? snackBarTheme.backgroundColor ?? defaults.backgroundColor!;
    final ShapeBorder? shape = widget.shape ?? snackBarTheme.shape ?? (isFloatingSnackBar ? defaults.shape : null);
    final DismissDirection dismissDirection =
        widget.dismissDirection ?? snackBarTheme.dismissDirection ?? DismissDirection.down;

    snackBar = Material(
      shape: shape,
      elevation: elevation,
      color: backgroundColor,
      clipBehavior: widget.clipBehavior,
      child: Theme(
        data: effectiveTheme,
        child: accessibleNavigation ? snackBar : FadeTransition(opacity: _fadeOutAnimation!, child: snackBar),
      ),
    );

    if (isFloatingSnackBar) {
      // If width is provided, do not include horizontal margins.
      if (width != null) {
        snackBar = Padding(
          padding: EdgeInsets.only(top: margin.top, bottom: margin.bottom),
          child: SizedBox(width: width, child: snackBar),
        );
      } else {
        snackBar = Padding(padding: margin, child: snackBar);
      }
      snackBar = SafeArea(top: false, bottom: false, child: snackBar);
    }

    snackBar = Semantics(
      container: true,
      liveRegion: true,
      onDismiss: () {
        ScaffoldMessenger.of(context).removeCurrentSnackBar(reason: SnackBarClosedReason.dismiss);
      },
      child: Dismissible(
        key: const Key('dismissible'),
        direction: dismissDirection,
        resizeDuration: null,
        behavior:
            widget.hitTestBehavior ??
            (widget.margin != null || snackBarTheme.insetPadding != null
                ? HitTestBehavior.deferToChild
                : HitTestBehavior.opaque),
        onDismissed: (direction) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar(reason: SnackBarClosedReason.swipe);
        },
        child: snackBar,
      ),
    );

    final Widget snackBarTransition;
    if (accessibleNavigation) {
      snackBarTransition = snackBar;
    } else if (isFloatingSnackBar) {
      snackBarTransition = FadeTransition(opacity: _fadeInAnimation!, child: snackBar);
      // Is Material 3 Floating Snack Bar.
    } else if (isFloatingSnackBar) {
      snackBarTransition = FadeTransition(
        opacity: _fadeInM3Animation!,
        child: ValueListenableBuilder<double>(
          valueListenable: _heightM3Animation!,
          builder: (context, value, child) => Align(alignment: Alignment.bottomLeft, heightFactor: value, child: child),
          child: snackBar,
        ),
      );
    } else {
      snackBarTransition = ValueListenableBuilder<double>(
        valueListenable: _heightAnimation!,
        builder:
            (context, value, child) =>
                Align(alignment: AlignmentDirectional.topStart, heightFactor: value, child: child),
        child: snackBar,
      );
    }

    return Hero(
      tag: '<SnackBar Hero tag - ${widget.content}>',
      transitionOnUserGestures: true,
      child: ClipRect(clipBehavior: widget.clipBehavior, child: snackBarTransition),
    );
  }
}

// BEGIN GENERATED TOKEN PROPERTIES - Snackbar

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// dart format off
class _SnackbarDefaultsM3 extends SnackBarThemeData {
    _SnackbarDefaultsM3(this.context);

  final BuildContext context;
  late final ThemeData _theme = Theme.of(context);
  late final ColorScheme _colors = _theme.colorScheme;

  @override
  Color get backgroundColor => _colors.inverseSurface;

  @override
  Color get actionTextColor =>  WidgetStateColor.resolveWith((states) {
    if (states.contains(WidgetState.disabled)) {
      return _colors.inversePrimary;
    }
    if (states.contains(WidgetState.pressed)) {
      return _colors.inversePrimary;
    }
    if (states.contains(WidgetState.hovered)) {
      return _colors.inversePrimary;
    }
    if (states.contains(WidgetState.focused)) {
      return _colors.inversePrimary;
    }
    return _colors.inversePrimary;
  });

  @override
  Color get disabledActionTextColor =>
    _colors.inversePrimary;


  @override
  TextStyle get contentTextStyle =>
    Theme.of(context).textTheme.bodyMedium!.copyWith
      (color:  _colors.onInverseSurface,
    );

  @override
  double get elevation => 6.0;

  @override
  ShapeBorder get shape => const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)));

  @override
  SnackBarBehavior get behavior => SnackBarBehavior.fixed;

  @override
  EdgeInsets get insetPadding => const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 10.0);

  @override
  bool get showCloseIcon => false;

  @override
  Color? get closeIconColor => _colors.onInverseSurface;

  @override
  double get actionOverflowThreshold => 0.25;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BuildContext>('context', context));
  }
}
// dart format on

// END GENERATED TOKEN PROPERTIES - Snackbar
