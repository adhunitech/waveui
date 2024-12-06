import 'package:example/sample/widgets.dart';
import 'package:waveui/waveui.dart';

class WaveTwoRichContentExample extends StatefulWidget {
  const WaveTwoRichContentExample({super.key});

  @override
  _WaveTwoRichContentExampleState createState() => _WaveTwoRichContentExampleState();
}

class _WaveTwoRichContentExampleState extends State<WaveTwoRichContentExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const WaveAppBar(
        title: '两列复杂文本',
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
              text: '两组key-value内容平分屏幕，每一组key-value都是一行展示，'
                  'value紧挨着key，不考虑对齐',
            ),
            const Text(
              '正常案例',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
            WaveRichInfoGrid(
              pairInfoList: <WaveRichGridInfo>[
                WaveRichGridInfo("名称：", '内容内容内容内容'),
                WaveRichGridInfo("名称：", '内容内容内容'),
                WaveRichGridInfo("名称：", '内容内容'),
                WaveRichGridInfo.valueLastClickInfo('名称', '内容内容', keyQuestionCallback: (value) {
                  showSnackBar(context, msg: value);
                }),
                WaveRichGridInfo.valueLastClickInfo('名称', '内容内容', valueQuestionCallback: (value) {
                  showSnackBar(context, msg: value);
                }),
                WaveRichGridInfo.valueLastClickInfo('名称', '内容内容',
                    valueQuestionCallback: (value) {
                      showSnackBar(context, msg: value);
                    },
                    clickTitle: "可点击内容",
                    clickCallback: (value) {
                      showSnackBar(context, msg: value);
                    }),
                WaveRichGridInfo.valueLastClickInfo('名称', '内容内容', clickTitle: "可点击内容", clickCallback: (value) {
                  showSnackBar(context, msg: value);
                }),
              ],
            ),
            const Text(
              '异常案例：key过长',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
            WaveRichInfoGrid(
              pairInfoList: <WaveRichGridInfo>[
                WaveRichGridInfo.valueLastClickInfo('名称名称名称名称名称名称名称', '内容内容', keyQuestionCallback: (value) {
                  showSnackBar(context, msg: value);
                }),
                WaveRichGridInfo("名称：", '内容内容内容'),
                WaveRichGridInfo("名称：", '内容内容'),
                WaveRichGridInfo("名称：", '内容'),
              ],
            ),
            const Text(
              '异常案例：内容过长',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
            WaveRichInfoGrid(
              pairInfoList: <WaveRichGridInfo>[
                WaveRichGridInfo.valueLastClickInfo('名称名称', '内容内容内容内容内容内容内容内容内容内容内容', keyQuestionCallback: (value) {
                  showSnackBar(context, msg: value);
                }),
                WaveRichGridInfo("名称：", '内容内容内容内容内容内容内容内容内容内容内容'),
                WaveRichGridInfo("名称：", '内容内容'),
                WaveRichGridInfo("名称：", '内容'),
              ],
            ),
            const Text(
              '异常案例：Key和Value过长',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
            WaveRichInfoGrid(
              pairInfoList: <WaveRichGridInfo>[
                WaveRichGridInfo("名称名称：", '内容内容内容内容'),
                WaveRichGridInfo.valueLastClickInfo("名称名称名称名称名称名称名称名称名称：", '内容内容内容内容内容内容内容内容内容内容内容'),
                WaveRichGridInfo("名称：", '内容内容'),
                WaveRichGridInfo("名称：", '内容'),
              ],
            ),
            const Text(
              '异常案例：可点击内容过长',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
            WaveRichInfoGrid(
              pairInfoList: <WaveRichGridInfo>[
                WaveRichGridInfo("名称名称：", '内容内容内容内容'),
                WaveRichGridInfo.valueLastClickInfo("名称名称名", '内容内容内容', clickTitle: '可点击内容可点击内容可点击内容',
                    valueQuestionCallback: (value) {
                  showSnackBar(context, msg: value);
                }),
                WaveRichGridInfo("名称：", '内容内容'),
                WaveRichGridInfo("名称：", '内容'),
              ],
            )
          ],
        ),
      ),
    );
  }
}
