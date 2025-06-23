import 'package:flutter/material.dart';
import 'package:waveui/waveui.dart';

class WaveAvatar extends StatelessWidget {
  final String? initials;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final num size;
  const WaveAvatar({super.key, this.initials, this.backgroundColor, this.foregroundColor, this.size = 50});

  @override
  Widget build(BuildContext context) {
    final providedInitials = initials ?? 'Adhunitech';
    final theme = WaveApp.themeOf(context);
    return SizedBox(
      height: size.toDouble(),
      width: size.toDouble(),
      child: ClipOval(
        child: ColoredBox(
          color: backgroundColor ?? _getBackgroundColor(providedInitials).withValues(alpha: 0.15),
          child: Center(
            child: Text(
              _getInitials(providedInitials),
              style: theme.textTheme.h4.copyWith(color: foregroundColor ?? _getBackgroundColor(providedInitials)),
            ),
          ),
        ),
      ),
    );
  }
}

String _getInitials(String name) {
  final words = name.trim().split(RegExp(r'\s+'));
  if (words.length == 1) {
    return words[0][0].toUpperCase();
  }
  return words[0][0].toUpperCase() + words[1][0].toUpperCase();
}

Color _getBackgroundColor(String name) {
  int stableHash(String text) {
    int hash = 0;
    for (int i = 0; i < text.length; i++) {
      hash = 31 * hash + text.codeUnitAt(i);
    }
    return hash & 0x7FFFFFFF;
  }

  const List<int> hueBuckets = [7, 28, 50, 120, 200, 285];
  final hash = stableHash(name);
  final hue = hueBuckets[hash % hueBuckets.length];

  return HSLColor.fromAHSL(1.0, hue.toDouble(), 0.80, 0.36).toColor();
}
