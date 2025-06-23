import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:waveui/waveui.dart';

const Duration _bottomSheetEnterDuration = Duration(milliseconds: 250);
const Duration _bottomSheetExitDuration = Duration(milliseconds: 200);
const Curve _modalBottomSheetCurve = Easing.legacyDecelerate;
const double _minFlingVelocity = 700.0;
const double _closeProgressThreshold = 0.5;
const double _defaultScrollControlDisabledMaxHeightRatio = 9.0 / 16.0;

typedef BottomSheetDragStartHandler = void Function(DragStartDetails details);

typedef BottomSheetDragEndHandler = void Function(DragEndDetails details, {required bool isClosing});

class WaveBottomSheet extends StatefulWidget {
  const WaveBottomSheet({
    required this.onClosing,
    required this.builder,
    super.key,
    this.animationController,
    this.enableDrag = true,
    this.showDragHandle,
    this.dragHandleColor,
    this.dragHandleSize,
    this.onDragStart,
    this.onDragEnd,
    this.backgroundColor,
    this.shadowColor,
    this.elevation,
    this.shape,
    this.clipBehavior,
    this.constraints,
  }) : assert(elevation == null || elevation >= 0.0);

  final AnimationController? animationController;

  final VoidCallback onClosing;

  final WidgetBuilder builder;

  final bool enableDrag;

  final bool? showDragHandle;

  final Color? dragHandleColor;

  final Size? dragHandleSize;

  final BottomSheetDragStartHandler? onDragStart;

  final BottomSheetDragEndHandler? onDragEnd;

  final Color? backgroundColor;

  final Color? shadowColor;

  final double? elevation;

  final ShapeBorder? shape;

  final Clip? clipBehavior;

  final BoxConstraints? constraints;

  @override
  State<WaveBottomSheet> createState() => _WaveBottomSheetState();

  static AnimationController createAnimationController(TickerProvider vsync, {AnimationStyle? sheetAnimationStyle}) =>
      AnimationController(
        duration: sheetAnimationStyle?.duration ?? _bottomSheetEnterDuration,
        reverseDuration: sheetAnimationStyle?.reverseDuration ?? _bottomSheetExitDuration,
        debugLabel: 'BottomSheet',
        vsync: vsync,
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<AnimationController?>('animationController', animationController))
      ..add(ObjectFlagProperty<VoidCallback>.has('onClosing', onClosing))
      ..add(ObjectFlagProperty<WidgetBuilder>.has('builder', builder))
      ..add(DiagnosticsProperty<bool>('enableDrag', enableDrag))
      ..add(DiagnosticsProperty<bool?>('showDragHandle', showDragHandle))
      ..add(ColorProperty('dragHandleColor', dragHandleColor))
      ..add(DiagnosticsProperty<Size?>('dragHandleSize', dragHandleSize))
      ..add(ObjectFlagProperty<BottomSheetDragStartHandler?>.has('onDragStart', onDragStart))
      ..add(ObjectFlagProperty<BottomSheetDragEndHandler?>.has('onDragEnd', onDragEnd))
      ..add(ColorProperty('backgroundColor', backgroundColor))
      ..add(ColorProperty('shadowColor', shadowColor))
      ..add(DoubleProperty('elevation', elevation))
      ..add(DiagnosticsProperty<ShapeBorder?>('shape', shape))
      ..add(EnumProperty<Clip?>('clipBehavior', clipBehavior))
      ..add(DiagnosticsProperty<BoxConstraints?>('constraints', constraints));
  }
}

class _WaveBottomSheetState extends State<WaveBottomSheet> {
  final GlobalKey _childKey = GlobalKey(debugLabel: 'BottomSheet child');

  double get _childHeight {
    final RenderBox renderBox = _childKey.currentContext!.findRenderObject()! as RenderBox;
    return renderBox.size.height;
  }

  bool get _dismissUnderway => widget.animationController!.status == AnimationStatus.reverse;

  Set<WidgetState> dragHandleStates = <WidgetState>{};

