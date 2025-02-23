// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/button_style.dart';
import 'package:waveui/material/button_style_button.dart';
import 'package:waveui/material/color_scheme.dart';
import 'package:waveui/material/colors.dart';
import 'package:waveui/material/constants.dart';
import 'package:waveui/material/icon_button_theme.dart';
import 'package:waveui/material/ink_well.dart';
import 'package:waveui/material/theme.dart';
import 'package:waveui/material/theme_data.dart';

// Examples can assume:
// late BuildContext context;

// Minimum logical pixel size of the IconButton.
// See: <https://material.io/design/usability/accessibility.html#layout-typography>.
const double _kMinButtonSize = kMinInteractiveDimension;

enum _IconButtonVariant { standard, filled, filledTonal, outlined }

class IconButton extends StatelessWidget {
  const IconButton({
    required this.onPressed,
    required this.icon,
    super.key,
    this.iconSize,
    this.visualDensity,
    this.padding,
    this.alignment,
    this.splashRadius,
    this.color,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.splashColor,
    this.disabledColor,
    this.onHover,
    this.onLongPress,
    this.mouseCursor,
    this.focusNode,
    this.autofocus = false,
    this.tooltip,
    this.enableFeedback,
    this.constraints,
    this.style,
    this.isSelected,
    this.selectedIcon,
  }) : assert(splashRadius == null || splashRadius > 0),
       _variant = _IconButtonVariant.standard;

  const IconButton.filled({
    required this.onPressed,
    required this.icon,
    super.key,
    this.iconSize,
    this.visualDensity,
    this.padding,
    this.alignment,
    this.splashRadius,
    this.color,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.splashColor,
    this.disabledColor,
    this.onHover,
    this.onLongPress,
    this.mouseCursor,
    this.focusNode,
    this.autofocus = false,
    this.tooltip,
    this.enableFeedback,
    this.constraints,
    this.style,
    this.isSelected,
    this.selectedIcon,
  }) : assert(splashRadius == null || splashRadius > 0),
       _variant = _IconButtonVariant.filled;

  const IconButton.filledTonal({
    required this.onPressed,
    required this.icon,
    super.key,
    this.iconSize,
    this.visualDensity,
    this.padding,
    this.alignment,
    this.splashRadius,
    this.color,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.splashColor,
    this.disabledColor,
    this.onHover,
    this.onLongPress,
    this.mouseCursor,
    this.focusNode,
    this.autofocus = false,
    this.tooltip,
    this.enableFeedback,
    this.constraints,
    this.style,
    this.isSelected,
    this.selectedIcon,
  }) : assert(splashRadius == null || splashRadius > 0),
       _variant = _IconButtonVariant.filledTonal;

  const IconButton.outlined({
    required this.onPressed,
    required this.icon,
    super.key,
    this.iconSize,
    this.visualDensity,
    this.padding,
    this.alignment,
    this.splashRadius,
    this.color,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.splashColor,
    this.disabledColor,
    this.onHover,
    this.onLongPress,
    this.mouseCursor,
    this.focusNode,
    this.autofocus = false,
    this.tooltip,
    this.enableFeedback,
    this.constraints,
    this.style,
    this.isSelected,
    this.selectedIcon,
  }) : assert(splashRadius == null || splashRadius > 0),
       _variant = _IconButtonVariant.outlined;

  final double? iconSize;

  final VisualDensity? visualDensity;

  final EdgeInsetsGeometry? padding;

  final AlignmentGeometry? alignment;

  final double? splashRadius;

  final Widget icon;

  final Color? focusColor;

  final Color? hoverColor;

  final Color? color;

  final Color? splashColor;

  final Color? highlightColor;

  final Color? disabledColor;

  final VoidCallback? onPressed;

  final ValueChanged<bool>? onHover;

  final VoidCallback? onLongPress;

  final MouseCursor? mouseCursor;

  final FocusNode? focusNode;

  final bool autofocus;

  final String? tooltip;

  final bool? enableFeedback;

  final BoxConstraints? constraints;

