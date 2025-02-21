// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/button_theme.dart';
import 'package:waveui/material/colors.dart';
import 'package:waveui/material/constants.dart';
import 'package:waveui/material/debug.dart';
import 'package:waveui/material/icons.dart';
import 'package:waveui/material/ink_well.dart';
import 'package:waveui/material/input_decorator.dart';
import 'package:waveui/material/material.dart';
import 'package:waveui/material/material_localizations.dart';
import 'package:waveui/material/scrollbar.dart';
import 'package:waveui/material/shadows.dart';
import 'package:waveui/material/theme.dart';

const Duration _kDropdownMenuDuration = Duration(milliseconds: 300);
const double _kMenuItemHeight = kMinInteractiveDimension;
const double _kDenseButtonHeight = 24.0;
const EdgeInsets _kMenuItemPadding = EdgeInsets.symmetric(horizontal: 16.0);
const EdgeInsetsGeometry _kAlignedButtonPadding = EdgeInsetsDirectional.only(start: 16.0, end: 4.0);
const EdgeInsets _kUnalignedButtonPadding = EdgeInsets.zero;
const EdgeInsets _kAlignedMenuMargin = EdgeInsets.zero;
const EdgeInsetsGeometry _kUnalignedMenuMargin = EdgeInsetsDirectional.only(start: 16.0, end: 24.0);

typedef DropdownButtonBuilder = List<Widget> Function(BuildContext context);

class _DropdownMenuPainter extends CustomPainter {
  _DropdownMenuPainter({
    required this.resize,
    required this.getSelectedItemOffset,
    this.color,
    this.elevation,
    this.selectedIndex,
    this.borderRadius,
  }) : _painter =
           BoxDecoration(
             // If you add an image here, you must provide a real
             // configuration in the paint() function and you must provide some sort
             // of onChanged callback here.
             color: color,
             borderRadius: borderRadius ?? const BorderRadius.all(Radius.circular(2.0)),
             boxShadow: kElevationToShadow[elevation],
           ).createBoxPainter(),
       super(repaint: resize);

  final Color? color;
  final int? elevation;
  final int? selectedIndex;
  final BorderRadius? borderRadius;
  final Animation<double> resize;
  final ValueGetter<double> getSelectedItemOffset;
  final BoxPainter _painter;

  @override
  void paint(Canvas canvas, Size size) {
    final double selectedItemOffset = getSelectedItemOffset();
    final Tween<double> top = Tween<double>(
      begin: clampDouble(selectedItemOffset, 0.0, math.max(size.height - _kMenuItemHeight, 0.0)),
      end: 0.0,
    );

    final Tween<double> bottom = Tween<double>(
      begin: clampDouble(top.begin! + _kMenuItemHeight, math.min(_kMenuItemHeight, size.height), size.height),
      end: size.height,
    );

    final Rect rect = Rect.fromLTRB(0.0, top.evaluate(resize), size.width, bottom.evaluate(resize));

    _painter.paint(canvas, rect.topLeft, ImageConfiguration(size: rect.size));
  }

  @override
  bool shouldRepaint(_DropdownMenuPainter oldPainter) =>
      oldPainter.color != color ||
      oldPainter.elevation != elevation ||
      oldPainter.selectedIndex != selectedIndex ||
      oldPainter.borderRadius != borderRadius ||
      oldPainter.resize != resize;
}

// The widget that is the button wrapping the menu items.
class _DropdownMenuItemButton<T> extends StatefulWidget {
  const _DropdownMenuItemButton({
    required this.route,
    required this.buttonRect,
    required this.constraints,
    required this.itemIndex,
    required this.enableFeedback,
    required this.scrollController,
    super.key,
    this.padding,
  });

  final _DropdownRoute<T> route;
  final ScrollController scrollController;
  final EdgeInsets? padding;
  final Rect buttonRect;
  final BoxConstraints constraints;
  final int itemIndex;
  final bool enableFeedback;

  @override
  _DropdownMenuItemButtonState<T> createState() => _DropdownMenuItemButtonState<T>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<_DropdownRoute<T>>('route', route));
    properties.add(DiagnosticsProperty<ScrollController>('scrollController', scrollController));
    properties.add(DiagnosticsProperty<EdgeInsets?>('padding', padding));
    properties.add(DiagnosticsProperty<Rect>('buttonRect', buttonRect));
    properties.add(DiagnosticsProperty<BoxConstraints>('constraints', constraints));
    properties.add(IntProperty('itemIndex', itemIndex));
    properties.add(DiagnosticsProperty<bool>('enableFeedback', enableFeedback));
  }
}

