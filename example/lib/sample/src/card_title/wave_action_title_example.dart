import 'package:example/sample/widgets.dart';
import 'package:waveui/waveui.dart';

class WaveActionTitleExample extends StatefulWidget {
  const WaveActionTitleExample({super.key});

  @override
  _WaveActionTitleExampleState createState() => _WaveActionTitleExampleState();
}

class _WaveActionTitleExampleState extends State<WaveActionTitleExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const WaveAppBar(
        title: '箭头标题',
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              '规则',
              style: TextStyle(color: Color(0xFF222222), fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const WaveBubbleText(
              maxLines: 4,
              text: '标题不可以折行，当辅助widget和subwidget过多时，标题...截断\n'
                  '展示出sub和ac\n'
                  '标题字体为18',
            ),
            const Text(
              '正常案例',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
            WaveActionCardTitle(
              title: '表头',
              onTap: () {
                showSnackBar(
                  context,
                  msg: 'WaveActionCardTitle is clicked',
                );
              },
            ),
            const WaveLine(
              height: 2,
              color: Colors.black12,
            ),
            const Text(
              '正常案例（自定义副标题Widget）',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
            WaveActionCardTitle(
              title: '非箭头',
              //标题右侧widget
              subTitleWidget: const Row(
                textBaseline: TextBaseline.ideographic,
                children: <Widget>[
                  Text(
                    '副标题',
                    style: TextStyle(color: Colors.red),
                  ),
                  WaveStateTag(tagText: '状态标签'),
                ],
              ),
              //整个widget的点击
              onTap: () {
                showSnackBar(
                  context,
                  msg: 'WavePlainCardTitle is clicked',
                );
              },
            ),
            const WaveLine(
              height: 2,
              color: Colors.black12,
            ),
            const Text(
              '正常案例',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
            WaveActionCardTitle(
              title: '非箭头',
              //标题右侧widget
              subTitle: "副标题",
              //整个widget的点击
              accessoryText: "点击标题",
              onTap: () {
                showSnackBar(
                  context,
                  msg: 'WavePlainCardTitle is clicked',
                );
              },
            ),
            const WaveLine(
              height: 2,
              color: Colors.black12,
            ),
            const Text(
              '正常案例',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
            WaveActionCardTitle(
              title: '标题特别长特别长特别长特别长特别长特别长特别长特别长',
              //标题右侧widget
              subTitle: "副标题",
              //整个widget的点击
              accessoryText: "点击标题",
              onTap: () {
                showSnackBar(
                  context,
                  msg: 'WavePlainCardTitle is clicked',
                );
              },
            ),
            const WaveLine(
              height: 2,
              color: Colors.black12,
            ),
            const Text(
              '异常案例：title特别长',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
            WaveActionCardTitle(
              title: '标题特别长特别长特别长特别长特别长特别长特别长特别长',
              //标题右侧widget
//              subTitle: "副标题",
              //整个widget的点击
              accessoryText: "点击标题",
              onTap: () {
                showSnackBar(
                  context,
                  msg: 'WaveActionCardTitle is clicked',
                );
              },
            ),
            const WaveLine(
              height: 2,
              color: Colors.black12,
            ),
            const Text(
              '异常案例：副标题特别长',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
            WaveActionCardTitle(
              title: '标题特别',
              //标题右侧widget
              subTitle: "副标题也特别长特别长长特别长特别长特别长特别长",
              //整个widget的点击
              accessoryText: "点击标题",
              onTap: () {
                showSnackBar(
                  context,
                  msg: 'WaveActionCardTitle is clicked',
                );
              },
            ),
            const WaveLine(
              height: 2,
              color: Colors.black12,
            ),
            const Text(
              '异常案例：跳转标题特别长',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
            WaveActionCardTitle(
              title: '标题特别',
              //标题右侧widget
              subTitle: "副标题",
              //整个widget的点击
              accessoryText: "点击标题特别长特别长特别长特别长特别长特别长",
              onTap: () {
                showSnackBar(
                  context,
                  msg: 'WaveActionCardTitle is clicked',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
