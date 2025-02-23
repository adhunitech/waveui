// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/button_style.dart';
import 'package:waveui/material/color_scheme.dart';
import 'package:waveui/material/constants.dart';
import 'package:waveui/material/ink_ripple.dart';
import 'package:waveui/material/text_button.dart';
import 'package:waveui/material/theme.dart';
import 'package:waveui/material/theme_data.dart';
import 'package:waveui/material/toggle_buttons_theme.dart';

// Examples can assume:
// List<bool> isSelected = <bool>[];
// void setState(dynamic arg) { }

class ToggleButtons extends StatelessWidget {
  const ToggleButtons({
    required this.children,
    required this.isSelected,
    super.key,
    this.onPressed,
    this.mouseCursor,
    this.tapTargetSize,
    this.textStyle,
    this.constraints,
    this.color,
    this.selectedColor,
    this.disabledColor,
    this.fillColor,
    this.focusColor,
    this.highlightColor,
    this.hoverColor,
    this.splashColor,
    this.focusNodes,
    this.renderBorder = true,
    this.borderColor,
    this.selectedBorderColor,
    this.disabledBorderColor,
    this.borderRadius,
    this.borderWidth,
    this.direction = Axis.horizontal,
    this.verticalDirection = VerticalDirection.down,
  }) : assert(children.length == isSelected.length);

  static const double _defaultBorderWidth = 1.0;

  final List<Widget> children;

  final List<bool> isSelected;

  final void Function(int index)? onPressed;

  final MouseCursor? mouseCursor;

  final MaterialTapTargetSize? tapTargetSize;

  final TextStyle? textStyle;

  final BoxConstraints? constraints;

  final Color? color;

  final Color? selectedColor;

  final Color? disabledColor;

  final Color? fillColor;

  final Color? focusColor;

  final Color? highlightColor;

  final Color? splashColor;

  final Color? hoverColor;

  final List<FocusNode>? focusNodes;

  final bool renderBorder;

  final Color? borderColor;

  final Color? selectedBorderColor;

  final Color? disabledBorderColor;

  final double? borderWidth;

  final BorderRadius? borderRadius;

  final Axis direction;

  final VerticalDirection verticalDirection;

  // Determines if this is the first child that is being laid out
  // by the render object, _not_ the order of the children in its list.
  bool _isFirstButton(int index, int length, TextDirection textDirection) {
    switch (direction) {
      case Axis.horizontal:
        return switch (textDirection) {
          TextDirection.rtl => index == length - 1,
          TextDirection.ltr => index == 0,
        };
      case Axis.vertical:
        return switch (verticalDirection) {
          VerticalDirection.up => index == length - 1,
          VerticalDirection.down => index == 0,
        };
    }
  }

  // Determines if this is the last child that is being laid out
  // by the render object, _not_ the order of the children in its list.
  bool _isLastButton(int index, int length, TextDirection textDirection) {
    switch (direction) {
      case Axis.horizontal:
        return switch (textDirection) {
          TextDirection.rtl => index == 0,
          TextDirection.ltr => index == length - 1,
        };
      case Axis.vertical:
        return switch (verticalDirection) {
          VerticalDirection.up => index == 0,
          VerticalDirection.down => index == length - 1,
        };
    }
  }

  BorderRadius _getEdgeBorderRadius(
    int index,
    int length,
    TextDirection textDirection,
    ToggleButtonsThemeData toggleButtonsTheme,
  ) {
    final BorderRadius resultingBorderRadius = borderRadius ?? toggleButtonsTheme.borderRadius ?? BorderRadius.zero;

    if (length == 1) {
      return resultingBorderRadius;
    } else if (direction == Axis.horizontal) {
      if (_isFirstButton(index, length, textDirection)) {
        return BorderRadius.only(topLeft: resultingBorderRadius.topLeft, bottomLeft: resultingBorderRadius.bottomLeft);
      } else if (_isLastButton(index, length, textDirection)) {
        return BorderRadius.only(
          topRight: resultingBorderRadius.topRight,
          bottomRight: resultingBorderRadius.bottomRight,
        );
      }
    } else {
      if (_isFirstButton(index, length, textDirection)) {
        return BorderRadius.only(topLeft: resultingBorderRadius.topLeft, topRight: resultingBorderRadius.topRight);
      } else if (_isLastButton(index, length, textDirection)) {
        return BorderRadius.only(
          bottomLeft: resultingBorderRadius.bottomLeft,
          bottomRight: resultingBorderRadius.bottomRight,
        );
      }
    }

    return BorderRadius.zero;
  }

  BorderRadius _getClipBorderRadius(
    int index,
    int length,
    TextDirection textDirection,
    ToggleButtonsThemeData toggleButtonsTheme,
  ) {
    final BorderRadius resultingBorderRadius = borderRadius ?? toggleButtonsTheme.borderRadius ?? BorderRadius.zero;
    final double resultingBorderWidth = borderWidth ?? toggleButtonsTheme.borderWidth ?? _defaultBorderWidth;

    if (length == 1) {
      return BorderRadius.only(
        topLeft: resultingBorderRadius.topLeft - Radius.circular(resultingBorderWidth / 2.0),
        bottomLeft: resultingBorderRadius.bottomLeft - Radius.circular(resultingBorderWidth / 2.0),
        topRight: resultingBorderRadius.topRight - Radius.circular(resultingBorderWidth / 2.0),
        bottomRight: resultingBorderRadius.bottomRight - Radius.circular(resultingBorderWidth / 2.0),
      );
    } else if (direction == Axis.horizontal) {
      if (_isFirstButton(index, length, textDirection)) {
        return BorderRadius.only(
          topLeft: resultingBorderRadius.topLeft - Radius.circular(resultingBorderWidth / 2.0),
          bottomLeft: resultingBorderRadius.bottomLeft - Radius.circular(resultingBorderWidth / 2.0),
        );
      } else if (_isLastButton(index, length, textDirection)) {
        return BorderRadius.only(
          topRight: resultingBorderRadius.topRight - Radius.circular(resultingBorderWidth / 2.0),
          bottomRight: resultingBorderRadius.bottomRight - Radius.circular(resultingBorderWidth / 2.0),
        );
      }
    } else {
      if (_isFirstButton(index, length, textDirection)) {
        return BorderRadius.only(
          topLeft: resultingBorderRadius.topLeft - Radius.circular(resultingBorderWidth / 2.0),
          topRight: resultingBorderRadius.topRight - Radius.circular(resultingBorderWidth / 2.0),
        );
      } else if (_isLastButton(index, length, textDirection)) {
        return BorderRadius.only(
          bottomLeft: resultingBorderRadius.bottomLeft - Radius.circular(resultingBorderWidth / 2.0),
          bottomRight: resultingBorderRadius.bottomRight - Radius.circular(resultingBorderWidth / 2.0),
        );
      }
    }
    return BorderRadius.zero;
  }

