// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/action_buttons.dart';
import 'package:waveui/src/widgets/app_bar/theme.dart';
import 'package:waveui/material/button_style.dart';
import 'package:waveui/material/color_scheme.dart';
import 'package:waveui/material/colors.dart';
import 'package:waveui/material/constants.dart';
import 'package:waveui/material/debug.dart';
import 'package:waveui/material/flexible_space_bar.dart';
import 'package:waveui/material/icon_button.dart';
import 'package:waveui/material/icon_button_theme.dart';
import 'package:waveui/material/material.dart';
import 'package:waveui/material/scaffold.dart';
import 'package:waveui/src/theme/text_theme.dart';
import 'package:waveui/material/theme.dart';

// Examples can assume:
// late String _logoAsset;
// double _myToolbarHeight = 250.0;

const double _kLeadingWidth = kToolbarHeight; // So the leading button is square.
const double _kMaxTitleTextScaleFactor =
    1.34; // TODO(perc): Add link to Material spec when available, https://github.com/flutter/flutter/issues/58769.

enum _SliverAppVariant { small, medium, large }

// Bottom justify the toolbarHeight child which may overflow the top.
class _ToolbarContainerLayout extends SingleChildLayoutDelegate {
  const _ToolbarContainerLayout(this.toolbarHeight);

  final double toolbarHeight;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) => constraints.tighten(height: toolbarHeight);

  @override
  Size getSize(BoxConstraints constraints) => Size(constraints.maxWidth, toolbarHeight);

  @override
  Offset getPositionForChild(Size size, Size childSize) => Offset(0.0, size.height - childSize.height);

  @override
  bool shouldRelayout(_ToolbarContainerLayout oldDelegate) => toolbarHeight != oldDelegate.toolbarHeight;
}

class _PreferredAppBarSize extends Size {
  _PreferredAppBarSize(this.toolbarHeight, this.bottomHeight)
    : super.fromHeight((toolbarHeight ?? kToolbarHeight) + (bottomHeight ?? 0));

  final double? toolbarHeight;
  final double? bottomHeight;
}

class AppBar extends StatefulWidget implements PreferredSizeWidget {
  AppBar({
    super.key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.actions,
    this.flexibleSpace,
    this.bottom,
    this.elevation,
    this.scrolledUnderElevation,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.shadowColor,
    this.surfaceTintColor,
    this.shape,
    this.backgroundColor,
    this.foregroundColor,
    this.iconTheme,
    this.actionsIconTheme,
    this.primary = true,
    this.centerTitle,
    this.excludeHeaderSemantics = false,
    this.titleSpacing,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
    this.toolbarHeight,
    this.leadingWidth,
    this.toolbarTextStyle,
    this.titleTextStyle,
    this.systemOverlayStyle,
    this.forceMaterialTransparency = false,
    this.useDefaultSemanticsOrder = true,
    this.clipBehavior,
    this.actionsPadding,
  }) : assert(elevation == null || elevation >= 0.0),
       preferredSize = _PreferredAppBarSize(toolbarHeight, bottom?.preferredSize.height);

  static double preferredHeightFor(BuildContext context, Size preferredSize) {
    if (preferredSize is _PreferredAppBarSize && preferredSize.toolbarHeight == null) {
      return (AppBarTheme.of(context).toolbarHeight ?? kToolbarHeight) + (preferredSize.bottomHeight ?? 0);
    }
    return preferredSize.height;
  }

  final Widget? leading;

  final bool automaticallyImplyLeading;

  final Widget? title;

  final List<Widget>? actions;

  final Widget? flexibleSpace;

  final PreferredSizeWidget? bottom;

  final double? elevation;

  final double? scrolledUnderElevation;

  final ScrollNotificationPredicate notificationPredicate;

  final Color? shadowColor;

  final Color? surfaceTintColor;

  final ShapeBorder? shape;

  final Color? backgroundColor;

  final Color? foregroundColor;

  final IconThemeData? iconTheme;

  final IconThemeData? actionsIconTheme;

  final bool primary;

  final bool? centerTitle;

  final bool excludeHeaderSemantics;

  final double? titleSpacing;

  final double toolbarOpacity;

  final double bottomOpacity;

  @override
  final Size preferredSize;

  final double? toolbarHeight;

  final double? leadingWidth;

  final TextStyle? toolbarTextStyle;

  final TextStyle? titleTextStyle;

  //

  final SystemUiOverlayStyle? systemOverlayStyle;

  final bool forceMaterialTransparency;

  final bool useDefaultSemanticsOrder;

  final Clip? clipBehavior;

  final EdgeInsetsGeometry? actionsPadding;

  bool _getEffectiveCenterTitle(ThemeData theme) {
    bool platformCenter() {
      switch (theme.platform) {
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
          return false;
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
          return actions == null || actions!.length < 2;
      }
    }

    return centerTitle ?? theme.appBarTheme.centerTitle ?? platformCenter();
  }

  @override
  State<AppBar> createState() => _AppBarState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('automaticallyImplyLeading', automaticallyImplyLeading))
      ..add(DoubleProperty('elevation', elevation))
      ..add(DoubleProperty('scrolledUnderElevation', scrolledUnderElevation))
      ..add(ObjectFlagProperty<ScrollNotificationPredicate>.has('notificationPredicate', notificationPredicate))
      ..add(ColorProperty('shadowColor', shadowColor))
      ..add(ColorProperty('surfaceTintColor', surfaceTintColor))
      ..add(DiagnosticsProperty<ShapeBorder?>('shape', shape))
      ..add(ColorProperty('backgroundColor', backgroundColor))
      ..add(ColorProperty('foregroundColor', foregroundColor))
      ..add(DiagnosticsProperty<IconThemeData?>('iconTheme', iconTheme))
      ..add(DiagnosticsProperty<IconThemeData?>('actionsIconTheme', actionsIconTheme))
      ..add(DiagnosticsProperty<bool>('primary', primary))
      ..add(DiagnosticsProperty<bool?>('centerTitle', centerTitle))
      ..add(DiagnosticsProperty<bool>('excludeHeaderSemantics', excludeHeaderSemantics))
      ..add(DoubleProperty('titleSpacing', titleSpacing))
      ..add(DoubleProperty('toolbarOpacity', toolbarOpacity))
      ..add(DoubleProperty('bottomOpacity', bottomOpacity))
      ..add(DoubleProperty('toolbarHeight', toolbarHeight))
      ..add(DoubleProperty('leadingWidth', leadingWidth))
      ..add(DiagnosticsProperty<TextStyle?>('toolbarTextStyle', toolbarTextStyle))
      ..add(DiagnosticsProperty<TextStyle?>('titleTextStyle', titleTextStyle))
      ..add(DiagnosticsProperty<SystemUiOverlayStyle?>('systemOverlayStyle', systemOverlayStyle))
      ..add(DiagnosticsProperty<bool>('forceMaterialTransparency', forceMaterialTransparency))
      ..add(DiagnosticsProperty<bool>('useDefaultSemanticsOrder', useDefaultSemanticsOrder))
      ..add(EnumProperty<Clip?>('clipBehavior', clipBehavior))
      ..add(DiagnosticsProperty<EdgeInsetsGeometry?>('actionsPadding', actionsPadding));
  }
}

