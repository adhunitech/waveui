import 'package:example/sample/widgets.dart';
import 'package:waveui/waveui.dart';

class FlatSelectionFourTagsExample extends StatefulWidget {
  final String _title;
  final List<WaveSelectionEntity> _filterData;

  const FlatSelectionFourTagsExample(this._title, this._filterData, {super.key});

  @override
  _SelectionViewExamplePageState createState() => _SelectionViewExamplePageState();
}

class _SelectionViewExamplePageState extends State<FlatSelectionFourTagsExample> {
  WaveSelectionEntity? entity;

  WaveFlatSelectionController? controller;

  var selectionKey = GlobalKey();

  bool _isShow = true;

  @override
  void initState() {
    super.initState();

    controller = WaveFlatSelectionController();
  }

  @override
  void dispose() {
    controller!.dispose();
    controller = null;
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
              child: const Text("点击关闭展开"),
              onTap: () {
                setState(() {
                  _isShow = !_isShow;
                });
              },
            ),
          ),
          _isShow
              ? Column(
                  children: <Widget>[
                    Container(
                        color: Colors.white,
                        width: double.infinity,
                        height: 400,
                        child: WaveFlatSelection(
                            preLineTagSize: 4,
                            entityDataList: widget._filterData,
                            confirmCallback: (data) {
                              var str = "";
                              data.forEach((k, v) => str = str + " " + '$k: $v');
                              showSnackBar(
                                context,
                                msg: str,
                              );
                            },
                            controller: controller)),
                    _bottomWidget(),
                  ],
                )
              : Container(),
        ],
      )),
    );
  }

  Widget _bottomWidget() {
    return Column(
      children: <Widget>[
        const Divider(
          height: 0.3,
          color: Color(0xFFF0F0F0),
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(8, 11, 20, 11),
          child: Row(
            children: <Widget>[
              InkWell(
                child: Container(
                  padding: const EdgeInsets.only(left: 12, right: 20),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: WaveUITools.getAssetImage(WaveAsset.iconSelectionReset),
                      ),
                      const Text(
                        "重置",
                        style: TextStyle(fontSize: 11, color: Color(0xFF999999)),
                      )
                    ],
                  ),
                ),
                onTap: () {
                  if (controller != null) {
                    controller!.resetSelectedOptions();
                  }
                },
              ),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  OutlinedButton(
                      child: const SizedBox(
                        width: 104,
                        child: Text("取消"),
                      ),
                      onPressed: () {
                        if (controller != null) {
                          controller!.cancelSelectedOptions();
                          setState(() {
                            _isShow = false;
                          });
                        }
                      }),
                  Container(
                    width: 20,
                  ),
                  FilledButton(
                      child: const SizedBox(
                        width: 104,
                        child: Text("确定"),
                      ),
                      onPressed: () {
                        if (controller != null) {
                          controller!.confirmSelectedOptions();
                          setState(() {
                            _isShow = false;
                          });
                        }
                      }),
                ],
              ))
            ],
          ),
        )
      ],
    );
  }
}
