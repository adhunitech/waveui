// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/colors.dart';
import 'package:waveui/material/divider.dart';
import 'package:waveui/material/material.dart';
import 'package:waveui/material/theme.dart';

@immutable
abstract class MergeableMaterialItem {
  const MergeableMaterialItem(this.key);

  final LocalKey key;
}

class MaterialSlice extends MergeableMaterialItem {
  const MaterialSlice({required LocalKey key, required this.child, this.color}) : super(key);

  final Widget child;

  final Color? color;

  @override
  String toString() => 'MergeableSlice(key: $key, child: $child, color: $color)';
}

class MaterialGap extends MergeableMaterialItem {
  const MaterialGap({required LocalKey key, this.size = 16.0}) : super(key);

  final double size;

  @override
  String toString() => 'MaterialGap(key: $key, child: $size)';
}

class MergeableMaterial extends StatefulWidget {
  const MergeableMaterial({
    super.key,
    this.mainAxis = Axis.vertical,
    this.elevation = 2,
    this.hasDividers = false,
    this.children = const <MergeableMaterialItem>[],
    this.dividerColor,
  });

  final List<MergeableMaterialItem> children;

  final Axis mainAxis;

  final double elevation;

  final bool hasDividers;

  final Color? dividerColor;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<Axis>('mainAxis', mainAxis));
    properties.add(DoubleProperty('elevation', elevation));
    properties.add(IterableProperty<MergeableMaterialItem>('children', children));
    properties.add(DiagnosticsProperty<bool>('hasDividers', hasDividers));
    properties.add(ColorProperty('dividerColor', dividerColor));
  }

  @override
  State<MergeableMaterial> createState() => _MergeableWidgetState();
}

class _AnimationTuple {
  _AnimationTuple({
    required this.controller,
    required this.startAnimation,
    required this.endAnimation,
    required this.gapAnimation,
  }) {
    // TODO(polina-c): stop duplicating code across disposables
    // https://github.com/flutter/flutter/issues/137435
    if (kFlutterMemoryAllocationsEnabled) {
      FlutterMemoryAllocations.instance.dispatchObjectCreated(
        library: 'package:flutter/material.dart',
        className: '$_AnimationTuple',
        object: this,
      );
    }
  }

  final AnimationController controller;
  final CurvedAnimation startAnimation;
  final CurvedAnimation endAnimation;
  final CurvedAnimation gapAnimation;
  double gapStart = 0.0;

  @mustCallSuper
  void dispose() {
    if (kFlutterMemoryAllocationsEnabled) {
      FlutterMemoryAllocations.instance.dispatchObjectDisposed(object: this);
    }
    controller.dispose();
    startAnimation.dispose();
    endAnimation.dispose();
    gapAnimation.dispose();
  }
}

class _MergeableWidgetState extends State<MergeableMaterial> with TickerProviderStateMixin {
  late List<MergeableMaterialItem> _children;
  final Map<LocalKey, _AnimationTuple?> _animationTuples = <LocalKey, _AnimationTuple?>{};

  @override
  void initState() {
    super.initState();
    _children = List<MergeableMaterialItem>.of(widget.children);

    for (int i = 0; i < _children.length; i += 1) {
      final MergeableMaterialItem child = _children[i];
      if (child is MaterialGap) {
        _initGap(child);
        _animationTuples[child.key]!.controller.value = 1.0; // Gaps are initially full-sized.
      }
    }
    assert(_debugGapsAreValid(_children));
  }

  void _initGap(MaterialGap gap) {
    final AnimationController controller = AnimationController(duration: kThemeAnimationDuration, vsync: this);

    final CurvedAnimation startAnimation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
    final CurvedAnimation endAnimation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
    final CurvedAnimation gapAnimation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(_handleTick);

    _animationTuples[gap.key] = _AnimationTuple(
      controller: controller,
      startAnimation: startAnimation,
      endAnimation: endAnimation,
      gapAnimation: gapAnimation,
    );
  }

  @override
  void dispose() {
    for (final MergeableMaterialItem child in _children) {
      if (child is MaterialGap) {
        _animationTuples[child.key]!.dispose();
      }
    }
    super.dispose();
  }

  void _handleTick() {
    setState(() {
      // The animation's state is our build state, and it changed already.
    });
  }

  bool _debugHasConsecutiveGaps(List<MergeableMaterialItem> children) {
    for (int i = 0; i < widget.children.length - 1; i += 1) {
      if (widget.children[i] is MaterialGap && widget.children[i + 1] is MaterialGap) {
        return true;
      }
    }
    return false;
  }

