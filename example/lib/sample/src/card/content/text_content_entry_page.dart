import 'package:waveui/waveui.dart';
import 'package:example/sample/src/card/content/keyvalue_align_content_example.dart';
import 'package:example/sample/src/card/content/keyvalue_close_content_example.dart';
import 'package:example/sample/src/card/content/number_item_example.dart';
import 'package:example/sample/src/card/content/text_value_arrow_example.dart';
import 'package:example/sample/src/card/content/wave_two_rich_content_example.dart';
import 'package:example/sample/src/card/content/wave_two_text_content_example.dart';
import 'package:example/sample/src/card/content/wave_two_text_expanded_example.dart';
import 'package:example/sample/home/list_item.dart';

class TextContentEntryPage extends StatelessWidget {
  const TextContentEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WaveAppBar(
        title: "Example text content",
      ),
      body: ListView(
        children: [
          ListItem(
            title: "Single column left alignment",
            isShowLine: false,
            describe: 'key width up to 92, value is left-aligned',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return const TextContentExample();
                },
              ));
            },
          ),
          ListItem(
            title: "Single column close to the key name",
            describe: 'Value is next to Key, Key and value are displayed in one line',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return const KeyTextCloseContentExample();
                },
              ));
            },
          ),
          ListItem(
            title: "Two columns of plain text",
            isShowLine: false,
            describe: 'Two sets of key-value display',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return const WaveTextRIchContentExample();
                },
              ));
            },
          ),
          ListItem(
            title: "Two columns of complex elements",
            isShowLine: false,
            describe: 'Elements can carry question marks, etc.',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return const WaveTwoRichContentExample();
                },
              ));
            },
          ),
          ListItem(
            title: "Enhanced digital information",
            isShowLine: false,
            describe: 'The number is a large font',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return const NumberItemRowExample();
                },
              ));
            },
          ),
          ListItem(
            title: "Plain text display can be collapsed",
            isShowLine: false,
            describe: 'Expand and collapse text',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return const WaveTextExpandedContentExample();
                },
              ));
            },
          ),
          ListItem(
            title: "Text + jump operation",
            isShowLine: false,
            describe: 'value has a jump arrow',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return const TextValueArrowContentExample();
                },
              ));
            },
          ),
        ],
      ),
    );
  }
}
