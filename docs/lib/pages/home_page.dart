import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

class HomePage extends StatelessWidget {
  final Widget body;
  const HomePage({required this.body, super.key});

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder:
        (context, constraints) => FScaffold(
          // drawer: constraints.maxWidth > 720 ? null : _drawer(),
          header: const FHeader(title: Text('Waveui')),
          content: Row(children: [if (constraints.maxWidth > 720) _drawer(), Expanded(child: _body())]),
        ),
  );

  Widget _body() => SizedBox(width: 200, child: body);
  Widget _drawer() => const ColoredBox(color: Color(0xFFFFF000), child: SizedBox(width: 300, height: double.infinity));
}
