import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show CircularProgressIndicator, Colors;
import 'package:flutter/widgets.dart';
import 'package:waveui/waveui.dart';

enum WaveButtonType { primary, secondary, outline, destructive, ghost }

class WaveButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final WaveButtonType type;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final bool isCompact;
  final bool isLoading;
  const WaveButton({
    required this.text,
    this.type = WaveButtonType.primary,
    super.key,
    this.onTap,
    this.isLoading = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
    this.isCompact = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = WaveApp.themeOf(context);
    return WaveTappable(
      onTap: isLoading ? null : onTap,
      scale: isCompact ? 0.95 : 0.97,
      child: Container(
        padding:
            isCompact
                ? const EdgeInsets.only(left: 12, right: 12, top: 1, bottom: 4)
                : padding,
        decoration: BoxDecoration(
          color: _getBackgroundColor(context),
          borderRadius: BorderRadius.circular(12),
          border:
              type == WaveButtonType.outline
                  ? Border.all(color: theme.colorScheme.border)
                  : null,
        ),
        child: Center(
          child:
              isLoading
                  ? SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: _getForegroundColor(context),
                      backgroundColor: _getForegroundColor(
                        context,
                      ).withValues(alpha: 0.3),
                    ),
                  )
                  : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(
                          icon,
                          size: isCompact ? 18 : 24,
                          color: _getForegroundColor(context),
                        ),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        text,
                        style: theme.textTheme.button.copyWith(
                          color: _getForegroundColor(context),
                          fontWeight:
                              isCompact ? FontWeight.w400 : FontWeight.w500,
                          fontSize: isCompact ? 14 : 16,
                        ),
                      ),
                    ],
                  ),
        ),
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
      case WaveButtonType.outline:
        return Colors.transparent;
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
      case WaveButtonType.outline:
        return theme.colorScheme.labelPrimary;
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap))
      ..add(EnumProperty<WaveButtonType>('type', type))
      ..add(StringProperty('text', text))
      ..add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding))
      ..add(DiagnosticsProperty<bool>('isCompact', isCompact))
      ..add(DiagnosticsProperty<IconData?>('icon', icon));
  }
}
