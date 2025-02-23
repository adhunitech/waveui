// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:waveui/material/theme.dart' show ThemeData;
import 'package:waveui/material/theme_data.dart' show ThemeData;

import 'package:waveui/material/checkbox_theme.dart';
import 'package:waveui/material/color_scheme.dart';
import 'package:waveui/material/colors.dart';
import 'package:waveui/material/constants.dart';
import 'package:waveui/material/debug.dart';
import 'package:waveui/material/material_state.dart';
import 'package:waveui/material/theme.dart';
import 'package:waveui/material/theme_data.dart';
import 'package:waveui/waveui.dart' show ThemeData;

// Examples can assume:
// bool _throwShotAway = false;
// late StateSetter setState;

enum _CheckboxType { material, adaptive }

class Checkbox extends StatefulWidget {
  const Checkbox({
    required this.value,
    required this.onChanged,
    super.key,
    this.tristate = false,
    this.mouseCursor,
    this.activeColor,
    this.fillColor,
    this.checkColor,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.materialTapTargetSize,
    this.visualDensity,
    this.focusNode,
    this.autofocus = false,
    this.shape,
    this.side,
    this.isError = false,
    this.semanticLabel,
  }) : _checkboxType = _CheckboxType.material,
       assert(tristate || value != null);

  const Checkbox.adaptive({
    required this.value,
    required this.onChanged,
    super.key,
    this.tristate = false,
    this.mouseCursor,
    this.activeColor,
    this.fillColor,
    this.checkColor,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.materialTapTargetSize,
    this.visualDensity,
    this.focusNode,
    this.autofocus = false,
    this.shape,
    this.side,
    this.isError = false,
    this.semanticLabel,
  }) : _checkboxType = _CheckboxType.adaptive,
       assert(tristate || value != null);

  final bool? value;

  final ValueChanged<bool?>? onChanged;

  final MouseCursor? mouseCursor;

  final Color? activeColor;

  final WidgetStateProperty<Color?>? fillColor;

  final Color? checkColor;

  final bool tristate;

  final MaterialTapTargetSize? materialTapTargetSize;

  final VisualDensity? visualDensity;

  final Color? focusColor;

  final Color? hoverColor;

  final WidgetStateProperty<Color?>? overlayColor;

  final double? splashRadius;

  final FocusNode? focusNode;

  final bool autofocus;

  final OutlinedBorder? shape;

  final BorderSide? side;

  final bool isError;

  final String? semanticLabel;

  static const double width = 18.0;

  final _CheckboxType _checkboxType;

  @override
  State<Checkbox> createState() => _CheckboxState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool?>('value', value));
    properties.add(ObjectFlagProperty<ValueChanged<bool?>?>.has('onChanged', onChanged));
    properties.add(DiagnosticsProperty<MouseCursor?>('mouseCursor', mouseCursor));
    properties.add(ColorProperty('activeColor', activeColor));
    properties.add(DiagnosticsProperty<WidgetStateProperty<Color?>?>('fillColor', fillColor));
    properties.add(ColorProperty('checkColor', checkColor));
    properties.add(DiagnosticsProperty<bool>('tristate', tristate));
    properties.add(EnumProperty<MaterialTapTargetSize?>('materialTapTargetSize', materialTapTargetSize));
    properties.add(DiagnosticsProperty<VisualDensity?>('visualDensity', visualDensity));
    properties.add(ColorProperty('focusColor', focusColor));
    properties.add(ColorProperty('hoverColor', hoverColor));
    properties.add(DiagnosticsProperty<WidgetStateProperty<Color?>?>('overlayColor', overlayColor));
    properties.add(DoubleProperty('splashRadius', splashRadius));
    properties.add(DiagnosticsProperty<FocusNode?>('focusNode', focusNode));
    properties.add(DiagnosticsProperty<bool>('autofocus', autofocus));
    properties.add(DiagnosticsProperty<OutlinedBorder?>('shape', shape));
    properties.add(DiagnosticsProperty<BorderSide?>('side', side));
    properties.add(DiagnosticsProperty<bool>('isError', isError));
    properties.add(StringProperty('semanticLabel', semanticLabel));
  }
}

