import 'package:example/sample/widgets.dart';
import 'package:waveui/waveui.dart';

///Example of the second searchba, the scene is applied below the page title
class SearchTextExample extends StatefulWidget {
  const SearchTextExample({super.key});

  @override
  _SearchTextExampleState createState() => _SearchTextExampleState();
}

class _SearchTextExampleState extends State<SearchTextExample> {
  FocusNode focusNode = FocusNode();
  WaveSearchTextController scontroller = WaveSearchTextController();

  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    textController.addListener(() {
      if (focusNode.hasFocus) {
        if (!WaveUITools.isEmpty(textController.text)) {
          scontroller.isClearShow = true;
          scontroller.isActionShow = true;
        }
      }
    });
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        if (!WaveUITools.isEmpty(textController.text)) {
          scontroller.isClearShow = true;
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WaveAppBar(
        title: 'Example search input box',
      ),
      body: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 40,
              ),
              WaveSearchText(
                focusNode: focusNode,
                controller: textController,
                searchController: scontroller..isActionShow = true,
                onTextClear: () {
                  debugPrint('sss');
                  return false;
                },
                autoFocus: true,
                onActionTap: () {
                  scontroller.isClearShow = false;
                  scontroller.isActionShow = false;
                  focusNode.unfocus();
                  showSnackBar(
                    context,
                    msg: 'Cancel',
                  );
                },
                onTextCommit: (text) {
                  showSnackBar(
                    context,
                    msg: 'submit content: $text',
                  );
                },
                onTextChange: (text) {
                  showSnackBar(
                    context,
                    msg: 'Input content: $text',
                  );
                },
              ),
              Container(
                height: 20,
              ),
              SizedBox(
                width: 200,
                child: WaveSearchText(
                  innerPadding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  maxHeight: 60,
                  innerColor: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  normalBorder: Border.all(color: const Color(0xFFF0F0F0), width: 1, style: BorderStyle.solid),
                  activeBorder: Border.all(color: const Color(0xFF0984F9), width: 1, style: BorderStyle.solid),
                  onTextClear: () {
                    debugPrint('sss');
                    focusNode.unfocus();
                    return false;
                  },
                  autoFocus: true,
                  action: Container(),
                  onActionTap: () {
                    showSnackBar(
                      context,
                      msg: 'Cancel',
                    );
                  },
                  onTextCommit: (text) {
                    showSnackBar(
                      context,
                      msg: 'submit content: $text',
                    );
                  },
                  onTextChange: (text) {
                    showSnackBar(
                      context,
                      msg: 'Input content: $text',
                    );
                  },
                ),
              )
            ],
          )),
    );
  }
}