class _DropdownMenuItemButtonState<T> extends State<_DropdownMenuItemButton<T>> {
  CurvedAnimation? _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _setOpacityAnimation();
  }

  @override
  void didUpdateWidget(_DropdownMenuItemButton<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.itemIndex != widget.itemIndex ||
        oldWidget.route.animation != widget.route.animation ||
        oldWidget.route.selectedIndex != widget.route.selectedIndex ||
        widget.route.items.length != oldWidget.route.items.length) {
      _setOpacityAnimation();
    }
  }

  void _setOpacityAnimation() {
    _opacityAnimation?.dispose();
    final double unit = 0.5 / (widget.route.items.length + 1.5);
    if (widget.itemIndex == widget.route.selectedIndex) {
      _opacityAnimation = CurvedAnimation(parent: widget.route.animation!, curve: const Threshold(0.0));
    } else {
      final double start = clampDouble(0.5 + (widget.itemIndex + 1) * unit, 0.0, 1.0);
      final double end = clampDouble(start + 1.5 * unit, 0.0, 1.0);
      _opacityAnimation = CurvedAnimation(parent: widget.route.animation!, curve: Interval(start, end));
    }
  }

  void _handleFocusChange(bool focused) {
    final bool inTraditionalMode = switch (FocusManager.instance.highlightMode) {
      FocusHighlightMode.touch => false,
      FocusHighlightMode.traditional => true,
    };

    if (focused && inTraditionalMode) {
      final _MenuLimits menuLimits = widget.route.getMenuLimits(
        widget.buttonRect,
        widget.constraints.maxHeight,
        widget.itemIndex,
      );
      widget.scrollController.animateTo(
        menuLimits.scrollOffset,
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 100),
      );
    }
  }

  void _handleOnTap() {
    final DropdownMenuItem<T> dropdownMenuItem = widget.route.items[widget.itemIndex].item!;

    dropdownMenuItem.onTap?.call();

    Navigator.pop(context, _DropdownRouteResult<T>(dropdownMenuItem.value));
  }

  static const Map<ShortcutActivator, Intent> _webShortcuts = <ShortcutActivator, Intent>{
    // On the web, up/down don't change focus, *except* in a <select>
    // element, which is what a dropdown emulates.
    SingleActivator(LogicalKeyboardKey.arrowDown): DirectionalFocusIntent(TraversalDirection.down),
    SingleActivator(LogicalKeyboardKey.arrowUp): DirectionalFocusIntent(TraversalDirection.up),
  };

  @override
  void dispose() {
    _opacityAnimation?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DropdownMenuItem<T> dropdownMenuItem = widget.route.items[widget.itemIndex].item!;
    Widget child = widget.route.items[widget.itemIndex];
    if (widget.padding case final EdgeInsetsGeometry padding) {
      child = Padding(padding: padding, child: child);
    }
    child = SizedBox(height: widget.route.itemHeight, child: child);
    // An [InkWell] is added to the item only if it is enabled
    if (dropdownMenuItem.enabled) {
      child = InkWell(
        autofocus: widget.itemIndex == widget.route.selectedIndex,
        enableFeedback: widget.enableFeedback,
        onTap: _handleOnTap,
        onFocusChange: _handleFocusChange,
        child: child,
      );
    }
    child = FadeTransition(opacity: _opacityAnimation!, child: child);
    if (kIsWeb && dropdownMenuItem.enabled) {
      child = Shortcuts(shortcuts: _webShortcuts, child: child);
    }
    return child;
  }
}

class _DropdownMenu<T> extends StatefulWidget {
  const _DropdownMenu({
    required this.route,
    required this.buttonRect,
    required this.constraints,
    required this.enableFeedback,
    required this.scrollController,
    super.key,
    this.padding,
    this.dropdownColor,
    this.borderRadius,
    this.menuWidth,
  });

  final _DropdownRoute<T> route;
  final EdgeInsets? padding;
  final Rect buttonRect;
  final BoxConstraints constraints;
  final Color? dropdownColor;
  final bool enableFeedback;
  final BorderRadius? borderRadius;
  final ScrollController scrollController;
  final double? menuWidth;

  @override
  _DropdownMenuState<T> createState() => _DropdownMenuState<T>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<_DropdownRoute<T>>('route', route));
    properties.add(DiagnosticsProperty<EdgeInsets?>('padding', padding));
    properties.add(DiagnosticsProperty<Rect>('buttonRect', buttonRect));
    properties.add(DiagnosticsProperty<BoxConstraints>('constraints', constraints));
    properties.add(ColorProperty('dropdownColor', dropdownColor));
    properties.add(DiagnosticsProperty<bool>('enableFeedback', enableFeedback));
    properties.add(DiagnosticsProperty<BorderRadius?>('borderRadius', borderRadius));
    properties.add(DiagnosticsProperty<ScrollController>('scrollController', scrollController));
    properties.add(DoubleProperty('menuWidth', menuWidth));
  }
}

class _DropdownMenuState<T> extends State<_DropdownMenu<T>> {
  late final CurvedAnimation _fadeOpacity;
  late final CurvedAnimation _resize;

  @override
  void initState() {
    super.initState();
    // We need to hold these animations as state because of their curve
    // direction. When the route's animation reverses, if we were to recreate
    // the CurvedAnimation objects in build, we'd lose
    // CurvedAnimation._curveDirection.
    _fadeOpacity = CurvedAnimation(
      parent: widget.route.animation!,
      curve: const Interval(0.0, 0.25),
      reverseCurve: const Interval(0.75, 1.0),
    );
    _resize = CurvedAnimation(
      parent: widget.route.animation!,
      curve: const Interval(0.25, 0.5),
      reverseCurve: const Threshold(0.0),
    );
  }