  BorderSide _getLeadingBorderSide(int index, ThemeData theme, ToggleButtonsThemeData toggleButtonsTheme) {
    if (!renderBorder) {
      return BorderSide.none;
    }

    final double resultingBorderWidth = borderWidth ?? toggleButtonsTheme.borderWidth ?? _defaultBorderWidth;
    if (onPressed != null && (isSelected[index] || (index != 0 && isSelected[index - 1]))) {
      return BorderSide(
        color:
            selectedBorderColor ??
            toggleButtonsTheme.selectedBorderColor ??
            theme.colorScheme.onSurface.withValues(alpha: 0.12),
        width: resultingBorderWidth,
      );
    } else if (onPressed != null && !isSelected[index]) {
      return BorderSide(
        color: borderColor ?? toggleButtonsTheme.borderColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.12),
        width: resultingBorderWidth,
      );
    } else {
      return BorderSide(
        color:
            disabledBorderColor ??
            toggleButtonsTheme.disabledBorderColor ??
            theme.colorScheme.onSurface.withValues(alpha: 0.12),
        width: resultingBorderWidth,
      );
    }
  }

  BorderSide _getBorderSide(int index, ThemeData theme, ToggleButtonsThemeData toggleButtonsTheme) {
    if (!renderBorder) {
      return BorderSide.none;
    }

    final double resultingBorderWidth = borderWidth ?? toggleButtonsTheme.borderWidth ?? _defaultBorderWidth;
    if (onPressed != null && isSelected[index]) {
      return BorderSide(
        color:
            selectedBorderColor ??
            toggleButtonsTheme.selectedBorderColor ??
            theme.colorScheme.onSurface.withValues(alpha: 0.12),
        width: resultingBorderWidth,
      );
    } else if (onPressed != null && !isSelected[index]) {
      return BorderSide(
        color: borderColor ?? toggleButtonsTheme.borderColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.12),
        width: resultingBorderWidth,
      );
    } else {
      return BorderSide(
        color:
            disabledBorderColor ??
            toggleButtonsTheme.disabledBorderColor ??
            theme.colorScheme.onSurface.withValues(alpha: 0.12),
        width: resultingBorderWidth,
      );
    }
  }

  BorderSide _getTrailingBorderSide(int index, ThemeData theme, ToggleButtonsThemeData toggleButtonsTheme) {
    if (!renderBorder) {
      return BorderSide.none;
    }

    if (index != children.length - 1) {
      return BorderSide.none;
    }

    final double resultingBorderWidth = borderWidth ?? toggleButtonsTheme.borderWidth ?? _defaultBorderWidth;
    if (onPressed != null && (isSelected[index])) {
      return BorderSide(
        color:
            selectedBorderColor ??
            toggleButtonsTheme.selectedBorderColor ??
            theme.colorScheme.onSurface.withValues(alpha: 0.12),
        width: resultingBorderWidth,
      );
    } else if (onPressed != null && !isSelected[index]) {
      return BorderSide(
        color: borderColor ?? toggleButtonsTheme.borderColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.12),
        width: resultingBorderWidth,
      );
    } else {
      return BorderSide(
        color:
            disabledBorderColor ??
            toggleButtonsTheme.disabledBorderColor ??
            theme.colorScheme.onSurface.withValues(alpha: 0.12),
        width: resultingBorderWidth,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(
      () {
        if (focusNodes != null) {
          return focusNodes!.length == children.length;
        }
        return true;
      }(),
      'focusNodes.length must match children.length.\n'
      'There are ${focusNodes!.length} focus nodes, while '
      'there are ${children.length} children.',
    );
    final ThemeData theme = Theme.of(context);
    final ToggleButtonsThemeData toggleButtonsTheme = ToggleButtonsTheme.of(context);
    final TextDirection textDirection = Directionality.of(context);

    final List<Widget> buttons = List<Widget>.generate(children.length, (index) {
      final BorderRadius edgeBorderRadius = _getEdgeBorderRadius(
        index,
        children.length,
        textDirection,
        toggleButtonsTheme,
      );
      final BorderRadius clipBorderRadius = _getClipBorderRadius(
        index,
        children.length,
        textDirection,
        toggleButtonsTheme,
      );

      final BorderSide leadingBorderSide = _getLeadingBorderSide(index, theme, toggleButtonsTheme);
      final BorderSide borderSide = _getBorderSide(index, theme, toggleButtonsTheme);
      final BorderSide trailingBorderSide = _getTrailingBorderSide(index, theme, toggleButtonsTheme);

      final Set<WidgetState> states = <WidgetState>{
        if (isSelected[index] && onPressed != null) WidgetState.selected,
        if (onPressed == null) WidgetState.disabled,
      };
      final Color effectiveFillColor =
          _ResolveFillColor(fillColor ?? toggleButtonsTheme.fillColor).resolve(states) ??
          _DefaultFillColor(theme.colorScheme).resolve(states);
      final Color currentColor;
      if (onPressed != null && isSelected[index]) {
        currentColor = selectedColor ?? toggleButtonsTheme.selectedColor ?? theme.colorScheme.primary;
      } else if (onPressed != null && !isSelected[index]) {
        currentColor = color ?? toggleButtonsTheme.color ?? theme.colorScheme.onSurface.withValues(alpha: 0.87);
      } else {
        currentColor =
            disabledColor ?? toggleButtonsTheme.disabledColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.38);
      }
      final TextStyle currentTextStyle = textStyle ?? toggleButtonsTheme.textStyle ?? theme.textTheme.bodyMedium!;
      final BoxConstraints? currentConstraints = constraints ?? toggleButtonsTheme.constraints;
      final Size minimumSize = currentConstraints?.smallest ?? const Size.square(kMinInteractiveDimension);
      final Size? maximumSize = currentConstraints?.biggest;
      final Size minPaddingSize;
      switch (tapTargetSize ?? theme.materialTapTargetSize) {
        case MaterialTapTargetSize.padded:
          minPaddingSize = switch (direction) {
            Axis.horizontal => const Size(0.0, kMinInteractiveDimension),
            Axis.vertical => const Size(kMinInteractiveDimension, 0.0),
          };
          assert(minPaddingSize.width >= 0.0);
          assert(minPaddingSize.height >= 0.0);
        case MaterialTapTargetSize.shrinkWrap:
          minPaddingSize = Size.zero;
      }

      Widget button = _SelectToggleButton(
        leadingBorderSide: leadingBorderSide,
        borderSide: borderSide,
        trailingBorderSide: trailingBorderSide,
        borderRadius: edgeBorderRadius,
        isFirstButton: index == 0,
        isLastButton: index == children.length - 1,
        direction: direction,
        verticalDirection: verticalDirection,
        child: ClipRRect(
          borderRadius: clipBorderRadius,
          child: TextButton(
            focusNode: focusNodes != null ? focusNodes![index] : null,
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll<Color?>(effectiveFillColor),
              foregroundColor: WidgetStatePropertyAll<Color?>(currentColor),
              iconSize: const WidgetStatePropertyAll<double>(24.0),
              iconColor: WidgetStatePropertyAll<Color?>(currentColor),
              overlayColor: _ToggleButtonDefaultOverlay(
                selected: onPressed != null && isSelected[index],
                unselected: onPressed != null && !isSelected[index],
                colorScheme: theme.colorScheme,
                disabledColor: disabledColor ?? toggleButtonsTheme.disabledColor,
                focusColor: focusColor ?? toggleButtonsTheme.focusColor,
                highlightColor: highlightColor ?? toggleButtonsTheme.highlightColor,
                hoverColor: hoverColor ?? toggleButtonsTheme.hoverColor,
                splashColor: splashColor ?? toggleButtonsTheme.splashColor,
              ),
              elevation: const WidgetStatePropertyAll<double>(0),
              textStyle: WidgetStatePropertyAll<TextStyle?>(currentTextStyle.copyWith(color: currentColor)),
              padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.zero),
              minimumSize: WidgetStatePropertyAll<Size?>(minimumSize),
              maximumSize: WidgetStatePropertyAll<Size?>(maximumSize),
              shape: const WidgetStatePropertyAll<OutlinedBorder>(RoundedRectangleBorder()),
              mouseCursor: WidgetStatePropertyAll<MouseCursor?>(mouseCursor),
              visualDensity: VisualDensity.standard,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              animationDuration: kThemeChangeDuration,
              enableFeedback: true,
              alignment: Alignment.center,
              splashFactory: InkRipple.splashFactory,
            ),
            onPressed:
                onPressed != null
                    ? () {
                      onPressed!(index);
                    }
                    : null,
            child: children[index],
          ),
        ),
      );

      if (currentConstraints != null) {
        button = Center(child: button);
      }

      return MergeSemantics(
        child: Semantics(
          container: true,
          checked: isSelected[index],
          enabled: onPressed != null,
          child: _InputPadding(minSize: minPaddingSize, direction: direction, child: button),
        ),
      );
    });

    if (direction == Axis.vertical) {
      return IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          verticalDirection: verticalDirection,
          children: buttons,
        ),
      );
    }

    return IntrinsicHeight(
      child: Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: buttons),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      FlagProperty(
        'disabled',
        value: onPressed == null,
        ifTrue: 'Buttons are disabled',
        ifFalse: 'Buttons are enabled',
      ),
    );
    textStyle?.debugFillProperties(properties, prefix: 'textStyle.');
    properties.add(ColorProperty('color', color, defaultValue: null));
    properties.add(ColorProperty('selectedColor', selectedColor, defaultValue: null));
    properties.add(ColorProperty('disabledColor', disabledColor, defaultValue: null));
    properties.add(ColorProperty('fillColor', fillColor, defaultValue: null));
    properties.add(ColorProperty('focusColor', focusColor, defaultValue: null));
    properties.add(ColorProperty('highlightColor', highlightColor, defaultValue: null));
    properties.add(ColorProperty('hoverColor', hoverColor, defaultValue: null));
    properties.add(ColorProperty('splashColor', splashColor, defaultValue: null));
    properties.add(ColorProperty('borderColor', borderColor, defaultValue: null));
    properties.add(ColorProperty('selectedBorderColor', selectedBorderColor, defaultValue: null));
    properties.add(ColorProperty('disabledBorderColor', disabledBorderColor, defaultValue: null));
    properties.add(DiagnosticsProperty<BorderRadius>('borderRadius', borderRadius, defaultValue: null));
    properties.add(DoubleProperty('borderWidth', borderWidth, defaultValue: null));
    properties.add(DiagnosticsProperty<Axis>('direction', direction, defaultValue: Axis.horizontal));
    properties.add(
      DiagnosticsProperty<VerticalDirection>(
        'verticalDirection',
        verticalDirection,
        defaultValue: VerticalDirection.down,
      ),
    );
    properties.add(IterableProperty<bool>('isSelected', isSelected));
    properties.add(DiagnosticsProperty<MouseCursor?>('mouseCursor', mouseCursor));
    properties.add(EnumProperty<MaterialTapTargetSize?>('tapTargetSize', tapTargetSize));
    properties.add(DiagnosticsProperty<BoxConstraints?>('constraints', constraints));
    properties.add(IterableProperty<FocusNode>('focusNodes', focusNodes));
    properties.add(DiagnosticsProperty<bool>('renderBorder', renderBorder));
  }
}