  void _handleDragStart(DragStartDetails details) {
    setState(() {
      dragHandleStates.add(WidgetState.dragged);
    });
    widget.onDragStart?.call(details);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    assert(
      (widget.enableDrag || (widget.showDragHandle ?? false)) && widget.animationController != null,
      "'BottomSheet.animationController' cannot be null when 'BottomSheet.enableDrag' or 'BottomSheet.showDragHandle' is true. "
      "Use 'BottomSheet.createAnimationController' to create one, or provide another AnimationController.",
    );
    if (_dismissUnderway) {
      return;
    }
    widget.animationController!.value -= details.primaryDelta! / _childHeight;
  }

  void _handleDragEnd(DragEndDetails details) {
    assert(
      (widget.enableDrag || (widget.showDragHandle ?? false)) && widget.animationController != null,
      "'BottomSheet.animationController' cannot be null when 'BottomSheet.enableDrag' or 'BottomSheet.showDragHandle' is true. "
      "Use 'BottomSheet.createAnimationController' to create one, or provide another AnimationController.",
    );
    if (_dismissUnderway) {
      return;
    }
    setState(() {
      dragHandleStates.remove(WidgetState.dragged);
    });
    bool isClosing = false;
    if (details.velocity.pixelsPerSecond.dy > _minFlingVelocity) {
      final double flingVelocity = -details.velocity.pixelsPerSecond.dy / _childHeight;
      if (widget.animationController!.value > 0.0) {
        widget.animationController!.fling(velocity: flingVelocity);
      }
      if (flingVelocity < 0.0) {
        isClosing = true;
      }
    } else if (widget.animationController!.value < _closeProgressThreshold) {
      if (widget.animationController!.value > 0.0) {
        widget.animationController!.fling(velocity: -1.0);
      }
      isClosing = true;
    } else {
      widget.animationController!.forward();
    }

    widget.onDragEnd?.call(details, isClosing: isClosing);

    if (isClosing) {
      widget.onClosing();
    }
  }

  bool extentChanged(DraggableScrollableNotification notification) {
    if (notification.extent == notification.minExtent && notification.shouldCloseOnMinExtent) {
      widget.onClosing();
    }
    return false;
  }