  @override
  void dispose() {
    _fadeOpacity.dispose();
    _resize.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The menu is shown in three stages (unit timing in brackets):
    // [0s - 0.25s] - Fade in a rect-sized menu container with the selected item.
    // [0.25s - 0.5s] - Grow the otherwise empty menu container from the center
    //   until it's big enough for as many items as we're going to show.
    // [0.5s - 1.0s] Fade in the remaining visible items from top to bottom.
    //
    // When the menu is dismissed we just fade the entire thing out
    // in the first 0.25s.
    assert(debugCheckHasMaterialLocalizations(context));
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final _DropdownRoute<T> route = widget.route;
    final List<Widget> children = <Widget>[
      for (int itemIndex = 0; itemIndex < route.items.length; ++itemIndex)
        _DropdownMenuItemButton<T>(
          route: widget.route,
          padding: widget.padding,
          buttonRect: widget.buttonRect,
          constraints: widget.constraints,
          itemIndex: itemIndex,
          enableFeedback: widget.enableFeedback,
          scrollController: widget.scrollController,
        ),
    ];

    return FadeTransition(
      opacity: _fadeOpacity,
      child: CustomPaint(
        painter: _DropdownMenuPainter(
          color: widget.dropdownColor ?? Theme.of(context).canvasColor,
          elevation: route.elevation,
          selectedIndex: route.selectedIndex,
          resize: _resize,
          borderRadius: widget.borderRadius,
          // This offset is passed as a callback, not a value, because it must
          // be retrieved at paint time (after layout), not at build time.
          getSelectedItemOffset: () => route.getItemOffset(route.selectedIndex),
        ),
        child: Semantics(
          scopesRoute: true,
          namesRoute: true,
          explicitChildNodes: true,
          label: localizations.popupMenuLabel,
          child: ClipRRect(
            borderRadius: widget.borderRadius ?? BorderRadius.zero,
            clipBehavior: widget.borderRadius != null ? Clip.antiAlias : Clip.none,
            child: Material(
              type: MaterialType.transparency,
              textStyle: route.style,
              child: ScrollConfiguration(
                // Dropdown menus should never overscroll or display an overscroll indicator.
                // Scrollbars are built-in below.
                // Platform must use Theme and ScrollPhysics must be Clamping.
                behavior: ScrollConfiguration.of(context).copyWith(
                  scrollbars: false,
                  overscroll: false,
                  physics: const ClampingScrollPhysics(),
                  platform: Theme.of(context).platform,
                ),
                child: PrimaryScrollController(
                  controller: widget.scrollController,
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: ListView(
                      // Ensure this always inherits the PrimaryScrollController
                      primary: true,
                      padding: kMaterialListPadding,
                      shrinkWrap: true,
                      children: children,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DropdownMenuRouteLayout<T> extends SingleChildLayoutDelegate {
  _DropdownMenuRouteLayout({
    required this.buttonRect,
    required this.route,
    required this.textDirection,
    this.menuWidth,
  });

  final Rect buttonRect;
  final _DropdownRoute<T> route;
  final TextDirection? textDirection;
  final double? menuWidth;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // The maximum height of a simple menu should be one or more rows less than
    // the view height. This ensures a tappable area outside of the simple menu
    // with which to dismiss the menu.
    //   -- https://material.io/design/components/menus.html#usage
    double maxHeight = math.max(0.0, constraints.maxHeight - 2 * _kMenuItemHeight);
    if (route.menuMaxHeight != null && route.menuMaxHeight! <= maxHeight) {
      maxHeight = route.menuMaxHeight!;
    }
    // The width of a menu should be at most the view width. This ensures that
    // the menu does not extend past the left and right edges of the screen.
    final double width = math.min(constraints.maxWidth, menuWidth ?? buttonRect.width);
    return BoxConstraints(minWidth: width, maxWidth: width, maxHeight: maxHeight);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final _MenuLimits menuLimits = route.getMenuLimits(buttonRect, size.height, route.selectedIndex);

    assert(() {
      final Rect container = Offset.zero & size;
      if (container.intersect(buttonRect) == buttonRect) {
        // If the button was entirely on-screen, then verify
        // that the menu is also on-screen.
        // If the button was a bit off-screen, then, oh well.
        assert(menuLimits.top >= 0.0);
        assert(menuLimits.top + menuLimits.height <= size.height);
      }
      return true;
    }());
    assert(textDirection != null);
    final double left = switch (textDirection!) {
      TextDirection.rtl => clampDouble(buttonRect.right, 0.0, size.width) - childSize.width,
      TextDirection.ltr => clampDouble(buttonRect.left, 0.0, size.width - childSize.width),
    };

    return Offset(left, menuLimits.top);
  }

  @override
  bool shouldRelayout(_DropdownMenuRouteLayout<T> oldDelegate) =>
      buttonRect != oldDelegate.buttonRect || textDirection != oldDelegate.textDirection;
}

// We box the return value so that the return value can be null. Otherwise,
// canceling the route (which returns null) would get confused with actually
// returning a real null value.
@immutable
class _DropdownRouteResult<T> {
  const _DropdownRouteResult(this.result);

  final T? result;

  @override
  bool operator ==(Object other) => other is _DropdownRouteResult<T> && other.result == result;

  @override
  int get hashCode => result.hashCode;
}

class _MenuLimits {
  const _MenuLimits(this.top, this.bottom, this.height, this.scrollOffset);
  final double top;
  final double bottom;
  final double height;
  final double scrollOffset;
}

class _DropdownRoute<T> extends PopupRoute<_DropdownRouteResult<T>> {
  _DropdownRoute({
    required this.items,
    required this.padding,
    required this.buttonRect,
    required this.selectedIndex,
    required this.capturedThemes,
    required this.style,
    required this.enableFeedback,
    this.elevation = 8,
    this.barrierLabel,
    this.itemHeight,
    this.menuWidth,
    this.dropdownColor,
    this.menuMaxHeight,
    this.borderRadius,
  }) : itemHeights = List<double>.filled(items.length, itemHeight ?? kMinInteractiveDimension);

  final List<_MenuItem<T>> items;
  final EdgeInsetsGeometry padding;
  final Rect buttonRect;
  final int selectedIndex;
  final int elevation;
  final CapturedThemes capturedThemes;
  final TextStyle style;
  final double? itemHeight;
  final double? menuWidth;
  final Color? dropdownColor;
  final double? menuMaxHeight;
  final bool enableFeedback;
  final BorderRadius? borderRadius;

  final List<double> itemHeights;

  @override
  Duration get transitionDuration => _kDropdownMenuDuration;

  @override
  bool get barrierDismissible => true;

  @override
  Color? get barrierColor => null;

  @override
  final String? barrierLabel;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) =>
      LayoutBuilder(
        builder:
            (context, constraints) => _DropdownRoutePage<T>(
              route: this,
              constraints: constraints,
              items: items,
              padding: padding,
              buttonRect: buttonRect,
              selectedIndex: selectedIndex,
              elevation: elevation,
              capturedThemes: capturedThemes,
              style: style,
              dropdownColor: dropdownColor,
              enableFeedback: enableFeedback,
              borderRadius: borderRadius,
              menuWidth: menuWidth,
            ),
      );

  void _dismiss() {
    if (isActive) {
      navigator?.removeRoute(this);
    }
  }

  double getItemOffset(int index) {
    double offset = kMaterialListPadding.top;
    if (items.isNotEmpty && index > 0) {
      assert(items.length == itemHeights.length);
      offset += itemHeights.sublist(0, index).reduce((total, height) => total + height);
    }
    return offset;
  }

  // Returns the vertical extent of the menu and the initial scrollOffset
  // for the ListView that contains the menu items. The vertical center of the
  // selected item is aligned with the button's vertical center, as far as
  // that's possible given availableHeight.
  _MenuLimits getMenuLimits(Rect buttonRect, double availableHeight, int index) {
    double computedMaxHeight = availableHeight - 2.0 * _kMenuItemHeight;
    if (menuMaxHeight != null) {
      computedMaxHeight = math.min(computedMaxHeight, menuMaxHeight!);
    }
    final double buttonTop = buttonRect.top;
    final double buttonBottom = math.min(buttonRect.bottom, availableHeight);
    final double selectedItemOffset = getItemOffset(index);

    // If the button is placed on the bottom or top of the screen, its top or
    // bottom may be less than [_kMenuItemHeight] from the edge of the screen.
    // In this case, we want to change the menu limits to align with the top
    // or bottom edge of the button.
    final double topLimit = math.min(_kMenuItemHeight, buttonTop);
    final double bottomLimit = math.max(availableHeight - _kMenuItemHeight, buttonBottom);

    double menuTop = (buttonTop - selectedItemOffset) - (itemHeights[selectedIndex] - buttonRect.height) / 2.0;
    double preferredMenuHeight = kMaterialListPadding.vertical;
    if (items.isNotEmpty) {
      preferredMenuHeight += itemHeights.reduce((total, height) => total + height);
    }

    // If there are too many elements in the menu, we need to shrink it down
    // so it is at most the computedMaxHeight.
    final double menuHeight = math.min(computedMaxHeight, preferredMenuHeight);
    double menuBottom = menuTop + menuHeight;

    // If the computed top or bottom of the menu are outside of the range
    // specified, we need to bring them into range. If the item height is larger
    // than the button height and the button is at the very bottom or top of the
    // screen, the menu will be aligned with the bottom or top of the button
    // respectively.
    if (menuTop < topLimit) {
      menuTop = math.min(buttonTop, topLimit);
      menuBottom = menuTop + menuHeight;
    }

    if (menuBottom > bottomLimit) {
      menuBottom = math.max(buttonBottom, bottomLimit);
      menuTop = menuBottom - menuHeight;
    }

    if (menuBottom - itemHeights[selectedIndex] / 2.0 < buttonBottom - buttonRect.height / 2.0) {
      menuBottom = buttonBottom - buttonRect.height / 2.0 + itemHeights[selectedIndex] / 2.0;
      menuTop = menuBottom - menuHeight;
    }

    double scrollOffset = 0;
    // If all of the menu items will not fit within availableHeight then
    // compute the scroll offset that will line the selected menu item up
    // with the select item. This is only done when the menu is first
    // shown - subsequently we leave the scroll offset where the user left
    // it. This scroll offset is only accurate for fixed height menu items
    // (the default).
    if (preferredMenuHeight > computedMaxHeight) {
      // The offset should be zero if the selected item is in view at the beginning
      // of the menu. Otherwise, the scroll offset should center the item if possible.
      scrollOffset = math.max(0.0, selectedItemOffset - (buttonTop - menuTop));
      // If the selected item's scroll offset is greater than the maximum scroll offset,
      // set it instead to the maximum allowed scroll offset.
      scrollOffset = math.min(scrollOffset, preferredMenuHeight - menuHeight);
    }

    assert((menuBottom - menuTop - menuHeight).abs() < precisionErrorTolerance);
    return _MenuLimits(menuTop, menuBottom, menuHeight, scrollOffset);
  }
}

class _DropdownRoutePage<T> extends StatefulWidget {
  const _DropdownRoutePage({
    required this.route,
    required this.constraints,
    required this.padding,
    required this.buttonRect,
    required this.selectedIndex,
    required this.capturedThemes,
    required this.dropdownColor,
    required this.enableFeedback,
    super.key,
    this.items,
    this.elevation = 8,
    this.style,
    this.borderRadius,
    this.menuWidth,
  });

  final _DropdownRoute<T> route;
  final BoxConstraints constraints;
  final List<_MenuItem<T>>? items;
  final EdgeInsetsGeometry padding;
  final Rect buttonRect;
  final int selectedIndex;
  final int elevation;
  final CapturedThemes capturedThemes;
  final TextStyle? style;
  final Color? dropdownColor;
  final bool enableFeedback;
  final BorderRadius? borderRadius;
  final double? menuWidth;

  @override
  State<_DropdownRoutePage<T>> createState() => _DropdownRoutePageState<T>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<_DropdownRoute<T>>('route', route));
    properties.add(DiagnosticsProperty<BoxConstraints>('constraints', constraints));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding));
    properties.add(DiagnosticsProperty<Rect>('buttonRect', buttonRect));
    properties.add(IntProperty('selectedIndex', selectedIndex));
    properties.add(IntProperty('elevation', elevation));
    properties.add(DiagnosticsProperty<CapturedThemes>('capturedThemes', capturedThemes));
    properties.add(DiagnosticsProperty<TextStyle?>('style', style));
    properties.add(ColorProperty('dropdownColor', dropdownColor));
    properties.add(DiagnosticsProperty<bool>('enableFeedback', enableFeedback));
    properties.add(DiagnosticsProperty<BorderRadius?>('borderRadius', borderRadius));
    properties.add(DoubleProperty('menuWidth', menuWidth));
  }
}

class _DropdownRoutePageState<T> extends State<_DropdownRoutePage<T>> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    // Computing the initialScrollOffset now, before the items have been laid
    // out. This only works if the item heights are effectively fixed, i.e. either
    // DropdownButton.itemHeight is specified or DropdownButton.itemHeight is null
    // and all of the items' intrinsic heights are less than kMinInteractiveDimension.
    // Otherwise the initialScrollOffset is just a rough approximation based on
    // treating the items as if their heights were all equal to kMinInteractiveDimension.
    final _MenuLimits menuLimits = widget.route.getMenuLimits(
      widget.buttonRect,
      widget.constraints.maxHeight,
      widget.selectedIndex,
    );
    _scrollController = ScrollController(initialScrollOffset: menuLimits.scrollOffset);
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));

    final TextDirection? textDirection = Directionality.maybeOf(context);
    final Widget menu = _DropdownMenu<T>(
      route: widget.route,
      padding: widget.padding.resolve(textDirection),
      buttonRect: widget.buttonRect,
      constraints: widget.constraints,
      dropdownColor: widget.dropdownColor,
      enableFeedback: widget.enableFeedback,
      borderRadius: widget.borderRadius,
      scrollController: _scrollController,
    );

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: Builder(
        builder:
            (context) => CustomSingleChildLayout(
              delegate: _DropdownMenuRouteLayout<T>(
                buttonRect: widget.buttonRect,
                route: widget.route,
                textDirection: textDirection,
                menuWidth: widget.menuWidth,
              ),
              child: widget.capturedThemes.wrap(menu),
            ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

// This widget enables _DropdownRoute to look up the sizes of
// each menu item. These sizes are used to compute the offset of the selected
// item so that _DropdownRoutePage can align the vertical center of the
// selected item lines up with the vertical center of the dropdown button,
// as closely as possible.
class _MenuItem<T> extends SingleChildRenderObjectWidget {
  const _MenuItem({required this.onLayout, required this.item, super.key}) : super(child: item);

  final ValueChanged<Size> onLayout;
  final DropdownMenuItem<T>? item;

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

class _RenderMenuItem extends RenderProxyBox {
  _RenderMenuItem(this.onLayout, [RenderBox? child]) : super(child);

  ValueChanged<Size> onLayout;

  @override
  void performLayout() {
    super.performLayout();
    onLayout(size);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<ValueChanged<Size>>.has('onLayout', onLayout));
  }
}

// The container widget for a menu item created by a [DropdownButton]. It
// provides the default configuration for [DropdownMenuItem]s, as well as a
// [DropdownButton]'s hint and disabledHint widgets.
class _DropdownMenuItemContainer extends StatelessWidget {
  const _DropdownMenuItemContainer({required this.child, super.key, this.alignment = AlignmentDirectional.centerStart});

  final Widget child;

  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    child: ConstrainedBox(
      constraints: const BoxConstraints(minHeight: _kMenuItemHeight),
      child: Align(alignment: alignment, child: child),
    ),
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AlignmentGeometry>('alignment', alignment));
  }
}

class DropdownMenuItem<T> extends _DropdownMenuItemContainer {
  const DropdownMenuItem({
    required super.child,
    super.key,
    this.onTap,
    this.value,
    this.enabled = true,
    super.alignment,
  });

  final VoidCallback? onTap;

  final T? value;

  final bool enabled;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap));
    properties.add(DiagnosticsProperty<T?>('value', value));
    properties.add(DiagnosticsProperty<bool>('enabled', enabled));
  }
}