@immutable
class _ResolveFillColor extends WidgetStateProperty<Color?> with Diagnosticable {
  _ResolveFillColor(this.primary);

  final Color? primary;

  @override
  Color? resolve(Set<WidgetState> states) {
    if (primary is WidgetStateProperty<Color>) {
      return WidgetStateProperty.resolveAs<Color?>(primary, states);
    }
    return states.contains(WidgetState.selected) ? primary : null;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('primary', primary));
  }
}

@immutable
class _DefaultFillColor extends WidgetStateProperty<Color> with Diagnosticable {
  _DefaultFillColor(this.colorScheme);

  final ColorScheme colorScheme;

  @override
  Color resolve(Set<WidgetState> states) {
    if (states.contains(WidgetState.selected)) {
      return colorScheme.primary.withValues(alpha: 0.12);
    }
    return colorScheme.surface.withValues(alpha: 0.0);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ColorScheme>('colorScheme', colorScheme));
  }
}

@immutable
class _ToggleButtonDefaultOverlay extends WidgetStateProperty<Color?> {
  _ToggleButtonDefaultOverlay({
    required this.selected,
    required this.unselected,
    this.colorScheme,
    this.focusColor,
    this.highlightColor,
    this.hoverColor,
    this.splashColor,
    this.disabledColor,
  });