class _CheckboxState extends State<Checkbox> with TickerProviderStateMixin, ToggleableStateMixin {
  final _CheckboxPainter _painter = _CheckboxPainter();
  bool? _previousValue;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.value;
  }

  @override
  void didUpdateWidget(Checkbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = oldWidget.value;
      animateToValue();
    }
  }

  @override
  void dispose() {
    _painter.dispose();
    super.dispose();
  }

  @override
  ValueChanged<bool?>? get onChanged => widget.onChanged;

  @override
  bool get tristate => widget.tristate;

  @override
  bool? get value => widget.value;

  @override
  Duration? get reactionAnimationDuration => kRadialReactionDuration;

  WidgetStateProperty<Color?> get _widgetFillColor => WidgetStateProperty.resolveWith((states) {
    if (states.contains(WidgetState.disabled)) {
      return null;
    }
    if (states.contains(WidgetState.selected)) {
      return widget.activeColor;
    }
    return null;
  });

  BorderSide? _resolveSide(BorderSide? side, Set<WidgetState> states) {
    if (side is WidgetStateBorderSide) {
      return WidgetStateProperty.resolveAs<BorderSide?>(side, states);
    }
    if (!states.contains(WidgetState.selected)) {
      return side;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    switch (widget._checkboxType) {
      case _CheckboxType.material:
        break;

      case _CheckboxType.adaptive:
        final ThemeData theme = Theme.of(context);
        switch (theme.platform) {
          case TargetPlatform.android:
          case TargetPlatform.fuchsia:
          case TargetPlatform.linux:
          case TargetPlatform.windows:
            break;
          case TargetPlatform.iOS:
          case TargetPlatform.macOS:
            return CupertinoCheckbox(
              value: value,
              tristate: tristate,
              onChanged: onChanged,
              mouseCursor: widget.mouseCursor,
              activeColor: widget.activeColor,
              checkColor: widget.checkColor,
              focusColor: widget.focusColor,
              focusNode: widget.focusNode,
              autofocus: widget.autofocus,
              side: widget.side,
              shape: widget.shape,
              semanticLabel: widget.semanticLabel,
            );
        }
    }

    assert(debugCheckHasMaterial(context));
    final CheckboxThemeData checkboxTheme = CheckboxTheme.of(context);
    final CheckboxThemeData defaults = _CheckboxDefaultsM3(context);
    final MaterialTapTargetSize effectiveMaterialTapTargetSize =
        widget.materialTapTargetSize ?? checkboxTheme.materialTapTargetSize ?? defaults.materialTapTargetSize!;
    final VisualDensity effectiveVisualDensity =
        widget.visualDensity ?? checkboxTheme.visualDensity ?? defaults.visualDensity!;
    Size size = switch (effectiveMaterialTapTargetSize) {
      MaterialTapTargetSize.padded => const Size(kMinInteractiveDimension, kMinInteractiveDimension),
      MaterialTapTargetSize.shrinkWrap => const Size(kMinInteractiveDimension - 8.0, kMinInteractiveDimension - 8.0),
    };
    size += effectiveVisualDensity.baseSizeAdjustment;

    final WidgetStateProperty<MouseCursor> effectiveMouseCursor = WidgetStateProperty.resolveWith<MouseCursor>(
      (states) =>
          WidgetStateProperty.resolveAs<MouseCursor?>(widget.mouseCursor, states) ??
          checkboxTheme.mouseCursor?.resolve(states) ??
          WidgetStateMouseCursor.clickable.resolve(states),
    );

    // Colors need to be resolved in selected and non selected states separately
    final Set<WidgetState> activeStates = states..add(WidgetState.selected);
    final Set<WidgetState> inactiveStates = states..remove(WidgetState.selected);
    if (widget.isError) {
      activeStates.add(WidgetState.error);
      inactiveStates.add(WidgetState.error);
    }
    final Color? activeColor =
        widget.fillColor?.resolve(activeStates) ??
        _widgetFillColor.resolve(activeStates) ??
        checkboxTheme.fillColor?.resolve(activeStates);
    final Color effectiveActiveColor = activeColor ?? defaults.fillColor!.resolve(activeStates)!;
    final Color? inactiveColor =
        widget.fillColor?.resolve(inactiveStates) ??
        _widgetFillColor.resolve(inactiveStates) ??
        checkboxTheme.fillColor?.resolve(inactiveStates);
    final Color effectiveInactiveColor = inactiveColor ?? defaults.fillColor!.resolve(inactiveStates)!;

    final BorderSide activeSide =
        _resolveSide(widget.side, activeStates) ??
        _resolveSide(checkboxTheme.side, activeStates) ??
        _resolveSide(defaults.side, activeStates)!;
    final BorderSide inactiveSide =
        _resolveSide(widget.side, inactiveStates) ??
        _resolveSide(checkboxTheme.side, inactiveStates) ??
        _resolveSide(defaults.side, inactiveStates)!;

    final Set<WidgetState> focusedStates = states..add(WidgetState.focused);
    if (widget.isError) {
      focusedStates.add(WidgetState.error);
    }
    Color effectiveFocusOverlayColor =
        widget.overlayColor?.resolve(focusedStates) ??
        widget.focusColor ??
        checkboxTheme.overlayColor?.resolve(focusedStates) ??
        defaults.overlayColor!.resolve(focusedStates)!;

    final Set<WidgetState> hoveredStates = states..add(WidgetState.hovered);
    if (widget.isError) {
      hoveredStates.add(WidgetState.error);
    }
    Color effectiveHoverOverlayColor =
        widget.overlayColor?.resolve(hoveredStates) ??
        widget.hoverColor ??
        checkboxTheme.overlayColor?.resolve(hoveredStates) ??
        defaults.overlayColor!.resolve(hoveredStates)!;

    final Set<WidgetState> activePressedStates = activeStates..add(WidgetState.pressed);
    final Color effectiveActivePressedOverlayColor =
        widget.overlayColor?.resolve(activePressedStates) ??
        checkboxTheme.overlayColor?.resolve(activePressedStates) ??
        activeColor?.withAlpha(kRadialReactionAlpha) ??
        defaults.overlayColor!.resolve(activePressedStates)!;

    final Set<WidgetState> inactivePressedStates = inactiveStates..add(WidgetState.pressed);
    final Color effectiveInactivePressedOverlayColor =
        widget.overlayColor?.resolve(inactivePressedStates) ??
        checkboxTheme.overlayColor?.resolve(inactivePressedStates) ??
        inactiveColor?.withAlpha(kRadialReactionAlpha) ??
        defaults.overlayColor!.resolve(inactivePressedStates)!;

    if (downPosition != null) {
      effectiveHoverOverlayColor =
          states.contains(WidgetState.selected)
              ? effectiveActivePressedOverlayColor
              : effectiveInactivePressedOverlayColor;
      effectiveFocusOverlayColor =
          states.contains(WidgetState.selected)
              ? effectiveActivePressedOverlayColor
              : effectiveInactivePressedOverlayColor;
    }

    final Set<WidgetState> checkStates = widget.isError ? (states..add(WidgetState.error)) : states;
    final Color effectiveCheckColor =
        widget.checkColor ??
        checkboxTheme.checkColor?.resolve(checkStates) ??
        defaults.checkColor!.resolve(checkStates)!;

    final double effectiveSplashRadius = widget.splashRadius ?? checkboxTheme.splashRadius ?? defaults.splashRadius!;

    return Semantics(
      label: widget.semanticLabel,
      checked: widget.value ?? false,
      mixed: widget.tristate ? widget.value == null : null,
      child: buildToggleable(
        mouseCursor: effectiveMouseCursor,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        size: size,
        painter:
            _painter
              ..position = position
              ..reaction = reaction
              ..reactionFocusFade = reactionFocusFade
              ..reactionHoverFade = reactionHoverFade
              ..inactiveReactionColor = effectiveInactivePressedOverlayColor
              ..reactionColor = effectiveActivePressedOverlayColor
              ..hoverColor = effectiveHoverOverlayColor
              ..focusColor = effectiveFocusOverlayColor
              ..splashRadius = effectiveSplashRadius
              ..downPosition = downPosition
              ..isFocused = states.contains(WidgetState.focused)
              ..isHovered = states.contains(WidgetState.hovered)
              ..activeColor = effectiveActiveColor
              ..inactiveColor = effectiveInactiveColor
              ..checkColor = effectiveCheckColor
              ..value = value
              ..previousValue = _previousValue
              ..shape = widget.shape ?? checkboxTheme.shape ?? defaults.shape!
              ..activeSide = activeSide
              ..inactiveSide = inactiveSide,
      ),
    );
  }
}

