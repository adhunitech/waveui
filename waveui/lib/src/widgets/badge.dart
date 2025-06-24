import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter/widgets.dart';
import 'package:waveui/waveui.dart';

enum WaveBadgeType { primary, secondary, destructive, ghost }

class WaveBadge extends StatelessWidget {
  final String text;
  final WaveBadgeType type;
  final Color? backgroundColor;
  final Color? foregroundColor;
  const WaveBadge({
    required this.text,
    this.type = WaveBadgeType.primary,
    super.key,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = WaveTheme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(color: _getBackgroundColor(context), borderRadius: BorderRadius.circular(16)),
      child: Text(
        text,
        style: theme.textTheme.body.copyWith(fontSize: 12, color: foregroundColor ?? _getForegroundColor(context)),
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    if (backgroundColor != null) {
      return backgroundColor!;
    }
    final theme = WaveTheme.of(context);

    switch (type) {
      case WaveBadgeType.primary:
        return theme.colorScheme.brandPrimary;
      case WaveBadgeType.secondary:
        return theme.colorScheme.brandSecondary;
      case WaveBadgeType.ghost:
        return Colors.transparent;
      case WaveBadgeType.destructive:
        return theme.colorScheme.statusError;
    }
  }

  Color _getForegroundColor(BuildContext context) {
    if (foregroundColor != null) {
      return foregroundColor!;
    }
    final theme = WaveTheme.of(context);
    switch (type) {
      case WaveBadgeType.primary:
        return theme.colorScheme.onBrandPrimary;
      case WaveBadgeType.secondary:
        return theme.colorScheme.onBrandSecondary;
      case WaveBadgeType.ghost:
        return theme.colorScheme.textPrimary;
      case WaveBadgeType.destructive:
        return theme.colorScheme.onBrandPrimary;
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<WaveBadgeType>('type', type))
      ..add(StringProperty('text', text))
      ..add(ColorProperty('color', backgroundColor))
      ..add(ColorProperty('foregroundColor', foregroundColor));
  }
}
