import 'package:get/get.dart';
import 'package:waveui/src/src/guide/wave_flutter_guide.dart';
import 'package:waveui/src/constants/wave_asset_constants.dart';
import 'package:waveui/src/l10n/wave_intl.dart';
import 'package:waveui/src/utils/wave_tools.dart';
import 'package:flutter/material.dart';

enum GuideMode { force, soft }

/// 默认的引导组件包含，强和弱两种交互模式
class WaveTipInfoWidget extends StatelessWidget {
  final GuideDirection direction;
  final void Function()? onClose;
  final void Function()? onNext;
  final void Function()? onSkip;

  final double width;
  final double? height;
  final WaveTipInfoBean info;
  final GuideMode mode;

  /// Which guide page is currently displayed, starting from 0
  final int currentStepIndex;

  /// Total number of guide pages
  final int stepCount;
  final double? arrowPadding;
  final String? nextTip;

  const WaveTipInfoWidget(
      {Key? key,
      this.onClose,
      this.onNext,
      this.onSkip,
      required this.width,
      this.height,
      this.currentStepIndex = 0,
      required this.stepCount,
      required this.info,
      this.mode = GuideMode.force,
      required this.direction,
      this.arrowPadding,
      this.nextTip})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color borderColor = mode == GuideMode.force ? Colors.transparent : const Color(0xFFCCCCCC);
    if (direction == GuideDirection.bottomLeft || direction == GuideDirection.bottomRight) {
      return Column(
        verticalDirection: VerticalDirection.up,
        children: <Widget>[
          _buildContent(context),
          Container(
            alignment: direction == GuideDirection.bottomLeft ? Alignment.bottomRight : Alignment.bottomLeft,
            padding: direction == GuideDirection.bottomLeft
                ? EdgeInsets.only(right: arrowPadding ?? 12)
                : EdgeInsets.only(left: arrowPadding ?? 12),
            child: CustomPaint(
              size: const Size(14.0, 6.0),
              painter: CustomTrianglePainter(
                direction: TooltipAlign.Top,
                borderColor: borderColor,
              ),
            ),
          ),
        ],
      );
    }
    if (direction == GuideDirection.topLeft || direction == GuideDirection.topRight) {
      return Column(
        children: <Widget>[
          _buildContent(context),
          Container(
            alignment: direction == GuideDirection.topLeft ? Alignment.topRight : Alignment.topLeft,
            padding: direction == GuideDirection.topLeft
                ? EdgeInsets.only(right: arrowPadding ?? 12)
                : EdgeInsets.only(left: arrowPadding ?? 12),
            child: CustomPaint(
              size: const Size(14.0, 6.0),
              painter: CustomTrianglePainter(borderColor: borderColor, direction: TooltipAlign.Bottom),
            ),
          ),
        ],
      );
    }
    if (direction == GuideDirection.left) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _buildContent(context),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(top: 12),
            child: CustomPaint(
              size: const Size(6.0, 14.0),
              painter: CustomTrianglePainter(borderColor: borderColor, direction: TooltipAlign.Right),
            ),
          ),
        ],
      );
    }
    if (direction == GuideDirection.right) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        textDirection: TextDirection.rtl,
        verticalDirection: VerticalDirection.up,
        children: <Widget>[
          _buildContent(context),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 12),
            child: CustomPaint(
              size: const Size(6, 14.0),
              painter: CustomTrianglePainter(
                direction: TooltipAlign.Left,
                borderColor: borderColor,
              ),
            ),
          ),
        ],
      );
    }
    return const Row();
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
              blurRadius: 5.0, //阴影模糊程度
              offset: Offset(0, 2),
              color: Color(0x15000000))
        ],
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
        border: mode == GuideMode.force ? null : Border.all(color: const Color(0xFFCCCCCC), width: 0.5),
      ),
      width: width,
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildImage(),
          buildTitle(),
          buildMessage(),
          mode == GuideMode.force ? _buildForceBottom(context) : _buildSoftBottom(context)
        ],
      ),
    );
  }

  Widget buildImage() {
    if (info.imgUrl.isEmpty) return const Row();
    double imageSize = width - 16;
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Image.network(info.imgUrl, width: imageSize, height: imageSize, fit: BoxFit.cover),
    );
  }

  Widget buildTitle() {
    return Container(
      height: 18,
      margin: const EdgeInsets.only(top: 14),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            child: Text(
              info.title,
              style: const TextStyle(fontSize: 14, color: Color(0XFF222222), fontWeight: FontWeight.w600),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            child: onClose == null
                ? const Row()
                : GestureDetector(
                    onTap: () {
                      onClose!();
                    },
                    child: WaveUITools.getAssetImageWithColor(WaveAsset.iconClose, Colors.black),
                  ),
          ),
        ],
      ),
    );
  }

  Widget buildMessage() {
    if (info.message.isEmpty) return const Row();
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child:
          Text(info.message, style: const TextStyle(fontSize: 14, color: Color(0xFF999999), height: 1.3), maxLines: 3),
    );
  }

  Widget _buildSoftBottom(BuildContext context) {
    if (onNext == null && onSkip == null) return const Row();
    return Container(
      height: 32,
      margin: const EdgeInsets.only(top: 12),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            child: onSkip != null && currentStepIndex + 1 != stepCount
                ? GestureDetector(
                    onTap: () {},
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          onSkip!();
                        },
                        child: Text(
                          '${WaveIntl.of(context).localizedResource.skip} (${currentStepIndex + 1}/$stepCount)',
                          style: const TextStyle(color: Color(0xFF999999), fontSize: 14),
                        ),
                      ),
                    ))
                : const Row(),
          ),
          Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            child: onNext != null
                ? GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Get.theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          onNext!();
                        },
                        child: Text(
                          nextTip ??
                              (stepCount == currentStepIndex + 1
                                  ? WaveIntl.of(context).localizedResource.known
                                  : WaveIntl.of(context).localizedResource.next),
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ),
                  )
                : const Row(),
          )
        ],
      ),
    );
  }

  Widget _buildForceBottom(BuildContext context) {
    if (onNext == null && onSkip == null) return const Row();
    return Container(
      height: 20,
      margin: const EdgeInsets.only(top: 12),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            child: onSkip != null && currentStepIndex + 1 != stepCount
                ? GestureDetector(
                    onTap: () {},
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          onSkip!();
                        },
                        child: Text(
                          '${WaveIntl.of(context).localizedResource.skip} (${currentStepIndex + 1}/$stepCount)',
                          style: const TextStyle(color: Color(0xFF999999), fontSize: 14),
                        ),
                      ),
                    ))
                : const Row(),
          ),
          Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            child: onNext != null
                ? GestureDetector(
                    onTap: () {},
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          onNext!();
                        },
                        child: Text(
                          nextTip ??
                              (stepCount == currentStepIndex + 1
                                  ? WaveIntl.of(context).localizedResource.known
                                  : WaveIntl.of(context).localizedResource.next),
                          style: TextStyle(color: Get.theme.colorScheme.primary, fontSize: 14),
                        ),
                      ),
                    ),
                  )
                : const Row(),
          )
        ],
      ),
    );
  }
}

