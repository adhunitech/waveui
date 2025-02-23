// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;
import 'dart:ui' show SemanticsRole, lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/color_scheme.dart';
import 'package:waveui/material/colors.dart';
import 'package:waveui/material/constants.dart';
import 'package:waveui/material/debug.dart';
import 'package:waveui/material/ink_well.dart';
import 'package:waveui/material/material.dart';
import 'package:waveui/material/material_localizations.dart';
import 'package:waveui/material/tab_bar_theme.dart';
import 'package:waveui/material/tab_controller.dart';
import 'package:waveui/material/tab_indicator.dart';
import 'package:waveui/src/theme/text_theme.dart';
import 'package:waveui/material/theme.dart';

const double _kTabHeight = 46.0;
const double _kTextAndIconTabHeight = 72.0;
const double _kStartOffset = 52.0;

enum TabBarIndicatorSize { tab, label }

enum TabAlignment {
  // TODO(tahatesser): Add a link to the Material Design spec for
  // horizontal offset when it is available.
  // It's currently sourced from androidx/compose/material3/TabRow.kt.
  start,

  startOffset,

  fill,

  center,
}

enum TabIndicatorAnimation { linear, elastic }

class Tab extends StatelessWidget implements PreferredSizeWidget {
  const Tab({super.key, this.text, this.icon, this.iconMargin, this.height, this.child})
    : assert(text != null || child != null || icon != null),
      assert(text == null || child == null);

  final String? text;

  final Widget? child;

  final Widget? icon;

  final EdgeInsetsGeometry? iconMargin;

  final double? height;

  Widget _buildLabelText() => child ?? Text(text!, softWrap: false, overflow: TextOverflow.fade);

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));

    final double calculatedHeight;
    final Widget label;
    if (icon == null) {
      calculatedHeight = _kTabHeight;
      label = _buildLabelText();
    } else if (text == null && child == null) {
      calculatedHeight = _kTabHeight;
      label = icon!;
    } else {
      calculatedHeight = _kTextAndIconTabHeight;
      final EdgeInsetsGeometry effectiveIconMargin = iconMargin ?? _TabsPrimaryDefaultsM3.iconMargin;
      label = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Padding(padding: effectiveIconMargin, child: icon), _buildLabelText()],
      );
    }

    return SizedBox(height: height ?? calculatedHeight, child: Center(widthFactor: 1.0, child: label));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('text', text, defaultValue: null));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('iconMargin', iconMargin));
    properties.add(DoubleProperty('height', height));
  }

  @override
  Size get preferredSize {
    if (height != null) {
      return Size.fromHeight(height!);
    } else if ((text != null || child != null) && icon != null) {
      return const Size.fromHeight(_kTextAndIconTabHeight);
    } else {
      return const Size.fromHeight(_kTabHeight);
    }
  }
}

class _TabStyle extends AnimatedWidget {
  const _TabStyle({
    required Animation<double> animation,
    required this.isSelected,
    required this.isPrimary,
    required this.labelColor,
    required this.unselectedLabelColor,
    required this.labelStyle,
    required this.unselectedLabelStyle,
    required this.defaults,
    required this.child,
  }) : super(listenable: animation);

  final TextStyle? labelStyle;
  final TextStyle? unselectedLabelStyle;
  final bool isSelected;
  final bool isPrimary;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final TabBarThemeData defaults;
  final Widget child;

  WidgetStateColor _resolveWithLabelColor(BuildContext context, {IconThemeData? iconTheme}) {
    final ThemeData themeData = Theme.of(context);
    final TabBarThemeData tabBarTheme = TabBarTheme.of(context);
    final Animation<double> animation = listenable as Animation<double>;

    // labelStyle.color (and tabBarTheme.labelStyle.color) is not considered
    // as it'll be a breaking change without a possible migration plan. for
    // details: https://github.com/flutter/flutter/pull/109541#issuecomment-1294241417
    Color selectedColor =
        labelColor ??
        tabBarTheme.labelColor ??
        labelStyle?.color ??
        tabBarTheme.labelStyle?.color ??
        defaults.labelColor!;

    final Color unselectedColor;

    if (selectedColor is WidgetStateColor) {
      unselectedColor = selectedColor.resolve(const <WidgetState>{});
      selectedColor = selectedColor.resolve(const <WidgetState>{WidgetState.selected});
    } else {
      // unselectedLabelColor and tabBarTheme.unselectedLabelColor are ignored
      // when labelColor is a WidgetStateColor.
      unselectedColor =
          unselectedLabelColor ??
          tabBarTheme.unselectedLabelColor ??
          unselectedLabelStyle?.color ??
          tabBarTheme.unselectedLabelStyle?.color ??
          iconTheme?.color ??
          defaults.unselectedLabelColor!; // 70% alpha
    }

    return WidgetStateColor.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Color.lerp(selectedColor, unselectedColor, animation.value)!;
      }
      return Color.lerp(unselectedColor, selectedColor, animation.value)!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TabBarThemeData tabBarTheme = TabBarTheme.of(context);
    final Animation<double> animation = listenable as Animation<double>;

    final Set<WidgetState> states = isSelected ? const <WidgetState>{WidgetState.selected} : const <WidgetState>{};

    // To enable TextStyle.lerp(style1, style2, value), both styles must have
    // the same value of inherit. Force that to be inherit=true here.
    final TextStyle selectedStyle = (labelStyle ?? tabBarTheme.labelStyle ?? defaults.labelStyle!).copyWith(
      inherit: true,
    );
    final TextStyle unselectedStyle = (unselectedLabelStyle ??
            tabBarTheme.unselectedLabelStyle ??
            labelStyle ??
            defaults.unselectedLabelStyle!)
        .copyWith(inherit: true);
    final TextStyle textStyle =
        isSelected
            ? TextStyle.lerp(selectedStyle, unselectedStyle, animation.value)!
            : TextStyle.lerp(unselectedStyle, selectedStyle, animation.value)!;
    final Color defaultIconColor = switch (theme.colorScheme.brightness) {
      Brightness.light => kDefaultIconDarkColor,
      Brightness.dark => kDefaultIconLightColor,
    };
    final IconThemeData? customIconTheme = switch (IconTheme.of(context)) {
      final IconThemeData iconTheme when iconTheme.color != defaultIconColor => iconTheme,
      _ => null,
    };
    final Color iconColor = _resolveWithLabelColor(context, iconTheme: customIconTheme).resolve(states);
    final Color labelColor = _resolveWithLabelColor(context).resolve(states);

    return DefaultTextStyle(
      style: textStyle.copyWith(color: labelColor),
      child: IconTheme.merge(data: IconThemeData(size: customIconTheme?.size ?? 24.0, color: iconColor), child: child),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextStyle?>('labelStyle', labelStyle));
    properties.add(DiagnosticsProperty<TextStyle?>('unselectedLabelStyle', unselectedLabelStyle));
    properties.add(DiagnosticsProperty<bool>('isSelected', isSelected));
    properties.add(DiagnosticsProperty<bool>('isPrimary', isPrimary));
    properties.add(ColorProperty('labelColor', labelColor));
    properties.add(ColorProperty('unselectedLabelColor', unselectedLabelColor));
    properties.add(DiagnosticsProperty<TabBarThemeData>('defaults', defaults));
  }
}

typedef _LayoutCallback = void Function(List<double> xOffsets, TextDirection textDirection, double width);

class _TabLabelBarRenderer extends RenderFlex {
  _TabLabelBarRenderer({
    required super.direction,
    required super.mainAxisSize,
    required super.mainAxisAlignment,
    required super.crossAxisAlignment,
    required TextDirection super.textDirection,
    required super.verticalDirection,
    required this.onPerformLayout,
  });

  _LayoutCallback onPerformLayout;

  @override
  void performLayout() {
    super.performLayout();
    // xOffsets will contain childCount+1 values, giving the offsets of the
    // leading edge of the first tab as the first value, of the leading edge of
    // the each subsequent tab as each subsequent value, and of the trailing
    // edge of the last tab as the last value.
    RenderBox? child = firstChild;
    final List<double> xOffsets = <double>[];
    while (child != null) {
      final FlexParentData childParentData = child.parentData! as FlexParentData;
      xOffsets.add(childParentData.offset.dx);
      assert(child.parentData == childParentData);
      child = childParentData.nextSibling;
    }
    assert(textDirection != null);
    switch (textDirection!) {
      case TextDirection.rtl:
        xOffsets.insert(0, size.width);
      case TextDirection.ltr:
        xOffsets.add(size.width);
    }
    onPerformLayout(xOffsets, textDirection!, size.width);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<_LayoutCallback>.has('onPerformLayout', onPerformLayout));
  }
}

// This class and its renderer class only exist to report the widths of the tabs
// upon layout. The tab widths are only used at paint time (see _IndicatorPainter)
// or in response to input.
class _TabLabelBar extends Flex {
  const _TabLabelBar({required this.onPerformLayout, required super.mainAxisSize, super.children})
    : super(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        verticalDirection: VerticalDirection.down,
      );

