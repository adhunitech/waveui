// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:flutter/foundation.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/button_style.dart';
import 'package:waveui/material/color_scheme.dart';
import 'package:waveui/material/colors.dart';
import 'package:waveui/material/constants.dart';
import 'package:waveui/material/debug.dart';
import 'package:waveui/material/divider.dart';
import 'package:waveui/material/icon_button.dart';
import 'package:waveui/material/icons.dart';
import 'package:waveui/material/ink_well.dart';
import 'package:waveui/material/list_tile.dart';
import 'package:waveui/material/list_tile_theme.dart';
import 'package:waveui/material/material.dart';
import 'package:waveui/material/material_localizations.dart';
import 'package:waveui/material/popup_menu_theme.dart';
import 'package:waveui/src/theme/text_theme.dart';
import 'package:waveui/material/theme.dart';
import 'package:waveui/material/theme_data.dart';
import 'package:waveui/material/tooltip.dart';

// Examples can assume:
// enum Commands { heroAndScholar, hurricaneCame }
// late bool _heroAndScholar;
// late dynamic _selection;
// late BuildContext context;
// void setState(VoidCallback fn) { }
// enum Menu { itemOne, itemTwo, itemThree, itemFour }

const Duration _kMenuDuration = Duration(milliseconds: 300);
const double _kMenuCloseIntervalEnd = 2.0 / 3.0;
const double _kMenuDividerHeight = 16.0;
const double _kMenuMaxWidth = 5.0 * _kMenuWidthStep;
const double _kMenuMinWidth = 2.0 * _kMenuWidthStep;
const double _kMenuWidthStep = 56.0;
const double _kMenuScreenPadding = 8.0;

abstract class PopupMenuEntry<T> extends StatefulWidget {
  const PopupMenuEntry({super.key});

  double get height;

  bool represents(T? value);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('height', height));
  }
}

class PopupMenuDivider extends PopupMenuEntry<Never> {
  const PopupMenuDivider({super.key, this.height = _kMenuDividerHeight});

  @override
  final double height;

  @override
  bool represents(void value) => false;

  @override
  State<PopupMenuDivider> createState() => _PopupMenuDividerState();
}

class _PopupMenuDividerState extends State<PopupMenuDivider> {
  @override
  Widget build(BuildContext context) => Divider(height: widget.height);
}

// This widget only exists to enable _PopupMenuRoute to save the sizes of
// each menu item. The sizes are used by _PopupMenuRouteLayout to compute the
// y coordinate of the menu's origin so that the center of selected menu
// item lines up with the center of its PopupMenuButton.
class _MenuItem extends SingleChildRenderObjectWidget {
  const _MenuItem({required this.onLayout, required super.child});

  final ValueChanged<Size> onLayout;

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderMenuItem(onLayout);

  @override
  void updateRenderObject(BuildContext context, covariant _RenderMenuItem renderObject) {
    renderObject.onLayout = onLayout;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<ValueChanged<Size>>.has('onLayout', onLayout));
  }
}

class _RenderMenuItem extends RenderShiftedBox {
  _RenderMenuItem(this.onLayout, [RenderBox? child]) : super(child);

  ValueChanged<Size> onLayout;

  @override
  Size computeDryLayout(BoxConstraints constraints) => child?.getDryLayout(constraints) ?? Size.zero;

  @override
  double? computeDryBaseline(covariant BoxConstraints constraints, TextBaseline baseline) =>
      child?.getDryBaseline(constraints, baseline);

  @override
  void performLayout() {
    if (child == null) {
      size = Size.zero;
    } else {
      child!.layout(constraints, parentUsesSize: true);
      size = constraints.constrain(child!.size);
      final BoxParentData childParentData = child!.parentData! as BoxParentData;
      childParentData.offset = Offset.zero;
    }
    onLayout(size);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<ValueChanged<Size>>.has('onLayout', onLayout));
  }
}

class PopupMenuItem<T> extends PopupMenuEntry<T> {
  const PopupMenuItem({
    required this.child,
    super.key,
    this.value,
    this.onTap,
    this.enabled = true,
    this.height = kMinInteractiveDimension,
    this.padding,
    this.textStyle,
    this.labelTextStyle,
    this.mouseCursor,
  });

  final T? value;

  final VoidCallback? onTap;

  final bool enabled;

  @override
  final double height;

  final EdgeInsets? padding;

  final TextStyle? textStyle;

  final WidgetStateProperty<TextStyle?>? labelTextStyle;

  final MouseCursor? mouseCursor;

