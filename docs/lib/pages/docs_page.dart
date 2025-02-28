import 'dart:html' as html;
import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

class DocsPage extends StatelessWidget {
  final List<Widget> examples;
  final String title;
  final String description;
  final String apiPath;
  const DocsPage({
    required this.examples,
    required this.title,
    required this.description,
    required this.apiPath,
    super.key,
  });

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: FTheme.of(context).typography.h2),
          const SizedBox(height: 16),
          Text(description, style: FTheme.of(context).typography.body),
          const SizedBox(height: 12),
          FButton(
            onPress: () {
              final url = 'https://pub.dev/documentation/waveui/latest/$apiPath/';
              html.window.open(url, '_blank');
            },
            label: const Text('API Reference'),
            style: FButtonStyle.secondary,
            suffix: FIcon(FAssets.icons.arrowUpRight),
          ),
          const SizedBox(height: 24),
          ...examples,
        ],
      ),
    ),
  );
}
