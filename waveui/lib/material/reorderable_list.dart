// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/debug.dart';
import 'package:waveui/material/icons.dart';
import 'package:waveui/material/material.dart';
import 'package:waveui/material/theme.dart';

class ReorderableListView extends StatefulWidget {
  ReorderableListView({
    required List<Widget> children,
    required this.onReorder,
    super.key,
    this.onReorderStart,
    this.onReorderEnd,
    this.itemExtent,
    this.itemExtentBuilder,
    this.prototypeItem,
    this.proxyDecorator,
    this.buildDefaultDragHandles = true,
    this.padding,
    this.header,
    this.footer,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.scrollController,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.anchor = 0.0,
    this.cacheExtent,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.autoScrollerVelocityScalar,
    this.dragBoundaryProvider,
    this.mouseCursor,
  }) : assert(
         (itemExtent == null && prototypeItem == null) ||
             (itemExtent == null && itemExtentBuilder == null) ||
             (prototypeItem == null && itemExtentBuilder == null),
         'You can only pass one of itemExtent, prototypeItem and itemExtentBuilder.',
       ),
       assert(children.every((w) => w.key != null), 'All children of this widget must have a key.'),
       itemBuilder = ((context, index) => children[index]),
       itemCount = children.length;

  const ReorderableListView.builder({
    required this.itemBuilder,
    required this.itemCount,
    required this.onReorder,
    super.key,
    this.onReorderStart,
    this.onReorderEnd,
    this.itemExtent,
    this.itemExtentBuilder,
    this.prototypeItem,
    this.proxyDecorator,
    this.buildDefaultDragHandles = true,
    this.padding,
    this.header,
    this.footer,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.scrollController,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.anchor = 0.0,
    this.cacheExtent,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.autoScrollerVelocityScalar,
    this.dragBoundaryProvider,
    this.mouseCursor,
  }) : assert(itemCount >= 0),
       assert(
         (itemExtent == null && prototypeItem == null) ||
             (itemExtent == null && itemExtentBuilder == null) ||
             (prototypeItem == null && itemExtentBuilder == null),
         'You can only pass one of itemExtent, prototypeItem and itemExtentBuilder.',
       );

  final IndexedWidgetBuilder itemBuilder;

  final int itemCount;

  final ReorderCallback onReorder;

  final void Function(int index)? onReorderStart;

  final void Function(int index)? onReorderEnd;

  final ReorderItemProxyDecorator? proxyDecorator;

  final bool buildDefaultDragHandles;

  final EdgeInsets? padding;

  final Widget? header;

  final Widget? footer;

  final Axis scrollDirection;

  final bool reverse;

  final ScrollController? scrollController;

  final bool? primary;

  final ScrollPhysics? physics;

  final bool shrinkWrap;

  final double anchor;

  final double? cacheExtent;

  final DragStartBehavior dragStartBehavior;

  final ScrollViewKeyboardDismissBehavior? keyboardDismissBehavior;

  final String? restorationId;

  final Clip clipBehavior;

  final double? itemExtent;

  final ItemExtentBuilder? itemExtentBuilder;

  final Widget? prototypeItem;

  final double? autoScrollerVelocityScalar;

  final ReorderDragBoundaryProvider? dragBoundaryProvider;

  final MouseCursor? mouseCursor;

