// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:waveui/material/theme.dart' show ThemeData;
import 'package:waveui/material/theme_data.dart' show ThemeData;

import 'package:waveui/material/color_scheme.dart';
import 'package:waveui/material/colors.dart';
import 'package:waveui/material/elevation_overlay.dart';
import 'package:waveui/material/ink_well.dart';
import 'package:waveui/material/material.dart';
import 'package:waveui/material/material_localizations.dart';
import 'package:waveui/material/material_state.dart';
import 'package:waveui/material/navigation_bar_theme.dart';
import 'package:waveui/src/theme/text_theme.dart';
import 'package:waveui/material/theme.dart';
import 'package:waveui/material/tooltip.dart';
import 'package:waveui/waveui.dart' show ThemeData;

const double _kIndicatorHeight = 32;
const double _kIndicatorWidth = 64;
const double _kMaxLabelTextScaleFactor = 1.3;

// Examples can assume:
// late BuildContext context;
// late bool _isDrawerOpen;

class NavigationBar extends StatelessWidget {
  // TODO(goderbauer): This class cannot be const constructed, https://github.com/dart-lang/linter/issues/3366.
  // ignore: prefer_const_constructors_in_immutables
  NavigationBar({
    required this.destinations,
    super.key,
    this.animationDuration,
    this.selectedIndex = 0,
    this.onDestinationSelected,
    this.backgroundColor,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.indicatorColor,
    this.indicatorShape,
    this.height,
    this.labelBehavior,
    this.overlayColor,
    this.labelTextStyle,
    this.labelPadding,
    this.maintainBottomViewPadding = false,
  }) : assert(destinations.length >= 2),
       assert(0 <= selectedIndex && selectedIndex < destinations.length);

  final Duration? animationDuration;

  final int selectedIndex;

  final List<Widget> destinations;

  final ValueChanged<int>? onDestinationSelected;

  final Color? backgroundColor;

  final double? elevation;

  final Color? shadowColor;

  final Color? surfaceTintColor;

  final Color? indicatorColor;

  final ShapeBorder? indicatorShape;

  final double? height;

  final NavigationDestinationLabelBehavior? labelBehavior;

  final WidgetStateProperty<Color?>? overlayColor;

  final WidgetStateProperty<TextStyle?>? labelTextStyle;

  final EdgeInsetsGeometry? labelPadding;

  final bool maintainBottomViewPadding;

  VoidCallback _handleTap(int index) => onDestinationSelected != null ? () => onDestinationSelected!(index) : () {};

