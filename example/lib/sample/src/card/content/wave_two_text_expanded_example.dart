import 'package:example/sample/widgets.dart';
import 'package:waveui/waveui.dart';

class WaveTextExpandedContentExample extends StatefulWidget {
  const WaveTextExpandedContentExample({super.key});

  @override
  _WaveTextExpandedContentExampleState createState() => _WaveTextExpandedContentExampleState();
}

class _WaveTextExpandedContentExampleState extends State<WaveTextExpandedContentExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const WaveAppBar(
        title: '展开收起文本',
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
              text: '显示指定行数的文本，超过的收起，点击更多会显示全部',
            ),
            const Text(
              '正常案例',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
            WaveExpandableText(
              text: '冠寓是龙湖地产的第三大主航道业务，专注做中高端租赁市场，标语是我家我自在；门店位于昌平区390号，'
                  '距离昌平线生命科学冠寓是龙湖地产的第三大主航道业务，专注做中高端租赁市场，标语是我家我自在标语是我家我自在。',
              onExpanded: (value) {
                showSnackBar(
                  context,
                  msg: "当前的状态是$value",
                );
              },
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
