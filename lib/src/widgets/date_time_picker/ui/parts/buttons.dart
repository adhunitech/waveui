import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:waveui/waveui.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({required this.icon, required this.onTap, super.key, this.buttonSize = 36, this.child});

  final IconData icon;
  final void Function() onTap;
  final double buttonSize;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = WaveApp.themeOf(context);
    return WaveTappable(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAlias,
        child: Container(
          height: buttonSize,
          width: buttonSize,
          alignment: Alignment.center,
          child: child ?? Icon(icon, size: 20, color: theme.colorScheme.primary),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<IconData>('icon', icon))
      ..add(ObjectFlagProperty<void Function()>.has('onTap', onTap))
      ..add(DoubleProperty('buttonSize', buttonSize));
  }
}
