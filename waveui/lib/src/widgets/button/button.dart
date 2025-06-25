import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:waveui/waveui.dart';

/// Available button types for styling and behavior.
enum ButtonType { primary, secondary, tertiary, outline, destructive, ghost }

class Button extends StatefulWidget {
  final ButtonTypeTheme? theme;
  final ButtonType type;
  final Widget? label;
  final Widget? icon;
  final bool elevated;
  final bool isLoading;
  final VoidCallback? onTap;
  const Button({
    this.label,
    this.elevated = true,
    this.isLoading = false,
    super.key,
    this.theme,
    this.onTap,
    this.type = ButtonType.primary,
    this.icon,
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
      }
    }
    final opacity =
        widget.onTap == null || widget.isLoading
            ? colorScheme.stateDisabledOpacity
            : _pressing
            ? colorScheme.statePressedOpacity
            : 1.0;
    return MouseRegion(
      cursor: widget.onTap == null || widget.isLoading ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      onEnter: widget.onTap == null || widget.isLoading ? null : _handleMouseEnter,
      onExit: widget.onTap == null || widget.isLoading ? null : _handleMouseExit,
      child: GestureDetector(
        onTap: widget.isLoading ? null : widget.onTap,
        onTapDown: widget.onTap == null || widget.isLoading ? null : _handleTapDown,
        onTapUp: widget.onTap == null || widget.isLoading ? null : _handleTapUp,
        onTapCancel: widget.onTap == null || widget.isLoading ? null : _handleTapCancel,
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
                  !widget.elevated || _pressing || widget.onTap == null || widget.isLoading
                      ? null
                      : [const BoxShadow(color: Color.fromARGB(39, 0, 0, 0), blurRadius: 0.5, offset: Offset(0, 2))],
              borderRadius: theme.borderRadius,
              border: theme.borderColor == null ? null : Border.all(color: _getBorderColor(context, theme)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.isLoading)
                  WaveCircularProgressIndicator(
                    size: 18,
                    strokeWidth: 3,
                    color: theme.iconTheme?.color ?? theme.labelStyle?.color,
                  ),
                if (widget.icon != null) IconTheme(data: theme.iconTheme!, child: widget.icon!),
                if (widget.label != null)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: !widget.isLoading && widget.icon == null ? 4 : 0),
                    child: DefaultTextStyle(style: theme.labelStyle!, child: widget.label!),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
