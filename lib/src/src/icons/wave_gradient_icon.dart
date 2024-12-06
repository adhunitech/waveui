import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WaveGradientIcon extends StatelessWidget {
  const WaveGradientIcon({
    super.key,
    required this.icon,
    this.size = 28,
    this.gradient,
  });

  final IconData icon;
  final double size;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      child: Icon(
        icon,
        size: size,
        color: Colors.white,
      ),
      shaderCallback: (Rect bounds) {
        final Rect rect = Rect.fromLTRB(0, 0, size, size);
        return gradient == null
            ? LinearGradient(colors: [
                Get.theme.primaryColor,
                Get.theme.primaryColorDark
              ]).createShader(rect)
            : gradient!.createShader(rect);
      },
    );
  }
}
