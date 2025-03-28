import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:waveui/waveui.dart';

class WaveButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool isBusy;

  const WaveButton({super.key, required this.child, this.onTap, this.isBusy = false});

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
            child: _buildChild(),
          ),
        ),
      ),
    ),
  );

  Widget _buildChild() =>
      isBusy
          ? const SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(color: Colors.white, backgroundColor: Colors.white38, strokeWidth: 3),
          )
          : child;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap))
      ..add(DiagnosticsProperty<bool>('isBusy', isBusy));
  }
}