  final ButtonStyle? style;

  final bool? isSelected;

  final Widget? selectedIcon;

  final _IconButtonVariant _variant;

  static ButtonStyle styleFrom({
    Color? foregroundColor,
    Color? backgroundColor,
    Color? disabledForegroundColor,
    Color? disabledBackgroundColor,
    Color? focusColor,
    Color? hoverColor,
    Color? highlightColor,
    Color? shadowColor,
    Color? surfaceTintColor,
    Color? overlayColor,
    double? elevation,
    Size? minimumSize,
    Size? fixedSize,
    Size? maximumSize,
    double? iconSize,
    BorderSide? side,
    OutlinedBorder? shape,
    EdgeInsetsGeometry? padding,
    MouseCursor? enabledMouseCursor,
    MouseCursor? disabledMouseCursor,
    VisualDensity? visualDensity,
    MaterialTapTargetSize? tapTargetSize,
    Duration? animationDuration,
    bool? enableFeedback,
    AlignmentGeometry? alignment,
    InteractiveInkFeatureFactory? splashFactory,
  }) {
    final Color? overlayFallback = overlayColor ?? foregroundColor;
    WidgetStateProperty<Color?>? overlayColorProp;
    if ((hoverColor ?? focusColor ?? highlightColor ?? overlayFallback) != null) {
      overlayColorProp = switch (overlayColor) {
        Color(a: 0.0) => WidgetStatePropertyAll<Color>(overlayColor),
        _ => WidgetStateProperty<Color?>.fromMap(<WidgetState, Color?>{
          WidgetState.pressed: highlightColor ?? overlayFallback?.withValues(alpha: 0.1),
          WidgetState.hovered: hoverColor ?? overlayFallback?.withValues(alpha: 0.08),
          WidgetState.focused: focusColor ?? overlayFallback?.withValues(alpha: 0.1),
        }),
      };
    }

    return ButtonStyle(
      backgroundColor: ButtonStyleButton.defaultColor(backgroundColor, disabledBackgroundColor),
      foregroundColor: ButtonStyleButton.defaultColor(foregroundColor, disabledForegroundColor),
      overlayColor: overlayColorProp,
      shadowColor: ButtonStyleButton.allOrNull<Color>(shadowColor),
      surfaceTintColor: ButtonStyleButton.allOrNull<Color>(surfaceTintColor),
      elevation: ButtonStyleButton.allOrNull<double>(elevation),
      padding: ButtonStyleButton.allOrNull<EdgeInsetsGeometry>(padding),
      minimumSize: ButtonStyleButton.allOrNull<Size>(minimumSize),
      fixedSize: ButtonStyleButton.allOrNull<Size>(fixedSize),
      maximumSize: ButtonStyleButton.allOrNull<Size>(maximumSize),
      iconSize: ButtonStyleButton.allOrNull<double>(iconSize),
      side: ButtonStyleButton.allOrNull<BorderSide>(side),
      shape: ButtonStyleButton.allOrNull<OutlinedBorder>(shape),
      mouseCursor: WidgetStateProperty<MouseCursor?>.fromMap(<WidgetStatesConstraint, MouseCursor?>{
        WidgetState.disabled: disabledMouseCursor,
        WidgetState.any: enabledMouseCursor,
      }),
      visualDensity: visualDensity,
      tapTargetSize: tapTargetSize,
      animationDuration: animationDuration,
      enableFeedback: enableFeedback,
      alignment: alignment,
      splashFactory: splashFactory,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final Size? minSize = constraints == null ? null : Size(constraints!.minWidth, constraints!.minHeight);
    final Size? maxSize = constraints == null ? null : Size(constraints!.maxWidth, constraints!.maxHeight);

    ButtonStyle adjustedStyle = styleFrom(
      visualDensity: visualDensity,
      foregroundColor: color,
      disabledForegroundColor: disabledColor,
      focusColor: focusColor,
      hoverColor: hoverColor,
      highlightColor: highlightColor,
      padding: padding,
      minimumSize: minSize,
      maximumSize: maxSize,
      iconSize: iconSize,
      alignment: alignment,
      enabledMouseCursor: mouseCursor,
      disabledMouseCursor: mouseCursor,
      enableFeedback: enableFeedback,
    );
    if (style != null) {
      adjustedStyle = style!.merge(adjustedStyle);
    }

    Widget effectiveIcon = icon;
    if ((isSelected ?? false) && selectedIcon != null) {
      effectiveIcon = selectedIcon!;
    }

    return _SelectableIconButton(
      style: adjustedStyle,
      onPressed: onPressed,
      onHover: onHover,
      onLongPress: onPressed != null ? onLongPress : null,
      autofocus: autofocus,
      focusNode: focusNode,
      isSelected: isSelected,
      variant: _variant,
      tooltip: tooltip,
      child: effectiveIcon,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('tooltip', tooltip, defaultValue: null, quoted: false));
    properties.add(ObjectFlagProperty<VoidCallback>('onPressed', onPressed, ifNull: 'disabled'));
    properties.add(ObjectFlagProperty<ValueChanged<bool>>('onHover', onHover, ifNull: 'disabled'));
    properties.add(ObjectFlagProperty<VoidCallback>('onLongPress', onLongPress, ifNull: 'disabled'));
    properties.add(ColorProperty('color', color, defaultValue: null));
    properties.add(ColorProperty('disabledColor', disabledColor, defaultValue: null));
    properties.add(ColorProperty('focusColor', focusColor, defaultValue: null));
    properties.add(ColorProperty('hoverColor', hoverColor, defaultValue: null));
    properties.add(ColorProperty('highlightColor', highlightColor, defaultValue: null));
    properties.add(ColorProperty('splashColor', splashColor, defaultValue: null));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding, defaultValue: null));
    properties.add(DiagnosticsProperty<FocusNode>('focusNode', focusNode, defaultValue: null));
    properties.add(DoubleProperty('iconSize', iconSize));
    properties.add(DiagnosticsProperty<VisualDensity?>('visualDensity', visualDensity));
    properties.add(DiagnosticsProperty<AlignmentGeometry?>('alignment', alignment));
    properties.add(DoubleProperty('splashRadius', splashRadius));
    properties.add(DiagnosticsProperty<MouseCursor?>('mouseCursor', mouseCursor));
    properties.add(DiagnosticsProperty<bool>('autofocus', autofocus));
    properties.add(DiagnosticsProperty<bool?>('enableFeedback', enableFeedback));
    properties.add(DiagnosticsProperty<BoxConstraints?>('constraints', constraints));
    properties.add(DiagnosticsProperty<ButtonStyle?>('style', style));
    properties.add(DiagnosticsProperty<bool?>('isSelected', isSelected));
  }
}

