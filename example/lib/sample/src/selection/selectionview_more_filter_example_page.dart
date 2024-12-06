import 'package:waveui/waveui.dart';

class SelectionViewMoreFilterExamplePage extends StatefulWidget {
  final String _title;
  final List<WaveSelectionEntity>? _filters;

  const SelectionViewMoreFilterExamplePage(this._title, this._filters, {super.key});

  @override
  _SelectionViewExamplePageState createState() =>
      _SelectionViewExamplePageState();
}

class _SelectionViewExamplePageState
    extends State<SelectionViewMoreFilterExamplePage> {
  int count = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: WaveAppBar(title: widget._title),
        body: Column(
          children: <Widget>[
            WaveSelectionView(
              originalSelectionData: widget._filters!,
              onMoreSelectionMenuClick: (int index, WaveOpenMorePage openMore) {
                openMore(updateData: false);
              },
              onSelectionChanged: (int menuIndex,
                  Map<String, String> filterParams,
                  Map<String, String> customParams,
                  WaveSetCustomSelectionMenuTitle setCustomTitleFunction) {},
            ),
            Container(
              padding: const EdgeInsets.only(top: 400),
              alignment: Alignment.center,
              child: const Text("背景内容区域"),
            )
          ],
        ));
  }
}
