import 'package:example/sample/widgets.dart';
import 'package:waveui/waveui.dart';

class SelectionViewMultiRangeExamplePage extends StatefulWidget {
  final String _title;
  final List<WaveSelectionEntity>? _filters;

  const SelectionViewMultiRangeExamplePage(this._title, this._filters, {super.key});

  @override
  _SelectionViewExamplePageState createState() => _SelectionViewExamplePageState();
}

class _SelectionViewExamplePageState extends State<SelectionViewMultiRangeExamplePage> {
  List<String>? titles;

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
              onSelectionChanged: (int menuIndex, Map<String, String> filterParams, Map<String, String> customParams,
                  WaveSetCustomSelectionMenuTitle setCustomTitleFunction) {
                showSnackBar(context, msg: filterParams.toString());
              },
              onSelectionPreShow: (int index, WaveSelectionEntity entity) {
                if (entity.key == "one_range_key" || entity.key == "two_range_key") {
                  return WaveSelectionWindowType.range;
                }
                return entity.filterShowType!;
              },
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
