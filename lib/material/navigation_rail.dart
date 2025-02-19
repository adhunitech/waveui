// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:waveui/material/theme.dart' show ThemeData;
import 'package:waveui/material/theme_data.dart' show ThemeData;

import 'package:waveui/material/color_scheme.dart';
import 'package:waveui/material/ink_well.dart';
import 'package:waveui/material/material.dart';
import 'package:waveui/material/material_localizations.dart';
import 'package:waveui/material/navigation_bar.dart';
import 'package:waveui/material/navigation_rail_theme.dart';
import 'package:waveui/src/theme/text_theme.dart';
import 'package:waveui/material/theme.dart';
import 'package:waveui/waveui.dart' show ThemeData;

const double _kCircularIndicatorDiameter = 56;
const double _kIndicatorHeight = 32;

class NavigationRail extends StatefulWidget {
  const NavigationRail({
    required this.destinations,
    required this.selectedIndex,
    super.key,
    this.backgroundColor,
    this.extended = false,
    this.leading,
    this.trailing,
    this.onDestinationSelected,
    this.elevation,
    this.groupAlignment,
    this.labelType,
    this.unselectedLabelTextStyle,
    this.selectedLabelTextStyle,
    this.unselectedIconTheme,
    this.selectedIconTheme,
    this.minWidth,
    this.minExtendedWidth,
    this.useIndicator,
    this.indicatorColor,
    this.indicatorShape,
  }) : assert(selectedIndex == null || (0 <= selectedIndex && selectedIndex < destinations.length)),
       assert(elevation == null || elevation > 0),
       assert(minWidth == null || minWidth > 0),
       assert(minExtendedWidth == null || minExtendedWidth > 0),
       assert((minWidth == null || minExtendedWidth == null) || minExtendedWidth >= minWidth),
       assert(!extended || (labelType == null || labelType == NavigationRailLabelType.none));

  final Color? backgroundColor;

  final bool extended;

  final Widget? leading;

  final Widget? trailing;

  final List<NavigationRailDestination> destinations;

  final int? selectedIndex;

  final ValueChanged<int>? onDestinationSelected;

  final double? elevation;

  final double? groupAlignment;

  final NavigationRailLabelType? labelType;

  final TextStyle? unselectedLabelTextStyle;

  final TextStyle? selectedLabelTextStyle;

  final IconThemeData? unselectedIconTheme;

  final IconThemeData? selectedIconTheme;

  final double? minWidth;

  final double? minExtendedWidth;

  final bool? useIndicator;

  final Color? indicatorColor;

  final ShapeBorder? indicatorShape;

  static Animation<double> extendedAnimation(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_ExtendedNavigationRailAnimation>()!.animation;

  @override
  State<NavigationRail> createState() => _NavigationRailState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(DiagnosticsProperty<bool>('extended', extended));
    properties.add(IterableProperty<NavigationRailDestination>('destinations', destinations));
    properties.add(IntProperty('selectedIndex', selectedIndex));
    properties.add(ObjectFlagProperty<ValueChanged<int>?>.has('onDestinationSelected', onDestinationSelected));
    properties.add(DoubleProperty('elevation', elevation));
    properties.add(DoubleProperty('groupAlignment', groupAlignment));
    properties.add(EnumProperty<NavigationRailLabelType?>('labelType', labelType));
    properties.add(DiagnosticsProperty<TextStyle?>('unselectedLabelTextStyle', unselectedLabelTextStyle));
    properties.add(DiagnosticsProperty<TextStyle?>('selectedLabelTextStyle', selectedLabelTextStyle));
    properties.add(DiagnosticsProperty<IconThemeData?>('unselectedIconTheme', unselectedIconTheme));
    properties.add(DiagnosticsProperty<IconThemeData?>('selectedIconTheme', selectedIconTheme));
    properties.add(DoubleProperty('minWidth', minWidth));
    properties.add(DoubleProperty('minExtendedWidth', minExtendedWidth));
    properties.add(DiagnosticsProperty<bool?>('useIndicator', useIndicator));
    properties.add(ColorProperty('indicatorColor', indicatorColor));
    properties.add(DiagnosticsProperty<ShapeBorder?>('indicatorShape', indicatorShape));
  }
}

