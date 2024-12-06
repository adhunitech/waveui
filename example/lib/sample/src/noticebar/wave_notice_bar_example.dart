import 'package:example/sample/src/noticebar/notice_bar_example.dart';
import 'package:example/sample/widgets.dart';
import 'package:waveui/waveui.dart';
import 'package:example/sample/src/noticebar/notice_bar_with_button_example.dart';
import 'package:example/sample/home/list_item.dart';

/// Description: notification style example entry

class WaveNoticeBarExample extends StatelessWidget {
  const WaveNoticeBarExample({super.key});

  @override
  Widget build(BuildContext context) {
    int caseIndex = 3;
    if (caseIndex == 0) {
      return Scaffold(
          appBar: const WaveAppBar(
            title: 'Notification',
          ),
          body: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            Column(
              children: <Widget>[
                WaveNoticeBar(
                  // minHeight: 46,
                  padding: const EdgeInsets.all(10),
                  marquee: false,
                  leftWidget: Image.asset(
                    'assets/icons/icon_calendar_next_month.png',
                    package: 'waveui',
                    width: 14.0,
                    height: 14.0,
                  ),
                  content:
                      "Please ensure that the information filled in is true and valid. Please ensure that the information filled in is true and valid. Please ensure that the information filled in is true and valid.",
                  noticeStyle: NoticeStyles.warningWithClose,
                  showRightIcon: false,
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 2),
                    ),
                    height: 50,
                    child: Center(
                      child: Text('$index'),
                    ),
                  );
                },
                itemCount: 20,
              ),
            ),
          ]));
    } else if (caseIndex == 1) {
      return Scaffold(
          appBar: const WaveAppBar(
            title: 'Notify ddd',
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(children: [
                      Container(
                        color: Colors.red,
                        height: 220,
                      ),
                      Container(
                        color: Colors.green,
                        height: 220,
                      ),
                      Container(
                        color: Colors.blue,
                        height: 220,
                      ),
                      Container(
                        color: Colors.purple,
                        height: 220,
                      ),
                      Container(
                        color: Colors.red,
                        height: 220,
                      ),
                    ]),
                  ),
                ),
              ),
              SafeArea(
                top: false,
                child: Column(
                  children: <Widget>[
                    WaveNoticeBar(
                      //minHeight: 46,
                      padding: const EdgeInsets.all(10),
                      marquee: false,
                      leftWidget: Image.asset(
                        'assets/icons/icon_calendar_next_month.png',
                        package: 'waveui',
                        width: 14.0,
                        height: 14.0,
                      ),
                      content:
                          "Please ensure that it is faithful and valid, please ensure that the information is filled in",
                      noticeStyle: NoticeStyles.warningWithClose,
                      showRightIcon: false,
                    )
                  ],
                ),
              )
            ],
          ));
    }
    return Scaffold(
      appBar: const WaveAppBar(
        title: 'Notification',
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              WaveNoticeBar(
                //minHeight: 46,
                padding: const EdgeInsets.all(10),
                marquee: false,
                leftWidget: Image.asset(
                  'assets/icons/icon_calendar_next_month.png',
                  package: 'waveui',
                  width: 14.0,
                  height: 14.0,
                ),
                content:
                    "Please ensure that please ensure that it is faithful and valid, please ensure that the information is filled in with dots",
                noticeStyle: NoticeStyles.warningWithClose,
                showRightIcon: false,
              )
            ]),
            ListItem(
              title: 'Style 1: height 36, with icons on the left and right sides',
              describe: 'Click to view more examples of style 1',
              describeColor: const Color(0xFF0984F9),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return WaveNoticeBarExample1();
                }));
              },
            ),
            WaveNoticeBar(
              content: 'This is the notification content',
              noticeStyle: NoticeStyles.runningWithArrow,
              onNoticeTap: () {
                showSnackBar(context, msg: 'click notification');
              },
              onRightIconTap: () {
                showSnackBar(
                  context,
                  msg: 'Click the icon on the right',
                );
              },
            ),
            ListItem(
              title: 'Style 2: height is 56, label on the left, text button on the right',
              describe: 'Click to view more examples of style 2',
              describeColor: const Color(0xFF0984F9),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return const WaveNoticeBarWithButtonExample();
                }));
              },
            ),
            WaveNoticeBarWithButton(
              leftTagText: 'task',
              content: 'This is the notification content',
              rightButtonText: 'Go to finish',
              onRightButtonTap: () {
                showSnackBar(context, msg: 'Click the right button');
              },
            ),
          ],
        ),
      ),
    );
  }
}