const double _kEdgeSize = Checkbox.width;
const double _kStrokeWidth = 2.0;

class _CheckboxPainter extends ToggleablePainter {
  Color get checkColor => _checkColor!;
  Color? _checkColor;
  set checkColor(Color value) {
    if (_checkColor == value) {
      return;
    }
    _checkColor = value;
    notifyListeners();
  }

  bool? get value => _value;
  bool? _value;
  set value(bool? value) {
    if (_value == value) {
      return;
    }
    _value = value;
    notifyListeners();
  }

  bool? get previousValue => _previousValue;
  bool? _previousValue;
  set previousValue(bool? value) {
    if (_previousValue == value) {
      return;
    }
    _previousValue = value;
    notifyListeners();
  }

  OutlinedBorder get shape => _shape!;
  OutlinedBorder? _shape;
  set shape(OutlinedBorder value) {
    if (_shape == value) {
      return;
    }
    _shape = value;
    notifyListeners();
  }

  BorderSide get activeSide => _activeSide!;
  BorderSide? _activeSide;
  set activeSide(BorderSide value) {
    if (_activeSide == value) {
      return;
    }
    _activeSide = value;
    notifyListeners();
  }

  BorderSide get inactiveSide => _inactiveSide!;
  BorderSide? _inactiveSide;
  set inactiveSide(BorderSide value) {
    if (_inactiveSide == value) {
      return;
    }
    _inactiveSide = value;
    notifyListeners();
  }