  final bool selected;
  final bool unselected;
  final ColorScheme? colorScheme;
  final Color? focusColor;
  final Color? highlightColor;
  final Color? hoverColor;
  final Color? splashColor;
  final Color? disabledColor;

  @override
  Color? resolve(Set<WidgetState> states) {
    if (selected) {
      if (states.contains(WidgetState.pressed)) {
        return splashColor ?? colorScheme?.primary.withValues(alpha: 0.16);
      }
      if (states.contains(WidgetState.hovered)) {
        return hoverColor ?? colorScheme?.primary.withValues(alpha: 0.04);
      }
      if (states.contains(WidgetState.focused)) {
        return focusColor ?? colorScheme?.primary.withValues(alpha: 0.12);
      }
    } else if (unselected) {
      if (states.contains(WidgetState.pressed)) {
        return splashColor ?? highlightColor ?? colorScheme?.onSurface.withValues(alpha: 0.16);
      }
      if (states.contains(WidgetState.hovered)) {
        return hoverColor ?? colorScheme?.onSurface.withValues(alpha: 0.04);
      }
      if (states.contains(WidgetState.focused)) {
        return focusColor ?? colorScheme?.onSurface.withValues(alpha: 0.12);
      }
    }
    return null;
  }

  @override
  String toString() => '''
    {
      selected:
        hovered: $hoverColor, otherwise: ${colorScheme?.primary.withValues(alpha: 0.04)},
        focused: $focusColor, otherwise: ${colorScheme?.primary.withValues(alpha: 0.12)},
        pressed: $splashColor, otherwise: ${colorScheme?.primary.withValues(alpha: 0.16)},
      unselected:
        hovered: $hoverColor, otherwise: ${colorScheme?.onSurface.withValues(alpha: 0.04)},
        focused: $focusColor, otherwise: ${colorScheme?.onSurface.withValues(alpha: 0.12)},
        pressed: $splashColor, otherwise: ${colorScheme?.onSurface.withValues(alpha: 0.16)},
      otherwise: null,
    }
    ''';
}

class _SelectToggleButton extends SingleChildRenderObjectWidget {
  const _SelectToggleButton({
    required Widget super.child,
    required this.leadingBorderSide,
    required this.borderSide,
    required this.trailingBorderSide,
    required this.borderRadius,
    required this.isFirstButton,
    required this.isLastButton,
    required this.direction,
    required this.verticalDirection,
  });

  // The width and color of the button's leading side border.
  final BorderSide leadingBorderSide;

  // The width and color of the side borders.
  //
  // If [direction] is [Axis.horizontal], this corresponds to the width and color
  // of the button's top and bottom side borders.
  //
  // If [direction] is [Axis.vertical], this corresponds to the width and color
  // of the button's left and right side borders.
  final BorderSide borderSide;

  // The width and color of the button's trailing side border.
  final BorderSide trailingBorderSide;

  // The border radii of each corner of the button.
  final BorderRadius borderRadius;

  // Whether or not this toggle button is the first button in the list.
  final bool isFirstButton;

  // Whether or not this toggle button is the last button in the list.
  final bool isLastButton;

  // The direction along which the buttons are rendered.
  final Axis direction;

  // If [direction] is [Axis.vertical], this property defines whether or not this button in its list
  // of buttons is laid out starting from top to bottom or from bottom to top.
  final VerticalDirection verticalDirection;

  @override
  _SelectToggleButtonRenderObject createRenderObject(BuildContext context) => _SelectToggleButtonRenderObject(
    leadingBorderSide,
    borderSide,
    trailingBorderSide,
    borderRadius,
    isFirstButton,
    isLastButton,
    direction,
    verticalDirection,
    Directionality.of(context),
  );

  @override
  void updateRenderObject(BuildContext context, _SelectToggleButtonRenderObject renderObject) {
    renderObject
      ..leadingBorderSide = leadingBorderSide
      ..borderSide = borderSide
      ..trailingBorderSide = trailingBorderSide
      ..borderRadius = borderRadius
      ..isFirstButton = isFirstButton
      ..isLastButton = isLastButton
      ..direction = direction
      ..verticalDirection = verticalDirection
      ..textDirection = Directionality.of(context);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BorderSide>('leadingBorderSide', leadingBorderSide));
    properties.add(DiagnosticsProperty<BorderSide>('borderSide', borderSide));
    properties.add(DiagnosticsProperty<BorderSide>('trailingBorderSide', trailingBorderSide));
    properties.add(DiagnosticsProperty<BorderRadius>('borderRadius', borderRadius));
    properties.add(DiagnosticsProperty<bool>('isFirstButton', isFirstButton));
    properties.add(DiagnosticsProperty<bool>('isLastButton', isLastButton));
    properties.add(EnumProperty<Axis>('direction', direction));
    properties.add(EnumProperty<VerticalDirection>('verticalDirection', verticalDirection));
  }
}