class _SelectableIconButton extends StatefulWidget {
  const _SelectableIconButton({
    required this.variant,
    required this.autofocus,
    required this.onPressed,
    required this.child,
    this.isSelected,
    this.style,
    this.focusNode,
    this.onLongPress,
    this.onHover,
    this.tooltip,
  });

  final bool? isSelected;
  final ButtonStyle? style;
  final FocusNode? focusNode;
  final _IconButtonVariant variant;
  final bool autofocus;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Widget child;
  final VoidCallback? onLongPress;
  final ValueChanged<bool>? onHover;

  @override
  State<_SelectableIconButton> createState() => _SelectableIconButtonState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool?>('isSelected', isSelected));
    properties.add(DiagnosticsProperty<ButtonStyle?>('style', style));
    properties.add(DiagnosticsProperty<FocusNode?>('focusNode', focusNode));
    properties.add(EnumProperty<_IconButtonVariant>('variant', variant));
    properties.add(DiagnosticsProperty<bool>('autofocus', autofocus));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onPressed', onPressed));
    properties.add(StringProperty('tooltip', tooltip));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onLongPress', onLongPress));
    properties.add(ObjectFlagProperty<ValueChanged<bool>?>.has('onHover', onHover));
  }
}

class _SelectableIconButtonState extends State<_SelectableIconButton> {
  late final WidgetStatesController statesController;