  final _LayoutCallback onPerformLayout;

  @override
  RenderFlex createRenderObject(BuildContext context) => _TabLabelBarRenderer(
    direction: direction,
    mainAxisAlignment: mainAxisAlignment,
    mainAxisSize: mainAxisSize,
    crossAxisAlignment: crossAxisAlignment,
    textDirection: getEffectiveTextDirection(context)!,
    verticalDirection: verticalDirection,
    onPerformLayout: onPerformLayout,
  );

  @override
  void updateRenderObject(BuildContext context, _TabLabelBarRenderer renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject.onPerformLayout = onPerformLayout;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<_LayoutCallback>.has('onPerformLayout', onPerformLayout));
  }
}

double _indexChangeProgress(TabController controller) {
  final double controllerValue = controller.animation!.value;
  final double previousIndex = controller.previousIndex.toDouble();
  final double currentIndex = controller.index.toDouble();

  // The controller's offset is changing because the user is dragging the
  // TabBarView's PageView to the left or right.
  if (!controller.indexIsChanging) {
    return clampDouble((currentIndex - controllerValue).abs(), 0.0, 1.0);
  }

  // The TabController animation's value is changing from previousIndex to currentIndex.
  return (controllerValue - currentIndex).abs() / (currentIndex - previousIndex).abs();
}

class _DividerPainter extends CustomPainter {
  _DividerPainter({required this.dividerColor, required this.dividerHeight});

  final Color dividerColor;
  final double dividerHeight;

  @override
  void paint(Canvas canvas, Size size) {
    if (dividerHeight <= 0.0) {
      return;
    }

    final Paint paint =
        Paint()
          ..color = dividerColor
          ..strokeWidth = dividerHeight;

    canvas.drawLine(
      Offset(0, size.height - (paint.strokeWidth / 2)),
      Offset(size.width, size.height - (paint.strokeWidth / 2)),
      paint,
    );
  }

  @override
  bool shouldRepaint(_DividerPainter oldDelegate) =>
      oldDelegate.dividerColor != dividerColor || oldDelegate.dividerHeight != dividerHeight;
}

class _IndicatorPainter extends CustomPainter {
  _IndicatorPainter({
    required this.controller,
    required this.indicator,
    required this.indicatorSize,
    required this.tabKeys,
    required _IndicatorPainter? old,
    required this.indicatorPadding,
    required this.labelPaddings,
    required this.showDivider,
    required this.indicatorAnimation,
    required this.textDirection,
    this.dividerColor,
    this.dividerHeight,
    this.devicePixelRatio,
  }) : super(repaint: controller.animation) {
    // TODO(polina-c): stop duplicating code across disposables
    // https://github.com/flutter/flutter/issues/137435
    if (kFlutterMemoryAllocationsEnabled) {
      FlutterMemoryAllocations.instance.dispatchObjectCreated(
        library: 'package:flutter/material.dart',
        className: '$_IndicatorPainter',
        object: this,
      );
    }
    if (old != null) {
      saveTabOffsets(old._currentTabOffsets, old._currentTextDirection);
    }
  }

  final TabController controller;
  final Decoration indicator;
  final TabBarIndicatorSize indicatorSize;
  final EdgeInsetsGeometry indicatorPadding;
  final List<GlobalKey> tabKeys;
  final List<EdgeInsetsGeometry> labelPaddings;
  final Color? dividerColor;
  final double? dividerHeight;
  final bool showDivider;
  final double? devicePixelRatio;
  final TabIndicatorAnimation indicatorAnimation;
  final TextDirection textDirection;

  // _currentTabOffsets and _currentTextDirection are set each time TabBar
  // layout is completed. These values can be null when TabBar contains no
  // tabs, since there are nothing to lay out.
  List<double>? _currentTabOffsets;
  TextDirection? _currentTextDirection;

  Rect? _currentRect;
  BoxPainter? _painter;
  bool _needsPaint = false;
  void markNeedsPaint() {
    _needsPaint = true;
  }

  void dispose() {
    if (kFlutterMemoryAllocationsEnabled) {
      FlutterMemoryAllocations.instance.dispatchObjectDisposed(object: this);
    }
    _painter?.dispose();
  }

  void saveTabOffsets(List<double>? tabOffsets, TextDirection? textDirection) {
    _currentTabOffsets = tabOffsets;
    _currentTextDirection = textDirection;
  }

  // _currentTabOffsets[index] is the offset of the start edge of the tab at index, and
  // _currentTabOffsets[_currentTabOffsets.length] is the end edge of the last tab.
  int get maxTabIndex => _currentTabOffsets!.length - 2;

  double centerOf(int tabIndex) {
    assert(_currentTabOffsets != null);
    assert(_currentTabOffsets!.isNotEmpty);
    assert(tabIndex >= 0);
    assert(tabIndex <= maxTabIndex);
    return (_currentTabOffsets![tabIndex] + _currentTabOffsets![tabIndex + 1]) / 2.0;
  }

  Rect indicatorRect(Size tabBarSize, int tabIndex) {
    assert(_currentTabOffsets != null);
    assert(_currentTextDirection != null);
    assert(_currentTabOffsets!.isNotEmpty);
    assert(tabIndex >= 0);
    assert(tabIndex <= maxTabIndex);
    double tabLeft;
    double tabRight;
    (tabLeft, tabRight) = switch (_currentTextDirection!) {
      TextDirection.rtl => (_currentTabOffsets![tabIndex + 1], _currentTabOffsets![tabIndex]),
      TextDirection.ltr => (_currentTabOffsets![tabIndex], _currentTabOffsets![tabIndex + 1]),
    };

    if (indicatorSize == TabBarIndicatorSize.label) {
      final double tabWidth = tabKeys[tabIndex].currentContext!.size!.width;
      final EdgeInsetsGeometry labelPadding = labelPaddings[tabIndex];
      final EdgeInsets insets = labelPadding.resolve(_currentTextDirection);
      final double delta = ((tabRight - tabLeft) - (tabWidth + insets.horizontal)) / 2.0;
      tabLeft += delta + insets.left;
      tabRight = tabLeft + tabWidth;
    }

    final EdgeInsets insets = indicatorPadding.resolve(_currentTextDirection);
    final Rect rect = Rect.fromLTWH(tabLeft, 0.0, tabRight - tabLeft, tabBarSize.height);

    if (!(rect.size >= insets.collapsedSize)) {
      throw FlutterError(
        'indicatorPadding insets should be less than Tab Size\n'
        'Rect Size : ${rect.size}, Insets: $insets',
      );
    }
    return insets.deflateRect(rect);
  }

  @override
  void paint(Canvas canvas, Size size) {
    _needsPaint = false;
    _painter ??= indicator.createBoxPainter(markNeedsPaint);

    final double value = controller.animation!.value;

    _currentRect = switch (indicatorAnimation) {
      TabIndicatorAnimation.linear => _applyLinearEffect(size: size, value: value),
      TabIndicatorAnimation.elastic => _applyElasticEffect(size: size, value: value),
    };

    assert(_currentRect != null);

    final ImageConfiguration configuration = ImageConfiguration(
      size: _currentRect!.size,
      textDirection: _currentTextDirection,
      devicePixelRatio: devicePixelRatio,
    );
    if (showDivider && dividerHeight! > 0) {
      final Paint dividerPaint =
          Paint()
            ..color = dividerColor!
            ..strokeWidth = dividerHeight!;
      final Offset dividerP1 = Offset(0, size.height - (dividerPaint.strokeWidth / 2));
      final Offset dividerP2 = Offset(size.width, size.height - (dividerPaint.strokeWidth / 2));
      canvas.drawLine(dividerP1, dividerP2, dividerPaint);
    }
    _painter!.paint(canvas, _currentRect!.topLeft, configuration);
  }

  Rect? _applyLinearEffect({required Size size, required double value}) {
    final double index = controller.index.toDouble();
    final bool ltr = index > value;
    final int from = (ltr ? value.floor() : value.ceil()).clamp(0, maxTabIndex);
    final int to = (ltr ? from + 1 : from - 1).clamp(0, maxTabIndex);
    final Rect fromRect = indicatorRect(size, from);
    final Rect toRect = indicatorRect(size, to);
    return Rect.lerp(fromRect, toRect, (value - from).abs());
  }

  // Ease out sine (decelerating).
  double decelerateInterpolation(double fraction) => math.sin((fraction * math.pi) / 2.0);

  // Ease in sine (accelerating).
  double accelerateInterpolation(double fraction) => 1.0 - math.cos((fraction * math.pi) / 2.0);

