import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:waveui/src/theme/theme_data.dart';

class WaveApp extends InheritedWidget {
  final WaveThemeData themeData;

  const WaveApp({required this.themeData, required super.child, super.key});

  static WaveThemeData of(BuildContext context) {
    final WaveApp? inheritedTheme = context.dependOnInheritedWidgetOfExactType<WaveApp>();
    assert(inheritedTheme != null, 'No WaveTheme found in context');
    return inheritedTheme!.themeData;
  }

  @override
  bool updateShouldNotify(WaveApp oldWidget) => themeData != oldWidget.themeData;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<WaveThemeData>('themeData', themeData));
  }
}