class DropdownButtonHideUnderline extends InheritedWidget {
  const DropdownButtonHideUnderline({required super.child, super.key});

  static bool at(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DropdownButtonHideUnderline>() != null;

  @override
  bool updateShouldNotify(DropdownButtonHideUnderline oldWidget) => false;
}

class DropdownButton<T> extends StatefulWidget {
  DropdownButton({
    required this.items,
    required this.onChanged,
    super.key,
    this.selectedItemBuilder,
    this.value,
    this.hint,
    this.disabledHint,
    this.onTap,
    this.elevation = 8,
    this.style,
    this.underline,
    this.icon,
    this.iconDisabledColor,
    this.iconEnabledColor,
    this.iconSize = 24.0,
    this.isDense = false,
    this.isExpanded = false,
    this.itemHeight = kMinInteractiveDimension,
    this.menuWidth,
    this.focusColor,
    this.focusNode,
    this.autofocus = false,
    this.dropdownColor,
    this.menuMaxHeight,
    this.enableFeedback,
    this.alignment = AlignmentDirectional.centerStart,
    this.borderRadius,
    this.padding,
    // When adding new arguments, consider adding similar arguments to
    // DropdownButtonFormField.
  }) : assert(
         items == null || items.isEmpty || value == null || items.where((item) => item.value == value).length == 1,
         "There should be exactly one item with [DropdownButton]'s value: "
         '$value. \n'
         'Either zero or 2 or more [DropdownMenuItem]s were detected '
         'with the same value',
       ),
       assert(itemHeight == null || itemHeight >= kMinInteractiveDimension),
       _inputDecoration = null,
       _isEmpty = false;