  Rect? _applyElasticEffect({required Size size, required double value}) {
    final double index = controller.index.toDouble();
    double progressLeft = (index - value).abs();

    final int to =
        progressLeft == 0.0 || !controller.indexIsChanging
            ? switch (textDirection) {
              TextDirection.ltr => value.ceil(),
              TextDirection.rtl => value.floor(),
            }.clamp(0, maxTabIndex)
            : controller.index;
    final int from =
        progressLeft == 0.0 || !controller.indexIsChanging
            ? switch (textDirection) {
              TextDirection.ltr => (to - 1),
              TextDirection.rtl => (to + 1),
            }.clamp(0, maxTabIndex)
            : controller.previousIndex;
    final Rect toRect = indicatorRect(size, to);
    final Rect fromRect = indicatorRect(size, from);
    final Rect rect = Rect.lerp(fromRect, toRect, (value - from).abs())!;

    // If the tab animation is completed, there is no need to stretch the indicator
    // This only works for the tab change animation via tab index, not when
    // dragging a [TabBarView], but it's still ok, to avoid unnecessary calculations.
    if (controller.animation!.isCompleted) {
      return rect;
    }

    final double tabChangeProgress;

    if (controller.indexIsChanging) {
      final int tabsDelta = (controller.index - controller.previousIndex).abs();
      if (tabsDelta != 0) {
        progressLeft /= tabsDelta;
      }
      tabChangeProgress = 1 - clampDouble(progressLeft, 0.0, 1.0);
    } else {
      tabChangeProgress = (index - value).abs();
    }

    // If the animation has finished, there is no need to apply the stretch effect.
    if (tabChangeProgress == 1.0) {
      return rect;
    }

    final double leftFraction;
    final double rightFraction;
    final bool isMovingRight = switch (textDirection) {
      TextDirection.ltr => controller.indexIsChanging ? index > value : value > index,
      TextDirection.rtl => controller.indexIsChanging ? value > index : index > value,
    };
    if (isMovingRight) {
      leftFraction = accelerateInterpolation(tabChangeProgress);
      rightFraction = decelerateInterpolation(tabChangeProgress);
    } else {
      leftFraction = decelerateInterpolation(tabChangeProgress);
      rightFraction = accelerateInterpolation(tabChangeProgress);
    }

    final double lerpRectLeft;
    final double lerpRectRight;

    // The controller.indexIsChanging is true when the Tab is pressed, instead of swipe to change tabs.
    // If the tab is pressed then only lerp between fromRect and toRect.
    if (controller.indexIsChanging) {
      lerpRectLeft = lerpDouble(fromRect.left, toRect.left, leftFraction)!;
      lerpRectRight = lerpDouble(fromRect.right, toRect.right, rightFraction)!;
    } else {
      // Switch the Rect left and right lerp order based on swipe direction.
      lerpRectLeft = switch (isMovingRight) {
        true => lerpDouble(fromRect.left, toRect.left, leftFraction)!,
        false => lerpDouble(toRect.left, fromRect.left, leftFraction)!,
      };
      lerpRectRight = switch (isMovingRight) {
        true => lerpDouble(fromRect.right, toRect.right, rightFraction)!,
        false => lerpDouble(toRect.right, fromRect.right, rightFraction)!,
      };
    }

    return Rect.fromLTRB(lerpRectLeft, rect.top, lerpRectRight, rect.bottom);
  }

  @override
  bool shouldRepaint(_IndicatorPainter old) =>
      _needsPaint ||
      controller != old.controller ||
      indicator != old.indicator ||
      tabKeys.length != old.tabKeys.length ||
      (!listEquals(_currentTabOffsets, old._currentTabOffsets)) ||
      _currentTextDirection != old._currentTextDirection;
}

class _ChangeAnimation extends Animation<double> with AnimationWithParentMixin<double> {
  _ChangeAnimation(this.controller);

  final TabController controller;

  @override
  Animation<double> get parent => controller.animation!;

  @override
  void removeStatusListener(AnimationStatusListener listener) {
    if (controller.animation != null) {
      super.removeStatusListener(listener);
    }
  }

  @override
  void removeListener(VoidCallback listener) {
    if (controller.animation != null) {
      super.removeListener(listener);
    }
  }

  @override
  double get value => _indexChangeProgress(controller);
}

class _DragAnimation extends Animation<double> with AnimationWithParentMixin<double> {
  _DragAnimation(this.controller, this.index);

  final TabController controller;
  final int index;

  @override
  Animation<double> get parent => controller.animation!;

  @override
  void removeStatusListener(AnimationStatusListener listener) {
    if (controller.animation != null) {
      super.removeStatusListener(listener);
    }
  }

  @override
  void removeListener(VoidCallback listener) {
    if (controller.animation != null) {
      super.removeListener(listener);
    }
  }

  @override
  double get value {
    assert(!controller.indexIsChanging);
    final double controllerMaxValue = (controller.length - 1).toDouble();
    final double controllerValue = clampDouble(controller.animation!.value, 0.0, controllerMaxValue);
    return clampDouble((controllerValue - index.toDouble()).abs(), 0.0, 1.0);
  }
}

// This class, and TabBarScrollController, only exist to handle the case
// where a scrollable TabBar has a non-zero initialIndex. In that case we can
// only compute the scroll position's initial scroll offset (the "correct"
// pixels value) after the TabBar viewport width and scroll limits are known.
class _TabBarScrollPosition extends ScrollPositionWithSingleContext {
  _TabBarScrollPosition({
    required super.physics,
    required super.context,
    required super.oldPosition,
    required this.tabBar,
  }) : super(initialPixels: null);

  final _TabBarState tabBar;

  bool _viewportDimensionWasNonZero = false;

  // The scroll position should be adjusted at least once.
  bool _needsPixelsCorrection = true;

  @override
  bool applyContentDimensions(double minScrollExtent, double maxScrollExtent) {
    bool result = true;
    if (!_viewportDimensionWasNonZero) {
      _viewportDimensionWasNonZero = viewportDimension != 0.0;
    }
    // If the viewport never had a non-zero dimension, we just want to jump
    // to the initial scroll position to avoid strange scrolling effects in
    // release mode: the viewport temporarily may have a dimension of zero
    // before the actual dimension is calculated. In that scenario, setting
    // the actual dimension would cause a strange scroll effect without this
    // guard because the super call below would start a ballistic scroll activity.
    if (!_viewportDimensionWasNonZero || _needsPixelsCorrection) {
      _needsPixelsCorrection = false;
      correctPixels(tabBar._initialScrollOffset(viewportDimension, minScrollExtent, maxScrollExtent));
      result = false;
    }
    return super.applyContentDimensions(minScrollExtent, maxScrollExtent) && result;
  }

  void markNeedsPixelsCorrection() {
    _needsPixelsCorrection = true;
  }
}

// This class, and TabBarScrollPosition, only exist to handle the case
// where a scrollable TabBar has a non-zero initialIndex.
class _TabBarScrollController extends ScrollController {
  _TabBarScrollController(this.tabBar);

  final _TabBarState tabBar;

  @override
  ScrollPosition createScrollPosition(ScrollPhysics physics, ScrollContext context, ScrollPosition? oldPosition) =>
      _TabBarScrollPosition(physics: physics, context: context, oldPosition: oldPosition, tabBar: tabBar);
}

class TabBar extends StatefulWidget implements PreferredSizeWidget {
  const TabBar({
    required this.tabs,
    super.key,
    this.controller,
    this.isScrollable = false,
    this.padding,
    this.indicatorColor,
    this.automaticIndicatorColorAdjustment = true,
    this.indicatorWeight = 2.0,
    this.indicatorPadding = EdgeInsets.zero,
    this.indicator,
    this.indicatorSize,
    this.dividerColor,
    this.dividerHeight,
    this.labelColor,
    this.labelStyle,
    this.labelPadding,
    this.unselectedLabelColor,
    this.unselectedLabelStyle,
    this.dragStartBehavior = DragStartBehavior.start,
    this.overlayColor,
    this.mouseCursor,
    this.enableFeedback,
    this.onTap,
    this.physics,
    this.splashFactory,
    this.splashBorderRadius,
    this.tabAlignment,
    this.textScaler,
    this.indicatorAnimation,
  }) : _isPrimary = true,
       assert(indicator != null || (indicatorWeight > 0.0));

  const TabBar.secondary({
    required this.tabs,
    super.key,
    this.controller,
    this.isScrollable = false,
    this.padding,
    this.indicatorColor,
    this.automaticIndicatorColorAdjustment = true,
    this.indicatorWeight = 2.0,
    this.indicatorPadding = EdgeInsets.zero,
    this.indicator,
    this.indicatorSize,
    this.dividerColor,
    this.dividerHeight,
    this.labelColor,
    this.labelStyle,
    this.labelPadding,
    this.unselectedLabelColor,
    this.unselectedLabelStyle,
    this.dragStartBehavior = DragStartBehavior.start,
    this.overlayColor,
    this.mouseCursor,
    this.enableFeedback,
    this.onTap,
    this.physics,
    this.splashFactory,
    this.splashBorderRadius,
    this.tabAlignment,
    this.textScaler,
    this.indicatorAnimation,
  }) : _isPrimary = false,
       assert(indicator != null || (indicatorWeight > 0.0));

  final List<Widget> tabs;

  final TabController? controller;

  final bool isScrollable;