  @override
  Widget build(BuildContext context) {
    final NavigationBarThemeData defaults = _defaultsFor(context);

    final NavigationBarThemeData navigationBarTheme = NavigationBarTheme.of(context);
    final double effectiveHeight = height ?? navigationBarTheme.height ?? defaults.height!;
    final NavigationDestinationLabelBehavior effectiveLabelBehavior =
        labelBehavior ?? navigationBarTheme.labelBehavior ?? defaults.labelBehavior!;

    return Material(
      color: backgroundColor ?? navigationBarTheme.backgroundColor ?? defaults.backgroundColor!,
      elevation: elevation ?? navigationBarTheme.elevation ?? defaults.elevation!,
      shadowColor: shadowColor ?? navigationBarTheme.shadowColor ?? defaults.shadowColor,
      surfaceTintColor: surfaceTintColor ?? navigationBarTheme.surfaceTintColor ?? defaults.surfaceTintColor,
      child: SafeArea(
        maintainBottomViewPadding: maintainBottomViewPadding,
        child: SizedBox(
          height: effectiveHeight,
          child: Row(
            children: <Widget>[
              for (int i = 0; i < destinations.length; i++)
                Expanded(
                  child: _SelectableAnimatedBuilder(
                    duration: animationDuration ?? const Duration(milliseconds: 500),
                    isSelected: i == selectedIndex,
                    builder:
                        (context, animation) => _NavigationDestinationInfo(
                          index: i,
                          selectedIndex: selectedIndex,
                          totalNumberOfDestinations: destinations.length,
                          selectedAnimation: animation,
                          labelBehavior: effectiveLabelBehavior,
                          indicatorColor: indicatorColor,
                          indicatorShape: indicatorShape,
                          overlayColor: overlayColor,
                          onTap: _handleTap(i),
                          labelTextStyle: labelTextStyle,
                          labelPadding: labelPadding,
                          child: destinations[i],
                        ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Duration?>('animationDuration', animationDuration));
    properties.add(IntProperty('selectedIndex', selectedIndex));
    properties.add(ObjectFlagProperty<ValueChanged<int>?>.has('onDestinationSelected', onDestinationSelected));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(DoubleProperty('elevation', elevation));
    properties.add(ColorProperty('shadowColor', shadowColor));
    properties.add(ColorProperty('surfaceTintColor', surfaceTintColor));
    properties.add(ColorProperty('indicatorColor', indicatorColor));
    properties.add(DiagnosticsProperty<ShapeBorder?>('indicatorShape', indicatorShape));
    properties.add(DoubleProperty('height', height));
    properties.add(EnumProperty<NavigationDestinationLabelBehavior?>('labelBehavior', labelBehavior));
    properties.add(DiagnosticsProperty<WidgetStateProperty<Color?>?>('overlayColor', overlayColor));
    properties.add(DiagnosticsProperty<WidgetStateProperty<TextStyle?>?>('labelTextStyle', labelTextStyle));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('labelPadding', labelPadding));
    properties.add(DiagnosticsProperty<bool>('maintainBottomViewPadding', maintainBottomViewPadding));
  }
}

enum NavigationDestinationLabelBehavior { alwaysShow, alwaysHide, onlyShowSelected }

class NavigationDestination extends StatelessWidget {
  const NavigationDestination({
    required this.icon,
    required this.label,
    super.key,
    this.selectedIcon,
    this.tooltip,
    this.enabled = true,
  });

  final Widget icon;

  final Widget? selectedIcon;

  final String label;

  final String? tooltip;

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final _NavigationDestinationInfo info = _NavigationDestinationInfo.of(context);
    const Set<WidgetState> selectedState = <WidgetState>{WidgetState.selected};
    const Set<WidgetState> unselectedState = <WidgetState>{};
    const Set<WidgetState> disabledState = <WidgetState>{WidgetState.disabled};

    final NavigationBarThemeData navigationBarTheme = NavigationBarTheme.of(context);
    final NavigationBarThemeData defaults = _defaultsFor(context);
    final Animation<double> animation = info.selectedAnimation;

    return _NavigationDestinationBuilder(
      label: label,
      tooltip: tooltip,
      enabled: enabled,
      buildIcon: (context) {
        final IconThemeData selectedIconTheme =
            navigationBarTheme.iconTheme?.resolve(selectedState) ?? defaults.iconTheme!.resolve(selectedState)!;
        final IconThemeData unselectedIconTheme =
            navigationBarTheme.iconTheme?.resolve(unselectedState) ?? defaults.iconTheme!.resolve(unselectedState)!;
        final IconThemeData disabledIconTheme =
            navigationBarTheme.iconTheme?.resolve(disabledState) ?? defaults.iconTheme!.resolve(disabledState)!;

        final Widget selectedIconWidget = IconTheme.merge(
          data: enabled ? selectedIconTheme : disabledIconTheme,
          child: selectedIcon ?? icon,
        );
        final Widget unselectedIconWidget = IconTheme.merge(
          data: enabled ? unselectedIconTheme : disabledIconTheme,
          child: icon,
        );

        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            NavigationIndicator(
              animation: animation,
              color: info.indicatorColor ?? navigationBarTheme.indicatorColor ?? defaults.indicatorColor!,
              shape: info.indicatorShape ?? navigationBarTheme.indicatorShape ?? defaults.indicatorShape!,
            ),
            _StatusTransitionWidgetBuilder(
              animation: animation,
              builder: (context, child) => animation.isForwardOrCompleted ? selectedIconWidget : unselectedIconWidget,
            ),
          ],
        );
      },
      buildLabel: (context) {
        final TextStyle? effectiveSelectedLabelTextStyle =
            info.labelTextStyle?.resolve(selectedState) ??
            navigationBarTheme.labelTextStyle?.resolve(selectedState) ??
            defaults.labelTextStyle!.resolve(selectedState);
        final TextStyle? effectiveUnselectedLabelTextStyle =
            info.labelTextStyle?.resolve(unselectedState) ??
            navigationBarTheme.labelTextStyle?.resolve(unselectedState) ??
            defaults.labelTextStyle!.resolve(unselectedState);
        final TextStyle? effectiveDisabledLabelTextStyle =
            info.labelTextStyle?.resolve(disabledState) ??
            navigationBarTheme.labelTextStyle?.resolve(disabledState) ??
            defaults.labelTextStyle!.resolve(disabledState);
        final EdgeInsetsGeometry labelPadding =
            info.labelPadding ?? navigationBarTheme.labelPadding ?? defaults.labelPadding!;

        final TextStyle? textStyle =
            enabled
                ? animation.isForwardOrCompleted
                    ? effectiveSelectedLabelTextStyle
                    : effectiveUnselectedLabelTextStyle
                : effectiveDisabledLabelTextStyle;

        return Padding(
          padding: labelPadding,
          child: MediaQuery.withClampedTextScaling(
            // Set maximum text scale factor to _kMaxLabelTextScaleFactor for the
            // label to keep the visual hierarchy the same even with larger font
            // sizes. To opt out, wrap the [label] widget in a [MediaQuery] widget
            // with a different `TextScaler`.
            maxScaleFactor: _kMaxLabelTextScaleFactor,
            child: Text(label, style: textStyle),
          ),
        );
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('label', label));
    properties.add(StringProperty('tooltip', tooltip));
    properties.add(DiagnosticsProperty<bool>('enabled', enabled));
  }
}

class _NavigationDestinationBuilder extends StatefulWidget {
  const _NavigationDestinationBuilder({
    required this.buildIcon,
    required this.buildLabel,
    required this.label,
    this.tooltip,
    this.enabled = true,
  });

  final WidgetBuilder buildIcon;

  final WidgetBuilder buildLabel;

  final String label;

  final String? tooltip;

  final bool enabled;

  @override
  State<_NavigationDestinationBuilder> createState() => _NavigationDestinationBuilderState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<WidgetBuilder>.has('buildIcon', buildIcon));
    properties.add(ObjectFlagProperty<WidgetBuilder>.has('buildLabel', buildLabel));
    properties.add(StringProperty('label', label));
    properties.add(StringProperty('tooltip', tooltip));
    properties.add(DiagnosticsProperty<bool>('enabled', enabled));
  }
}

class _NavigationDestinationBuilderState extends State<_NavigationDestinationBuilder> {
  final GlobalKey iconKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final _NavigationDestinationInfo info = _NavigationDestinationInfo.of(context);
    final NavigationBarThemeData navigationBarTheme = NavigationBarTheme.of(context);
    final NavigationBarThemeData defaults = _defaultsFor(context);

    return _NavigationBarDestinationSemantics(
      child: _NavigationBarDestinationTooltip(
        message: widget.tooltip ?? widget.label,
        child: _IndicatorInkWell(
          iconKey: iconKey,
          labelBehavior: info.labelBehavior,
          customBorder: info.indicatorShape ?? navigationBarTheme.indicatorShape ?? defaults.indicatorShape,
          overlayColor: info.overlayColor ?? navigationBarTheme.overlayColor,
          onTap: widget.enabled ? info.onTap : null,
          child: Row(
            children: <Widget>[
              Expanded(
                child: _NavigationBarDestinationLayout(
                  icon: widget.buildIcon(context),
                  iconKey: iconKey,
                  label: widget.buildLabel(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<GlobalKey<State<StatefulWidget>>>('iconKey', iconKey));
  }
}

class _IndicatorInkWell extends InkResponse {
  const _IndicatorInkWell({
    required this.iconKey,
    required this.labelBehavior,
    super.overlayColor,
    super.customBorder,
    super.onTap,
    super.child,
  }) : super(containedInkWell: true, highlightColor: Colors.transparent);

  final GlobalKey iconKey;
  final NavigationDestinationLabelBehavior labelBehavior;

  @override
  RectCallback? getRectCallback(RenderBox referenceBox) => () {
    final RenderBox iconBox = iconKey.currentContext!.findRenderObject()! as RenderBox;
    final Rect iconRect = iconBox.localToGlobal(Offset.zero) & iconBox.size;
    return referenceBox.globalToLocal(iconRect.topLeft) & iconBox.size;
  };

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<GlobalKey<State<StatefulWidget>>>('iconKey', iconKey));
    properties.add(EnumProperty<NavigationDestinationLabelBehavior>('labelBehavior', labelBehavior));
  }
}

class _NavigationDestinationInfo extends InheritedWidget {
  const _NavigationDestinationInfo({
    required this.index,
    required this.selectedIndex,
    required this.totalNumberOfDestinations,
    required this.selectedAnimation,
    required this.labelBehavior,
    required this.indicatorColor,
    required this.indicatorShape,
    required this.overlayColor,
    required this.onTap,
    required super.child,
    this.labelTextStyle,
    this.labelPadding,
  });

  final int index;

  final int selectedIndex;

  final int totalNumberOfDestinations;

  final Animation<double> selectedAnimation;

  final NavigationDestinationLabelBehavior labelBehavior;

  final Color? indicatorColor;

  final ShapeBorder? indicatorShape;

  final WidgetStateProperty<Color?>? overlayColor;

  final VoidCallback onTap;

  final WidgetStateProperty<TextStyle?>? labelTextStyle;

  final EdgeInsetsGeometry? labelPadding;

  static _NavigationDestinationInfo of(BuildContext context) {
    final _NavigationDestinationInfo? result = context.dependOnInheritedWidgetOfExactType<_NavigationDestinationInfo>();
    assert(
      result != null,
      'Navigation destinations need a _NavigationDestinationInfo parent, '
      'which is usually provided by NavigationBar.',
    );
    return result!;
  }

  @override
  bool updateShouldNotify(_NavigationDestinationInfo oldWidget) =>
      index != oldWidget.index ||
      totalNumberOfDestinations != oldWidget.totalNumberOfDestinations ||
      selectedAnimation != oldWidget.selectedAnimation ||
      labelBehavior != oldWidget.labelBehavior ||
      onTap != oldWidget.onTap;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('index', index));
    properties.add(IntProperty('selectedIndex', selectedIndex));
    properties.add(IntProperty('totalNumberOfDestinations', totalNumberOfDestinations));
    properties.add(DiagnosticsProperty<Animation<double>>('selectedAnimation', selectedAnimation));
    properties.add(EnumProperty<NavigationDestinationLabelBehavior>('labelBehavior', labelBehavior));
    properties.add(ColorProperty('indicatorColor', indicatorColor));
    properties.add(DiagnosticsProperty<ShapeBorder?>('indicatorShape', indicatorShape));
    properties.add(DiagnosticsProperty<WidgetStateProperty<Color?>?>('overlayColor', overlayColor));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onTap', onTap));
    properties.add(DiagnosticsProperty<WidgetStateProperty<TextStyle?>?>('labelTextStyle', labelTextStyle));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('labelPadding', labelPadding));
  }
}

class NavigationIndicator extends StatelessWidget {
  const NavigationIndicator({
    required this.animation,
    super.key,
    this.color,
    this.width = _kIndicatorWidth,
    this.height = _kIndicatorHeight,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.shape,
  });

  final Animation<double> animation;

  final Color? color;

  final double width;

  final double height;

  final BorderRadius borderRadius;

  final ShapeBorder? shape;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: animation,
    builder: (context, child) {
      // The scale should be 0 when the animation is unselected, as soon as
      // the animation starts, the scale jumps to 40%, and then animates to
      // 100% along a curve.
      final double scale =
          animation.isDismissed
              ? 0.0
              : Tween<double>(
                begin: .4,
                end: 1.0,
              ).transform(CurveTween(curve: Curves.easeInOutCubicEmphasized).transform(animation.value));

      return Transform(
        alignment: Alignment.center,
        // Scale in the X direction only.
        transform: Matrix4.diagonal3Values(scale, 1.0, 1.0),
        child: child,
      );
    },
    // Fade should be a 100ms animation whenever the parent animation changes
    // direction.
    child: _StatusTransitionWidgetBuilder(
      animation: animation,
      builder:
          (context, child) => _SelectableAnimatedBuilder(
            isSelected: animation.isForwardOrCompleted,
            duration: const Duration(milliseconds: 100),
            alwaysDoFullAnimation: true,
            builder:
                (context, fadeAnimation) => FadeTransition(
                  opacity: fadeAnimation,
                  child: Container(
                    width: width,
                    height: height,
                    decoration: ShapeDecoration(
                      shape: shape ?? RoundedRectangleBorder(borderRadius: borderRadius),
                      color: color ?? Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
          ),
    ),
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Animation<double>>('animation', animation));
    properties.add(ColorProperty('color', color));
    properties.add(DoubleProperty('width', width));
    properties.add(DoubleProperty('height', height));
    properties.add(DiagnosticsProperty<BorderRadius>('borderRadius', borderRadius));
    properties.add(DiagnosticsProperty<ShapeBorder?>('shape', shape));
  }
}

class _NavigationBarDestinationLayout extends StatelessWidget {
  const _NavigationBarDestinationLayout({required this.icon, required this.iconKey, required this.label});

  final Widget icon;

  final GlobalKey iconKey;

  final Widget label;

  static final Key _labelKey = UniqueKey();

  @override
  Widget build(BuildContext context) => _DestinationLayoutAnimationBuilder(
    builder:
        (context, animation) => CustomMultiChildLayout(
          delegate: _NavigationDestinationLayoutDelegate(animation: animation),
          children: <Widget>[
            LayoutId(
              id: _NavigationDestinationLayoutDelegate.iconId,
              child: RepaintBoundary(key: iconKey, child: icon),
            ),
            LayoutId(
              id: _NavigationDestinationLayoutDelegate.labelId,
              child: FadeTransition(
                alwaysIncludeSemantics: true,
                opacity: animation,
                child: RepaintBoundary(key: _labelKey, child: label),
              ),
            ),
          ],
        ),
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<GlobalKey<State<StatefulWidget>>>('iconKey', iconKey));
  }
}

class _DestinationLayoutAnimationBuilder extends StatelessWidget {
  const _DestinationLayoutAnimationBuilder({required this.builder});

  final Widget Function(BuildContext, Animation<double>) builder;

  @override
  Widget build(BuildContext context) {
    final _NavigationDestinationInfo info = _NavigationDestinationInfo.of(context);
    switch (info.labelBehavior) {
      case NavigationDestinationLabelBehavior.alwaysShow:
        return builder(context, kAlwaysCompleteAnimation);
      case NavigationDestinationLabelBehavior.alwaysHide:
        return builder(context, kAlwaysDismissedAnimation);
      case NavigationDestinationLabelBehavior.onlyShowSelected:
        return _CurvedAnimationBuilder(
          animation: info.selectedAnimation,
          curve: Curves.easeInOutCubicEmphasized,
          reverseCurve: Curves.easeInOutCubicEmphasized.flipped,
          builder: builder,
        );
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<Widget Function(BuildContext p1, Animation<double> p2)>.has('builder', builder));
  }
}

class _NavigationBarDestinationSemantics extends StatelessWidget {
  const _NavigationBarDestinationSemantics({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final _NavigationDestinationInfo destinationInfo = _NavigationDestinationInfo.of(context);
    // The AnimationStatusBuilder will make sure that the semantics update to
    // "selected" when the animation status changes.
    return _StatusTransitionWidgetBuilder(
      animation: destinationInfo.selectedAnimation,
      builder:
          (context, child) => Semantics(
            selected: destinationInfo.selectedAnimation.isForwardOrCompleted,
            container: true,
            button: true,
            child: child,
          ),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          child,
          Semantics(
            label: localizations.tabLabel(
              tabIndex: destinationInfo.index + 1,
              tabCount: destinationInfo.totalNumberOfDestinations,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavigationBarDestinationTooltip extends StatelessWidget {
  const _NavigationBarDestinationTooltip({required this.message, required this.child});

  final String message;

  final Widget child;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: message,
    // TODO(johnsonmh): Make this value configurable/themable.
    verticalOffset: 42,
    excludeFromSemantics: true,
    preferBelow: false,
    child: child,
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('message', message));
  }
}

class _NavigationDestinationLayoutDelegate extends MultiChildLayoutDelegate {
  _NavigationDestinationLayoutDelegate({required this.animation}) : super(relayout: animation);

  final Animation<double> animation;

  static const int iconId = 1;

  static const int labelId = 2;

  @override
  void performLayout(Size size) {
    double halfWidth(Size size) => size.width / 2;
    double halfHeight(Size size) => size.height / 2;

    final Size iconSize = layoutChild(iconId, BoxConstraints.loose(size));
    final Size labelSize = layoutChild(labelId, BoxConstraints.loose(size));

    final double yPositionOffset = Tween<double>(
      // When unselected, the icon is centered vertically.
      begin: halfHeight(iconSize),
      // When selected, the icon and label are centered vertically.
      end: halfHeight(iconSize) + halfHeight(labelSize),
    ).transform(animation.value);
    final double iconYPosition = halfHeight(size) - yPositionOffset;

    // Position the icon.
    positionChild(
      iconId,
      Offset(
        // Center the icon horizontally.
        halfWidth(size) - halfWidth(iconSize),
        iconYPosition,
      ),
    );

    // Position the label.
    positionChild(
      labelId,
      Offset(
        // Center the label horizontally.
        halfWidth(size) - halfWidth(labelSize),
        // Label always appears directly below the icon.
        iconYPosition + iconSize.height,
      ),
    );
  }

  @override
  bool shouldRelayout(_NavigationDestinationLayoutDelegate oldDelegate) => oldDelegate.animation != animation;
}

class _StatusTransitionWidgetBuilder extends StatusTransitionWidget {
  const _StatusTransitionWidgetBuilder({required super.animation, required this.builder, this.child});

  final TransitionBuilder builder;

  final Widget? child;

  @override
  Widget build(BuildContext context) => builder(context, child);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<TransitionBuilder>.has('builder', builder));
  }
}

// Builder widget for widgets that need to be animated from 0 (unselected) to
// 1.0 (selected).
//
// This widget creates and manages an [AnimationController] that it passes down
// to the child through the [builder] function.
//
// When [isSelected] is `true`, the animation controller will animate from
// 0 to 1 (for [duration] time).
//
// When [isSelected] is `false`, the animation controller will animate from
// 1 to 0 (for [duration] time).
//
// If [isSelected] is updated while the widget is animating, the animation will
// be reversed until it is either 0 or 1 again. If [alwaysDoFullAnimation] is
// true, the animation will reset to 0 or 1 before beginning the animation, so
// that the full animation is done.
//
// Usage:
// ```dart
// _SelectableAnimatedBuilder(
//   isSelected: _isDrawerOpen,
//   builder: (context, animation) {
//     return AnimatedIcon(
//       icon: AnimatedIcons.menu_arrow,
//       progress: animation,
//       semanticLabel: 'Show menu',
//     );
//   }
// )
// ```
class _SelectableAnimatedBuilder extends StatefulWidget {
  const _SelectableAnimatedBuilder({
    required this.isSelected,
    required this.builder,
    this.duration = const Duration(milliseconds: 200),
    this.alwaysDoFullAnimation = false,
  });

  final bool isSelected;

  final Duration duration;

  final bool alwaysDoFullAnimation;

  final Widget Function(BuildContext, Animation<double>) builder;

  @override
  _SelectableAnimatedBuilderState createState() => _SelectableAnimatedBuilderState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('isSelected', isSelected));
    properties.add(DiagnosticsProperty<Duration>('duration', duration));
    properties.add(DiagnosticsProperty<bool>('alwaysDoFullAnimation', alwaysDoFullAnimation));
    properties.add(ObjectFlagProperty<Widget Function(BuildContext p1, Animation<double> p2)>.has('builder', builder));
  }
}

class _SelectableAnimatedBuilderState extends State<_SelectableAnimatedBuilder> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.duration = widget.duration;
    _controller.value = widget.isSelected ? 1.0 : 0.0;
  }

  @override
  void didUpdateWidget(_SelectableAnimatedBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }
    if (oldWidget.isSelected != widget.isSelected) {
      if (widget.isSelected) {
        _controller.forward(from: widget.alwaysDoFullAnimation ? 0 : null);
      } else {
        _controller.reverse(from: widget.alwaysDoFullAnimation ? 1 : null);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _controller);
}

class _CurvedAnimationBuilder extends StatefulWidget {
  const _CurvedAnimationBuilder({
    required this.animation,
    required this.curve,
    required this.reverseCurve,
    required this.builder,
  });

  final Animation<double> animation;
  final Curve curve;
  final Curve reverseCurve;
  final Widget Function(BuildContext, Animation<double>) builder;

  @override
  _CurvedAnimationBuilderState createState() => _CurvedAnimationBuilderState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Animation<double>>('animation', animation));
    properties.add(DiagnosticsProperty<Curve>('curve', curve));
    properties.add(DiagnosticsProperty<Curve>('reverseCurve', reverseCurve));
    properties.add(ObjectFlagProperty<Widget Function(BuildContext p1, Animation<double> p2)>.has('builder', builder));
  }
}