  DropdownButton._formField({
    required this.items,
    required this.onChanged,
    required InputDecoration inputDecoration,
    required bool isEmpty,
    super.key,
    this.selectedItemBuilder,
    this.value,
    this.hint,
    this.disabledHint,
    this.onTap,
    this.elevation = 8,
    this.style,
    this.underline,
    this.icon,
    this.iconDisabledColor,
    this.iconEnabledColor,
    this.iconSize = 24.0,
    this.isDense = false,
    this.isExpanded = false,
    this.itemHeight = kMinInteractiveDimension,
    this.menuWidth,
    this.focusColor,
    this.focusNode,
    this.autofocus = false,
    this.dropdownColor,
    this.menuMaxHeight,
    this.enableFeedback,
    this.alignment = AlignmentDirectional.centerStart,
    this.borderRadius,
    this.padding,
  }) : assert(
         items == null || items.isEmpty || value == null || items.where((item) => item.value == value).length == 1,
         "There should be exactly one item with [DropdownButtonFormField]'s value: "
         '$value. \n'
         'Either zero or 2 or more [DropdownMenuItem]s were detected '
         'with the same value',
       ),
       assert(itemHeight == null || itemHeight >= kMinInteractiveDimension),
       _inputDecoration = inputDecoration,
       _isEmpty = isEmpty;

  final List<DropdownMenuItem<T>>? items;

  final T? value;

  final Widget? hint;

  final Widget? disabledHint;

  final ValueChanged<T?>? onChanged;

  final VoidCallback? onTap;

  final DropdownButtonBuilder? selectedItemBuilder;

  final int elevation;

  final TextStyle? style;

  final Widget? underline;

  final Widget? icon;

  final Color? iconDisabledColor;

  final Color? iconEnabledColor;

  final double iconSize;

  final bool isDense;

  final bool isExpanded;

  final double? itemHeight;

  final double? menuWidth;

  final Color? focusColor;

  final FocusNode? focusNode;

  final bool autofocus;

  final Color? dropdownColor;

  final EdgeInsetsGeometry? padding;

  final double? menuMaxHeight;

  final bool? enableFeedback;

  final AlignmentGeometry alignment;

  final BorderRadius? borderRadius;

  final InputDecoration? _inputDecoration;

  final bool _isEmpty;