class _AppBarState extends State<AppBar> {
  ScrollNotificationObserverState? _scrollNotificationObserver;
  bool _scrolledUnder = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollNotificationObserver?.removeListener(_handleScrollNotification);
    final ScaffoldState? scaffoldState = Scaffold.maybeOf(context);

    if (scaffoldState != null && (scaffoldState.isDrawerOpen || scaffoldState.isEndDrawerOpen)) {
      return;
    }
    _scrollNotificationObserver = ScrollNotificationObserver.maybeOf(context);
    _scrollNotificationObserver?.addListener(_handleScrollNotification);
  }

  @override
  void dispose() {
    if (_scrollNotificationObserver != null) {
      _scrollNotificationObserver!.removeListener(_handleScrollNotification);
      _scrollNotificationObserver = null;
    }
    super.dispose();
  }

  void _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification && widget.notificationPredicate(notification)) {
      final bool oldScrolledUnder = _scrolledUnder;
      final ScrollMetrics metrics = notification.metrics;
      switch (metrics.axisDirection) {
        case AxisDirection.up:
          // Scroll view is reversed
          _scrolledUnder = metrics.extentAfter > 0;
        case AxisDirection.down:
          _scrolledUnder = metrics.extentBefore > 0;
        case AxisDirection.right:
        case AxisDirection.left:
          // Scrolled under is only supported in the vertical axis, and should
          // not be altered based on horizontal notifications of the same
          // predicate since it could be a 2D scroller.
          break;
      }

      if (_scrolledUnder != oldScrolledUnder) {
        setState(() {
          // React to a change in WidgetState.scrolledUnder
        });
      }
    }
  }

  Color _resolveColor(Set<WidgetState> states, Color? widgetColor, Color? themeColor, Color defaultColor) =>
      WidgetStateProperty.resolveAs<Color?>(widgetColor, states) ??
      WidgetStateProperty.resolveAs<Color?>(themeColor, states) ??
      WidgetStateProperty.resolveAs<Color>(defaultColor, states);

  SystemUiOverlayStyle _systemOverlayStyleForBrightness(Brightness brightness, [Color? backgroundColor]) {
    final SystemUiOverlayStyle style =
        brightness == Brightness.dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;
    // For backward compatibility, create an overlay style without system navigation bar settings.
    return SystemUiOverlayStyle(
      statusBarColor: backgroundColor,
      statusBarBrightness: style.statusBarBrightness,
      statusBarIconBrightness: style.statusBarIconBrightness,
      systemStatusBarContrastEnforced: style.systemStatusBarContrastEnforced,
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(!widget.primary || debugCheckHasMediaQuery(context));
    assert(debugCheckHasMaterialLocalizations(context));
    final ThemeData theme = Theme.of(context);
    final IconButtonThemeData iconButtonTheme = IconButtonTheme.of(context);
    final AppBarTheme appBarTheme = AppBarTheme.of(context);
    final AppBarTheme defaults = _AppBarDefaultsM3(context);
    final ScaffoldState? scaffold = Scaffold.maybeOf(context);
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);

    final FlexibleSpaceBarSettings? settings = context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
    final Set<WidgetState> states = <WidgetState>{
      if (settings?.isScrolledUnder ?? _scrolledUnder) WidgetState.scrolledUnder,
    };

    final bool hasDrawer = scaffold?.hasDrawer ?? false;
    final bool hasEndDrawer = scaffold?.hasEndDrawer ?? false;
    final bool useCloseButton = parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;

    final double toolbarHeight = widget.toolbarHeight ?? appBarTheme.toolbarHeight ?? kToolbarHeight;

    final Color backgroundColor = _resolveColor(
      states,
      widget.backgroundColor,
      appBarTheme.backgroundColor,
      defaults.backgroundColor!,
    );

    final Color scrolledUnderBackground = _resolveColor(
      states,
      widget.backgroundColor,
      appBarTheme.backgroundColor,
      Theme.of(context).colorScheme.surfaceContainer,
    );

    final Color effectiveBackgroundColor =
        states.contains(WidgetState.scrolledUnder) ? scrolledUnderBackground : backgroundColor;

    final Color foregroundColor = widget.foregroundColor ?? appBarTheme.foregroundColor ?? defaults.foregroundColor!;

    final double elevation = widget.elevation ?? appBarTheme.elevation ?? defaults.elevation!;

    final double effectiveElevation =
        states.contains(WidgetState.scrolledUnder)
            ? widget.scrolledUnderElevation ??
                appBarTheme.scrolledUnderElevation ??
                defaults.scrolledUnderElevation ??
                elevation
            : elevation;

    IconThemeData overallIconTheme =
        widget.iconTheme ?? appBarTheme.iconTheme ?? defaults.iconTheme!.copyWith(color: foregroundColor);

    final Color? actionForegroundColor = widget.foregroundColor ?? appBarTheme.foregroundColor;
    IconThemeData actionsIconTheme =
        widget.actionsIconTheme ??
        appBarTheme.actionsIconTheme ??
        widget.iconTheme ??
        appBarTheme.iconTheme ??
        defaults.actionsIconTheme?.copyWith(color: actionForegroundColor) ??
        overallIconTheme;

    final EdgeInsetsGeometry actionsPadding =
        widget.actionsPadding ?? appBarTheme.actionsPadding ?? defaults.actionsPadding!;

    TextStyle? toolbarTextStyle =
        widget.toolbarTextStyle ??
        appBarTheme.toolbarTextStyle ??
        defaults.toolbarTextStyle?.copyWith(color: foregroundColor);

    TextStyle? titleTextStyle =
        widget.titleTextStyle ??
        appBarTheme.titleTextStyle ??
        defaults.titleTextStyle?.copyWith(color: foregroundColor);

    if (widget.toolbarOpacity != 1.0) {
      final double opacity = const Interval(0.25, 1.0, curve: Curves.fastOutSlowIn).transform(widget.toolbarOpacity);
      if (titleTextStyle?.color != null) {
        titleTextStyle = titleTextStyle!.copyWith(color: titleTextStyle.color!.withOpacity(opacity));
      }
      if (toolbarTextStyle?.color != null) {
        toolbarTextStyle = toolbarTextStyle!.copyWith(color: toolbarTextStyle.color!.withOpacity(opacity));
      }
      overallIconTheme = overallIconTheme.copyWith(opacity: opacity * (overallIconTheme.opacity ?? 1.0));
      actionsIconTheme = actionsIconTheme.copyWith(opacity: opacity * (actionsIconTheme.opacity ?? 1.0));
    }

    Widget? leading = widget.leading;
    if (leading == null && widget.automaticallyImplyLeading) {
      if (hasDrawer) {
        leading = DrawerButton(style: IconButton.styleFrom(iconSize: overallIconTheme.size ?? 24));
      } else if (parentRoute?.impliesAppBarDismissal ?? false) {
        leading = useCloseButton ? const CloseButton() : const BackButton();
      }
    }
    if (leading != null) {
      final IconButtonThemeData effectiveIconButtonTheme;

      // This comparison is to check if there is a custom [overallIconTheme]. If true, it means that no
      // custom [overallIconTheme] is provided, so [iconButtonTheme] is applied. Otherwise, we generate
      // a new [IconButtonThemeData] based on the values from [overallIconTheme]. If [iconButtonTheme] only
      // has null values, the default [overallIconTheme] will be applied below by [IconTheme.merge]
      if (overallIconTheme == defaults.iconTheme) {
        effectiveIconButtonTheme = iconButtonTheme;
      } else {
        // The [IconButton.styleFrom] method is used to generate a correct [overlayColor] based on the [foregroundColor].
        final ButtonStyle leadingIconButtonStyle = IconButton.styleFrom(
          foregroundColor: overallIconTheme.color,
          iconSize: overallIconTheme.size,
        );

        effectiveIconButtonTheme = IconButtonThemeData(
          style: iconButtonTheme.style?.copyWith(
            foregroundColor: leadingIconButtonStyle.foregroundColor,
            overlayColor: leadingIconButtonStyle.overlayColor,
            iconSize: leadingIconButtonStyle.iconSize,
          ),
        );
      }

      leading = IconButtonTheme(
        data: effectiveIconButtonTheme,
        child: leading is IconButton ? Center(child: leading) : leading,
      );

      // Based on the Material Design 3 specs, the leading IconButton should have
      // a size of 48x48, and a highlight size of 40x40. Users can also put other
      // type of widgets on leading with the original config.
      leading = ConstrainedBox(
        constraints: BoxConstraints.tightFor(width: widget.leadingWidth ?? appBarTheme.leadingWidth ?? _kLeadingWidth),
        child: leading,
      );
    }

    Widget? title = widget.title;
    if (title != null) {
      title = _AppBarTitleBox(child: title);
      if (!widget.excludeHeaderSemantics) {
        title = Semantics(
          namesRoute: switch (theme.platform) {
            TargetPlatform.android || TargetPlatform.fuchsia || TargetPlatform.linux || TargetPlatform.windows => true,
            TargetPlatform.iOS || TargetPlatform.macOS => null,
          },
          header: true,
          child: title,
        );
      }

      title = DefaultTextStyle(style: titleTextStyle!, softWrap: false, overflow: TextOverflow.ellipsis, child: title);

      // Set maximum text scale factor to [_kMaxTitleTextScaleFactor] for the
      // title to keep the visual hierarchy the same even with larger font
      // sizes. To opt out, wrap the [title] widget in a [MediaQuery] widget
      // with a different `TextScaler`.
      title = MediaQuery.withClampedTextScaling(maxScaleFactor: _kMaxTitleTextScaleFactor, child: title);
    }

    Widget? actions;
    if (widget.actions != null && widget.actions!.isNotEmpty) {
      actions = Padding(padding: actionsPadding, child: Row(mainAxisSize: MainAxisSize.min, children: widget.actions!));
    } else if (hasEndDrawer) {
      actions = EndDrawerButton(style: IconButton.styleFrom(iconSize: overallIconTheme.size ?? 24));
    }

    // Allow the trailing actions to have their own theme if necessary.
    if (actions != null) {
      final IconButtonThemeData effectiveActionsIconButtonTheme;
      if (actionsIconTheme == defaults.actionsIconTheme) {
        effectiveActionsIconButtonTheme = iconButtonTheme;
      } else {
        final ButtonStyle actionsIconButtonStyle = IconButton.styleFrom(
          foregroundColor: actionsIconTheme.color,
          iconSize: actionsIconTheme.size,
        );

        effectiveActionsIconButtonTheme = IconButtonThemeData(
          style: iconButtonTheme.style?.copyWith(
            foregroundColor: actionsIconButtonStyle.foregroundColor,
            overlayColor: actionsIconButtonStyle.overlayColor,
            iconSize: actionsIconButtonStyle.iconSize,
          ),
        );
      }

      actions = IconButtonTheme(
        data: effectiveActionsIconButtonTheme,
        child: IconTheme.merge(data: actionsIconTheme, child: actions),
      );
    }

    final Widget toolbar = NavigationToolbar(
      leading: leading,
      middle: title,
      trailing: actions,
      centerMiddle: widget._getEffectiveCenterTitle(theme),
      middleSpacing: widget.titleSpacing ?? appBarTheme.titleSpacing ?? NavigationToolbar.kMiddleSpacing,
    );

    // If the toolbar is allocated less than toolbarHeight make it
    // appear to scroll upwards within its shrinking container.
    Widget appBar = ClipRect(
      clipBehavior: widget.clipBehavior ?? Clip.hardEdge,
      child: CustomSingleChildLayout(
        delegate: _ToolbarContainerLayout(toolbarHeight),
        child: IconTheme.merge(
          data: overallIconTheme,
          child: DefaultTextStyle(style: toolbarTextStyle!, child: toolbar),
        ),
      ),
    );
    if (widget.bottom != null) {
      appBar = Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(child: ConstrainedBox(constraints: BoxConstraints(maxHeight: toolbarHeight), child: appBar)),
          if (widget.bottomOpacity == 1.0)
            widget.bottom!
          else
            Opacity(
              opacity: const Interval(0.25, 1.0, curve: Curves.fastOutSlowIn).transform(widget.bottomOpacity),
              child: widget.bottom,
            ),
        ],
      );
    }

    // The padding applies to the toolbar and tabbar, not the flexible space.
    if (widget.primary) {
      appBar = SafeArea(bottom: false, child: appBar);
    }

    appBar = Align(alignment: Alignment.topCenter, child: appBar);

    if (widget.flexibleSpace != null) {
      appBar = Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          Semantics(
            sortKey: widget.useDefaultSemanticsOrder ? const OrdinalSortKey(1.0) : null,
            explicitChildNodes: true,
            child: widget.flexibleSpace,
          ),
          Semantics(
            sortKey: widget.useDefaultSemanticsOrder ? const OrdinalSortKey(0.0) : null,
            explicitChildNodes: true,
            // Creates a material widget to prevent the flexibleSpace from
            // obscuring the ink splashes produced by appBar children.
            child: Material(type: MaterialType.transparency, child: appBar),
          ),
        ],
      );
    }

    final SystemUiOverlayStyle overlayStyle =
        widget.systemOverlayStyle ??
        appBarTheme.systemOverlayStyle ??
        defaults.systemOverlayStyle ??
        _systemOverlayStyleForBrightness(
          ThemeData.estimateBrightnessForColor(effectiveBackgroundColor),
          const Color(0x00000000),
        );

    return Semantics(
      container: true,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: overlayStyle,
        child: Material(
          color: effectiveBackgroundColor,
          elevation: effectiveElevation,
          type: widget.forceMaterialTransparency ? MaterialType.transparency : MaterialType.canvas,
          shadowColor: widget.shadowColor ?? appBarTheme.shadowColor ?? defaults.shadowColor,
          surfaceTintColor: widget.surfaceTintColor ?? appBarTheme.surfaceTintColor ?? theme.colorScheme.surfaceTint,
          shape: widget.shape ?? appBarTheme.shape ?? defaults.shape,
          child: Semantics(explicitChildNodes: true, child: appBar),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.leading,
    required this.automaticallyImplyLeading,
    required this.title,
    required this.actions,
    required this.flexibleSpace,
    required this.bottom,
    required this.elevation,
    required this.scrolledUnderElevation,
    required this.shadowColor,
    required this.surfaceTintColor,
    required this.forceElevated,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.iconTheme,
    required this.actionsIconTheme,
    required this.primary,
    required this.centerTitle,
    required this.excludeHeaderSemantics,
    required this.titleSpacing,
    required this.expandedHeight,
    required this.collapsedHeight,
    required this.topPadding,
    required this.floating,
    required this.pinned,
    required this.vsync,
    required this.snapConfiguration,
    required this.stretchConfiguration,
    required this.showOnScreenConfiguration,
    required this.shape,
    required this.toolbarHeight,
    required this.leadingWidth,
    required this.toolbarTextStyle,
    required this.titleTextStyle,
    required this.systemOverlayStyle,
    required this.forceMaterialTransparency,
    required this.useDefaultSemanticsOrder,
    required this.clipBehavior,
    required this.variant,
    required this.accessibleNavigation,
    required this.actionsPadding,
  }) : assert(primary || topPadding == 0.0),
       _bottomHeight = bottom?.preferredSize.height ?? 0.0;

  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Widget? title;
  final List<Widget>? actions;
  final Widget? flexibleSpace;
  final PreferredSizeWidget? bottom;
  final double? elevation;
  final double? scrolledUnderElevation;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final bool forceElevated;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconThemeData? iconTheme;
  final IconThemeData? actionsIconTheme;
  final bool primary;
  final bool? centerTitle;
  final bool excludeHeaderSemantics;
  final double? titleSpacing;
  final double? expandedHeight;
  final double collapsedHeight;
  final double topPadding;
  final bool floating;
  final bool pinned;
  final ShapeBorder? shape;
  final double? toolbarHeight;
  final double? leadingWidth;
  final TextStyle? toolbarTextStyle;
  final TextStyle? titleTextStyle;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final double _bottomHeight;
  final bool forceMaterialTransparency;
  final bool useDefaultSemanticsOrder;
  final Clip? clipBehavior;
  final _SliverAppVariant variant;
  final bool accessibleNavigation;
  final EdgeInsetsGeometry? actionsPadding;

  @override
  double get minExtent => collapsedHeight;

  @override
  double get maxExtent =>
      math.max(topPadding + (expandedHeight ?? (toolbarHeight ?? kToolbarHeight) + _bottomHeight), minExtent);

  @override
  final TickerProvider vsync;

  @override
  final FloatingHeaderSnapConfiguration? snapConfiguration;

  @override
  final OverScrollHeaderStretchConfiguration? stretchConfiguration;

  @override
  final PersistentHeaderShowOnScreenConfiguration? showOnScreenConfiguration;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final double visibleMainHeight = maxExtent - shrinkOffset - topPadding;
    final double extraToolbarHeight = math.max(
      minExtent - _bottomHeight - topPadding - (toolbarHeight ?? kToolbarHeight),
      0.0,
    );
    final double visibleToolbarHeight = visibleMainHeight - _bottomHeight - extraToolbarHeight;

    final bool isScrolledUnder = overlapsContent || forceElevated || (pinned && shrinkOffset > maxExtent - minExtent);
    final bool isPinnedWithOpacityFade = pinned && floating && bottom != null && extraToolbarHeight == 0.0;
    final double toolbarOpacity =
        !accessibleNavigation && (!pinned || isPinnedWithOpacityFade)
            ? clampDouble(visibleToolbarHeight / (toolbarHeight ?? kToolbarHeight), 0.0, 1.0)
            : 1.0;
    final Widget? effectiveTitle = switch (variant) {
      _SliverAppVariant.small => title,
      _SliverAppVariant.medium || _SliverAppVariant.large => AnimatedOpacity(
        opacity: isScrolledUnder ? 1 : 0,
        duration: const Duration(milliseconds: 500),
        curve: const Cubic(0.2, 0.0, 0.0, 1.0),
        child: title,
      ),
    };

    final Widget appBar = FlexibleSpaceBar.createSettings(
      minExtent: minExtent,
      maxExtent: maxExtent,
      currentExtent: math.max(minExtent, maxExtent - shrinkOffset),
      toolbarOpacity: toolbarOpacity,
      isScrolledUnder: isScrolledUnder,
      hasLeading: leading != null || automaticallyImplyLeading,
      child: AppBar(
        clipBehavior: clipBehavior,
        leading: leading,
        automaticallyImplyLeading: automaticallyImplyLeading,
        title: effectiveTitle,
        actions: actions,
        flexibleSpace:
            (title == null && flexibleSpace != null && !excludeHeaderSemantics)
                ? Semantics(header: true, child: flexibleSpace)
                : flexibleSpace,
        bottom: bottom,
        elevation: isScrolledUnder ? elevation : 0.0,
        scrolledUnderElevation: scrolledUnderElevation,
        shadowColor: shadowColor,
        surfaceTintColor: surfaceTintColor,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        iconTheme: iconTheme,
        actionsIconTheme: actionsIconTheme,
        primary: primary,
        centerTitle: centerTitle,
        excludeHeaderSemantics: excludeHeaderSemantics,
        titleSpacing: titleSpacing,
        shape: shape,
        toolbarOpacity: toolbarOpacity,
        bottomOpacity: pinned ? 1.0 : clampDouble(visibleMainHeight / _bottomHeight, 0.0, 1.0),
        toolbarHeight: toolbarHeight,
        leadingWidth: leadingWidth,
        toolbarTextStyle: toolbarTextStyle,
        titleTextStyle: titleTextStyle,
        systemOverlayStyle: systemOverlayStyle,
        forceMaterialTransparency: forceMaterialTransparency,
        useDefaultSemanticsOrder: useDefaultSemanticsOrder,
        actionsPadding: actionsPadding,
      ),
    );
    return appBar;
  }

  @override
  bool shouldRebuild(covariant _SliverAppBarDelegate oldDelegate) =>
      leading != oldDelegate.leading ||
      automaticallyImplyLeading != oldDelegate.automaticallyImplyLeading ||
      title != oldDelegate.title ||
      actions != oldDelegate.actions ||
      flexibleSpace != oldDelegate.flexibleSpace ||
      bottom != oldDelegate.bottom ||
      _bottomHeight != oldDelegate._bottomHeight ||
      elevation != oldDelegate.elevation ||
      shadowColor != oldDelegate.shadowColor ||
      backgroundColor != oldDelegate.backgroundColor ||
      foregroundColor != oldDelegate.foregroundColor ||
      iconTheme != oldDelegate.iconTheme ||
      actionsIconTheme != oldDelegate.actionsIconTheme ||
      primary != oldDelegate.primary ||
      centerTitle != oldDelegate.centerTitle ||
      titleSpacing != oldDelegate.titleSpacing ||
      expandedHeight != oldDelegate.expandedHeight ||
      topPadding != oldDelegate.topPadding ||
      pinned != oldDelegate.pinned ||
      floating != oldDelegate.floating ||
      vsync != oldDelegate.vsync ||
      snapConfiguration != oldDelegate.snapConfiguration ||
      stretchConfiguration != oldDelegate.stretchConfiguration ||
      showOnScreenConfiguration != oldDelegate.showOnScreenConfiguration ||
      forceElevated != oldDelegate.forceElevated ||
      toolbarHeight != oldDelegate.toolbarHeight ||
      leadingWidth != oldDelegate.leadingWidth ||
      toolbarTextStyle != oldDelegate.toolbarTextStyle ||
      titleTextStyle != oldDelegate.titleTextStyle ||
      systemOverlayStyle != oldDelegate.systemOverlayStyle ||
      forceMaterialTransparency != oldDelegate.forceMaterialTransparency ||
      useDefaultSemanticsOrder != oldDelegate.useDefaultSemanticsOrder ||
      accessibleNavigation != oldDelegate.accessibleNavigation ||
      actionsPadding != oldDelegate.actionsPadding;

  @override
  String toString() =>
      '${describeIdentity(this)}(topPadding: ${topPadding.toStringAsFixed(1)}, bottomHeight: ${_bottomHeight.toStringAsFixed(1)}, ...)';
}

