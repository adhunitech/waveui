import 'dart:math';

import 'package:waveui/waveui.dart';

class WaveShadowExample extends StatefulWidget {
  const WaveShadowExample({super.key});

  @override
  _WaveShadowExampleState createState() => _WaveShadowExampleState();
}

class _WaveShadowExampleState extends State<WaveShadowExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const WaveAppBar(
        title: '阴影卡片',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(
            20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                '规则',
                style: TextStyle(
                    color: Color(0xFF222222),
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
              const WaveBubbleText(
                  maxLines: 2,
                  text: '头部icon需要显示主题相关的icon，线条需要时圆头\n,'
                      '线条的高度随着左侧内容变化而改变，线宽2'),
              const Text(
                '正常案例',
                style: TextStyle(
                  color: Color(0xFF222222),
                  fontSize: 28,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              WaveShadowCard(
                padding: const EdgeInsets.all(20),
                color: Colors.white,
                child: Container(
                  color: Colors.blue[200],
                  child: const Text(
                    '阴影卡片，\n这是内容区域',
                    style: TextStyle(fontSize: 26),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const Text(
                '正常案例',
                style: TextStyle(
                  color: Color(0xFF222222),
                  fontSize: 28,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              WaveShadowCard(
                color: Colors.white,
                padding: const EdgeInsets.all(4),
                child: Container(
                  color: Colors.blue[200],
                  child: const Text(
                    '小阴影卡片，这是内容区域',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color getRandomColor() {
    return Color.fromARGB(Random().nextInt(255), Random().nextInt(255),
        Random().nextInt(255), Random().nextInt(255));
  }
}
