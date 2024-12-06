import 'package:waveui/waveui.dart';
import 'package:example/sample/src/card_title/wave_action_title_example.dart';
import 'package:example/sample/src/card_title/wave_common_title_example.dart';
import 'package:example/sample/src/tabbar/wave_switch_title_example.dart';
import 'package:example/sample/src/tabbar/sub_switch_title_example.dart';
import 'package:example/sample/home/list_item.dart';

class TitleExample extends StatelessWidget {
  const TitleExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WaveAppBar(
        title: "标题示例",
      ),
      body: ListView(
        children: [
          ListItem(
            title: "普通标题",
            isShowLine: false,
            describe: '标题+辅助widget+底部详细信息',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return const WaveCommonTitleExample();
                },
              ));
            },
          ),
          ListItem(
            title: "箭头标题",
            describe: '带有箭头的标题',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return const WaveActionTitleExample();
                },
              ));
            },
          ),
          ListItem(
            title: "一级标题",
            describe: '标题下方可切换',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return const WaveSwitchTitleExample();
                },
              ));
            },
          ),
          ListItem(
            title: "二级标题",
            describe: '标题下方可切换',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return const SubSwitchTitleExample();
                },
              ));
            },
          ),
        ],
      ),
    );
  }
}