class SliverAppBar extends StatefulWidget {
  const SliverAppBar({
    super.key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.actions,
    this.flexibleSpace,
    this.bottom,
    this.elevation,
    this.scrolledUnderElevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.forceElevated = false,
    this.backgroundColor,
    this.foregroundColor,
    this.iconTheme,
    this.actionsIconTheme,
    this.primary = true,
    this.centerTitle,
    this.excludeHeaderSemantics = false,
    this.titleSpacing,
    this.collapsedHeight,
    this.expandedHeight,
    this.floating = false,
    this.pinned = false,
    this.snap = false,
    this.stretch = false,
    this.stretchTriggerOffset = 100.0,
    this.onStretchTrigger,
    this.shape,
    this.toolbarHeight = kToolbarHeight,
    this.leadingWidth,
    this.toolbarTextStyle,
    this.titleTextStyle,
    this.systemOverlayStyle,
    this.forceMaterialTransparency = false,
    this.useDefaultSemanticsOrder = true,
    this.clipBehavior,
    this.actionsPadding,
  }) : assert(floating || !snap, 'The "snap" argument only makes sense for floating app bars.'),
       assert(stretchTriggerOffset > 0.0),
       assert(
         collapsedHeight == null || collapsedHeight >= toolbarHeight,
         'The "collapsedHeight" argument has to be larger than or equal to [toolbarHeight].',
       ),
       _variant = _SliverAppVariant.small;