  final Widget? child;

  @override
  bool represents(T? value) => value == this.value;

  @override
  PopupMenuItemState<T, PopupMenuItem<T>> createState() => PopupMenuItemState<T, PopupMenuItem<T>>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<T?>('value', value));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap));
    properties.add(DiagnosticsProperty<bool>('enabled', enabled));
    properties.add(DiagnosticsProperty<EdgeInsets?>('padding', padding));
    properties.add(DiagnosticsProperty<TextStyle?>('textStyle', textStyle));
    properties.add(DiagnosticsProperty<WidgetStateProperty<TextStyle?>?>('labelTextStyle', labelTextStyle));
    properties.add(DiagnosticsProperty<MouseCursor?>('mouseCursor', mouseCursor));
  }
}

class PopupMenuItemState<T, W extends PopupMenuItem<T>> extends State<W> {
  @protected
  Widget? buildChild() => widget.child;

  @protected
  void handleTap() {
    // Need to pop the navigator first in case onTap may push new route onto navigator.
    Navigator.pop<T>(context, widget.value);

    widget.onTap?.call();
  }

  @protected
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    final PopupMenuThemeData defaults = _PopupMenuDefaultsM3(context);
    final Set<WidgetState> states = <WidgetState>{if (!widget.enabled) WidgetState.disabled};

    TextStyle style =
        widget.labelTextStyle?.resolve(states) ??
        popupMenuTheme.labelTextStyle?.resolve(states)! ??
        defaults.labelTextStyle!.resolve(states)!;

    if (!widget.enabled) {
      style = style.copyWith(color: theme.disabledColor);
    }
    final EdgeInsetsGeometry padding = widget.padding ?? _PopupMenuDefaultsM3.menuItemPadding;

    Widget item = AnimatedDefaultTextStyle(
      style: style,
      duration: kThemeChangeDuration,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: widget.height),
        child: Padding(
          key: const Key('menu item padding'),
          padding: padding,
          child: Align(alignment: AlignmentDirectional.centerStart, child: buildChild()),
        ),
      ),
    );

    if (!widget.enabled) {
      final bool isDark = theme.brightness == Brightness.dark;
      item = IconTheme.merge(data: IconThemeData(opacity: isDark ? 0.5 : 0.38), child: item);
    }

    return MergeSemantics(
      child: Semantics(
        enabled: widget.enabled,
        button: true,
        child: InkWell(
          onTap: widget.enabled ? handleTap : null,
          canRequestFocus: widget.enabled,
          mouseCursor: _EffectiveMouseCursor(widget.mouseCursor, popupMenuTheme.mouseCursor),
          child: ListTileTheme.merge(contentPadding: EdgeInsets.zero, titleTextStyle: style, child: item),
        ),
      ),
    );
  }
}

class CheckedPopupMenuItem<T> extends PopupMenuItem<T> {
  const CheckedPopupMenuItem({
    super.key,
    super.value,
    this.checked = false,
    super.enabled,
    super.padding,
    super.height,
    super.labelTextStyle,
    super.mouseCursor,
    super.child,
    super.onTap,
  });

  final bool checked;


  @override
  PopupMenuItemState<T, CheckedPopupMenuItem<T>> createState() => _CheckedPopupMenuItemState<T>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('checked', checked));
  }
}

class _CheckedPopupMenuItemState<T> extends PopupMenuItemState<T, CheckedPopupMenuItem<T>>
    with SingleTickerProviderStateMixin {
  static const Duration _fadeDuration = Duration(milliseconds: 150);
  late AnimationController _controller;
  Animation<double> get _opacity => _controller.view;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: _fadeDuration, vsync: this)
          ..value = widget.checked ? 1.0 : 0.0
          ..addListener(
            () => setState(() {
              /* animation changed */
            }),
          );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void handleTap() {
    // This fades the checkmark in or out when tapped.
    if (widget.checked) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    super.handleTap();
  }

  @override
  Widget buildChild() {
    final ThemeData theme = Theme.of(context);
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    final PopupMenuThemeData defaults = _PopupMenuDefaultsM3(context);
    final Set<WidgetState> states = <WidgetState>{if (widget.checked) WidgetState.selected};
    final WidgetStateProperty<TextStyle?>? effectiveLabelTextStyle =
        widget.labelTextStyle ?? popupMenuTheme.labelTextStyle ?? defaults.labelTextStyle;
    return IgnorePointer(
      child: ListTileTheme.merge(
        contentPadding: EdgeInsets.zero,
        child: ListTile(
          enabled: widget.enabled,
          titleTextStyle: effectiveLabelTextStyle?.resolve(states),
          leading: FadeTransition(opacity: _opacity, child: Icon(_controller.isDismissed ? null : Icons.done)),
          title: widget.child,
        ),
      ),
    );
  }
}