  @override
  void initState() {
    super.initState();
    if (widget.isSelected == null) {
      statesController = WidgetStatesController();
    } else {
      statesController = WidgetStatesController(<WidgetState>{if (widget.isSelected!) WidgetState.selected});
    }
  }

  @override
  void didUpdateWidget(_SelectableIconButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected == null) {
      if (statesController.value.contains(WidgetState.selected)) {
        statesController.update(WidgetState.selected, false);
      }
      return;
    }
    if (widget.isSelected != oldWidget.isSelected) {
      statesController.update(WidgetState.selected, widget.isSelected!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool toggleable = widget.isSelected != null;

    return _IconButtonM3(
      statesController: statesController,
      style: widget.style,
      autofocus: widget.autofocus,
      focusNode: widget.focusNode,
      onPressed: widget.onPressed,
      onHover: widget.onHover,
      onLongPress: widget.onPressed != null ? widget.onLongPress : null,
      variant: widget.variant,
      toggleable: toggleable,
      tooltip: widget.tooltip,
      child: Semantics(selected: widget.isSelected, child: widget.child),
    );
  }

  @override
  void dispose() {
    statesController.dispose();
    super.dispose();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<WidgetStatesController>('statesController', statesController));
  }
}

class _IconButtonM3 extends ButtonStyleButton {
  const _IconButtonM3({
    required super.onPressed,
    required this.variant,
    required this.toggleable,
    required Widget super.child,
    super.style,
    super.focusNode,
    super.onHover,
    super.onLongPress,
    super.autofocus = false,
    super.statesController,
    super.tooltip,
  }) : super(onFocusChange: null, clipBehavior: Clip.none);

  final _IconButtonVariant variant;
  final bool toggleable;

  @override
  ButtonStyle defaultStyleOf(BuildContext context) => switch (variant) {
    _IconButtonVariant.filled => _FilledIconButtonDefaultsM3(context, toggleable),
    _IconButtonVariant.filledTonal => _FilledTonalIconButtonDefaultsM3(context, toggleable),
    _IconButtonVariant.outlined => _OutlinedIconButtonDefaultsM3(context, toggleable),
    _IconButtonVariant.standard => _IconButtonDefaultsM3(context, toggleable),
  };

  @override
  ButtonStyle? themeStyleOf(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);
    final bool isDefaultSize = iconTheme.size == const IconThemeData.fallback().size;
    final bool isDefaultColor = identical(iconTheme.color, switch (Theme.of(context).brightness) {
      Brightness.light => kDefaultIconDarkColor,
      Brightness.dark => kDefaultIconLightColor,
    });

    final ButtonStyle iconThemeStyle = IconButton.styleFrom(
      foregroundColor: isDefaultColor ? null : iconTheme.color,
      iconSize: isDefaultSize ? null : iconTheme.size,
    );

    return IconButtonTheme.of(context).style?.merge(iconThemeStyle) ?? iconThemeStyle;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<_IconButtonVariant>('variant', variant));
    properties.add(DiagnosticsProperty<bool>('toggleable', toggleable));
  }
}

// BEGIN GENERATED TOKEN PROPERTIES - IconButton

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// dart format off
class _IconButtonDefaultsM3 extends ButtonStyle {
  _IconButtonDefaultsM3(this.context, this.toggleable)
    : super(
        animationDuration: kThemeChangeDuration,
        enableFeedback: true,
        alignment: Alignment.center,
      );

  final BuildContext context;
  final bool toggleable;
  late final ColorScheme _colors = Theme.of(context).colorScheme;

  // No default text style

  @override
  WidgetStateProperty<Color?>? get backgroundColor =>
    const WidgetStatePropertyAll<Color?>(Colors.transparent);