  const SliverAppBar.medium({
    super.key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.actions,
    this.flexibleSpace,
    this.bottom,
    this.elevation,
    this.scrolledUnderElevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.forceElevated = false,
    this.backgroundColor,
    this.foregroundColor,
    this.iconTheme,
    this.actionsIconTheme,
    this.primary = true,
    this.centerTitle,
    this.excludeHeaderSemantics = false,
    this.titleSpacing,
    this.collapsedHeight,
    this.expandedHeight,
    this.floating = false,
    this.pinned = true,
    this.snap = false,
    this.stretch = false,
    this.stretchTriggerOffset = 100.0,
    this.onStretchTrigger,
    this.shape,
    this.toolbarHeight = _MediumScrollUnderFlexibleConfig.collapsedHeight,
    this.leadingWidth,
    this.toolbarTextStyle,
    this.titleTextStyle,
    this.systemOverlayStyle,
    this.forceMaterialTransparency = false,
    this.useDefaultSemanticsOrder = true,
    this.clipBehavior,
    this.actionsPadding,
  }) : assert(floating || !snap, 'The "snap" argument only makes sense for floating app bars.'),
       assert(stretchTriggerOffset > 0.0),
       assert(
         collapsedHeight == null || collapsedHeight >= toolbarHeight,
         'The "collapsedHeight" argument has to be larger than or equal to [toolbarHeight].',
       ),
       _variant = _SliverAppVariant.medium;