  bool _debugGapsAreValid(List<MergeableMaterialItem> children) {
    // Check for consecutive gaps.
    if (_debugHasConsecutiveGaps(children)) {
      return false;
    }

    // First and last children must not be gaps.
    if (children.isNotEmpty) {
      if (children.first is MaterialGap || children.last is MaterialGap) {
        return false;
      }
    }

    return true;
  }

  void _insertChild(int index, MergeableMaterialItem child) {
    _children.insert(index, child);

    if (child is MaterialGap) {
      _initGap(child);
    }
  }

  void _removeChild(int index) {
    final MergeableMaterialItem child = _children.removeAt(index);

    if (child is MaterialGap) {
      _animationTuples[child.key]!.dispose();
      _animationTuples[child.key] = null;
    }
  }

  bool _isClosingGap(int index) {
    if (index < _children.length - 1 && _children[index] is MaterialGap) {
      return _animationTuples[_children[index].key]!.controller.status == AnimationStatus.reverse;
    }

    return false;
  }

  void _removeEmptyGaps() {
    for (int j = _children.length - 1; j >= 0; j -= 1) {
      if (_children[j] is MaterialGap && _animationTuples[_children[j].key]!.controller.isDismissed) {
        _removeChild(j);
      }
    }
  }

  @override
  void didUpdateWidget(MergeableMaterial oldWidget) {
    super.didUpdateWidget(oldWidget);

    final Set<LocalKey> oldKeys = oldWidget.children.map<LocalKey>((child) => child.key).toSet();
    final Set<LocalKey> newKeys = widget.children.map<LocalKey>((child) => child.key).toSet();
    final Set<LocalKey> newOnly = newKeys.difference(oldKeys);
    final Set<LocalKey> oldOnly = oldKeys.difference(newKeys);

    final List<MergeableMaterialItem> newChildren = widget.children;
    int i = 0;
    int j = 0;

    assert(_debugGapsAreValid(newChildren));

    _removeEmptyGaps();

    while (i < newChildren.length && j < _children.length) {
      if (newOnly.contains(newChildren[i].key) || oldOnly.contains(_children[j].key)) {
        final int startNew = i;
        final int startOld = j;

        // Skip new keys.
        while (newOnly.contains(newChildren[i].key)) {
          i += 1;
        }

        // Skip old keys.
        while (oldOnly.contains(_children[j].key) || _isClosingGap(j)) {
          j += 1;
        }

        final int newLength = i - startNew;
        final int oldLength = j - startOld;

        if (newLength > 0) {
          if (oldLength > 1 || oldLength == 1 && _children[startOld] is MaterialSlice) {
            if (newLength == 1 && newChildren[startNew] is MaterialGap) {
              // Shrink all gaps into the size of the new one.
              double gapSizeSum = 0.0;

              while (startOld < j) {
                final MergeableMaterialItem child = _children[startOld];
                if (child is MaterialGap) {
                  final MaterialGap gap = child;
                  gapSizeSum += gap.size;
                }

                _removeChild(startOld);
                j -= 1;
              }

              _insertChild(startOld, newChildren[startNew]);
              _animationTuples[newChildren[startNew].key]!
                ..gapStart = gapSizeSum
                ..controller.forward();

              j += 1;
            } else {
              // No animation if replaced items are more than one.
              for (int k = 0; k < oldLength; k += 1) {
                _removeChild(startOld);
              }
              for (int k = 0; k < newLength; k += 1) {
                _insertChild(startOld + k, newChildren[startNew + k]);
              }

              j += newLength - oldLength;
            }
          } else if (oldLength == 1) {
            if (newLength == 1 &&
                newChildren[startNew] is MaterialGap &&
                _children[startOld].key == newChildren[startNew].key) {
              _animationTuples[newChildren[startNew].key]!.controller.forward();
            } else {
              final double gapSize = _getGapSize(startOld);

              _removeChild(startOld);

              for (int k = 0; k < newLength; k += 1) {
                _insertChild(startOld + k, newChildren[startNew + k]);
              }

              j += newLength - 1;
              double gapSizeSum = 0.0;

              for (int k = startNew; k < i; k += 1) {
                final MergeableMaterialItem newChild = newChildren[k];
                if (newChild is MaterialGap) {
                  gapSizeSum += newChild.size;
                }
              }

              // All gaps get proportional sizes of the original gap and they will
              // animate to their actual size.
              for (int k = startNew; k < i; k += 1) {
                final MergeableMaterialItem newChild = newChildren[k];
                if (newChild is MaterialGap) {
                  _animationTuples[newChild.key]!.gapStart = gapSize * newChild.size / gapSizeSum;
                  _animationTuples[newChild.key]!.controller
                    ..value = 0.0
                    ..forward();
                }
              }
            }
          } else {
            // Grow gaps.
            for (int k = 0; k < newLength; k += 1) {
              final MergeableMaterialItem newChild = newChildren[startNew + k];

              _insertChild(startOld + k, newChild);

              if (newChild is MaterialGap) {
                _animationTuples[newChild.key]!.controller.forward();
              }
            }

            j += newLength;
          }
        } else {
          // If more than a gap disappeared, just remove slices and shrink gaps.
          if (oldLength > 1 || oldLength == 1 && _children[startOld] is MaterialSlice) {
            double gapSizeSum = 0.0;

            while (startOld < j) {
              final MergeableMaterialItem child = _children[startOld];
              if (child is MaterialGap) {
                gapSizeSum += child.size;
              }

              _removeChild(startOld);
              j -= 1;
            }

            if (gapSizeSum != 0.0) {
              final MaterialGap gap = MaterialGap(key: UniqueKey(), size: gapSizeSum);
              _insertChild(startOld, gap);
              _animationTuples[gap.key]!.gapStart = 0.0;
              _animationTuples[gap.key]!.controller
                ..value = 1.0
                ..reverse();

              j += 1;
            }
          } else if (oldLength == 1) {
            // Shrink gap.
            final MaterialGap gap = _children[startOld] as MaterialGap;
            _animationTuples[gap.key]!.gapStart = 0.0;
            _animationTuples[gap.key]!.controller.reverse();
          }
        }
      } else {
        // Check whether the items are the same type. If they are, it means that
        // their places have been swapped.
        if ((_children[j] is MaterialGap) == (newChildren[i] is MaterialGap)) {
          _children[j] = newChildren[i];

          i += 1;
          j += 1;
        } else {
          // This is a closing gap which we need to skip.
          assert(_children[j] is MaterialGap);
          j += 1;
        }
      }
    }

    // Handle remaining items.
    while (j < _children.length) {
      _removeChild(j);
    }
    while (i < newChildren.length) {
      final MergeableMaterialItem newChild = newChildren[i];
      _insertChild(j, newChild);

      if (newChild is MaterialGap) {
        _animationTuples[newChild.key]!.controller.forward();
      }

      i += 1;
      j += 1;
    }
  }

