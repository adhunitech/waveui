import 'package:example/sample/widgets.dart';
import 'package:waveui/waveui.dart';

class SubSwitchTitleExample extends StatefulWidget {
  const SubSwitchTitleExample({super.key});

  @override
  _SubSwitchTitleExampleState createState() => _SubSwitchTitleExampleState();
}

class _SubSwitchTitleExampleState extends State<SubSwitchTitleExample> with TickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      initialIndex: 0,
      length: 6,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const WaveAppBar(
        title: '二级标题',
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
                text: "默认颜色文字颜色0XFF222222，选中文字颜色为主题色，没有下划线，"
                    "title之间水平间距为20，只有一个标题时，不显示选中态",
              ),
              const Text(
                '正常案例',
                style: TextStyle(
                  color: Color(0xFF222222),
                  fontSize: 28,
                ),
              ),
              WaveSubSwitchTitle(
                nameList: const ['二级标题'],
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
              WaveSubSwitchTitle(
                nameList: const ['二级标题1', '二级标题2'],
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
              WaveSubSwitchTitle(
                nameList: const ['二级标题1', '二级标题2', '二级标题3'],
                defaultSelectIndex: 0,
                onSelect: (value) {
                  showSnackBar(
                    context,
                    msg: value.toString(),
                  );
                },
              ),
              const Text(
                '异常案例个数特别多',
                style: TextStyle(
                  color: Color(0xFF222222),
                  fontSize: 28,
                ),
              ),
              WaveSubSwitchTitle(
                nameList: const ['二级标题1', '二级标题2', '二级标题3', '二级标题4', '二级标题5', '二级标题6'],
                defaultSelectIndex: 0,
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
              WaveSubSwitchTitle(
                nameList: const ['二级标题1', '二级标题2', '二级标题3', '二级标题4', '二级标题5', '二级标题6'],
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
                  child: const Text('点击选中第三个'),
                  onPressed: () {
                    _controller.index = 2;
                  },
                ),
              ),
              const Text(
                '异常案例文案过长',
                style: TextStyle(
                  color: Color(0xFF222222),
                  fontSize: 28,
                ),
              ),
              WaveSubSwitchTitle(
                nameList: const [
                  '二级标题1',
                  '二级标题二级标题二级标题二级标题二级标题二级标题2',
                  '二级标题3',
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
              WaveSubSwitchTitle(
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
              WaveSubSwitchTitle(
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
              WaveSubSwitchTitle(
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