  const SliverAppBar.large({
    super.key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.actions,
    this.flexibleSpace,
    this.bottom,
    this.elevation,
    this.scrolledUnderElevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.forceElevated = false,
    this.backgroundColor,
    this.foregroundColor,
    this.iconTheme,
    this.actionsIconTheme,
    this.primary = true,
    this.centerTitle,
    this.excludeHeaderSemantics = false,
    this.titleSpacing,
    this.collapsedHeight,
    this.expandedHeight,
    this.floating = false,
    this.pinned = true,
    this.snap = false,
    this.stretch = false,
    this.stretchTriggerOffset = 100.0,
    this.onStretchTrigger,
    this.shape,
    this.toolbarHeight = _LargeScrollUnderFlexibleConfig.collapsedHeight,
    this.leadingWidth,
    this.toolbarTextStyle,
    this.titleTextStyle,
    this.systemOverlayStyle,
    this.forceMaterialTransparency = false,
    this.useDefaultSemanticsOrder = true,
    this.clipBehavior,
    this.actionsPadding,
  }) : assert(floating || !snap, 'The "snap" argument only makes sense for floating app bars.'),
       assert(stretchTriggerOffset > 0.0),
       assert(
         collapsedHeight == null || collapsedHeight >= toolbarHeight,
         'The "collapsedHeight" argument has to be larger than or equal to [toolbarHeight].',
       ),
       _variant = _SliverAppVariant.large;

  final Widget? leading;

  final bool automaticallyImplyLeading;

  final Widget? title;

  final List<Widget>? actions;

  final Widget? flexibleSpace;

  final PreferredSizeWidget? bottom;

  final double? elevation;

  final double? scrolledUnderElevation;

  final Color? shadowColor;

  final Color? surfaceTintColor;

  final bool forceElevated;

  final Color? backgroundColor;

  final Color? foregroundColor;

  final IconThemeData? iconTheme;

  final IconThemeData? actionsIconTheme;

  final bool primary;

  final bool? centerTitle;

  final bool excludeHeaderSemantics;

  final double? titleSpacing;

  final double? collapsedHeight;

  final double? expandedHeight;

  final bool floating;

  final bool pinned;

  final ShapeBorder? shape;

  final bool snap;

  final bool stretch;

  final double stretchTriggerOffset;

  final AsyncCallback? onStretchTrigger;

  final double toolbarHeight;

  final double? leadingWidth;

  final TextStyle? toolbarTextStyle;

  final TextStyle? titleTextStyle;

  final SystemUiOverlayStyle? systemOverlayStyle;

  final bool forceMaterialTransparency;

  final bool useDefaultSemanticsOrder;

  final Clip? clipBehavior;

  final EdgeInsetsGeometry? actionsPadding;

  final _SliverAppVariant _variant;