class _SelectToggleButtonRenderObject extends RenderShiftedBox {
  _SelectToggleButtonRenderObject(
    this._leadingBorderSide,
    this._borderSide,
    this._trailingBorderSide,
    this._borderRadius,
    this._isFirstButton,
    this._isLastButton,
    this._direction,
    this._verticalDirection,
    this._textDirection, [
    RenderBox? child,
  ]) : super(child);

  Axis get direction => _direction;
  Axis _direction;
  set direction(Axis value) {
    if (_direction == value) {
      return;
    }
    _direction = value;
    markNeedsLayout();
  }

  VerticalDirection get verticalDirection => _verticalDirection;
  VerticalDirection _verticalDirection;
  set verticalDirection(VerticalDirection value) {
    if (_verticalDirection == value) {
      return;
    }
    _verticalDirection = value;
    markNeedsLayout();
  }

  // The width and color of the button's leading side border.
  BorderSide get leadingBorderSide => _leadingBorderSide;
  BorderSide _leadingBorderSide;
  set leadingBorderSide(BorderSide value) {
    if (_leadingBorderSide == value) {
      return;
    }
    _leadingBorderSide = value;
    markNeedsLayout();
  }

  // The width and color of the button's top and bottom side borders.
  BorderSide get borderSide => _borderSide;
  BorderSide _borderSide;
  set borderSide(BorderSide value) {
    if (_borderSide == value) {
      return;
    }
    _borderSide = value;
    markNeedsLayout();
  }

  // The width and color of the button's trailing side border.
  BorderSide get trailingBorderSide => _trailingBorderSide;
  BorderSide _trailingBorderSide;
  set trailingBorderSide(BorderSide value) {
    if (_trailingBorderSide == value) {
      return;
    }
    _trailingBorderSide = value;
    markNeedsLayout();
  }

  // The border radii of each corner of the button.
  BorderRadius get borderRadius => _borderRadius;
  BorderRadius _borderRadius;
  set borderRadius(BorderRadius value) {
    if (_borderRadius == value) {
      return;
    }
    _borderRadius = value;
    markNeedsLayout();
  }

  // Whether or not this toggle button is the first button in the list.
  bool get isFirstButton => _isFirstButton;
  bool _isFirstButton;
  set isFirstButton(bool value) {
    if (_isFirstButton == value) {
      return;
    }
    _isFirstButton = value;
    markNeedsLayout();
  }

  // Whether or not this toggle button is the last button in the list.
  bool get isLastButton => _isLastButton;
  bool _isLastButton;
  set isLastButton(bool value) {
    if (_isLastButton == value) {
      return;
    }
    _isLastButton = value;
    markNeedsLayout();
  }

  // The direction in which text flows for this application.
  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;
  set textDirection(TextDirection value) {
    if (_textDirection == value) {
      return;
    }
    _textDirection = value;
    markNeedsLayout();
  }

  static double _maxHeight(RenderBox? box, double width) => box?.getMaxIntrinsicHeight(width) ?? 0.0;

  static double _minHeight(RenderBox? box, double width) => box?.getMinIntrinsicHeight(width) ?? 0.0;

  static double _minWidth(RenderBox? box, double height) => box?.getMinIntrinsicWidth(height) ?? 0.0;