  @override
  State<ReorderableListView> createState() => _ReorderableListViewState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<IndexedWidgetBuilder>.has('itemBuilder', itemBuilder));
    properties.add(IntProperty('itemCount', itemCount));
    properties.add(ObjectFlagProperty<ReorderCallback>.has('onReorder', onReorder));
    properties.add(ObjectFlagProperty<void Function(int index)?>.has('onReorderStart', onReorderStart));
    properties.add(ObjectFlagProperty<void Function(int index)?>.has('onReorderEnd', onReorderEnd));
    properties.add(ObjectFlagProperty<ReorderItemProxyDecorator?>.has('proxyDecorator', proxyDecorator));
    properties.add(DiagnosticsProperty<bool>('buildDefaultDragHandles', buildDefaultDragHandles));
    properties.add(DiagnosticsProperty<EdgeInsets?>('padding', padding));
    properties.add(EnumProperty<Axis>('scrollDirection', scrollDirection));
    properties.add(DiagnosticsProperty<bool>('reverse', reverse));
    properties.add(DiagnosticsProperty<ScrollController?>('scrollController', scrollController));
    properties.add(DiagnosticsProperty<bool?>('primary', primary));
    properties.add(DiagnosticsProperty<ScrollPhysics?>('physics', physics));
    properties.add(DiagnosticsProperty<bool>('shrinkWrap', shrinkWrap));
    properties.add(DoubleProperty('anchor', anchor));
    properties.add(DoubleProperty('cacheExtent', cacheExtent));
    properties.add(EnumProperty<DragStartBehavior>('dragStartBehavior', dragStartBehavior));
    properties.add(
      EnumProperty<ScrollViewKeyboardDismissBehavior?>('keyboardDismissBehavior', keyboardDismissBehavior),
    );
    properties.add(StringProperty('restorationId', restorationId));
    properties.add(EnumProperty<Clip>('clipBehavior', clipBehavior));
    properties.add(DoubleProperty('itemExtent', itemExtent));
    properties.add(ObjectFlagProperty<ItemExtentBuilder?>.has('itemExtentBuilder', itemExtentBuilder));
    properties.add(DoubleProperty('autoScrollerVelocityScalar', autoScrollerVelocityScalar));
    properties.add(ObjectFlagProperty<ReorderDragBoundaryProvider?>.has('dragBoundaryProvider', dragBoundaryProvider));
    properties.add(DiagnosticsProperty<MouseCursor?>('mouseCursor', mouseCursor));
  }
}

class _ReorderableListViewState extends State<ReorderableListView> {
  final ValueNotifier<bool> _dragging = ValueNotifier<bool>(false);

  Widget _itemBuilder(BuildContext context, int index) {
    final Widget item = widget.itemBuilder(context, index);
    assert(() {
      if (item.key == null) {
        throw FlutterError('Every item of ReorderableListView must have a key.');
      }
      return true;
    }());

    final Key itemGlobalKey = _ReorderableListViewChildGlobalKey(item.key!, this);

    if (widget.buildDefaultDragHandles) {
      switch (Theme.of(context).platform) {
        case TargetPlatform.linux:
        case TargetPlatform.windows:
        case TargetPlatform.macOS:
          final ListenableBuilder dragHandle = ListenableBuilder(
            listenable: _dragging,
            builder: (context, child) {
              final MouseCursor effectiveMouseCursor = WidgetStateProperty.resolveAs<MouseCursor>(
                widget.mouseCursor ??
                    const WidgetStateMouseCursor.fromMap(<WidgetStatesConstraint, MouseCursor>{
                      WidgetState.dragged: SystemMouseCursors.grabbing,
                      WidgetState.any: SystemMouseCursors.grab,
                    }),
                <WidgetState>{if (_dragging.value) WidgetState.dragged},
              );
              return MouseRegion(cursor: effectiveMouseCursor, child: child);
            },
            child: const Icon(Icons.drag_handle),
          );
          switch (widget.scrollDirection) {
            case Axis.horizontal:
              return Stack(
                key: itemGlobalKey,
                children: <Widget>[
                  item,
                  Positioned.directional(
                    textDirection: Directionality.of(context),
                    start: 0,
                    end: 0,
                    bottom: 8,
                    child: Align(
                      alignment: AlignmentDirectional.bottomCenter,
                      child: ReorderableDragStartListener(index: index, child: dragHandle),
                    ),
                  ),
                ],
              );
            case Axis.vertical:
              return Stack(
                key: itemGlobalKey,
                children: <Widget>[
                  item,
                  Positioned.directional(
                    textDirection: Directionality.of(context),
                    top: 0,
                    bottom: 0,
                    end: 8,
                    child: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: ReorderableDragStartListener(index: index, child: dragHandle),
                    ),
                  ),
                ],
              );
          }

        case TargetPlatform.iOS:
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
          return ReorderableDelayedDragStartListener(key: itemGlobalKey, index: index, child: item);
      }
    }