  void _handleDragHandleHover(bool hovering) {
    if (hovering != dragHandleStates.contains(WidgetState.hovered)) {
      setState(() {
        if (hovering) {
          dragHandleStates.add(WidgetState.hovered);
        } else {
          dragHandleStates.remove(WidgetState.hovered);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final BottomSheetThemeData bottomSheetTheme = Theme.of(context).bottomSheetTheme;
    final bool useMaterial3 = Theme.of(context).useMaterial3;
    final BottomSheetThemeData defaults = useMaterial3 ? _BottomSheetDefaultsM3(context) : const BottomSheetThemeData();
    final BoxConstraints? constraints = widget.constraints ?? bottomSheetTheme.constraints ?? defaults.constraints;
    final Color? color = widget.backgroundColor ?? bottomSheetTheme.backgroundColor ?? defaults.backgroundColor;
    final Color? surfaceTintColor = bottomSheetTheme.surfaceTintColor ?? defaults.surfaceTintColor;
    final Color? shadowColor = widget.shadowColor ?? bottomSheetTheme.shadowColor ?? defaults.shadowColor;
    final double elevation = widget.elevation ?? bottomSheetTheme.elevation ?? defaults.elevation ?? 0;
    final ShapeBorder? shape = widget.shape ?? bottomSheetTheme.shape ?? defaults.shape;
    final Clip clipBehavior = widget.clipBehavior ?? bottomSheetTheme.clipBehavior ?? Clip.none;
    final bool showDragHandle =
        widget.showDragHandle ?? (widget.enableDrag && (bottomSheetTheme.showDragHandle ?? false));

    Widget? dragHandle;
    if (showDragHandle) {
      dragHandle = _DragHandle(
        onSemanticsTap: widget.onClosing,
        handleHover: _handleDragHandleHover,
        states: dragHandleStates,
        dragHandleColor: widget.dragHandleColor,
        dragHandleSize: widget.dragHandleSize,
      );

      if (!widget.enableDrag) {
        dragHandle = _BottomSheetGestureDetector(
          onVerticalDragStart: _handleDragStart,
          onVerticalDragUpdate: _handleDragUpdate,
          onVerticalDragEnd: _handleDragEnd,
          child: dragHandle,
        );
      }
    }

    Widget bottomSheet = Material(
      key: _childKey,
      color: color,
      elevation: elevation,
      surfaceTintColor: surfaceTintColor,
      shadowColor: shadowColor,
      shape: shape,
      clipBehavior: clipBehavior,
      child: NotificationListener<DraggableScrollableNotification>(
        onNotification: extentChanged,
        child:
            !showDragHandle
                ? widget.builder(context)
                : Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    dragHandle!,
                    Padding(
                      padding: const EdgeInsets.only(top: kMinInteractiveDimension),
                      child: widget.builder(context),
                    ),
                  ],
                ),
      ),
    );

    if (constraints != null) {
      bottomSheet = Align(
        alignment: Alignment.bottomCenter,
        heightFactor: 1.0,
        child: ConstrainedBox(constraints: constraints, child: bottomSheet),
      );
    }

    return !widget.enableDrag
        ? bottomSheet
        : _BottomSheetGestureDetector(
          onVerticalDragStart: _handleDragStart,
          onVerticalDragUpdate: _handleDragUpdate,
          onVerticalDragEnd: _handleDragEnd,
          child: bottomSheet,
        );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<WidgetState>('dragHandleStates', dragHandleStates));
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle({
    required this.onSemanticsTap,
    required this.handleHover,
    required this.states,
    this.dragHandleColor,
    this.dragHandleSize,
  });

  final VoidCallback? onSemanticsTap;
  final ValueChanged<bool> handleHover;
  final Set<WidgetState> states;
  final Color? dragHandleColor;
  final Size? dragHandleSize;

  @override
  Widget build(BuildContext context) {
    final BottomSheetThemeData bottomSheetTheme = Theme.of(context).bottomSheetTheme;
    final BottomSheetThemeData m3Defaults = _BottomSheetDefaultsM3(context);
    final Size handleSize = dragHandleSize ?? bottomSheetTheme.dragHandleSize ?? m3Defaults.dragHandleSize!;

    return MouseRegion(
      onEnter: (event) => handleHover(true),
      onExit: (event) => handleHover(false),
      child: Semantics(
        label: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        container: true,
        onTap: onSemanticsTap,
        child: SizedBox(
          width: math.max(handleSize.width, kMinInteractiveDimension),
          height: math.max(handleSize.height, kMinInteractiveDimension),
          child: Center(
            child: Container(
              height: handleSize.height,
              width: handleSize.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(handleSize.height / 2),
                color:
                    WidgetStateProperty.resolveAs<Color?>(dragHandleColor, states) ??
                    WidgetStateProperty.resolveAs<Color?>(bottomSheetTheme.dragHandleColor, states) ??
                    m3Defaults.dragHandleColor,
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
    properties
      ..add(ObjectFlagProperty<VoidCallback?>.has('onSemanticsTap', onSemanticsTap))
      ..add(ObjectFlagProperty<ValueChanged<bool>>.has('handleHover', handleHover))
      ..add(IterableProperty<WidgetState>('states', states))
      ..add(ColorProperty('dragHandleColor', dragHandleColor))
      ..add(DiagnosticsProperty<Size?>('dragHandleSize', dragHandleSize));
  }
}

class _BottomSheetLayoutWithSizeListener extends SingleChildRenderObjectWidget {
  const _BottomSheetLayoutWithSizeListener({
    required this.onChildSizeChanged,
    required this.animationValue,
    required this.isScrollControlled,
    required this.scrollControlDisabledMaxHeightRatio,
    super.child,
  });

  final ValueChanged<Size> onChildSizeChanged;
  final double animationValue;
  final bool isScrollControlled;
  final double scrollControlDisabledMaxHeightRatio;

  @override
  _RenderBottomSheetLayoutWithSizeListener createRenderObject(BuildContext context) =>
      _RenderBottomSheetLayoutWithSizeListener(
        onChildSizeChanged: onChildSizeChanged,
        animationValue: animationValue,
        isScrollControlled: isScrollControlled,
        scrollControlDisabledMaxHeightRatio: scrollControlDisabledMaxHeightRatio,
      );

  @override
  void updateRenderObject(BuildContext context, _RenderBottomSheetLayoutWithSizeListener renderObject) {
    renderObject
      ..onChildSizeChanged = onChildSizeChanged
      ..animationValue = animationValue
      ..isScrollControlled = isScrollControlled
      ..scrollControlDisabledMaxHeightRatio = scrollControlDisabledMaxHeightRatio;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<ValueChanged<Size>>.has('onChildSizeChanged', onChildSizeChanged))
      ..add(DoubleProperty('animationValue', animationValue))
      ..add(DiagnosticsProperty<bool>('isScrollControlled', isScrollControlled))
      ..add(DoubleProperty('scrollControlDisabledMaxHeightRatio', scrollControlDisabledMaxHeightRatio));
  }
}

class _RenderBottomSheetLayoutWithSizeListener extends RenderShiftedBox {
  _RenderBottomSheetLayoutWithSizeListener({
    required ValueChanged<Size> onChildSizeChanged,
    required double animationValue,
    required bool isScrollControlled,
    required double scrollControlDisabledMaxHeightRatio,
    RenderBox? child,
  }) : _onChildSizeChanged = onChildSizeChanged,
       _animationValue = animationValue,
       _isScrollControlled = isScrollControlled,
       _scrollControlDisabledMaxHeightRatio = scrollControlDisabledMaxHeightRatio,
       super(child);

  Size _lastSize = Size.zero;

  ValueChanged<Size> get onChildSizeChanged => _onChildSizeChanged;
  ValueChanged<Size> _onChildSizeChanged;
  set onChildSizeChanged(ValueChanged<Size> newCallback) {
    if (_onChildSizeChanged == newCallback) {
      return;
    }

    _onChildSizeChanged = newCallback;
    markNeedsLayout();
  }

  double get animationValue => _animationValue;
  double _animationValue;
  set animationValue(double newValue) {
    if (_animationValue == newValue) {
      return;
    }

    _animationValue = newValue;
    markNeedsLayout();
  }

  bool get isScrollControlled => _isScrollControlled;
  bool _isScrollControlled;
  set isScrollControlled(bool newValue) {
    if (_isScrollControlled == newValue) {
      return;
    }

    _isScrollControlled = newValue;
    markNeedsLayout();
  }

  double get scrollControlDisabledMaxHeightRatio => _scrollControlDisabledMaxHeightRatio;
  double _scrollControlDisabledMaxHeightRatio;
  set scrollControlDisabledMaxHeightRatio(double newValue) {
    if (_scrollControlDisabledMaxHeightRatio == newValue) {
      return;
    }

    _scrollControlDisabledMaxHeightRatio = newValue;
    markNeedsLayout();
  }

  @override
  double computeMinIntrinsicWidth(double height) => 0.0;

  @override
  double computeMaxIntrinsicWidth(double height) => 0.0;

  @override
  double computeMinIntrinsicHeight(double width) => 0.0;

  @override
  double computeMaxIntrinsicHeight(double width) => 0.0;

  @override
  Size computeDryLayout(BoxConstraints constraints) => constraints.biggest;

  @override
  double? computeDryBaseline(covariant BoxConstraints constraints, TextBaseline baseline) {
    final RenderBox? child = this.child;
    if (child == null) {
      return null;
    }
    final BoxConstraints childConstraints = _getConstraintsForChild(constraints);
    final double? result = child.getDryBaseline(childConstraints, baseline);
    if (result == null) {
      return null;
    }
    final Size childSize = childConstraints.isTight ? childConstraints.smallest : child.getDryLayout(childConstraints);
    return result + _getPositionForChild(constraints.biggest, childSize).dy;
  }

  BoxConstraints _getConstraintsForChild(BoxConstraints constraints) => BoxConstraints(
    minWidth: constraints.maxWidth,
    maxWidth: constraints.maxWidth,
    maxHeight: isScrollControlled ? constraints.maxHeight : constraints.maxHeight * scrollControlDisabledMaxHeightRatio,
  );

  Offset _getPositionForChild(Size size, Size childSize) =>
      Offset(0.0, size.height - childSize.height * animationValue);

  @override
  void performLayout() {
    size = constraints.biggest;
    final RenderBox? child = this.child;
    if (child == null) {
      return;
    }

    final BoxConstraints childConstraints = _getConstraintsForChild(constraints);
    assert(childConstraints.debugAssertIsValid(isAppliedConstraint: true));
    child.layout(childConstraints, parentUsesSize: !childConstraints.isTight);
    final BoxParentData childParentData = child.parentData! as BoxParentData;
    final Size childSize = childConstraints.isTight ? childConstraints.smallest : child.size;
    childParentData.offset = _getPositionForChild(size, childSize);

    if (_lastSize != childSize) {
      _lastSize = childSize;
      _onChildSizeChanged.call(_lastSize);
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<ValueChanged<Size>>.has('onChildSizeChanged', onChildSizeChanged))
      ..add(DoubleProperty('animationValue', animationValue))
      ..add(DiagnosticsProperty<bool>('isScrollControlled', isScrollControlled))
      ..add(DoubleProperty('scrollControlDisabledMaxHeightRatio', scrollControlDisabledMaxHeightRatio));
  }
}

class _ModalBottomSheet<T> extends StatefulWidget {
  const _ModalBottomSheet({
    required this.route,
    super.key,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.clipBehavior,
    this.constraints,
    this.isScrollControlled = false,
    this.scrollControlDisabledMaxHeightRatio = _defaultScrollControlDisabledMaxHeightRatio,
    this.enableDrag = true,
    this.showDragHandle = true,
  });

  final ModalBottomSheetRoute<T> route;
  final bool isScrollControlled;
  final double scrollControlDisabledMaxHeightRatio;
  final Color? backgroundColor;
  final double? elevation;
  final ShapeBorder? shape;
  final Clip? clipBehavior;
  final BoxConstraints? constraints;
  final bool enableDrag;
  final bool showDragHandle;

  @override
  _ModalBottomSheetState<T> createState() => _ModalBottomSheetState<T>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<ModalBottomSheetRoute<T>>('route', route))
      ..add(DiagnosticsProperty<bool>('isScrollControlled', isScrollControlled))
      ..add(DoubleProperty('scrollControlDisabledMaxHeightRatio', scrollControlDisabledMaxHeightRatio))
      ..add(ColorProperty('backgroundColor', backgroundColor))
      ..add(DoubleProperty('elevation', elevation))
      ..add(DiagnosticsProperty<ShapeBorder?>('shape', shape))
      ..add(EnumProperty<Clip?>('clipBehavior', clipBehavior))
      ..add(DiagnosticsProperty<BoxConstraints?>('constraints', constraints))
      ..add(DiagnosticsProperty<bool>('enableDrag', enableDrag))
      ..add(DiagnosticsProperty<bool>('showDragHandle', showDragHandle));
  }
}

class _ModalBottomSheetState<T> extends State<_ModalBottomSheet<T>> {
  ParametricCurve<double> animationCurve = _modalBottomSheetCurve;

  String _getRouteLabel(MaterialLocalizations localizations) {
    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return '';
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return localizations.dialogLabel;
    }
  }

  EdgeInsets _getNewClipDetails(Size topLayerSize) => EdgeInsets.fromLTRB(0, 0, 0, topLayerSize.height);

  void handleDragStart(DragStartDetails details) {
    animationCurve = Curves.linear;
  }

  void handleDragEnd(DragEndDetails details, {bool? isClosing}) {
    animationCurve = Split(widget.route.animation!.value, endCurve: _modalBottomSheetCurve);
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    assert(debugCheckHasMaterialLocalizations(context));
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final String routeLabel = _getRouteLabel(localizations);

    return AnimatedBuilder(
      animation: widget.route.animation!,
      child: WaveBottomSheet(
        animationController: widget.route._animationController,
        onClosing: () {
          if (widget.route.isCurrent) {
            Navigator.pop(context);
          }
        },
        builder: widget.route.builder,
        backgroundColor: widget.backgroundColor,
        elevation: widget.elevation,
        shape:
            widget.shape ??
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            ),
        clipBehavior: widget.clipBehavior,
        constraints: widget.constraints,
        enableDrag: widget.enableDrag,
        showDragHandle: widget.showDragHandle,
        onDragStart: handleDragStart,
        onDragEnd: handleDragEnd,
      ),
      builder: (context, child) {
        final double animationValue = animationCurve.transform(widget.route.animation!.value);
        return Semantics(
          scopesRoute: true,
          namesRoute: true,
          label: routeLabel,
          explicitChildNodes: true,
          child: ClipRect(
            child: _BottomSheetLayoutWithSizeListener(
              onChildSizeChanged: (size) {
                widget.route._didChangeBarrierSemanticsClip(_getNewClipDetails(size));
              },
              animationValue: animationValue,
              isScrollControlled: widget.isScrollControlled,
              scrollControlDisabledMaxHeightRatio: widget.scrollControlDisabledMaxHeightRatio,
              child: child,
            ),
          ),
        );
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ParametricCurve<double>>('animationCurve', animationCurve));
  }
}

class ModalBottomSheetRoute<T> extends PopupRoute<T> {
  ModalBottomSheetRoute({
    required this.builder,
    required this.isScrollControlled,
    this.capturedThemes,
    this.barrierLabel,
    this.barrierOnTapHint,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.clipBehavior,
    this.constraints,
    this.modalBarrierColor,
    this.isDismissible = true,
    this.enableDrag = true,
    this.showDragHandle = true,
    this.scrollControlDisabledMaxHeightRatio = _defaultScrollControlDisabledMaxHeightRatio,
    super.settings,
    super.requestFocus,
    this.transitionAnimationController,
    this.anchorPoint,
    this.useSafeArea = false,
    this.sheetAnimationStyle,
  });

  final WidgetBuilder builder;

  final CapturedThemes? capturedThemes;

  final bool isScrollControlled;

  final double scrollControlDisabledMaxHeightRatio;

  final Color? backgroundColor;

  final double? elevation;

  final ShapeBorder? shape;

  final Clip? clipBehavior;

  final BoxConstraints? constraints;

  final Color? modalBarrierColor;

  final bool isDismissible;

  final bool enableDrag;

  final bool showDragHandle;

  final AnimationController? transitionAnimationController;

  final Offset? anchorPoint;

  final bool useSafeArea;

  final AnimationStyle? sheetAnimationStyle;

  final String? barrierOnTapHint;

  final ValueNotifier<EdgeInsets> _clipDetailsNotifier = ValueNotifier<EdgeInsets>(EdgeInsets.zero);

  @override
  void dispose() {
    _clipDetailsNotifier.dispose();
    super.dispose();
  }

  bool _didChangeBarrierSemanticsClip(EdgeInsets newClipDetails) {
    if (_clipDetailsNotifier.value == newClipDetails) {
      return false;
    }
    _clipDetailsNotifier.value = newClipDetails;
    return true;
  }

  @override
  Duration get transitionDuration =>
      transitionAnimationController?.duration ?? sheetAnimationStyle?.duration ?? _bottomSheetEnterDuration;

  @override
  Duration get reverseTransitionDuration =>
      transitionAnimationController?.reverseDuration ??
      transitionAnimationController?.duration ??
      sheetAnimationStyle?.reverseDuration ??
      _bottomSheetExitDuration;

  @override
  bool get barrierDismissible => isDismissible;

  @override
  final String? barrierLabel;

  @override
  Color get barrierColor => modalBarrierColor ?? Colors.black54;

  AnimationController? _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    if (transitionAnimationController != null) {
      _animationController = transitionAnimationController;
      willDisposeAnimationController = false;
    } else {
      _animationController = WaveBottomSheet.createAnimationController(
        navigator!,
        sheetAnimationStyle: sheetAnimationStyle,
      );
    }
    return _animationController!;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    final Widget content = DisplayFeatureSubScreen(
      anchorPoint: anchorPoint,
      child: Builder(
        builder: (context) {
          final BottomSheetThemeData sheetTheme = Theme.of(context).bottomSheetTheme;
          final BottomSheetThemeData defaults =
              Theme.of(context).useMaterial3 ? _BottomSheetDefaultsM3(context) : const BottomSheetThemeData();
          return _ModalBottomSheet<T>(
            route: this,
            backgroundColor:
                backgroundColor ??
                sheetTheme.modalBackgroundColor ??
                sheetTheme.backgroundColor ??
                defaults.backgroundColor,
            elevation: elevation ?? sheetTheme.modalElevation ?? sheetTheme.elevation ?? defaults.modalElevation,
            shape: shape,
            clipBehavior: clipBehavior,
            constraints: constraints,
            isScrollControlled: isScrollControlled,
            scrollControlDisabledMaxHeightRatio: scrollControlDisabledMaxHeightRatio,
            enableDrag: enableDrag,
            showDragHandle: showDragHandle,
          );
        },
      ),
    );

    final Widget bottomSheet =
        useSafeArea
            ? SafeArea(bottom: false, child: content)
            : MediaQuery.removePadding(context: context, removeTop: true, child: content);

    return capturedThemes?.wrap(bottomSheet) ?? bottomSheet;
  }

  @override
  Widget buildModalBarrier() {
    if (barrierColor.a != 0 && !offstage) {
      assert(barrierColor != barrierColor.withValues(alpha: 0.0));
      final Animation<Color?> color = animation!.drive(
        ColorTween(
          begin: barrierColor.withValues(alpha: 0.0),
          end: barrierColor,
        ).chain(CurveTween(curve: barrierCurve)),
      );
      return AnimatedModalBarrier(
        color: color,
        dismissible: barrierDismissible,
        semanticsLabel: barrierLabel,
        barrierSemanticsDismissible: semanticsDismissible,
        clipDetailsNotifier: _clipDetailsNotifier,
        semanticsOnTapHint: barrierOnTapHint,
      );
    } else {
      return ModalBarrier(
        dismissible: barrierDismissible,
        semanticsLabel: barrierLabel,
        barrierSemanticsDismissible: semanticsDismissible,
        clipDetailsNotifier: _clipDetailsNotifier,
        semanticsOnTapHint: barrierOnTapHint,
      );
    }
  }
}

Future<T?> showWaveModalBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? backgroundColor,
  String? barrierLabel,
  double? elevation,
  ShapeBorder? shape,
  Clip? clipBehavior,
  BoxConstraints? constraints,
  Color? barrierColor,
  bool isScrollControlled = true,
  double scrollControlDisabledMaxHeightRatio = _defaultScrollControlDisabledMaxHeightRatio,
  bool useRootNavigator = false,
  bool isDismissible = true,
  bool enableDrag = true,
  bool showDragHandle = true,
  bool useSafeArea = false,
  RouteSettings? routeSettings,
  AnimationController? transitionAnimationController,
  Offset? anchorPoint,
  AnimationStyle? sheetAnimationStyle,
}) {
  assert(debugCheckHasMediaQuery(context));
  assert(debugCheckHasMaterialLocalizations(context));

  final NavigatorState navigator = Navigator.of(context, rootNavigator: useRootNavigator);
  final MaterialLocalizations localizations = MaterialLocalizations.of(context);
  return navigator.push(
    ModalBottomSheetRoute<T>(
      builder: builder,
      capturedThemes: InheritedTheme.capture(from: context, to: navigator.context),
      isScrollControlled: isScrollControlled,
      scrollControlDisabledMaxHeightRatio: scrollControlDisabledMaxHeightRatio,
      barrierLabel: barrierLabel ?? localizations.scrimLabel,
      barrierOnTapHint: localizations.scrimOnTapHint(localizations.bottomSheetLabel),
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      constraints: constraints,
      isDismissible: isDismissible,
      modalBarrierColor: barrierColor ?? Theme.of(context).bottomSheetTheme.modalBarrierColor,
      enableDrag: enableDrag,
      showDragHandle: showDragHandle,
      settings: routeSettings,
      transitionAnimationController: transitionAnimationController,
      anchorPoint: anchorPoint,
      useSafeArea: useSafeArea,
      sheetAnimationStyle: sheetAnimationStyle,
    ),
  );
}

