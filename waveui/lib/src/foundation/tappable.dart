import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:waveui/waveui.dart';

/// A widget that provides tap feedback with scale and opacity animations.
class WaveTappable extends StatefulWidget {
  const WaveTappable({
    super.key,
    this.tooltip,
    this.child,
    this.onTap,
    this.duration = const Duration(milliseconds: 150),
    this.scale = 0.95,
    this.opacity,
  });

  final Widget? child;
  final VoidCallback? onTap;
  final Duration duration;
  final double scale;
  final double? opacity;
  final String? tooltip;

  @override
  State<WaveTappable> createState() => _WaveTappableState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap))
      ..add(DiagnosticsProperty<Duration>('duration', duration))
      ..add(DoubleProperty('opacity', opacity))
      ..add(DoubleProperty('scale', scale))
      ..add(StringProperty('tooltip', tooltip));
  }
}

class _WaveTappableState extends State<WaveTappable> with SingleTickerProviderStateMixin {
  bool _isTouched = false;

  void _handleTapDown() {
    if (widget.onTap != null) {
      _setTouched(true);
    }
  }

  void _handleTapUp() {
    if (widget.onTap != null) {
      _setTouched(false);
      widget.onTap?.call();
    }
  }

  void _setTouched(bool touched) {
    setState(() => _isTouched = touched);
  }

  double get _opacity {
    final theme = WaveTheme.of(context);
    if (_isTouched) {
      return widget.opacity ?? theme.colorScheme.stateHoverOpacity;
    }
    return widget.onTap == null ? theme.colorScheme.stateDisabledOpacity : 1.0;
  }

  double get _scale => widget.onTap == null ? 1 : (_isTouched ? widget.scale : 1.0);

  @override
  Widget build(BuildContext context) {
    final baseWidget = GestureDetector(
      onTapDown: (_) => _handleTapDown(),
      onTapUp: (_) => _handleTapUp(),
      onTapCancel: () => _setTouched(false),
      child: AnimatedOpacity(
        opacity: _opacity,
        duration: widget.duration,
        child: AnimatedScale(scale: _scale, duration: widget.duration, curve: Curves.easeOut, child: widget.child),
      ),
    );
    if (widget.tooltip != null) {
      return Tooltip(message: widget.tooltip, child: baseWidget);
    }
    return baseWidget;
  }
}