class _NavigationRailState extends State<NavigationRail> with TickerProviderStateMixin {
  late List<AnimationController> _destinationControllers;
  late List<Animation<double>> _destinationAnimations;
  late AnimationController _extendedController;
  late CurvedAnimation _extendedAnimation;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  @override
  void didUpdateWidget(NavigationRail oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.extended != oldWidget.extended) {
      if (widget.extended) {
        _extendedController.forward();
      } else {
        _extendedController.reverse();
      }
    }

    // No animated segue if the length of the items list changes.
    if (widget.destinations.length != oldWidget.destinations.length) {
      _resetState();
      return;
    }

    if (widget.selectedIndex != oldWidget.selectedIndex) {
      if (oldWidget.selectedIndex != null) {
        _destinationControllers[oldWidget.selectedIndex!].reverse();
      }
      if (widget.selectedIndex != null) {
        _destinationControllers[widget.selectedIndex!].forward();
      }
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final NavigationRailThemeData navigationRailTheme = NavigationRailTheme.of(context);
    final NavigationRailThemeData defaults = _NavigationRailDefaultsM3(context);
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);

    final Color backgroundColor =
        widget.backgroundColor ?? navigationRailTheme.backgroundColor ?? defaults.backgroundColor!;
    final double elevation = widget.elevation ?? navigationRailTheme.elevation ?? defaults.elevation!;
    final double minWidth = widget.minWidth ?? navigationRailTheme.minWidth ?? defaults.minWidth!;
    final double minExtendedWidth =
        widget.minExtendedWidth ?? navigationRailTheme.minExtendedWidth ?? defaults.minExtendedWidth!;
    final TextStyle unselectedLabelTextStyle =
        widget.unselectedLabelTextStyle ??
        navigationRailTheme.unselectedLabelTextStyle ??
        defaults.unselectedLabelTextStyle!;
    final TextStyle selectedLabelTextStyle =
        widget.selectedLabelTextStyle ?? navigationRailTheme.selectedLabelTextStyle ?? defaults.selectedLabelTextStyle!;
    final IconThemeData unselectedIconTheme =
        widget.unselectedIconTheme ?? navigationRailTheme.unselectedIconTheme ?? defaults.unselectedIconTheme!;
    final IconThemeData selectedIconTheme =
        widget.selectedIconTheme ?? navigationRailTheme.selectedIconTheme ?? defaults.selectedIconTheme!;
    final double groupAlignment =
        widget.groupAlignment ?? navigationRailTheme.groupAlignment ?? defaults.groupAlignment!;
    final NavigationRailLabelType labelType = widget.labelType ?? navigationRailTheme.labelType ?? defaults.labelType!;
    final bool useIndicator = widget.useIndicator ?? navigationRailTheme.useIndicator ?? defaults.useIndicator!;
    final Color? indicatorColor =
        widget.indicatorColor ?? navigationRailTheme.indicatorColor ?? defaults.indicatorColor;
    final ShapeBorder? indicatorShape =
        widget.indicatorShape ?? navigationRailTheme.indicatorShape ?? defaults.indicatorShape;

    // For backwards compatibility, in M2 the opacity of the unselected icons needs
    // to be set to the default if it isn't in the given theme. This can be removed
    // when Material 3 is the default.
    final IconThemeData effectiveUnselectedIconTheme = unselectedIconTheme;

    final bool isRTLDirection = Directionality.of(context) == TextDirection.rtl;

