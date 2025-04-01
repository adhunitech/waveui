import 'package:flutter/material.dart';
import 'package:waveui/src/theme/themes.dart';

class WaveBadge extends StatelessWidget {
  final String text;
  final Color? color;
  const WaveBadge({required this.text, super.key, this.color});

  @override
  Widget build(BuildContext context) {
    var theme = WaveTheme.of(context);
    return Container(
      child: Text(text, style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400)),
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(color: color ?? theme.colorScheme.primary, borderRadius: BorderRadius.circular(4)),
    );
  }
}
