// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show DiagnosticPropertiesBuilder, DoubleProperty, EnumProperty, ObjectFlagProperty, StringProperty, clampDouble;

import 'package:waveui/material/debug.dart';
import 'package:waveui/material/material_localizations.dart';
import 'package:waveui/material/progress_indicator.dart';
import 'package:waveui/material/theme.dart';

// The over-scroll distance that moves the indicator to its maximum
// displacement, as a percentage of the scrollable's container extent.
const double _kDragContainerExtentPercentage = 0.25;

// How much the scroll's drag gesture can overshoot the RefreshIndicator's
// displacement; max displacement = _kDragSizeFactorLimit * displacement.
const double _kDragSizeFactorLimit = 1.5;

// When the scroll ends, the duration of the refresh indicator's animation
// to the RefreshIndicator's displacement.
const Duration _kIndicatorSnapDuration = Duration(milliseconds: 150);

// The duration of the ScaleTransition that starts when the refresh action
// has completed.
const Duration _kIndicatorScaleDuration = Duration(milliseconds: 200);

typedef RefreshCallback = Future<void> Function();

enum RefreshIndicatorStatus { drag, armed, snap, refresh, done, canceled }

enum RefreshIndicatorTriggerMode { anywhere, onEdge }

enum _IndicatorType { material, adaptive, noSpinner }

class RefreshIndicator extends StatefulWidget {
  const RefreshIndicator({
    required this.child,
    required this.onRefresh,
    super.key,
    this.displacement = 40.0,
    this.edgeOffset = 0.0,
    this.color,
    this.backgroundColor,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.semanticsLabel,
    this.semanticsValue,
    this.strokeWidth = RefreshProgressIndicator.defaultStrokeWidth,
    this.triggerMode = RefreshIndicatorTriggerMode.onEdge,
    this.elevation = 2.0,
  }) : _indicatorType = _IndicatorType.material,
       onStatusChange = null,
       assert(elevation >= 0.0);

  const RefreshIndicator.adaptive({
    required this.child,
    required this.onRefresh,
    super.key,
    this.displacement = 40.0,
    this.edgeOffset = 0.0,
    this.color,
    this.backgroundColor,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.semanticsLabel,
    this.semanticsValue,
    this.strokeWidth = RefreshProgressIndicator.defaultStrokeWidth,
    this.triggerMode = RefreshIndicatorTriggerMode.onEdge,
    this.elevation = 2.0,
  }) : _indicatorType = _IndicatorType.adaptive,
       onStatusChange = null,
       assert(elevation >= 0.0);

  const RefreshIndicator.noSpinner({
    required this.child,
    required this.onRefresh,
    super.key,
    this.onStatusChange,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.semanticsLabel,
    this.semanticsValue,
    this.triggerMode = RefreshIndicatorTriggerMode.onEdge,
    this.elevation = 2.0,
  }) : _indicatorType = _IndicatorType.noSpinner,
       // The following parameters aren't used because [_IndicatorType.noSpinner] is being used,
       // which involves showing no spinner, hence the following parameters are useless since
       // their only use is to change the spinner's appearance.
       displacement = 0.0,
       edgeOffset = 0.0,
       color = null,
       backgroundColor = null,
       strokeWidth = 0.0,
       assert(elevation >= 0.0);

  final Widget child;

  final double displacement;

  final double edgeOffset;

  final RefreshCallback onRefresh;

  final ValueChanged<RefreshIndicatorStatus?>? onStatusChange;

  final Color? color;

  final Color? backgroundColor;

  final ScrollNotificationPredicate notificationPredicate;

  final String? semanticsLabel;

  final String? semanticsValue;

  final double strokeWidth;

  final _IndicatorType _indicatorType;

  final RefreshIndicatorTriggerMode triggerMode;

  final double elevation;

  @override
  RefreshIndicatorState createState() => RefreshIndicatorState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('displacement', displacement));
    properties.add(DoubleProperty('edgeOffset', edgeOffset));
    properties.add(ObjectFlagProperty<RefreshCallback>.has('onRefresh', onRefresh));
    properties.add(ObjectFlagProperty<ValueChanged<RefreshIndicatorStatus?>?>.has('onStatusChange', onStatusChange));
    properties.add(ColorProperty('color', color));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(ObjectFlagProperty<ScrollNotificationPredicate>.has('notificationPredicate', notificationPredicate));
    properties.add(StringProperty('semanticsLabel', semanticsLabel));
    properties.add(StringProperty('semanticsValue', semanticsValue));
    properties.add(DoubleProperty('strokeWidth', strokeWidth));
    properties.add(EnumProperty<RefreshIndicatorTriggerMode>('triggerMode', triggerMode));
    properties.add(DoubleProperty('elevation', elevation));
  }
}

