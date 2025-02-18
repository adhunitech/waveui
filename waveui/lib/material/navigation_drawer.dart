// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/color_scheme.dart';
import 'package:waveui/material/colors.dart';
import 'package:waveui/material/drawer.dart';
import 'package:waveui/material/ink_decoration.dart';
import 'package:waveui/material/ink_well.dart';
import 'package:waveui/material/material.dart';
import 'package:waveui/material/material_localizations.dart';
import 'package:waveui/material/material_state.dart';
import 'package:waveui/material/navigation_bar.dart';
import 'package:waveui/material/navigation_drawer_theme.dart';
import 'package:waveui/src/theme/text_theme.dart';
import 'package:waveui/material/theme.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({
    required this.children,
    super.key,
    this.backgroundColor,
    this.shadowColor,
    this.surfaceTintColor,
    this.elevation,
    this.indicatorColor,
    this.indicatorShape,
    this.onDestinationSelected,
    this.selectedIndex = 0,
    this.tilePadding = const EdgeInsets.symmetric(horizontal: 12.0),
  });

  final Color? backgroundColor;

  final Color? shadowColor;

  final Color? surfaceTintColor;

  final double? elevation;

  final Color? indicatorColor;

  final ShapeBorder? indicatorShape;

  final List<Widget> children;

  final int? selectedIndex;

  final ValueChanged<int>? onDestinationSelected;

  final EdgeInsetsGeometry tilePadding;

  @override
  Widget build(BuildContext context) {
    final int totalNumberOfDestinations = children.whereType<NavigationDrawerDestination>().toList().length;

    int destinationIndex = 0;
    Widget wrapChild(Widget child, int index) => _SelectableAnimatedBuilder(
      duration: const Duration(milliseconds: 500),
      isSelected: index == selectedIndex,
      builder:
          (context, animation) => _NavigationDrawerDestinationInfo(
            index: index,
            totalNumberOfDestinations: totalNumberOfDestinations,
            selectedAnimation: animation,
            indicatorColor: indicatorColor,
            indicatorShape: indicatorShape,
            tilePadding: tilePadding,
            onTap: () => onDestinationSelected?.call(index),
            child: child,
          ),
    );

    final List<Widget> wrappedChildren = <Widget>[
      for (final Widget child in children)
        if (child is! NavigationDrawerDestination) child else wrapChild(child, destinationIndex++),
    ];
    final NavigationDrawerThemeData navigationDrawerTheme = NavigationDrawerTheme.of(context);

    return Drawer(
      backgroundColor: backgroundColor ?? navigationDrawerTheme.backgroundColor,
      shadowColor: shadowColor ?? navigationDrawerTheme.shadowColor,
      surfaceTintColor: surfaceTintColor ?? navigationDrawerTheme.surfaceTintColor,
      elevation: elevation ?? navigationDrawerTheme.elevation,
      child: SafeArea(bottom: false, child: ListView(children: wrappedChildren)),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(ColorProperty('shadowColor', shadowColor));
    properties.add(ColorProperty('surfaceTintColor', surfaceTintColor));
    properties.add(DoubleProperty('elevation', elevation));
    properties.add(ColorProperty('indicatorColor', indicatorColor));
    properties.add(DiagnosticsProperty<ShapeBorder?>('indicatorShape', indicatorShape));
    properties.add(IntProperty('selectedIndex', selectedIndex));
    properties.add(ObjectFlagProperty<ValueChanged<int>?>.has('onDestinationSelected', onDestinationSelected));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('tilePadding', tilePadding));
  }
}

class NavigationDrawerDestination extends StatelessWidget {
  const NavigationDrawerDestination({
    required this.icon,
    required this.label,
    super.key,
    this.backgroundColor,
    this.selectedIcon,
    this.enabled = true,
  });

  final Color? backgroundColor;

  final Widget icon;

  final Widget? selectedIcon;

  final Widget label;

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    const Set<WidgetState> selectedState = <WidgetState>{WidgetState.selected};
    const Set<WidgetState> unselectedState = <WidgetState>{};
    const Set<WidgetState> disabledState = <WidgetState>{WidgetState.disabled};

    final NavigationDrawerThemeData navigationDrawerTheme = NavigationDrawerTheme.of(context);
    final NavigationDrawerThemeData defaults = _NavigationDrawerDefaultsM3(context);

