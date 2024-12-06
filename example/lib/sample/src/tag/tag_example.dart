import 'package:waveui/waveui.dart';
import 'package:example/sample/src/tag/border_tag_example.dart';
import 'package:example/sample/src/tag/custom_tag_example.dart';
import 'package:example/sample/src/tag/delete_tag_example.dart';
import 'package:example/sample/src/tag/select_tag_example.dart';
import 'package:example/sample/src/tag/state_tag_example.dart';
import 'package:example/sample/src/tag/tag_row_example.dart';
import 'package:example/sample/home/list_item.dart';

class TagExample extends StatelessWidget {
  const TagExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WaveAppBar(
        title: "Label Example",
      ),
      body: ListView(
        children: [
          ListItem(
            title: "Select Label",
            isShowLine: false,
            describe: 'Single-select, multi-select tags',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return const SelectTagExamplePage();
                },
              ));
            },
          ),
          ListItem(
            title: "Delete Label",
            describe: 'Deletable label',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return const DeleteTagExamplePage();
                },
              ));
            },
          ),
          ListItem(
            title: "Custom Label",
            describe: 'key width up to 92, value is left-aligned',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return const CustomTagExample();
                },
              ));
            },
          ),
          ListItem(
            title: "Status Label",
            describe: 'Default yellow, support setting other colors',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return const StateTagExample();
                },
              ));
            },
          ),
          ListItem(
            title: "Border Color",
            describe: 'Default theme color, support setting other colors',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return const BorderTagExample();
                },
              ));
            },
          ),
          ListItem(
            title: "Label Group",
            describe: 'Multiple labels combined together label',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return const RowTagExample();
                },
              ));
            },
          ),
        ],
      ),
    );
  }
}