  final EdgeInsetsGeometry? padding;

  final Color? indicatorColor;

  final double indicatorWeight;

  final EdgeInsetsGeometry indicatorPadding;

  final Decoration? indicator;

  final bool automaticIndicatorColorAdjustment;

  final TabBarIndicatorSize? indicatorSize;

  final Color? dividerColor;

  final double? dividerHeight;

  final Color? labelColor;

  final Color? unselectedLabelColor;

  final TextStyle? labelStyle;

  final TextStyle? unselectedLabelStyle;

  final EdgeInsetsGeometry? labelPadding;

  final WidgetStateProperty<Color?>? overlayColor;

  final DragStartBehavior dragStartBehavior;

  final MouseCursor? mouseCursor;

  final bool? enableFeedback;

  final ValueChanged<int>? onTap;

  final ScrollPhysics? physics;

  final InteractiveInkFeatureFactory? splashFactory;

  final BorderRadius? splashBorderRadius;

  final TabAlignment? tabAlignment;

  final TextScaler? textScaler;

  final TabIndicatorAnimation? indicatorAnimation;

  @override
  Size get preferredSize {
    double maxHeight = _kTabHeight;
    for (final Widget item in tabs) {
      if (item is PreferredSizeWidget) {
        final double itemHeight = item.preferredSize.height;
        maxHeight = math.max(itemHeight, maxHeight);
      }
    }
    return Size.fromHeight(maxHeight + indicatorWeight);
  }

  bool get tabHasTextAndIcon {
    for (final Widget item in tabs) {
      if (item is PreferredSizeWidget) {
        if (item.preferredSize.height == _kTextAndIconTabHeight) {
          return true;
        }
      }
    }
    return false;
  }

  final bool _isPrimary;

  @override
  State<TabBar> createState() => _TabBarState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TabController?>('controller', controller));
    properties.add(DiagnosticsProperty<bool>('isScrollable', isScrollable));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('padding', padding));
    properties.add(ColorProperty('indicatorColor', indicatorColor));
    properties.add(DoubleProperty('indicatorWeight', indicatorWeight));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('indicatorPadding', indicatorPadding));
    properties.add(DiagnosticsProperty<Decoration?>('indicator', indicator));
    properties.add(DiagnosticsProperty<bool>('automaticIndicatorColorAdjustment', automaticIndicatorColorAdjustment));
    properties.add(EnumProperty<TabBarIndicatorSize?>('indicatorSize', indicatorSize));
    properties.add(ColorProperty('dividerColor', dividerColor));
    properties.add(DoubleProperty('dividerHeight', dividerHeight));
    properties.add(ColorProperty('labelColor', labelColor));
    properties.add(ColorProperty('unselectedLabelColor', unselectedLabelColor));
    properties.add(DiagnosticsProperty<TextStyle?>('labelStyle', labelStyle));
    properties.add(DiagnosticsProperty<TextStyle?>('unselectedLabelStyle', unselectedLabelStyle));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('labelPadding', labelPadding));
    properties.add(DiagnosticsProperty<WidgetStateProperty<Color?>?>('overlayColor', overlayColor));
    properties.add(EnumProperty<DragStartBehavior>('dragStartBehavior', dragStartBehavior));
    properties.add(DiagnosticsProperty<MouseCursor?>('mouseCursor', mouseCursor));
    properties.add(DiagnosticsProperty<bool?>('enableFeedback', enableFeedback));
    properties.add(ObjectFlagProperty<ValueChanged<int>?>.has('onTap', onTap));
    properties.add(DiagnosticsProperty<ScrollPhysics?>('physics', physics));
    properties.add(DiagnosticsProperty<InteractiveInkFeatureFactory?>('splashFactory', splashFactory));
    properties.add(DiagnosticsProperty<BorderRadius?>('splashBorderRadius', splashBorderRadius));
    properties.add(EnumProperty<TabAlignment?>('tabAlignment', tabAlignment));
    properties.add(DiagnosticsProperty<TextScaler?>('textScaler', textScaler));
    properties.add(EnumProperty<TabIndicatorAnimation?>('indicatorAnimation', indicatorAnimation));
    properties.add(DiagnosticsProperty<bool>('tabHasTextAndIcon', tabHasTextAndIcon));
  }
}

class _TabBarState extends State<TabBar> {
  ScrollController? _scrollController;
  TabController? _controller;
  _IndicatorPainter? _indicatorPainter;
  int? _currentIndex;
  late double _tabStripWidth;
  late List<GlobalKey> _tabKeys;
  late List<EdgeInsetsGeometry> _labelPaddings;
  bool _debugHasScheduledValidTabsCountCheck = false;

  @override
  void initState() {
    super.initState();
    // If indicatorSize is TabIndicatorSize.label, _tabKeys[i] is used to find
    // the width of tab widget i. See _IndicatorPainter.indicatorRect().
    _tabKeys = widget.tabs.map((tab) => GlobalKey()).toList();
    _labelPaddings = List<EdgeInsetsGeometry>.filled(widget.tabs.length, EdgeInsets.zero, growable: true);
  }

  TabBarThemeData get _defaults =>
      widget._isPrimary
          ? _TabsPrimaryDefaultsM3(context, widget.isScrollable)
          : _TabsSecondaryDefaultsM3(context, widget.isScrollable);

  Decoration _getIndicator(TabBarIndicatorSize indicatorSize) {
    final ThemeData theme = Theme.of(context);
    final TabBarThemeData tabBarTheme = TabBarTheme.of(context);

    if (widget.indicator != null) {
      return widget.indicator!;
    }
    if (tabBarTheme.indicator != null) {
      return tabBarTheme.indicator!;
    }

    Color color = widget.indicatorColor ?? tabBarTheme.indicatorColor ?? _defaults.indicatorColor!;
    // ThemeData tries to avoid this by having indicatorColor avoid being the
    // primaryColor. However, it's possible that the tab bar is on a
    // Material that isn't the primaryColor. In that case, if the indicator
    // color ends up matching the material's color, then this overrides it.
    // When that happens, automatic transitions of the theme will likely look
    // ugly as the indicator color suddenly snaps to white at one end, but it's
    // not clear how to avoid that any further.
    //
    // The material's color might be null (if it's a transparency). In that case
    // there's no good way for us to find out what the color is so we don't.
    //
    // TODO(xu-baolin): Remove automatic adjustment to white color indicator
    // with a better long-term solution.
    // https://github.com/flutter/flutter/pull/68171#pullrequestreview-517753917
    if (widget.automaticIndicatorColorAdjustment && color.value == Material.maybeOf(context)?.color?.value) {
      color = Colors.white;
    }

    final double effectiveIndicatorWeight = math.max(widget.indicatorWeight, switch (widget._isPrimary) {
      true => _TabsPrimaryDefaultsM3.indicatorWeight(indicatorSize),
      false => _TabsSecondaryDefaultsM3.indicatorWeight,
    });
    // Only Material 3 primary TabBar with label indicatorSize should be rounded.
    final bool primaryWithLabelIndicator = switch (indicatorSize) {
      TabBarIndicatorSize.label => widget._isPrimary,
      TabBarIndicatorSize.tab => false,
    };
    final BorderRadius? effectiveBorderRadius =
        primaryWithLabelIndicator
            ? BorderRadius.only(
              topLeft: Radius.circular(effectiveIndicatorWeight),
              topRight: Radius.circular(effectiveIndicatorWeight),
            )
            : null;
    return UnderlineTabIndicator(
      borderRadius: effectiveBorderRadius,
      borderSide: BorderSide(
        // TODO(tahatesser): Make sure this value matches Material 3 Tabs spec
        // when `preferredSize`and `indicatorWeight` are updated to support Material 3
        // https://m3.material.io/components/tabs/specs#149a189f-9039-4195-99da-15c205d20e30,
        // https://github.com/flutter/flutter/issues/116136
        width: effectiveIndicatorWeight,
        color: color,
      ),
    );
  }

  // If the TabBar is rebuilt with a new tab controller, the caller should
  // dispose the old one. In that case the old controller's animation will be
  // null and should not be accessed.
  bool get _controllerIsValid => _controller?.animation != null;

  void _updateTabController() {
    final TabController? newController = widget.controller ?? DefaultTabController.maybeOf(context);
    assert(() {
      if (newController == null) {
        throw FlutterError(
          'No TabController for ${widget.runtimeType}.\n'
          'When creating a ${widget.runtimeType}, you must either provide an explicit '
          'TabController using the "controller" property, or you must ensure that there '
          'is a DefaultTabController above the ${widget.runtimeType}.\n'
          'In this case, there was neither an explicit controller nor a default controller.',
        );
      }
      return true;
    }());

    if (newController == _controller) {
      return;
    }

    if (_controllerIsValid) {
      _controller!.animation!.removeListener(_handleTabControllerAnimationTick);
      _controller!.removeListener(_handleTabControllerTick);
    }
    _controller = newController;
    if (_controller != null) {
      _controller!.animation!.addListener(_handleTabControllerAnimationTick);
      _controller!.addListener(_handleTabControllerTick);
      _currentIndex = _controller!.index;
    }
  }