    final Animation<double> animation = _NavigationDrawerDestinationInfo.of(context).selectedAnimation;

    return _NavigationDestinationBuilder(
      buildIcon: (context) {
        final Widget selectedIconWidget = IconTheme.merge(
          data:
              navigationDrawerTheme.iconTheme?.resolve(enabled ? selectedState : disabledState) ??
              defaults.iconTheme!.resolve(enabled ? selectedState : disabledState)!,
          child: selectedIcon ?? icon,
        );
        final Widget unselectedIconWidget = IconTheme.merge(
          data:
              navigationDrawerTheme.iconTheme?.resolve(enabled ? unselectedState : disabledState) ??
              defaults.iconTheme!.resolve(enabled ? unselectedState : disabledState)!,
          child: icon,
        );

        return animation.isForwardOrCompleted ? selectedIconWidget : unselectedIconWidget;
      },
      buildLabel: (context) {
        final TextStyle? effectiveSelectedLabelTextStyle =
            navigationDrawerTheme.labelTextStyle?.resolve(enabled ? selectedState : disabledState) ??
            defaults.labelTextStyle!.resolve(enabled ? selectedState : disabledState);
        final TextStyle? effectiveUnselectedLabelTextStyle =
            navigationDrawerTheme.labelTextStyle?.resolve(enabled ? unselectedState : disabledState) ??
            defaults.labelTextStyle!.resolve(enabled ? unselectedState : disabledState);

        return DefaultTextStyle(
          style: animation.isForwardOrCompleted ? effectiveSelectedLabelTextStyle! : effectiveUnselectedLabelTextStyle!,
          child: label,
        );
      },
      enabled: enabled,
      backgroundColor: backgroundColor,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(DiagnosticsProperty<bool>('enabled', enabled));
  }
}

class _NavigationDestinationBuilder extends StatelessWidget {
  const _NavigationDestinationBuilder({
    required this.buildIcon,
    required this.buildLabel,
    this.enabled = true,
    this.backgroundColor,
  });

  final WidgetBuilder buildIcon;

  final WidgetBuilder buildLabel;

  final bool enabled;

  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final _NavigationDrawerDestinationInfo info = _NavigationDrawerDestinationInfo.of(context);
    final NavigationDrawerThemeData navigationDrawerTheme = NavigationDrawerTheme.of(context);
    final NavigationDrawerThemeData defaults = _NavigationDrawerDefaultsM3(context);

    final InkWell inkWell = InkWell(
      highlightColor: Colors.transparent,
      onTap: enabled ? info.onTap : null,
      customBorder: info.indicatorShape ?? navigationDrawerTheme.indicatorShape ?? defaults.indicatorShape!,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          NavigationIndicator(
            animation: info.selectedAnimation,
            color: info.indicatorColor ?? navigationDrawerTheme.indicatorColor ?? defaults.indicatorColor!,
            shape: info.indicatorShape ?? navigationDrawerTheme.indicatorShape ?? defaults.indicatorShape!,
            width: (navigationDrawerTheme.indicatorSize ?? defaults.indicatorSize!).width,
            height: (navigationDrawerTheme.indicatorSize ?? defaults.indicatorSize!).height,
          ),
          Row(
            children: <Widget>[
              const SizedBox(width: 16),
              buildIcon(context),
              const SizedBox(width: 12),
              buildLabel(context),
            ],
          ),
        ],
      ),
    );

    final Widget destination = Padding(
      padding: info.tilePadding,
      child: _NavigationDestinationSemantics(
        child: SizedBox(height: navigationDrawerTheme.tileHeight ?? defaults.tileHeight, child: inkWell),
      ),
    );

    if (backgroundColor != null) {
      return Ink(color: backgroundColor, child: destination);
    }
    return destination;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<WidgetBuilder>.has('buildIcon', buildIcon));
    properties.add(ObjectFlagProperty<WidgetBuilder>.has('buildLabel', buildLabel));
    properties.add(DiagnosticsProperty<bool>('enabled', enabled));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
  }
}