    return _ExtendedNavigationRailAnimation(
      animation: _extendedAnimation,
      child: Semantics(
        explicitChildNodes: true,
        child: Material(
          elevation: elevation,
          color: backgroundColor,
          child: SafeArea(
            right: isRTLDirection,
            left: !isRTLDirection,
            child: Column(
              children: <Widget>[
                _verticalSpacer,
                if (widget.leading != null) ...<Widget>[widget.leading!, _verticalSpacer],
                Expanded(
                  child: Align(
                    alignment: Alignment(0, groupAlignment),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        for (int i = 0; i < widget.destinations.length; i += 1)
                          _RailDestination(
                            minWidth: minWidth,
                            minExtendedWidth: minExtendedWidth,
                            extendedTransitionAnimation: _extendedAnimation,
                            selected: widget.selectedIndex == i,
                            icon:
                                widget.selectedIndex == i
                                    ? widget.destinations[i].selectedIcon
                                    : widget.destinations[i].icon,
                            label: widget.destinations[i].label,
                            destinationAnimation: _destinationAnimations[i],
                            labelType: labelType,
                            iconTheme: widget.selectedIndex == i ? selectedIconTheme : effectiveUnselectedIconTheme,
                            labelTextStyle:
                                widget.selectedIndex == i ? selectedLabelTextStyle : unselectedLabelTextStyle,
                            padding: widget.destinations[i].padding,
                            useIndicator: useIndicator,
                            indicatorColor: useIndicator ? indicatorColor : null,
                            indicatorShape: useIndicator ? indicatorShape : null,
                            onTap: () {
                              if (widget.onDestinationSelected != null) {
                                widget.onDestinationSelected!(i);
                              }
                            },
                            indexLabel: localizations.tabLabel(tabIndex: i + 1, tabCount: widget.destinations.length),
                            disabled: widget.destinations[i].disabled,
                          ),
                        if (widget.trailing != null) widget.trailing!,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _disposeControllers() {
    for (final AnimationController controller in _destinationControllers) {
      controller.dispose();
    }
    _extendedController.dispose();
    _extendedAnimation.dispose();
  }

  void _initControllers() {
    _destinationControllers = List<AnimationController>.generate(
      widget.destinations.length,
      (index) => AnimationController(duration: kThemeAnimationDuration, vsync: this)..addListener(_rebuild),
    );
    _destinationAnimations = _destinationControllers.map((controller) => controller.view).toList();
    if (widget.selectedIndex != null) {
      _destinationControllers[widget.selectedIndex!].value = 1.0;
    }
    _extendedController = AnimationController(
      duration: kThemeAnimationDuration,
      vsync: this,
      value: widget.extended ? 1.0 : 0.0,
    );
    _extendedAnimation = CurvedAnimation(parent: _extendedController, curve: Curves.easeInOut);
    _extendedController.addListener(_rebuild);
  }

  void _resetState() {
    _disposeControllers();
    _initControllers();
  }

  void _rebuild() {
    setState(() {
      // Rebuilding when any of the controllers tick, i.e. when the items are
      // animating.
    });
  }
}

class _RailDestination extends StatefulWidget {
  const _RailDestination({
    required this.minWidth,
    required this.minExtendedWidth,
    required this.icon,
    required this.label,
    required this.destinationAnimation,
    required this.extendedTransitionAnimation,
    required this.labelType,
    required this.selected,
    required this.iconTheme,
    required this.labelTextStyle,
    required this.onTap,
    required this.indexLabel,
    required this.useIndicator,
    this.padding,
    this.indicatorColor,
    this.indicatorShape,
    this.disabled = false,
  });

  final double minWidth;
  final double minExtendedWidth;
  final Widget icon;
  final Widget label;
  final Animation<double> destinationAnimation;
  final NavigationRailLabelType labelType;
  final bool selected;
  final Animation<double> extendedTransitionAnimation;
  final IconThemeData iconTheme;
  final TextStyle labelTextStyle;
  final VoidCallback onTap;
  final String indexLabel;
  final EdgeInsetsGeometry? padding;
  final bool useIndicator;
  final Color? indicatorColor;
  final ShapeBorder? indicatorShape;
  final bool disabled;

  @override
  State<_RailDestination> createState() => _RailDestinationState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('minWidth', minWidth));
    properties.add(DoubleProperty('minExtendedWidth', minExtendedWidth));
    properties.add(DiagnosticsProperty<Animation<double>>('destinationAnimation', destinationAnimation));
    properties.add(EnumProperty<NavigationRailLabelType>('labelType', labelType));
    properties.add(DiagnosticsProperty<bool>('selected', selected));
    properties.add(DiagnosticsProperty<Animation<double>>('extendedTransitionAnimation', extendedTransitionAnimation));
    properties.add(DiagnosticsProperty<IconThemeData>('iconTheme', iconTheme));
    properties.add(DiagnosticsProperty<TextStyle>('labelTextStyle', labelTextStyle));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onTap', onTap));
    properties.add(StringProperty('indexLabel', indexLabel));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('padding', padding));
    properties.add(DiagnosticsProperty<bool>('useIndicator', useIndicator));
    properties.add(ColorProperty('indicatorColor', indicatorColor));
    properties.add(DiagnosticsProperty<ShapeBorder?>('indicatorShape', indicatorShape));
    properties.add(DiagnosticsProperty<bool>('disabled', disabled));
  }
}

class _RailDestinationState extends State<_RailDestination> {
  late CurvedAnimation _positionAnimation;

  @override
  void initState() {
    super.initState();
    _setPositionAnimation();
  }

  @override
  void didUpdateWidget(_RailDestination oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.destinationAnimation != oldWidget.destinationAnimation) {
      _positionAnimation.dispose();
      _setPositionAnimation();
    }
  }

  void _setPositionAnimation() {
    _positionAnimation = CurvedAnimation(
      parent: ReverseAnimation(widget.destinationAnimation),
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeInOut.flipped,
    );
  }

  @override
  void dispose() {
    _positionAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(
      widget.useIndicator || widget.indicatorColor == null,
      '[NavigationRail.indicatorColor] does not have an effect when [NavigationRail.useIndicator] is false',
    );

    final ThemeData theme = Theme.of(context);
    final TextDirection textDirection = Directionality.of(context);
    final EdgeInsets destinationPadding = (widget.padding ?? EdgeInsets.zero).resolve(textDirection);
    Offset indicatorOffset;
    bool applyXOffset = false;

    final Widget themedIcon = IconTheme(
      data:
          widget.disabled
              ? widget.iconTheme.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.38))
              : widget.iconTheme,
      child: widget.icon,
    );
    final Widget styledLabel = DefaultTextStyle(
      style:
          widget.disabled
              ? widget.labelTextStyle.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.38))
              : widget.labelTextStyle,
      child: widget.label,
    );

    Widget content;

    // The indicator height is fixed and equal to _kIndicatorHeight.
    // When the icon height is larger than the indicator height the indicator
    // vertical offset is used to vertically center the indicator.
    final bool isLargeIconSize = widget.iconTheme.size != null && widget.iconTheme.size! > _kIndicatorHeight;
    final double indicatorVerticalOffset = isLargeIconSize ? (widget.iconTheme.size! - _kIndicatorHeight) / 2 : 0;

    switch (widget.labelType) {
      case NavigationRailLabelType.none:
        // Split the destination spacing across the top and bottom to keep the icon centered.
        const Widget spacing = SizedBox(height: _verticalDestinationSpacingM3 / 2);
        indicatorOffset = Offset(
          widget.minWidth / 2 + destinationPadding.left,
          _verticalDestinationSpacingM3 / 2 + destinationPadding.top + indicatorVerticalOffset,
        );
        final Widget iconPart = Column(
          children: <Widget>[
            spacing,
            SizedBox(
              width: widget.minWidth,
              child: Center(
                child: _AddIndicator(
                  addIndicator: widget.useIndicator,
                  indicatorColor: widget.indicatorColor,
                  indicatorShape: widget.indicatorShape,
                  isCircular: false,
                  indicatorAnimation: widget.destinationAnimation,
                  child: themedIcon,
                ),
              ),
            ),
            spacing,
          ],
        );
        if (widget.extendedTransitionAnimation.value == 0) {
          content = Padding(
            padding: widget.padding ?? EdgeInsets.zero,
            child: Stack(
              children: <Widget>[
                iconPart,
                // For semantics when label is not showing,
                SizedBox.shrink(child: Visibility.maintain(visible: false, child: widget.label)),
              ],
            ),
          );
        } else {
          final Animation<double> labelFadeAnimation = widget.extendedTransitionAnimation.drive(
            CurveTween(curve: const Interval(0.0, 0.25)),
          );
          applyXOffset = true;
          content = Padding(
            padding: widget.padding ?? EdgeInsets.zero,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth:
                    lerpDouble(widget.minWidth, widget.minExtendedWidth, widget.extendedTransitionAnimation.value)!,
              ),
              child: ClipRect(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    iconPart,
                    Flexible(
                      child: Align(
                        heightFactor: 1.0,
                        widthFactor: widget.extendedTransitionAnimation.value,
                        alignment: AlignmentDirectional.centerStart,
                        child: FadeTransition(
                          alwaysIncludeSemantics: true,
                          opacity: labelFadeAnimation,
                          child: styledLabel,
                        ),
                      ),
                    ),
                    SizedBox(width: _horizontalDestinationPadding * widget.extendedTransitionAnimation.value),
                  ],
                ),
              ),
            ),
          );
        }
      case NavigationRailLabelType.selected:
        final double appearingAnimationValue = 1 - _positionAnimation.value;
        final double verticalPadding =
            lerpDouble(
              _verticalDestinationPaddingNoLabel,
              _verticalDestinationPaddingWithLabel,
              appearingAnimationValue,
            )!;
        final Interval interval = widget.selected ? const Interval(0.25, 0.75) : const Interval(0.75, 1.0);
        final Animation<double> labelFadeAnimation = widget.destinationAnimation.drive(CurveTween(curve: interval));
        const double minHeight = 0;
        const Widget topSpacing = SizedBox(height: 0);
        final Widget labelSpacing = SizedBox(
          height: lerpDouble(0, _verticalIconLabelSpacingM3, appearingAnimationValue)!,
        );
        const Widget bottomSpacing = SizedBox(height: _verticalDestinationSpacingM3);
        final double indicatorHorizontalPadding = (destinationPadding.left / 2) - (destinationPadding.right / 2);
        final double indicatorVerticalPadding = destinationPadding.top;
        indicatorOffset = Offset(
          widget.minWidth / 2 + indicatorHorizontalPadding,
          indicatorVerticalPadding + indicatorVerticalOffset,
        );
        indicatorOffset = Offset(
          widget.minWidth / 2 + _horizontalDestinationSpacingM3,
          indicatorVerticalPadding + indicatorVerticalOffset,
        );
        content = ConstrainedBox(
          constraints: BoxConstraints(minWidth: widget.minWidth),
          child: Padding(
            padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: _horizontalDestinationPadding),
            child: ClipRect(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  topSpacing,
                  _AddIndicator(
                    addIndicator: widget.useIndicator,
                    indicatorColor: widget.indicatorColor,
                    indicatorShape: widget.indicatorShape,
                    isCircular: false,
                    indicatorAnimation: widget.destinationAnimation,
                    child: themedIcon,
                  ),
                  labelSpacing,
                  Align(
                    alignment: Alignment.topCenter,
                    heightFactor: appearingAnimationValue,
                    widthFactor: 1.0,
                    child: FadeTransition(
                      alwaysIncludeSemantics: true,
                      opacity: labelFadeAnimation,
                      child: styledLabel,
                    ),
                  ),
                  bottomSpacing,
                ],
              ),
            ),
          ),
        );
      case NavigationRailLabelType.all:
        const double minHeight = 0;
        const Widget topSpacing = SizedBox(height: 0);
        const Widget labelSpacing = SizedBox(height: _verticalIconLabelSpacingM3);
        const Widget bottomSpacing = SizedBox(height: _verticalDestinationSpacingM3);
        final double indicatorHorizontalPadding = (destinationPadding.left / 2) - (destinationPadding.right / 2);
        final double indicatorVerticalPadding = destinationPadding.top;
        indicatorOffset = Offset(
          widget.minWidth / 2 + indicatorHorizontalPadding,
          indicatorVerticalPadding + indicatorVerticalOffset,
        );

        content = ConstrainedBox(
          constraints: BoxConstraints(minWidth: widget.minWidth),
          child: Padding(
            padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: _horizontalDestinationPadding),
            child: Column(
              children: <Widget>[
                topSpacing,
                _AddIndicator(
                  addIndicator: widget.useIndicator,
                  indicatorColor: widget.indicatorColor,
                  indicatorShape: widget.indicatorShape,
                  isCircular: false,
                  indicatorAnimation: widget.destinationAnimation,
                  child: themedIcon,
                ),
                labelSpacing,
                styledLabel,
                bottomSpacing,
              ],
            ),
          ),
        );
    }

    final ColorScheme colors = Theme.of(context).colorScheme;
    final bool primaryColorAlphaModified = colors.primary.alpha < 255.0;
    final Color effectiveSplashColor = primaryColorAlphaModified ? colors.primary : colors.primary.withOpacity(0.12);
    final Color effectiveHoverColor = primaryColorAlphaModified ? colors.primary : colors.primary.withOpacity(0.04);
    return Semantics(
      container: true,
      selected: widget.selected,
      child: Stack(
        children: <Widget>[
          Material(
            type: MaterialType.transparency,
            child: _IndicatorInkWell(
              onTap: widget.disabled ? null : widget.onTap,
              // borderRadius: BorderRadius.all(Radius.circular(widget.minWidth / 2.0)),
              customBorder: widget.indicatorShape,
              splashColor: effectiveSplashColor,
              hoverColor: effectiveHoverColor,
              indicatorOffset: indicatorOffset,
              applyXOffset: applyXOffset,
              textDirection: textDirection,
              child: content,
            ),
          ),
          Semantics(label: widget.indexLabel),
        ],
      ),
    );
  }
}