  void _initIndicatorPainter() {
    final ThemeData theme = Theme.of(context);
    final TabBarThemeData tabBarTheme = TabBarTheme.of(context);
    final TabBarIndicatorSize indicatorSize =
        widget.indicatorSize ?? tabBarTheme.indicatorSize ?? _defaults.indicatorSize!;

    final _IndicatorPainter? oldPainter = _indicatorPainter;

    final TabIndicatorAnimation defaultTabIndicatorAnimation = switch (indicatorSize) {
      TabBarIndicatorSize.label => TabIndicatorAnimation.elastic,
      TabBarIndicatorSize.tab => TabIndicatorAnimation.linear,
    };

    _indicatorPainter =
        !_controllerIsValid
            ? null
            : _IndicatorPainter(
              controller: _controller!,
              indicator: _getIndicator(indicatorSize),
              indicatorSize: indicatorSize,
              indicatorPadding: widget.indicatorPadding,
              tabKeys: _tabKeys,
              // Passing old painter so that the constructor can copy some values from it.
              old: oldPainter,
              labelPaddings: _labelPaddings,
              dividerColor: widget.dividerColor ?? tabBarTheme.dividerColor ?? _defaults.dividerColor,
              dividerHeight: widget.dividerHeight ?? tabBarTheme.dividerHeight ?? _defaults.dividerHeight,
              showDivider: !widget.isScrollable,
              devicePixelRatio: MediaQuery.devicePixelRatioOf(context),
              indicatorAnimation:
                  widget.indicatorAnimation ?? tabBarTheme.indicatorAnimation ?? defaultTabIndicatorAnimation,
              textDirection: Directionality.of(context),
            );

    oldPainter?.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    assert(debugCheckHasMaterial(context));
    _updateTabController();
    _initIndicatorPainter();
  }

  @override
  void didUpdateWidget(TabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _updateTabController();
      _initIndicatorPainter();
      // Adjust scroll position.
      if (_scrollController != null && _scrollController!.hasClients) {
        final ScrollPosition position = _scrollController!.position;
        if (position is _TabBarScrollPosition) {
          position.markNeedsPixelsCorrection();
        }
      }
    } else if (widget.indicatorColor != oldWidget.indicatorColor ||
        widget.indicatorWeight != oldWidget.indicatorWeight ||
        widget.indicatorSize != oldWidget.indicatorSize ||
        widget.indicatorPadding != oldWidget.indicatorPadding ||
        widget.indicator != oldWidget.indicator ||
        widget.dividerColor != oldWidget.dividerColor ||
        widget.dividerHeight != oldWidget.dividerHeight ||
        widget.indicatorAnimation != oldWidget.indicatorAnimation) {
      _initIndicatorPainter();
    }

