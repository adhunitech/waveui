import 'package:waveui/waveui.dart';

class RowTagExample extends StatefulWidget {
  const RowTagExample({super.key});

  @override
  _RowTagExampleState createState() => _RowTagExampleState();
}

class _RowTagExampleState extends State<RowTagExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const WaveAppBar(
        title: 'Label Combination',
      ),
      body: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.start,
        spacing: 5,
        runSpacing: 5,
        children: [
          const WaveTagCustom(
            tagText: 'custom label',
          ),
          const WaveTagCustom(
            tagText: 'tag',
          ),
          WaveTagCustom.buildBorderTag(tagText: 'Label 1'),
          WaveTagCustom.buildBorderTag(tagText: 'Tag 2'),
          WaveTagCustom.buildBorderTag(
              tagText: 'Special long long long long long long label'),
          const WaveTagCustom(tagText: 'Level 1 Tag'),
          const WaveTagCustom(tagText: 'secondary tag'),
          const WaveTagCustom(tagText: 'other tags'),
          const WaveTagCustom(tagText: 'secondary tag'),
          const WaveTagCustom(tagText: 'Level 1 Tag'),
          const WaveTagCustom(tagText: 'secondary tag'),
        ],
      ),
    );
  }
}
