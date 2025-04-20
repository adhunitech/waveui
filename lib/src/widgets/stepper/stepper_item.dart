import 'package:flutter/material.dart';

class StepperItem {
  /// title for the stepper
  final Text? title;

  /// subtitle for the stepper
  final Text? subtitle;

  final Widget? iconWidget;

  /// Use the constructor of [StepperItem] to pass the data needed.
  StepperItem({this.iconWidget, this.title, this.subtitle});
}