  @override
  State<SliverAppBar> createState() => _SliverAppBarState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('automaticallyImplyLeading', automaticallyImplyLeading));
    properties.add(DoubleProperty('elevation', elevation));
    properties.add(DoubleProperty('scrolledUnderElevation', scrolledUnderElevation));
    properties.add(ColorProperty('shadowColor', shadowColor));
    properties.add(ColorProperty('surfaceTintColor', surfaceTintColor));
    properties.add(DiagnosticsProperty<bool>('forceElevated', forceElevated));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(ColorProperty('foregroundColor', foregroundColor));
    properties.add(DiagnosticsProperty<IconThemeData?>('iconTheme', iconTheme));
    properties.add(DiagnosticsProperty<IconThemeData?>('actionsIconTheme', actionsIconTheme));
    properties.add(DiagnosticsProperty<bool>('primary', primary));
    properties.add(DiagnosticsProperty<bool?>('centerTitle', centerTitle));
    properties.add(DiagnosticsProperty<bool>('excludeHeaderSemantics', excludeHeaderSemantics));
    properties.add(DoubleProperty('titleSpacing', titleSpacing));
    properties.add(DoubleProperty('collapsedHeight', collapsedHeight));
    properties.add(DoubleProperty('expandedHeight', expandedHeight));
    properties.add(DiagnosticsProperty<bool>('floating', floating));
    properties.add(DiagnosticsProperty<bool>('pinned', pinned));
    properties.add(DiagnosticsProperty<ShapeBorder?>('shape', shape));
    properties.add(DiagnosticsProperty<bool>('snap', snap));
    properties.add(DiagnosticsProperty<bool>('stretch', stretch));
    properties.add(DoubleProperty('stretchTriggerOffset', stretchTriggerOffset));
    properties.add(ObjectFlagProperty<AsyncCallback?>.has('onStretchTrigger', onStretchTrigger));
    properties.add(DoubleProperty('toolbarHeight', toolbarHeight));
    properties.add(DoubleProperty('leadingWidth', leadingWidth));
    properties.add(DiagnosticsProperty<TextStyle?>('toolbarTextStyle', toolbarTextStyle));
    properties.add(DiagnosticsProperty<TextStyle?>('titleTextStyle', titleTextStyle));
    properties.add(DiagnosticsProperty<SystemUiOverlayStyle?>('systemOverlayStyle', systemOverlayStyle));
    properties.add(DiagnosticsProperty<bool>('forceMaterialTransparency', forceMaterialTransparency));
    properties.add(DiagnosticsProperty<bool>('useDefaultSemanticsOrder', useDefaultSemanticsOrder));
    properties.add(EnumProperty<Clip?>('clipBehavior', clipBehavior));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('actionsPadding', actionsPadding));
  }
}

// This class is only Stateful because it owns the TickerProvider used
// by the floating appbar snap animation (via FloatingHeaderSnapConfiguration).
class _SliverAppBarState extends State<SliverAppBar> with TickerProviderStateMixin {
  FloatingHeaderSnapConfiguration? _snapConfiguration;
  OverScrollHeaderStretchConfiguration? _stretchConfiguration;
  PersistentHeaderShowOnScreenConfiguration? _showOnScreenConfiguration;

  void _updateSnapConfiguration() {
    if (widget.snap && widget.floating) {
      _snapConfiguration = FloatingHeaderSnapConfiguration(
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 200),
      );
    } else {
      _snapConfiguration = null;
    }

    _showOnScreenConfiguration =
        widget.floating & widget.snap
            ? const PersistentHeaderShowOnScreenConfiguration(minShowOnScreenExtent: double.infinity)
            : null;
  }

  void _updateStretchConfiguration() {
    if (widget.stretch) {
      _stretchConfiguration = OverScrollHeaderStretchConfiguration(
        stretchTriggerOffset: widget.stretchTriggerOffset,
        onStretchTrigger: widget.onStretchTrigger,
      );
    } else {
      _stretchConfiguration = null;
    }
  }

  @override
  void initState() {
    super.initState();
    _updateSnapConfiguration();
    _updateStretchConfiguration();
  }

  @override
  void didUpdateWidget(SliverAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.snap != oldWidget.snap || widget.floating != oldWidget.floating) {
      _updateSnapConfiguration();
    }
    if (widget.stretch != oldWidget.stretch) {
      _updateStretchConfiguration();
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(!widget.primary || debugCheckHasMediaQuery(context));
    final double bottomHeight = widget.bottom?.preferredSize.height ?? 0.0;
    final double topPadding = widget.primary ? MediaQuery.paddingOf(context).top : 0.0;
    final double collapsedHeight =
        (widget.pinned && widget.floating && widget.bottom != null)
            ? (widget.collapsedHeight ?? 0.0) + bottomHeight + topPadding
            : (widget.collapsedHeight ?? widget.toolbarHeight) + bottomHeight + topPadding;
    final double? effectiveExpandedHeight;
    final double effectiveCollapsedHeight;
    final Widget? effectiveFlexibleSpace;
    switch (widget._variant) {
      case _SliverAppVariant.small:
        effectiveExpandedHeight = widget.expandedHeight;
        effectiveCollapsedHeight = collapsedHeight;
        effectiveFlexibleSpace = widget.flexibleSpace;
      case _SliverAppVariant.medium:
        effectiveExpandedHeight =
            widget.expandedHeight ?? _MediumScrollUnderFlexibleConfig.expandedHeight + bottomHeight;
        effectiveCollapsedHeight =
            widget.collapsedHeight ?? topPadding + _MediumScrollUnderFlexibleConfig.collapsedHeight + bottomHeight;
        effectiveFlexibleSpace =
            widget.flexibleSpace ??
            _ScrollUnderFlexibleSpace(
              title: widget.title,
              foregroundColor: widget.foregroundColor,
              configBuilder: _MediumScrollUnderFlexibleConfig.new,
              titleTextStyle: widget.titleTextStyle,
              bottomHeight: bottomHeight,
            );
      case _SliverAppVariant.large:
        effectiveExpandedHeight =
            widget.expandedHeight ?? _LargeScrollUnderFlexibleConfig.expandedHeight + bottomHeight;
        effectiveCollapsedHeight =
            widget.collapsedHeight ?? topPadding + _LargeScrollUnderFlexibleConfig.collapsedHeight + bottomHeight;
        effectiveFlexibleSpace =
            widget.flexibleSpace ??
            _ScrollUnderFlexibleSpace(
              title: widget.title,
              foregroundColor: widget.foregroundColor,
              configBuilder: _LargeScrollUnderFlexibleConfig.new,
              titleTextStyle: widget.titleTextStyle,
              bottomHeight: bottomHeight,
            );
    }

    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      child: SliverPersistentHeader(
        floating: widget.floating,
        pinned: widget.pinned,
        delegate: _SliverAppBarDelegate(
          vsync: this,
          leading: widget.leading,
          automaticallyImplyLeading: widget.automaticallyImplyLeading,
          title: widget.title,
          actions: widget.actions,
          flexibleSpace: effectiveFlexibleSpace,
          bottom: widget.bottom,
          elevation: widget.elevation,
          scrolledUnderElevation: widget.scrolledUnderElevation,
          shadowColor: widget.shadowColor,
          surfaceTintColor: widget.surfaceTintColor,
          forceElevated: widget.forceElevated,
          backgroundColor: widget.backgroundColor,
          foregroundColor: widget.foregroundColor,
          iconTheme: widget.iconTheme,
          actionsIconTheme: widget.actionsIconTheme,
          primary: widget.primary,
          centerTitle: widget.centerTitle,
          excludeHeaderSemantics: widget.excludeHeaderSemantics,
          titleSpacing: widget.titleSpacing,
          expandedHeight: effectiveExpandedHeight,
          collapsedHeight: effectiveCollapsedHeight,
          topPadding: topPadding,
          floating: widget.floating,
          pinned: widget.pinned,
          shape: widget.shape,
          snapConfiguration: _snapConfiguration,
          stretchConfiguration: _stretchConfiguration,
          showOnScreenConfiguration: _showOnScreenConfiguration,
          toolbarHeight: widget.toolbarHeight,
          leadingWidth: widget.leadingWidth,
          toolbarTextStyle: widget.toolbarTextStyle,
          titleTextStyle: widget.titleTextStyle,
          systemOverlayStyle: widget.systemOverlayStyle,
          forceMaterialTransparency: widget.forceMaterialTransparency,
          useDefaultSemanticsOrder: widget.useDefaultSemanticsOrder,
          clipBehavior: widget.clipBehavior,
          variant: widget._variant,
          accessibleNavigation: MediaQuery.of(context).accessibleNavigation,
          actionsPadding: widget.actionsPadding,
        ),
      ),
    );
  }
}

