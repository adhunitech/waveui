import 'package:waveui/waveui.dart';
import 'package:example/sample/src/card/bubble/common_bubble_example.dart';
import 'package:example/sample/src/card/bubble/wave_expanded_bubble_example.dart';
import 'package:example/sample/home/list_item.dart';

class BubbleEntryPage extends StatelessWidget {
  const BubbleEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WaveAppBar(
        title: "气泡示例",
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListItem(
            title: "普通气泡",
            isShowLine: false,
            describe: '通栏分割线',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return const BubbleExample();
                },
              ));
            },
          ),
          ListItem(
            title: "展开收起气泡",
            describe: '左右有20dp间距的分割线',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return const WaveBubbleExample2();
                },
              ));
            },
          ),
        ],
      ),
    );
  }
}
