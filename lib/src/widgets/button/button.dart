import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:waveui/waveui.dart';

enum WaveButtonType { primary, secondary, text }

class WaveButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool isBusy;
  final WaveButtonType type;
  final Color? backgroundColor;
  final Color? textColor;

  const WaveButton({
    required this.child,
    this.type = WaveButtonType.primary,
    super.key,
    this.onTap,
    this.isBusy = false,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) => WaveTappable(
    onTap: onTap,
    child: ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 48, minWidth: 120),
      child: DecoratedBox(
        decoration: BoxDecoration(color: _buildBackgroundColor(context), borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: DefaultTextStyle(
            style: TextStyle(fontWeight: FontWeight.w500, color: _buildTextColor(context), fontSize: 16),
            child: _buildChild(),
          ),
        ),
      ),
    ),
  );

  Widget _buildChild() =>
      isBusy
          ? const SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(color: Colors.white, backgroundColor: Colors.white38, strokeWidth: 3),
          )
          : child;

  Color _buildTextColor(BuildContext context) {
    if (textColor != null) {
      return textColor!;
    }
    switch (type) {
      case WaveButtonType.primary:
        return Colors.white;
      case WaveButtonType.secondary:
        return WaveTheme.of(context).colorScheme.primaryText;
      case WaveButtonType.text:
        return WaveTheme.of(context).colorScheme.primaryText;
    }
  }

  Color _buildBackgroundColor(BuildContext context) {
    if (backgroundColor != null) {
      return backgroundColor!;
    }
    switch (type) {
      case WaveButtonType.primary:
        return WaveTheme.of(context).colorScheme.primary;
      case WaveButtonType.secondary:
        return WaveTheme.of(context).colorScheme.separator;
      case WaveButtonType.text:
        return Colors.transparent;
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap))
      ..add(DiagnosticsProperty<bool>('isBusy', isBusy))
      ..add(EnumProperty<WaveButtonType>('type', type));
  }
}
