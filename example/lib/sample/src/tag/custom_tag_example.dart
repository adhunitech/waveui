import 'package:waveui/waveui.dart';

class CustomTagExample extends StatefulWidget {
  const CustomTagExample({super.key});

  @override
  _CustomTagExampleState createState() => _CustomTagExampleState();
}

class _CustomTagExampleState extends State<CustomTagExample> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      appBar: WaveAppBar(
        title: 'Custom label',
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'rule',
              style: TextStyle(
                  color: Color(0xFF222222),
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
            WaveBubbleText(
                maxLines: 4,
                text:
                    'The text of the label is size 11, the top, bottom, left, and right margins are 3, and the rounded corners are 2. It supports custom background color and text color'),
            Text(
              'Normal case',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
            WaveTagCustom(
              tagText: 'custom label',
            ),
            Text(
              'Normal case',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
            Text(
              'Exceptional case: the copy is extremely long',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
            WaveTagCustom(
              tagText:
                  'Title very long very long very long very long very long very long very long very long title very long very long very long very long very long very long very long very long very long very long very long very long very long very long Very long',
            ),
          ],
        ),
      ),
    );
  }
}
