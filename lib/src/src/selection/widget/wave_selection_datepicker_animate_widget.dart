import 'package:waveui/src/src/selection/controller/wave_selection_view_date_picker_controller.dart';
import 'package:flutter/material.dart';

class WaveSelectionDatePickerAnimationWidget extends StatefulWidget {
  final WaveSelectionDatePickerController controller;
  final Widget view;
  final int animationMilliseconds;

  const WaveSelectionDatePickerAnimationWidget(
      {Key? key, required this.controller, required this.view, this.animationMilliseconds = 100})
      : super(key: key);

  @override
  _WaveSelectionDatePickerAnimationWidgetState createState() => _WaveSelectionDatePickerAnimationWidgetState();
}

class _WaveSelectionDatePickerAnimationWidgetState extends State<WaveSelectionDatePickerAnimationWidget>
    with SingleTickerProviderStateMixin {
  bool _isControllerDisposed = false;
  Animation<double>? _animation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_onController);
    _controller = AnimationController(duration: Duration(milliseconds: widget.animationMilliseconds), vsync: this);
  }

  @override
  dispose() {
    widget.controller.removeListener(_onController);
    _controller.dispose();
    _isControllerDisposed = true;
    super.dispose();
  }

  _onController() {
    _showListViewWidget();
  }

  @override
  Widget build(BuildContext context) {
    _controller.duration = Duration(milliseconds: widget.animationMilliseconds);
    return _buildListViewWidget();
  }

  _showListViewWidget() {
    _animation = Tween(begin: MediaQuery.of(context).size.height, end: 300.0).animate(_controller)
      ..addListener(() {
        //这行如果不写，没有动画效果
        setState(() {});
      });

    if (_isControllerDisposed) return;

    if (_animation!.status == AnimationStatus.completed) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  Widget _buildListViewWidget() {
    return GestureDetector(
      onTap: () {},
      child: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: widget.view,
        ),
      ),
    );
  }
}