class _PopupMenu<T> extends StatefulWidget {
  const _PopupMenu({
    required this.itemKeys,
    required this.route,
    required this.semanticLabel,
    required this.clipBehavior,
    super.key,
    this.constraints,
  });

  final List<GlobalKey> itemKeys;
  final _PopupMenuRoute<T> route;
  final String? semanticLabel;
  final BoxConstraints? constraints;
  final Clip clipBehavior;

  @override
  State<_PopupMenu<T>> createState() => _PopupMenuState<T>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<GlobalKey<State<StatefulWidget>>>('itemKeys', itemKeys));
    properties.add(DiagnosticsProperty<_PopupMenuRoute<T>>('route', route));
    properties.add(StringProperty('semanticLabel', semanticLabel));
    properties.add(DiagnosticsProperty<BoxConstraints?>('constraints', constraints));
    properties.add(EnumProperty<Clip>('clipBehavior', clipBehavior));
  }
}

class _PopupMenuState<T> extends State<_PopupMenu<T>> {
  List<CurvedAnimation> _opacities = const <CurvedAnimation>[];

  @override
  void initState() {
    super.initState();
    _setOpacities();
  }

  @override
  void didUpdateWidget(covariant _PopupMenu<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.route.items.length != widget.route.items.length ||
        oldWidget.route.animation != widget.route.animation) {
      _setOpacities();
    }
  }

  void _setOpacities() {
    for (final CurvedAnimation opacity in _opacities) {
      opacity.dispose();
    }
    final List<CurvedAnimation> newOpacities = <CurvedAnimation>[];
    final double unit = 1.0 / (widget.route.items.length + 1.5); // 1.0 for the width and 0.5 for the last item's fade.
    for (int i = 0; i < widget.route.items.length; i += 1) {
      final double start = (i + 1) * unit;
      final double end = clampDouble(start + 1.5 * unit, 0.0, 1.0);
      final CurvedAnimation opacity = CurvedAnimation(parent: widget.route.animation!, curve: Interval(start, end));
      newOpacities.add(opacity);
    }
    _opacities = newOpacities;
  }

  @override
  void dispose() {
    for (final CurvedAnimation opacity in _opacities) {
      opacity.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double unit = 1.0 / (widget.route.items.length + 1.5); // 1.0 for the width and 0.5 for the last item's fade.
    final List<Widget> children = <Widget>[];
    final ThemeData theme = Theme.of(context);
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    final PopupMenuThemeData defaults = _PopupMenuDefaultsM3(context);

    for (int i = 0; i < widget.route.items.length; i += 1) {
      final CurvedAnimation opacity = _opacities[i];
      Widget item = widget.route.items[i];
      if (widget.route.initialValue != null && widget.route.items[i].represents(widget.route.initialValue)) {
        item = ColoredBox(color: Theme.of(context).highlightColor, child: item);
      }
      children.add(
        _MenuItem(
          onLayout: (size) {
            widget.route.itemSizes[i] = size;
          },
          child: FadeTransition(key: widget.itemKeys[i], opacity: opacity, child: item),
        ),
      );
    }

    final CurveTween opacity = CurveTween(curve: const Interval(0.0, 1.0 / 3.0));
    final CurveTween width = CurveTween(curve: Interval(0.0, unit));
    final CurveTween height = CurveTween(curve: Interval(0.0, unit * widget.route.items.length));

    final Widget child = ConstrainedBox(
      constraints: widget.constraints ?? const BoxConstraints(minWidth: _kMenuMinWidth, maxWidth: _kMenuMaxWidth),
      child: IntrinsicWidth(
        stepWidth: _kMenuWidthStep,
        child: Semantics(
          scopesRoute: true,
          namesRoute: true,
          explicitChildNodes: true,
          label: widget.semanticLabel,
          child: SingleChildScrollView(
            padding: widget.route.menuPadding ?? popupMenuTheme.menuPadding ?? defaults.menuPadding,
            child: ListBody(children: children),
          ),
        ),
      ),
    );

    return AnimatedBuilder(
      animation: widget.route.animation!,
      builder:
          (context, child) => FadeTransition(
            opacity: opacity.animate(widget.route.animation!),
            child: Material(
              shape: widget.route.shape ?? popupMenuTheme.shape ?? defaults.shape,
              color: widget.route.color ?? popupMenuTheme.color ?? defaults.color,
              clipBehavior: widget.clipBehavior,
              type: MaterialType.card,
              elevation: widget.route.elevation ?? popupMenuTheme.elevation ?? defaults.elevation!,
              shadowColor: widget.route.shadowColor ?? popupMenuTheme.shadowColor ?? defaults.shadowColor,
              surfaceTintColor:
                  widget.route.surfaceTintColor ?? popupMenuTheme.surfaceTintColor ?? defaults.surfaceTintColor,
              child: Align(
                alignment: AlignmentDirectional.topEnd,
                widthFactor: width.evaluate(widget.route.animation!),
                heightFactor: height.evaluate(widget.route.animation!),
                child: child,
              ),
            ),
          ),
      child: child,
    );
  }
}