PersistentBottomSheetController showBottomSheet({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? backgroundColor,
  double? elevation,
  ShapeBorder? shape,
  Clip? clipBehavior,
  BoxConstraints? constraints,
  bool? enableDrag,
  bool? showDragHandle,
  AnimationController? transitionAnimationController,
  AnimationStyle? sheetAnimationStyle,
}) {
  assert(debugCheckHasScaffold(context));

  return Scaffold.of(context).showBottomSheet(
    builder,
    backgroundColor: backgroundColor,
    elevation: elevation,
    shape: shape,
    clipBehavior: clipBehavior,
    constraints: constraints,
    enableDrag: enableDrag,
    showDragHandle: showDragHandle,
    transitionAnimationController: transitionAnimationController,
    sheetAnimationStyle: sheetAnimationStyle,
  );
}

class _BottomSheetGestureDetector extends StatelessWidget {
  const _BottomSheetGestureDetector({
    required this.child,
    required this.onVerticalDragStart,
    required this.onVerticalDragUpdate,
    required this.onVerticalDragEnd,
  });

  final Widget child;
  final GestureDragStartCallback onVerticalDragStart;
  final GestureDragUpdateCallback onVerticalDragUpdate;
  final GestureDragEndCallback onVerticalDragEnd;

  @override
  Widget build(BuildContext context) => RawGestureDetector(
    excludeFromSemantics: true,
    gestures: <Type, GestureRecognizerFactory<GestureRecognizer>>{
      VerticalDragGestureRecognizer: GestureRecognizerFactoryWithHandlers<VerticalDragGestureRecognizer>(
        () => VerticalDragGestureRecognizer(debugOwner: this),
        (instance) {
          instance
            ..onStart = onVerticalDragStart
            ..onUpdate = onVerticalDragUpdate
            ..onEnd = onVerticalDragEnd
            ..onlyAcceptDragOnThreshold = true;
        },
      ),
    },
    child: child,
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<GestureDragStartCallback>.has('onVerticalDragStart', onVerticalDragStart))
      ..add(ObjectFlagProperty<GestureDragUpdateCallback>.has('onVerticalDragUpdate', onVerticalDragUpdate))
      ..add(ObjectFlagProperty<GestureDragEndCallback>.has('onVerticalDragEnd', onVerticalDragEnd));
  }
}

class _BottomSheetDefaultsM3 extends BottomSheetThemeData {
  _BottomSheetDefaultsM3(this.context)
    : super(
        elevation: 1.0,
        modalElevation: 1.0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28.0))),
        constraints: const BoxConstraints(maxWidth: 640),
      );

  final BuildContext context;
  late final _colors = WaveApp.themeOf(context).colorScheme;

  @override
  Color? get backgroundColor => _colors.surfacePrimary;

  @override
  Color? get surfaceTintColor => Colors.transparent;

  @override
  Color? get shadowColor => Colors.transparent;

  @override
  Color? get dragHandleColor => _colors.outlineStandard;

  @override
  Size? get dragHandleSize => const Size(32, 4);

  @override
  BoxConstraints? get constraints => const BoxConstraints(maxWidth: 640.0);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BuildContext>('context', context));
  }
}
