import 'package:example/sample/widgets.dart';
import 'package:waveui/waveui.dart';

class KeyTextCloseContentExample extends StatefulWidget {
  const KeyTextCloseContentExample({super.key});

  @override
  _KeyTextCloseContentExampleState createState() => _KeyTextCloseContentExampleState();
}

class _KeyTextCloseContentExampleState extends State<KeyTextCloseContentExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const WaveAppBar(
        title: '单列展示紧随',
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
              text: '一行展示内容，key和value都不换行',
            ),
            const Text(
              '正常案例',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
            WavePairInfoTable(
              isValueAlign: false,
              children: <WaveInfoModal>[
                WaveInfoModal(keyPart: "名称：", valuePart: "内容内容内容内容"),
                WaveInfoModal(keyPart: "名称名：", valuePart: "内容内容内容内容内容"),
                WaveInfoModal(keyPart: "名称名称名：", valuePart: "内容内容内容内容内容"),
                WaveInfoModal(keyPart: "名称名称名称：", valuePart: "内容内容内容内容内容"),
              ],
            ),
            const Text(
              '正常案例',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
            GestureDetector(
              onTap: () {
                showSnackBar(
                  context,
                  msg: "点击了卡片",
                );
              },
              child: WavePairInfoTable(
                isValueAlign: false,
                children: <WaveInfoModal>[
                  WaveInfoModal(keyPart: "名称：", valuePart: "内容内容内容内容"),
                  WaveInfoModal(keyPart: "名称名：", valuePart: "内容内容内容内容内容"),
                  WaveInfoModal(keyPart: "名称名称名：", valuePart: "内容内容内容内容内容"),
                  WaveInfoModal.valueLastClickInfo("名称名：", '内容内容内容内容内容', '可点击内容', clickCallback: (text) {
                    showSnackBar(context, msg: text!);
                  }),
                ],
              ),
            ),
            const Text(
              '正常案例',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
            const Text(
              '异常案例：key过长',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
            WavePairInfoTable(
              isValueAlign: false,
              children: <WaveInfoModal>[
                WaveInfoModal(keyPart: "名称：", valuePart: "内容内容内容内容"),
                WaveInfoModal(keyPart: "名称名：", valuePart: "内容内容内容内容内容"),
                WaveInfoModal(keyPart: "名称十分的长名称十分的长名称十分的长名称十分的长：", valuePart: "内容内容内容内容内容"),
                WaveInfoModal(keyPart: "名称十分的长名称十分的长名称十分的长名称十分的长十分的长：", valuePart: "内容内容内容内容内容"),
                WaveInfoModal(keyPart: "名称名称名：", valuePart: "内容内容内容内容内容"),
              ],
            ),
            const Text(
              '异常案例：内容过长',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
            WavePairInfoTable(
              isValueAlign: false,
              children: <WaveInfoModal>[
                WaveInfoModal(keyPart: "名称：", valuePart: "内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容"),
                WaveInfoModal(keyPart: "名称名：", valuePart: "内容内容内容内容内容"),
                WaveInfoModal(keyPart: "名称正常：", valuePart: "内容内容内容内容内容"),
                WaveInfoModal(keyPart: "名称名称名：", valuePart: "内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容"),
                WaveInfoModal(
                    keyPart: "名称名称名：",
                    valuePart: "内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内"),
              ],
            ),
            const Text(
              '异常案例：可点击内容过长',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
            WavePairInfoTable(
              isValueAlign: false,
              expandAtIndex: 2,
              children: <WaveInfoModal>[
                WaveInfoModal(keyPart: "名称：", valuePart: "内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容"),
                WaveInfoModal(keyPart: "名称名：", valuePart: "内容内容内容内容内容"),
                WaveInfoModal(keyPart: "名称正常：", valuePart: "内容内容内容内容内容"),
                WaveInfoModal(keyPart: "名称名称名：", valuePart: "内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容"),
                WaveInfoModal(
                    keyPart: "名称名称名：",
                    valuePart: "内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内"),
                WaveInfoModal.valueLastClickInfo("名称十分的长名：", '内容内容内容内容内容', '可点击内容可点击内容可点击内容可点击内容',
                    clickCallback: (text) {
                  showSnackBar(context, msg: text!);
                }),
                WaveInfoModal.valueLastClickInfo("名称十分的长名：", '内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容', '可点击内容可点击内容可点击内容可点击内容',
                    clickCallback: (text) {
                  showSnackBar(context, msg: text!);
                }),
              ],
            ),
            const Text(
              '异常案例某个元素缺失',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
            WavePairInfoTable(
              isValueAlign: false,
              children: <WaveInfoModal>[
                WaveInfoModal(keyPart: "内容缺失：", valuePart: null),
                WaveInfoModal(keyPart: "", valuePart: "名称缺失"),
                WaveInfoModal(keyPart: "", valuePart: ""),
                WaveInfoModal(keyPart: "上面的都缺失：", valuePart: "内容内容内容内容内容"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
