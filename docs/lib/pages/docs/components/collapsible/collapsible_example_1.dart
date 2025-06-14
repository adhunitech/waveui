import 'package:waveui/waveui.dart';

class CollapsibleExample1 extends StatelessWidget {
  const CollapsibleExample1({super.key});

  @override
  Widget build(BuildContext context) {
    return Collapsible(
      children: [
        const CollapsibleTrigger(
          child: Text('@adhunitech starred 3 repositories'),
        ),
        OutlinedContainer(
          child: const Text('@adhunitech/waveui').small().mono().withPadding(horizontal: 16, vertical: 8),
        ).withPadding(top: 8),
        CollapsibleContent(
          child: OutlinedContainer(
            child: const Text('@flutter/flutter').small().mono().withPadding(horizontal: 16, vertical: 8),
          ).withPadding(top: 8),
        ),
        CollapsibleContent(
          child: OutlinedContainer(
            child: const Text('@dart-lang/sdk').small().mono().withPadding(horizontal: 16, vertical: 8),
          ).withPadding(top: 8),
        ),
      ],
    );
  }
}