    if (widget.tabs.length > _tabKeys.length) {
      final int delta = widget.tabs.length - _tabKeys.length;
      _tabKeys.addAll(List<GlobalKey>.generate(delta, (n) => GlobalKey()));
      _labelPaddings.addAll(List<EdgeInsetsGeometry>.filled(delta, EdgeInsets.zero));
    } else if (widget.tabs.length < _tabKeys.length) {
      _tabKeys.removeRange(widget.tabs.length, _tabKeys.length);
      _labelPaddings.removeRange(widget.tabs.length, _tabKeys.length);
    }
  }

  @override
  void dispose() {
    _indicatorPainter!.dispose();
    if (_controllerIsValid) {
      _controller!.animation!.removeListener(_handleTabControllerAnimationTick);
      _controller!.removeListener(_handleTabControllerTick);
    }
    _controller = null;
    _scrollController?.dispose();
    // We don't own the _controller Animation, so it's not disposed here.
    super.dispose();
  }

  int get maxTabIndex => _indicatorPainter!.maxTabIndex;

  double _tabScrollOffset(int index, double viewportWidth, double minExtent, double maxExtent) {
    if (!widget.isScrollable) {
      return 0.0;
    }
    double tabCenter = _indicatorPainter!.centerOf(index);
    double paddingStart;
    switch (Directionality.of(context)) {
      case TextDirection.rtl:
        paddingStart = widget.padding?.resolve(TextDirection.rtl).right ?? 0;
        tabCenter = _tabStripWidth - tabCenter;
      case TextDirection.ltr:
        paddingStart = widget.padding?.resolve(TextDirection.ltr).left ?? 0;
    }

    return clampDouble(tabCenter + paddingStart - viewportWidth / 2.0, minExtent, maxExtent);
  }

  double _tabCenteredScrollOffset(int index) {
    final ScrollPosition position = _scrollController!.position;
    return _tabScrollOffset(index, position.viewportDimension, position.minScrollExtent, position.maxScrollExtent);
  }

  double _initialScrollOffset(double viewportWidth, double minExtent, double maxExtent) =>
      _tabScrollOffset(_currentIndex!, viewportWidth, minExtent, maxExtent);

  void _scrollToCurrentIndex() {
    final double offset = _tabCenteredScrollOffset(_currentIndex!);
    _scrollController!.animateTo(offset, duration: kTabScrollDuration, curve: Curves.ease);
  }

  void _scrollToControllerValue() {
    final double? leadingPosition = _currentIndex! > 0 ? _tabCenteredScrollOffset(_currentIndex! - 1) : null;
    final double middlePosition = _tabCenteredScrollOffset(_currentIndex!);
    final double? trailingPosition = _currentIndex! < maxTabIndex ? _tabCenteredScrollOffset(_currentIndex! + 1) : null;

    final double index = _controller!.index.toDouble();
    final double value = _controller!.animation!.value;
    final double offset = switch (value - index) {
      -1.0 => leadingPosition ?? middlePosition,
      1.0 => trailingPosition ?? middlePosition,
      0 => middlePosition,
      < 0 => leadingPosition == null ? middlePosition : lerpDouble(middlePosition, leadingPosition, index - value)!,
      _ => trailingPosition == null ? middlePosition : lerpDouble(middlePosition, trailingPosition, value - index)!,
    };

    _scrollController!.jumpTo(offset);
  }

  void _handleTabControllerAnimationTick() {
    assert(mounted);
    if (!_controller!.indexIsChanging && widget.isScrollable) {
      // Sync the TabBar's scroll position with the TabBarView's PageView.
      _currentIndex = _controller!.index;
      _scrollToControllerValue();
    }
  }

  void _handleTabControllerTick() {
    if (_controller!.index != _currentIndex) {
      _currentIndex = _controller!.index;
      if (widget.isScrollable) {
        _scrollToCurrentIndex();
      }
    }
    setState(() {
      // Rebuild the tabs after a (potentially animated) index change
      // has completed.
    });
  }

  // Called each time layout completes.
  void _saveTabOffsets(List<double> tabOffsets, TextDirection textDirection, double width) {
    _tabStripWidth = width;
    _indicatorPainter?.saveTabOffsets(tabOffsets, textDirection);
  }

  void _handleTap(int index) {
    assert(index >= 0 && index < widget.tabs.length);
    _controller!.animateTo(index);
    widget.onTap?.call(index);
  }

  Widget _buildStyledTab(Widget child, bool isSelected, Animation<double> animation, TabBarThemeData defaults) =>
      _TabStyle(
        animation: animation,
        isSelected: isSelected,
        isPrimary: widget._isPrimary,
        labelColor: widget.labelColor,
        unselectedLabelColor: widget.unselectedLabelColor,
        labelStyle: widget.labelStyle,
        unselectedLabelStyle: widget.unselectedLabelStyle,
        defaults: defaults,
        child: child,
      );

  bool _debugScheduleCheckHasValidTabsCount() {
    if (_debugHasScheduledValidTabsCountCheck) {
      return true;
    }
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      _debugHasScheduledValidTabsCountCheck = false;
      if (!mounted) {
        return;
      }
      assert(() {
        if (_controller!.length != widget.tabs.length) {
          throw FlutterError(
            "Controller's length property (${_controller!.length}) does not match the "
            "number of tabs (${widget.tabs.length}) present in TabBar's tabs property.",
          );
        }
        return true;
      }());
    }, debugLabel: 'TabBar.tabsCountCheck');
    _debugHasScheduledValidTabsCountCheck = true;
    return true;
  }

  bool _debugTabAlignmentIsValid(TabAlignment tabAlignment) {
    assert(() {
      if (widget.isScrollable && tabAlignment == TabAlignment.fill) {
        throw FlutterError('$tabAlignment is only valid for non-scrollable tab bars.');
      }
      if (!widget.isScrollable && (tabAlignment == TabAlignment.start || tabAlignment == TabAlignment.startOffset)) {
        throw FlutterError('$tabAlignment is only valid for scrollable tab bars.');
      }
      return true;
    }());
    return true;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    assert(_debugScheduleCheckHasValidTabsCount());
    final ThemeData theme = Theme.of(context);
    final TabBarThemeData tabBarTheme = TabBarTheme.of(context);
    final TabAlignment effectiveTabAlignment =
        widget.tabAlignment ?? tabBarTheme.tabAlignment ?? _defaults.tabAlignment!;
    assert(_debugTabAlignmentIsValid(effectiveTabAlignment));

    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    if (_controller!.length == 0) {
      return LimitedBox(
        maxWidth: 0.0,
        child: SizedBox(width: double.infinity, height: _kTabHeight + widget.indicatorWeight),
      );
    }

    final List<Widget> wrappedTabs = List<Widget>.generate(widget.tabs.length, (index) {
      EdgeInsetsGeometry padding = widget.labelPadding ?? tabBarTheme.labelPadding ?? kTabLabelPadding;
      const double verticalAdjustment = (_kTextAndIconTabHeight - _kTabHeight) / 2.0;

      final Widget tab = widget.tabs[index];
      if (tab is PreferredSizeWidget && tab.preferredSize.height == _kTabHeight && widget.tabHasTextAndIcon) {
        padding = padding.add(const EdgeInsets.symmetric(vertical: verticalAdjustment));
      }
      _labelPaddings[index] = padding;

      return Center(
        heightFactor: 1.0,
        child: Padding(
          padding: _labelPaddings[index],
          child: KeyedSubtree(key: _tabKeys[index], child: widget.tabs[index]),
        ),
      );
    });

    // If the controller was provided by DefaultTabController and we're part
    // of a Hero (typically the AppBar), then we will not be able to find the
    // controller during a Hero transition. See https://github.com/flutter/flutter/issues/213.
    if (_controller != null) {
      final int previousIndex = _controller!.previousIndex;

      if (_controller!.indexIsChanging) {
        // The user tapped on a tab, the tab controller's animation is running.
        assert(_currentIndex != previousIndex);
        final Animation<double> animation = _ChangeAnimation(_controller!);
        wrappedTabs[_currentIndex!] = _buildStyledTab(wrappedTabs[_currentIndex!], true, animation, _defaults);
        wrappedTabs[previousIndex] = _buildStyledTab(wrappedTabs[previousIndex], false, animation, _defaults);
      } else {
        // The user is dragging the TabBarView's PageView left or right.
        final int tabIndex = _currentIndex!;
        final Animation<double> centerAnimation = _DragAnimation(_controller!, tabIndex);
        wrappedTabs[tabIndex] = _buildStyledTab(wrappedTabs[tabIndex], true, centerAnimation, _defaults);
        if (_currentIndex! > 0) {
          final int tabIndex = _currentIndex! - 1;
          final Animation<double> previousAnimation = ReverseAnimation(_DragAnimation(_controller!, tabIndex));
          wrappedTabs[tabIndex] = _buildStyledTab(wrappedTabs[tabIndex], false, previousAnimation, _defaults);
        }
        if (_currentIndex! < widget.tabs.length - 1) {
          final int tabIndex = _currentIndex! + 1;
          final Animation<double> nextAnimation = ReverseAnimation(_DragAnimation(_controller!, tabIndex));
          wrappedTabs[tabIndex] = _buildStyledTab(wrappedTabs[tabIndex], false, nextAnimation, _defaults);
        }
      }
    }

    // Add the tap handler to each tab. If the tab bar is not scrollable,
    // then give all of the tabs equal flexibility so that they each occupy
    // the same share of the tab bar's overall width.
    final int tabCount = widget.tabs.length;
    for (int index = 0; index < tabCount; index += 1) {
      final Set<WidgetState> selectedState = <WidgetState>{if (index == _currentIndex) WidgetState.selected};

      final MouseCursor effectiveMouseCursor =
          WidgetStateProperty.resolveAs<MouseCursor?>(widget.mouseCursor, selectedState) ??
          tabBarTheme.mouseCursor?.resolve(selectedState) ??
          WidgetStateMouseCursor.clickable.resolve(selectedState);

      final WidgetStateProperty<Color?> defaultOverlay = WidgetStateProperty.resolveWith<Color?>((states) {
        final Set<WidgetState> effectiveStates = selectedState..addAll(states);
        return _defaults.overlayColor?.resolve(effectiveStates);
      });
      wrappedTabs[index] = InkWell(
        mouseCursor: effectiveMouseCursor,
        onTap: () {
          _handleTap(index);
        },
        enableFeedback: widget.enableFeedback ?? true,
        overlayColor: widget.overlayColor ?? tabBarTheme.overlayColor ?? defaultOverlay,
        splashFactory: widget.splashFactory ?? tabBarTheme.splashFactory ?? _defaults.splashFactory,
        borderRadius: widget.splashBorderRadius ?? tabBarTheme.splashBorderRadius ?? _defaults.splashBorderRadius,
        child: Padding(
          padding: EdgeInsets.only(bottom: widget.indicatorWeight),
          child: Stack(
            children: <Widget>[
              wrappedTabs[index],
              Semantics(
                role: SemanticsRole.tab,
                selected: index == _currentIndex,
                label: kIsWeb ? null : localizations.tabLabel(tabIndex: index + 1, tabCount: tabCount),
              ),
            ],
          ),
        ),
      );
      if (!widget.isScrollable && effectiveTabAlignment == TabAlignment.fill) {
        wrappedTabs[index] = Expanded(child: wrappedTabs[index]);
      }
    }

    Widget tabBar = Semantics(
      role: SemanticsRole.tabBar,
      container: true,
      explicitChildNodes: true,
      child: CustomPaint(
        painter: _indicatorPainter,
        child: _TabStyle(
          animation: kAlwaysDismissedAnimation,
          isSelected: false,
          isPrimary: widget._isPrimary,
          labelColor: widget.labelColor,
          unselectedLabelColor: widget.unselectedLabelColor,
          labelStyle: widget.labelStyle,
          unselectedLabelStyle: widget.unselectedLabelStyle,
          defaults: _defaults,
          child: _TabLabelBar(
            onPerformLayout: _saveTabOffsets,
            mainAxisSize: effectiveTabAlignment == TabAlignment.fill ? MainAxisSize.max : MainAxisSize.min,
            children: wrappedTabs,
          ),
        ),
      ),
    );

    if (widget.isScrollable) {
      final EdgeInsetsGeometry? effectivePadding =
          effectiveTabAlignment == TabAlignment.startOffset
              ? const EdgeInsetsDirectional.only(start: _kStartOffset).add(widget.padding ?? EdgeInsets.zero)
              : widget.padding;
      _scrollController ??= _TabBarScrollController(this);
      tabBar = ScrollConfiguration(
        // The scrolling tabs should not show an overscroll indicator.
        behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
        child: SingleChildScrollView(
          dragStartBehavior: widget.dragStartBehavior,
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          padding: effectivePadding,
          physics: widget.physics,
          child: tabBar,
        ),
      );
      final AlignmentGeometry effectiveAlignment = switch (effectiveTabAlignment) {
        TabAlignment.center => Alignment.center,
        TabAlignment.start || TabAlignment.startOffset || TabAlignment.fill => AlignmentDirectional.centerStart,
      };

      final Color dividerColor = widget.dividerColor ?? tabBarTheme.dividerColor ?? _defaults.dividerColor!;
      final double dividerHeight = widget.dividerHeight ?? tabBarTheme.dividerHeight ?? _defaults.dividerHeight!;

      tabBar = Align(
        heightFactor: 1.0,
        widthFactor: dividerHeight > 0 ? null : 1.0,
        alignment: effectiveAlignment,
        child: tabBar,
      );

      if (dividerColor != Colors.transparent && dividerHeight > 0) {
        tabBar = CustomPaint(
          painter: _DividerPainter(dividerColor: dividerColor, dividerHeight: dividerHeight),
          child: tabBar,
        );
      }
    } else if (widget.padding != null) {
      tabBar = Padding(padding: widget.padding!, child: tabBar);
    }

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: widget.textScaler ?? tabBarTheme.textScaler),
      child: tabBar,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('maxTabIndex', maxTabIndex));
  }
}

class TabBarView extends StatefulWidget {
  const TabBarView({
    required this.children,
    super.key,
    this.controller,
    this.physics,
    this.dragStartBehavior = DragStartBehavior.start,
    this.viewportFraction = 1.0,
    this.clipBehavior = Clip.hardEdge,
  });

  final TabController? controller;

  final List<Widget> children;

  final ScrollPhysics? physics;

  final DragStartBehavior dragStartBehavior;

  final double viewportFraction;

  final Clip clipBehavior;

  @override
  State<TabBarView> createState() => _TabBarViewState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TabController?>('controller', controller));
    properties.add(DiagnosticsProperty<ScrollPhysics?>('physics', physics));
    properties.add(EnumProperty<DragStartBehavior>('dragStartBehavior', dragStartBehavior));
    properties.add(DoubleProperty('viewportFraction', viewportFraction));
    properties.add(EnumProperty<Clip>('clipBehavior', clipBehavior));
  }
}