// Layout the AppBar's title with unconstrained height, vertically
// center it within its (NavigationToolbar) parent, and allow the
// parent to constrain the title's actual height.
class _AppBarTitleBox extends SingleChildRenderObjectWidget {
  const _AppBarTitleBox({required Widget super.child});

  @override
  _RenderAppBarTitleBox createRenderObject(BuildContext context) =>
      _RenderAppBarTitleBox(textDirection: Directionality.of(context));

  @override
  void updateRenderObject(BuildContext context, _RenderAppBarTitleBox renderObject) {
    renderObject.textDirection = Directionality.of(context);
  }
}

class _RenderAppBarTitleBox extends RenderAligningShiftedBox {
  _RenderAppBarTitleBox({super.textDirection}) : super(alignment: Alignment.center);

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final BoxConstraints innerConstraints = constraints.copyWith(maxHeight: double.infinity);
    final Size childSize = child!.getDryLayout(innerConstraints);
    return constraints.constrain(childSize);
  }

  @override
  double? computeDryBaseline(covariant BoxConstraints constraints, TextBaseline baseline) {
    final BoxConstraints innerConstraints = constraints.copyWith(maxHeight: double.infinity);
    final RenderBox? child = this.child;
    if (child == null) {
      return null;
    }
    final double? result = child.getDryBaseline(innerConstraints, baseline);
    if (result == null) {
      return null;
    }
    final Size childSize = child.getDryLayout(innerConstraints);
    return result + resolvedAlignment.alongOffset(getDryLayout(constraints) - childSize as Offset).dy;
  }

  @override
  void performLayout() {
    final BoxConstraints innerConstraints = constraints.copyWith(maxHeight: double.infinity);
    child!.layout(innerConstraints, parentUsesSize: true);
    size = constraints.constrain(child!.size);
    alignChild();
  }
}

class _ScrollUnderFlexibleSpace extends StatelessWidget {
  const _ScrollUnderFlexibleSpace({
    required this.configBuilder,
    required this.bottomHeight,
    this.title,
    this.foregroundColor,
    this.titleTextStyle,
  });

  final Widget? title;
  final Color? foregroundColor;
  final _ScrollUnderFlexibleConfig Function(BuildContext) configBuilder;
  final TextStyle? titleTextStyle;
  final double bottomHeight;

  @override
  Widget build(BuildContext context) {
    late final AppBarTheme appBarTheme = AppBarTheme.of(context);
    late final AppBarTheme defaults = _AppBarDefaultsM3(context);
    final FlexibleSpaceBarSettings settings = context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>()!;
    final _ScrollUnderFlexibleConfig config = configBuilder(context);
    assert(
      config.expandedTitlePadding.isNonNegative,
      'The _ExpandedTitleWithPadding widget assumes that the expanded title padding is non-negative. '
      'Update its implementation to handle negative padding.',
    );

    final TextStyle? expandedTextStyle =
        titleTextStyle ??
        appBarTheme.titleTextStyle ??
        config.expandedTextStyle?.copyWith(
          color: foregroundColor ?? appBarTheme.foregroundColor ?? defaults.foregroundColor,
        );

    final Widget? expandedTitle = switch ((title, expandedTextStyle)) {
      (null, _) => null,
      (final Widget title, null) => title,
      (final Widget title, final TextStyle textStyle) => DefaultTextStyle(style: textStyle, child: title),
    };

    final EdgeInsets resolvedTitlePadding = config.expandedTitlePadding.resolve(Directionality.of(context));
    final EdgeInsetsGeometry expandedTitlePadding =
        bottomHeight > 0 ? resolvedTitlePadding.copyWith(bottom: 0) : resolvedTitlePadding;

    // Set maximum text scale factor to [_kMaxTitleTextScaleFactor] for the
    // title to keep the visual hierarchy the same even with larger font
    // sizes. To opt out, wrap the [title] widget in a [MediaQuery] widget
    // with a different TextScaler.
    // TODO(tahatesser): Add link to Material spec when available, https://github.com/flutter/flutter/issues/58769.
    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: _kMaxTitleTextScaleFactor,
      // This column will assume the full height of the parent Stack.
      child: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: settings.minExtent - bottomHeight)),
          Flexible(
            child: ClipRect(
              child: _ExpandedTitleWithPadding(
                padding: expandedTitlePadding,
                maxExtent: settings.maxExtent - settings.minExtent,
                child: expandedTitle,
              ),
            ),
          ),
          // Reserve space for AppBar.bottom, which is a sibling of this widget,
          // on the parent Stack.
          if (bottomHeight > 0) Padding(padding: EdgeInsets.only(bottom: bottomHeight)),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('foregroundColor', foregroundColor))
      ..add(
        ObjectFlagProperty<_ScrollUnderFlexibleConfig Function(BuildContext p1)>.has('configBuilder', configBuilder),
      )
      ..add(DiagnosticsProperty<TextStyle?>('titleTextStyle', titleTextStyle))
      ..add(DoubleProperty('bottomHeight', bottomHeight));
  }
}

// A widget that bottom-start aligns its child (the expanded title widget), and
// insets the child according to the specified padding.
//
// This widget gives the child an infinite max height constraint, and will also
// attempt to vertically limit the child's bounding box (not including the
// padding) to within the y range [0, maxExtent], to make sure the child is
// visible when the AppBar is fully expanded.
class _ExpandedTitleWithPadding extends SingleChildRenderObjectWidget {
  const _ExpandedTitleWithPadding({required this.padding, required this.maxExtent, super.child});

  final EdgeInsetsGeometry padding;
  final double maxExtent;

  @override
  _RenderExpandedTitleBox createRenderObject(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);
    return _RenderExpandedTitleBox(
      padding.resolve(textDirection),
      AlignmentDirectional.bottomStart.resolve(textDirection),
      maxExtent,
      null,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderExpandedTitleBox renderObject) {
    final TextDirection textDirection = Directionality.of(context);
    renderObject
      ..padding = padding.resolve(textDirection)
      ..titleAlignment = AlignmentDirectional.bottomStart.resolve(textDirection)
      ..maxExtent = maxExtent;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding));
    properties.add(DoubleProperty('maxExtent', maxExtent));
  }
}

class _RenderExpandedTitleBox extends RenderShiftedBox {
  _RenderExpandedTitleBox(this._padding, this._titleAlignment, this._maxExtent, super.child);