  @override
  WidgetStateProperty<Color?>? get foregroundColor =>
    WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return _colors.onSurface.withValues(alpha:0.38);
      }
      if (states.contains(WidgetState.selected)) {
        return _colors.primary;
      }
      return _colors.onSurfaceVariant;
    });

 @override
  WidgetStateProperty<Color?>? get overlayColor =>
    WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        if (states.contains(WidgetState.pressed)) {
          return _colors.primary.withValues(alpha:0.1);
        }
        if (states.contains(WidgetState.hovered)) {
          return _colors.primary.withValues(alpha:0.08);
        }
        if (states.contains(WidgetState.focused)) {
          return _colors.primary.withValues(alpha:0.1);
        }
      }
      if (states.contains(WidgetState.pressed)) {
        return _colors.onSurfaceVariant.withValues(alpha:0.1);
      }
      if (states.contains(WidgetState.hovered)) {
        return _colors.onSurfaceVariant.withValues(alpha:0.08);
      }
      if (states.contains(WidgetState.focused)) {
        return _colors.onSurfaceVariant.withValues(alpha:0.1);
      }
      return Colors.transparent;
    });

  @override
  WidgetStateProperty<double>? get elevation =>
    const WidgetStatePropertyAll<double>(0.0);

  @override
  WidgetStateProperty<Color>? get shadowColor =>
    const WidgetStatePropertyAll<Color>(Colors.transparent);

  @override
  WidgetStateProperty<Color>? get surfaceTintColor =>
    const WidgetStatePropertyAll<Color>(Colors.transparent);

  @override
  WidgetStateProperty<EdgeInsetsGeometry>? get padding =>
    const WidgetStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.all(8.0));

  @override
  WidgetStateProperty<Size>? get minimumSize =>
    const WidgetStatePropertyAll<Size>(Size(40.0, 40.0));

  // No default fixedSize

  @override
  WidgetStateProperty<Size>? get maximumSize =>
    const WidgetStatePropertyAll<Size>(Size.infinite);

  @override
  WidgetStateProperty<double>? get iconSize =>
    const WidgetStatePropertyAll<double>(24.0);

  @override
  WidgetStateProperty<BorderSide?>? get side => null;

  @override
  WidgetStateProperty<OutlinedBorder>? get shape =>
    const WidgetStatePropertyAll<OutlinedBorder>(StadiumBorder());

  @override
  WidgetStateProperty<MouseCursor?>? get mouseCursor =>
    WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return SystemMouseCursors.basic;
      }
      return SystemMouseCursors.click;
    });

  @override
  VisualDensity? get visualDensity => VisualDensity.standard;

  @override
  MaterialTapTargetSize? get tapTargetSize => Theme.of(context).materialTapTargetSize;

  @override
  InteractiveInkFeatureFactory? get splashFactory => Theme.of(context).splashFactory;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BuildContext>('context', context));
    properties.add(DiagnosticsProperty<bool>('toggleable', toggleable));
  }
}
// dart format on

// END GENERATED TOKEN PROPERTIES - IconButton

// BEGIN GENERATED TOKEN PROPERTIES - FilledIconButton

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// dart format off
class _FilledIconButtonDefaultsM3 extends ButtonStyle {
  _FilledIconButtonDefaultsM3(this.context, this.toggleable)
    : super(
        animationDuration: kThemeChangeDuration,
        enableFeedback: true,
        alignment: Alignment.center,
      );

  final BuildContext context;
  final bool toggleable;
  late final ColorScheme _colors = Theme.of(context).colorScheme;

  // No default text style