  // The square outer bounds of the checkbox at t, with the specified origin.
  // At t == 0.0, the outer rect's size is _kEdgeSize (Checkbox.width)
  // At t == 0.5, .. is _kEdgeSize - _kStrokeWidth
  // At t == 1.0, .. is _kEdgeSize
  Rect _outerRectAt(Offset origin, double t) {
    final double inset = 1.0 - (t - 0.5).abs() * 2.0;
    final double size = _kEdgeSize - inset * _kStrokeWidth;
    final Rect rect = Rect.fromLTWH(origin.dx + inset, origin.dy + inset, size, size);
    return rect;
  }

  // The checkbox's fill color
  Color _colorAt(double t) {
    // As t goes from 0.0 to 0.25, animate from the inactiveColor to activeColor.
    return t >= 0.25 ? activeColor : Color.lerp(inactiveColor, activeColor, t * 4.0)!;
  }

  // White stroke used to paint the check and dash.
  Paint _createStrokePaint() =>
      Paint()
        ..color = checkColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = _kStrokeWidth;

  void _drawBox(Canvas canvas, Rect outer, Paint paint, BorderSide? side) {
    canvas.drawPath(shape.getOuterPath(outer), paint);
    if (side != null) {
      shape.copyWith(side: side).paint(canvas, outer);
    }
  }