class _IndicatorInkWell extends InkResponse {
  const _IndicatorInkWell({
    required this.indicatorOffset,
    required this.applyXOffset,
    required this.textDirection,
    super.child,
    super.onTap,
    super.customBorder,
    super.splashColor,
    super.hoverColor,
  }) : super(containedInkWell: true, highlightShape: BoxShape.rectangle, borderRadius: null);

  // The offset used to position Ink highlight.
  final Offset indicatorOffset;

  // Whether the horizontal offset from indicatorOffset should be used to position Ink highlight.
  // If true, Ink highlight uses the indicator horizontal offset. If false, Ink highlight is centered horizontally.
  final bool applyXOffset;

  // The text direction used to adjust the indicator horizontal offset.
  final TextDirection textDirection;

  @override
  RectCallback? getRectCallback(RenderBox referenceBox) {
    final double boxWidth = referenceBox.size.width;
    double indicatorHorizontalCenter = applyXOffset ? indicatorOffset.dx : boxWidth / 2;
    if (textDirection == TextDirection.rtl) {
      indicatorHorizontalCenter = boxWidth - indicatorHorizontalCenter;
    }
    return () => Rect.fromLTWH(
      indicatorHorizontalCenter - (_kCircularIndicatorDiameter / 2),
      indicatorOffset.dy,
      _kCircularIndicatorDiameter,
      _kIndicatorHeight,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Offset>('indicatorOffset', indicatorOffset));
    properties.add(DiagnosticsProperty<bool>('applyXOffset', applyXOffset));
    properties.add(EnumProperty<TextDirection>('textDirection', textDirection));
  }
}