class _NavigationDestinationSemantics extends StatelessWidget {
  const _NavigationDestinationSemantics({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final _NavigationDrawerDestinationInfo destinationInfo = _NavigationDrawerDestinationInfo.of(context);
    // The AnimationStatusBuilder will make sure that the semantics update to
    // "selected" when the animation status changes.
    return _StatusTransitionWidgetBuilder(
      animation: destinationInfo.selectedAnimation,
      builder:
          (context, child) => Semantics(
            selected: destinationInfo.selectedAnimation.isForwardOrCompleted,
            container: true,
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

class _NavigationDrawerDestinationInfo extends InheritedWidget {
  const _NavigationDrawerDestinationInfo({
    required this.index,
    required this.totalNumberOfDestinations,
    required this.selectedAnimation,
    required this.indicatorColor,
    required this.indicatorShape,
    required this.onTap,
    required super.child,
    required this.tilePadding,
  });

  final int index;

  final int totalNumberOfDestinations;

  final Animation<double> selectedAnimation;

  final Color? indicatorColor;

  final ShapeBorder? indicatorShape;

  final VoidCallback onTap;

  final EdgeInsetsGeometry tilePadding;

  static _NavigationDrawerDestinationInfo of(BuildContext context) {
    final _NavigationDrawerDestinationInfo? result =
        context.dependOnInheritedWidgetOfExactType<_NavigationDrawerDestinationInfo>();
    assert(
      result != null,
      'Navigation destinations need a _NavigationDrawerDestinationInfo parent, '
      'which is usually provided by NavigationDrawer.',
    );
    return result!;
  }

  @override
  bool updateShouldNotify(_NavigationDrawerDestinationInfo oldWidget) =>
      index != oldWidget.index ||
      totalNumberOfDestinations != oldWidget.totalNumberOfDestinations ||
      selectedAnimation != oldWidget.selectedAnimation ||
      onTap != oldWidget.onTap;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('index', index));
    properties.add(IntProperty('totalNumberOfDestinations', totalNumberOfDestinations));
    properties.add(DiagnosticsProperty<Animation<double>>('selectedAnimation', selectedAnimation));
    properties.add(ColorProperty('indicatorColor', indicatorColor));
    properties.add(DiagnosticsProperty<ShapeBorder?>('indicatorShape', indicatorShape));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onTap', onTap));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('tilePadding', tilePadding));
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
// be reversed until it is either 0 or 1 again.
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
  });

  final bool isSelected;

  final Duration duration;

  final Widget Function(BuildContext, Animation<double>) builder;

  @override
  _SelectableAnimatedBuilderState createState() => _SelectableAnimatedBuilderState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('isSelected', isSelected));
    properties.add(DiagnosticsProperty<Duration>('duration', duration));
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
        _controller.forward();
      } else {
        _controller.reverse();
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

// BEGIN GENERATED TOKEN PROPERTIES - NavigationDrawer

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// dart format off
class _NavigationDrawerDefaultsM3 extends NavigationDrawerThemeData {
  _NavigationDrawerDefaultsM3(this.context)
    : super(
        elevation: 1.0,
        tileHeight: 56.0,
        indicatorShape: const StadiumBorder(),
        indicatorSize: const Size(336.0, 56.0),
      );

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;
  late final TextTheme _textTheme = Theme.of(context).textTheme;

  @override
  Color? get backgroundColor => _colors.surfaceContainerLow;

  @override
  Color? get surfaceTintColor => Colors.transparent;

  @override
  Color? get shadowColor => Colors.transparent;

  @override
  Color? get indicatorColor => _colors.secondaryContainer;

  @override
  WidgetStateProperty<IconThemeData?>? get iconTheme => WidgetStateProperty.resolveWith((states) => IconThemeData(
        size: 24.0,
        color: states.contains(WidgetState.disabled)
          ? _colors.onSurfaceVariant.withOpacity(0.38)
          : states.contains(WidgetState.selected)
            ? _colors.onSecondaryContainer
            : _colors.onSurfaceVariant,
      ));

  @override
  WidgetStateProperty<TextStyle?>? get labelTextStyle => WidgetStateProperty.resolveWith((states) {
      final TextStyle style = _textTheme.labelLarge!;
      return style.apply(
        color: states.contains(WidgetState.disabled)
          ? _colors.onSurfaceVariant.withOpacity(0.38)
          : states.contains(WidgetState.selected)
            ? _colors.onSecondaryContainer
            : _colors.onSurfaceVariant,
      );
    });

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BuildContext>('context', context));
  }
}
// dart format on

// END GENERATED TOKEN PROPERTIES - NavigationDrawer
