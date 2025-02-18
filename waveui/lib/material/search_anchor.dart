// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/adaptive_text_selection_toolbar.dart';
import 'package:waveui/material/back_button.dart';
import 'package:waveui/material/button_style.dart';
import 'package:waveui/material/color_scheme.dart';
import 'package:waveui/material/colors.dart';
import 'package:waveui/material/constants.dart';
import 'package:waveui/material/divider.dart';
import 'package:waveui/material/divider_theme.dart';
import 'package:waveui/material/icon_button.dart';
import 'package:waveui/material/icons.dart';
import 'package:waveui/material/ink_well.dart';
import 'package:waveui/material/input_border.dart';
import 'package:waveui/material/input_decorator.dart';
import 'package:waveui/material/material.dart';
import 'package:waveui/material/material_localizations.dart';
import 'package:waveui/material/search_bar_theme.dart';
import 'package:waveui/material/search_view_theme.dart';
import 'package:waveui/material/text_field.dart';
import 'package:waveui/src/theme/text_theme.dart';
import 'package:waveui/material/theme.dart';
import 'package:waveui/material/theme_data.dart';

const int _kOpenViewMilliseconds = 600;
const Duration _kOpenViewDuration = Duration(milliseconds: _kOpenViewMilliseconds);
const Duration _kAnchorFadeDuration = Duration(milliseconds: 150);
const Curve _kViewFadeOnInterval = Interval(0.0, 1 / 2);
const Curve _kViewIconsFadeOnInterval = Interval(1 / 6, 2 / 6);
const Curve _kViewDividerFadeOnInterval = Interval(0.0, 1 / 6);
const Curve _kViewListFadeOnInterval = Interval(133 / _kOpenViewMilliseconds, 233 / _kOpenViewMilliseconds);
const double _kDisableSearchBarOpacity = 0.38;

typedef SearchAnchorChildBuilder = Widget Function(BuildContext context, SearchController controller);

typedef SuggestionsBuilder = FutureOr<Iterable<Widget>> Function(BuildContext context, SearchController controller);

typedef ViewBuilder = Widget Function(Iterable<Widget> suggestions);

class SearchAnchor extends StatefulWidget {
  const SearchAnchor({
    required this.builder,
    required this.suggestionsBuilder,
    super.key,
    this.isFullScreen,
    this.searchController,
    this.viewBuilder,
    this.viewLeading,
    this.viewTrailing,
    this.viewHintText,
    this.viewBackgroundColor,
    this.viewElevation,
    this.viewSurfaceTintColor,
    this.viewSide,
    this.viewShape,
    this.viewBarPadding,
    this.headerHeight,
    this.headerTextStyle,
    this.headerHintStyle,
    this.dividerColor,
    this.viewConstraints,
    this.viewPadding,
    this.shrinkWrap,
    this.textCapitalization,
    this.viewOnChanged,
    this.viewOnSubmitted,
    this.viewOnClose,
    this.textInputAction,
    this.keyboardType,
    this.enabled = true,
  });

  factory SearchAnchor.bar({
    required SuggestionsBuilder suggestionsBuilder,
    Widget? barLeading,
    Iterable<Widget>? barTrailing,
    String? barHintText,
    GestureTapCallback? onTap,
    ValueChanged<String>? onSubmitted,
    ValueChanged<String>? onChanged,
    VoidCallback? onClose,
    WidgetStateProperty<double?>? barElevation,
    WidgetStateProperty<Color?>? barBackgroundColor,
    WidgetStateProperty<Color?>? barOverlayColor,
    WidgetStateProperty<BorderSide?>? barSide,
    WidgetStateProperty<OutlinedBorder?>? barShape,
    WidgetStateProperty<EdgeInsetsGeometry?>? barPadding,
    EdgeInsetsGeometry? viewBarPadding,
    WidgetStateProperty<TextStyle?>? barTextStyle,
    WidgetStateProperty<TextStyle?>? barHintStyle,
    ViewBuilder? viewBuilder,
    Widget? viewLeading,
    Iterable<Widget>? viewTrailing,
    String? viewHintText,
    Color? viewBackgroundColor,
    double? viewElevation,
    BorderSide? viewSide,
    OutlinedBorder? viewShape,
    double? viewHeaderHeight,
    TextStyle? viewHeaderTextStyle,
    TextStyle? viewHeaderHintStyle,
    Color? dividerColor,
    BoxConstraints? constraints,
    BoxConstraints? viewConstraints,
    EdgeInsetsGeometry? viewPadding,
    bool? shrinkWrap,
    bool? isFullScreen,
    SearchController searchController,
    TextCapitalization textCapitalization,
    TextInputAction? textInputAction,
    TextInputType? keyboardType,
    EdgeInsets scrollPadding,
    EditableTextContextMenuBuilder contextMenuBuilder,
    bool enabled,
  }) = _SearchAnchorWithSearchBar;

  final bool? isFullScreen;

  final SearchController? searchController;

  final ViewBuilder? viewBuilder;

  final Widget? viewLeading;

  final Iterable<Widget>? viewTrailing;

  final String? viewHintText;

  final Color? viewBackgroundColor;

  final double? viewElevation;

  final Color? viewSurfaceTintColor;

  final BorderSide? viewSide;

  final OutlinedBorder? viewShape;

  final EdgeInsetsGeometry? viewBarPadding;

  final double? headerHeight;

  final TextStyle? headerTextStyle;

  final TextStyle? headerHintStyle;

  final Color? dividerColor;

  final BoxConstraints? viewConstraints;

  final EdgeInsetsGeometry? viewPadding;

  final bool? shrinkWrap;

  final TextCapitalization? textCapitalization;

  final ValueChanged<String>? viewOnChanged;

  final ValueChanged<String>? viewOnSubmitted;

  final VoidCallback? viewOnClose;

  final SearchAnchorChildBuilder builder;

  final SuggestionsBuilder suggestionsBuilder;

  final TextInputAction? textInputAction;

  final TextInputType? keyboardType;

  final bool enabled;

