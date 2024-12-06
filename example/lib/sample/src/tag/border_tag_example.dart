import 'package:waveui/waveui.dart';

class BorderTagExample extends StatefulWidget {
  const BorderTagExample({super.key});

  @override
  _BorderTagExampleState createState() => _BorderTagExampleState();
}

class _BorderTagExampleState extends State<BorderTagExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WaveAppBar(
        title: "Label with Border",
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
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
        const WaveBubbleText(maxLines: 4, text: 'text size 11, spacing 3'),
        const Text(
          'Normal case',
          style: TextStyle(
            color: Color(0xFF222222),
            fontSize: 28,
          ),
        ),
        WaveTagCustom.buildBorderTag(
          tagText: 'Inventoryed',
        ),
        const Text(
          'Normal case 1',
          style: TextStyle(
            color: Color(0xFF222222),
            fontSize: 28,
          ),
        ),
        WaveTagCustom.buildBorderTag(
          tagText: 'Authentication passed',
          textColor: Colors.red,
          borderColor: Colors.red,
          borderWidth: 2,
          fontSize: 24,
          textPadding: const EdgeInsets.all(6),
        ),
      ],
    );
  }
}