class RefreshIndicatorState extends State<RefreshIndicator> with TickerProviderStateMixin<RefreshIndicator> {
  late AnimationController _positionController;
  late AnimationController _scaleController;
  late Animation<double> _positionFactor;
  late Animation<double> _scaleFactor;
  late Animation<double> _value;
  late Animation<Color?> _valueColor;

  RefreshIndicatorStatus? _status;
  late Future<void> _pendingRefreshFuture;
  bool? _isIndicatorAtTop;
  double? _dragOffset;
  late Color _effectiveValueColor = widget.color ?? Theme.of(context).colorScheme.primary;

  static final Animatable<double> _threeQuarterTween = Tween<double>(begin: 0.0, end: 0.75);

  static final Animatable<double> _kDragSizeFactorLimitTween = Tween<double>(begin: 0.0, end: _kDragSizeFactorLimit);

  static final Animatable<double> _oneToZeroTween = Tween<double>(begin: 1.0, end: 0.0);

  @protected
  @override
  void initState() {
    super.initState();
    _positionController = AnimationController(vsync: this);
    _positionFactor = _positionController.drive(_kDragSizeFactorLimitTween);

    // The "value" of the circular progress indicator during a drag.
    _value = _positionController.drive(_threeQuarterTween);

    _scaleController = AnimationController(vsync: this);
    _scaleFactor = _scaleController.drive(_oneToZeroTween);
  }

  @protected
  @override
  void didChangeDependencies() {
    _setupColorTween();
    super.didChangeDependencies();
  }

