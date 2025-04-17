import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter/widgets.dart';
import 'package:waveui/waveui.dart';

enum WaveButtonType { primary, secondary, destructive, ghost }

class WaveButton extends StatelessWidget {
  final String text;
  final WaveButtonType type;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  const WaveButton({
    required this.text,
    this.type = WaveButtonType.primary,
    super.key,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
  });

  @override
  Widget build(BuildContext context) {
    final theme = WaveApp.themeOf(context);
    return WaveTappable(
      onTap: onTap,
      scale: 0.97,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(color: _getBackgroundColor(context), borderRadius: BorderRadius.circular(8)),
        child: Center(child: Text(text, style: theme.textTheme.button.copyWith(color: _getForegroundColor(context)))),
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    final theme = WaveApp.themeOf(context);
    switch (type) {
      case WaveButtonType.primary:
        return theme.colorScheme.primary;
      case WaveButtonType.secondary:
        return theme.colorScheme.secondary;
      case WaveButtonType.ghost:
        return Colors.transparent;
      case WaveButtonType.destructive:
        return theme.colorScheme.error;
    }
  }

  Color _getForegroundColor(BuildContext context) {
    final theme = WaveApp.themeOf(context);
    switch (type) {
      case WaveButtonType.primary:
        return theme.colorScheme.onPrimary;
      case WaveButtonType.secondary:
        return theme.colorScheme.onSecondary;
      case WaveButtonType.ghost:
        return theme.colorScheme.labelPrimary;
      case WaveButtonType.destructive:
        return theme.colorScheme.onPrimary;
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap))
      ..add(EnumProperty<WaveButtonType>('type', type))
      ..add(StringProperty('text', text))
      ..add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding));
  }
}
