import 'package:waveui/waveui.dart';
import 'package:example/sample/src/guide/force_guide_example.dart';
import 'package:example/sample/src/guide/soft_intro_example.dart';
import 'package:example/sample/home/list_item.dart';

class GuideEntryPage extends StatelessWidget {
  const GuideEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WaveAppBar(
        title: "引导示例",
      ),
      body: ListView(
        children: [
          ListItem(
            title: "强引导组件",
            isShowLine: false,
            describe: '强引导组件example',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return const ForceGuideExample();
                },
              ));
            },
          ),
          ListItem(
            title: "弱引导组件",
            describe: '弱引导组件example',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return const SoftGuideExample();
                },
              ));
            },
          ),
        ],
      ),
    );
  }
}
