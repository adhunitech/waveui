import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:waveui/theme.dart';

class WaveApp extends InheritedWidget {
  final WaveTheme theme;

  const WaveApp({required this.theme, required Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<WaveTheme>('theme', theme));
  }
}
