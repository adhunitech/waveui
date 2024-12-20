import 'package:waveui/waveui.dart';

class OverlayWindowExample extends StatefulWidget {
  final String _title;

  const OverlayWindowExample(this._title, {super.key});

  @override
  State<StatefulWidget> createState() => OverlayWindowExamplePageState();
}

class OverlayWindowExamplePageState extends State<OverlayWindowExample> {
  WaveOverlayController? _overlayController;
  final FocusNode _focusNode = FocusNode();
  final GlobalKey _searchBarKey = GlobalKey();

  @override
  void initState() {
    super.initState();
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
            children: <Widget>[_searchBar()],
          ),
        ));
  }

  ///
  /// 搜索框
  ///
  Widget _searchBar() {
    return Container(
      child: WaveSearchText(
        key: _searchBarKey,
        innerPadding: const EdgeInsets.only(left: 32, right: 32, top: 32, bottom: 8),
        maxHeight: 84,
        innerColor: Colors.white,
        hintText: "请输入小区名称",
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        normalBorder: Border.all(
            color: const Color(0xFF999999), width: 1, style: BorderStyle.solid),
        activeBorder: Border.all(
            color: const Color(0xFF0984F9), width: 1, style: BorderStyle.solid),
        focusNode: _focusNode,
        onTextClear: () {
          _focusNode.unfocus();
          _overlayController?.removeOverlay();
          return false;
        },
        autoFocus: false,
        onActionTap: () {
          _overlayController?.removeOverlay();
        },
        onTextCommit: (text) {
          _overlayController?.removeOverlay();
        },
        onTextChange: (text) {
          if (text == '') {
            _overlayController?.removeOverlay();
            return;
          }
          if (_overlayController == null ||
              _overlayController!.isOverlayShowing == false) {
            _overlayController = WaveOverlayWindow.showOverlayWindow(
                context, _searchBarKey,
                content: _sugListView(),
                autoDismissOnTouchOutSide: true,
                popDirection: WaveOverlayPopDirection.bottom);
          }
        },
      ),
    );
  }

  ///
  /// 搜索sug
  ///
  Widget _sugListView() {
    return Container(
      width: 250,
      height: 200,
      margin: const EdgeInsets.only(left: 56),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: const Center(
          child: Text(
              '1. You can customize the search content view;\n2. Automatically display when entering keywords, and automatically close when clearing.',
              style: TextStyle(color: Colors.white))),
    );
  }

  @override
  void dispose() {
    _overlayController?.removeOverlay();
    super.dispose();
  }
}