  @override
  State<SearchAnchor> createState() => _SearchAnchorState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool?>('isFullScreen', isFullScreen));
    properties.add(DiagnosticsProperty<SearchController?>('searchController', searchController));
    properties.add(ObjectFlagProperty<ViewBuilder?>.has('viewBuilder', viewBuilder));
    properties.add(IterableProperty<Widget>('viewTrailing', viewTrailing));
    properties.add(StringProperty('viewHintText', viewHintText));
    properties.add(ColorProperty('viewBackgroundColor', viewBackgroundColor));
    properties.add(DoubleProperty('viewElevation', viewElevation));
    properties.add(ColorProperty('viewSurfaceTintColor', viewSurfaceTintColor));
    properties.add(DiagnosticsProperty<BorderSide?>('viewSide', viewSide));
    properties.add(DiagnosticsProperty<OutlinedBorder?>('viewShape', viewShape));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('viewBarPadding', viewBarPadding));
    properties.add(DoubleProperty('headerHeight', headerHeight));
    properties.add(DiagnosticsProperty<TextStyle?>('headerTextStyle', headerTextStyle));
    properties.add(DiagnosticsProperty<TextStyle?>('headerHintStyle', headerHintStyle));
    properties.add(ColorProperty('dividerColor', dividerColor));
    properties.add(DiagnosticsProperty<BoxConstraints?>('viewConstraints', viewConstraints));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('viewPadding', viewPadding));
    properties.add(DiagnosticsProperty<bool?>('shrinkWrap', shrinkWrap));
    properties.add(EnumProperty<TextCapitalization?>('textCapitalization', textCapitalization));
    properties.add(ObjectFlagProperty<ValueChanged<String>?>.has('viewOnChanged', viewOnChanged));
    properties.add(ObjectFlagProperty<ValueChanged<String>?>.has('viewOnSubmitted', viewOnSubmitted));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('viewOnClose', viewOnClose));
    properties.add(ObjectFlagProperty<SearchAnchorChildBuilder>.has('builder', builder));
    properties.add(ObjectFlagProperty<SuggestionsBuilder>.has('suggestionsBuilder', suggestionsBuilder));
    properties.add(EnumProperty<TextInputAction?>('textInputAction', textInputAction));
    properties.add(DiagnosticsProperty<TextInputType?>('keyboardType', keyboardType));
    properties.add(DiagnosticsProperty<bool>('enabled', enabled));
  }
}

class _SearchAnchorState extends State<SearchAnchor> {
  Size? _screenSize;
  bool _anchorIsVisible = true;
  final GlobalKey _anchorKey = GlobalKey();
  bool get _viewIsOpen => !_anchorIsVisible;
  SearchController? _internalSearchController;
  SearchController get _searchController =>
      widget.searchController ?? (_internalSearchController ??= SearchController());
  _SearchViewRoute? _route;

  @override
  void initState() {
    super.initState();
    _searchController._attach(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Size updatedScreenSize = MediaQuery.of(context).size;
    if (_screenSize != null && _screenSize != updatedScreenSize) {
      if (_searchController.isOpen && !getShowFullScreenView()) {
        _closeView(null);
      }
    }
    _screenSize = updatedScreenSize;
  }

  @override
  void didUpdateWidget(SearchAnchor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchController != widget.searchController) {
      oldWidget.searchController?._detach(this);
      _searchController._attach(this);
    }
  }

  @override
  void dispose() {
    widget.searchController?._detach(this);
    _internalSearchController?._detach(this);
    final bool usingExternalController = widget.searchController != null;
    if (_route?.navigator != null) {
      _route?._dismiss(disposeController: !usingExternalController);
      if (usingExternalController) {
        _internalSearchController?.dispose();
      }
    } else {
      _internalSearchController?.dispose();
    }
    super.dispose();
  }

  void _openView() {
    final NavigatorState navigator = Navigator.of(context);
    _route = _SearchViewRoute(
      viewOnChanged: widget.viewOnChanged,
      viewOnSubmitted: widget.viewOnSubmitted,
      viewOnClose: widget.viewOnClose,
      viewLeading: widget.viewLeading,
      viewTrailing: widget.viewTrailing,
      viewHintText: widget.viewHintText,
      viewBackgroundColor: widget.viewBackgroundColor,
      viewElevation: widget.viewElevation,
      viewSurfaceTintColor: widget.viewSurfaceTintColor,
      viewSide: widget.viewSide,
      viewShape: widget.viewShape,
      viewBarPadding: widget.viewBarPadding,
      viewHeaderHeight: widget.headerHeight,
      viewHeaderTextStyle: widget.headerTextStyle,
      viewHeaderHintStyle: widget.headerHintStyle,
      dividerColor: widget.dividerColor,
      viewConstraints: widget.viewConstraints,
      viewPadding: widget.viewPadding,
      shrinkWrap: widget.shrinkWrap,
      showFullScreenView: getShowFullScreenView(),
      toggleVisibility: toggleVisibility,
      textDirection: Directionality.of(context),
      viewBuilder: widget.viewBuilder,
      anchorKey: _anchorKey,
      searchController: _searchController,
      suggestionsBuilder: widget.suggestionsBuilder,
      textCapitalization: widget.textCapitalization,
      capturedThemes: InheritedTheme.capture(from: context, to: navigator.context),
      textInputAction: widget.textInputAction,
      keyboardType: widget.keyboardType,
    );
    navigator.push(_route!);
  }

  void _closeView(String? selectedText) {
    if (selectedText != null) {
      _searchController.value = TextEditingValue(text: selectedText);
    }
    Navigator.of(context).pop();
  }

  bool toggleVisibility() {
    setState(() {
      _anchorIsVisible = !_anchorIsVisible;
    });
    return _anchorIsVisible;
  }

  bool getShowFullScreenView() =>
      widget.isFullScreen ??
      switch (Theme.of(context).platform) {
        TargetPlatform.iOS || TargetPlatform.android || TargetPlatform.fuchsia => true,
        TargetPlatform.macOS || TargetPlatform.linux || TargetPlatform.windows => false,
      };

  double _getOpacity() {
    if (widget.enabled) {
      return _anchorIsVisible ? 1.0 : 0.0;
    }
    return _kDisableSearchBarOpacity;
  }

  @override
  Widget build(BuildContext context) => AnimatedOpacity(
    key: _anchorKey,
    opacity: _getOpacity(),
    duration: _kAnchorFadeDuration,
    child: IgnorePointer(
      ignoring: !widget.enabled,
      child: GestureDetector(onTap: _openView, child: widget.builder(context, _searchController)),
    ),
  );
}

class _SearchViewRoute extends PopupRoute<_SearchViewRoute> {
  _SearchViewRoute({
    required this.showFullScreenView,
    required this.anchorKey,
    required this.searchController,
    required this.suggestionsBuilder,
    required this.capturedThemes,
    this.viewOnChanged,
    this.viewOnSubmitted,
    this.viewOnClose,
    this.toggleVisibility,
    this.textDirection,
    this.viewBuilder,
    this.viewLeading,
    this.viewTrailing,
    this.viewHintText,
    this.viewBackgroundColor,
    this.viewElevation,
    this.viewSurfaceTintColor,
    this.viewSide,
    this.viewShape,
    this.viewBarPadding,
    this.viewHeaderHeight,
    this.viewHeaderTextStyle,
    this.viewHeaderHintStyle,
    this.dividerColor,
    this.viewConstraints,
    this.viewPadding,
    this.shrinkWrap,
    this.textCapitalization,
    this.textInputAction,
    this.keyboardType,
  });