  @override
  WidgetStateProperty<Color?>? get backgroundColor =>
    WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return _colors.onSurface.withValues(alpha:0.12);
      }
      if (states.contains(WidgetState.selected)) {
        return _colors.primary;
      }
      if (toggleable) { // toggleable but unselected case
        return _colors.surfaceContainerHighest;
      }
      return _colors.primary;
    });

  @override
  WidgetStateProperty<Color?>? get foregroundColor =>
    WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return _colors.onSurface.withValues(alpha:0.38);
      }
      if (states.contains(WidgetState.selected)) {
        return _colors.onPrimary;
      }
      if (toggleable) { // toggleable but unselected case
        return _colors.primary;
      }
      return _colors.onPrimary;
    });

 @override
  WidgetStateProperty<Color?>? get overlayColor =>
    WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        if (states.contains(WidgetState.pressed)) {
          return _colors.onPrimary.withValues(alpha:0.1);
        }
        if (states.contains(WidgetState.hovered)) {
          return _colors.onPrimary.withValues(alpha:0.08);
        }
        if (states.contains(WidgetState.focused)) {
          return _colors.onPrimary.withValues(alpha:0.1);
        }
      }
      if (toggleable) { // toggleable but unselected case
        if (states.contains(WidgetState.pressed)) {
          return _colors.primary.withValues(alpha:0.1);
        }
        if (states.contains(WidgetState.hovered)) {
          return _colors.primary.withValues(alpha:0.08);
        }
        if (states.contains(WidgetState.focused)) {
          return _colors.primary.withValues(alpha:0.1);
        }
      }
      if (states.contains(WidgetState.pressed)) {
        return _colors.onPrimary.withValues(alpha:0.1);
      }
      if (states.contains(WidgetState.hovered)) {
        return _colors.onPrimary.withValues(alpha:0.08);
      }
      if (states.contains(WidgetState.focused)) {
        return _colors.onPrimary.withValues(alpha:0.1);
      }
      return Colors.transparent;
    });

  @override
  WidgetStateProperty<double>? get elevation =>
    const WidgetStatePropertyAll<double>(0.0);

  @override
  WidgetStateProperty<Color>? get shadowColor =>
    const WidgetStatePropertyAll<Color>(Colors.transparent);

  @override
  WidgetStateProperty<Color>? get surfaceTintColor =>
    const WidgetStatePropertyAll<Color>(Colors.transparent);

  @override
  WidgetStateProperty<EdgeInsetsGeometry>? get padding =>
    const WidgetStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.all(8.0));

  @override
  WidgetStateProperty<Size>? get minimumSize =>
    const WidgetStatePropertyAll<Size>(Size(40.0, 40.0));

  // No default fixedSize

  @override
  WidgetStateProperty<Size>? get maximumSize =>
    const WidgetStatePropertyAll<Size>(Size.infinite);

  @override
  WidgetStateProperty<double>? get iconSize =>
    const WidgetStatePropertyAll<double>(24.0);

  @override
  WidgetStateProperty<BorderSide?>? get side => null;

  @override
  WidgetStateProperty<OutlinedBorder>? get shape =>
    const WidgetStatePropertyAll<OutlinedBorder>(StadiumBorder());

  @override
  WidgetStateProperty<MouseCursor?>? get mouseCursor =>
    WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return SystemMouseCursors.basic;
      }
      return SystemMouseCursors.click;
    });

  @override
  VisualDensity? get visualDensity => VisualDensity.standard;

  @override
  MaterialTapTargetSize? get tapTargetSize => Theme.of(context).materialTapTargetSize;

  @override
  InteractiveInkFeatureFactory? get splashFactory => Theme.of(context).splashFactory;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BuildContext>('context', context));
    properties.add(DiagnosticsProperty<bool>('toggleable', toggleable));
  }
}
// dart format on

// END GENERATED TOKEN PROPERTIES - FilledIconButton

// BEGIN GENERATED TOKEN PROPERTIES - FilledTonalIconButton

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// dart format off
class _FilledTonalIconButtonDefaultsM3 extends ButtonStyle {
  _FilledTonalIconButtonDefaultsM3(this.context, this.toggleable)
    : super(
        animationDuration: kThemeChangeDuration,
        enableFeedback: true,
        alignment: Alignment.center,
      );

  final BuildContext context;
  final bool toggleable;
  late final ColorScheme _colors = Theme.of(context).colorScheme;

  // No default text style

