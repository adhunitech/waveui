import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:waveui/waveui.dart';

/// Available button types for styling and behavior.
enum ButtonType { primary, secondary, tertiary, outline, destructive, ghost, link }

class Button extends StatefulWidget {
  final ButtonTypeTheme? theme;
  final ButtonType type;
  final Widget label;
  final bool elevated;
  final VoidCallback? onTap;
  const Button({
    required this.label,
    this.elevated = true,
    super.key,
    this.theme,
    this.onTap,
    this.type = ButtonType.primary,
  });

  @override
  State<Button> createState() => _ButtonState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<ButtonTypeTheme?>('theme', theme))
      ..add(EnumProperty<ButtonType>('type', type))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap));
  }
}

class _ButtonState extends State<Button> {
  bool _hovering = false;
  bool _pressing = false;

  Color _getBackgroundColor(BuildContext context, ButtonTypeTheme theme) {
    final colorScheme = ColorScheme.of(context);
    if (_pressing) {
      return colorScheme.getStateOverlay(theme.backgroundColor!, UIState.pressed);
    } else if (_hovering) {
      return colorScheme.getStateOverlay(theme.backgroundColor!, UIState.hovered);
    } else {
      return theme.backgroundColor ?? const Color(0xFFE0E0E0);
    }
  }

  Color _getBorderColor(BuildContext context, ButtonTypeTheme theme) {
    final colorScheme = ColorScheme.of(context);
    if (_pressing) {
      return colorScheme.getStateOverlay(theme.borderColor!, UIState.pressed);
    } else if (_hovering) {
      return colorScheme.getStateOverlay(theme.borderColor!, UIState.hovered);
    } else {
      return theme.borderColor!;
    }
  }

  void _handleMouseEnter(PointerEnterEvent event) {
    if (!_pressing) {
      setState(() => _hovering = true);
    }
  }

  void _handleMouseExit(PointerExitEvent event) {
    setState(() {
      _hovering = false;
      _pressing = false;
    });
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _pressing = true;
      _hovering = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _pressing = false);
  }

  void _handleTapCancel() {
    setState(() => _pressing = false);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    ButtonTypeTheme? theme = widget.theme;
    if (theme == null) {
      switch (widget.type) {
        case ButtonType.primary:
          theme = ButtonTheme.of(context).primaryButton;
        case ButtonType.secondary:
          theme = ButtonTheme.of(context).secondaryButton;
        case ButtonType.tertiary:
          theme = ButtonTheme.of(context).tertiaryButton;
        case ButtonType.outline:
          theme = ButtonTheme.of(context).outlineButton;
        case ButtonType.destructive:
          theme = ButtonTheme.of(context).destructiveButton;
        case ButtonType.ghost:
          theme = ButtonTheme.of(context).ghostButton;
        case ButtonType.link:
          theme = ButtonTheme.of(context).linkButton;
      }
    }
    final opacity = _pressing ? colorScheme.statePressedOpacity : 1.0;
    return MouseRegion(
      cursor: widget.onTap == null ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      onEnter: _handleMouseEnter,
      onExit: _handleMouseExit,
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          opacity: opacity,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.ease,
            padding: theme.padding,
            decoration: BoxDecoration(
              color: _getBackgroundColor(context, theme),
              boxShadow:
                  !widget.elevated || _pressing
                      ? null
                      : [const BoxShadow(color: Color.fromARGB(39, 0, 0, 0), blurRadius: 0.5, offset: Offset(0, 2))],
              borderRadius: BorderRadius.circular(theme.borderRadius),
              border: theme.borderColor == null ? null : Border.all(color: _getBorderColor(context, theme)),
            ),
            child: DefaultTextStyle(
              style: theme.labelStyle!.copyWith(color: theme.foregroundColor),
              child: widget.label,
            ),
          ),
        ),
      ),
    );
  }
}
