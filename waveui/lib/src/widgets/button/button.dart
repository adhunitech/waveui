import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:waveui/waveui.dart';

enum ButtonType { primary, secondary, outline, destructive, ghost, link }

class Button extends StatefulWidget {
  final ButtonTheme? theme;
  final ButtonType type;
  final Widget label;
  final VoidCallback? onPressed;
  const Button({super.key, this.theme, required this.label, this.onPressed, this.type = ButtonType.primary});

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  bool _hovering = false;
  bool _pressing = false;

  Color _getBackgroundColor(BuildContext context, ButtonTheme theme) {
    final colorScheme = ColorScheme.of(context);
    if (_pressing) {
      return colorScheme.getStateOverlay(theme.primaryButton.backgroundColor!, UIState.pressed);
    } else if (_hovering) {
      return colorScheme.getStateOverlay(theme.primaryButton.backgroundColor!, UIState.hovered);
    } else {
      return theme.primaryButton.backgroundColor ?? const Color(0xFFE0E0E0);
    }
  }

  Color _getBorderColor(BuildContext context, ButtonTheme theme) {
    final colorScheme = ColorScheme.of(context);
    if (_pressing) {
      return colorScheme.getStateOverlay(theme.primaryButton.borderColor!, UIState.pressed);
    } else if (_hovering) {
      return colorScheme.getStateOverlay(theme.primaryButton.borderColor!, UIState.hovered);
    } else {
      return theme.primaryButton.borderColor!;
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
    final theme = widget.theme ?? ButtonTheme.of(context);
    final animatedColor = _getBackgroundColor(context, theme);

    return MouseRegion(
      cursor: widget.onPressed == null ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      onEnter: _handleMouseEnter,
      onExit: _handleMouseExit,
      child: GestureDetector(
        onTap: widget.onPressed,
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.ease,
          padding: theme.primaryButton.padding,
          decoration: BoxDecoration(
            color: animatedColor,
            boxShadow:
                _pressing
                    ? null
                    : [const BoxShadow(color: Color.fromARGB(39, 0, 0, 0), blurRadius: 0.5, offset: Offset(0, 2))],
            borderRadius: BorderRadius.circular(theme.primaryButton.borderRadius),
            border: theme.primaryButton.borderColor == null ? null : Border.all(color: _getBorderColor(context, theme)),
          ),
          child: DefaultTextStyle(
            style: theme.primaryButton.labelStyle!.copyWith(color: theme.primaryButton.foregroundColor),
            child: widget.label,
          ),
        ),
      ),
    );
  }
}