  @protected
  @override
  void didUpdateWidget(covariant RefreshIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.color != widget.color) {
      _setupColorTween();
    }
  }

  @protected
  @override
  void dispose() {
    _positionController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _setupColorTween() {
    // Reset the current value color.
    _effectiveValueColor = widget.color ?? Theme.of(context).colorScheme.primary;
    final Color color = _effectiveValueColor;
    if (color.alpha == 0x00) {
      // Set an always stopped animation instead of a driven tween.
      _valueColor = AlwaysStoppedAnimation<Color>(color);
    } else {
      // Respect the alpha of the given color.
      _valueColor = _positionController.drive(
        ColorTween(
          begin: color.withAlpha(0),
          end: color.withAlpha(color.alpha),
        ).chain(CurveTween(curve: const Interval(0.0, 1.0 / _kDragSizeFactorLimit))),
      );
    }
  }

  bool _shouldStart(ScrollNotification notification) {
    // If the notification.dragDetails is null, this scroll is not triggered by
    // user dragging. It may be a result of ScrollController.jumpTo or ballistic scroll.
    // In this case, we don't want to trigger the refresh indicator.
    return ((notification is ScrollStartNotification && notification.dragDetails != null) ||
            (notification is ScrollUpdateNotification &&
                notification.dragDetails != null &&
                widget.triggerMode == RefreshIndicatorTriggerMode.anywhere)) &&
        ((notification.metrics.axisDirection == AxisDirection.up && notification.metrics.extentAfter == 0.0) ||
            (notification.metrics.axisDirection == AxisDirection.down && notification.metrics.extentBefore == 0.0)) &&
        _status == null &&
        _start(notification.metrics.axisDirection);
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (!widget.notificationPredicate(notification)) {
      return false;
    }
    if (_shouldStart(notification)) {
      setState(() {
        _status = RefreshIndicatorStatus.drag;
        widget.onStatusChange?.call(_status);
      });
      return false;
    }
    final bool? indicatorAtTopNow = switch (notification.metrics.axisDirection) {
      AxisDirection.down || AxisDirection.up => true,
      AxisDirection.left || AxisDirection.right => null,
    };
    if (indicatorAtTopNow != _isIndicatorAtTop) {
      if (_status == RefreshIndicatorStatus.drag || _status == RefreshIndicatorStatus.armed) {
        _dismiss(RefreshIndicatorStatus.canceled);
      }
    } else if (notification is ScrollUpdateNotification) {
      if (_status == RefreshIndicatorStatus.drag || _status == RefreshIndicatorStatus.armed) {
        if (notification.metrics.axisDirection == AxisDirection.down) {
          _dragOffset = _dragOffset! - notification.scrollDelta!;
        } else if (notification.metrics.axisDirection == AxisDirection.up) {
          _dragOffset = _dragOffset! + notification.scrollDelta!;
        }
        _checkDragOffset(notification.metrics.viewportDimension);
      }
      if (_status == RefreshIndicatorStatus.armed && notification.dragDetails == null) {
        // On iOS start the refresh when the Scrollable bounces back from the
        // overscroll (ScrollNotification indicating this don't have dragDetails
        // because the scroll activity is not directly triggered by a drag).
        _show();
      }
    } else if (notification is OverscrollNotification) {
      if (_status == RefreshIndicatorStatus.drag || _status == RefreshIndicatorStatus.armed) {
        if (notification.metrics.axisDirection == AxisDirection.down) {
          _dragOffset = _dragOffset! - notification.overscroll;
        } else if (notification.metrics.axisDirection == AxisDirection.up) {
          _dragOffset = _dragOffset! + notification.overscroll;
        }
        _checkDragOffset(notification.metrics.viewportDimension);
      }
    } else if (notification is ScrollEndNotification) {
      switch (_status) {
        case RefreshIndicatorStatus.armed:
          if (_positionController.value < 1.0) {
            _dismiss(RefreshIndicatorStatus.canceled);
          } else {
            _show();
          }
        case RefreshIndicatorStatus.drag:
          _dismiss(RefreshIndicatorStatus.canceled);
        case RefreshIndicatorStatus.canceled:
        case RefreshIndicatorStatus.done:
        case RefreshIndicatorStatus.refresh:
        case RefreshIndicatorStatus.snap:
        case null:
          // do nothing
          break;
      }
    }
    return false;
  }

  bool _handleIndicatorNotification(OverscrollIndicatorNotification notification) {
    if (notification.depth != 0 || !notification.leading) {
      return false;
    }
    if (_status == RefreshIndicatorStatus.drag) {
      notification.disallowIndicator();
      return true;
    }
    return false;
  }

  bool _start(AxisDirection direction) {
    assert(_status == null);
    assert(_isIndicatorAtTop == null);
    assert(_dragOffset == null);
    switch (direction) {
      case AxisDirection.down:
      case AxisDirection.up:
        _isIndicatorAtTop = true;
      case AxisDirection.left:
      case AxisDirection.right:
        _isIndicatorAtTop = null;
        // we do not support horizontal scroll views.
        return false;
    }
    _dragOffset = 0.0;
    _scaleController.value = 0.0;
    _positionController.value = 0.0;
    return true;
  }

  void _checkDragOffset(double containerExtent) {
    assert(_status == RefreshIndicatorStatus.drag || _status == RefreshIndicatorStatus.armed);
    double newValue = _dragOffset! / (containerExtent * _kDragContainerExtentPercentage);
    if (_status == RefreshIndicatorStatus.armed) {
      newValue = math.max(newValue, 1.0 / _kDragSizeFactorLimit);
    }
    _positionController.value = clampDouble(newValue, 0.0, 1.0); // This triggers various rebuilds.
    if (_status == RefreshIndicatorStatus.drag && _valueColor.value!.alpha == _effectiveValueColor.alpha) {
      _status = RefreshIndicatorStatus.armed;
      widget.onStatusChange?.call(_status);
    }
  }

  // Stop showing the refresh indicator.
  Future<void> _dismiss(RefreshIndicatorStatus newMode) async {
    await Future<void>.value();
    // This can only be called from _show() when refreshing and
    // _handleScrollNotification in response to a ScrollEndNotification or
    // direction change.
    assert(newMode == RefreshIndicatorStatus.canceled || newMode == RefreshIndicatorStatus.done);
    setState(() {
      _status = newMode;
      widget.onStatusChange?.call(_status);
    });
    switch (_status!) {
      case RefreshIndicatorStatus.done:
        await _scaleController.animateTo(1.0, duration: _kIndicatorScaleDuration);
      case RefreshIndicatorStatus.canceled:
        await _positionController.animateTo(0.0, duration: _kIndicatorScaleDuration);
      case RefreshIndicatorStatus.armed:
      case RefreshIndicatorStatus.drag:
      case RefreshIndicatorStatus.refresh:
      case RefreshIndicatorStatus.snap:
        assert(false);
    }
    if (mounted && _status == newMode) {
      _dragOffset = null;
      _isIndicatorAtTop = null;
      setState(() {
        _status = null;
      });
    }
  }

  void _show() {
    assert(_status != RefreshIndicatorStatus.refresh);
    assert(_status != RefreshIndicatorStatus.snap);
    final Completer<void> completer = Completer<void>();
    _pendingRefreshFuture = completer.future;
    _status = RefreshIndicatorStatus.snap;
    widget.onStatusChange?.call(_status);
    _positionController.animateTo(1.0 / _kDragSizeFactorLimit, duration: _kIndicatorSnapDuration).then<void>((value) {
      if (mounted && _status == RefreshIndicatorStatus.snap) {
        setState(() {
          // Show the indeterminate progress indicator.
          _status = RefreshIndicatorStatus.refresh;
        });

        final Future<void> refreshResult = widget.onRefresh();
        refreshResult.whenComplete(() {
          if (mounted && _status == RefreshIndicatorStatus.refresh) {
            completer.complete();
            _dismiss(RefreshIndicatorStatus.done);
          }
        });
      }
    });
  }

  Future<void> show({bool atTop = true}) {
    if (_status != RefreshIndicatorStatus.refresh && _status != RefreshIndicatorStatus.snap) {
      if (_status == null) {
        _start(atTop ? AxisDirection.down : AxisDirection.up);
      }
      _show();
    }
    return _pendingRefreshFuture;
  }

  @protected
  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final Widget child = NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: _handleIndicatorNotification,
        child: widget.child,
      ),
    );
    assert(() {
      if (_status == null) {
        assert(_dragOffset == null);
        assert(_isIndicatorAtTop == null);
      } else {
        assert(_dragOffset != null);
        assert(_isIndicatorAtTop != null);
      }
      return true;
    }());

    final bool showIndeterminateIndicator =
        _status == RefreshIndicatorStatus.refresh || _status == RefreshIndicatorStatus.done;

    return Stack(
      children: <Widget>[
        child,
        if (_status != null)
          Positioned(
            top: _isIndicatorAtTop! ? widget.edgeOffset : null,
            bottom: !_isIndicatorAtTop! ? widget.edgeOffset : null,
            left: 0.0,
            right: 0.0,
            child: SizeTransition(
              axisAlignment: _isIndicatorAtTop! ? 1.0 : -1.0,
              sizeFactor: _positionFactor, // This is what brings it down.
              child: Padding(
                padding:
                    _isIndicatorAtTop!
                        ? EdgeInsets.only(top: widget.displacement)
                        : EdgeInsets.only(bottom: widget.displacement),
                child: Align(
                  alignment: _isIndicatorAtTop! ? Alignment.topCenter : Alignment.bottomCenter,
                  child: ScaleTransition(
                    scale: _scaleFactor,
                    child: AnimatedBuilder(
                      animation: _positionController,
                      builder: (context, child) {
                        final Widget materialIndicator = RefreshProgressIndicator(
                          semanticsLabel:
                              widget.semanticsLabel ?? MaterialLocalizations.of(context).refreshIndicatorSemanticLabel,
                          semanticsValue: widget.semanticsValue,
                          value: showIndeterminateIndicator ? null : _value.value,
                          valueColor: _valueColor,
                          backgroundColor: widget.backgroundColor,
                          strokeWidth: widget.strokeWidth,
                          elevation: widget.elevation,
                        );

                        final Widget cupertinoIndicator = CupertinoActivityIndicator(color: widget.color);

                        switch (widget._indicatorType) {
                          case _IndicatorType.material:
                            return materialIndicator;

                          case _IndicatorType.adaptive:
                            final ThemeData theme = Theme.of(context);
                            switch (theme.platform) {
                              case TargetPlatform.android:
                              case TargetPlatform.fuchsia:
                              case TargetPlatform.linux:
                              case TargetPlatform.windows:
                                return materialIndicator;
                              case TargetPlatform.iOS:
                              case TargetPlatform.macOS:
                                return cupertinoIndicator;
                            }

                          case _IndicatorType.noSpinner:
                            return Container();
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
