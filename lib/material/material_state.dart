// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:flutter/widgets.dart';

import 'package:waveui/material/input_border.dart';

// Examples can assume:
// late BuildContext context;

@Deprecated(
  'Use WidgetState instead. '
  'Moved to the Widgets layer to make code available outside of Material. '
  'This feature was deprecated after v3.19.0-0.3.pre.',
)
typedef MaterialState = WidgetState;

@Deprecated(
  'Use WidgetPropertyResolver instead. '
  'Moved to the Widgets layer to make code available outside of Material. '
  'This feature was deprecated after v3.19.0-0.3.pre.',
)
typedef MaterialPropertyResolver<T> = WidgetPropertyResolver<T>;

@Deprecated(
  'Use WidgetStateColor instead. '
  'Moved to the Widgets layer to make code available outside of Material. '
  'This feature was deprecated after v3.19.0-0.3.pre.',
)
typedef MaterialStateColor = WidgetStateColor;

@Deprecated(
  'Use WidgetStateMouseCursor instead. '
  'Moved to the Widgets layer to make code available outside of Material. '
  'This feature was deprecated after v3.19.0-0.3.pre.',
)
typedef MaterialStateMouseCursor = WidgetStateMouseCursor;

@Deprecated(
  'Use WidgetStateBorderSide instead. '
  'Moved to the Widgets layer to make code available outside of Material. '
  'This feature was deprecated after v3.19.0-0.3.pre.',
)
typedef MaterialStateBorderSide = WidgetStateBorderSide;

@Deprecated(
  'Use WidgetStateOutlinedBorder instead. '
  'Moved to the Widgets layer to make code available outside of Material. '
  'This feature was deprecated after v3.19.0-0.3.pre.',
)
typedef MaterialStateOutlinedBorder = WidgetStateOutlinedBorder;

@Deprecated(
  'Use WidgetStateTextStyle instead. '
  'Moved to the Widgets layer to make code available outside of Material. '
  'This feature was deprecated after v3.19.0-0.3.pre.',
)
typedef MaterialStateTextStyle = WidgetStateTextStyle;

@Deprecated(
  'Use WidgetStateInputBorder instead. '
  'Renamed to match other WidgetStateProperty objects. '
  'This feature was deprecated after v3.26.0-0.1.pre.',
)
abstract class MaterialStateOutlineInputBorder extends OutlineInputBorder
    implements MaterialStateProperty<InputBorder> {
  @Deprecated(
    'Use WidgetStateInputBorder instead. '
    'Renamed to match other WidgetStateProperty objects. '
    'This feature was deprecated after v3.26.0-0.1.pre.',
  )
  const MaterialStateOutlineInputBorder();

  @Deprecated(
    'Use WidgetStateInputBorder.resolveWith() instead. '
    'Renamed to match other WidgetStateProperty objects. '
    'This feature was deprecated after v3.26.0-0.1.pre.',
  )
  const factory MaterialStateOutlineInputBorder.resolveWith(MaterialPropertyResolver<InputBorder> callback) =
      _MaterialStateOutlineInputBorder;

  @override
  InputBorder resolve(Set<MaterialState> states);
}

class _MaterialStateOutlineInputBorder extends MaterialStateOutlineInputBorder {
  const _MaterialStateOutlineInputBorder(this._resolve);

  final WidgetPropertyResolver<InputBorder> _resolve;

  @override
  InputBorder resolve(Set<WidgetState> states) => _resolve(states);
}

@Deprecated(
  'Use WidgetStateInputBorder instead. '
  'Renamed to match other WidgetStateProperty objects. '
  'This feature was deprecated after v3.26.0-0.1.pre.',
)
abstract class MaterialStateUnderlineInputBorder extends UnderlineInputBorder
    implements MaterialStateProperty<InputBorder> {
  @Deprecated(
    'Use WidgetStateInputBorder instead. '
    'Renamed to match other WidgetStateProperty objects. '
    'This feature was deprecated after v3.26.0-0.1.pre.',
  )
  const MaterialStateUnderlineInputBorder();

  @Deprecated(
    'Use WidgetStateInputBorder.resolveWith() instead. '
    'Renamed to match other WidgetStateProperty objects. '
    'This feature was deprecated after v3.26.0-0.1.pre.',
  )
  const factory MaterialStateUnderlineInputBorder.resolveWith(MaterialPropertyResolver<InputBorder> callback) =
      _MaterialStateUnderlineInputBorder;

  @override
  InputBorder resolve(Set<MaterialState> states);
}

class _MaterialStateUnderlineInputBorder extends MaterialStateUnderlineInputBorder {
  const _MaterialStateUnderlineInputBorder(this._resolve);

  final WidgetPropertyResolver<InputBorder> _resolve;

  @override
  InputBorder resolve(Set<WidgetState> states) => _resolve(states);
}

abstract interface class WidgetStateInputBorder implements InputBorder, WidgetStateProperty<InputBorder> {
  const factory WidgetStateInputBorder.resolveWith(WidgetPropertyResolver<InputBorder> callback) =
      _WidgetStateInputBorder;

  const factory WidgetStateInputBorder.fromMap(WidgetStateMap<InputBorder> map) = _WidgetInputBorderMapper;
}

class _WidgetStateInputBorder extends OutlineInputBorder implements WidgetStateInputBorder {
  const _WidgetStateInputBorder(this._resolve);

  final WidgetPropertyResolver<InputBorder> _resolve;

  @override
  InputBorder resolve(Set<WidgetState> states) => _resolve(states);
}

class _WidgetInputBorderMapper extends WidgetStateMapper<InputBorder> implements WidgetStateInputBorder {
  const _WidgetInputBorderMapper(super.map);
}

@Deprecated(
  'Use WidgetStateProperty instead. '
  'Moved to the Widgets layer to make code available outside of Material. '
  'This feature was deprecated after v3.19.0-0.3.pre.',
)
typedef MaterialStateProperty<T> = WidgetStateProperty<T>;

@Deprecated(
  'Use WidgetStatePropertyAll instead. '
  'Moved to the Widgets layer to make code available outside of Material. '
  'This feature was deprecated after v3.19.0-0.3.pre.',
)
typedef MaterialStatePropertyAll<T> = WidgetStatePropertyAll<T>;

@Deprecated(
  'Use WidgetStatesController instead. '
  'Moved to the Widgets layer to make code available outside of Material. '
  'This feature was deprecated after v3.19.0-0.3.pre.',
)
typedef MaterialStatesController = WidgetStatesController;