  void _drawCheck(Canvas canvas, Offset origin, double t, Paint paint) {
    assert(t >= 0.0 && t <= 1.0);
    // As t goes from 0.0 to 1.0, animate the two check mark strokes from the
    // short side to the long side.
    final Path path = Path();
    const Offset start = Offset(_kEdgeSize * 0.15, _kEdgeSize * 0.45);
    const Offset mid = Offset(_kEdgeSize * 0.4, _kEdgeSize * 0.7);
    const Offset end = Offset(_kEdgeSize * 0.85, _kEdgeSize * 0.25);
    if (t < 0.5) {
      final double strokeT = t * 2.0;
      final Offset drawMid = Offset.lerp(start, mid, strokeT)!;
      path.moveTo(origin.dx + start.dx, origin.dy + start.dy);
      path.lineTo(origin.dx + drawMid.dx, origin.dy + drawMid.dy);
    } else {
      final double strokeT = (t - 0.5) * 2.0;
      final Offset drawEnd = Offset.lerp(mid, end, strokeT)!;
      path.moveTo(origin.dx + start.dx, origin.dy + start.dy);
      path.lineTo(origin.dx + mid.dx, origin.dy + mid.dy);
      path.lineTo(origin.dx + drawEnd.dx, origin.dy + drawEnd.dy);
    }
    canvas.drawPath(path, paint);
  }

  void _drawDash(Canvas canvas, Offset origin, double t, Paint paint) {
    assert(t >= 0.0 && t <= 1.0);
    // As t goes from 0.0 to 1.0, animate the horizontal line from the
    // mid point outwards.
    const Offset start = Offset(_kEdgeSize * 0.2, _kEdgeSize * 0.5);
    const Offset mid = Offset(_kEdgeSize * 0.5, _kEdgeSize * 0.5);
    const Offset end = Offset(_kEdgeSize * 0.8, _kEdgeSize * 0.5);
    final Offset drawStart = Offset.lerp(start, mid, 1.0 - t)!;
    final Offset drawEnd = Offset.lerp(mid, end, t)!;
    canvas.drawLine(origin + drawStart, origin + drawEnd, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    paintRadialReaction(canvas: canvas, origin: size.center(Offset.zero));

    final Paint strokePaint = _createStrokePaint();
    final Offset origin = size / 2.0 - const Size.square(_kEdgeSize) / 2.0 as Offset;
    final double tNormalized = switch (position.status) {
      AnimationStatus.forward || AnimationStatus.completed => position.value,
      AnimationStatus.reverse || AnimationStatus.dismissed => 1.0 - position.value,
    };

    // Four cases: false to null, false to true, null to false, true to false
    if (previousValue == false || value == false) {
      final double t = value == false ? 1.0 - tNormalized : tNormalized;
      final Rect outer = _outerRectAt(origin, t);
      final Paint paint = Paint()..color = _colorAt(t);

      if (t <= 0.5) {
        final BorderSide border = BorderSide.lerp(inactiveSide, activeSide, t);
        _drawBox(canvas, outer, paint, border);
      } else {
        _drawBox(canvas, outer, paint, activeSide);
        final double tShrink = (t - 0.5) * 2.0;
        if (previousValue == null || value == null) {
          _drawDash(canvas, origin, tShrink, strokePaint);
        } else {
          _drawCheck(canvas, origin, tShrink, strokePaint);
        }
      }
    } else {
      // Two cases: null to true, true to null
      final Rect outer = _outerRectAt(origin, 1.0);
      final Paint paint = Paint()..color = _colorAt(1.0);

      _drawBox(canvas, outer, paint, activeSide);
      if (tNormalized <= 0.5) {
        final double tShrink = 1.0 - tNormalized * 2.0;
        if (previousValue ?? false) {
          _drawCheck(canvas, origin, tShrink, strokePaint);
        } else {
          _drawDash(canvas, origin, tShrink, strokePaint);
        }
      } else {
        final double tExpand = (tNormalized - 0.5) * 2.0;
        if (value ?? false) {
          _drawCheck(canvas, origin, tExpand, strokePaint);
        } else {
          _drawDash(canvas, origin, tExpand, strokePaint);
        }
      }
    }
  }
}

// BEGIN GENERATED TOKEN PROPERTIES - Checkbox

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// dart format off
class _CheckboxDefaultsM3 extends CheckboxThemeData {
  _CheckboxDefaultsM3(BuildContext context)
    : _theme = Theme.of(context),
      _colors = Theme.of(context).colorScheme;