  static double _maxWidth(RenderBox? box, double height) => box?.getMaxIntrinsicWidth(height) ?? 0.0;

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) {
    // The baseline of this widget is the baseline of its child
    final BaselineOffset childOffset = BaselineOffset(child?.getDistanceToActualBaseline(baseline));
    return switch (direction) {
      Axis.horizontal => childOffset + borderSide.width,
      Axis.vertical => childOffset + leadingBorderSide.width,
    }.offset;
  }

  @override
  double computeMaxIntrinsicHeight(double width) =>
      direction == Axis.horizontal
          ? borderSide.width * 2.0 + _maxHeight(child, width)
          : leadingBorderSide.width + _maxHeight(child, width) + trailingBorderSide.width;

  @override
  double computeMinIntrinsicHeight(double width) =>
      direction == Axis.horizontal
          ? borderSide.width * 2.0 + _minHeight(child, width)
          : leadingBorderSide.width + _maxHeight(child, width) + trailingBorderSide.width;

  @override
  double computeMaxIntrinsicWidth(double height) =>
      direction == Axis.horizontal
          ? leadingBorderSide.width + _maxWidth(child, height) + trailingBorderSide.width
          : borderSide.width * 2.0 + _maxWidth(child, height);

  @override
  double computeMinIntrinsicWidth(double height) =>
      direction == Axis.horizontal
          ? leadingBorderSide.width + _minWidth(child, height) + trailingBorderSide.width
          : borderSide.width * 2.0 + _minWidth(child, height);

  @override
  Size computeDryLayout(BoxConstraints constraints) =>
      _computeSize(constraints: constraints, layoutChild: ChildLayoutHelper.dryLayoutChild);

  EdgeInsetsDirectional get _childPadding {
    assert(child != null);
    // It does not matter what [textDirection] or [verticalDirection] is,
    // since deflating the size constraints horizontally/vertically
    // and the returned size accounts for the width of both sides.
    return switch (direction) {
      Axis.horizontal => EdgeInsetsDirectional.only(
        start: leadingBorderSide.width,
        end: trailingBorderSide.width,
        top: borderSide.width,
        bottom: borderSide.width,
      ),
      Axis.vertical => EdgeInsetsDirectional.only(
        start: borderSide.width,
        end: borderSide.width,
        top: leadingBorderSide.width,
        bottom: trailingBorderSide.width,
      ),
    };
  }

  @override
  double? computeDryBaseline(BoxConstraints constraints, TextBaseline baseline) {
    final double? childBaseline = child?.getDryBaseline(constraints.deflate(_childPadding), baseline);
    if (childBaseline == null) {
      return null;
    }
    return childBaseline +
        switch (direction) {
          Axis.horizontal => borderSide.width,
          Axis.vertical => switch (verticalDirection) {
            VerticalDirection.down => leadingBorderSide.width,
            VerticalDirection.up => trailingBorderSide.width,
          },
        };
  }

  @override
  void performLayout() {
    size = _computeSize(constraints: constraints, layoutChild: ChildLayoutHelper.layoutChild);
    if (child == null) {
      return;
    }
    final BoxParentData childParentData = child!.parentData! as BoxParentData;
    if (direction == Axis.horizontal) {
      childParentData.offset = switch (textDirection) {
        TextDirection.ltr => Offset(leadingBorderSide.width, borderSide.width),
        TextDirection.rtl => Offset(trailingBorderSide.width, borderSide.width),
      };
    } else {
      childParentData.offset = switch (verticalDirection) {
        VerticalDirection.down => Offset(borderSide.width, leadingBorderSide.width),
        VerticalDirection.up => Offset(borderSide.width, trailingBorderSide.width),
      };
    }
  }

  Size _computeSize({required BoxConstraints constraints, required ChildLayouter layoutChild}) {
    final RenderBox? child = this.child;
    if (child == null) {
      final Size horizontalSize = Size(leadingBorderSide.width + trailingBorderSide.width, borderSide.width * 2.0);
      return switch (direction) {
        Axis.horizontal => constraints.constrain(horizontalSize),
        Axis.vertical => constraints.constrain(horizontalSize.flipped),
      };
    }

    final EdgeInsetsDirectional childPadding = _childPadding;
    final BoxConstraints innerConstraints = constraints.deflate(childPadding);
    return constraints.constrain(childPadding.inflateSize(layoutChild(child, innerConstraints)));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    final Offset bottomRight = size.bottomRight(offset);
    final Rect outer = Rect.fromLTRB(offset.dx, offset.dy, bottomRight.dx, bottomRight.dy);
    final Rect center = outer.deflate(borderSide.width / 2.0);
    const double sweepAngle = math.pi / 2.0;
    final RRect rrect =
        RRect.fromRectAndCorners(
          center,
          topLeft: (borderRadius.topLeft.x * borderRadius.topLeft.y != 0.0) ? borderRadius.topLeft : Radius.zero,
          topRight: (borderRadius.topRight.x * borderRadius.topRight.y != 0.0) ? borderRadius.topRight : Radius.zero,
          bottomLeft:
              (borderRadius.bottomLeft.x * borderRadius.bottomLeft.y != 0.0) ? borderRadius.bottomLeft : Radius.zero,
          bottomRight:
              (borderRadius.bottomRight.x * borderRadius.bottomRight.y != 0.0) ? borderRadius.bottomRight : Radius.zero,
        ).scaleRadii();

    final Rect tlCorner = Rect.fromLTWH(rrect.left, rrect.top, rrect.tlRadiusX * 2.0, rrect.tlRadiusY * 2.0);
    final Rect blCorner = Rect.fromLTWH(
      rrect.left,
      rrect.bottom - (rrect.blRadiusY * 2.0),
      rrect.blRadiusX * 2.0,
      rrect.blRadiusY * 2.0,
    );
    final Rect trCorner = Rect.fromLTWH(
      rrect.right - (rrect.trRadiusX * 2),
      rrect.top,
      rrect.trRadiusX * 2,
      rrect.trRadiusY * 2,
    );
    final Rect brCorner = Rect.fromLTWH(
      rrect.right - (rrect.brRadiusX * 2),
      rrect.bottom - (rrect.brRadiusY * 2),
      rrect.brRadiusX * 2,
      rrect.brRadiusY * 2,
    );

    final Paint leadingPaint = leadingBorderSide.toPaint();
    // Only one button.
    if (isFirstButton && isLastButton) {
      final Path leadingPath = Path();
      final double startX = (rrect.brRadiusX == 0.0) ? outer.right : rrect.right - rrect.brRadiusX;
      leadingPath
        ..moveTo(startX, rrect.bottom)
        ..lineTo(rrect.left + rrect.blRadiusX, rrect.bottom)
        ..addArc(blCorner, math.pi / 2.0, sweepAngle)
        ..lineTo(rrect.left, rrect.top + rrect.tlRadiusY)
        ..addArc(tlCorner, math.pi, sweepAngle)
        ..lineTo(rrect.right - rrect.trRadiusX, rrect.top)
        ..addArc(trCorner, math.pi * 3.0 / 2.0, sweepAngle)
        ..lineTo(rrect.right, rrect.bottom - rrect.brRadiusY)
        ..addArc(brCorner, 0, sweepAngle);
      context.canvas.drawPath(leadingPath, leadingPaint);
      return;
    }

    if (direction == Axis.horizontal) {
      switch (textDirection) {
        case TextDirection.ltr:
          if (isLastButton) {
            final Path leftPath = Path();
            leftPath
              ..moveTo(rrect.left, rrect.bottom + leadingBorderSide.width / 2)
              ..lineTo(rrect.left, rrect.top - leadingBorderSide.width / 2);
            context.canvas.drawPath(leftPath, leadingPaint);

            final Paint endingPaint = trailingBorderSide.toPaint();
            final Path endingPath = Path();
            endingPath
              ..moveTo(rrect.left + borderSide.width / 2.0, rrect.top)
              ..lineTo(rrect.right - rrect.trRadiusX, rrect.top)
              ..addArc(trCorner, math.pi * 3.0 / 2.0, sweepAngle)
              ..lineTo(rrect.right, rrect.bottom - rrect.brRadiusY)
              ..addArc(brCorner, 0, sweepAngle)
              ..lineTo(rrect.left + borderSide.width / 2.0, rrect.bottom);
            context.canvas.drawPath(endingPath, endingPaint);
          } else if (isFirstButton) {
            final Path leadingPath = Path();
            leadingPath
              ..moveTo(outer.right, rrect.bottom)
              ..lineTo(rrect.left + rrect.blRadiusX, rrect.bottom)
              ..addArc(blCorner, math.pi / 2.0, sweepAngle)
              ..lineTo(rrect.left, rrect.top + rrect.tlRadiusY)
              ..addArc(tlCorner, math.pi, sweepAngle)
              ..lineTo(outer.right, rrect.top);
            context.canvas.drawPath(leadingPath, leadingPaint);
          } else {
            final Path leadingPath = Path();
            leadingPath
              ..moveTo(rrect.left, rrect.bottom + leadingBorderSide.width / 2)
              ..lineTo(rrect.left, rrect.top - leadingBorderSide.width / 2);
            context.canvas.drawPath(leadingPath, leadingPaint);

            final Paint horizontalPaint = borderSide.toPaint();
            final Path horizontalPaths = Path();
            horizontalPaths
              ..moveTo(rrect.left + borderSide.width / 2.0, rrect.top)
              ..lineTo(outer.right - rrect.trRadiusX, rrect.top)
              ..moveTo(rrect.left + borderSide.width / 2.0 + rrect.tlRadiusX, rrect.bottom)
              ..lineTo(outer.right - rrect.trRadiusX, rrect.bottom);
            context.canvas.drawPath(horizontalPaths, horizontalPaint);
          }
        case TextDirection.rtl:
          if (isLastButton) {
            final Path leadingPath = Path();
            leadingPath
              ..moveTo(rrect.right, rrect.bottom + leadingBorderSide.width / 2)
              ..lineTo(rrect.right, rrect.top - leadingBorderSide.width / 2);
            context.canvas.drawPath(leadingPath, leadingPaint);

            final Paint endingPaint = trailingBorderSide.toPaint();
            final Path endingPath = Path();
            endingPath
              ..moveTo(rrect.right - borderSide.width / 2.0, rrect.top)
              ..lineTo(rrect.left + rrect.tlRadiusX, rrect.top)
              ..addArc(tlCorner, math.pi * 3.0 / 2.0, -sweepAngle)
              ..lineTo(rrect.left, rrect.bottom - rrect.blRadiusY)
              ..addArc(blCorner, math.pi, -sweepAngle)
              ..lineTo(rrect.right - borderSide.width / 2.0, rrect.bottom);
            context.canvas.drawPath(endingPath, endingPaint);
          } else if (isFirstButton) {
            final Path leadingPath = Path();
            leadingPath
              ..moveTo(outer.left, rrect.bottom)
              ..lineTo(rrect.right - rrect.brRadiusX, rrect.bottom)
              ..addArc(brCorner, math.pi / 2.0, -sweepAngle)
              ..lineTo(rrect.right, rrect.top + rrect.trRadiusY)
              ..addArc(trCorner, 0, -sweepAngle)
              ..lineTo(outer.left, rrect.top);
            context.canvas.drawPath(leadingPath, leadingPaint);
          } else {
            final Path leadingPath = Path();
            leadingPath
              ..moveTo(rrect.right, rrect.bottom + leadingBorderSide.width / 2)
              ..lineTo(rrect.right, rrect.top - leadingBorderSide.width / 2);
            context.canvas.drawPath(leadingPath, leadingPaint);

            final Paint horizontalPaint = borderSide.toPaint();
            final Path horizontalPaths = Path();
            horizontalPaths
              ..moveTo(rrect.right - borderSide.width / 2.0, rrect.top)
              ..lineTo(outer.left - rrect.tlRadiusX, rrect.top)
              ..moveTo(rrect.right - borderSide.width / 2.0 + rrect.trRadiusX, rrect.bottom)
              ..lineTo(outer.left - rrect.tlRadiusX, rrect.bottom);
            context.canvas.drawPath(horizontalPaths, horizontalPaint);
          }
      }
    } else {
      switch (verticalDirection) {
        case VerticalDirection.down:
          if (isLastButton) {
            final Path topPath = Path();
            topPath
              ..moveTo(outer.left, outer.top + leadingBorderSide.width / 2)
              ..lineTo(outer.right, outer.top + leadingBorderSide.width / 2);
            context.canvas.drawPath(topPath, leadingPaint);

            final Paint endingPaint = trailingBorderSide.toPaint();
            final Path endingPath = Path();
            endingPath
              ..moveTo(rrect.left, rrect.top + leadingBorderSide.width / 2.0)
              ..lineTo(rrect.left, rrect.bottom - rrect.blRadiusY)
              ..addArc(blCorner, math.pi * 3.0, -sweepAngle)
              ..lineTo(rrect.right - rrect.blRadiusX, rrect.bottom)
              ..addArc(brCorner, math.pi / 2.0, -sweepAngle)
              ..lineTo(rrect.right, rrect.top + leadingBorderSide.width / 2.0);
            context.canvas.drawPath(endingPath, endingPaint);
          } else if (isFirstButton) {
            final Path leadingPath = Path();
            leadingPath
              ..moveTo(rrect.left, outer.bottom)
              ..lineTo(rrect.left, rrect.top + rrect.tlRadiusX)
              ..addArc(tlCorner, math.pi, sweepAngle)
              ..lineTo(rrect.right - rrect.trRadiusX, rrect.top)
              ..addArc(trCorner, math.pi * 3.0 / 2.0, sweepAngle)
              ..lineTo(rrect.right, outer.bottom);
            context.canvas.drawPath(leadingPath, leadingPaint);
          } else {
            final Path topPath = Path();
            topPath
              ..moveTo(outer.left, outer.top + leadingBorderSide.width / 2)
              ..lineTo(outer.right, outer.top + leadingBorderSide.width / 2);
            context.canvas.drawPath(topPath, leadingPaint);

            final Paint paint = borderSide.toPaint();
            final Path paths = Path(); // Left and right borders.
            paths
              ..moveTo(rrect.left, outer.top + leadingBorderSide.width)
              ..lineTo(rrect.left, outer.bottom)
              ..moveTo(rrect.right, outer.top + leadingBorderSide.width)
              ..lineTo(rrect.right, outer.bottom);
            context.canvas.drawPath(paths, paint);
          }
        case VerticalDirection.up:
          if (isLastButton) {
            final Path bottomPath = Path();
            bottomPath
              ..moveTo(outer.left, outer.bottom - leadingBorderSide.width / 2.0)
              ..lineTo(outer.right, outer.bottom - leadingBorderSide.width / 2.0);
            context.canvas.drawPath(bottomPath, leadingPaint);

            final Paint endingPaint = trailingBorderSide.toPaint();
            final Path endingPath = Path();
            endingPath
              ..moveTo(rrect.left, rrect.bottom - leadingBorderSide.width / 2.0)
              ..lineTo(rrect.left, rrect.top + rrect.tlRadiusY)
              ..addArc(tlCorner, math.pi, sweepAngle)
              ..lineTo(rrect.right - rrect.trRadiusX, rrect.top)
              ..addArc(trCorner, math.pi * 3.0 / 2.0, sweepAngle)
              ..lineTo(rrect.right, rrect.bottom - leadingBorderSide.width / 2.0);
            context.canvas.drawPath(endingPath, endingPaint);
          } else if (isFirstButton) {
            final Path leadingPath = Path();
            leadingPath
              ..moveTo(rrect.left, outer.top)
              ..lineTo(rrect.left, rrect.bottom - rrect.blRadiusY)
              ..addArc(blCorner, math.pi, -sweepAngle)
              ..lineTo(rrect.right - rrect.brRadiusX, rrect.bottom)
              ..addArc(brCorner, math.pi / 2.0, -sweepAngle)
              ..lineTo(rrect.right, outer.top);
            context.canvas.drawPath(leadingPath, leadingPaint);
          } else {
            final Path bottomPath = Path();
            bottomPath
              ..moveTo(outer.left, outer.bottom - leadingBorderSide.width / 2.0)
              ..lineTo(outer.right, outer.bottom - leadingBorderSide.width / 2.0);
            context.canvas.drawPath(bottomPath, leadingPaint);

            final Paint paint = borderSide.toPaint();
            final Path paths = Path(); // Left and right borders.
            paths
              ..moveTo(rrect.left, outer.top)
              ..lineTo(rrect.left, outer.bottom - leadingBorderSide.width)
              ..moveTo(rrect.right, outer.top)
              ..lineTo(rrect.right, outer.bottom - leadingBorderSide.width);
            context.canvas.drawPath(paths, paint);
          }
      }
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<Axis>('direction', direction));
    properties.add(EnumProperty<VerticalDirection>('verticalDirection', verticalDirection));
    properties.add(DiagnosticsProperty<BorderSide>('leadingBorderSide', leadingBorderSide));
    properties.add(DiagnosticsProperty<BorderSide>('borderSide', borderSide));
    properties.add(DiagnosticsProperty<BorderSide>('trailingBorderSide', trailingBorderSide));
    properties.add(DiagnosticsProperty<BorderRadius>('borderRadius', borderRadius));
    properties.add(DiagnosticsProperty<bool>('isFirstButton', isFirstButton));
    properties.add(DiagnosticsProperty<bool>('isLastButton', isLastButton));
    properties.add(EnumProperty<TextDirection>('textDirection', textDirection));
  }
}

