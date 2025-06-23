import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:waveui/src/theme/theme.dart';

/// Root widget for setting WaveUI configuration and global text selection styles.
class WaveApp extends InheritedWidget {
  final WaveTheme theme;

  WaveApp({required this.theme, required Widget child, super.key}) : super(child: _GlobalThemeWrapper(child: child));

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

/// A wrapper that applies global cursor and selection color
class _GlobalThemeWrapper extends StatelessWidget {
  final Widget child;

  const _GlobalThemeWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = WaveApp.themeOf(context);
    return DefaultSelectionStyle(
      cursorColor: theme.colorScheme.brandPrimary,
      selectionColor: theme.colorScheme.brandPrimary.withValues(alpha: 0.3),
      child: DefaultTextStyle(style: theme.textTheme.body, child: child),
    );
  }
}
