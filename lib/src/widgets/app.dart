import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:waveui/src/theme/theme.dart';

/// Typically used at the root of an app to configure Waveui components.
class WaveApp extends InheritedWidget {
  /// The theme to use for descendant Waveui widgets.
  final WaveTheme theme;

  /// Creates a [WaveApp]
  const WaveApp({required this.theme, required super.child, super.key});

  /// Returns the [WaveTheme] from the closest [WaveApp] ancestor.
  static WaveTheme themeOf(BuildContext context) {
    final WaveApp? inheritedTheme = context.dependOnInheritedWidgetOfExactType<WaveApp>();
    assert(inheritedTheme != null, 'No WaveTheme found in context');
    return inheritedTheme!.theme;
  }

  @override
  bool updateShouldNotify(WaveApp oldWidget) => theme != oldWidget.theme;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<WaveTheme>('theme', theme));
  }
}
