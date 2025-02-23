// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/colors.dart';
import 'package:waveui/material/ink_well.dart';
import 'package:waveui/material/material.dart';
import 'package:waveui/material/theme.dart';

// Examples can assume:
// late BuildContext context;

class CarouselView extends StatefulWidget {
  const CarouselView({
    required double this.itemExtent,
    required this.children,
    super.key,
    this.padding,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.overlayColor,
    this.itemSnapping = false,
    this.shrinkExtent = 0.0,
    this.controller,
    this.scrollDirection = Axis.horizontal,
    this.reverse = false,
    this.onTap,
    this.enableSplash = true,
  }) : consumeMaxWeight = true,
       flexWeights = null;

  const CarouselView.weighted({
    required List<int> this.flexWeights,
    required this.children,
    super.key,
    this.padding,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.overlayColor,
    this.itemSnapping = false,
    this.shrinkExtent = 0.0,
    this.controller,
    this.scrollDirection = Axis.horizontal,
    this.reverse = false,
    this.consumeMaxWeight = true,
    this.onTap,
    this.enableSplash = true,
  }) : itemExtent = null;

  final EdgeInsets? padding;

  final Color? backgroundColor;

  final double? elevation;

  final ShapeBorder? shape;

  final WidgetStateProperty<Color?>? overlayColor;

  final double shrinkExtent;

  final bool itemSnapping;

  final CarouselController? controller;

  final Axis scrollDirection;

  final bool reverse;

  final bool consumeMaxWeight;

  final ValueChanged<int>? onTap;

  final bool enableSplash;

  final double? itemExtent;

  final List<int>? flexWeights;

  final List<Widget> children;

  @override
  State<CarouselView> createState() => _CarouselViewState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<EdgeInsets?>('padding', padding))
      ..add(ColorProperty('backgroundColor', backgroundColor))
      ..add(DoubleProperty('elevation', elevation))
      ..add(DiagnosticsProperty<ShapeBorder?>('shape', shape))
      ..add(DiagnosticsProperty<WidgetStateProperty<Color?>?>('overlayColor', overlayColor))
      ..add(DoubleProperty('shrinkExtent', shrinkExtent))
      ..add(DiagnosticsProperty<bool>('itemSnapping', itemSnapping))
      ..add(DiagnosticsProperty<CarouselController?>('controller', controller))
      ..add(EnumProperty<Axis>('scrollDirection', scrollDirection))
      ..add(DiagnosticsProperty<bool>('reverse', reverse))
      ..add(DiagnosticsProperty<bool>('consumeMaxWeight', consumeMaxWeight))
      ..add(ObjectFlagProperty<ValueChanged<int>?>.has('onTap', onTap))
      ..add(DiagnosticsProperty<bool>('enableSplash', enableSplash))
      ..add(DoubleProperty('itemExtent', itemExtent))
      ..add(IterableProperty<int>('flexWeights', flexWeights));
  }
}

class _CarouselViewState extends State<CarouselView> {
  double? _itemExtent;
  List<int>? get _flexWeights => widget.flexWeights;
  bool get _consumeMaxWeight => widget.consumeMaxWeight;
  CarouselController? _internalController;
  CarouselController get _controller => widget.controller ?? _internalController!;

  @override
  void initState() {
    super.initState();
    _itemExtent = widget.itemExtent;
    if (widget.controller == null) {
      _internalController = CarouselController();
    }
    _controller._attach(this);
  }

