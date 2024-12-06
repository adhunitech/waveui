import 'dart:math';

import 'package:example/sample/widgets.dart';
import 'package:waveui/waveui.dart';

class TextContentExample extends StatefulWidget {
  const TextContentExample({super.key});

  @override
  _TextContentExampleState createState() => _TextContentExampleState();
}

class _TextContentExampleState extends State<TextContentExample> {
  late List<WaveInfoModal> list;

  @override
  void initState() {
    super.initState();
    list = [
      WaveInfoModal(keyPart: "Name:", valuePart: "Content Content Content Content"),
      WaveInfoModal(keyPart: "Name:", valuePart: "Content Content Content Content Content"),
      WaveInfoModal(keyPart: "Name Name:", valuePart: "Content Content Content Content Content"),
      WaveInfoModal(keyPart: "Name Name:", valuePart: "Content Content Content Content Content"),
      WaveInfoModal(keyPart: "Name Name:", valuePart: "Content Content Content Content Content"),
      WaveInfoModal(keyPart: "Name Name:", valuePart: "Content Content Content Content Content"),
      WaveInfoModal(
          keyPart: "name name name name name:",
          valuePart:
              "content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content"),
      WaveInfoModal.valueLastClickInfo("Name:", 'Content content', 'Clickable content', clickCallback: (text) {
        showSnackBar(context, msg: text!);
      })
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const WaveAppBar(
        title: 'Single-column display left-aligned',
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'rule',
              style: TextStyle(color: Color(0xFF222222), fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const WaveBubbleText(
              maxLines: 4,
              text:
                  'The width of the key is at most 92, the value is left-aligned, and the key and value can be wrapped when they are too long',
            ),
            const Text(
              'Normal case',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
            GestureDetector(
              onTap: () {
                showSnackBar(context, msg: 'click');
              },
              child: WavePairInfoTable(
                children: <WaveInfoModal>[
                  WaveInfoModal(keyPart: "Name:", valuePart: "Content Content Content Content"),
                  WaveInfoModal(
                      keyPart: "Name Name:",
                      valuePart: const Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Test valuevalu content content valuevalu content content',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xFF222222),
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Text(
                            '2000 dollars',
                            style: TextStyle(
                              color: Color(0xFF222222),
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          )
                        ],
                      )),
                  WaveInfoModal(
                      keyPart: "Name Name:",
                      valuePart: const Row(
                        children: [
                          Expanded(
                            child: Text(
                              '测试 valueva',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xFF222222),
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Text(
                            '2000元',
                            style: TextStyle(
                              color: Color(0xFF222222),
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          )
                        ],
                      )),
                  WaveInfoModal(
                      keyPart: "Name Name:",
                      valuePart: const Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Test valuevalue content content',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xFF222222),
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Text(
                            '2000元',
                            style: TextStyle(
                              color: Color(0xFF222222),
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          )
                        ],
                      )),
                  WaveInfoModal(
                      keyPart: "Name Name:",
                      valuePart: const Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Test valuevalue content',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xFF222222),
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Text(
                            '2000元',
                            style: TextStyle(
                              color: Color(0xFF222222),
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          )
                        ],
                      )),
                  WaveInfoModal(
                      keyPart: "总费用：",
                      valuePart: const Row(
                        children: [
                          Expanded(
                            child: Text(
                              '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xFF222222),
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Text(
                            '8000元',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          )
                        ],
                      )),
                ],
              ),
            ),
            const Text(
              'Normal case',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
            WaveAlignPairInfo(
              children: <WaveInfoModal>[
                WaveInfoModal(keyPart: "Name:", valuePart: "Content Content Content Content"),
                WaveInfoModal(keyPart: "Name:", valuePart: "Content Content Content Content Content"),
                WaveInfoModal(keyPart: "Name Name:", valuePart: "Content Content Content Content Content"),
                WaveInfoModal(
                    keyPart: "Name Name Name Name:",
                    valuePart:
                        "Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content"),
              ],
            ),
            const Text(
              'Normal case',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
            GestureDetector(
              onTap: () {
                showSnackBar(context, msg: 'clicked the card');
              },
              child: WaveAlignPairInfo(
                children: <WaveInfoModal>[
                  WaveInfoModal(keyPart: "Name 1:", valuePart: "Content Content Content Content"),
                  WaveInfoModal(keyPart: "Name:", valuePart: "Content Content Content Content Content"),
                  WaveInfoModal(keyPart: "Name Name:", valuePart: "Content Content Content Content Content"),
                  WaveInfoModal(
                      keyPart: "name name name name name:",
                      valuePart:
                          "content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content"),
                  WaveInfoModal.valueLastClickInfo("name name:", '11111111', '22222222', clickCallback: (text) {
                    showSnackBar(context, msg: text!);
                  }),
                ],
              ),
            ),
            const Text(
              'Normal case',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
            WavePairInfoTable(
              expandAtIndex: 3,
              isFolded: false,
              children: <WaveInfoModal>[
                WaveInfoModal(keyPart: "Name:", valuePart: "Content Content Content Content"),
                WaveInfoModal(keyPart: "Name:", valuePart: "Content Content Content Content Content"),
                WaveInfoModal(keyPart: "Name Name:", valuePart: "Content Content Content Content Content"),
                WaveInfoModal(keyPart: "Name Name:", valuePart: "Content Content Content Content Content"),
                WaveInfoModal(keyPart: "Name Name:", valuePart: "Content Content Content Content Content"),
                WaveInfoModal(keyPart: "Name Name:", valuePart: "Content Content Content Content Content"),
                WaveInfoModal(
                    keyPart: "Name Name Name Name:",
                    valuePart:
                        "Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content"),
                WaveInfoModal.valueLastClickInfo("Name:", 'Content content', 'Clickable content',
                    clickCallback: (text) {
                  showSnackBar(context, msg: text!);
                }),
              ],
            ),
            const Text(
              'Normal case: dynamic append',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
            Stack(
              children: <Widget>[
                WaveAlignPairInfo(
                  children: list,
                ),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          list.add(
                            WaveInfoModal(keyPart: "name:", valuePart: "content content content content"),
                          );
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 30),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                          colors: [Colors.white.withAlpha(100), Colors.white, Colors.white],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        )),
                        child: Row(
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.only(right: 4),
                              child: Text(
                                '更多',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF999999),
                                ),
                              ),
                            ),
                            Transform.rotate(angle: pi, child: WaveUITools.getAssetImage('icons/icon_up_arrow.png')),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
            const Text(
              'Normal case: dynamic collapse',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
            Stack(
              children: <Widget>[
                WaveAlignPairInfo(
                  children: list,
                ),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          list.removeLast();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 30),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                          colors: [Colors.white.withAlpha(100), Colors.white, Colors.white],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        )),
                        child: Row(
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.only(right: 4),
                              child: Text(
                                '收起',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF999999),
                                ),
                              ),
                            ),
                            Transform.rotate(angle: pi, child: WaveUITools.getAssetImage('icons/icon_down_arrow.png')),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
            const Text(
              'Exception case: key is too long',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
            WaveAlignPairInfo(
              children: <WaveInfoModal>[
                WaveInfoModal(keyPart: "Name:", valuePart: "Content Content Content Content"),
                WaveInfoModal(keyPart: "Name:", valuePart: "Content Content Content Content Content"),
                WaveInfoModal(
                    keyPart: "111111111111111111111111111111111:",
                    valuePart: "Content Content Content Content Content"),
                WaveInfoModal(keyPart: "Name Name:", valuePart: "Content Content Content Content Content"),
                WaveInfoModal.valueLastClickInfo("The name is very long, the name is very long, the name is very long:",
                    'Content Content Content Content Content', 'Clickable Content', clickCallback: (text) {
                  showSnackBar(context, msg: text!);
                }),
              ],
            ),
            const Text(
              'Exception case: the content is too long',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
            WaveAlignPairInfo(
              children: <WaveInfoModal>[
                WaveInfoModal(
                    keyPart: "Name:",
                    valuePart:
                        "Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content"),
                WaveInfoModal(keyPart: "Name:", valuePart: "Content Content Content Content Content"),
                WaveInfoModal(keyPart: "Normal Name:", valuePart: "Content Content Content Content Content"),
                WaveInfoModal(
                    keyPart: "Name Name:",
                    valuePart:
                        "Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content"),
                WaveInfoModal.valueLastClickInfo(
                    "Name very long name very long name very long name very long:",
                    'Content Content Content Content Content',
                    'Clickable contentClickable contentClickable contentClickable contentClickable contentClickable content',
                    clickCallback: (text) {
                  showSnackBar(context, msg: text!);
                }),
              ],
            ),
            const Text(
              'Exception case an element is missing',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
            WaveAlignPairInfo(
              children: <WaveInfoModal>[
                WaveInfoModal(keyPart: "Missing content:", valuePart: null),
                WaveInfoModal(keyPart: "", valuePart: "Name is missing"),
                WaveInfoModal(keyPart: "", valuePart: ""),
                WaveInfoModal(
                    keyPart: "all of the above are missing:",
                    valuePart: "content content content content content content"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
