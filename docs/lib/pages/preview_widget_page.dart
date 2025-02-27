import 'package:forui/forui.dart';
import 'package:flutter/widgets.dart';

class PreviewWidgetPage extends StatelessWidget {
  final String exampleName;
  final String path;
  final Widget widget;
  const PreviewWidgetPage({required this.widget, required this.path, required this.exampleName, super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(exampleName, style: FTheme.of(context).typography.body.copyWith(fontSize: 24, fontWeight: FontWeight.w600)),
      const SizedBox(height: 16),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: FTheme.of(context).colorScheme.secondary,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 200, minWidth: double.infinity),
          child: Center(child: widget),
        ),
      ),
    ],
  );
}
