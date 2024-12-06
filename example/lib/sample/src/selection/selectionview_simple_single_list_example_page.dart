import 'package:example/sample/widgets.dart';
import 'package:waveui/waveui.dart';
import 'package:example/sample/src/selection/filter_entity.dart';

class SelectionViewSimpleSingleListExamplePage extends StatefulWidget {
  final String _title;
  final WaveFilterEntity _filterData;

  const SelectionViewSimpleSingleListExamplePage(this._title, this._filterData, {super.key});

  @override
  _SelectionViewExamplePageState createState() => _SelectionViewExamplePageState();
}

class _SelectionViewExamplePageState extends State<SelectionViewSimpleSingleListExamplePage> {
  List<WaveSelectionEntity>? items;

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
            WaveSimpleSelection.radio(
              menuName: widget._filterData.name,
              menuKey: widget._filterData.key ?? 'defaultMenuKey',
              items: widget._filterData.children,
              defaultValue: widget._filterData.defaultValue,
              onSimpleSelectionChanged: (List<ItemEntity> filterParams) {
                showSnackBar(
                  context,
                  msg: filterParams.map((e) => e.value).toList().join(','),
                );
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
