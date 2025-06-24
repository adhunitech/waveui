import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Colors;
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
  final bool isSecondary;
  final Color? backgroundColor;
  final Color? foregroundColor;
  const WaveButton({
    required this.text,
    this.isSecondary = false,
    this.type = WaveButtonType.primary,
    super.key,
    this.onTap,
    this.isLoading = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
    this.isCompact = false,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WaveTappable(
      onTap: isLoading ? null : onTap,
      scale: isCompact ? 0.95 : 0.97,
      child: Container(
        padding:
            isCompact
                ? const EdgeInsets.only(left: 12, right: 12, top: 3, bottom: 4)
                : isSecondary
                ? const EdgeInsets.only(left: 16, right: 16, top: 6, bottom: 6)
                : padding,
        decoration: BoxDecoration(
          color: backgroundColor ?? _getBackgroundColor(context),
          borderRadius: BorderRadius.circular(isSecondary ? 24 : 12),
          border: type == WaveButtonType.outline ? Border.all(color: theme.colorScheme.outlineStandard) : null,
        ),
        child: Center(
          child:
              isLoading
                  ? SizedBox(
                    height: 24,
                    width: 24,
                    child: WaveCircularProgressIndicator(
                      strokeWidth: 3,
                      color: foregroundColor ?? _getForegroundColor(context),
                      backgroundColor:
                          foregroundColor?.withValues(alpha: 0.3) ??
                          _getForegroundColor(context).withValues(alpha: 0.3),
                    ),
                  )
                  : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, size: isCompact ? 18 : 24, color: _getForegroundColor(context)),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        text,
                        style: theme.textTheme.h5.copyWith(
                          color: _getForegroundColor(context),
                          fontWeight: isCompact ? FontWeight.w400 : FontWeight.w500,
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
    final theme = Theme.of(context);
    switch (type) {
      case WaveButtonType.primary:
        return theme.colorScheme.brandPrimary;
      case WaveButtonType.secondary:
        return theme.colorScheme.brandSecondary;
      case WaveButtonType.ghost:
        return Colors.transparent;
      case WaveButtonType.destructive:
        return theme.colorScheme.statusError;
      case WaveButtonType.outline:
        return Colors.transparent;
    }
  }

  Color _getForegroundColor(BuildContext context) {
    final theme = Theme.of(context);
    switch (type) {
      case WaveButtonType.primary:
        return theme.colorScheme.textPrimary;
      case WaveButtonType.secondary:
        return theme.colorScheme.textSecondary;
      case WaveButtonType.ghost:
        return theme.colorScheme.textPrimary;
      case WaveButtonType.destructive:
        return theme.colorScheme.textPrimary;
      case WaveButtonType.outline:
        return theme.colorScheme.textPrimary;
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
      ..add(DiagnosticsProperty<IconData?>('icon', icon))
      ..add(DiagnosticsProperty<bool>('isLoading', isLoading))
      ..add(ColorProperty('backgroundColor', backgroundColor))
      ..add(ColorProperty('foregroundColor', foregroundColor));
  }
}
