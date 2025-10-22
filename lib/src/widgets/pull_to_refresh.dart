import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Theme;
import 'package:waveui/waveui.dart';

class WavePullToRefresh extends StatefulWidget {
  final Future<void> Function() onRefresh;
  final Widget child;

  const WavePullToRefresh({required this.onRefresh, required this.child, super.key});

  @override
  State<WavePullToRefresh> createState() => _WavePullToRefreshState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<Future<void> Function()>.has('onRefresh', onRefresh));
  }
}

class _WavePullToRefreshState extends State<WavePullToRefresh> {
  double _dragOffset = 0.0;
  bool _isRefreshing = false;

  static const double _triggerDistance = 160.0;

  void _handleScrollUpdate(ScrollNotification notification) {
    if (_isRefreshing) {
      return;
    }

    if (notification is OverscrollNotification && notification.overscroll < 0) {
      setState(() {
        _dragOffset -= notification.overscroll;
      });
    } else if (notification is ScrollUpdateNotification && notification.metrics.extentBefore == 0) {
      setState(() {
        _dragOffset = (_dragOffset - (notification.scrollDelta ?? 0)).clamp(0.0, double.infinity);
      });
    } else if (notification is ScrollEndNotification) {
      if (_dragOffset >= _triggerDistance) {
        _startRefresh();
      } else {
        setState(() {
          _dragOffset = 0.0;
        });
      }
    }
  }

  Future<void> _startRefresh() async {
    setState(() {
      _isRefreshing = true;
    });
    await widget.onRefresh();
    setState(() {
      _isRefreshing = false;
      _dragOffset = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double progressHeight = _isRefreshing || _dragOffset > 0 ? 4.0 : 0.0;

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        _handleScrollUpdate(notification);
        return false;
      },
      child: Stack(
        children: [
          widget.child,
          AnimatedPositioned(
            duration: const Duration(milliseconds: 150),
            top: 0,
            left: 0,
            right: 0,
            height: progressHeight,
            child:
                _isRefreshing || _dragOffset > 0
                    ? WaveLinearProgressIndicator(
                      value: _isRefreshing ? null : (_dragOffset / _triggerDistance).clamp(0.0, 1.0),
                    )
                    : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
