import 'package:example/sample/widgets.dart';
import 'package:waveui/waveui.dart';

///Tab selection view
class DeleteTagExamplePage extends StatefulWidget {
  const DeleteTagExamplePage({super.key});

  @override
  State<StatefulWidget> createState() => TagViewExamplePageState();
}

class TagViewExamplePageState extends State<DeleteTagExamplePage> {
  List<String> tagList = [
    'This is a long long long long long long long long long long long long tag',
    'Label Information',
    'Tag information label information',
    'Label Information',
    'Tag InfoTag InfoTag InfoTag Info'
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WaveAppBar(
        title: 'WaveDeleteTag',
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[_buildDeleteWidget()],
        ),
      ),
    );
  }

  Widget _buildDeleteWidget() {
    WaveDeleteTagController controller = WaveDeleteTagController(initTags: [
      'This is a long long long long long long long long long long long long tag',
      'Label Information',
      'Tag information label information',
      'Label Information',
      'Tag InfoTag InfoTag InfoTag Info'
    ]);

    return Container(
      margin: const EdgeInsets.only(top: 20),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          WaveDeleteTag(
            controller: controller,
            onTagDelete: (tags, tag, index) {
              showSnackBar(
                context,
                msg:
                    'The remaining tags are: ${tags.toString()}, the deleted tag is: $tag, the deleted tag index is $index',
              );
            },
          ),
          WaveDeleteTag(
            controller: controller,
            tagTextStyle: const TextStyle(color: Colors.blue, fontSize: 20),
            deleteIconSize: const Size(16, 16),
            onTagDelete: (tags, tag, index) {
              showSnackBar(
                context,
                msg:
                    'The remaining tags are: ${tags.toString()}, the deleted tag is: $tag, the deleted tag index is $index',
              );
            },
          ),
          WaveDeleteTag(
            controller: controller,
            tagTextStyle: const TextStyle(color: Colors.yellow),
            backgroundColor: Colors.blue,
            deleteIconColor: Colors.red,
            softWrap: false,
            onTagDelete: (tags, tag, index) {
              showSnackBar(
                context,
                msg:
                    'The remaining tags are: ${tags.toString()}, the deleted tag is: $tag, the deleted tag index is $index',
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => controller.addTag('增加的tag'),
              ),
              IconButton(
                icon: const Icon(Icons.delete_forever),
                onPressed: () => controller.deleteForIndex(0),
              )
            ],
          )
        ],
      ),
    );
  }
}