class _InputPadding extends SingleChildRenderObjectWidget {
  const _InputPadding({required this.minSize, required this.direction, super.child});

  final Size minSize;
  final Axis direction;

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderInputPadding(minSize, direction);

  @override
  void updateRenderObject(BuildContext context, covariant _RenderInputPadding renderObject) {
    renderObject.minSize = minSize;
    renderObject.direction = direction;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Size>('minSize', minSize));
    properties.add(EnumProperty<Axis>('direction', direction));
  }
}

class _RenderInputPadding extends RenderShiftedBox {
  _RenderInputPadding(this._minSize, this._direction, [RenderBox? child]) : super(child);

  Size get minSize => _minSize;
  Size _minSize;
  set minSize(Size value) {
    if (_minSize == value) {
      return;
    }
    _minSize = value;
    markNeedsLayout();
  }

  Axis get direction => _direction;
  Axis _direction;
  set direction(Axis value) {
    if (_direction == value) {
      return;
    }
    _direction = value;
    markNeedsLayout();
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    if (child != null) {
      return math.max(child!.getMinIntrinsicWidth(height), minSize.width);
    }
    return 0.0;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    if (child != null) {
      return math.max(child!.getMinIntrinsicHeight(width), minSize.height);
    }
    return 0.0;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    if (child != null) {
      return math.max(child!.getMaxIntrinsicWidth(height), minSize.width);
    }
    return 0.0;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    if (child != null) {
      return math.max(child!.getMaxIntrinsicHeight(width), minSize.height);
    }
    return 0.0;
  }

