import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:waveui/waveui.dart';

/// The type of divider to display.
enum WaveDividerType {
  /// A solid line divider
  solid,

  /// A dotted line divider
  dotted,
}

class WaveDivider extends StatelessWidget {
  final Axis axis;
  final Color? color;
  final WaveDividerType type;

  /// Creates a [WaveDivider] widget.
  const WaveDivider({super.key, this.axis = Axis.horizontal, this.color, this.type = WaveDividerType.solid});

  @override
  Widget build(BuildContext context) {
    final theme = WaveApp.themeOf(context);
    final dividerColor = color ?? theme.colorScheme.outlineDivider;

    if (type == WaveDividerType.dotted) {
      return axis == Axis.horizontal
          ? SizedBox(
            height: 1,
            width: double.infinity,
            child: CustomPaint(painter: DottedLinePainter(color: dividerColor, isHorizontal: true)),
          )
          : SizedBox(
            width: 1,
            height: double.infinity,
            child: CustomPaint(painter: DottedLinePainter(color: dividerColor, isHorizontal: false)),
          );
    }

    return axis == Axis.horizontal
        ? SizedBox(height: 1, width: double.infinity, child: ColoredBox(color: dividerColor))
        : SizedBox(width: 1, height: double.infinity, child: ColoredBox(color: dividerColor));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<Axis>('axis', axis))
      ..add(ColorProperty('color', color))
      ..add(EnumProperty<WaveDividerType>('type', type));
  }
}

class DottedLinePainter extends CustomPainter {
  final Color color;
  final bool isHorizontal;

  DottedLinePainter({required this.color, required this.isHorizontal});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 1;

    const dashWidth = 8.0;
    const dashSpace = 6.0;
    double startX = 0;
    double startY = 0;

    if (isHorizontal) {
      while (startX < size.width) {
        canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
        startX += dashWidth + dashSpace;
      }
    } else {
      while (startY < size.height) {
        canvas.drawLine(Offset(0, startY), Offset(0, startY + dashWidth), paint);
        startY += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(DottedLinePainter oldDelegate) =>
      color != oldDelegate.color || isHorizontal != oldDelegate.isHorizontal;
}