  @override
  void didUpdateWidget(covariant CarouselView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?._detach(this);
      if (widget.controller != null) {
        _internalController?._detach(this);
        _internalController = null;
        widget.controller?._attach(this);
      } else {
        // widget.controller == null && oldWidget.controller != null
        assert(_internalController == null);
        _internalController = CarouselController();
        _controller._attach(this);
      }
    }
    if (widget.flexWeights != oldWidget.flexWeights) {
      (_controller.position as _CarouselPosition).flexWeights = _flexWeights;
    }
    if (widget.itemExtent != oldWidget.itemExtent) {
      _itemExtent = widget.itemExtent;
      (_controller.position as _CarouselPosition).itemExtent = _itemExtent;
    }
    if (widget.consumeMaxWeight != oldWidget.consumeMaxWeight) {
      (_controller.position as _CarouselPosition).consumeMaxWeight = _consumeMaxWeight;
    }
  }

  @override
  void dispose() {
    _controller._detach(this);
    _internalController?.dispose();
    super.dispose();
  }

  AxisDirection _getDirection(BuildContext context) {
    switch (widget.scrollDirection) {
      case Axis.horizontal:
        assert(debugCheckHasDirectionality(context));
        final TextDirection textDirection = Directionality.of(context);
        final AxisDirection axisDirection = textDirectionToAxisDirection(textDirection);
        return widget.reverse ? flipAxisDirection(axisDirection) : axisDirection;
      case Axis.vertical:
        return widget.reverse ? AxisDirection.up : AxisDirection.down;
    }
  }

  Widget _buildCarouselItem(ThemeData theme, int index) {
    final EdgeInsets effectivePadding = widget.padding ?? const EdgeInsets.all(4.0);
    final Color effectiveBackgroundColor = widget.backgroundColor ?? Theme.of(context).colorScheme.surface;
    final double effectiveElevation = widget.elevation ?? 0.0;
    final ShapeBorder effectiveShape =
        widget.shape ?? const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(28.0)));
    final WidgetStateProperty<Color?> effectiveOverlayColor =
        widget.overlayColor ??
        WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return theme.colorScheme.onSurface.withValues(alpha: 0.1);
          }
          if (states.contains(WidgetState.hovered)) {
            return theme.colorScheme.onSurface.withValues(alpha: 0.08);
          }
          if (states.contains(WidgetState.focused)) {
            return theme.colorScheme.onSurface.withValues(alpha: 0.1);
          }
          return null;
        });

    Widget contents = widget.children[index];
    if (widget.enableSplash) {
      contents = Stack(
        fit: StackFit.expand,
        children: <Widget>[
          contents,
          Material(
            color: Colors.transparent,
            child: InkWell(onTap: () => widget.onTap?.call(index), overlayColor: effectiveOverlayColor),
          ),
        ],
      );
    } else if (widget.onTap != null) {
      contents = GestureDetector(onTap: () => widget.onTap!(index), child: contents);
    }

    return Padding(
      padding: effectivePadding,
      child: Material(
        clipBehavior: Clip.antiAlias,
        color: effectiveBackgroundColor,
        elevation: effectiveElevation,
        shape: effectiveShape,
        child: contents,
      ),
    );
  }

  Widget _buildSliverCarousel(ThemeData theme) {
    if (_itemExtent != null) {
      return _SliverFixedExtentCarousel(
        itemExtent: _itemExtent!,
        minExtent: widget.shrinkExtent,
        delegate: SliverChildBuilderDelegate(
          (context, index) => _buildCarouselItem(theme, index),
          childCount: widget.children.length,
        ),
      );
    }

    assert(
      _flexWeights != null && _flexWeights!.every((weight) => weight > 0),
      'flexWeights is null or it contains non-positive integers',
    );
    return _SliverWeightedCarousel(
      consumeMaxWeight: _consumeMaxWeight,
      shrinkExtent: widget.shrinkExtent,
      weights: _flexWeights!,
      delegate: SliverChildBuilderDelegate(
        (context, index) => _buildCarouselItem(theme, index),
        childCount: widget.children.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AxisDirection axisDirection = _getDirection(context);
    final ScrollPhysics physics =
        widget.itemSnapping ? const CarouselScrollPhysics() : ScrollConfiguration.of(context).getScrollPhysics(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final double mainAxisExtent = switch (widget.scrollDirection) {
          Axis.horizontal => constraints.maxWidth,
          Axis.vertical => constraints.maxHeight,
        };
        _itemExtent = _itemExtent == null ? _itemExtent : clampDouble(_itemExtent!, 0, mainAxisExtent);

        return Scrollable(
          axisDirection: axisDirection,
          controller: _controller,
          physics: physics,
          viewportBuilder:
              (context, position) => Viewport(
                cacheExtent: 0.0,
                cacheExtentStyle: CacheExtentStyle.viewport,
                axisDirection: axisDirection,
                offset: position,
                clipBehavior: Clip.antiAlias,
                slivers: <Widget>[_buildSliverCarousel(theme)],
              ),
        );
      },
    );
  }
}

class _SliverFixedExtentCarousel extends SliverMultiBoxAdaptorWidget {
  const _SliverFixedExtentCarousel({required super.delegate, required this.minExtent, required this.itemExtent});

  final double itemExtent;
  final double minExtent;

  @override
  RenderSliverFixedExtentBoxAdaptor createRenderObject(BuildContext context) {
    final SliverMultiBoxAdaptorElement element = context as SliverMultiBoxAdaptorElement;
    return _RenderSliverFixedExtentCarousel(childManager: element, minExtent: minExtent, maxExtent: itemExtent);
  }

  @override
  void updateRenderObject(BuildContext context, _RenderSliverFixedExtentCarousel renderObject) {
    renderObject.maxExtent = itemExtent;
    renderObject.minExtent = minExtent;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('itemExtent', itemExtent));
    properties.add(DoubleProperty('minExtent', minExtent));
  }
}

class _RenderSliverFixedExtentCarousel extends RenderSliverFixedExtentBoxAdaptor {
  _RenderSliverFixedExtentCarousel({required super.childManager, required double maxExtent, required double minExtent})
    : _maxExtent = maxExtent,
      _minExtent = minExtent;

  double get maxExtent => _maxExtent;
  double _maxExtent;
  set maxExtent(double value) {
    if (_maxExtent == value) {
      return;
    }
    _maxExtent = value;
    markNeedsLayout();
  }

  double get minExtent => _minExtent;
  double _minExtent;
  set minExtent(double value) {
    if (_minExtent == value) {
      return;
    }
    _minExtent = value;
    markNeedsLayout();
  }

  // This implements the [itemExtentBuilder] callback.
  double _buildItemExtent(int index, SliverLayoutDimensions currentLayoutDimensions) {
    final int firstVisibleIndex = (constraints.scrollOffset / maxExtent).floor();

    // Calculate how many items have been completely scroll off screen.
    final int offscreenItems = (constraints.scrollOffset / maxExtent).floor();

    // If an item is partially off screen and partially on screen,
    // `constraints.scrollOffset` must be greater than
    // `offscreenItems * maxExtent`, so the difference between these two is how
    // much the current first visible item is off screen.
    final double offscreenExtent = constraints.scrollOffset - offscreenItems * maxExtent;

    // If there is not enough space to place the last visible item but the remaining
    // space is larger than `minExtent`, the extent for last item should be at
    // least the remaining extent to ensure a smooth size transition.
    final double effectiveMinExtent = math.max(constraints.remainingPaintExtent % maxExtent, minExtent);

    // Two special cases are the first and last visible items. Other items' extent
    // should all return `maxExtent`.
    if (index == firstVisibleIndex) {
      final double effectiveExtent = maxExtent - offscreenExtent;
      return math.max(effectiveExtent, effectiveMinExtent);
    }

    final double scrollOffsetForLastIndex = constraints.scrollOffset + constraints.remainingPaintExtent;
    if (index == getMaxChildIndexForScrollOffset(scrollOffsetForLastIndex, maxExtent)) {
      return clampDouble(scrollOffsetForLastIndex - maxExtent * index, effectiveMinExtent, maxExtent);
    }

    return maxExtent;
  }

