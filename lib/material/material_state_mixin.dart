// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

@optionalTypeArgs
mixin WidgetStateMixin<T extends StatefulWidget> on State<T> {
  @protected
  Set<WidgetState> WidgetStates = <WidgetState>{};

  @protected
  ValueChanged<bool> updateWidgetState(WidgetState key, {ValueChanged<bool>? onChanged}) => (value) {
    if (WidgetStates.contains(key) == value) {
      return;
    }
    setWidgetState(key, value);
    onChanged?.call(value);
  };

  @protected
  void setWidgetState(WidgetState state, bool isSet) => isSet ? addWidgetState(state) : removeWidgetState(state);

  @protected
  void addWidgetState(WidgetState state) {
    if (WidgetStates.add(state)) {
      setState(() {});
    }
  }

  @protected
  void removeWidgetState(WidgetState state) {
    if (WidgetStates.remove(state)) {
      setState(() {});
    }
  }

  bool get isDisabled => WidgetStates.contains(WidgetState.disabled);

  bool get isDragged => WidgetStates.contains(WidgetState.dragged);

  bool get isErrored => WidgetStates.contains(WidgetState.error);

  bool get isFocused => WidgetStates.contains(WidgetState.focused);

  bool get isHovered => WidgetStates.contains(WidgetState.hovered);

  bool get isPressed => WidgetStates.contains(WidgetState.pressed);

  bool get isScrolledUnder => WidgetStates.contains(WidgetState.scrolledUnder);

  bool get isSelected => WidgetStates.contains(WidgetState.selected);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Set<WidgetState>>('WidgetStates', WidgetStates, defaultValue: <WidgetState>{}));
  }
}
