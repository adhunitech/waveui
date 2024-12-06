import 'package:waveui/waveui.dart';
import 'package:example/sample/src/step/wave_horizontal_step_example.dart';
import 'package:example/sample/src/step/step_line_example.dart';
import 'package:example/sample/home/list_item.dart';

class StepExample extends StatelessWidget {
  const StepExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WaveAppBar(
        title: "步骤条示例",
      ),
      body: ListView(
        children: [
          ListItem(
            title: "横向步骤条",
            isShowLine: false,
            describe: "显示流程阶段，告知用户'我在哪/我能去哪'，跟随主题色",
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return const WaveHorizontalStepExamplePage(title: "步骤条");
                },
              ));
            },
          ),
          ListItem(
            title: "竖向步骤条",
            describe: '显示步骤、时间线',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return const StepLineExample();
                },
              ));
            },
          ),
        ],
      ),
    );
  }
}