  late SliverLayoutDimensions _currentLayoutDimensions;

  @override
  void performLayout() {
    _currentLayoutDimensions = SliverLayoutDimensions(
      scrollOffset: constraints.scrollOffset,
      precedingScrollExtent: constraints.precedingScrollExtent,
      viewportMainAxisExtent: constraints.viewportMainAxisExtent,
      crossAxisExtent: constraints.crossAxisExtent,
    );
    super.performLayout();
  }

  @override
  double indexToLayoutOffset(
    @Deprecated(
      'The itemExtent is already available within the scope of this function. '
      'This feature was deprecated after v3.20.0-7.0.pre.',
    )
    double itemExtent,
    int index,
  ) {
    final int firstVisibleIndex = (constraints.scrollOffset / maxExtent).floor();

    // If there is not enough space to place the last visible item but the remaining
    // space is larger than `minExtent`, the extent for last item should be at
    // least the remaining extent to make sure a smooth size transition.
    final double effectiveMinExtent = math.max(constraints.remainingPaintExtent % maxExtent, minExtent);
    if (index == firstVisibleIndex) {
      final double firstVisibleItemExtent = _buildItemExtent(index, _currentLayoutDimensions);

      // If the first item is collapsed to be less than `effectiveMinExtent`,
      // then it should stop changing its size and should start to scroll off screen.
      if (firstVisibleItemExtent <= effectiveMinExtent) {
        return maxExtent * index - effectiveMinExtent + maxExtent;
      }
      return constraints.scrollOffset;
    }
    return maxExtent * index;
  }

  @override
  int getMinChildIndexForScrollOffset(
    double scrollOffset,
    @Deprecated(
      'The itemExtent is already available within the scope of this function. '
      'This feature was deprecated after v3.20.0-7.0.pre.',
    )
    double itemExtent,
  ) {
    final int firstVisibleIndex = (constraints.scrollOffset / maxExtent).floor();
    return math.max(firstVisibleIndex, 0);
  }

  @override
  int getMaxChildIndexForScrollOffset(
    double scrollOffset,
    @Deprecated(
      'The itemExtent is already available within the scope of this function. '
      'This feature was deprecated after v3.20.0-7.0.pre.',
    )
    double itemExtent,
  ) {
    if (maxExtent > 0.0) {
      final double actual = scrollOffset / maxExtent - 1;
      final int round = actual.round();
      if ((actual * maxExtent - round * maxExtent).abs() < precisionErrorTolerance) {
        return math.max(0, round);
      }
      return math.max(0, actual.ceil());
    }
    return 0;
  }

  @override
  double? get itemExtent => null;

  @override
  ItemExtentBuilder? get itemExtentBuilder => _buildItemExtent;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('maxExtent', maxExtent));
    properties.add(DoubleProperty('minExtent', minExtent));
  }
}

class _SliverWeightedCarousel extends SliverMultiBoxAdaptorWidget {
  const _SliverWeightedCarousel({
    required super.delegate,
    required this.consumeMaxWeight,
    required this.shrinkExtent,
    required this.weights,
  });

  // Determine whether extra scroll offset should be calculate so that every
  // item have a chance to scroll to the maximum extent.
  //
  // This is useful when the leading/trailing items have smaller weights, such
  // as [1, 7], and [3, 2, 1].
  final bool consumeMaxWeight;

  // The starting extent for items when they gradually show on/off screen.
  //
  // This is useful to avoid a hairline shape. This value should also smaller
  // than the last item extent to make sure a smooth transition. So in calculation,
  // this is limited to [0, weight for the last visible item].
  final double shrinkExtent;

  // The layout arrangement.
  //
  // When items are laying out, each item will be arranged based on the order of
  // the weights and the extent is based on the corresponding weight out of the
  // sum of weights. The length of weights means how many items we can put in the
  // view at a time.
  final List<int> weights;

  @override
  RenderSliverFixedExtentBoxAdaptor createRenderObject(BuildContext context) {
    final SliverMultiBoxAdaptorElement element = context as SliverMultiBoxAdaptorElement;
    return _RenderSliverWeightedCarousel(
      childManager: element,
      consumeMaxWeight: consumeMaxWeight,
      shrinkExtent: shrinkExtent,
      weights: weights,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderSliverWeightedCarousel renderObject) {
    renderObject
      ..consumeMaxWeight = consumeMaxWeight
      ..shrinkExtent = shrinkExtent
      ..weights = weights;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('consumeMaxWeight', consumeMaxWeight));
    properties.add(DoubleProperty('shrinkExtent', shrinkExtent));
    properties.add(IterableProperty<int>('weights', weights));
  }
}

// A sliver that places its box children in a linear array and constrains them
// to have the corresponding weight which is determined by [weights].
class _RenderSliverWeightedCarousel extends RenderSliverFixedExtentBoxAdaptor {
  _RenderSliverWeightedCarousel({
    required super.childManager,
    required bool consumeMaxWeight,
    required double shrinkExtent,
    required List<int> weights,
  }) : _consumeMaxWeight = consumeMaxWeight,
       _shrinkExtent = shrinkExtent,
       _weights = weights;

