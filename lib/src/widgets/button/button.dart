import 'package:flutter/material.dart';
import 'package:waveui/waveui.dart';

class WaveButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const WaveButton({super.key, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) => WaveTappable(
    onTap: onTap,
    child: ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 48, minWidth: 120),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: WaveTheme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),
            child: child,
          ),
        ),
      ),
    ),
  );
}
