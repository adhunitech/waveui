import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:waveui/waveui.dart';

class WaveRadio extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const WaveRadio({required this.isSelected, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) =>
      GestureDetector(onTap: onTap, behavior: HitTestBehavior.opaque, child: _AnimatedRing(isSelected: isSelected));

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('isSelected', isSelected))
      ..add(ObjectFlagProperty<VoidCallback>.has('onTap', onTap));
  }
}

class _AnimatedRing extends StatelessWidget {
  final bool isSelected;

  const _AnimatedRing({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final theme = WaveApp.themeOf(context);
    final Color beginColor = isSelected ? theme.colorScheme.border : theme.colorScheme.primary;
    final Color endColor = isSelected ? theme.colorScheme.primary : theme.colorScheme.border;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: isSelected ? 2 : 4, end: isSelected ? 4 : 2),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      builder:
          (context, borderWidth, _) => TweenAnimationBuilder<Color?>(
            tween: ColorTween(begin: beginColor, end: endColor),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            builder:
                (context, color, child) => Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: color ?? endColor, width: borderWidth),
                  ),
                ),
          ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('isSelected', isSelected));
  }
}