class _AddIndicator extends StatelessWidget {
  const _AddIndicator({
    required this.addIndicator,
    required this.isCircular,
    required this.indicatorColor,
    required this.indicatorShape,
    required this.indicatorAnimation,
    required this.child,
  });

  final bool addIndicator;
  final bool isCircular;
  final Color? indicatorColor;
  final ShapeBorder? indicatorShape;
  final Animation<double> indicatorAnimation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!addIndicator) {
      return child;
    }
    late final Widget indicator;
    if (isCircular) {
      indicator = NavigationIndicator(
        animation: indicatorAnimation,
        height: _kCircularIndicatorDiameter,
        width: _kCircularIndicatorDiameter,
        borderRadius: BorderRadius.circular(_kCircularIndicatorDiameter / 2),
        color: indicatorColor,
      );
    } else {
      indicator = NavigationIndicator(
        animation: indicatorAnimation,
        width: _kCircularIndicatorDiameter,
        shape: indicatorShape,
        color: indicatorColor,
      );
    }

    return Stack(alignment: Alignment.center, children: <Widget>[indicator, child]);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('addIndicator', addIndicator));
    properties.add(DiagnosticsProperty<bool>('isCircular', isCircular));
    properties.add(ColorProperty('indicatorColor', indicatorColor));
    properties.add(DiagnosticsProperty<ShapeBorder?>('indicatorShape', indicatorShape));
    properties.add(DiagnosticsProperty<Animation<double>>('indicatorAnimation', indicatorAnimation));
  }
}

