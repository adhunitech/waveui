import 'package:flutter/material.dart' hide DialogRoute;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:forui/forui.dart';

import 'package:forui_samples/pages/home_page.dart';
import 'package:forui_samples/pages/widgets/accordion_page.dart';
import 'package:go_router/go_router.dart';

void main() {
  usePathUrlStrategy();
  runApp(ForuiSamples());
}

class ForuiSamples extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: 'Waveui Samples',
    builder: (context, child) => FTheme(data: FThemes.blue.light, child: child!),
    routerConfig: _router,
  );
}

final _router = GoRouter(
  initialLocation: '/accordion',
  routes: [
    ShellRoute(
      builder: (context, state, child) => HomePage(body: child),
      routes: [GoRoute(path: '/accordion', builder: (context, state) => const AccordionPage())],
    ),
  ],
);
