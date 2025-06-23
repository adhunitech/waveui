import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:waveui/waveui.dart';

Future<T?> showWaveDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  bool useSafeArea = true,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
}) {
  final CapturedThemes themes = InheritedTheme.capture(
    from: context,
    to: Navigator.of(context, rootNavigator: useRootNavigator).context,
  );
  final theme = WaveApp.themeOf(context);

  return Navigator.of(context, rootNavigator: useRootNavigator).push<T>(
    PageRouteBuilder<T>(
      opaque: false,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.transparent,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      settings: routeSettings,
      pageBuilder:
          (context, animation, secondaryAnimation) => themes.wrap(
            Builder(
              builder:
                  (context) => Stack(
                    children: [
                      GestureDetector(
                        onTap: barrierDismissible ? () => Navigator.of(context).maybePop() : null,
                        // TODO: Fix background blur is not smooth
                        child: AnimatedBuilder(
                          animation: animation,
                          builder:
                              (context, child) => BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 3.0 * animation.value, sigmaY: 3.0 * animation.value),
                                child: Container(
                                  color: theme.colorScheme.scrim.withValues(alpha: 0.2 * animation.value),
                                ),
                              ),
                        ),
                      ),
                      Center(child: SafeArea(top: useSafeArea, bottom: useSafeArea, child: builder(context))),
                    ],
                  ),
            ),
          ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(parent: animation, curve: Curves.easeOut, reverseCurve: Curves.easeIn);
        return FadeTransition(opacity: curvedAnimation, child: child);
      },
    ),
  );
}

Future<void> showWaveDialogSheet({
  required BuildContext context,
  required String title,
  required String message,
  required List<Widget> actions,
}) async {
  await showWaveModalBottomSheet(
    context: context,
    builder:
        (context) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: WaveApp.themeOf(context).textTheme.h4),
                const SizedBox(height: 12),
                Text(
                  message,
                  style: WaveApp.themeOf(
                    context,
                  ).textTheme.body.copyWith(color: WaveApp.themeOf(context).colorScheme.textSecondary),
                ),
                const SizedBox(height: 16),
                Row(spacing: 12, children: actions.map((e) => Expanded(child: e)).toList()),
              ],
            ),
          ),
        ),
  );
}