  @override
  State<DropdownButton<T>> createState() => _DropdownButtonState<T>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<T?>('value', value));
    properties.add(ObjectFlagProperty<ValueChanged<T?>?>.has('onChanged', onChanged));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap));
    properties.add(ObjectFlagProperty<DropdownButtonBuilder?>.has('selectedItemBuilder', selectedItemBuilder));
    properties.add(IntProperty('elevation', elevation));
    properties.add(DiagnosticsProperty<TextStyle?>('style', style));
    properties.add(ColorProperty('iconDisabledColor', iconDisabledColor));
    properties.add(ColorProperty('iconEnabledColor', iconEnabledColor));
    properties.add(DoubleProperty('iconSize', iconSize));
    properties.add(DiagnosticsProperty<bool>('isDense', isDense));
    properties.add(DiagnosticsProperty<bool>('isExpanded', isExpanded));
    properties.add(DoubleProperty('itemHeight', itemHeight));
    properties.add(DoubleProperty('menuWidth', menuWidth));
    properties.add(ColorProperty('focusColor', focusColor));
    properties.add(DiagnosticsProperty<FocusNode?>('focusNode', focusNode));
    properties.add(DiagnosticsProperty<bool>('autofocus', autofocus));
    properties.add(ColorProperty('dropdownColor', dropdownColor));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('padding', padding));
    properties.add(DoubleProperty('menuMaxHeight', menuMaxHeight));
    properties.add(DiagnosticsProperty<bool?>('enableFeedback', enableFeedback));
    properties.add(DiagnosticsProperty<AlignmentGeometry>('alignment', alignment));
    properties.add(DiagnosticsProperty<BorderRadius?>('borderRadius', borderRadius));
  }
}

class _DropdownButtonState<T> extends State<DropdownButton<T>> with WidgetsBindingObserver {
  int? _selectedIndex;
  _DropdownRoute<T>? _dropdownRoute;
  Orientation? _lastOrientation;
  FocusNode? _internalNode;
  FocusNode? get focusNode => widget.focusNode ?? _internalNode;
  late Map<Type, Action<Intent>> _actionMap;
  bool _isHovering = false;
  bool _hasPrimaryFocus = false;

  // Only used if needed to create _internalNode.
  FocusNode _createFocusNode() => FocusNode(debugLabel: '${widget.runtimeType}');

