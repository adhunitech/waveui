// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/ink_well.dart';
import 'package:waveui/material/material.dart';

class _NoSplashFactory extends InteractiveInkFeatureFactory {
  const _NoSplashFactory();

  @override
  InteractiveInkFeature create({
    required MaterialInkController controller,
    required RenderBox referenceBox,
    required Offset position,
    required Color color,
    required TextDirection textDirection,
    bool containedInkWell = false,
    RectCallback? rectCallback,
    BorderRadius? borderRadius,
    ShapeBorder? customBorder,
    double? radius,
    VoidCallback? onRemoved,
  }) => NoSplash(controller: controller, referenceBox: referenceBox, color: color, onRemoved: onRemoved);
}

class NoSplash extends InteractiveInkFeature {
  NoSplash({required super.controller, required super.referenceBox, required super.color, super.onRemoved});

  static const InteractiveInkFeatureFactory splashFactory = _NoSplashFactory();

  @override
  void paintFeature(Canvas canvas, Matrix4 transform) {}

  @override
  void confirm() {
    super.confirm();
    dispose();
  }

  @override
  void cancel() {
    super.cancel();
    dispose();
  }
}
