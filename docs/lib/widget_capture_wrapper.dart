import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class WidgetCaptureWrapper extends StatefulWidget {
  final Widget child;
  final int targetWidth;
  final ui.ImageByteFormat format; // PNG or WebP

  const WidgetCaptureWrapper({
    required this.child,
    super.key,
    this.targetWidth = 250,
    this.format = ui.ImageByteFormat.png,
  });

  @override
  State<WidgetCaptureWrapper> createState() => _WidgetCaptureWrapperState();
}

class _WidgetCaptureWrapperState extends State<WidgetCaptureWrapper> {
  final GlobalKey _boundaryKey = GlobalKey();

  Future<void> _captureAndDownload() async {
    final RenderRepaintBoundary boundary = _boundaryKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;

    if (boundary.debugNeedsPaint) {
      await Future.delayed(const Duration(milliseconds: 50));
      return _captureAndDownload(); // Retry after paint
    }

    final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    final int originalWidth = image.width;
    final int originalHeight = image.height;

    final double scale = widget.targetWidth / originalWidth;
    final int targetHeight = (originalHeight * scale).round();

    final ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas(recorder)
      ..scale(scale, scale)
      ..drawImage(image, Offset.zero, Paint());
    final ui.Image resizedImage = await recorder.endRecording().toImage(widget.targetWidth, targetHeight);

    final ByteData? byteData = await resizedImage.toByteData(format: widget.format);
    if (byteData == null) {
      return;
    }

    final mime = widget.format == ui.ImageByteFormat.png ? 'image/png' : 'image/webp';
    final ext = widget.format == ui.ImageByteFormat.png ? 'png' : 'webp';

    final blob = html.Blob([byteData.buffer.asUint8List()], mime);
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..download = 'capture_${DateTime.now().millisecondsSinceEpoch}.$ext'
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      RepaintBoundary(key: _boundaryKey, child: widget.child),
      Positioned(
        right: 8,
        top: 8,
        child: IconButton(icon: const Icon(Icons.download), onPressed: _captureAndDownload),
      ),
    ],
  );
}