class _CurvedAnimationBuilderState extends State<_CurvedAnimationBuilder> {
  late AnimationStatus _animationDirection;
  AnimationStatus? _preservedDirection;

  @override
  void initState() {
    super.initState();
    _animationDirection = widget.animation.status;
    _updateStatus(widget.animation.status);
    widget.animation.addStatusListener(_updateStatus);
  }

  @override
  void dispose() {
    widget.animation.removeStatusListener(_updateStatus);
    super.dispose();
  }

  // Keeps track of the current animation status, as well as the "preserved
  // direction" when the animation changes direction mid animation.
  //
  // The preserved direction is reset when the animation finishes in either
  // direction.
  void _updateStatus(AnimationStatus status) {
    if (_animationDirection != status) {
      setState(() {
        _animationDirection = status;
      });
    }
    switch (status) {
      case AnimationStatus.forward || AnimationStatus.reverse when _preservedDirection != null:
        break;
      case AnimationStatus.forward || AnimationStatus.reverse:
        setState(() {
          _preservedDirection = status;
        });
      case AnimationStatus.completed || AnimationStatus.dismissed:
        setState(() {
          _preservedDirection = null;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool shouldUseForwardCurve = (_preservedDirection ?? _animationDirection) != AnimationStatus.reverse;

    final Animation<double> curvedAnimation = CurveTween(
      curve: shouldUseForwardCurve ? widget.curve : widget.reverseCurve,
    ).animate(widget.animation);

    return widget.builder(context, curvedAnimation);
  }
}

NavigationBarThemeData _defaultsFor(BuildContext context) => _NavigationBarDefaultsM3(context);

// BEGIN GENERATED TOKEN PROPERTIES - NavigationBar

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// dart format off
class _NavigationBarDefaultsM3 extends NavigationBarThemeData {
  _NavigationBarDefaultsM3(this.context)
    : super(
        height: 80.0,
        elevation: 3.0,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      );

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;
  late final TextTheme _textTheme = Theme.of(context).textTheme;

  @override
  Color? get backgroundColor => _colors.surfaceContainer;

  @override
  Color? get shadowColor => Colors.transparent;

  @override
  Color? get surfaceTintColor => Colors.transparent;

  @override
  WidgetStateProperty<IconThemeData?>? get iconTheme => WidgetStateProperty.resolveWith((states) => IconThemeData(
        size: 24.0,
        color: states.contains(WidgetState.disabled)
          ? _colors.onSurfaceVariant.withValues(alpha:0.38)
          : states.contains(WidgetState.selected)
            ? _colors.onSecondaryContainer
            : _colors.onSurfaceVariant,
      ));

  @override
  Color? get indicatorColor => _colors.secondaryContainer;

  @override
  ShapeBorder? get indicatorShape => const StadiumBorder();

  @override
  WidgetStateProperty<TextStyle?>? get labelTextStyle => WidgetStateProperty.resolveWith((states) {
    final TextStyle style = _textTheme.labelMedium!;
      return style.apply(
        color: states.contains(WidgetState.disabled)
          ? _colors.onSurfaceVariant.withValues(alpha:0.38)
          : states.contains(WidgetState.selected)
            ? _colors.onSurface
            : _colors.onSurfaceVariant
      );
    });

  @override
  EdgeInsetsGeometry? get labelPadding => const EdgeInsets.only(top: 4);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BuildContext>('context', context));
  }
}
// dart format on

// END GENERATED TOKEN PROPERTIES - NavigationBar