class _TabBarViewState extends State<TabBarView> {
  TabController? _controller;
  PageController? _pageController;
  late List<Widget> _childrenWithKey;
  int? _currentIndex;
  int _warpUnderwayCount = 0;
  int _scrollUnderwayCount = 0;
  bool _debugHasScheduledValidChildrenCountCheck = false;

  // If the TabBarView is rebuilt with a new tab controller, the caller should
  // dispose the old one. In that case the old controller's animation will be
  // null and should not be accessed.
  bool get _controllerIsValid => _controller?.animation != null;

  void _updateTabController() {
    final TabController? newController = widget.controller ?? DefaultTabController.maybeOf(context);
    assert(() {
      if (newController == null) {
        throw FlutterError(
          'No TabController for ${widget.runtimeType}.\n'
          'When creating a ${widget.runtimeType}, you must either provide an explicit '
          'TabController using the "controller" property, or you must ensure that there '
          'is a DefaultTabController above the ${widget.runtimeType}.\n'
          'In this case, there was neither an explicit controller nor a default controller.',
        );
      }
      return true;
    }());

    if (newController == _controller) {
      return;
    }

    if (_controllerIsValid) {
      _controller!.animation!.removeListener(_handleTabControllerAnimationTick);
    }
    _controller = newController;
    if (_controller != null) {
      _controller!.animation!.addListener(_handleTabControllerAnimationTick);
    }
  }

  void _jumpToPage(int page) {
    _warpUnderwayCount += 1;
    _pageController!.jumpToPage(page);
    _warpUnderwayCount -= 1;
  }

  Future<void> _animateToPage(int page, {required Duration duration, required Curve curve}) async {
    _warpUnderwayCount += 1;
    await _pageController!.animateToPage(page, duration: duration, curve: curve);
    _warpUnderwayCount -= 1;
  }

  @override
  void initState() {
    super.initState();
    _updateChildren();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateTabController();
    _currentIndex = _controller!.index;
    if (_pageController == null) {
      _pageController = PageController(initialPage: _currentIndex!, viewportFraction: widget.viewportFraction);
    } else {
      _pageController!.jumpToPage(_currentIndex!);
    }
  }

  @override
  void didUpdateWidget(TabBarView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _updateTabController();
      _currentIndex = _controller!.index;
      _jumpToPage(_currentIndex!);
    }
    if (widget.viewportFraction != oldWidget.viewportFraction) {
      _pageController?.dispose();
      _pageController = PageController(initialPage: _currentIndex!, viewportFraction: widget.viewportFraction);
    }
    // While a warp is under way, we stop updating the tab page contents.
    // This is tracked in https://github.com/flutter/flutter/issues/31269.
    if (widget.children != oldWidget.children && _warpUnderwayCount == 0) {
      _updateChildren();
    }
  }

  @override
  void dispose() {
    if (_controllerIsValid) {
      _controller!.animation!.removeListener(_handleTabControllerAnimationTick);
    }
    _controller = null;
    _pageController?.dispose();
    // We don't own the _controller Animation, so it's not disposed here.
    super.dispose();
  }

  void _updateChildren() {
    _childrenWithKey = KeyedSubtree.ensureUniqueKeysForList(
      widget.children.map<Widget>((child) => Semantics(role: SemanticsRole.tabPanel, child: child)).toList(),
    );
  }

  void _handleTabControllerAnimationTick() {
    if (_scrollUnderwayCount > 0 || !_controller!.indexIsChanging) {
      return;
    } // This widget is driving the controller's animation.

    if (_controller!.index != _currentIndex) {
      _currentIndex = _controller!.index;
      _warpToCurrentIndex();
    }
  }

  void _warpToCurrentIndex() {
    if (!mounted || _pageController!.page == _currentIndex!.toDouble()) {
      return;
    }

    final bool adjacentDestination = (_currentIndex! - _controller!.previousIndex).abs() == 1;
    if (adjacentDestination) {
      _warpToAdjacentTab(_controller!.animationDuration);
    } else {
      _warpToNonAdjacentTab(_controller!.animationDuration);
    }
  }

  Future<void> _warpToAdjacentTab(Duration duration) async {
    if (duration == Duration.zero) {
      _jumpToPage(_currentIndex!);
    } else {
      await _animateToPage(_currentIndex!, duration: duration, curve: Curves.ease);
    }
    if (mounted) {
      setState(_updateChildren);
    }
    return Future<void>.value();
  }

  Future<void> _warpToNonAdjacentTab(Duration duration) async {
    final int previousIndex = _controller!.previousIndex;
    assert((_currentIndex! - previousIndex).abs() > 1);

    // initialPage defines which page is shown when starting the animation.
    // This page is adjacent to the destination page.
    final int initialPage = _currentIndex! > previousIndex ? _currentIndex! - 1 : _currentIndex! + 1;

    setState(() {
      // Needed for `RenderSliverMultiBoxAdaptor.move` and kept alive children.
      // For motivation, see https://github.com/flutter/flutter/pull/29188 and
      // https://github.com/flutter/flutter/issues/27010#issuecomment-486475152.
      _childrenWithKey = List<Widget>.of(_childrenWithKey, growable: false);
      final Widget temp = _childrenWithKey[initialPage];
      _childrenWithKey[initialPage] = _childrenWithKey[previousIndex];
      _childrenWithKey[previousIndex] = temp;
    });

    // Make a first jump to the adjacent page.
    _jumpToPage(initialPage);

    // Jump or animate to the destination page.
    if (duration == Duration.zero) {
      _jumpToPage(_currentIndex!);
    } else {
      await _animateToPage(_currentIndex!, duration: duration, curve: Curves.ease);
    }

    if (mounted) {
      setState(_updateChildren);
    }
  }

  void _syncControllerOffset() {
    _controller!.offset = clampDouble(_pageController!.page! - _controller!.index, -1.0, 1.0);
  }

  // Called when the PageView scrolls
  bool _handleScrollNotification(ScrollNotification notification) {
    if (_warpUnderwayCount > 0 || _scrollUnderwayCount > 0) {
      return false;
    }

    if (notification.depth != 0) {
      return false;
    }

    if (!_controllerIsValid) {
      return false;
    }

    _scrollUnderwayCount += 1;
    final double page = _pageController!.page!;
    if (notification is ScrollUpdateNotification && !_controller!.indexIsChanging) {
      final bool pageChanged = (page - _controller!.index).abs() > 1.0;
      if (pageChanged) {
        _controller!.index = page.round();
        _currentIndex = _controller!.index;
      }
      _syncControllerOffset();
    } else if (notification is ScrollEndNotification) {
      _controller!.index = page.round();
      _currentIndex = _controller!.index;
      if (!_controller!.indexIsChanging) {
        _syncControllerOffset();
      }
    }
    _scrollUnderwayCount -= 1;

    return false;
  }

  bool _debugScheduleCheckHasValidChildrenCount() {
    if (_debugHasScheduledValidChildrenCountCheck) {
      return true;
    }
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      _debugHasScheduledValidChildrenCountCheck = false;
      if (!mounted) {
        return;
      }
      assert(() {
        if (_controller!.length != widget.children.length) {
          throw FlutterError(
            "Controller's length property (${_controller!.length}) does not match the "
            "number of children (${widget.children.length}) present in TabBarView's children property.",
          );
        }
        return true;
      }());
    }, debugLabel: 'TabBarView.validChildrenCountCheck');
    _debugHasScheduledValidChildrenCountCheck = true;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    assert(_debugScheduleCheckHasValidChildrenCount());

    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: PageView(
        dragStartBehavior: widget.dragStartBehavior,
        clipBehavior: widget.clipBehavior,
        controller: _pageController,
        physics:
            widget.physics == null
                ? const PageScrollPhysics().applyTo(const ClampingScrollPhysics())
                : const PageScrollPhysics().applyTo(widget.physics),
        children: _childrenWithKey,
      ),
    );
  }
}

class TabPageSelectorIndicator extends StatelessWidget {
  const TabPageSelectorIndicator({
    required this.backgroundColor,
    required this.borderColor,
    required this.size,
    super.key,
    this.borderStyle = BorderStyle.solid,
  });

  final Color backgroundColor;

  final Color borderColor;

  final double size;

  final BorderStyle borderStyle;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    margin: const EdgeInsets.all(4.0),
    decoration: BoxDecoration(
      color: backgroundColor,
      border: Border.all(color: borderColor, style: borderStyle),
      shape: BoxShape.circle,
    ),
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(ColorProperty('borderColor', borderColor));
    properties.add(DoubleProperty('size', size));
    properties.add(EnumProperty<BorderStyle>('borderStyle', borderStyle));
  }
}

class TabPageSelector extends StatefulWidget {
  const TabPageSelector({
    super.key,
    this.controller,
    this.indicatorSize = 12.0,
    this.color,
    this.selectedColor,
    this.borderStyle,
  }) : assert(indicatorSize > 0.0);

  final TabController? controller;

  final double indicatorSize;

  final Color? color;

  final Color? selectedColor;

  final BorderStyle? borderStyle;

