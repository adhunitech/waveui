import 'package:flutter/material.dart' hide Theme;
import 'package:waveui/waveui.dart';

class WaveSnackbar {
  static void show({
    required BuildContext context,
    required String message,
    Color backgroundColor = Colors.black87,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    final width = MediaQuery.of(context).size.width;

    double maxWidth;
    AlignmentGeometry alignment;

    if (width < 600) {
      maxWidth = double.infinity;
      alignment = Alignment.bottomCenter;
    } else if (width < 1024) {
      maxWidth = 480;
      alignment = Alignment.bottomCenter;
    } else {
      maxWidth = 480;
      alignment = Alignment.bottomRight;
    }

    final overlay = Overlay.of(context);

    late OverlayEntry overlayEntry;
    final animationController = AnimationController(
      vsync: Navigator.of(context),
      duration: const Duration(milliseconds: 300),
    );

    final curvedAnimation = CurvedAnimation(parent: animationController, curve: Curves.easeOutCubic);

    final slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(curvedAnimation);

    overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            bottom: 24,
            left: alignment == Alignment.bottomCenter ? (width - maxWidth) / 2 : null,
            right: alignment == Alignment.bottomRight ? 24 : null,
            child: Material(
              color: Colors.transparent,
              child: FadeTransition(
                opacity: curvedAnimation,
                child: SlideTransition(
                  position: slideAnimation,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [backgroundColor.withOpacity(0.95), backgroundColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 14, offset: const Offset(0, 8)),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(WaveIcons.info_24_regular, color: Colors.white),
                        const SizedBox(width: 12),
                        Expanded(child: Text(message, style: const TextStyle(color: Colors.white, fontSize: 15))),
                        if (action != null)
                          TextButton(
                            onPressed: () {
                              action.onPressed();
                              animationController.reverse().then((_) {
                                if (overlayEntry.mounted) overlayEntry.remove();
                              });
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              textStyle: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            child: Text(action.label),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
    );

    overlay.insert(overlayEntry);
    animationController.forward();

    Future.delayed(duration, () {
      if (animationController.status == AnimationStatus.completed) {
        animationController.reverse().then((_) {
          if (overlayEntry.mounted) overlayEntry.remove();
        });
      }
    });
  }
}