  Size _computeSize({required BoxConstraints constraints, required ChildLayouter layoutChild}) {
    if (child != null) {
      final Size childSize = layoutChild(child!, constraints);
      final double height = math.max(childSize.width, minSize.width);
      final double width = math.max(childSize.height, minSize.height);
      return constraints.constrain(Size(height, width));
    }
    return Size.zero;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) =>
      _computeSize(constraints: constraints, layoutChild: ChildLayoutHelper.dryLayoutChild);

  @override
  double? computeDryBaseline(covariant BoxConstraints constraints, TextBaseline baseline) {
    final RenderBox? child = this.child;
    if (child == null) {
      return null;
    }
    final double? result = child.getDryBaseline(constraints, baseline);
    if (result == null) {
      return null;
    }
    final Size childSize = child.getDryLayout(constraints);
    return result + Alignment.center.alongOffset(getDryLayout(constraints) - childSize as Offset).dy;
  }

  @override
  void performLayout() {
    size = _computeSize(constraints: constraints, layoutChild: ChildLayoutHelper.layoutChild);
    if (child != null) {
      final BoxParentData childParentData = child!.parentData! as BoxParentData;
      childParentData.offset = Alignment.center.alongOffset(size - child!.size as Offset);
    }
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    // The super.hitTest() method also checks hitTestChildren(). We don't
    // want that in this case because we've padded around the children per
    // tapTargetSize.
    if (!size.contains(position)) {
      return false;
    }

    // Only adjust one axis to ensure the correct button is tapped.
    final Offset center = switch (direction) {
      Axis.horizontal => Offset(position.dx, child!.size.height / 2),
      Axis.vertical => Offset(child!.size.width / 2, position.dy),
    };
    return result.addWithRawTransform(
      transform: MatrixUtils.forceToPoint(center),
      position: center,
      hitTest: (result, position) {
        assert(position == center);
        return child!.hitTest(result, position: center);
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Size>('minSize', minSize));
    properties.add(EnumProperty<Axis>('direction', direction));
  }
}
