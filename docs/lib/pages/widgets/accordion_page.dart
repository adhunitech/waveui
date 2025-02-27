import 'package:flutter/widgets.dart';
import 'package:forui_samples/pages/docs_page.dart';
import 'package:forui_samples/pages/preview_widget_page.dart';
import 'package:forui_samples/pages/widgets/accordion/accordion_example_1.dart';

class AccordionPage extends StatelessWidget {
  const AccordionPage({super.key});

  @override
  Widget build(BuildContext context) => DocsPage(
    examples: [
      PreviewWidgetPage(
        widget: AccordionExample1(),
        path: 'docs/lib/pages/widgets/accordion/accordion_example_1.dart',
        exampleName: 'Accordion',
      ),
    ],
  );
}