  final ValueChanged<String>? viewOnChanged;
  final ValueChanged<String>? viewOnSubmitted;
  final VoidCallback? viewOnClose;
  final ValueGetter<bool>? toggleVisibility;
  final TextDirection? textDirection;
  final ViewBuilder? viewBuilder;
  final Widget? viewLeading;
  final Iterable<Widget>? viewTrailing;
  final String? viewHintText;
  final Color? viewBackgroundColor;
  final double? viewElevation;
  final Color? viewSurfaceTintColor;
  final BorderSide? viewSide;
  final OutlinedBorder? viewShape;
  final EdgeInsetsGeometry? viewBarPadding;
  final double? viewHeaderHeight;
  final TextStyle? viewHeaderTextStyle;
  final TextStyle? viewHeaderHintStyle;
  final Color? dividerColor;
  final BoxConstraints? viewConstraints;
  final EdgeInsetsGeometry? viewPadding;
  final bool? shrinkWrap;
  final TextCapitalization? textCapitalization;
  final bool showFullScreenView;
  final GlobalKey anchorKey;
  final SearchController searchController;
  final SuggestionsBuilder suggestionsBuilder;
  final CapturedThemes capturedThemes;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  CurvedAnimation? curvedAnimation;
  CurvedAnimation? viewFadeOnIntervalCurve;
  bool willDisposeSearchController = false;

  @override
  Color? get barrierColor => Colors.transparent;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'Dismiss';

  late final SearchViewThemeData viewDefaults;
  late final SearchViewThemeData viewTheme;
  final RectTween _rectTween = RectTween();

  Rect? getRect() {
    final BuildContext? context = anchorKey.currentContext;
    if (context != null) {
      final RenderBox searchBarBox = context.findRenderObject()! as RenderBox;
      final Size boxSize = searchBarBox.size;
      final NavigatorState navigator = Navigator.of(context);
      final Offset boxLocation = searchBarBox.localToGlobal(
        Offset.zero,
        ancestor: navigator.context.findRenderObject(),
      );
      return boxLocation & boxSize;
    }
    return null;
  }

  @override
  TickerFuture didPush() {
    assert(anchorKey.currentContext != null);
    updateViewConfig(anchorKey.currentContext!);
    updateTweens(anchorKey.currentContext!);
    toggleVisibility?.call();
    return super.didPush();
  }

  @override
  bool didPop(_SearchViewRoute? result) {
    assert(anchorKey.currentContext != null);
    updateTweens(anchorKey.currentContext!);
    toggleVisibility?.call();
    viewOnClose?.call();
    return super.didPop(result);
  }

  void _dismiss({required bool disposeController}) {
    willDisposeSearchController = disposeController;
    if (isActive) {
      navigator?.removeRoute(this);
    }
  }

  @override
  void dispose() {
    curvedAnimation?.dispose();
    viewFadeOnIntervalCurve?.dispose();
    if (willDisposeSearchController) {
      searchController.dispose();
    }
    super.dispose();
  }

  void updateViewConfig(BuildContext context) {
    viewDefaults = _SearchViewDefaultsM3(context, isFullScreen: showFullScreenView);
    viewTheme = SearchViewTheme.of(context);
  }

  void updateTweens(BuildContext context) {
    final RenderBox navigator = Navigator.of(context).context.findRenderObject()! as RenderBox;
    final Size screenSize = navigator.size;
    final Rect anchorRect = getRect() ?? Rect.zero;

    final BoxConstraints effectiveConstraints = viewConstraints ?? viewTheme.constraints ?? viewDefaults.constraints!;
    _rectTween.begin = anchorRect;

    final double viewWidth = clampDouble(
      anchorRect.width,
      effectiveConstraints.minWidth,
      effectiveConstraints.maxWidth,
    );
    final double viewHeight = clampDouble(
      screenSize.height * 2 / 3,
      effectiveConstraints.minHeight,
      effectiveConstraints.maxHeight,
    );

    switch (textDirection ?? TextDirection.ltr) {
      case TextDirection.ltr:
        final double viewLeftToScreenRight = screenSize.width - anchorRect.left;
        final double viewTopToScreenBottom = screenSize.height - anchorRect.top;

        // Make sure the search view doesn't go off the screen. If the search view
        // doesn't fit, move the top-left corner of the view to fit the window.
        // If the window is smaller than the view, then we resize the view to fit the window.
        Offset topLeft = anchorRect.topLeft;
        if (viewLeftToScreenRight < viewWidth) {
          topLeft = Offset(screenSize.width - math.min(viewWidth, screenSize.width), topLeft.dy);
        }
        if (viewTopToScreenBottom < viewHeight) {
          topLeft = Offset(topLeft.dx, screenSize.height - math.min(viewHeight, screenSize.height));
        }
        final Size endSize = Size(viewWidth, viewHeight);
        _rectTween.end = showFullScreenView ? Offset.zero & screenSize : (topLeft & endSize);
        return;
      case TextDirection.rtl:
        final double viewRightToScreenLeft = anchorRect.right;
        final double viewTopToScreenBottom = screenSize.height - anchorRect.top;

        // Make sure the search view doesn't go off the screen.
        Offset topLeft = Offset(math.max(anchorRect.right - viewWidth, 0.0), anchorRect.top);
        if (viewRightToScreenLeft < viewWidth) {
          topLeft = Offset(0.0, topLeft.dy);
        }
        if (viewTopToScreenBottom < viewHeight) {
          topLeft = Offset(topLeft.dx, screenSize.height - math.min(viewHeight, screenSize.height));
        }
        final Size endSize = Size(viewWidth, viewHeight);
        _rectTween.end = showFullScreenView ? Offset.zero & screenSize : (topLeft & endSize);
    }
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) =>
      Directionality(
        textDirection: textDirection ?? TextDirection.ltr,
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            curvedAnimation ??= CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubicEmphasized,
              reverseCurve: Curves.easeInOutCubicEmphasized.flipped,
            );

            final Rect viewRect = _rectTween.evaluate(curvedAnimation!)!;
            final double topPadding =
                showFullScreenView ? lerpDouble(0.0, MediaQuery.paddingOf(context).top, curvedAnimation!.value)! : 0.0;

            viewFadeOnIntervalCurve ??= CurvedAnimation(
              parent: animation,
              curve: _kViewFadeOnInterval,
              reverseCurve: _kViewFadeOnInterval.flipped,
            );