  bool get consumeMaxWeight => _consumeMaxWeight;
  bool _consumeMaxWeight;
  set consumeMaxWeight(bool value) {
    if (_consumeMaxWeight == value) {
      return;
    }
    _consumeMaxWeight = value;
    markNeedsLayout();
  }

  double get shrinkExtent => _shrinkExtent;
  double _shrinkExtent;
  set shrinkExtent(double value) {
    if (_shrinkExtent == value) {
      return;
    }
    _shrinkExtent = value;
    markNeedsLayout();
  }

  List<int> get weights => _weights;
  List<int> _weights;
  set weights(List<int> value) {
    if (_weights == value) {
      return;
    }
    _weights = value;
    markNeedsLayout();
  }

  late SliverLayoutDimensions _currentLayoutDimensions;

  // This is to implement the itemExtentBuilder callback to return each item extent
  // while scrolling.
  //
  // The given `index` is compared with `_firstVisibleItemIndex` to know how
  // many items are placed before the current one in the view.
  double _buildItemExtent(int index, SliverLayoutDimensions currentLayoutDimensions) {
    double extent;
    if (index == _firstVisibleItemIndex) {
      extent = math.max(_distanceToLeadingEdge, effectiveShrinkExtent);
    }
    // Calculate the extents of items located within the range defined by the
    // weights array relative to the first visible item. This allows us to
    // precisely determine each item's extent based on its initial extent
    // (calculated from the weights) and the scrolling progress (the off-screen
    // portion of the first item).
    else if (index > _firstVisibleItemIndex && index - _firstVisibleItemIndex + 1 <= weights.length) {
      assert(index - _firstVisibleItemIndex < weights.length);
      final int currIndexOnWeightList = index - _firstVisibleItemIndex;
      final int currWeight = weights[currIndexOnWeightList];
      extent = extentUnit * currWeight; // initial extent
      final double progress = _firstVisibleItemOffscreenExtent / firstChildExtent;

      final int prevWeight = weights[currIndexOnWeightList - 1];
      final double finalIncrease = (prevWeight - currWeight) / weights.max;
      extent = extent + finalIncrease * progress * maxChildExtent;
    }
    // Calculate the extents of items located beyond the range defined by the
    // weights array relative to the first visible item. During scrolling transition,
    // it is possible that the number of visible items is larger than the length
    // of `weights`. The extra item extent should be calculated here to fill
    // the remaining space.
    else if (index > _firstVisibleItemIndex && index - _firstVisibleItemIndex + 1 > weights.length) {
      double visibleItemsTotalExtent = _distanceToLeadingEdge;
      for (int i = _firstVisibleItemIndex + 1; i < index; i++) {
        visibleItemsTotalExtent += _buildItemExtent(i, currentLayoutDimensions);
      }
      extent = math.max(constraints.remainingPaintExtent - visibleItemsTotalExtent, effectiveShrinkExtent);
    } else {
      extent = math.max(minChildExtent, effectiveShrinkExtent);
    }
    return extent;
  }

  // To ge the extent unit based on the viewport extent and the sum of weights.
  double get extentUnit => constraints.viewportMainAxisExtent / (weights.reduce((total, extent) => total + extent));

  double get firstChildExtent => weights.first * extentUnit;
  double get maxChildExtent => weights.max * extentUnit;
  double get minChildExtent => weights.min * extentUnit;

  // The shrink extent for first and last visible items should be no larger
  // than [minChildExtent] to ensure a smooth transition.
  double get effectiveShrinkExtent => clampDouble(shrinkExtent, 0, minChildExtent);

  // The index of the first visible item. The returned value can be negative when
  // the leading items with smaller weights need to be fully expanded. For example,
  // assuming a weights [1, 7, 1], when item 0 is expanding to the maximum size
  // (with weight 7), we leave some space before item 0 assuming there is another
  // item -1 as the first visible item.
  int get _firstVisibleItemIndex {
    int smallerWeightCount = 0;
    for (final int weight in weights) {
      if (weight == weights.max) {
        break;
      }
      smallerWeightCount += 1;
    }
    int index;

    final double actual = constraints.scrollOffset / firstChildExtent;
    final int round = (constraints.scrollOffset / firstChildExtent).round();
    if ((actual - round).abs() < precisionErrorTolerance) {
      index = round;
    } else {
      index = actual.floor();
    }
    return consumeMaxWeight ? index - smallerWeightCount : index;
  }

  // This value indicates the scrolling progress of items following the first
  // item. It informs them how much the first item has moved off-screen,
  // enabling them to adjust their sizes (grow or shrink) accordingly.
  double get _firstVisibleItemOffscreenExtent {
    int index;
    final double actual = constraints.scrollOffset / firstChildExtent;
    final int round = (constraints.scrollOffset / firstChildExtent).round();
    if ((actual - round).abs() < precisionErrorTolerance) {
      index = round;
    } else {
      index = actual.floor();
    }
    return constraints.scrollOffset - index * firstChildExtent;
  }

  // Given the off-screen extent for the first visible item, we can know the
  // on-screen extent for the first visible item.
  double get _distanceToLeadingEdge => firstChildExtent - _firstVisibleItemOffscreenExtent;

