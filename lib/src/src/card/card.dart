import 'package:waveui/waveui.dart';

class WaveCard extends StatelessWidget {
  const WaveCard({
    super.key,
    this.width,
    this.height,
    this.backgroundColor,
    this.child,
    this.margin,
    this.padding,
  });

  final double? width;
  final double? height;
  final Widget? child;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(WaveConstants.radius),
      child: Container(
        height: height,
        width: width,
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor ?? Get.theme.cardColor,
          borderRadius: BorderRadius.circular(WaveConstants.radius),
          border: Border.all(
            color: Get.theme.dividerColor,
            width: WaveConstants.contentBorder,
          ),
        ),
        child: child,
      ),
    );
  }
}
