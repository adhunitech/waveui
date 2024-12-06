import 'package:waveui/waveui.dart';

class PopWindowExamplePage extends StatefulWidget {
  final String _title;

  const PopWindowExamplePage(this._title, {super.key});

  @override
  State<StatefulWidget> createState() => PopWindowExamplePageState();
}

class PopWindowExamplePageState extends State<PopWindowExamplePage> {
  GlobalKey? _leftKey;
  GlobalKey? _leftKey1;
  GlobalKey? _leftKey2;
  GlobalKey? _leftKey3;
  GlobalKey? _leftKey4;
  GlobalKey? _leftKey5;
  GlobalKey? _leftKey6;
  GlobalKey? _leftKey7;

  WaveOverlayController? overlayController;

  @override
  void initState() {
    super.initState();
    _leftKey = GlobalKey();
    _leftKey1 = GlobalKey();
    _leftKey2 = GlobalKey();
    _leftKey3 = GlobalKey();
    _leftKey4 = GlobalKey();
    _leftKey5 = GlobalKey();
    _leftKey6 = GlobalKey();
    _leftKey7 = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: WaveAppBar(
          title: widget._title,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: ElevatedButton(
                  key: _leftKey,
                  onPressed: () {
                    WavePopupWindow.showPopWindow(
                        context, "prompt content", _leftKey!,
                        hasCloseIcon: true);
                  },
                  child: const Text("Close Tips on the left side"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: ElevatedButton(
                  key: _leftKey1,
                  onPressed: () {
                    WavePopupWindow.showPopWindow(
                        context,
                        "prompt content prompt content prompt content prompt content prompt content prompt content prompt content prompt content prompt content prompt content prompt content",
                        _leftKey1!,
                        hasCloseIcon: false);
                  },
                  child: const Text("With no closing Tips on the left"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: ElevatedButton(
                  key: _leftKey2,
                  onPressed: () {
                    WavePopupWindow.showPopWindow(
                        context,
                        "Prompt Content Prompt Content Prompt Content Prompt Content Prompt Content Prompt Content Prompt Content Prompt Content Prompt Content Prompt Content Prompt Content",
                        _leftKey2!,
                        popDirection: WavePopupDirection.top,
                        hasCloseIcon: true);
                  },
                  child: const Text(
                      "The left side is closed, the arrow points down Tips"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: ElevatedButton(
                  key: _leftKey3,
                  onPressed: () {
                    WavePopupWindow.showPopWindow(
                        context,
                        "Prompt Content Prompt Content Prompt Content Prompt Content Prompt Content Prompt Content Prompt Content Prompt Content Prompt Content",
                        _leftKey3!,
                        dismissCallback: () {},
                        popDirection: WavePopupDirection.top);
                  },
                  child: const Text(
                      "There is no closure on the left, the arrow points down Tips"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 250),
                child: ElevatedButton(
                  key: _leftKey4,
                  onPressed: () {
                    WavePopupWindow.showPopWindow(
                        context,
                        "Prompt Content Prompt Content Prompt Content Prompt Content Prompt Content Prompt Content Prompt Content Prompt Content Prompt Content",
                        _leftKey4!,
                        hasCloseIcon: true,
                        dismissCallback: () {},
                        popDirection: WavePopupDirection.bottom);
                  },
                  child: const Text("Close Tips on the right side"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 250),
                child: ElevatedButton(
                  key: _leftKey5,
                  onPressed: () {
                    WavePopupWindow.showPopWindow(
                        context,
                        "prompt content prompt content prompt content prompt content",
                        _leftKey5!,
                        hasCloseIcon: false,
                        dismissCallback: () {},
                        popDirection: WavePopupDirection.bottom);
                  },
                  child: const Text("No closing Tips on the right"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 250),
                child: ElevatedButton(
                  key: _leftKey6,
                  onPressed: () {
                    WavePopupWindow.showPopWindow(
                        context,
                        "prompt content prompt content prompt content prompt content prompt content prompt content prompt content",
                        _leftKey6!,
                        hasCloseIcon: true,
                        canWrap: false,
                        dismissCallback: () {},
                        popDirection: WavePopupDirection.top);
                  },
                  child: const Text(
                      "The right side is closed, the arrow points down Tips"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 250),
                child: ElevatedButton(
                  key: _leftKey7,
                  onPressed: () {
                    WavePopupWindow.showPopWindow(
                        context,
                        "prompt content prompt content prompt content prompt content prompt content prompt content prompt content",
                        _leftKey7!,
                        hasCloseIcon: false,
                        dismissCallback: () {},
                        popDirection: WavePopupDirection.top);
                  },
                  child: const Text(
                      "There is no closure on the right, and the arrow points down Tips"),
                ),
              ),
            ],
          ),
        ));
  }
}