// Positioning of the menu on the screen.
class _PopupMenuRouteLayout extends SingleChildLayoutDelegate {
  _PopupMenuRouteLayout(
    this.position,
    this.itemSizes,
    this.selectedItemIndex,
    this.textDirection,
    this.padding,
    this.avoidBounds,
  );

  // Rectangle of underlying button, relative to the overlay's dimensions.
  final RelativeRect position;

  // The sizes of each item are computed when the menu is laid out, and before
  // the route is laid out.
  List<Size?> itemSizes;

  // The index of the selected item, or null if PopupMenuButton.initialValue
  // was not specified.
  final int? selectedItemIndex;

  // Whether to prefer going to the left or to the right.
  final TextDirection textDirection;

  // The padding of unsafe area.
  EdgeInsets padding;

  // List of rectangles that we should avoid overlapping. Unusable screen area.
  final Set<Rect> avoidBounds;

  // We put the child wherever position specifies, so long as it will fit within
  // the specified parent size padded (inset) by 8. If necessary, we adjust the
  // child's position so that it fits.

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // The menu can be at most the size of the overlay minus 8.0 pixels in each
    // direction.
    return BoxConstraints.loose(constraints.biggest).deflate(const EdgeInsets.all(_kMenuScreenPadding) + padding);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final double y = position.top;

    // Find the ideal horizontal position.
    // size: The size of the overlay.
    // childSize: The size of the menu, when fully open, as determined by
    // getConstraintsForChild.
    double x;
    if (position.left > position.right) {
      // Menu button is closer to the right edge, so grow to the left, aligned to the right edge.
      x = size.width - position.right - childSize.width;
    } else if (position.left < position.right) {
      // Menu button is closer to the left edge, so grow to the right, aligned to the left edge.
      x = position.left;
    } else {
      // Menu button is equidistant from both edges, so grow in reading direction.
      x = switch (textDirection) {
        TextDirection.rtl => size.width - position.right - childSize.width,
        TextDirection.ltr => position.left,
      };
    }
    final Offset wantedPosition = Offset(x, y);
    final Offset originCenter = position.toRect(Offset.zero & size).center;
    final Iterable<Rect> subScreens = DisplayFeatureSubScreen.subScreensInBounds(Offset.zero & size, avoidBounds);
    final Rect subScreen = _closestScreen(subScreens, originCenter);
    return _fitInsideScreen(subScreen, childSize, wantedPosition);
  }

  Rect _closestScreen(Iterable<Rect> screens, Offset point) {
    Rect closest = screens.first;
    for (final Rect screen in screens) {
      if ((screen.center - point).distance < (closest.center - point).distance) {
        closest = screen;
      }
    }
    return closest;
  }

  Offset _fitInsideScreen(Rect screen, Size childSize, Offset wantedPosition) {
    double x = wantedPosition.dx;
    double y = wantedPosition.dy;
    // Avoid going outside an area defined as the rectangle 8.0 pixels from the
    // edge of the screen in every direction.
    if (x < screen.left + _kMenuScreenPadding + padding.left) {
      x = screen.left + _kMenuScreenPadding + padding.left;
    } else if (x + childSize.width > screen.right - _kMenuScreenPadding - padding.right) {
      x = screen.right - childSize.width - _kMenuScreenPadding - padding.right;
    }
    if (y < screen.top + _kMenuScreenPadding + padding.top) {
      y = _kMenuScreenPadding + padding.top;
    } else if (y + childSize.height > screen.bottom - _kMenuScreenPadding - padding.bottom) {
      y = screen.bottom - childSize.height - _kMenuScreenPadding - padding.bottom;
    }

    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_PopupMenuRouteLayout oldDelegate) {
    // If called when the old and new itemSizes have been initialized then
    // we expect them to have the same length because there's no practical
    // way to change length of the items list once the menu has been shown.
    assert(itemSizes.length == oldDelegate.itemSizes.length);

    return position != oldDelegate.position ||
        selectedItemIndex != oldDelegate.selectedItemIndex ||
        textDirection != oldDelegate.textDirection ||
        !listEquals(itemSizes, oldDelegate.itemSizes) ||
        padding != oldDelegate.padding ||
        !setEquals(avoidBounds, oldDelegate.avoidBounds);
  }
}