  final ThemeData _theme;
  final ColorScheme _colors;

  @override
  WidgetStateBorderSide? get side => WidgetStateBorderSide.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        if (states.contains(WidgetState.selected)) {
          return const BorderSide(width: 2.0, color: Colors.transparent);
        }
        return BorderSide(width: 2.0, color: _colors.onSurface.withValues(alpha:0.38));
      }
      if (states.contains(WidgetState.selected)) {
        return const BorderSide(width: 0.0, color: Colors.transparent);
      }
      if (states.contains(WidgetState.error)) {
        return BorderSide(width: 2.0, color: _colors.error);
      }
      if (states.contains(WidgetState.pressed)) {
        return BorderSide(width: 2.0, color: _colors.onSurface);
      }
      if (states.contains(WidgetState.hovered)) {
        return BorderSide(width: 2.0, color: _colors.onSurface);
      }
      if (states.contains(WidgetState.focused)) {
        return BorderSide(width: 2.0, color: _colors.onSurface);
      }
      return BorderSide(width: 2.0, color: _colors.onSurfaceVariant);
    });

  @override
  WidgetStateProperty<Color> get fillColor => WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        if (states.contains(WidgetState.selected)) {
          return _colors.onSurface.withValues(alpha:0.38);
        }
        return Colors.transparent;
      }
      if (states.contains(WidgetState.selected)) {
        if (states.contains(WidgetState.error)) {
          return _colors.error;
        }
        return _colors.primary;
      }
      return Colors.transparent;
    });

  @override
  WidgetStateProperty<Color> get checkColor => WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        if (states.contains(WidgetState.selected)) {
          return _colors.surface;
        }
        return Colors.transparent; // No icons available when the checkbox is unselected.
      }
      if (states.contains(WidgetState.selected)) {
        if (states.contains(WidgetState.error)) {
          return _colors.onError;
        }
        return _colors.onPrimary;
      }
      return Colors.transparent; // No icons available when the checkbox is unselected.
    });

  @override
  WidgetStateProperty<Color> get overlayColor => WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.error)) {
        if (states.contains(WidgetState.pressed)) {
          return _colors.error.withValues(alpha:0.1);
        }
        if (states.contains(WidgetState.hovered)) {
          return _colors.error.withValues(alpha:0.08);
        }
        if (states.contains(WidgetState.focused)) {
          return _colors.error.withValues(alpha:0.1);
        }
      }
      if (states.contains(WidgetState.selected)) {
        if (states.contains(WidgetState.pressed)) {
          return _colors.onSurface.withValues(alpha:0.1);
        }
        if (states.contains(WidgetState.hovered)) {
          return _colors.primary.withValues(alpha:0.08);
        }
        if (states.contains(WidgetState.focused)) {
          return _colors.primary.withValues(alpha:0.1);
        }
        return Colors.transparent;
      }
      if (states.contains(WidgetState.pressed)) {
        return _colors.primary.withValues(alpha:0.1);
      }
      if (states.contains(WidgetState.hovered)) {
        return _colors.onSurface.withValues(alpha:0.08);
      }
      if (states.contains(WidgetState.focused)) {
        return _colors.onSurface.withValues(alpha:0.1);
      }
      return Colors.transparent;
    });

  @override
  double get splashRadius => 40.0 / 2;

  @override
  MaterialTapTargetSize get materialTapTargetSize => _theme.materialTapTargetSize;

  @override
  VisualDensity get visualDensity => VisualDensity.standard;

  @override
  OutlinedBorder get shape => const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2.0)),
  );
}
// dart format on

// END GENERATED TOKEN PROPERTIES - Checkbox