  @override
  WidgetStateProperty<Color?>? get backgroundColor =>
    WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return _colors.onSurface.withValues(alpha:0.12);
      }
      if (states.contains(WidgetState.selected)) {
        return _colors.secondaryContainer;
      }
      if (toggleable) { // toggleable but unselected case
        return _colors.surfaceContainerHighest;
      }
      return _colors.secondaryContainer;
    });

  @override
  WidgetStateProperty<Color?>? get foregroundColor =>
    WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return _colors.onSurface.withValues(alpha:0.38);
      }
      if (states.contains(WidgetState.selected)) {
        return _colors.onSecondaryContainer;
      }
      if (toggleable) { // toggleable but unselected case
        return _colors.onSurfaceVariant;
      }
      return _colors.onSecondaryContainer;
    });

 @override
  WidgetStateProperty<Color?>? get overlayColor =>
    WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        if (states.contains(WidgetState.pressed)) {
          return _colors.onSecondaryContainer.withValues(alpha:0.1);
        }
        if (states.contains(WidgetState.hovered)) {
          return _colors.onSecondaryContainer.withValues(alpha:0.08);
        }
        if (states.contains(WidgetState.focused)) {
          return _colors.onSecondaryContainer.withValues(alpha:0.1);
        }
      }
      if (toggleable) { // toggleable but unselected case
        if (states.contains(WidgetState.pressed)) {
          return _colors.onSurfaceVariant.withValues(alpha:0.1);
        }
        if (states.contains(WidgetState.hovered)) {
          return _colors.onSurfaceVariant.withValues(alpha:0.08);
        }
        if (states.contains(WidgetState.focused)) {
          return _colors.onSurfaceVariant.withValues(alpha:0.1);
        }
      }
      if (states.contains(WidgetState.pressed)) {
        return _colors.onSecondaryContainer.withValues(alpha:0.1);
      }
      if (states.contains(WidgetState.hovered)) {
        return _colors.onSecondaryContainer.withValues(alpha:0.08);
      }
      if (states.contains(WidgetState.focused)) {
        return _colors.onSecondaryContainer.withValues(alpha:0.1);
      }
      return Colors.transparent;
    });

  @override
  WidgetStateProperty<double>? get elevation =>
    const WidgetStatePropertyAll<double>(0.0);

  @override
  WidgetStateProperty<Color>? get shadowColor =>
    const WidgetStatePropertyAll<Color>(Colors.transparent);

  @override
  WidgetStateProperty<Color>? get surfaceTintColor =>
    const WidgetStatePropertyAll<Color>(Colors.transparent);

  @override
  WidgetStateProperty<EdgeInsetsGeometry>? get padding =>
    const WidgetStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.all(8.0));

  @override
  WidgetStateProperty<Size>? get minimumSize =>
    const WidgetStatePropertyAll<Size>(Size(40.0, 40.0));

  // No default fixedSize

  @override
  WidgetStateProperty<Size>? get maximumSize =>
    const WidgetStatePropertyAll<Size>(Size.infinite);

  @override
  WidgetStateProperty<double>? get iconSize =>
    const WidgetStatePropertyAll<double>(24.0);

  @override
  WidgetStateProperty<BorderSide?>? get side => null;

  @override
  WidgetStateProperty<OutlinedBorder>? get shape =>
    const WidgetStatePropertyAll<OutlinedBorder>(StadiumBorder());

  @override
  WidgetStateProperty<MouseCursor?>? get mouseCursor =>
    WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return SystemMouseCursors.basic;
      }
      return SystemMouseCursors.click;
    });

  @override
  VisualDensity? get visualDensity => VisualDensity.standard;

  @override
  MaterialTapTargetSize? get tapTargetSize => Theme.of(context).materialTapTargetSize;

  @override
  InteractiveInkFeatureFactory? get splashFactory => Theme.of(context).splashFactory;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BuildContext>('context', context));
    properties.add(DiagnosticsProperty<bool>('toggleable', toggleable));
  }
}
// dart format on

// END GENERATED TOKEN PROPERTIES - FilledTonalIconButton

// BEGIN GENERATED TOKEN PROPERTIES - OutlinedIconButton

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// dart format off
class _OutlinedIconButtonDefaultsM3 extends ButtonStyle {
  _OutlinedIconButtonDefaultsM3(this.context, this.toggleable)
    : super(
        animationDuration: kThemeChangeDuration,
        enableFeedback: true,
        alignment: Alignment.center,
      );

