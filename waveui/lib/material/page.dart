// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';

import 'package:waveui/material/page_transitions_theme.dart';
import 'package:waveui/material/theme.dart';

class MaterialPageRoute<T> extends PageRoute<T> with MaterialRouteTransitionMixin<T> {
  MaterialPageRoute({
    required this.builder,
    super.settings,
    super.requestFocus,
    this.maintainState = true,
    super.fullscreenDialog,
    super.allowSnapshotting = true,
    super.barrierDismissible = false,
    super.traversalEdgeBehavior,
    super.directionalTraversalEdgeBehavior,
  }) {
    assert(opaque);
  }

  final WidgetBuilder builder;

  @override
  Widget buildContent(BuildContext context) => builder(context);

  @override
  final bool maintainState;

  @override
  String get debugLabel => '${super.debugLabel}(${settings.name})';
}

mixin MaterialRouteTransitionMixin<T> on PageRoute<T> {
  @protected
  Widget buildContent(BuildContext context);

  @override
  Duration get transitionDuration =>
      _getPageTransitionBuilder(navigator!.context)?.transitionDuration ?? const Duration(microseconds: 300);

  @override
  Duration get reverseTransitionDuration =>
      _getPageTransitionBuilder(navigator!.context)?.reverseTransitionDuration ?? const Duration(microseconds: 300);

  PageTransitionsBuilder? _getPageTransitionBuilder(BuildContext context) {
    final TargetPlatform platform = Theme.of(context).platform;
    final PageTransitionsTheme pageTransitionsTheme = Theme.of(context).pageTransitionsTheme;
    return pageTransitionsTheme.builders[platform];
  }

  // The transitionDuration is used to create the AnimationController which is only
  // built once, so when page transition builder is updated and transitionDuration
  // has a new value, the AnimationController cannot be updated automatically. So we
  // manually update its duration here.
  // TODO(quncCccccc): Clean up this override method when controller can be updated as the transitionDuration is changed.
  @override
  TickerFuture didPush() {
    controller?.duration = transitionDuration;
    return super.didPush();
  }

  // The reverseTransitionDuration is used to create the AnimationController
  // which is only built once, so when page transition builder is updated and
  // reverseTransitionDuration has a new value, the AnimationController cannot
  // be updated automatically. So we manually update its reverseDuration here.
  // TODO(quncCccccc): Clean up this override method when controller can beupdated as the reverseTransitionDuration is changed.
  @override
  bool didPop(T? result) {
    controller?.reverseDuration = reverseTransitionDuration;
    return super.didPop(result);
  }

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  DelegatedTransitionBuilder? get delegatedTransition => _delegatedTransition;

  static Widget? _delegatedTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    bool allowSnapshotting,
    Widget? child,
  ) {
    final PageTransitionsTheme theme = Theme.of(context).pageTransitionsTheme;
    final TargetPlatform platform = Theme.of(context).platform;
    final DelegatedTransitionBuilder? themeDelegatedTransition = theme.delegatedTransition(platform);
    return themeDelegatedTransition != null
        ? themeDelegatedTransition(context, animation, secondaryAnimation, allowSnapshotting, child)
        : null;
  }

  @override
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) {
    // Don't perform outgoing animation if the next route is a fullscreen dialog,
    // or there is no matching transition to use.
    // Don't perform outgoing animation if the next route is a fullscreen dialog.
    final bool nextRouteIsNotFullscreen = (nextRoute is! PageRoute<T>) || !nextRoute.fullscreenDialog;

    // If the next route has a delegated transition, then this route is able to
    // use that delegated transition to smoothly sync with the next route's
    // transition.
    final bool nextRouteHasDelegatedTransition = nextRoute is ModalRoute<T> && nextRoute.delegatedTransition != null;

    // Otherwise if the next route has the same route transition mixin as this
    // one, then this route will already be synced with its transition.
    return nextRouteIsNotFullscreen && ((nextRoute is MaterialRouteTransitionMixin) || nextRouteHasDelegatedTransition);
  }

  @override
  bool canTransitionFrom(TransitionRoute<dynamic> previousRoute) {
    // Supress previous route from transitioning if this is a fullscreenDialog route.
    return previousRoute is PageRoute && !fullscreenDialog;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    final Widget result = buildContent(context);
    return Semantics(scopesRoute: true, explicitChildNodes: true, child: result);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final PageTransitionsTheme theme = Theme.of(context).pageTransitionsTheme;
    return theme.buildTransitions<T>(this, context, animation, secondaryAnimation, child);
  }
}

class MaterialPage<T> extends Page<T> {
  const MaterialPage({
    required this.child,
    this.maintainState = true,
    this.fullscreenDialog = false,
    this.allowSnapshotting = true,
    super.key,
    super.canPop,
    super.onPopInvoked,
    super.name,
    super.arguments,
    super.restorationId,
  });

  final Widget child;

  final bool maintainState;

  final bool fullscreenDialog;

  final bool allowSnapshotting;

  @override
  Route<T> createRoute(BuildContext context) =>
      _PageBasedMaterialPageRoute<T>(page: this, allowSnapshotting: allowSnapshotting);
}

// A page-based version of MaterialPageRoute.
//
// This route uses the builder from the page to build its content. This ensures
// the content is up to date after page updates.
class _PageBasedMaterialPageRoute<T> extends PageRoute<T> with MaterialRouteTransitionMixin<T> {
  _PageBasedMaterialPageRoute({required MaterialPage<T> page, super.allowSnapshotting}) : super(settings: page) {
    assert(opaque);
  }

  MaterialPage<T> get _page => settings as MaterialPage<T>;

  @override
  Widget buildContent(BuildContext context) => _page.child;

  @override
  bool get maintainState => _page.maintainState;

  @override
  bool get fullscreenDialog => _page.fullscreenDialog;

  @override
  String get debugLabel => '${super.debugLabel}(${_page.name})';
}