  BorderRadius _borderRadius(int index, bool start, bool end) {
    assert(kMaterialEdges[MaterialType.card]!.topLeft == kMaterialEdges[MaterialType.card]!.topRight);
    assert(kMaterialEdges[MaterialType.card]!.topLeft == kMaterialEdges[MaterialType.card]!.bottomLeft);
    assert(kMaterialEdges[MaterialType.card]!.topLeft == kMaterialEdges[MaterialType.card]!.bottomRight);
    final Radius cardRadius = kMaterialEdges[MaterialType.card]!.topLeft;

    Radius startRadius = Radius.zero;
    Radius endRadius = Radius.zero;

    if (index > 0 && _children[index - 1] is MaterialGap) {
      startRadius =
          Radius.lerp(Radius.zero, cardRadius, _animationTuples[_children[index - 1].key]!.startAnimation.value)!;
    }
    if (index < _children.length - 2 && _children[index + 1] is MaterialGap) {
      endRadius = Radius.lerp(Radius.zero, cardRadius, _animationTuples[_children[index + 1].key]!.endAnimation.value)!;
    }

    if (widget.mainAxis == Axis.vertical) {
      return BorderRadius.vertical(top: start ? cardRadius : startRadius, bottom: end ? cardRadius : endRadius);
    } else {
      return BorderRadius.horizontal(left: start ? cardRadius : startRadius, right: end ? cardRadius : endRadius);
    }
  }

  double _getGapSize(int index) {
    final MaterialGap gap = _children[index] as MaterialGap;

    return lerpDouble(_animationTuples[gap.key]!.gapStart, gap.size, _animationTuples[gap.key]!.gapAnimation.value)!;
  }

  bool _willNeedDivider(int index) {
    if (index < 0) {
      return false;
    }
    if (index >= _children.length) {
      return false;
    }
    return _children[index] is MaterialSlice || _isClosingGap(index);
  }