  // Given an index, this method returns the layout offset for the item. The `index`
  // is firstly compared to `_firstVisibleItemIndex` and compute the distance
  // between them, then compute all the current extents for items that are located
  // in front.
  @override
  double indexToLayoutOffset(
    @Deprecated(
      'The itemExtent is already available within the scope of this function. '
      'This feature was deprecated after v3.20.0-7.0.pre.',
    )
    double itemExtent,
    int index,
  ) {
    if (index == _firstVisibleItemIndex) {
      if (_distanceToLeadingEdge <= effectiveShrinkExtent) {
        return constraints.scrollOffset - effectiveShrinkExtent + _distanceToLeadingEdge;
      }
      return constraints.scrollOffset;
    }
    double visibleItemsTotalExtent = _distanceToLeadingEdge;
    for (int i = _firstVisibleItemIndex + 1; i < index; i++) {
      visibleItemsTotalExtent += _buildItemExtent(i, _currentLayoutDimensions);
    }
    return constraints.scrollOffset + visibleItemsTotalExtent;
  }

  @override
  int getMinChildIndexForScrollOffset(
    double scrollOffset,
    @Deprecated(
      'The itemExtent is already available within the scope of this function. '
      'This feature was deprecated after v3.20.0-7.0.pre.',
    )
    double itemExtent,
  ) => math.max(_firstVisibleItemIndex, 0);

  @override
  int getMaxChildIndexForScrollOffset(
    double scrollOffset,
    @Deprecated(
      'The itemExtent is already available within the scope of this function. '
      'This feature was deprecated after v3.20.0-7.0.pre.',
    )
    double itemExtent,
  ) {
    final int? childCount = childManager.estimatedChildCount;
    if (childCount != null) {
      double visibleItemsTotalExtent = _distanceToLeadingEdge;
      for (int i = _firstVisibleItemIndex + 1; i < childCount; i++) {
        visibleItemsTotalExtent += _buildItemExtent(i, _currentLayoutDimensions);
        if (visibleItemsTotalExtent >= constraints.viewportMainAxisExtent) {
          return i;
        }
      }
    }
    return childCount ?? 0;
  }

  @override
  double computeMaxScrollOffset(
    SliverConstraints constraints,
    @Deprecated(
      'The itemExtent is already available within the scope of this function. '
      'This feature was deprecated after v3.20.0-7.0.pre.',
    )
    double itemExtent,
  ) => childManager.childCount * maxChildExtent;

  BoxConstraints _getChildConstraints(int index) {
    final double extent = itemExtentBuilder!(index, _currentLayoutDimensions)!;
    return constraints.asBoxConstraints(minExtent: extent, maxExtent: extent);
  }