    return KeyedSubtree(key: itemGlobalKey, child: item);
  }

  Widget _proxyDecorator(Widget child, int index, Animation<double> animation) => AnimatedBuilder(
    animation: animation,
    builder: (context, child) {
      final double animValue = Curves.easeInOut.transform(animation.value);
      final double elevation = lerpDouble(0, 6, animValue)!;
      return Material(elevation: elevation, child: child);
    },
    child: child,
  );

  @override
  void dispose() {
    _dragging.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    assert(debugCheckHasOverlay(context));

    // If there is a header or footer we can't just apply the padding to the list,
    // so we break it up into padding for the header, footer and padding for the list.
    final EdgeInsets padding = widget.padding ?? EdgeInsets.zero;
    double? start = widget.header == null ? null : 0.0;
    double? end = widget.footer == null ? null : 0.0;
    if (widget.reverse) {
      (start, end) = (end, start);
    }

    final EdgeInsets startPadding;
    final EdgeInsets endPadding;
    final EdgeInsets listPadding;
    (startPadding, endPadding, listPadding) = switch (widget.scrollDirection) {
      Axis.horizontal || Axis.vertical when (start ?? end) == null => (EdgeInsets.zero, EdgeInsets.zero, padding),
      Axis.horizontal => (
        padding.copyWith(left: 0),
        padding.copyWith(right: 0),
        padding.copyWith(left: start, right: end),
      ),
      Axis.vertical => (
        padding.copyWith(top: 0),
        padding.copyWith(bottom: 0),
        padding.copyWith(top: start, bottom: end),
      ),
    };
    final (EdgeInsets headerPadding, EdgeInsets footerPadding) =
        widget.reverse ? (startPadding, endPadding) : (endPadding, startPadding);

    return CustomScrollView(
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverse,
      controller: widget.scrollController,
      primary: widget.primary,
      physics: widget.physics,
      shrinkWrap: widget.shrinkWrap,
      anchor: widget.anchor,
      cacheExtent: widget.cacheExtent,
      dragStartBehavior: widget.dragStartBehavior,
      keyboardDismissBehavior: widget.keyboardDismissBehavior,
      restorationId: widget.restorationId,
      clipBehavior: widget.clipBehavior,
      slivers: <Widget>[
        if (widget.header != null)
          SliverPadding(padding: headerPadding, sliver: SliverToBoxAdapter(child: widget.header)),
        SliverPadding(
          padding: listPadding,
          sliver: SliverReorderableList(
            itemBuilder: _itemBuilder,
            itemExtent: widget.itemExtent,
            itemExtentBuilder: widget.itemExtentBuilder,
            prototypeItem: widget.prototypeItem,
            itemCount: widget.itemCount,
            onReorder: widget.onReorder,
            onReorderStart: (index) {
              _dragging.value = true;
              widget.onReorderStart?.call(index);
            },
            onReorderEnd: (index) {
              _dragging.value = false;
              widget.onReorderEnd?.call(index);
            },
            proxyDecorator: widget.proxyDecorator ?? _proxyDecorator,
            autoScrollerVelocityScalar: widget.autoScrollerVelocityScalar,
            dragBoundaryProvider: widget.dragBoundaryProvider,
          ),
        ),
        if (widget.footer != null)
          SliverPadding(padding: footerPadding, sliver: SliverToBoxAdapter(child: widget.footer)),
      ],
    );
  }
}

// A global key that takes its identity from the object and uses a value of a
// particular type to identify itself.
//
// The difference with GlobalObjectKey is that it uses [==] instead of [identical]
// of the objects used to generate widgets.
@optionalTypeArgs
class _ReorderableListViewChildGlobalKey extends GlobalObjectKey {
  const _ReorderableListViewChildGlobalKey(this.subKey, this.state) : super(subKey);

  final Key subKey;
  final State state;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is _ReorderableListViewChildGlobalKey && other.subKey == subKey && other.state == state;
  }

  @override
  int get hashCode => Object.hash(subKey, state);
}
