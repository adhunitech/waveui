import 'package:flutter/material.dart';

import 'package:forui/forui.dart';

class AccordionExample1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) => FAccordion(
    items: [
      FAccordionItem(
        title: const Text('Is it accessible?'),
        child: const Text('Yes. It adheres to the WAI-ARIA design pattern.'),
      ),
      FAccordionItem(
        initiallyExpanded: true,
        title: const Text('Is it Styled?'),
        child: const Text("Yes. It comes with default styles that matches the other components' aesthetics"),
      ),
      FAccordionItem(
        title: const Text('Is it Animated?'),
        child: const Text('Yes. It is animated by default, but you can disable it if you prefer'),
      ),
    ],
  );
}