  EdgeInsets get padding => _padding;
  EdgeInsets _padding;
  set padding(EdgeInsets value) {
    if (_padding == value) {
      return;
    }
    assert(value.isNonNegative);
    _padding = value;
    markNeedsLayout();
  }

  Alignment get titleAlignment => _titleAlignment;
  Alignment _titleAlignment;
  set titleAlignment(Alignment value) {
    if (_titleAlignment == value) {
      return;
    }
    _titleAlignment = value;
    markNeedsLayout();
  }

  double get maxExtent => _maxExtent;
  double _maxExtent;
  set maxExtent(double value) {
    if (_maxExtent == value) {
      return;
    }
    _maxExtent = value;
    markNeedsLayout();
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    final RenderBox? child = this.child;
    return child == null
        ? 0.0
        : child.getMaxIntrinsicHeight(math.max(0, width - padding.horizontal)) + padding.vertical;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    final RenderBox? child = this.child;
    return child == null ? 0.0 : child.getMaxIntrinsicWidth(double.infinity) + padding.horizontal;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    final RenderBox? child = this.child;
    return child == null
        ? 0.0
        : child.getMinIntrinsicHeight(math.max(0, width - padding.horizontal)) + padding.vertical;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    final RenderBox? child = this.child;
    return child == null ? 0.0 : child.getMinIntrinsicWidth(double.infinity) + padding.horizontal;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) => child == null ? Size.zero : constraints.biggest;

  Offset _childOffsetFromSize(Size childSize, Size size) {
    assert(child != null);
    assert(padding.isNonNegative);
    assert(titleAlignment.y == 1.0);
    // yAdjustment is the minimum additional y offset to shift the child in
    // the visible vertical space when AppBar is fully expanded. The goal is to
    // prevent the expanded title from being clipped when the expanded title
    // widget + the bottom padding is too tall to fit in the flexible space (the
    // top padding is basically ignored since the expanded title is
    // bottom-aligned).
    final double yAdjustment = clampDouble(childSize.height + padding.bottom - maxExtent, 0, padding.bottom);
    final double offsetX =
        (titleAlignment.x + 1) / 2 * (size.width - padding.horizontal - childSize.width) + padding.left;
    final double offsetY = size.height - childSize.height - padding.bottom + yAdjustment;
    return Offset(offsetX, offsetY);
  }

  @override
  double? computeDryBaseline(covariant BoxConstraints constraints, TextBaseline baseline) {
    final RenderBox? child = this.child;
    if (child == null) {
      return null;
    }
    final BoxConstraints childConstraints = constraints.widthConstraints().deflate(padding);
    final BaselineOffset result =
        BaselineOffset(child.getDryBaseline(childConstraints, baseline)) +
        _childOffsetFromSize(child.getDryLayout(childConstraints), getDryLayout(constraints)).dy;
    return result.offset;
  }

  @override
  void performLayout() {
    final RenderBox? child = this.child;
    if (child == null) {
      size = constraints.smallest;
      return;
    }
    size = constraints.biggest;
    child.layout(constraints.widthConstraints().deflate(padding), parentUsesSize: true);
    final BoxParentData childParentData = child.parentData! as BoxParentData;
    childParentData.offset = _childOffsetFromSize(child.size, size);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<EdgeInsets>('padding', padding))
      ..add(DiagnosticsProperty<Alignment>('titleAlignment', titleAlignment))
      ..add(DoubleProperty('maxExtent', maxExtent));
  }
}

mixin _ScrollUnderFlexibleConfig {
  TextStyle? get collapsedTextStyle;
  TextStyle? get expandedTextStyle;
  EdgeInsetsGeometry get expandedTitlePadding;
}

// BEGIN GENERATED TOKEN PROPERTIES - AppBar

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// dart format off
 class _AppBarDefaultsM3 implements AppBarTheme {
  _AppBarDefaultsM3(this.context);

  final BuildContext context;
  late final ThemeData _theme = Theme.of(context);
  late final ColorScheme _colors = _theme.colorScheme;
  late final TextTheme _textTheme = _theme.textTheme;

  @override
  Color? get backgroundColor => _colors.surface;

  @override
  Color? get foregroundColor => _colors.onSurface;

  @override
  double? get elevation => 0.0;

  @override
  double? get scrolledUnderElevation => 3.0;

  @override
  Color? get shadowColor => Colors.transparent;

  @override
  Color? get surfaceTintColor => Colors.transparent;

  @override
  ShapeBorder? get shape => null;

  @override
  IconThemeData? get iconTheme => IconThemeData(
        color: _colors.onSurface,
        size: 24.0,
      );

  @override
  IconThemeData? get actionsIconTheme => IconThemeData(
        color: _colors.onSurfaceVariant,
        size: 24.0,
      );

  @override
  bool? get centerTitle => null;

  @override
  double? get titleSpacing => NavigationToolbar.kMiddleSpacing;

  @override
  double? get leadingWidth => null;

  @override
  double? get toolbarHeight => 64.0;

  @override
  TextStyle? get toolbarTextStyle => _textTheme.bodyMedium;

  @override
  TextStyle? get titleTextStyle => _textTheme.titleLarge;

  @override
  SystemUiOverlayStyle? get systemOverlayStyle => null;

  @override
  EdgeInsetsGeometry? get actionsPadding => EdgeInsets.zero;
  
  @override
  $AppBarThemeCopyWith<AppBarTheme> get copyWith => throw UnimplementedError();
}


// Variant configuration
class _MediumScrollUnderFlexibleConfig with _ScrollUnderFlexibleConfig {
  _MediumScrollUnderFlexibleConfig(this.context);

  final BuildContext context;
  late final ThemeData _theme = Theme.of(context);
  late final ColorScheme _colors = _theme.colorScheme;
  late final TextTheme _textTheme = _theme.textTheme;

  static const double collapsedHeight = 64.0;
  static const double expandedHeight = 112.0;

  @override
  TextStyle? get collapsedTextStyle =>
    _textTheme.titleLarge?.apply(color: _colors.onSurface);

  @override
  TextStyle? get expandedTextStyle =>
    _textTheme.headlineSmall?.apply(color: _colors.onSurface);

  @override
  EdgeInsetsGeometry get expandedTitlePadding => const EdgeInsets.fromLTRB(16, 0, 16, 20);
}

class _LargeScrollUnderFlexibleConfig with _ScrollUnderFlexibleConfig {
  _LargeScrollUnderFlexibleConfig(this.context);

  final BuildContext context;
  late final ThemeData _theme = Theme.of(context);
  late final ColorScheme _colors = _theme.colorScheme;
  late final TextTheme _textTheme = _theme.textTheme;

  static const double collapsedHeight = 64.0;
  static const double expandedHeight = 152.0;

  @override
  TextStyle? get collapsedTextStyle =>
    _textTheme.titleLarge?.apply(color: _colors.onSurface);

  @override
  TextStyle? get expandedTextStyle =>
    _textTheme.headlineMedium?.apply(color: _colors.onSurface);

  @override
  EdgeInsetsGeometry get expandedTitlePadding => const EdgeInsets.fromLTRB(16, 0, 16, 28);
}
// dart format on

// END GENERATED TOKEN PROPERTIES - AppBar