  @override
  void initState() {
    super.initState();
    _updateSelectedIndex();
    if (widget.focusNode == null) {
      _internalNode ??= _createFocusNode();
    }
    _actionMap = <Type, Action<Intent>>{
      ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (intent) => _handleTap()),
      ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(onInvoke: (intent) => _handleTap()),
    };
    focusNode?.addListener(_handleFocusChanged);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _removeDropdownRoute();
    focusNode?.removeListener(_handleFocusChanged);
    _internalNode?.dispose();
    super.dispose();
  }

  void _handleFocusChanged() {
    if (_hasPrimaryFocus != focusNode!.hasPrimaryFocus) {
      setState(() {
        _hasPrimaryFocus = focusNode!.hasPrimaryFocus;
      });
    }
  }

  void _removeDropdownRoute() {
    _dropdownRoute?._dismiss();
    _dropdownRoute = null;
    _lastOrientation = null;
  }

  @override
  void didUpdateWidget(DropdownButton<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode == null) {
      _internalNode ??= _createFocusNode();
    }
    _updateSelectedIndex();
  }

  void _updateSelectedIndex() {
    if (widget.items == null ||
        widget.items!.isEmpty ||
        (widget.value == null && widget.items!.where((item) => item.enabled && item.value == widget.value).isEmpty)) {
      _selectedIndex = null;
      return;
    }

    assert(widget.items!.where((item) => item.value == widget.value).length == 1);
    for (int itemIndex = 0; itemIndex < widget.items!.length; itemIndex++) {
      if (widget.items![itemIndex].value == widget.value) {
        _selectedIndex = itemIndex;
        return;
      }
    }
  }

  TextStyle? get _textStyle => widget.style ?? Theme.of(context).textTheme.titleMedium;

  void _handleTap() {
    final TextDirection? textDirection = Directionality.maybeOf(context);
    final EdgeInsetsGeometry menuMargin =
        ButtonTheme.of(context).alignedDropdown ? _kAlignedMenuMargin : _kUnalignedMenuMargin;

    final List<_MenuItem<T>> menuItems = <_MenuItem<T>>[
      for (int index = 0; index < widget.items!.length; index += 1)
        _MenuItem<T>(
          item: widget.items![index],
          onLayout: (size) {
            // If [_dropdownRoute] is null and onLayout is called, this means
            // that performLayout was called on a _DropdownRoute that has not
            // left the widget tree but is already on its way out.
            //
            // Since onLayout is used primarily to collect the desired heights
            // of each menu item before laying them out, not having the _DropdownRoute
            // collect each item's height to lay out is fine since the route is
            // already on its way out.
            if (_dropdownRoute == null) {
              return;
            }

            _dropdownRoute!.itemHeights[index] = size.height;
          },
        ),
    ];

    final NavigatorState navigator = Navigator.of(context);
    assert(_dropdownRoute == null);
    final RenderBox itemBox = context.findRenderObject()! as RenderBox;
    final Rect itemRect =
        itemBox.localToGlobal(Offset.zero, ancestor: navigator.context.findRenderObject()) & itemBox.size;
    _dropdownRoute = _DropdownRoute<T>(
      items: menuItems,
      buttonRect: menuMargin.resolve(textDirection).inflateRect(itemRect),
      padding: _kMenuItemPadding.resolve(textDirection),
      selectedIndex: _selectedIndex ?? 0,
      elevation: widget.elevation,
      capturedThemes: InheritedTheme.capture(from: context, to: navigator.context),
      style: _textStyle!,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      itemHeight: widget.itemHeight,
      menuWidth: widget.menuWidth,
      dropdownColor: widget.dropdownColor,
      menuMaxHeight: widget.menuMaxHeight,
      enableFeedback: widget.enableFeedback ?? true,
      borderRadius: widget.borderRadius,
    );

    focusNode?.requestFocus();
    navigator.push(_dropdownRoute!).then<void>((newValue) {
      _removeDropdownRoute();
      if (!mounted || newValue == null) {
        return;
      }
      widget.onChanged?.call(newValue.result);
    });

    widget.onTap?.call();
  }

  // When isDense is true, reduce the height of this button from _kMenuItemHeight to
  // _kDenseButtonHeight, but don't make it smaller than the text that it contains.
  // Similarly, we don't reduce the height of the button so much that its icon
  // would be clipped.
  double get _denseButtonHeight {
    final double fontSize = _textStyle!.fontSize ?? Theme.of(context).textTheme.titleMedium!.fontSize!;
    final double lineHeight = _textStyle!.height ?? Theme.of(context).textTheme.titleMedium!.height ?? 1.0;
    final double scaledFontSize = MediaQuery.textScalerOf(context).scale(fontSize * lineHeight);
    return math.max(scaledFontSize, math.max(widget.iconSize, _kDenseButtonHeight));
  }

  Color get _iconColor {
    // These colors are not defined in the Material Design spec.
    final Brightness brightness = Theme.of(context).brightness;
    if (_enabled) {
      return widget.iconEnabledColor ??
          switch (brightness) {
            Brightness.light => Colors.grey.shade700,
            Brightness.dark => Colors.white70,
          };
    } else {
      return widget.iconDisabledColor ??
          switch (brightness) {
            Brightness.light => Colors.grey.shade400,
            Brightness.dark => Colors.white10,
          };
    }
  }

  bool get _enabled => widget.items != null && widget.items!.isNotEmpty && widget.onChanged != null;

  Orientation _getOrientation(BuildContext context) {
    Orientation? result = MediaQuery.maybeOrientationOf(context);
    if (result == null) {
      // If there's no MediaQuery, then use the view aspect to determine
      // orientation.
      final Size size = View.of(context).physicalSize;
      result = size.width > size.height ? Orientation.landscape : Orientation.portrait;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMaterialLocalizations(context));
    final Orientation newOrientation = _getOrientation(context);
    _lastOrientation ??= newOrientation;
    if (newOrientation != _lastOrientation) {
      _removeDropdownRoute();
      _lastOrientation = newOrientation;
    }

    // The width of the button and the menu are defined by the widest
    // item and the width of the hint.
    // We should explicitly type the items list to be a list of <Widget>,
    // otherwise, no explicit type adding items maybe trigger a crash/failure
    // when hint and selectedItemBuilder are provided.
    final List<Widget> items =
        widget.selectedItemBuilder == null
            ? (widget.items != null ? List<Widget>.of(widget.items!) : <Widget>[])
            : List<Widget>.of(widget.selectedItemBuilder!(context));

    int? hintIndex;
    if (widget.hint != null || (!_enabled && widget.disabledHint != null)) {
      final Widget displayedHint = _enabled ? widget.hint! : widget.disabledHint ?? widget.hint!;

      hintIndex = items.length;
      items.add(
        DefaultTextStyle(
          style: _textStyle!.copyWith(color: Theme.of(context).hintColor),
          child: IgnorePointer(child: _DropdownMenuItemContainer(alignment: widget.alignment, child: displayedHint)),
        ),
      );
    }

    final EdgeInsetsGeometry padding =
        ButtonTheme.of(context).alignedDropdown && widget._inputDecoration == null
            ? _kAlignedButtonPadding
            : _kUnalignedButtonPadding;

    // If value is null (then _selectedIndex is null) then we
    // display the hint or nothing at all.
    final Widget innerItemsWidget;
    if (items.isEmpty) {
      innerItemsWidget = const SizedBox.shrink();
    } else {
      innerItemsWidget = IndexedStack(
        index: _selectedIndex ?? hintIndex,
        alignment: widget.alignment,
        children:
            widget.isDense
                ? items
                : items
                    .map(
                      (item) =>
                          widget.itemHeight != null
                              ? SizedBox(height: widget.itemHeight, child: item)
                              : Column(mainAxisSize: MainAxisSize.min, children: <Widget>[item]),
                    )
                    .toList(),
      );
    }

    const Icon defaultIcon = Icon(Icons.arrow_drop_down);

    Widget result = DefaultTextStyle(
      style: _enabled ? _textStyle! : _textStyle!.copyWith(color: Theme.of(context).disabledColor),
      child: SizedBox(
        height: widget.isDense ? _denseButtonHeight : null,
        child: Padding(
          padding: padding.resolve(Directionality.of(context)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (widget.isExpanded) Expanded(child: innerItemsWidget) else innerItemsWidget,
              IconTheme(
                data: IconThemeData(color: _iconColor, size: widget.iconSize),
                child: widget.icon ?? defaultIcon,
              ),
            ],
          ),
        ),
      ),
    );

    if (!DropdownButtonHideUnderline.at(context)) {
      final double bottom = (widget.isDense || widget.itemHeight == null) ? 0.0 : 8.0;
      result = Stack(
        children: <Widget>[
          result,
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: bottom,
            child:
                widget.underline ??
                Container(
                  height: 1.0,
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Color(0xFFBDBDBD), width: 0.0)),
                  ),
                ),
          ),
        ],
      );
    }

    final MouseCursor effectiveMouseCursor = WidgetStateProperty.resolveAs<MouseCursor>(
      WidgetStateMouseCursor.clickable,
      <WidgetState>{if (!_enabled) WidgetState.disabled},
    );

    // When an InputDecoration is provided, use it instead of using an InkWell
    // that overflows in some cases (such as showing an errorText) and requires
    // additional logic to manage clipping properly.
    // A filled InputDecoration is able to fill the InputDecorator container
    // without overflowing. It also supports blending the hovered color.
    // According to the Material specification, the overlay colors should be
    // visible only for filled dropdown button, see:
    // https://m2.material.io/components/menus#dropdown-menu
    if (widget._inputDecoration != null) {
      InputDecoration effectiveDecoration = widget._inputDecoration!;
      if (_hasPrimaryFocus) {
        final Color? focusColor = widget.focusColor ?? effectiveDecoration.focusColor;
        // For compatibility, override the fill color when focusColor is set.
        if (focusColor != null) {
          effectiveDecoration = effectiveDecoration.copyWith(fillColor: focusColor);
        }
      }
      result = Focus(
        canRequestFocus: _enabled,
        focusNode: focusNode,
        autofocus: widget.autofocus,
        child: MouseRegion(
          onEnter: (event) {
            if (!_isHovering) {
              setState(() {
                _isHovering = true;
              });
            }
          },
          onExit: (event) {
            if (_isHovering) {
              setState(() {
                _isHovering = false;
              });
            }
          },
          cursor: effectiveMouseCursor,
          child: GestureDetector(
            onTap: _enabled ? _handleTap : null,
            behavior: HitTestBehavior.opaque,
            child: InputDecorator(
              decoration: effectiveDecoration,
              isEmpty: widget._isEmpty,
              isFocused: _hasPrimaryFocus,
              isHovering: _isHovering,
              child: widget.padding == null ? result : Padding(padding: widget.padding!, child: result),
            ),
          ),
        ),
      );
    } else {
      result = InkWell(
        mouseCursor: effectiveMouseCursor,
        onTap: _enabled ? _handleTap : null,
        canRequestFocus: _enabled,
        borderRadius: widget.borderRadius,
        focusNode: focusNode,
        autofocus: widget.autofocus,
        focusColor: widget.focusColor ?? Theme.of(context).focusColor,
        enableFeedback: false,
        child: widget.padding == null ? result : Padding(padding: widget.padding!, child: result),
      );
    }

    final bool childHasButtonSemantic =
        hintIndex != null || (_selectedIndex != null && widget.selectedItemBuilder == null);
    return Semantics(button: !childHasButtonSemantic, child: Actions(actions: _actionMap, child: result));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<FocusNode?>('focusNode', focusNode));
  }
}