class _PopupMenuRoute<T> extends PopupRoute<T> {
  _PopupMenuRoute({
    required this.items,
    required this.itemKeys,
    required this.barrierLabel,
    required this.capturedThemes,
    required this.clipBehavior,
    this.position,
    this.positionBuilder,
    this.initialValue,
    this.elevation,
    this.surfaceTintColor,
    this.shadowColor,
    this.semanticLabel,
    this.shape,
    this.menuPadding,
    this.color,
    this.constraints,
    super.settings,
    super.requestFocus,
    this.popUpAnimationStyle,
  }) : assert((position != null) != (positionBuilder != null), 'Either position or positionBuilder must be provided.'),
       itemSizes = List<Size?>.filled(items.length, null),
       // Menus always cycle focus through their items irrespective of the
       // focus traversal edge behavior set in the Navigator.
       super(traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop);

  final RelativeRect? position;
  final PopupMenuPositionBuilder? positionBuilder;
  final List<PopupMenuEntry<T>> items;
  final List<GlobalKey> itemKeys;
  final List<Size?> itemSizes;
  final T? initialValue;
  final double? elevation;
  final Color? surfaceTintColor;
  final Color? shadowColor;
  final String? semanticLabel;
  final ShapeBorder? shape;
  final EdgeInsetsGeometry? menuPadding;
  final Color? color;
  final CapturedThemes capturedThemes;
  final BoxConstraints? constraints;
  final Clip clipBehavior;
  final AnimationStyle? popUpAnimationStyle;

  CurvedAnimation? _animation;

  @override
  Animation<double> createAnimation() {
    if (popUpAnimationStyle != AnimationStyle.noAnimation) {
      return _animation ??= CurvedAnimation(
        parent: super.createAnimation(),
        curve: popUpAnimationStyle?.curve ?? Curves.linear,
        reverseCurve: popUpAnimationStyle?.reverseCurve ?? const Interval(0.0, _kMenuCloseIntervalEnd),
      );
    }
    return super.createAnimation();
  }

  void scrollTo(int selectedItemIndex) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (itemKeys[selectedItemIndex].currentContext != null) {
        Scrollable.ensureVisible(itemKeys[selectedItemIndex].currentContext!);
      }
    });
  }

  @override
  Duration get transitionDuration => popUpAnimationStyle?.duration ?? _kMenuDuration;

  @override
  bool get barrierDismissible => true;

  @override
  Color? get barrierColor => null;

  @override
  final String barrierLabel;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    int? selectedItemIndex;
    if (initialValue != null) {
      for (int index = 0; selectedItemIndex == null && index < items.length; index += 1) {
        if (items[index].represents(initialValue)) {
          selectedItemIndex = index;
        }
      }
    }
    if (selectedItemIndex != null) {
      scrollTo(selectedItemIndex);
    }

    final Widget menu = _PopupMenu<T>(
      route: this,
      itemKeys: itemKeys,
      semanticLabel: semanticLabel,
      constraints: constraints,
      clipBehavior: clipBehavior,
    );
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: LayoutBuilder(
        builder:
            (context, constraints) => CustomSingleChildLayout(
              delegate: _PopupMenuRouteLayout(
                positionBuilder?.call(context, constraints) ?? position!,
                itemSizes,
                selectedItemIndex,
                Directionality.of(context),
                mediaQuery.padding,
                _avoidBounds(mediaQuery),
              ),
              child: capturedThemes.wrap(menu),
            ),
      ),
    );
  }

  Set<Rect> _avoidBounds(MediaQueryData mediaQuery) => DisplayFeatureSubScreen.avoidBounds(mediaQuery).toSet();

  @override
  void dispose() {
    _animation?.dispose();
    super.dispose();
  }
}

typedef PopupMenuPositionBuilder = RelativeRect Function(BuildContext context, BoxConstraints constraints);