  // This method is mostly the same as its parent class [RenderSliverFixedExtentList].
  // The difference is when we allow some space before the leading items or after
  // the trailing items with smaller weights, we leave extra scroll offset.
  // TODO(quncCccccc): add the calculation for the extra scroll offset on the super class to simplify the implementation here.
  @override
  void performLayout() {
    assert((itemExtent != null && itemExtentBuilder == null) || (itemExtent == null && itemExtentBuilder != null));
    assert(itemExtentBuilder != null || (itemExtent!.isFinite && itemExtent! >= 0));

    final SliverConstraints constraints = this.constraints;
    childManager.didStartLayout();
    childManager.setDidUnderflow(false);

    final double scrollOffset = constraints.scrollOffset + constraints.cacheOrigin;
    assert(scrollOffset >= 0.0);
    final double remainingExtent = constraints.remainingCacheExtent;
    assert(remainingExtent >= 0.0);
    final double targetEndScrollOffset = scrollOffset + remainingExtent;
    _currentLayoutDimensions = SliverLayoutDimensions(
      scrollOffset: constraints.scrollOffset,
      precedingScrollExtent: constraints.precedingScrollExtent,
      viewportMainAxisExtent: constraints.viewportMainAxisExtent,
      crossAxisExtent: constraints.crossAxisExtent,
    );
    // TODO(Piinks): Clean up when deprecation expires.
    const double deprecatedExtraItemExtent = -1;

    final int firstIndex = getMinChildIndexForScrollOffset(scrollOffset, deprecatedExtraItemExtent);
    final int? targetLastIndex =
        targetEndScrollOffset.isFinite
            ? getMaxChildIndexForScrollOffset(targetEndScrollOffset, deprecatedExtraItemExtent)
            : null;

    if (firstChild != null) {
      final int leadingGarbage = calculateLeadingGarbage(firstIndex: firstIndex);
      final int trailingGarbage = targetLastIndex != null ? calculateTrailingGarbage(lastIndex: targetLastIndex) : 0;
      collectGarbage(leadingGarbage, trailingGarbage);
    } else {
      collectGarbage(0, 0);
    }

    if (firstChild == null) {
      final double layoutOffset = indexToLayoutOffset(deprecatedExtraItemExtent, firstIndex);
      if (!addInitialChild(index: firstIndex, layoutOffset: layoutOffset)) {
        // There are either no children, or we are past the end of all our children.
        final double max;
        if (firstIndex <= 0) {
          max = 0.0;
        } else {
          max = computeMaxScrollOffset(constraints, deprecatedExtraItemExtent);
        }
        geometry = SliverGeometry(scrollExtent: max, maxPaintExtent: max);
        childManager.didFinishLayout();
        return;
      }
    }

    RenderBox? trailingChildWithLayout;

    for (int index = indexOf(firstChild!) - 1; index >= firstIndex; --index) {
      final RenderBox? child = insertAndLayoutLeadingChild(_getChildConstraints(index));
      if (child == null) {
        // Items before the previously first child are no longer present.
        // Reset the scroll offset to offset all items prior and up to the
        // missing item. Let parent re-layout everything.
        geometry = SliverGeometry(scrollOffsetCorrection: indexToLayoutOffset(deprecatedExtraItemExtent, index));
        return;
      }
      final SliverMultiBoxAdaptorParentData childParentData = child.parentData! as SliverMultiBoxAdaptorParentData;
      childParentData.layoutOffset = indexToLayoutOffset(deprecatedExtraItemExtent, index);
      assert(childParentData.index == index);
      trailingChildWithLayout ??= child;
    }

    if (trailingChildWithLayout == null) {
      firstChild!.layout(_getChildConstraints(indexOf(firstChild!)));
      final SliverMultiBoxAdaptorParentData childParentData =
          firstChild!.parentData! as SliverMultiBoxAdaptorParentData;
      childParentData.layoutOffset = indexToLayoutOffset(deprecatedExtraItemExtent, firstIndex);
      trailingChildWithLayout = firstChild;
    }

    // From the last item to the firstly encountered max item
    double extraLayoutOffset = 0;
    if (consumeMaxWeight) {
      for (int i = weights.length - 1; i >= 0; i--) {
        if (weights[i] == weights.max) {
          break;
        }
        extraLayoutOffset += weights[i] * extentUnit;
      }
    }

    double estimatedMaxScrollOffset = double.infinity;
    // Layout visible items after the first visible item.
    for (
      int index = indexOf(trailingChildWithLayout!) + 1;
      targetLastIndex == null || index <= targetLastIndex;
      ++index
    ) {
      RenderBox? child = childAfter(trailingChildWithLayout!);
      if (child == null || indexOf(child) != index) {
        child = insertAndLayoutChild(_getChildConstraints(index), after: trailingChildWithLayout);
        if (child == null) {
          // We have run out of children.
          estimatedMaxScrollOffset = indexToLayoutOffset(deprecatedExtraItemExtent, index) + extraLayoutOffset;
          break;
        }
      } else {
        child.layout(_getChildConstraints(index));
      }
      trailingChildWithLayout = child;
      final SliverMultiBoxAdaptorParentData childParentData = child.parentData! as SliverMultiBoxAdaptorParentData;
      assert(childParentData.index == index);
      childParentData.layoutOffset = indexToLayoutOffset(deprecatedExtraItemExtent, childParentData.index!);
    }

    final int lastIndex = indexOf(lastChild!);
    final double leadingScrollOffset = indexToLayoutOffset(deprecatedExtraItemExtent, firstIndex);
    double trailingScrollOffset;

    if (lastIndex + 1 == childManager.childCount) {
      trailingScrollOffset = indexToLayoutOffset(deprecatedExtraItemExtent, lastIndex);

      trailingScrollOffset += math.max(
        weights.last * extentUnit,
        _buildItemExtent(lastIndex, _currentLayoutDimensions),
      );
      trailingScrollOffset += extraLayoutOffset;
    } else {
      trailingScrollOffset = indexToLayoutOffset(deprecatedExtraItemExtent, lastIndex + 1);
    }

    assert(debugAssertChildListIsNonEmptyAndContiguous());
    assert(indexOf(firstChild!) == firstIndex);
    assert(targetLastIndex == null || lastIndex <= targetLastIndex);

    estimatedMaxScrollOffset = math.min(
      estimatedMaxScrollOffset,
      estimateMaxScrollOffset(
        constraints,
        firstIndex: firstIndex,
        lastIndex: lastIndex,
        leadingScrollOffset: leadingScrollOffset,
        trailingScrollOffset: trailingScrollOffset,
      ),
    );

    final double paintExtent = calculatePaintOffset(
      constraints,
      from: consumeMaxWeight ? 0 : leadingScrollOffset,
      to: trailingScrollOffset,
    );

    final double cacheExtent = calculateCacheOffset(
      constraints,
      from: consumeMaxWeight ? 0 : leadingScrollOffset,
      to: trailingScrollOffset,
    );

    final double targetEndScrollOffsetForPaint = constraints.scrollOffset + constraints.remainingPaintExtent;
    final int? targetLastIndexForPaint =
        targetEndScrollOffsetForPaint.isFinite
            ? getMaxChildIndexForScrollOffset(targetEndScrollOffsetForPaint, deprecatedExtraItemExtent)
            : null;

    geometry = SliverGeometry(
      scrollExtent: estimatedMaxScrollOffset,
      paintExtent: paintExtent,
      cacheExtent: cacheExtent,
      maxPaintExtent: estimatedMaxScrollOffset,
      // Conservative to avoid flickering away the clip during scroll.
      hasVisualOverflow:
          (targetLastIndexForPaint != null && lastIndex >= targetLastIndexForPaint) || constraints.scrollOffset > 0.0,
    );

    // We may have started the layout while scrolled to the end, which would not
    // expose a new child.
    if (estimatedMaxScrollOffset == trailingScrollOffset) {
      childManager.setDidUnderflow(true);
    }
    childManager.didFinishLayout();
  }

  @override
  double? get itemExtent => null;

  @override
  ItemExtentBuilder? get itemExtentBuilder => _buildItemExtent;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('consumeMaxWeight', consumeMaxWeight));
    properties.add(DoubleProperty('shrinkExtent', shrinkExtent));
    properties.add(IterableProperty<int>('weights', weights));
    properties.add(DoubleProperty('extentUnit', extentUnit));
    properties.add(DoubleProperty('firstChildExtent', firstChildExtent));
    properties.add(DoubleProperty('maxChildExtent', maxChildExtent));
    properties.add(DoubleProperty('minChildExtent', minChildExtent));
    properties.add(DoubleProperty('effectiveShrinkExtent', effectiveShrinkExtent));
  }
}

