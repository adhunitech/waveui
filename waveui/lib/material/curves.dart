// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/animation.dart';

// The easing curves of the Material Library

@Deprecated(
  'Use Easing.legacy (M2) or Easing.standard (M3) instead. '
  'This curve is updated in M3. '
  'This feature was deprecated after v3.18.0-0.1.pre.',
)
const Curve standardEasing = Curves.fastOutSlowIn;

@Deprecated(
  'Use Easing.legacyAccelerate (M2) or Easing.standardAccelerate (M3) instead. '
  'This curve is updated in M3. '
  'This feature was deprecated after v3.18.0-0.1.pre.',
)
const Curve accelerateEasing = Cubic(0.4, 0.0, 1.0, 1.0);

@Deprecated(
  'Use Easing.legacyDecelerate (M2) or Easing.standardDecelerate (M3) instead. '
  'This curve is updated in M3. '
  'This feature was deprecated after v3.18.0-0.1.pre.',
)
const Curve decelerateEasing = Cubic(0.0, 0.0, 0.2, 1.0);
