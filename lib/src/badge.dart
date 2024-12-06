import 'package:flutter/material.dart';

enum WaveBadgeStyle {
  primary,
  secondary,
  outlined,
  destructive,
}

class WaveBadge extends StatelessWidget {
  final String text;
  final Color? color;
  final WaveBadgeStyle badgeStyle;
  const WaveBadge({
    Key? key,
    required this.text,
    this.color,
    this.badgeStyle = WaveBadgeStyle.primary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? _buildBackgroundColors(context, badgeStyle),
        borderRadius: BorderRadius.circular(30),
        border: badgeStyle == WaveBadgeStyle.outlined ? Border.all(color: Theme.of(context).dividerColor) : null,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Text(
        text,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: _buildForegroundColors(context, badgeStyle),
        ),
      ),
    );
  }

  Color _buildBackgroundColors(BuildContext context, WaveBadgeStyle badgeStyle) {
    switch (badgeStyle) {
      case WaveBadgeStyle.primary:
        return Theme.of(context).colorScheme.primary;
      case WaveBadgeStyle.secondary:
        return Theme.of(context).dividerColor;
      case WaveBadgeStyle.outlined:
        return Colors.transparent;
      case WaveBadgeStyle.destructive:
        return Colors.red;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  Color _buildForegroundColors(BuildContext context, WaveBadgeStyle badgeStyle) {
    switch (badgeStyle) {
      case WaveBadgeStyle.primary:
        return Colors.white;
      case WaveBadgeStyle.secondary:
        return Theme.of(context).textTheme.bodyMedium!.color!;
      case WaveBadgeStyle.outlined:
        return Theme.of(context).textTheme.bodyMedium!.color!;
      case WaveBadgeStyle.destructive:
        return Colors.white;
      default:
        return Theme.of(context).primaryColor;
    }
  }
}