enum TooltipAlign { Left, Right, Top, Bottom }

///
/// 绘制箭头
///
///
class CustomTrianglePainter extends CustomPainter {
  Color color;
  Color borderColor;
  TooltipAlign direction;

  CustomTrianglePainter(
      {this.color = Colors.white, this.borderColor = const Color(0XFFCCCCCC), required this.direction});

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();
    paint.strokeWidth = 2.0;
    paint.color = color;
    paint.style = PaintingStyle.fill;
    Paint paintBorder = Paint();
    Path pathBorder = Path();
    paintBorder.strokeWidth = 0.5;
    paintBorder.color = borderColor;
    paintBorder.style = PaintingStyle.stroke;

    switch (direction) {
      case TooltipAlign.Left:
        path.moveTo(size.width + 1, -1.3);
        path.lineTo(0, size.height / 2);
        path.lineTo(size.width + 1, size.height + 0.5);
        pathBorder.moveTo(size.width, -0.5);
        pathBorder.lineTo(0, size.height / 2 - 0.5);
        pathBorder.lineTo(size.width, size.height);
        break;
      case TooltipAlign.Right:
        path.moveTo(-1, -1.3);
        path.lineTo(size.width, size.height / 2);
        path.lineTo(-1, size.height + 0.5);
        pathBorder.moveTo(-0, -0.5);
        pathBorder.lineTo(size.width, size.height / 2);
        pathBorder.lineTo(-0, size.height);
        break;
      case TooltipAlign.Top:
        path.moveTo(0.0, size.height + 1.5);
        path.lineTo(size.width / 2.0, 0.0);
        path.lineTo(size.width, size.height + 1.5);
        pathBorder.moveTo(0.5, size.height + 0.5);
        pathBorder.lineTo(size.width / 2.0, 0);
        pathBorder.lineTo(size.width - 0.5, size.height + 0.5);
        break;
      case TooltipAlign.Bottom:
        path.moveTo(0.0, -1.5);
        path.lineTo(size.width / 2.0, size.height);
        path.lineTo(size.width, -1.5);
        pathBorder.moveTo(0.0, -0.5);
        pathBorder.lineTo(size.width / 2.0, size.height);
        pathBorder.lineTo(size.width, -0.5);
        break;
    }

    canvas.drawPath(path, paint);
    canvas.drawPath(pathBorder, paintBorder);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
