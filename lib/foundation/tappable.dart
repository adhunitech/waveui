import 'package:flutter/material.dart';

class WaveTappable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Duration duration;
  final double scale;
  final double opacity;

  const WaveTappable({
    required this.child,
    Key? key,
    this.onTap,
    this.duration = const Duration(milliseconds: 100),
    this.scale = 0.95,
    this.opacity = 0.6,
  }) : super(key: key);

  @override
  _WaveTappableState createState() => _WaveTappableState();
}

class _WaveTappableState extends State<WaveTappable> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    setState(() {
      _isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onTap == null) {
      return Opacity(opacity: widget.opacity, child: widget.child);
    }
    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) {
        _setPressed(false);
        widget.onTap?.call();
      },
      onTapCancel: () => _setPressed(false),
      child: MouseRegion(
        onEnter: (_) => _setPressed(true),
        onExit: (_) => _setPressed(false),
        child: AnimatedOpacity(
          duration: widget.duration,
          opacity: _isPressed ? widget.opacity : 1.0,
          child: AnimatedScale(scale: _isPressed ? widget.scale : 1.0, duration: widget.duration, child: widget.child),
        ),
      ),
    );
  }
}