Future<T?> showMenu<T>({
  required BuildContext context,
  required List<PopupMenuEntry<T>> items,
  RelativeRect? position,
  PopupMenuPositionBuilder? positionBuilder,
  T? initialValue,
  double? elevation,
  Color? shadowColor,
  Color? surfaceTintColor,
  String? semanticLabel,
  ShapeBorder? shape,
  EdgeInsetsGeometry? menuPadding,
  Color? color,
  bool useRootNavigator = false,
  BoxConstraints? constraints,
  Clip clipBehavior = Clip.none,
  RouteSettings? routeSettings,
  AnimationStyle? popUpAnimationStyle,
  bool? requestFocus,
}) {
  assert(items.isNotEmpty);
  assert(debugCheckHasMaterialLocalizations(context));
  assert((position != null) != (positionBuilder != null), 'Either position or positionBuilder must be provided.');

  switch (Theme.of(context).platform) {
    case TargetPlatform.iOS:
    case TargetPlatform.macOS:
      break;
    case TargetPlatform.android:
    case TargetPlatform.fuchsia:
    case TargetPlatform.linux:
    case TargetPlatform.windows:
      semanticLabel ??= MaterialLocalizations.of(context).popupMenuLabel;
  }

  final List<GlobalKey> menuItemKeys = List<GlobalKey>.generate(items.length, (index) => GlobalKey());
  final NavigatorState navigator = Navigator.of(context, rootNavigator: useRootNavigator);
  return navigator.push(
    _PopupMenuRoute<T>(
      position: position,
      positionBuilder: positionBuilder,
      items: items,
      itemKeys: menuItemKeys,
      initialValue: initialValue,
      elevation: elevation,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      semanticLabel: semanticLabel,
      barrierLabel: MaterialLocalizations.of(context).menuDismissLabel,
      shape: shape,
      menuPadding: menuPadding,
      color: color,
      capturedThemes: InheritedTheme.capture(from: context, to: navigator.context),
      constraints: constraints,
      clipBehavior: clipBehavior,
      settings: routeSettings,
      popUpAnimationStyle: popUpAnimationStyle,
      requestFocus: requestFocus,
    ),
  );
}

typedef PopupMenuItemSelected<T> = void Function(T value);

typedef PopupMenuCanceled = void Function();

typedef PopupMenuItemBuilder<T> = List<PopupMenuEntry<T>> Function(BuildContext context);

class PopupMenuButton<T> extends StatefulWidget {
  const PopupMenuButton({
    required this.itemBuilder,
    super.key,
    this.initialValue,
    this.onOpened,
    this.onSelected,
    this.onCanceled,
    this.tooltip,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.padding = const EdgeInsets.all(8.0),
    this.menuPadding,
    this.child,
    this.borderRadius,
    this.splashRadius,
    this.icon,
    this.iconSize,
    this.offset = Offset.zero,
    this.enabled = true,
    this.shape,
    this.color,
    this.iconColor,
    this.enableFeedback,
    this.constraints,
    this.position,
    this.clipBehavior = Clip.none,
    this.useRootNavigator = false,
    this.popUpAnimationStyle,
    this.routeSettings,
    this.style,
    this.requestFocus,
  }) : assert(!(child != null && icon != null), 'You can only pass [child] or [icon], not both.');

  final PopupMenuItemBuilder<T> itemBuilder;

  final T? initialValue;

  final VoidCallback? onOpened;

  final PopupMenuItemSelected<T>? onSelected;

  final PopupMenuCanceled? onCanceled;

  final String? tooltip;

  final double? elevation;

  final Color? shadowColor;

  final Color? surfaceTintColor;

  final EdgeInsetsGeometry padding;

  final EdgeInsetsGeometry? menuPadding;

  final double? splashRadius;

  final Widget? child;

  final BorderRadius? borderRadius;

  final Widget? icon;

  final Offset offset;

  final bool enabled;

  final ShapeBorder? shape;

  final Color? color;

  final Color? iconColor;

  final bool? enableFeedback;

  final double? iconSize;

  final BoxConstraints? constraints;

  final PopupMenuPosition? position;

  final Clip clipBehavior;

  final bool useRootNavigator;

  final AnimationStyle? popUpAnimationStyle;

  final RouteSettings? routeSettings;

  final ButtonStyle? style;

  final bool? requestFocus;

