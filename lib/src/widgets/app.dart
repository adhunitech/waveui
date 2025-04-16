import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:waveui/src/theme/theme_data.dart';

/// Typically used at the root of an app to configure Waveui components.
class WaveApp extends InheritedWidget {
  /// The theme data to use for descendant Waveui widgets.
  final WaveThemeData themeData;

  /// Creates a [WaveApp]
  const WaveApp({required this.themeData, required super.child, super.key});

  /// Returns the [WaveThemeData] from the closest [WaveApp] ancestor.
  static WaveThemeData themeOf(BuildContext context) {
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