  final BuildContext context;
  final bool toggleable;
  late final ColorScheme _colors = Theme.of(context).colorScheme;

  // No default text style

  @override
  WidgetStateProperty<Color?>? get backgroundColor =>
    WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        if (states.contains(WidgetState.selected)) {
          return _colors.onSurface.withValues(alpha:0.12);
        }
        return Colors.transparent;
      }
      if (states.contains(WidgetState.selected)) {
        return _colors.inverseSurface;
      }
      return Colors.transparent;
    });

  @override
  WidgetStateProperty<Color?>? get foregroundColor =>
    WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return _colors.onSurface.withValues(alpha:0.38);
      }
      if (states.contains(WidgetState.selected)) {
        return _colors.onInverseSurface;
      }
      return _colors.onSurfaceVariant;
    });

 @override
  WidgetStateProperty<Color?>? get overlayColor =>    WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        if (states.contains(WidgetState.pressed)) {
          return _colors.onInverseSurface.withValues(alpha:0.1);
        }
        if (states.contains(WidgetState.hovered)) {
          return _colors.onInverseSurface.withValues(alpha:0.08);
        }
        if (states.contains(WidgetState.focused)) {
          return _colors.onInverseSurface.withValues(alpha:0.08);
        }
      }
      if (states.contains(WidgetState.pressed)) {
        return _colors.onSurface.withValues(alpha:0.1);
      }
      if (states.contains(WidgetState.hovered)) {
        return _colors.onSurfaceVariant.withValues(alpha:0.08);
      }
      if (states.contains(WidgetState.focused)) {
        return _colors.onSurfaceVariant.withValues(alpha:0.08);
      }
      return Colors.transparent;
    });

  @override
  WidgetStateProperty<double>? get elevation =>
    const WidgetStatePropertyAll<double>(0.0);

  @override
  WidgetStateProperty<Color>? get shadowColor =>
    const WidgetStatePropertyAll<Color>(Colors.transparent);

  @override
  WidgetStateProperty<Color>? get surfaceTintColor =>
    const WidgetStatePropertyAll<Color>(Colors.transparent);

  @override
  WidgetStateProperty<EdgeInsetsGeometry>? get padding =>
    const WidgetStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.all(8.0));

  @override
  WidgetStateProperty<Size>? get minimumSize =>
    const WidgetStatePropertyAll<Size>(Size(40.0, 40.0));

  // No default fixedSize

  @override
  WidgetStateProperty<Size>? get maximumSize =>
    const WidgetStatePropertyAll<Size>(Size.infinite);

  @override
  WidgetStateProperty<double>? get iconSize =>
    const WidgetStatePropertyAll<double>(24.0);

  @override
  WidgetStateProperty<BorderSide?>? get side =>
    WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return null;
      } else {
        if (states.contains(WidgetState.disabled)) {
          return BorderSide(color: _colors.onSurface.withValues(alpha:0.12));
        }
        return BorderSide(color: _colors.outline);
      }
    });

  @override
  WidgetStateProperty<OutlinedBorder>? get shape =>
    const WidgetStatePropertyAll<OutlinedBorder>(StadiumBorder());

  @override
  WidgetStateProperty<MouseCursor?>? get mouseCursor =>
    WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return SystemMouseCursors.basic;
      }
      return SystemMouseCursors.click;
    });

  @override
  VisualDensity? get visualDensity => VisualDensity.standard;

  @override
  MaterialTapTargetSize? get tapTargetSize => Theme.of(context).materialTapTargetSize;

  @override
  InteractiveInkFeatureFactory? get splashFactory => Theme.of(context).splashFactory;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BuildContext>('context', context));
    properties.add(DiagnosticsProperty<bool>('toggleable', toggleable));
  }
}
// dart format on

// END GENERATED TOKEN PROPERTIES - OutlinedIconButton
