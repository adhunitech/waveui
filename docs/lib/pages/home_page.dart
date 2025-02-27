import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder:
        (context, constraints) => Scaffold(
          drawer: constraints.maxWidth > 720 ? null : _drawer(),
          appBar: AppBar(title: const Text('data')),
          body: Row(children: [if (constraints.maxWidth > 720) const Drawer(), Expanded(child: _body())]),
        ),
  );

  Widget _body() => const Center(child: Text('Content goes here'));
  Widget _drawer() => const Drawer();
}