  @override
  State<TabPageSelector> createState() => _TabPageSelectorState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TabController?>('controller', controller));
    properties.add(DoubleProperty('indicatorSize', indicatorSize));
    properties.add(ColorProperty('color', color));
    properties.add(ColorProperty('selectedColor', selectedColor));
    properties.add(EnumProperty<BorderStyle?>('borderStyle', borderStyle));
  }
}

class _TabPageSelectorState extends State<TabPageSelector> {
  TabController? _previousTabController;
  TabController get _tabController {
    final TabController? tabController = widget.controller ?? DefaultTabController.maybeOf(context);
    assert(() {
      if (tabController == null) {
        throw FlutterError(
          'No TabController for $runtimeType.\n'
          'When creating a $runtimeType, you must either provide an explicit TabController '
          'using the "controller" property, or you must ensure that there is a '
          'DefaultTabController above the $runtimeType.\n'
          'In this case, there was neither an explicit controller nor a default controller.',
        );
      }
      return true;
    }());
    return tabController!;
  }

  CurvedAnimation? _animation;

  @override
  void didUpdateWidget(TabPageSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_previousTabController?.animation != _tabController.animation) {
      _setAnimation();
    }
    if (_previousTabController != _tabController) {
      _previousTabController = _tabController;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_animation == null || _previousTabController?.animation != _tabController.animation) {
      _setAnimation();
    }
    if (_previousTabController != _tabController) {
      _previousTabController = _tabController;
    }
  }

  void _setAnimation() {
    _animation?.dispose();
    _animation = CurvedAnimation(parent: _tabController.animation!, curve: Curves.fastOutSlowIn);
  }

  @override
  void dispose() {
    _animation?.dispose();
    super.dispose();
  }

  Widget _buildTabIndicator(
    int tabIndex,
    TabController tabController,
    ColorTween selectedColorTween,
    ColorTween previousColorTween,
  ) {
    final Color background;
    if (tabController.indexIsChanging) {
      // The selection's animation is animating from previousValue to value.
      final double t = 1.0 - _indexChangeProgress(tabController);
      if (tabController.index == tabIndex) {
        background = selectedColorTween.lerp(t)!;
      } else if (tabController.previousIndex == tabIndex) {
        background = previousColorTween.lerp(t)!;
      } else {
        background = selectedColorTween.begin!;
      }
    } else {
      // The selection's offset reflects how far the TabBarView has / been dragged
      // to the previous page (-1.0 to 0.0) or the next page (0.0 to 1.0).
      final double offset = tabController.offset;
      if (tabController.index == tabIndex) {
        background = selectedColorTween.lerp(1.0 - offset.abs())!;
      } else if (tabController.index == tabIndex - 1 && offset > 0.0) {
        background = selectedColorTween.lerp(offset)!;
      } else if (tabController.index == tabIndex + 1 && offset < 0.0) {
        background = selectedColorTween.lerp(-offset)!;
      } else {
        background = selectedColorTween.begin!;
      }
    }
    return TabPageSelectorIndicator(
      backgroundColor: background,
      borderColor: selectedColorTween.end!,
      size: widget.indicatorSize,
      borderStyle: widget.borderStyle ?? BorderStyle.solid,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color fixColor = widget.color ?? Colors.transparent;
    final Color fixSelectedColor = widget.selectedColor ?? Theme.of(context).colorScheme.secondary;
    final ColorTween selectedColorTween = ColorTween(begin: fixColor, end: fixSelectedColor);
    final ColorTween previousColorTween = ColorTween(begin: fixSelectedColor, end: fixColor);
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    return AnimatedBuilder(
      animation: _animation!,
      builder:
          (context, child) => Semantics(
            label: localizations.tabLabel(tabIndex: _tabController.index + 1, tabCount: _tabController.length),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children:
                  List<Widget>.generate(
                    _tabController.length,
                    (tabIndex) => _buildTabIndicator(tabIndex, _tabController, selectedColorTween, previousColorTween),
                  ).toList(),
            ),
          ),
    );
  }
}

// BEGIN GENERATED TOKEN PROPERTIES - Tabs

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// dart format off
class _TabsPrimaryDefaultsM3 extends TabBarThemeData {
  _TabsPrimaryDefaultsM3(this.context, this.isScrollable)
    : super(indicatorSize: TabBarIndicatorSize.label);

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;
  late final TextTheme _textTheme = Theme.of(context).textTheme;
  final bool isScrollable;

  // This value comes from Divider widget defaults. Token db deprecated 'primary-navigation-tab.divider.color' token.
  @override
  Color? get dividerColor => _colors.outlineVariant;

  // This value comes from Divider widget defaults. Token db deprecated 'primary-navigation-tab.divider.height' token.
  @override
  double? get dividerHeight => 1.0;

  @override
  Color? get indicatorColor => _colors.primary;

  @override
  Color? get labelColor => _colors.primary;

  @override
  TextStyle? get labelStyle => _textTheme.titleSmall;

  @override
  Color? get unselectedLabelColor => _colors.onSurfaceVariant;

  @override
  TextStyle? get unselectedLabelStyle => _textTheme.titleSmall;

  @override
  WidgetStateProperty<Color?> get overlayColor => WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        if (states.contains(WidgetState.pressed)) {
          return _colors.primary.withValues(alpha:0.1);
        }
        if (states.contains(WidgetState.hovered)) {
          return _colors.primary.withValues(alpha:0.08);
        }
        if (states.contains(WidgetState.focused)) {
          return _colors.primary.withValues(alpha:0.1);
        }
        return null;
      }
      if (states.contains(WidgetState.pressed)) {
        return _colors.primary.withValues(alpha:0.1);
      }
      if (states.contains(WidgetState.hovered)) {
        return _colors.onSurface.withValues(alpha:0.08);
      }
      if (states.contains(WidgetState.focused)) {
        return _colors.onSurface.withValues(alpha:0.1);
      }
      return null;
    });

  @override
  InteractiveInkFeatureFactory? get splashFactory => Theme.of(context).splashFactory;

  @override
  TabAlignment? get tabAlignment => isScrollable ? TabAlignment.startOffset : TabAlignment.fill;

  static double indicatorWeight(TabBarIndicatorSize indicatorSize) => switch (indicatorSize) {
      TabBarIndicatorSize.label => 3.0,
      TabBarIndicatorSize.tab   => 2.0,
    };

  // TODO(davidmartos96): This value doesn't currently exist in
  // https://m3.material.io/components/tabs/specs
  // Update this when the token is available.
  static const EdgeInsetsGeometry iconMargin = EdgeInsets.only(bottom: 2);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BuildContext>('context', context));
    properties.add(DiagnosticsProperty<bool>('isScrollable', isScrollable));
  }
}

class _TabsSecondaryDefaultsM3 extends TabBarThemeData {
  _TabsSecondaryDefaultsM3(this.context, this.isScrollable)
    : super(indicatorSize: TabBarIndicatorSize.tab);

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;
  late final TextTheme _textTheme = Theme.of(context).textTheme;
  final bool isScrollable;

  // This value comes from Divider widget defaults. Token db deprecated 'secondary-navigation-tab.divider.color' token.
  @override
  Color? get dividerColor => _colors.outlineVariant;

  // This value comes from Divider widget defaults. Token db deprecated 'secondary-navigation-tab.divider.height' token.
  @override
  double? get dividerHeight => 1.0;

  @override
  Color? get indicatorColor => _colors.primary;

  @override
  Color? get labelColor => _colors.onSurface;

  @override
  TextStyle? get labelStyle => _textTheme.titleSmall;

  @override
  Color? get unselectedLabelColor => _colors.onSurfaceVariant;

  @override
  TextStyle? get unselectedLabelStyle => _textTheme.titleSmall;

  @override
  WidgetStateProperty<Color?> get overlayColor => WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        if (states.contains(WidgetState.pressed)) {
          return _colors.onSurface.withValues(alpha:0.1);
        }
        if (states.contains(WidgetState.hovered)) {
          return _colors.onSurface.withValues(alpha:0.08);
        }
        if (states.contains(WidgetState.focused)) {
          return _colors.onSurface.withValues(alpha:0.1);
        }
        return null;
      }
      if (states.contains(WidgetState.pressed)) {
        return _colors.onSurface.withValues(alpha:0.1);
      }
      if (states.contains(WidgetState.hovered)) {
        return _colors.onSurface.withValues(alpha:0.08);
      }
      if (states.contains(WidgetState.focused)) {
        return _colors.onSurface.withValues(alpha:0.1);
      }
      return null;
    });

  @override
  InteractiveInkFeatureFactory? get splashFactory => Theme.of(context).splashFactory;

  @override
  TabAlignment? get tabAlignment => isScrollable ? TabAlignment.startOffset : TabAlignment.fill;

  static double indicatorWeight = 2.0;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BuildContext>('context', context));
    properties.add(DiagnosticsProperty<bool>('isScrollable', isScrollable));
  }
}
// dart format on

// END GENERATED TOKEN PROPERTIES - Tabs
