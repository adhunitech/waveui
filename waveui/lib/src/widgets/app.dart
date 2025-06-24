import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:waveui/src/theme/theme.dart';

/// Root widget for setting global configuration and styles.
class WaveApp extends InheritedWidget {
  /// The theme data for components, provided to all descendants.
  final WaveTheme theme;

  /// Creates a new [WaveApp].
  WaveApp({required this.theme, required Widget child, super.key}) : super(child: _GlobalThemeWrapper(child: child));

  @override
  bool updateShouldNotify(WaveApp oldWidget) => theme != oldWidget.theme;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<WaveTheme>('theme', theme));
  }
}

/// A wrapper that applies global cursor and selection color
class _GlobalThemeWrapper extends StatelessWidget {
  final Widget child;

  const _GlobalThemeWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = WaveTheme.of(context);
    return DefaultSelectionStyle(
      cursorColor: theme.colorScheme.brandPrimary,
      selectionColor: theme.colorScheme.brandPrimary.withValues(alpha: 0.3),
      child: DefaultTextStyle(style: theme.textTheme.body, child: child),
    );
  }
}
