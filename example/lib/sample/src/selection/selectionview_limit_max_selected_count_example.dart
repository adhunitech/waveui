import 'package:example/sample/widgets.dart';
import 'package:waveui/waveui.dart';

class SelectionViewLimitMaxSelectedCountExamplePage extends StatefulWidget {
  final String _title;
  final List<WaveSelectionEntity> _filterData;

  const SelectionViewLimitMaxSelectedCountExamplePage(this._title, this._filterData, {super.key});

  @override
  _SelectionViewExamplePageState createState() => _SelectionViewExamplePageState();
}

class _SelectionViewExamplePageState extends State<SelectionViewLimitMaxSelectedCountExamplePage> {
  List<WaveSelectionEntity>? items;

  WaveSelectionViewController? controller;

  @override
  void initState() {
    super.initState();

    controller = WaveSelectionViewController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WaveAppBar(title: widget._title),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 20),
            alignment: Alignment.center,
            child: GestureDetector(
              child: const Text("点击关闭弹窗"),
              onTap: () {
                controller!.closeSelectionView();
              },
            ),
          ),
          WaveSelectionView(
            selectionViewController: controller,
            originalSelectionData: widget._filterData,
            onSelectionChanged: (int menuIndex, Map<String, String> filterParams, Map<String, String> customParams,
                WaveSetCustomSelectionMenuTitle setCustomTitleFunction) {
              showSnackBar(
                context,
                msg: 'filterParams : $filterParams' ',\n customParams : $customParams',
              );
            },
            onMenuClickInterceptor: (index) {
              if (index == 4) {
                showSnackBar(context, msg: '第$index个被拦截了');
                return true;
              } else {
                return false;
              }
            },
            onSelectionPreShow: (int index, WaveSelectionEntity entity) {
              if (entity.key == "role" || entity.key == "guidePrice") {
                return WaveSelectionWindowType.range;
              }
              return entity.filterShowType!;
            },
          ),
          Container(
            padding: const EdgeInsets.only(top: 300),
            alignment: Alignment.center,
            child: const Text("背景内容区域"),
          ),
        ],
      )),
    );
  }
}
