// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// 三角形指示器 参考ShapeDecoration
class WaveTriangleIndicator extends Decoration {
  final Color? color; // 指示器颜色
  final double lineWidth;
  final double triWidth; // 三角形底边长
  final double triHeight; // 三角形高
  final Gradient? gradient;
  final DecorationImage? image;
  final List<BoxShadow>? shadows;
  final ShapeBorder? shape;

  const WaveTriangleIndicator({
    this.color = Colors.white,
    this.lineWidth = 1.0,
    this.triWidth = 15.0,
    this.triHeight = 10.0,
    this.image,
    this.gradient,
    this.shadows,
    this.shape,
  });

  factory WaveTriangleIndicator.fromBoxDecoration(BoxDecoration source) {
    ShapeBorder? shape;
    switch (source.shape) {
      case BoxShape.circle:
        if (source.border != null) {
          assert(source.border!.isUniform);
          shape = CircleBorder(side: source.border!.top);
        } else {
          shape = const CircleBorder();
        }
        break;
      case BoxShape.rectangle:
        if (source.borderRadius != null) {
          assert(source.border == null || source.border!.isUniform);
          shape = RoundedRectangleBorder(
            side: source.border?.top ?? BorderSide.none,
            borderRadius: source.borderRadius!,
          );
        } else {
          shape = source.border ?? const Border();
        }
        break;
    }

    return WaveTriangleIndicator(
      color: source.color,
      image: source.image,
      gradient: source.gradient,
      shadows: source.boxShadow,
      shape: shape,
    );
  }

  /// The inset space occupied by the [shape]'s border.
  ///
  /// This value may be misleading. See the discussion at [ShapeBorder.dimensions].
  @override
  EdgeInsets get padding => shape!.dimensions as EdgeInsets;

  @override
  bool get isComplex => shadows != null;

  @override
  WaveTriangleIndicator? lerpFrom(Decoration? a, double t) {
    if (a is BoxDecoration) {
      return WaveTriangleIndicator.lerp(
          WaveTriangleIndicator.fromBoxDecoration(a), this, t);
    } else if (a == null || a is WaveTriangleIndicator) {
      return WaveTriangleIndicator.lerp(a as WaveTriangleIndicator?, this, t);
    }
    return super.lerpFrom(a, t) as WaveTriangleIndicator?;
  }

  @override
  WaveTriangleIndicator? lerpTo(Decoration? b, double t) {
    if (b is BoxDecoration) {
      return WaveTriangleIndicator.lerp(
          this, WaveTriangleIndicator.fromBoxDecoration(b), t);
    } else if (b == null || b is WaveTriangleIndicator) {
      return WaveTriangleIndicator.lerp(this, b as WaveTriangleIndicator?, t);
    }
    return super.lerpTo(b, t) as WaveTriangleIndicator?;
  }

  static WaveTriangleIndicator? lerp(
      WaveTriangleIndicator? a, WaveTriangleIndicator? b, double t) {
    if (a == null && b == null) return null;
    if (a != null && b != null) {
      if (t == 0.0) return a;
      if (t == 1.0) return b;
    }
    return WaveTriangleIndicator(
      color: Color.lerp(a?.color, b?.color, t),
      gradient: Gradient.lerp(a?.gradient, b?.gradient, t),
      image: t < 0.5 ? a?.image : b?.image,
      shadows: BoxShadow.lerpList(a?.shadows, b?.shadows, t),
      shape: ShapeBorder.lerp(a?.shape, b?.shape, t),
    );
  }

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final WaveTriangleIndicator typedOther = other;
    return color == typedOther.color &&
        lineWidth == typedOther.lineWidth &&
        triWidth == typedOther.triWidth &&
        triHeight == typedOther.triHeight &&
        gradient == typedOther.gradient &&
        image == typedOther.image &&
        shadows == typedOther.shadows &&
        shape == typedOther.shape;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.defaultDiagnosticsTreeStyle = DiagnosticsTreeStyle.whitespace;
    properties
        .add(DiagnosticsProperty<Color>('color', color, defaultValue: null));
    properties.add(DiagnosticsProperty<Gradient>('gradient', gradient,
        defaultValue: null));
    properties.add(DiagnosticsProperty<DecorationImage>('image', image,
        defaultValue: null));
    properties.add(IterableProperty<BoxShadow>('shadows', shadows,
        defaultValue: null, style: DiagnosticsTreeStyle.whitespace));
    properties.add(DiagnosticsProperty<ShapeBorder>('shape', shape));
  }

  @override
  bool hitTest(Size size, Offset position, {TextDirection? textDirection}) {
    return shape!
        .getOuterPath(Offset.zero & size, textDirection: textDirection)
        .contains(position);
  }

  @override
  _TriangleDecorationPainter createBoxPainter([VoidCallback? onChanged]) {
    assert(onChanged != null || image == null);
    Path path = Path();
    Paint paint = Paint()..isAntiAlias = true;
    return _TriangleDecorationPainter(this, path, paint, onChanged);
  }
}

/// An object that paints a [WaveTriangleIndicator] into a canvas.
class _TriangleDecorationPainter extends BoxPainter {
  _TriangleDecorationPainter(
      this._decoration, this._path, this._paint, VoidCallback? onChanged)
      : super(onChanged);

  final WaveTriangleIndicator _decoration;

  final Paint _paint; //画笔
  final Path _path; //绘制路径

  void _paintTriangle(Canvas canvas, Offset offset, Rect rect,
      ImageConfiguration configuration) {
    final baseX = offset.dx + rect.width / 2;
    final width = _decoration.triWidth;
    final height = _decoration.triHeight;

    double vertexX = baseX;
    double vertexY = offset.dy + rect.height - height / 2;

    _path.moveTo(vertexX, vertexY);
    _path.lineTo(vertexX - width / 2, vertexY + height / 2);
    _path.lineTo(vertexX + width / 2, vertexY + height / 2);
    _path.close();

    _paint.color = _decoration.color!;
    _paint.strokeWidth = _decoration.lineWidth;

    canvas.drawPath(_path, _paint);
    _path.reset();
  }

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    final Rect rect = offset & configuration.size!;

    _paintTriangle(canvas, offset, rect, configuration);
  }
}