  @override
  PopupMenuButtonState<T> createState() => PopupMenuButtonState<T>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<PopupMenuItemBuilder<T>>.has('itemBuilder', itemBuilder));
    properties.add(DiagnosticsProperty<T?>('initialValue', initialValue));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onOpened', onOpened));
    properties.add(ObjectFlagProperty<PopupMenuItemSelected<T>?>.has('onSelected', onSelected));
    properties.add(ObjectFlagProperty<PopupMenuCanceled?>.has('onCanceled', onCanceled));
    properties.add(StringProperty('tooltip', tooltip));
    properties.add(DoubleProperty('elevation', elevation));
    properties.add(ColorProperty('shadowColor', shadowColor));
    properties.add(ColorProperty('surfaceTintColor', surfaceTintColor));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('menuPadding', menuPadding));
    properties.add(DoubleProperty('splashRadius', splashRadius));
    properties.add(DiagnosticsProperty<BorderRadius?>('borderRadius', borderRadius));
    properties.add(DiagnosticsProperty<Offset>('offset', offset));
    properties.add(DiagnosticsProperty<bool>('enabled', enabled));
    properties.add(DiagnosticsProperty<ShapeBorder?>('shape', shape));
    properties.add(ColorProperty('color', color));
    properties.add(ColorProperty('iconColor', iconColor));
    properties.add(DiagnosticsProperty<bool?>('enableFeedback', enableFeedback));
    properties.add(DoubleProperty('iconSize', iconSize));
    properties.add(DiagnosticsProperty<BoxConstraints?>('constraints', constraints));
    properties.add(EnumProperty<PopupMenuPosition?>('position', position));
    properties.add(EnumProperty<Clip>('clipBehavior', clipBehavior));
    properties.add(DiagnosticsProperty<bool>('useRootNavigator', useRootNavigator));
    properties.add(DiagnosticsProperty<AnimationStyle?>('popUpAnimationStyle', popUpAnimationStyle));
    properties.add(DiagnosticsProperty<RouteSettings?>('routeSettings', routeSettings));
    properties.add(DiagnosticsProperty<ButtonStyle?>('style', style));
    properties.add(DiagnosticsProperty<bool?>('requestFocus', requestFocus));
  }
}

class PopupMenuButtonState<T> extends State<PopupMenuButton<T>> {
  RelativeRect _positionBuilder(BuildContext _, BoxConstraints constraints) {
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    final RenderBox button = context.findRenderObject()! as RenderBox;
    final RenderBox overlay =
        Navigator.of(context, rootNavigator: widget.useRootNavigator).overlay!.context.findRenderObject()! as RenderBox;
    final PopupMenuPosition popupMenuPosition = widget.position ?? popupMenuTheme.position ?? PopupMenuPosition.over;
    late Offset offset;
    switch (popupMenuPosition) {
      case PopupMenuPosition.over:
        offset = widget.offset;
      case PopupMenuPosition.under:
        offset = Offset(0.0, button.size.height) + widget.offset;
        if (widget.child == null) {
          // Remove the padding of the icon button.
          offset -= Offset(0.0, widget.padding.vertical / 2);
        }
    }
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(offset, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero) + offset, ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    return position;
  }

  void showButtonMenu() {
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    final List<PopupMenuEntry<T>> items = widget.itemBuilder(context);
    // Only show the menu if there is something to show
    if (items.isNotEmpty) {
      widget.onOpened?.call();
      showMenu<T?>(
        context: context,
        elevation: widget.elevation ?? popupMenuTheme.elevation,
        shadowColor: widget.shadowColor ?? popupMenuTheme.shadowColor,
        surfaceTintColor: widget.surfaceTintColor ?? popupMenuTheme.surfaceTintColor,
        items: items,
        initialValue: widget.initialValue,
        positionBuilder: _positionBuilder,
        shape: widget.shape ?? popupMenuTheme.shape,
        menuPadding: widget.menuPadding ?? popupMenuTheme.menuPadding,
        color: widget.color ?? popupMenuTheme.color,
        constraints: widget.constraints,
        clipBehavior: widget.clipBehavior,
        useRootNavigator: widget.useRootNavigator,
        popUpAnimationStyle: widget.popUpAnimationStyle,
        routeSettings: widget.routeSettings,
        requestFocus: widget.requestFocus,
      ).then<void>((newValue) {
        if (!mounted) {
          return null;
        }
        if (newValue == null) {
          widget.onCanceled?.call();
          return null;
        }
        widget.onSelected?.call(newValue);
      });
    }
  }

  bool get _canRequestFocus {
    final NavigationMode mode = MediaQuery.maybeNavigationModeOf(context) ?? NavigationMode.traditional;
    return switch (mode) {
      NavigationMode.traditional => widget.enabled,
      NavigationMode.directional => true,
    };
  }