class CarouselScrollPhysics extends ScrollPhysics {
  const CarouselScrollPhysics({super.parent});

  @override
  CarouselScrollPhysics applyTo(ScrollPhysics? ancestor) => CarouselScrollPhysics(parent: buildParent(ancestor));

  double _getTargetPixels(_CarouselPosition position, Tolerance tolerance, double velocity) {
    double fraction;

    if (position.itemExtent != null) {
      fraction = position.itemExtent! / position.viewportDimension;
    } else {
      assert(position.flexWeights != null);
      fraction = position.flexWeights!.first / position.flexWeights!.sum;
    }

    final double itemWidth = position.viewportDimension * fraction;

    final double actual = math.max(0.0, position.pixels) / itemWidth;
    final double round = actual.roundToDouble();
    double item;
    if ((actual - round).abs() < precisionErrorTolerance) {
      item = round;
    } else {
      item = actual;
    }
    if (velocity < -tolerance.velocity) {
      item -= 0.5;
    } else if (velocity > tolerance.velocity) {
      item += 0.5;
    }
    return item.roundToDouble() * itemWidth;
  }

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    assert(
      position is _CarouselPosition,
      'CarouselScrollPhysics can only be used with Scrollables that uses '
      'the CarouselController',
    );

    final _CarouselPosition metrics = position as _CarouselPosition;
    if ((velocity <= 0.0 && metrics.pixels <= metrics.minScrollExtent) ||
        (velocity >= 0.0 && metrics.pixels >= metrics.maxScrollExtent)) {
      return super.createBallisticSimulation(metrics, velocity);
    }

    final Tolerance tolerance = toleranceFor(metrics);
    final double target = _getTargetPixels(metrics, tolerance, velocity);
    if (target != metrics.pixels) {
      return ScrollSpringSimulation(spring, metrics.pixels, target, velocity, tolerance: tolerance);
    }
    return null;
  }

  @override
  bool get allowImplicitScrolling => true;
}

class _CarouselMetrics extends FixedScrollMetrics {
  _CarouselMetrics({
    required super.minScrollExtent,
    required super.maxScrollExtent,
    required super.pixels,
    required super.viewportDimension,
    required super.axisDirection,
    required super.devicePixelRatio,
    this.itemExtent,
    this.flexWeights,
    this.consumeMaxWeight,
  });

  final double? itemExtent;

  final List<int>? flexWeights;

  final bool? consumeMaxWeight;

  @override
  _CarouselMetrics copyWith({
    double? minScrollExtent,
    double? maxScrollExtent,
    double? pixels,
    double? viewportDimension,
    AxisDirection? axisDirection,
    double? itemExtent,
    List<int>? flexWeights,
    bool? consumeMaxWeight,
    double? devicePixelRatio,
  }) => _CarouselMetrics(
    minScrollExtent: minScrollExtent ?? (hasContentDimensions ? this.minScrollExtent : null),
    maxScrollExtent: maxScrollExtent ?? (hasContentDimensions ? this.maxScrollExtent : null),
    pixels: pixels ?? (hasPixels ? this.pixels : null),
    viewportDimension: viewportDimension ?? (hasViewportDimension ? this.viewportDimension : null),
    axisDirection: axisDirection ?? this.axisDirection,
    itemExtent: itemExtent ?? this.itemExtent,
    flexWeights: flexWeights ?? this.flexWeights,
    consumeMaxWeight: consumeMaxWeight ?? this.consumeMaxWeight,
    devicePixelRatio: devicePixelRatio ?? this.devicePixelRatio,
  );
}

class _CarouselPosition extends ScrollPositionWithSingleContext implements _CarouselMetrics {
  _CarouselPosition({
    required super.physics,
    required super.context,
    this.initialItem = 0,
    double? itemExtent,
    List<int>? flexWeights,
    bool consumeMaxWeight = true,
    super.oldPosition,
  }) : assert(flexWeights != null && itemExtent == null || flexWeights == null && itemExtent != null),
       _itemToShowOnStartup = initialItem.toDouble(),
       _consumeMaxWeight = consumeMaxWeight,
       super(initialPixels: null);

  int initialItem;
  final double _itemToShowOnStartup;
  // When the viewport has a zero-size, the item can not
  // be retrieved by `getItemFromPixels`, so we need to cache the item
  // for use when resizing the viewport to non-zero next time.
  double? _cachedItem;

  @override
  bool get consumeMaxWeight => _consumeMaxWeight;
  bool _consumeMaxWeight;
  set consumeMaxWeight(bool value) {
    if (_consumeMaxWeight == value) {
      return;
    }
    if (hasPixels && flexWeights != null) {
      final double leadingItem = updateLeadingItem(flexWeights, value);
      final double newPixel = getPixelsFromItem(leadingItem, flexWeights, itemExtent);
      forcePixels(newPixel);
    }
    _consumeMaxWeight = value;
  }

  @override
  double? get itemExtent => _itemExtent;
  double? _itemExtent;
  set itemExtent(double? value) {
    if (_itemExtent == value) {
      return;
    }
    if (hasPixels && _itemExtent != null) {
      final double leadingItem = getItemFromPixels(pixels, viewportDimension);
      final double newPixel = getPixelsFromItem(leadingItem, flexWeights, value);
      forcePixels(newPixel);
    }
    _itemExtent = value;
  }

