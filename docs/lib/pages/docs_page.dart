import 'package:flutter/widgets.dart';

class DocsPage extends StatelessWidget {
  final List<Widget> examples;
  const DocsPage({required this.examples, super.key});

  @override
  Widget build(BuildContext context) =>
      SingleChildScrollView(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: examples)));
}
