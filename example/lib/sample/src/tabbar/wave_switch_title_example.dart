import 'package:example/sample/widgets.dart';
import 'package:waveui/waveui.dart';

class WaveSwitchTitleExample extends StatefulWidget {
  const WaveSwitchTitleExample({super.key});

  @override
  _WaveSwitchTitleExampleState createState() => _WaveSwitchTitleExampleState();
}

class _WaveSwitchTitleExampleState extends State<WaveSwitchTitleExample> with TickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      initialIndex: 1,
      length: 3,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const WaveAppBar(
        title: '一级标题',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
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
                text: "默认颜色文字颜色0XFF243238，选中文字颜色为主题色，title之间水平间距为20，"
                    "上下间距为14，title下面有分割线。只有一个标题时，不显示下划线、分割线和选中态",
              ),
              const Text(
                '正常案例',
                style: TextStyle(
                  color: Color(0xFF222222),
                  fontSize: 28,
                ),
              ),
              WaveSwitchTitle(
                nameList: const ['标题内容'],
                onSelect: (value) {
                  showSnackBar(
                    context,
                    msg: value.toString(),
                  );
                },
              ),
              const Text(
                '正常案例',
                style: TextStyle(
                  color: Color(0xFF222222),
                  fontSize: 28,
                ),
              ),
              WaveSwitchTitle(
                nameList: const ['标题内容1', '标题内容2'],
                indicatorWeight: 0,
                indicatorWidth: 0,
                padding: const EdgeInsets.all(0),
                selectedTextStyle: const TextStyle(fontSize: 24),
                unselectedTextStyle: const TextStyle(fontSize: 12),
                onSelect: (value) {
                  showSnackBar(
                    context,
                    msg: value.toString(),
                  );
                },
              ),
              const Text(
                '正常案例:外部调用tab切换',
                style: TextStyle(
                  color: Color(0xFF222222),
                  fontSize: 28,
                ),
              ),
              WaveSwitchTitle(
                nameList: const ['标题内容1', '标题内容2', '标题内容3'],
                defaultSelectIndex: 0,
                controller: _controller,
                onSelect: (value) {
                  showSnackBar(
                    context,
                    msg: value.toString(),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: OutlinedButton(
                  child: const Text('点击选中第二个'),
                  onPressed: () {
                    _controller.index = 1;
                  },
                ),
              ),
              const Text(
                '异常案例个数特别多',
                style: TextStyle(
                  color: Color(0xFF222222),
                  fontSize: 28,
                ),
              ),
              WaveSwitchTitle(
                nameList: const ['标题内容1', '标题内容2', '标题内容3', '标题内容4', '标题内容5', '标题内容6'],
                defaultSelectIndex: 0,
                onSelect: (value) {
                  showSnackBar(
                    context,
                    msg: value.toString(),
                  );
                },
              ),
              const Text(
                '异常案例文案过长',
                style: TextStyle(
                  color: Color(0xFF222222),
                  fontSize: 28,
                ),
              ),
              WaveSwitchTitle(
                nameList: const [
                  '标题内容1',
                  '标题内容标题内容标题内容标题内容标题内容标题内容2',
                  '标题内容3',
                ],
                defaultSelectIndex: 0,
                onSelect: (value) {
                  showSnackBar(
                    context,
                    msg: value.toString(),
                  );
                },
              ),
              const Text(
                '异常案例文案长度为1',
                style: TextStyle(
                  color: Color(0xFF222222),
                  fontSize: 28,
                ),
              ),
              WaveSwitchTitle(
                nameList: const [
                  '1',
                  '2',
                  '3',
                ],
                defaultSelectIndex: 0,
                onSelect: (value) {
                  showSnackBar(
                    context,
                    msg: value.toString(),
                  );
                },
              ),
              const Text(
                '异常案例文案长度为0',
                style: TextStyle(
                  color: Color(0xFF222222),
                  fontSize: 28,
                ),
              ),
              WaveSwitchTitle(
                nameList: const [
                  '1',
                  '2',
                  '3',
                ],
                defaultSelectIndex: 0,
                onSelect: (value) {
                  showSnackBar(
                    context,
                    msg: value.toString(),
                  );
                },
              ),
              WaveSwitchTitle(
                nameList: const [
                  '1',
                  '',
                  '3',
                ],
                defaultSelectIndex: 0,
                onSelect: (value) {
                  showSnackBar(
                    context,
                    msg: value.toString(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