  @override
  List<int>? get flexWeights => _flexWeights;
  List<int>? _flexWeights;
  set flexWeights(List<int>? value) {
    if (flexWeights == value) {
      return;
    }
    final List<int>? oldWeights = _flexWeights;
    if (hasPixels && oldWeights != null) {
      final double leadingItem = updateLeadingItem(value, consumeMaxWeight);
      final double newPixel = getPixelsFromItem(leadingItem, value, itemExtent);
      forcePixels(newPixel);
    }
    _flexWeights = value;
  }

  double updateLeadingItem(List<int>? newFlexWeights, bool newConsumeMaxWeight) {
    final double maxItem;
    if (hasPixels && flexWeights != null) {
      final double leadingItem = getItemFromPixels(pixels, viewportDimension);
      maxItem = consumeMaxWeight ? leadingItem : leadingItem + flexWeights!.indexOf(flexWeights!.max);
    } else {
      maxItem = _itemToShowOnStartup;
    }
    if (newFlexWeights != null && !newConsumeMaxWeight) {
      int smallerWeights = 0;
      for (final int weight in newFlexWeights) {
        if (weight == newFlexWeights.max) {
          break;
        }
        smallerWeights += 1;
      }
      return maxItem - smallerWeights;
    }
    return maxItem;
  }

  double getItemFromPixels(double pixels, double viewportDimension) {
    assert(viewportDimension > 0.0);
    double fraction;
    if (itemExtent != null) {
      fraction = itemExtent! / viewportDimension;
    } else {
      // If itemExtent is null, flexWeights cannot be null.
      assert(flexWeights != null);
      fraction = flexWeights!.first / flexWeights!.sum;
    }

    final double actual = math.max(0.0, pixels) / (viewportDimension * fraction);
    final double round = actual.roundToDouble();
    if ((actual - round).abs() < precisionErrorTolerance) {
      return round;
    }
    return actual;
  }

  double getPixelsFromItem(double item, List<int>? flexWeights, double? itemExtent) {
    double fraction;
    if (itemExtent != null) {
      fraction = itemExtent / viewportDimension;
    } else {
      // If itemExtent is null, flexWeights cannot be null.
      assert(flexWeights != null);
      fraction = flexWeights!.first / flexWeights.sum;
    }

    return item * viewportDimension * fraction;
  }

  @override
  bool applyViewportDimension(double viewportDimension) {
    final double? oldViewportDimensions = hasViewportDimension ? this.viewportDimension : null;
    if (viewportDimension == oldViewportDimensions) {
      return true;
    }
    final bool result = super.applyViewportDimension(viewportDimension);
    final double? oldPixels = hasPixels ? pixels : null;
    double item;
    if (oldPixels == null) {
      item = updateLeadingItem(flexWeights, consumeMaxWeight);
    } else if (oldViewportDimensions == 0.0) {
      // If resize from zero, we should use the _cachedItem to recover the state.
      item = _cachedItem!;
    } else {
      item = getItemFromPixels(oldPixels, oldViewportDimensions!);
    }
    final double newPixels = getPixelsFromItem(item, flexWeights, itemExtent);
    // If the viewportDimension is zero, cache the item
    // in case the viewport is resized to be non-zero.
    _cachedItem = (viewportDimension == 0.0) ? item : null;

    if (newPixels != oldPixels) {
      correctPixels(newPixels);
      return false;
    }
    return result;
  }

  @override
  _CarouselMetrics copyWith({
    double? minScrollExtent,
    double? maxScrollExtent,
    double? pixels,
    double? viewportDimension,
    AxisDirection? axisDirection,
    double? itemExtent,
    List<int>? flexWeights,
    bool? consumeMaxWeight,
    double? devicePixelRatio,
  }) => _CarouselMetrics(
    minScrollExtent: minScrollExtent ?? (hasContentDimensions ? this.minScrollExtent : null),
    maxScrollExtent: maxScrollExtent ?? (hasContentDimensions ? this.maxScrollExtent : null),
    pixels: pixels ?? (hasPixels ? this.pixels : null),
    viewportDimension: viewportDimension ?? (hasViewportDimension ? this.viewportDimension : null),
    axisDirection: axisDirection ?? this.axisDirection,
    itemExtent: itemExtent ?? this.itemExtent,
    flexWeights: flexWeights ?? this.flexWeights,
    consumeMaxWeight: consumeMaxWeight ?? this.consumeMaxWeight,
    devicePixelRatio: devicePixelRatio ?? this.devicePixelRatio,
  );
}

class CarouselController extends ScrollController {
  CarouselController({this.initialItem = 0});

  final int initialItem;

  _CarouselViewState? _carouselState;

  // ignore: use_setters_to_change_properties
  void _attach(_CarouselViewState anchor) {
    _carouselState = anchor;
  }

  void _detach(_CarouselViewState anchor) {
    if (_carouselState == anchor) {
      _carouselState = null;
    }
  }

  @override
  ScrollPosition createScrollPosition(ScrollPhysics physics, ScrollContext context, ScrollPosition? oldPosition) {
    assert(_carouselState != null);
    return _CarouselPosition(
      physics: physics,
      context: context,
      initialItem: initialItem,
      itemExtent: _carouselState!._itemExtent,
      consumeMaxWeight: _carouselState!._consumeMaxWeight,
      flexWeights: _carouselState!._flexWeights,
      oldPosition: oldPosition,
    );
  }

  @override
  void attach(ScrollPosition position) {
    super.attach(position);
    final _CarouselPosition carouselPosition = position as _CarouselPosition;
    carouselPosition.flexWeights = _carouselState!._flexWeights;
    carouselPosition.itemExtent = _carouselState!._itemExtent;
    carouselPosition.consumeMaxWeight = _carouselState!._consumeMaxWeight;
  }
}
