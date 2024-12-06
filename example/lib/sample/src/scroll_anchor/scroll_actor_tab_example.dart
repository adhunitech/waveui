import 'dart:math';

import 'package:waveui/waveui.dart';

class ScrollActorTabExample extends StatelessWidget {
  const ScrollActorTabExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WaveAppBar(
        title: 'anchor point',
      ),
      body: WaveAnchorTab(
        itemCount: 20,
        widgetIndexedBuilder: (context, index) {
          return StatefulBuilder(builder: (_, state) {
            double height = Random().nextInt(400).toDouble();
            return GestureDetector(
              child: Container(
                height: height,
                color: Color.fromARGB(
                    Random().nextInt(255),
                    Random().nextInt(255),
                    Random().nextInt(255),
                    Random().nextInt(255)),
                child: Center(child: Text('$index')),
              ),
              onTap: () {
                state(() {});
              },
            );
          });
        },
        tabIndexedBuilder: (context, index) {
          return BadgeTab(text: 'index $index');
        },
      ),
    );
  }
}