enum NavigationRailLabelType { none, selected, all }

class NavigationRailDestination {
  const NavigationRailDestination({
    required this.icon,
    required this.label,
    Widget? selectedIcon,
    this.indicatorColor,
    this.indicatorShape,
    this.padding,
    this.disabled = false,
  }) : selectedIcon = selectedIcon ?? icon;

  final Widget icon;

  final Widget selectedIcon;

  final Color? indicatorColor;

  final ShapeBorder? indicatorShape;

  final Widget label;

  final EdgeInsetsGeometry? padding;

  final bool disabled;
}

class _ExtendedNavigationRailAnimation extends InheritedWidget {
  const _ExtendedNavigationRailAnimation({required this.animation, required super.child});

  final Animation<double> animation;

  @override
  bool updateShouldNotify(_ExtendedNavigationRailAnimation old) => animation != old.animation;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Animation<double>>('animation', animation));
  }
}

// There don't appear to be tokens for these values, but they are
// shown in the spec.
const double _horizontalDestinationPadding = 8.0;
const double _verticalDestinationPaddingNoLabel = 24.0;
const double _verticalDestinationPaddingWithLabel = 16.0;
const Widget _verticalSpacer = SizedBox(height: 8.0);
const double _verticalIconLabelSpacingM3 = 4.0;
const double _verticalDestinationSpacingM3 = 12.0;
const double _horizontalDestinationSpacingM3 = 12.0;