  @protected
  @override
  Widget build(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    final bool enableFeedback = widget.enableFeedback ?? PopupMenuTheme.of(context).enableFeedback ?? true;

    assert(debugCheckHasMaterialLocalizations(context));

    if (widget.child != null) {
      final Widget child = Tooltip(
        message: widget.tooltip ?? MaterialLocalizations.of(context).showMenuTooltip,
        child: InkWell(
          borderRadius: widget.borderRadius,
          onTap: widget.enabled ? showButtonMenu : null,
          canRequestFocus: _canRequestFocus,
          radius: widget.splashRadius,
          enableFeedback: enableFeedback,
          child: widget.child,
        ),
      );
      final MaterialTapTargetSize tapTargetSize = widget.style?.tapTargetSize ?? MaterialTapTargetSize.shrinkWrap;
      if (tapTargetSize == MaterialTapTargetSize.padded) {
        return ConstrainedBox(
          constraints: const BoxConstraints(minWidth: kMinInteractiveDimension, minHeight: kMinInteractiveDimension),
          child: child,
        );
      }
      return child;
    }

    return IconButton(
      key: StandardComponentType.moreButton.key,
      icon: widget.icon ?? Icon(Icons.adaptive.more),
      padding: widget.padding,
      splashRadius: widget.splashRadius,
      iconSize: widget.iconSize ?? popupMenuTheme.iconSize ?? iconTheme.size,
      color: widget.iconColor ?? popupMenuTheme.iconColor ?? iconTheme.color,
      tooltip: widget.tooltip ?? MaterialLocalizations.of(context).showMenuTooltip,
      onPressed: widget.enabled ? showButtonMenu : null,
      enableFeedback: enableFeedback,
      style: widget.style,
    );
  }
}

// This WidgetStateProperty is passed along to the menu item's InkWell which
// resolves the property against WidgetState.disabled, WidgetState.hovered,
// WidgetState.focused.
class _EffectiveMouseCursor extends WidgetStateMouseCursor {
  const _EffectiveMouseCursor(this.widgetCursor, this.themeCursor);

  final MouseCursor? widgetCursor;
  final WidgetStateProperty<MouseCursor?>? themeCursor;

  @override
  MouseCursor resolve(Set<WidgetState> states) =>
      WidgetStateProperty.resolveAs<MouseCursor?>(widgetCursor, states) ??
      themeCursor?.resolve(states) ??
      WidgetStateMouseCursor.clickable.resolve(states);

  @override
  String get debugDescription => 'WidgetStateMouseCursor(PopupMenuItemState)';

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<MouseCursor?>('widgetCursor', widgetCursor));
    properties.add(DiagnosticsProperty<WidgetStateProperty<MouseCursor?>?>('themeCursor', themeCursor));
  }
}
// BEGIN GENERATED TOKEN PROPERTIES - PopupMenu

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// dart format off
class _PopupMenuDefaultsM3 extends PopupMenuThemeData {
  _PopupMenuDefaultsM3(this.context)
    : super(elevation: 3.0);

  final BuildContext context;
  late final ThemeData _theme = Theme.of(context);
  late final ColorScheme _colors = _theme.colorScheme;
  late final TextTheme _textTheme = _theme.textTheme;

  @override WidgetStateProperty<TextStyle?>? get labelTextStyle => WidgetStateProperty.resolveWith((states) {
    // TODO(quncheng): Update this hard-coded value to use the latest tokens.
    final TextStyle style = _textTheme.labelLarge!;
      if (states.contains(WidgetState.disabled)) {
        return style.apply(color: _colors.onSurface.withOpacity(0.38));
      }
      return style.apply(color: _colors.onSurface);
    });

  @override
  Color? get color => _colors.surfaceContainer;

  @override
  Color? get shadowColor => _colors.shadow;

  @override
  Color? get surfaceTintColor => Colors.transparent;

  @override
  ShapeBorder? get shape => const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)));

  // TODO(bleroux): This is taken from https://m3.material.io/components/menus/specs
  // Update this when the token is available.
  @override
  EdgeInsets? get menuPadding => const EdgeInsets.symmetric(vertical: 8.0);

  // TODO(tahatesser): This is taken from https://m3.material.io/components/menus/specs
  // Update this when the token is available.
  static EdgeInsets menuItemPadding  = const EdgeInsets.symmetric(horizontal: 12.0);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BuildContext>('context', context));
  }
}// dart format on

// END GENERATED TOKEN PROPERTIES - PopupMenu
