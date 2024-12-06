import 'dart:async';

import 'package:example/sample/widgets.dart';
import 'package:waveui/waveui.dart';

/// @desc    弱引导example
class SoftGuideExample extends StatefulWidget {
  const SoftGuideExample({super.key});

  @override
  _SoftGuideExampleState createState() => _SoftGuideExampleState();
}

class _SoftGuideExampleState extends State<SoftGuideExample> {
  late WaveGuide intro;

  _SoftGuideExampleState() {
    /// init Guide
    intro = WaveGuide(
      stepCount: 7,
      introMode: GuideMode.soft,

      /// use defaultTheme, or you can implement widgetBuilder function yourself
      widgetBuilder: StepWidgetBuilder.useDefaultTheme(
        tipInfo: [
          WaveTipInfoBean("标题栏", "这里是标题栏，显示当前页面的名称", ""),
          WaveTipInfoBean("标签组件", "这里是标签组件，你可以动态添加或者删除组件，当你点击后会将结果给你回传", ""),
          WaveTipInfoBean("左边的按钮", "这里是按钮，点击他试试", ""),
          WaveTipInfoBean("右边的按钮", "这里是按钮，点击他试试", ""),
          WaveTipInfoBean("左边的文本 ", "这是一个朴实无华的文本", ""),
          WaveTipInfoBean("右边文本 ", "这是一个枯燥文本", ""),
          WaveTipInfoBean("开始按钮 ", "点击开启引导动画", ""),
        ],
      ),
    );
  }

  List<String> nameList = ['这是一条很长很长很长很长很长很长很长很长很长很长的标签', '标签么么么么么', '标签么么没没没么么么', '标签么么么么么', '标签么么么么么'];

  @override
  void initState() {
    super.initState();
    Timer(const Duration(microseconds: 0), () {
      /// start the intro
      intro.start(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: WaveAppBar(
          title: Text(
            '弱引导组件example',
            key: intro.keys[0],
            style: const TextStyle(color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'WaveSelectTagWidget',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Text(
                  '流式布局的自适应标签(最小宽度75)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                WaveSelectTag(
                    key: intro.keys[1],
                    tags: nameList,
                    tagWidth: (MediaQuery.of(context).size.width - 40 - 24) / 3,
                    fixWidthMode: false,
                    onSelect: (index) {
                      showSnackBar(
                        context,
                        msg: "$index is selected",
                      );
                    }),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ElevatedButton(
                      key: intro.keys[2],
                      onPressed: () {},
                      child: const Text("需求1"),
                    ),
                    ElevatedButton(
                      key: intro.keys[3],
                      onPressed: () {},
                      child: const Text("需求2"),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 14,
                      padding: const EdgeInsets.only(top: 20),
                      alignment: Alignment.center,
                      child: Text(
                        '左边的文字',
                        key: intro.keys[4],
                      ),
                    ),
                    Container(
                      width: 14,
                      padding: const EdgeInsets.only(top: 20),
                      alignment: Alignment.center,
                      child: Text(
                        '右边的文字',
                        key: intro.keys[5],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          key: intro.keys[6],

          /// 1st guide
          child: const Icon(
            Icons.play_arrow,
          ),
          onPressed: () {
            intro.start(context);
          },
        ),
      ),
      onWillPop: () async {
        // destroy guide page when tap back key
        intro.dispose();
        return true;
      },
    );
  }
}
