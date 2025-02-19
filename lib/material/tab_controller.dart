// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/constants.dart';

// Examples can assume:
// late BuildContext context;

class TabController extends ChangeNotifier {
  TabController({
    required this.length,
    required TickerProvider vsync,
    int initialIndex = 0,
    Duration? animationDuration,
  }) : assert(length >= 0),
       assert(initialIndex >= 0 && (length == 0 || initialIndex < length)),
       _index = initialIndex,
       _previousIndex = initialIndex,
       _animationDuration = animationDuration ?? kTabScrollDuration,
       _animationController = AnimationController.unbounded(value: initialIndex.toDouble(), vsync: vsync) {
    if (kFlutterMemoryAllocationsEnabled) {
      ChangeNotifier.maybeDispatchObjectCreation(this);
    }
  }

  // Private constructor used by `_copyWith`. This allows a new TabController to
  // be created without having to create a new animationController.
  TabController._({
    required int index,
    required int previousIndex,
    required AnimationController? animationController,
    required Duration animationDuration,
    required this.length,
  }) : _index = index,
       _previousIndex = previousIndex,
       _animationController = animationController,
       _animationDuration = animationDuration {
    if (kFlutterMemoryAllocationsEnabled) {
      ChangeNotifier.maybeDispatchObjectCreation(this);
    }
  }

  TabController _copyWithAndDispose({
    required int? index,
    required int? length,
    required int? previousIndex,
    required Duration? animationDuration,
  }) {
    if (index != null) {
      _animationController!.value = index.toDouble();
    }
    final TabController result = TabController._(
      index: index ?? _index,
      length: length ?? this.length,
      animationController: _animationController,
      previousIndex: previousIndex ?? _previousIndex,
      animationDuration: animationDuration ?? _animationDuration,
    );
    _animationController = null;
    dispose();
    return result;
  }

  Animation<double>? get animation => _animationController?.view;
  AnimationController? _animationController;

  Duration get animationDuration => _animationDuration;
  final Duration _animationDuration;

  final int length;

  void _changeIndex(int value, {Duration? duration, Curve? curve}) {
    assert(value >= 0 && (value < length || length == 0));
    assert(duration != null || curve == null);
    assert(_indexIsChangingCount >= 0);
    if (value == _index || length < 2) {
      return;
    }
    _previousIndex = index;
    _index = value;
    if (duration != null && duration > Duration.zero) {
      _indexIsChangingCount += 1;
      notifyListeners(); // Because the value of indexIsChanging may have changed.
      _animationController!.animateTo(_index.toDouble(), duration: duration, curve: curve!).whenCompleteOrCancel(() {
        if (_animationController != null) {
          // don't notify if we've been disposed
          _indexIsChangingCount -= 1;
          notifyListeners();
        }
      });
    } else {
      _indexIsChangingCount += 1;
      _animationController!.value = _index.toDouble();
      _indexIsChangingCount -= 1;
      notifyListeners();
    }
  }

  int get index => _index;
  int _index;
  set index(int value) {
    _changeIndex(value);
  }

  int get previousIndex => _previousIndex;
  int _previousIndex;

  bool get indexIsChanging => _indexIsChangingCount != 0;
  int _indexIsChangingCount = 0;

  void animateTo(int value, {Duration? duration, Curve curve = Curves.ease}) {
    _changeIndex(value, duration: duration ?? _animationDuration, curve: curve);
  }

  double get offset => _animationController!.value - _index.toDouble();
  set offset(double value) {
    assert(value >= -1.0 && value <= 1.0);
    assert(!indexIsChanging);
    if (value == offset) {
      return;
    }
    _animationController!.value = value + _index.toDouble();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _animationController = null;
    super.dispose();
  }
}

class _TabControllerScope extends InheritedWidget {
  const _TabControllerScope({required this.controller, required this.enabled, required super.child});

  final TabController controller;
  final bool enabled;

  @override
  bool updateShouldNotify(_TabControllerScope old) => enabled != old.enabled || controller != old.controller;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TabController>('controller', controller));
    properties.add(DiagnosticsProperty<bool>('enabled', enabled));
  }
}

class DefaultTabController extends StatefulWidget {
  const DefaultTabController({
    required this.length,
    required this.child,
    super.key,
    this.initialIndex = 0,
    this.animationDuration,
  }) : assert(length >= 0),
       assert(length == 0 || (initialIndex >= 0 && initialIndex < length));

  final int length;

  final int initialIndex;

  final Duration? animationDuration;

  final Widget child;

  static TabController? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_TabControllerScope>()?.controller;

  static TabController of(BuildContext context) {
    final TabController? controller = maybeOf(context);
    assert(() {
      if (controller == null) {
        throw FlutterError(
          'DefaultTabController.of() was called with a context that does not '
          'contain a DefaultTabController widget.\n'
          'No DefaultTabController widget ancestor could be found starting from '
          'the context that was passed to DefaultTabController.of(). This can '
          'happen because you are using a widget that looks for a DefaultTabController '
          'ancestor, but no such ancestor exists.\n'
          'The context used was:\n'
          '  $context',
        );
      }
      return true;
    }());
    return controller!;
  }

  @override
  State<DefaultTabController> createState() => _DefaultTabControllerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('length', length));
    properties.add(IntProperty('initialIndex', initialIndex));
    properties.add(DiagnosticsProperty<Duration?>('animationDuration', animationDuration));
  }
}

class _DefaultTabControllerState extends State<DefaultTabController> with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      vsync: this,
      length: widget.length,
      initialIndex: widget.initialIndex,
      animationDuration: widget.animationDuration,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      _TabControllerScope(controller: _controller, enabled: TickerMode.of(context), child: widget.child);

  @override
  void didUpdateWidget(DefaultTabController oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.length != widget.length) {
      // If the length is shortened while the last tab is selected, we should
      // automatically update the index of the controller to be the new last tab.
      int? newIndex;
      int previousIndex = _controller.previousIndex;
      if (_controller.index >= widget.length) {
        newIndex = math.max(0, widget.length - 1);
        previousIndex = _controller.index;
      }
      _controller = _controller._copyWithAndDispose(
        length: widget.length,
        animationDuration: widget.animationDuration,
        index: newIndex,
        previousIndex: previousIndex,
      );
    }

    if (oldWidget.animationDuration != widget.animationDuration) {
      _controller = _controller._copyWithAndDispose(
        length: widget.length,
        animationDuration: widget.animationDuration,
        index: _controller.index,
        previousIndex: _controller.previousIndex,
      );
    }
  }
}