  @override
  Widget build(BuildContext context) {
    _removeEmptyGaps();

    final List<Widget> widgets = <Widget>[];
    List<Widget> slices = <Widget>[];
    int i;

    for (i = 0; i < _children.length; i += 1) {
      if (_children[i] is MaterialGap) {
        assert(slices.isNotEmpty);
        widgets.add(ListBody(mainAxis: widget.mainAxis, children: slices));
        slices = <Widget>[];

        widgets.add(switch (widget.mainAxis) {
          Axis.horizontal => SizedBox(width: _getGapSize(i)),
          Axis.vertical => SizedBox(height: _getGapSize(i)),
        });
      } else {
        final MaterialSlice slice = _children[i] as MaterialSlice;
        Widget child = slice.child;

        if (widget.hasDividers) {
          final bool hasTopDivider = _willNeedDivider(i - 1);
          final bool hasBottomDivider = _willNeedDivider(i + 1);

          final BorderSide divider = Divider.createBorderSide(
            context,
            width: 0.5, // TODO(ianh): This probably looks terrible when the dpr isn't a power of two.
            color: widget.dividerColor,
          );

          final Border border;
          if (i == 0) {
            border = Border(bottom: hasBottomDivider ? divider : BorderSide.none);
          } else if (i == _children.length - 1) {
            border = Border(top: hasTopDivider ? divider : BorderSide.none);
          } else {
            border = Border(
              top: hasTopDivider ? divider : BorderSide.none,
              bottom: hasBottomDivider ? divider : BorderSide.none,
            );
          }

          child = AnimatedContainer(
            key: _MergeableMaterialSliceKey(_children[i].key),
            decoration: BoxDecoration(border: border),
            duration: kThemeAnimationDuration,
            curve: Curves.fastOutSlowIn,
            child: child,
          );
        }

        slices.add(
          DecoratedBox(
            decoration: BoxDecoration(
              color: (_children[i] as MaterialSlice).color ?? Theme.of(context).cardColor,
              borderRadius: _borderRadius(i, i == 0, i == _children.length - 1),
            ),
            child: Material(type: MaterialType.transparency, child: child),
          ),
        );
      }
    }

    if (slices.isNotEmpty) {
      widgets.add(ListBody(mainAxis: widget.mainAxis, children: slices));
      slices = <Widget>[];
    }

    return _MergeableMaterialListBody(
      mainAxis: widget.mainAxis,
      elevation: widget.elevation,
      items: _children,
      children: widgets,
    );
  }
}

// The parent hierarchy can change and lead to the slice being
// rebuilt. Using a global key solves the issue.
class _MergeableMaterialSliceKey extends GlobalKey {
  const _MergeableMaterialSliceKey(this.value) : super.constructor();

  final LocalKey value;

  @override
  bool operator ==(Object other) => other is _MergeableMaterialSliceKey && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => '_MergeableMaterialSliceKey($value)';
}

class _MergeableMaterialListBody extends ListBody {
  const _MergeableMaterialListBody({
    required super.children,
    required this.items,
    required this.elevation,
    super.mainAxis,
  });

  final List<MergeableMaterialItem> items;
  final double elevation;

  AxisDirection _getDirection(BuildContext context) =>
      getAxisDirectionFromAxisReverseAndDirectionality(context, mainAxis, false);

  @override
  RenderListBody createRenderObject(BuildContext context) =>
      _RenderMergeableMaterialListBody(axisDirection: _getDirection(context), elevation: elevation);

  @override
  void updateRenderObject(BuildContext context, RenderListBody renderObject) {
    final _RenderMergeableMaterialListBody materialRenderListBody = renderObject as _RenderMergeableMaterialListBody;
    materialRenderListBody
      ..axisDirection = _getDirection(context)
      ..elevation = elevation;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<MergeableMaterialItem>('items', items));
    properties.add(DoubleProperty('elevation', elevation));
  }
}

class _RenderMergeableMaterialListBody extends RenderListBody {
  _RenderMergeableMaterialListBody({super.axisDirection, double elevation = 0.0}) : _elevation = elevation;

  double get elevation => _elevation;
  double _elevation;
  set elevation(double value) {
    if (value == _elevation) {
      return;
    }
    _elevation = value;
    markNeedsPaint();
  }

  void _paintShadows(Canvas canvas, Rect rect) {
    // TODO(ianh): We should interpolate the border radii of the shadows the same way we do those of the visible Material slices.
    if (elevation != 0) {
      canvas.drawShadow(
        Path()..addRRect(kMaterialEdges[MaterialType.card]!.toRRect(rect)),
        Colors.black,
        elevation,
        true, // occluding object is not (necessarily) opaque
      );
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    RenderBox? child = firstChild;
    int index = 0;
    while (child != null) {
      final ListBodyParentData childParentData = child.parentData! as ListBodyParentData;
      final Rect rect = (childParentData.offset + offset) & child.size;
      if (index.isEven) {
        _paintShadows(context.canvas, rect);
      }
      child = childParentData.nextSibling;
      index += 1;
    }
    defaultPaint(context, offset);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('elevation', elevation));
  }
}
