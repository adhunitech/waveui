import 'package:example/sample/widgets.dart';
import 'package:waveui/waveui.dart';

/// Notification style example
class WaveNoticeBarExample1 extends StatelessWidget {
  final List<NoticeStyle> defaultStyles = [
    NoticeStyles.failWithArrow,
    NoticeStyles.failWithClose,
    NoticeStyles.runningWithArrow,
    NoticeStyles.runningWithClose,
    NoticeStyles.succeedWithArrow,
    NoticeStyles.succeedWithClose,
    NoticeStyles.warningWithArrow,
    NoticeStyles.warningWithClose,
    NoticeStyles.normalNoticeWithArrow,
    NoticeStyles.normalNoticeWithClose,
  ];

  final List<String> defaultContents = [
    "Style 1: failWithArrow fails + arrow",
    "Style 2: failWithClose fails + close",
    "Style 3: runningWithArrow running + arrow",
    "Style 4: runningWithClose running + close",
    "Style 5: succeedWithArrow success + arrow",
    "Style 6: succeedWithClose + close",
    "Style 7: warningWithArrow warning + arrow",
    "Style 8: warningWithClose warning + close",
    "Style 9: normalNoticeWithArrow normal notification + arrow",
    "Style 10: normalNoticeWithClose normal notification + close",
  ];

  WaveNoticeBarExample1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WaveAppBar(
        title: 'Notification style',
      ),
      body: SingleChildScrollView(
          child:
              Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        const Text(
          'rule',
          style: TextStyle(
            color: Color(0xFF222222),
            fontSize: 28,
          ),
        ),
        const WaveBubbleText(
          maxLines: 3,
          text:
              'Default supports 10 notification styles, supports custom icon, text color and background color, supports whether to display icon',
        ),
        const Text(
          'Normal case',
          style: TextStyle(
            color: Color(0xFF222222),
            fontSize: 28,
          ),
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
        const Text(
          'Marquee',
          style: TextStyle(
            color: Color(0xFF222222),
            fontSize: 28,
          ),
        ),
        WaveNoticeBar(
          content:
              'This is the notification content of the marquee The notification content of the marquee The notification content of the marquee The notification content of the marquee',
          marquee: true,
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
        const Text(
          'Exception case: Hide left icon',
          style: TextStyle(
            color: Color(0xFF222222),
            fontSize: 28,
          ),
        ),
        WaveNoticeBar(
          content: 'This is the notification content',
          showLeftIcon: false,
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
        const Text(
          'Exception case: hide the icon on the right',
          style: TextStyle(
            color: Color(0xFF222222),
            fontSize: 28,
          ),
        ),
        WaveNoticeBar(
          content: 'This is the notification content',
          showRightIcon: false,
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
        const Text(
          'Exception case: no icon is displayed',
          style: TextStyle(
            color: Color(0xFF222222),
            fontSize: 28,
          ),
        ),
        WaveNoticeBar(
          content: 'This is the notification content',
          showLeftIcon: false,
          showRightIcon: false,
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
        const Text(
          'Exceptional case: the notification text is extremely long',
          style: TextStyle(
            color: Color(0xFF222222),
            fontSize: 28,
          ),
        ),
        WaveNoticeBar(
          content:
              'This is the content of the notification This is the content of the notification This is the content of the notification This is the content of the notification This is the content of the notification This is the content of the notification This is the content of the notification',
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
        const Text(
          'Exception case: custom',
          style: TextStyle(
            color: Color(0xFF222222),
            fontSize: 28,
          ),
        ),
        WaveNoticeBar(
          content: 'This is the notification content',
          textColor: const Color(0xFF222222),
          //notification color
          backgroundColor: Colors.grey,
          //background color
          leftWidget: WaveUITools.getAssetImage(WaveAsset.iconMore),

          ///Left icon
          rightWidget: WaveUITools.getAssetImage(WaveAsset.iconMore),

          ///Right icon
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
        const Text(
          '10 default styles',
          style: TextStyle(
            color: Color(0xFF222222),
            fontSize: 28,
          ),
        ),
        SizedBox(
          height: 460,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: WaveNoticeBar(
                  noticeStyle: defaultStyles[index],
                  content: defaultContents[index],
                  onNoticeTap: () {
                    showSnackBar(
                      context,
                      msg: 'click notification',
                    );
                  },
                  onRightIconTap: () {
                    showSnackBar(
                      context,
                      msg: 'Click the icon on the right',
                    );
                  },
                ),
              );
            },
          ),
        )
      ])),
    );
  }
}
