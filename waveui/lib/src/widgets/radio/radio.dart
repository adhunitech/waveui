import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:waveui/waveui.dart';

enum WaveSelectableType { radio, checkbox }

class WaveSelectable extends StatelessWidget {
  final bool isSelected;
  final VoidCallback? onTap;
  final WaveSelectableType type;

  const WaveSelectable({required this.isSelected, this.onTap, this.type = WaveSelectableType.radio, super.key});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    behavior: HitTestBehavior.opaque,
    child: _AnimatedSelection(isSelected: isSelected, type: type),
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('isSelected', isSelected))
      ..add(EnumProperty<WaveSelectableType>('type', type))
      ..add(ObjectFlagProperty<VoidCallback>.has('onTap', onTap));
  }
}

class _AnimatedSelection extends StatelessWidget {
  final bool isSelected;
  final WaveSelectableType type;

  const _AnimatedSelection({required this.isSelected, required this.type});

  @override
  Widget build(BuildContext context) {
    final theme = WaveTheme.of(context);
    final Color targetColor = isSelected ? theme.colorScheme.brandPrimary : theme.colorScheme.outlineStandard;
    final double targetWidth = isSelected ? 4.5 : 2;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: targetWidth),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      builder:
          (context, borderWidth, _) => TweenAnimationBuilder<Color?>(
            tween: ColorTween(end: targetColor),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            builder: (context, color, _) {
              if (type == WaveSelectableType.checkbox) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: color ?? targetColor, width: borderWidth),
                        color: isSelected ? (color ?? targetColor) : Colors.transparent,
                      ),
                    ),
                    if (isSelected) const Icon(WaveIcons.checkmark_12_filled, size: 20, color: Colors.white),
                  ],
                );
              }

              return Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: color ?? targetColor, width: borderWidth),
                ),
              );
            },
          ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('isSelected', isSelected))
      ..add(EnumProperty<WaveSelectableType>('type', type));
  }
}