class DropdownButtonFormField<T> extends FormField<T> {
  DropdownButtonFormField({
    required List<DropdownMenuItem<T>>? items,
    required this.onChanged,
    super.key,
    DropdownButtonBuilder? selectedItemBuilder,
    T? value,
    Widget? hint,
    Widget? disabledHint,
    VoidCallback? onTap,
    int elevation = 8,
    TextStyle? style,
    Widget? icon,
    Color? iconDisabledColor,
    Color? iconEnabledColor,
    double iconSize = 24.0,
    bool isDense = true,
    bool isExpanded = false,
    double? itemHeight,
    Color? focusColor,
    FocusNode? focusNode,
    bool autofocus = false,
    Color? dropdownColor,
    InputDecoration? decoration,
    super.onSaved,
    super.validator,
    super.errorBuilder,
    AutovalidateMode? autovalidateMode,
    double? menuMaxHeight,
    bool? enableFeedback,
    AlignmentGeometry alignment = AlignmentDirectional.centerStart,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? padding,
    // When adding new arguments, consider adding similar arguments to
    // DropdownButton.
  }) : assert(
         items == null || items.isEmpty || value == null || items.where((item) => item.value == value).length == 1,
         "There should be exactly one item with [DropdownButton]'s value: "
         '$value. \n'
         'Either zero or 2 or more [DropdownMenuItem]s were detected '
         'with the same value',
       ),
       assert(itemHeight == null || itemHeight >= kMinInteractiveDimension),
       decoration = decoration ?? const InputDecoration(),
       super(
         initialValue: value,
         autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
         builder: (field) {
           final _DropdownButtonFormFieldState<T> state = field as _DropdownButtonFormFieldState<T>;
           InputDecoration effectiveDecoration = (decoration ?? const InputDecoration()).applyDefaults(
             Theme.of(field.context).inputDecorationTheme,
           );

           final bool showSelectedItem = items != null && items.where((item) => item.value == state.value).isNotEmpty;
           final bool isDropdownEnabled = onChanged != null && items != null && items.isNotEmpty;
           // If decoration hintText is provided, use it as the default value for both hint and disabledHint.
           final Widget? decorationHint =
               effectiveDecoration.hintText != null ? Text(effectiveDecoration.hintText!) : null;
           final Widget? effectiveHint = hint ?? decorationHint;
           final Widget? effectiveDisabledHint = disabledHint ?? effectiveHint;
           final bool isHintOrDisabledHintAvailable =
               isDropdownEnabled ? effectiveHint != null : effectiveHint != null || effectiveDisabledHint != null;
           final bool isEmpty = !showSelectedItem && !isHintOrDisabledHintAvailable;

           if (field.errorText != null || effectiveDecoration.hintText != null) {
             final Widget? error =
                 field.errorText != null && errorBuilder != null ? errorBuilder(state.context, field.errorText!) : null;
             final String? errorText = error == null ? field.errorText : null;
             // Clear the decoration hintText because DropdownButton has its own hint logic.
             final String? hintText = effectiveDecoration.hintText != null ? '' : null;

             effectiveDecoration = effectiveDecoration.copyWith(error: error, errorText: errorText, hintText: hintText);
           }

           // An unfocusable Focus widget so that this widget can detect if its
           // descendants have focus or not.
           return Focus(
             canRequestFocus: false,
             skipTraversal: true,
             child: Builder(
               builder:
                   (context) => DropdownButtonHideUnderline(
                     child: DropdownButton<T>._formField(
                       items: items,
                       selectedItemBuilder: selectedItemBuilder,
                       value: state.value,
                       hint: effectiveHint,
                       disabledHint: effectiveDisabledHint,
                       onChanged: onChanged == null ? null : state.didChange,
                       onTap: onTap,
                       elevation: elevation,
                       style: style,
                       icon: icon,
                       iconDisabledColor: iconDisabledColor,
                       iconEnabledColor: iconEnabledColor,
                       iconSize: iconSize,
                       isDense: isDense,
                       isExpanded: isExpanded,
                       itemHeight: itemHeight,
                       focusColor: focusColor,
                       focusNode: focusNode,
                       autofocus: autofocus,
                       dropdownColor: dropdownColor,
                       menuMaxHeight: menuMaxHeight,
                       enableFeedback: enableFeedback,
                       alignment: alignment,
                       borderRadius: borderRadius,
                       inputDecoration: effectiveDecoration,
                       isEmpty: isEmpty,
                       padding: padding,
                     ),
                   ),
             ),
           );
         },
       );

  final ValueChanged<T?>? onChanged;

  final InputDecoration decoration;

  @override
  FormFieldState<T> createState() => _DropdownButtonFormFieldState<T>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<ValueChanged<T?>?>.has('onChanged', onChanged));
    properties.add(DiagnosticsProperty<InputDecoration>('decoration', decoration));
  }
}

class _DropdownButtonFormFieldState<T> extends FormFieldState<T> {
  DropdownButtonFormField<T> get _dropdownButtonFormField => widget as DropdownButtonFormField<T>;

  @override
  void didChange(T? value) {
    super.didChange(value);
    _dropdownButtonFormField.onChanged?.call(value);
  }

  @override
  void didUpdateWidget(DropdownButtonFormField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      setValue(widget.initialValue);
    }
  }

  @override
  void reset() {
    super.reset();
    _dropdownButtonFormField.onChanged?.call(value);
  }
}
