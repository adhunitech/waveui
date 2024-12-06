import 'package:waveui/waveui.dart';

class StateTagExample extends StatefulWidget {
  const StateTagExample({super.key});

  @override
  _StateTagExampleState createState() => _StateTagExampleState();
}

class _StateTagExampleState extends State<StateTagExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const WaveAppBar(
        title: 'Status Corner Label',
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'rule',
              style: TextStyle(
                  color: Color(0xFF222222),
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
            const WaveBubbleText(maxLines: 4, text: 'same as custom label'),
            const Text(
              'waiting state',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
            const WaveStateTag(
              tagText: 'To be done',
              tagState: TagState.waiting,
            ),
            const Text(
              'failure status',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
            const WaveStateTag(
              tagText: 'failure state',
              tagState: TagState.invalidate,
            ),
            const Text(
              'Operating status',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
            const WaveStateTag(
              tagText: 'in progress',
              tagState: TagState.running,
            ),
            const Text(
              'failure status',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
            const WaveStateTag(
              tagText: 'failure state',
              tagState: TagState.failed,
            ),
            const Text(
              'Success Status',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
            const WaveStateTag(
              tagText: 'Success status',
              tagState: TagState.succeed,
            ),
            const Text(
              'customize',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
            const WaveStateTag(
              backgroundColor: Colors.green,
              textColor: Colors.white,
              tagText:
                  'custom label custom label custom label custom label custom label custom label custom label custom label custom label',
            ),
            Container(
              height: 20,
            ),
            const WaveStateTag(
              tagText:
                  'Custom label custom label custom label long special label custom label custom label',
            ),
            const Text(
              'Exceptional case: the copy is extremely long',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
            const WaveStateTag(
              tagText:
                  'Title very long very long very long very long very long very long very long very long title very long very long very long very long very long very long very long very long very long very long very long very long very long very long Very long',
            ),
          ],
        ),
      ),
    );
  }
}
