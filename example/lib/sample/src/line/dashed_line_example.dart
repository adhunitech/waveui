import 'package:waveui/waveui.dart';

class DashedLineExample extends StatefulWidget {
  const DashedLineExample({super.key});

  @override
  _DashedLineExampleState createState() => _DashedLineExampleState();
}

class _DashedLineExampleState extends State<DashedLineExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const WaveAppBar(
        title: '虚线分割线',
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              '分割线的空间是由内部内容撑开',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 18,
              ),
            ),
            // 分割线的空间是由内部内容撑开
            WaveDashedLine(
              dashedLength: 20,
              dashedThickness: 5,
              axis: Axis.vertical,
              color: Colors.red,
              dashedOffset: 20,
              position: WaveDashedLinePosition.leading,
              contentWidget: Container(
                margin:
                    const EdgeInsets.only(left: 60, right: 20, top: 10, bottom: 10),
                child: const Text(
                    "穿插介绍、公司模式一句话C端服务承诺介绍、价值穿插介绍、公司模式一句话C端服务承诺介绍、价值穿插介绍、公司模式一句话C端服务承诺介绍、价值"),
              ),
            ),
            const Text(
              '分割线的空间是由内部容器设定',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 18,
              ),
            ),
            // 分割线的空间是由内部容器设定
            const WaveDashedLine(
              dashedLength: 10,
              dashedThickness: 3,
              axis: Axis.horizontal,
              color: Colors.green,
              dashedOffset: 20,
              position: WaveDashedLinePosition.leading,
              contentWidget: SizedBox(
                width: 200,
                height: 100,
              ),
            ),
            const Text(
              '分割线的空间由外部设定',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 18,
              ),
            ),
            // 分割线的空间由外部设定
            Container(
              height: 50,
              width: 300,
              padding: const EdgeInsets.all(5),
              color: Colors.red,
              child: const WaveDashedLine(
                axis: Axis.horizontal,
                dashedOffset: 10,
                contentWidget: SizedBox(
                  width: 200,
                  height: 100,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