            return FadeTransition(
              opacity: viewFadeOnIntervalCurve!,
              child: capturedThemes.wrap(
                _ViewContent(
                  viewOnChanged: viewOnChanged,
                  viewOnSubmitted: viewOnSubmitted,
                  viewLeading: viewLeading,
                  viewTrailing: viewTrailing,
                  viewHintText: viewHintText,
                  viewBackgroundColor: viewBackgroundColor,
                  viewElevation: viewElevation,
                  viewSurfaceTintColor: viewSurfaceTintColor,
                  viewSide: viewSide,
                  viewShape: viewShape,
                  viewBarPadding: viewBarPadding,
                  viewHeaderHeight: viewHeaderHeight,
                  viewHeaderTextStyle: viewHeaderTextStyle,
                  viewHeaderHintStyle: viewHeaderHintStyle,
                  dividerColor: dividerColor,
                  viewConstraints: viewConstraints,
                  viewPadding: viewPadding,
                  shrinkWrap: shrinkWrap,
                  showFullScreenView: showFullScreenView,
                  animation: curvedAnimation!,
                  topPadding: topPadding,
                  viewMaxWidth: _rectTween.end!.width,
                  viewRect: viewRect,
                  viewBuilder: viewBuilder,
                  searchController: searchController,
                  suggestionsBuilder: suggestionsBuilder,
                  textCapitalization: textCapitalization,
                  textInputAction: textInputAction,
                  keyboardType: keyboardType,
                ),
              ),
            );
          },
        ),
      );

  @override
  Duration get transitionDuration => _kOpenViewDuration;
}

class _ViewContent extends StatefulWidget {
  const _ViewContent({
    required this.showFullScreenView,
    required this.topPadding,
    required this.animation,
    required this.viewMaxWidth,
    required this.viewRect,
    required this.searchController,
    required this.suggestionsBuilder,
    this.viewOnChanged,
    this.viewOnSubmitted,
    this.viewBuilder,
    this.viewLeading,
    this.viewTrailing,
    this.viewHintText,
    this.viewBackgroundColor,
    this.viewElevation,
    this.viewSurfaceTintColor,
    this.viewSide,
    this.viewShape,
    this.viewBarPadding,
    this.viewHeaderHeight,
    this.viewHeaderTextStyle,
    this.viewHeaderHintStyle,
    this.dividerColor,
    this.viewConstraints,
    this.viewPadding,
    this.shrinkWrap,
    this.textCapitalization,
    this.textInputAction,
    this.keyboardType,
  });

  final ValueChanged<String>? viewOnChanged;
  final ValueChanged<String>? viewOnSubmitted;
  final ViewBuilder? viewBuilder;
  final Widget? viewLeading;
  final Iterable<Widget>? viewTrailing;
  final String? viewHintText;
  final Color? viewBackgroundColor;
  final double? viewElevation;
  final Color? viewSurfaceTintColor;
  final BorderSide? viewSide;
  final OutlinedBorder? viewShape;
  final EdgeInsetsGeometry? viewBarPadding;
  final double? viewHeaderHeight;
  final TextStyle? viewHeaderTextStyle;
  final TextStyle? viewHeaderHintStyle;
  final Color? dividerColor;
  final BoxConstraints? viewConstraints;
  final EdgeInsetsGeometry? viewPadding;
  final bool? shrinkWrap;
  final TextCapitalization? textCapitalization;
  final bool showFullScreenView;
  final double topPadding;
  final Animation<double> animation;
  final double viewMaxWidth;
  final Rect viewRect;
  final SearchController searchController;
  final SuggestionsBuilder suggestionsBuilder;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;

  @override
  State<_ViewContent> createState() => _ViewContentState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<ValueChanged<String>?>.has('viewOnChanged', viewOnChanged));
    properties.add(ObjectFlagProperty<ValueChanged<String>?>.has('viewOnSubmitted', viewOnSubmitted));
    properties.add(ObjectFlagProperty<ViewBuilder?>.has('viewBuilder', viewBuilder));
    properties.add(IterableProperty<Widget>('viewTrailing', viewTrailing));
    properties.add(StringProperty('viewHintText', viewHintText));
    properties.add(ColorProperty('viewBackgroundColor', viewBackgroundColor));
    properties.add(DoubleProperty('viewElevation', viewElevation));
    properties.add(ColorProperty('viewSurfaceTintColor', viewSurfaceTintColor));
    properties.add(DiagnosticsProperty<BorderSide?>('viewSide', viewSide));
    properties.add(DiagnosticsProperty<OutlinedBorder?>('viewShape', viewShape));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('viewBarPadding', viewBarPadding));
    properties.add(DoubleProperty('viewHeaderHeight', viewHeaderHeight));
    properties.add(DiagnosticsProperty<TextStyle?>('viewHeaderTextStyle', viewHeaderTextStyle));
    properties.add(DiagnosticsProperty<TextStyle?>('viewHeaderHintStyle', viewHeaderHintStyle));
    properties.add(ColorProperty('dividerColor', dividerColor));
    properties.add(DiagnosticsProperty<BoxConstraints?>('viewConstraints', viewConstraints));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('viewPadding', viewPadding));
    properties.add(DiagnosticsProperty<bool?>('shrinkWrap', shrinkWrap));
    properties.add(EnumProperty<TextCapitalization?>('textCapitalization', textCapitalization));
    properties.add(DiagnosticsProperty<bool>('showFullScreenView', showFullScreenView));
    properties.add(DoubleProperty('topPadding', topPadding));
    properties.add(DiagnosticsProperty<Animation<double>>('animation', animation));
    properties.add(DoubleProperty('viewMaxWidth', viewMaxWidth));
    properties.add(DiagnosticsProperty<Rect>('viewRect', viewRect));
    properties.add(DiagnosticsProperty<SearchController>('searchController', searchController));
    properties.add(ObjectFlagProperty<SuggestionsBuilder>.has('suggestionsBuilder', suggestionsBuilder));
    properties.add(EnumProperty<TextInputAction?>('textInputAction', textInputAction));
    properties.add(DiagnosticsProperty<TextInputType?>('keyboardType', keyboardType));
  }
}