// BEGIN GENERATED TOKEN PROPERTIES - NavigationRail

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// dart format off
class _NavigationRailDefaultsM3 extends NavigationRailThemeData {
  _NavigationRailDefaultsM3(this.context)
    : super(
        elevation: 0.0,
        groupAlignment: -1,
        labelType: NavigationRailLabelType.none,
        useIndicator: true,
        minWidth: 80.0,
        minExtendedWidth: 256,
      );

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;
  late final TextTheme _textTheme = Theme.of(context).textTheme;

  @override Color? get backgroundColor => _colors.surface;

  @override TextStyle? get unselectedLabelTextStyle => _textTheme.labelMedium!.copyWith(color: _colors.onSurface);

  @override TextStyle? get selectedLabelTextStyle => _textTheme.labelMedium!.copyWith(color: _colors.onSurface);

  @override IconThemeData? get unselectedIconTheme => IconThemeData(
      size: 24.0,
      color: _colors.onSurfaceVariant,
    );

  @override IconThemeData? get selectedIconTheme => IconThemeData(
      size: 24.0,
      color: _colors.onSecondaryContainer,
    );

  @override Color? get indicatorColor => _colors.secondaryContainer;

  @override ShapeBorder? get indicatorShape => const StadiumBorder();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BuildContext>('context', context));
  }
}
// dart format on

// END GENERATED TOKEN PROPERTIES - NavigationRail