class _ViewContentState extends State<_ViewContent> {
  Size? _screenSize;
  late Rect _viewRect;
  late CurvedAnimation viewIconsFadeCurve;
  late CurvedAnimation viewDividerFadeCurve;
  late CurvedAnimation viewListFadeOnIntervalCurve;
  late final SearchController _controller;
  Iterable<Widget> result = <Widget>[];
  String? searchValue;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _viewRect = widget.viewRect;
    _controller = widget.searchController;
    _controller.addListener(updateSuggestions);
    _setupAnimations();
  }

  @override
  void didUpdateWidget(covariant _ViewContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.viewRect != oldWidget.viewRect) {
      setState(() {
        _viewRect = widget.viewRect;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Size updatedScreenSize = MediaQuery.of(context).size;

    if (_screenSize != updatedScreenSize) {
      _screenSize = updatedScreenSize;
      if (widget.showFullScreenView) {
        _viewRect = Offset.zero & _screenSize!;
      }
    }

    if (searchValue != _controller.text) {
      _timer?.cancel();
      _timer = Timer(Duration.zero, () async {
        searchValue = _controller.text;
        final Iterable<Widget> suggestions = await widget.suggestionsBuilder(context, _controller);
        _timer?.cancel();
        _timer = null;
        if (mounted) {
          setState(() {
            result = suggestions;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(updateSuggestions);
    _disposeAnimations();
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  void _setupAnimations() {
    viewIconsFadeCurve = CurvedAnimation(
      parent: widget.animation,
      curve: _kViewIconsFadeOnInterval,
      reverseCurve: _kViewIconsFadeOnInterval.flipped,
    );
    viewDividerFadeCurve = CurvedAnimation(
      parent: widget.animation,
      curve: _kViewDividerFadeOnInterval,
      reverseCurve: _kViewFadeOnInterval.flipped,
    );
    viewListFadeOnIntervalCurve = CurvedAnimation(
      parent: widget.animation,
      curve: _kViewListFadeOnInterval,
      reverseCurve: _kViewListFadeOnInterval.flipped,
    );
  }

  void _disposeAnimations() {
    viewIconsFadeCurve.dispose();
    viewDividerFadeCurve.dispose();
    viewListFadeOnIntervalCurve.dispose();
  }

  Future<void> updateSuggestions() async {
    if (searchValue != _controller.text) {
      searchValue = _controller.text;
      final Iterable<Widget> suggestions = await widget.suggestionsBuilder(context, _controller);
      if (mounted) {
        setState(() {
          result = suggestions;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget defaultLeading = BackButton(
      style: const ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    final List<Widget> defaultTrailing = <Widget>[
      if (_controller.text.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.close),
          tooltip: MaterialLocalizations.of(context).clearButtonTooltip,
          onPressed: () {
            _controller.clear();
          },
        ),
    ];

    final SearchViewThemeData viewDefaults = _SearchViewDefaultsM3(context, isFullScreen: widget.showFullScreenView);
    final SearchViewThemeData viewTheme = SearchViewTheme.of(context);
    final DividerThemeData dividerTheme = DividerTheme.of(context);

    final Color effectiveBackgroundColor =
        widget.viewBackgroundColor ?? viewTheme.backgroundColor ?? viewDefaults.backgroundColor!;
    final Color effectiveSurfaceTint =
        widget.viewSurfaceTintColor ?? viewTheme.surfaceTintColor ?? viewDefaults.surfaceTintColor!;
    final double effectiveElevation = widget.viewElevation ?? viewTheme.elevation ?? viewDefaults.elevation!;
    final BorderSide? effectiveSide = widget.viewSide ?? viewTheme.side ?? viewDefaults.side;
    OutlinedBorder effectiveShape = widget.viewShape ?? viewTheme.shape ?? viewDefaults.shape!;
    if (effectiveSide != null) {
      effectiveShape = effectiveShape.copyWith(side: effectiveSide);
    }
    final Color effectiveDividerColor =
        widget.dividerColor ?? viewTheme.dividerColor ?? dividerTheme.color ?? viewDefaults.dividerColor!;
    final double? effectiveHeaderHeight = widget.viewHeaderHeight ?? viewTheme.headerHeight;
    final BoxConstraints? headerConstraints =
        effectiveHeaderHeight == null ? null : BoxConstraints.tightFor(height: effectiveHeaderHeight);
    final TextStyle? effectiveTextStyle =
        widget.viewHeaderTextStyle ?? viewTheme.headerTextStyle ?? viewDefaults.headerTextStyle;
    final TextStyle? effectiveHintStyle =
        widget.viewHeaderHintStyle ??
        viewTheme.headerHintStyle ??
        widget.viewHeaderTextStyle ??
        viewTheme.headerTextStyle ??
        viewDefaults.headerHintStyle;
    final EdgeInsetsGeometry? effectivePadding = widget.viewPadding ?? viewTheme.padding ?? viewDefaults.padding;
    final EdgeInsetsGeometry? effectiveBarPadding =
        widget.viewBarPadding ?? viewTheme.barPadding ?? viewDefaults.barPadding;

    final BoxConstraints effectiveConstraints =
        widget.viewConstraints ?? viewTheme.constraints ?? viewDefaults.constraints!;
    final double minWidth = math.min(effectiveConstraints.minWidth, _viewRect.width);
    final double minHeight = math.min(effectiveConstraints.minHeight, _viewRect.height);

    final bool effectiveShrinkWrap = widget.shrinkWrap ?? viewTheme.shrinkWrap ?? viewDefaults.shrinkWrap!;

    final Widget viewDivider = DividerTheme(
      data: dividerTheme.copyWith(color: effectiveDividerColor),
      child: const Divider(height: 1),
    );

    return Align(
      alignment: Alignment.topLeft,
      child: Transform.translate(
        offset: _viewRect.topLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: minWidth,
            maxWidth: _viewRect.width,
            minHeight: minHeight,
            maxHeight: _viewRect.height,
          ),
          child: Padding(
            padding: widget.showFullScreenView ? EdgeInsets.zero : (effectivePadding ?? EdgeInsets.zero),
            child: Material(
              clipBehavior: Clip.antiAlias,
              shape: effectiveShape,
              color: effectiveBackgroundColor,
              surfaceTintColor: effectiveSurfaceTint,
              elevation: effectiveElevation,
              child: OverflowBox(
                alignment: Alignment.topLeft,
                maxWidth: math.min(widget.viewMaxWidth, _screenSize!.width),
                minWidth: 0,
                fit: OverflowBoxFit.deferToChild,
                child: FadeTransition(
                  opacity: viewIconsFadeCurve,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: widget.topPadding),
                        child: SafeArea(
                          top: false,
                          bottom: false,
                          child: SearchBar(
                            autoFocus: true,
                            constraints:
                                headerConstraints ??
                                (widget.showFullScreenView
                                    ? BoxConstraints(minHeight: _SearchViewDefaultsM3.fullScreenBarHeight)
                                    : null),
                            padding: WidgetStatePropertyAll<EdgeInsetsGeometry?>(effectiveBarPadding),
                            leading: widget.viewLeading ?? defaultLeading,
                            trailing: widget.viewTrailing ?? defaultTrailing,
                            hintText: widget.viewHintText,
                            backgroundColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
                            overlayColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
                            elevation: const WidgetStatePropertyAll<double>(0.0),
                            textStyle: WidgetStatePropertyAll<TextStyle?>(effectiveTextStyle),
                            hintStyle: WidgetStatePropertyAll<TextStyle?>(effectiveHintStyle),
                            controller: _controller,
                            onChanged: (value) {
                              widget.viewOnChanged?.call(value);
                              updateSuggestions();
                            },
                            onSubmitted: widget.viewOnSubmitted,
                            textCapitalization: widget.textCapitalization,
                            textInputAction: widget.textInputAction,
                            keyboardType: widget.keyboardType,
                          ),
                        ),
                      ),
                      if (!effectiveShrinkWrap ||
                          minHeight > 0 ||
                          widget.showFullScreenView ||
                          result.isNotEmpty) ...<Widget>[
                        FadeTransition(opacity: viewDividerFadeCurve, child: viewDivider),
                        Flexible(
                          fit: (effectiveShrinkWrap && !widget.showFullScreenView) ? FlexFit.loose : FlexFit.tight,
                          child: FadeTransition(
                            opacity: viewListFadeOnIntervalCurve,
                            child:
                                widget.viewBuilder == null
                                    ? MediaQuery.removePadding(
                                      context: context,
                                      removeTop: true,
                                      child: ListView(shrinkWrap: effectiveShrinkWrap, children: result.toList()),
                                    )
                                    : widget.viewBuilder!(result),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<CurvedAnimation>('viewIconsFadeCurve', viewIconsFadeCurve));
    properties.add(DiagnosticsProperty<CurvedAnimation>('viewDividerFadeCurve', viewDividerFadeCurve));
    properties.add(DiagnosticsProperty<CurvedAnimation>('viewListFadeOnIntervalCurve', viewListFadeOnIntervalCurve));
    properties.add(IterableProperty<Widget>('result', result));
    properties.add(StringProperty('searchValue', searchValue));
  }
}

class _SearchAnchorWithSearchBar extends SearchAnchor {
  _SearchAnchorWithSearchBar({
    required super.suggestionsBuilder,
    Widget? barLeading,
    Iterable<Widget>? barTrailing,
    String? barHintText,
    GestureTapCallback? onTap,
    WidgetStateProperty<double?>? barElevation,
    WidgetStateProperty<Color?>? barBackgroundColor,
    WidgetStateProperty<Color?>? barOverlayColor,
    WidgetStateProperty<BorderSide?>? barSide,
    WidgetStateProperty<OutlinedBorder?>? barShape,
    WidgetStateProperty<EdgeInsetsGeometry?>? barPadding,
    super.viewBarPadding,
    WidgetStateProperty<TextStyle?>? barTextStyle,
    WidgetStateProperty<TextStyle?>? barHintStyle,
    super.viewBuilder,
    super.viewLeading,
    super.viewTrailing,
    String? viewHintText,
    super.viewBackgroundColor,
    super.viewElevation,
    super.viewSide,
    super.viewShape,
    double? viewHeaderHeight,
    TextStyle? viewHeaderTextStyle,
    TextStyle? viewHeaderHintStyle,
    super.dividerColor,
    BoxConstraints? constraints,
    super.viewConstraints,
    super.viewPadding,
    super.shrinkWrap,
    super.isFullScreen,
    super.searchController,
    super.textCapitalization,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    VoidCallback? onClose,
    super.textInputAction,
    super.keyboardType,
    EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
    EditableTextContextMenuBuilder contextMenuBuilder = SearchBar._defaultContextMenuBuilder,
    super.enabled,
  }) : super(
         viewHintText: viewHintText ?? barHintText,
         headerHeight: viewHeaderHeight,
         headerTextStyle: viewHeaderTextStyle,
         headerHintStyle: viewHeaderHintStyle,
         viewOnSubmitted: onSubmitted,
         viewOnChanged: onChanged,
         viewOnClose: onClose,
         builder:
             (context, controller) => SearchBar(
               constraints: constraints,
               controller: controller,
               onTap: () {
                 controller.openView();
                 onTap?.call();
               },
               onChanged: (value) {
                 controller.openView();
               },
               onSubmitted: onSubmitted,
               hintText: barHintText,
               hintStyle: barHintStyle,
               textStyle: barTextStyle,
               elevation: barElevation,
               backgroundColor: barBackgroundColor,
               overlayColor: barOverlayColor,
               side: barSide,
               shape: barShape,
               padding: barPadding ?? const WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 16.0)),
               leading: barLeading ?? const Icon(Icons.search),
               trailing: barTrailing,
               textCapitalization: textCapitalization,
               textInputAction: textInputAction,
               keyboardType: keyboardType,
               scrollPadding: scrollPadding,
               contextMenuBuilder: contextMenuBuilder,
             ),
       );
}

class SearchController extends TextEditingController {
  // The anchor that this controller controls.
  //
  // This is set automatically when a [SearchController] is given to the anchor
  // it controls.
  _SearchAnchorState? _anchor;

  bool get isAttached => _anchor != null;

  bool get isOpen {
    assert(isAttached);
    return _anchor!._viewIsOpen;
  }

  void openView() {
    assert(isAttached);
    _anchor!._openView();
  }

  void closeView(String? selectedText) {
    assert(isAttached);
    _anchor!._closeView(selectedText);
  }

  // ignore: use_setters_to_change_properties
  void _attach(_SearchAnchorState anchor) {
    _anchor = anchor;
  }

  void _detach(_SearchAnchorState anchor) {
    if (_anchor == anchor) {
      _anchor = null;
    }
  }
}

class SearchBar extends StatefulWidget {
  const SearchBar({
    super.key,
    this.controller,
    this.focusNode,
    this.hintText,
    this.leading,
    this.trailing,
    this.onTap,
    this.onTapOutside,
    this.onChanged,
    this.onSubmitted,
    this.constraints,
    this.elevation,
    this.backgroundColor,
    this.shadowColor,
    this.surfaceTintColor,
    this.overlayColor,
    this.side,
    this.shape,
    this.padding,
    this.textStyle,
    this.hintStyle,
    this.textCapitalization,
    this.enabled = true,
    this.autoFocus = false,
    this.textInputAction,
    this.keyboardType,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.contextMenuBuilder = _defaultContextMenuBuilder,
  });

  final TextEditingController? controller;

  final FocusNode? focusNode;

  final String? hintText;

  final Widget? leading;

  final Iterable<Widget>? trailing;

  final GestureTapCallback? onTap;

  final TapRegionCallback? onTapOutside;

  final ValueChanged<String>? onChanged;

  final ValueChanged<String>? onSubmitted;

  final BoxConstraints? constraints;

  final WidgetStateProperty<double?>? elevation;

  final WidgetStateProperty<Color?>? backgroundColor;

  final WidgetStateProperty<Color?>? shadowColor;

  final WidgetStateProperty<Color?>? surfaceTintColor;

  final WidgetStateProperty<Color?>? overlayColor;

  final WidgetStateProperty<BorderSide?>? side;

  final WidgetStateProperty<OutlinedBorder?>? shape;

  final WidgetStateProperty<EdgeInsetsGeometry?>? padding;

  final WidgetStateProperty<TextStyle?>? textStyle;

  final WidgetStateProperty<TextStyle?>? hintStyle;

  final TextCapitalization? textCapitalization;

  final bool enabled;

  final bool autoFocus;

  final TextInputAction? textInputAction;

  final TextInputType? keyboardType;

  final EdgeInsets scrollPadding;

  final EditableTextContextMenuBuilder? contextMenuBuilder;

  static Widget _defaultContextMenuBuilder(BuildContext context, EditableTextState editableTextState) =>
      AdaptiveTextSelectionToolbar.editableText(editableTextState: editableTextState);

  @override
  State<SearchBar> createState() => _SearchBarState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextEditingController?>('controller', controller));
    properties.add(DiagnosticsProperty<FocusNode?>('focusNode', focusNode));
    properties.add(StringProperty('hintText', hintText));
    properties.add(IterableProperty<Widget>('trailing', trailing));
    properties.add(ObjectFlagProperty<GestureTapCallback?>.has('onTap', onTap));
    properties.add(ObjectFlagProperty<TapRegionCallback?>.has('onTapOutside', onTapOutside));
    properties.add(ObjectFlagProperty<ValueChanged<String>?>.has('onChanged', onChanged));
    properties.add(ObjectFlagProperty<ValueChanged<String>?>.has('onSubmitted', onSubmitted));
    properties.add(DiagnosticsProperty<BoxConstraints?>('constraints', constraints));
    properties.add(DiagnosticsProperty<WidgetStateProperty<double?>?>('elevation', elevation));
    properties.add(DiagnosticsProperty<WidgetStateProperty<Color?>?>('backgroundColor', backgroundColor));
    properties.add(DiagnosticsProperty<WidgetStateProperty<Color?>?>('shadowColor', shadowColor));
    properties.add(DiagnosticsProperty<WidgetStateProperty<Color?>?>('surfaceTintColor', surfaceTintColor));
    properties.add(DiagnosticsProperty<WidgetStateProperty<Color?>?>('overlayColor', overlayColor));
    properties.add(DiagnosticsProperty<WidgetStateProperty<BorderSide?>?>('side', side));
    properties.add(DiagnosticsProperty<WidgetStateProperty<OutlinedBorder?>?>('shape', shape));
    properties.add(DiagnosticsProperty<WidgetStateProperty<EdgeInsetsGeometry?>?>('padding', padding));
    properties.add(DiagnosticsProperty<WidgetStateProperty<TextStyle?>?>('textStyle', textStyle));
    properties.add(DiagnosticsProperty<WidgetStateProperty<TextStyle?>?>('hintStyle', hintStyle));
    properties.add(EnumProperty<TextCapitalization?>('textCapitalization', textCapitalization));
    properties.add(DiagnosticsProperty<bool>('enabled', enabled));
    properties.add(DiagnosticsProperty<bool>('autoFocus', autoFocus));
    properties.add(EnumProperty<TextInputAction?>('textInputAction', textInputAction));
    properties.add(DiagnosticsProperty<TextInputType?>('keyboardType', keyboardType));
    properties.add(DiagnosticsProperty<EdgeInsets>('scrollPadding', scrollPadding));
    properties.add(ObjectFlagProperty<EditableTextContextMenuBuilder?>.has('contextMenuBuilder', contextMenuBuilder));
  }
}

class _SearchBarState extends State<SearchBar> {
  late final WidgetStatesController _internalStatesController;
  FocusNode? _internalFocusNode;
  FocusNode get _focusNode => widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _internalStatesController = WidgetStatesController();
    _internalStatesController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _internalStatesController.dispose();
    _internalFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final SearchBarThemeData searchBarTheme = SearchBarTheme.of(context);
    final SearchBarThemeData defaults = _SearchBarDefaultsM3(context);

    T? resolve<T>(
      WidgetStateProperty<T>? widgetValue,
      WidgetStateProperty<T>? themeValue,
      WidgetStateProperty<T>? defaultValue,
    ) {
      final Set<WidgetState> states = _internalStatesController.value;
      return widgetValue?.resolve(states) ?? themeValue?.resolve(states) ?? defaultValue?.resolve(states);
    }

    final TextStyle? effectiveTextStyle = resolve<TextStyle?>(
      widget.textStyle,
      searchBarTheme.textStyle,
      defaults.textStyle,
    );
    final double? effectiveElevation = resolve<double?>(widget.elevation, searchBarTheme.elevation, defaults.elevation);
    final Color? effectiveShadowColor = resolve<Color?>(
      widget.shadowColor,
      searchBarTheme.shadowColor,
      defaults.shadowColor,
    );
    final Color? effectiveBackgroundColor = resolve<Color?>(
      widget.backgroundColor,
      searchBarTheme.backgroundColor,
      defaults.backgroundColor,
    );
    final Color? effectiveSurfaceTintColor = resolve<Color?>(
      widget.surfaceTintColor,
      searchBarTheme.surfaceTintColor,
      defaults.surfaceTintColor,
    );
    final OutlinedBorder? effectiveShape = resolve<OutlinedBorder?>(widget.shape, searchBarTheme.shape, defaults.shape);
    final BorderSide? effectiveSide = resolve<BorderSide?>(widget.side, searchBarTheme.side, defaults.side);
    final EdgeInsetsGeometry? effectivePadding = resolve<EdgeInsetsGeometry?>(
      widget.padding,
      searchBarTheme.padding,
      defaults.padding,
    );
    final WidgetStateProperty<Color?>? effectiveOverlayColor =
        widget.overlayColor ?? searchBarTheme.overlayColor ?? defaults.overlayColor;
    final TextCapitalization effectiveTextCapitalization =
        widget.textCapitalization ?? searchBarTheme.textCapitalization ?? defaults.textCapitalization!;

    final Set<WidgetState> states = _internalStatesController.value;
    final TextStyle? effectiveHintStyle =
        widget.hintStyle?.resolve(states) ??
        searchBarTheme.hintStyle?.resolve(states) ??
        widget.textStyle?.resolve(states) ??
        searchBarTheme.textStyle?.resolve(states) ??
        defaults.hintStyle?.resolve(states);

    final Color defaultColor = switch (colorScheme.brightness) {
      Brightness.light => kDefaultIconDarkColor,
      Brightness.dark => kDefaultIconLightColor,
    };
    final IconThemeData? customTheme = switch (IconTheme.of(context)) {
      final IconThemeData iconTheme when iconTheme.color != defaultColor => iconTheme,
      _ => null,
    };

    Widget? leading;
    if (widget.leading != null) {
      leading = IconTheme.merge(
        data: customTheme ?? IconThemeData(color: colorScheme.onSurface),
        child: widget.leading!,
      );
    }

    final List<Widget>? trailing =
        widget.trailing
            ?.map(
              (trailing) => IconTheme.merge(
                data: customTheme ?? IconThemeData(color: colorScheme.onSurfaceVariant),
                child: trailing,
              ),
            )
            .toList();

    return ConstrainedBox(
      constraints: widget.constraints ?? searchBarTheme.constraints ?? defaults.constraints!,
      child: Opacity(
        opacity: widget.enabled ? 1 : _kDisableSearchBarOpacity,
        child: Material(
          elevation: effectiveElevation!,
          shadowColor: effectiveShadowColor,
          color: effectiveBackgroundColor,
          surfaceTintColor: effectiveSurfaceTintColor,
          shape: effectiveShape?.copyWith(side: effectiveSide),
          child: IgnorePointer(
            ignoring: !widget.enabled,
            child: InkWell(
              onTap: () {
                widget.onTap?.call();
                if (!_focusNode.hasFocus) {
                  _focusNode.requestFocus();
                }
              },
              overlayColor: effectiveOverlayColor,
              customBorder: effectiveShape?.copyWith(side: effectiveSide),
              statesController: _internalStatesController,
              child: Padding(
                padding: effectivePadding!,
                child: Row(
                  textDirection: textDirection,
                  children: <Widget>[
                    if (leading != null) leading,
                    Expanded(
                      child: Padding(
                        padding: effectivePadding,
                        child: TextField(
                          autofocus: widget.autoFocus,
                          onTap: widget.onTap,
                          onTapAlwaysCalled: true,
                          onTapOutside: widget.onTapOutside,
                          focusNode: _focusNode,
                          onChanged: widget.onChanged,
                          onSubmitted: widget.onSubmitted,
                          controller: widget.controller,
                          style: effectiveTextStyle,
                          enabled: widget.enabled,
                          decoration: InputDecoration(hintText: widget.hintText).applyDefaults(
                            InputDecorationTheme(
                              hintStyle: effectiveHintStyle,
                              // The configuration below is to make sure that the text field
                              // in `SearchBar` will not be overridden by the overall `InputDecorationTheme`
                              enabledBorder: InputBorder.none,
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              // Setting `isDense` to true to allow the text field height to be
                              // smaller than 48.0
                              isDense: true,
                            ),
                          ),
                          textCapitalization: effectiveTextCapitalization,
                          textInputAction: widget.textInputAction,
                          keyboardType: widget.keyboardType,
                          scrollPadding: widget.scrollPadding,
                          contextMenuBuilder: widget.contextMenuBuilder,
                        ),
                      ),
                    ),
                    ...?trailing,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// BEGIN GENERATED TOKEN PROPERTIES - SearchBar

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// dart format off
class _SearchBarDefaultsM3 extends SearchBarThemeData {
  _SearchBarDefaultsM3(this.context);

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;
  late final TextTheme _textTheme = Theme.of(context).textTheme;

  @override
  WidgetStateProperty<Color?>? get backgroundColor =>
    WidgetStatePropertyAll<Color>(_colors.surfaceContainerHigh);

  @override
  WidgetStateProperty<double>? get elevation =>
    const WidgetStatePropertyAll<double>(6.0);

  @override
  WidgetStateProperty<Color>? get shadowColor =>
    WidgetStatePropertyAll<Color>(_colors.shadow);

  @override
  WidgetStateProperty<Color>? get surfaceTintColor =>
    const WidgetStatePropertyAll<Color>(Colors.transparent);

  @override
  WidgetStateProperty<Color?>? get overlayColor =>
    WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.pressed)) {
        return _colors.onSurface.withOpacity(0.1);
      }
      if (states.contains(WidgetState.hovered)) {
        return _colors.onSurface.withOpacity(0.08);
      }
      if (states.contains(WidgetState.focused)) {
        return Colors.transparent;
      }
      return Colors.transparent;
    });

  // No default side

  @override
  WidgetStateProperty<OutlinedBorder>? get shape =>
    const WidgetStatePropertyAll<OutlinedBorder>(StadiumBorder());

  @override
  WidgetStateProperty<EdgeInsetsGeometry>? get padding =>
    const WidgetStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.symmetric(horizontal: 8.0));

  @override
  WidgetStateProperty<TextStyle?> get textStyle =>
    WidgetStatePropertyAll<TextStyle?>(_textTheme.bodyLarge?.copyWith(color: _colors.onSurface));

  @override
  WidgetStateProperty<TextStyle?> get hintStyle =>
    WidgetStatePropertyAll<TextStyle?>(_textTheme.bodyLarge?.copyWith(color: _colors.onSurfaceVariant));

  @override
  BoxConstraints get constraints =>
    const BoxConstraints(minWidth: 360.0, maxWidth: 800.0, minHeight: 56.0);

  @override
  TextCapitalization get textCapitalization => TextCapitalization.none;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BuildContext>('context', context));
  }
}
// dart format on

// END GENERATED TOKEN PROPERTIES - SearchBar

// BEGIN GENERATED TOKEN PROPERTIES - SearchView

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// dart format off
class _SearchViewDefaultsM3 extends SearchViewThemeData {
  _SearchViewDefaultsM3(this.context, {required this.isFullScreen});

  final BuildContext context;
  final bool isFullScreen;
  late final ColorScheme _colors = Theme.of(context).colorScheme;
  late final TextTheme _textTheme = Theme.of(context).textTheme;

  static double fullScreenBarHeight = 72.0;

  @override
  Color? get backgroundColor => _colors.surfaceContainerHigh;

  @override
  double? get elevation => 6.0;

  @override
  Color? get surfaceTintColor => Colors.transparent;

  // No default side

  @override
  OutlinedBorder? get shape => isFullScreen
    ? const RoundedRectangleBorder()
    : const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(28.0)));

  @override
  TextStyle? get headerTextStyle => _textTheme.bodyLarge?.copyWith(color: _colors.onSurface);

  @override
  TextStyle? get headerHintStyle => _textTheme.bodyLarge?.copyWith(color: _colors.onSurfaceVariant);

  @override
  BoxConstraints get constraints => const BoxConstraints(minWidth: 360.0, minHeight: 240.0);

  @override
  EdgeInsetsGeometry? get barPadding => const EdgeInsets.symmetric(horizontal: 8.0);

  @override
  bool get shrinkWrap => false;

  @override
  Color? get dividerColor => _colors.outline;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BuildContext>('context', context));
    properties.add(DiagnosticsProperty<bool>('isFullScreen', isFullScreen));
  }
}
// dart format on

// END GENERATED TOKEN PROPERTIES - SearchView
