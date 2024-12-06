import 'package:example/sample/widgets.dart';
import 'package:waveui/waveui.dart';

/// Description: Notification example with button

class WaveNoticeBarWithButtonExample extends StatelessWidget {
  const WaveNoticeBarWithButtonExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WaveAppBar(
        title: 'Notification Style 01',
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
              'Height 56, label on the left, notification content in the middle, and button on the right. The notification content must be passed. If the label and button copy are empty, they will not be displayed. All colors support customization',
        ),
        const Text(
          'Default style',
          style: TextStyle(
            color: Color(0xFF222222),
            fontSize: 28,
          ),
        ),
        const WaveNoticeBarWithButton(
          content: 'This is the notification content',
        ),
        const Text(
          'normal style',
          style: TextStyle(
            color: Color(0xFF222222),
            fontSize: 28,
          ),
        ),
        WaveNoticeBarWithButton(
          leftTagText: 'task',
          content: 'This is the notification content',
          rightButtonText: 'Go to finish',
          onRightButtonTap: () {
            showSnackBar(context, msg: 'Click the right button');
          },
        ),
        const Text(
          'Marquee',
          style: TextStyle(
            color: Color(0xFF222222),
            fontSize: 28,
          ),
        ),
        WaveNoticeBarWithButton(
          leftTagText: 'task',
          content:
              'This is the notification content of the marquee The notification content of the marquee The notification content of the marquee The notification content of the marquee',
          rightButtonText: 'Go to finish',
          marquee: true,
          onRightButtonTap: () {
            showSnackBar(context, msg: 'Click the right button');
          },
        ),
        const Text(
          'Hide left label',
          style: TextStyle(
            color: Color(0xFF222222),
            fontSize: 28,
          ),
        ),
        WaveNoticeBarWithButton(
          content: 'This is the notification content',
          rightButtonText: 'Go to finish',
          onRightButtonTap: () {
            showSnackBar(context, msg: 'Click the right button');
          },
        ),
        const Text(
          'Hide right button',
          style: TextStyle(
            color: Color(0xFF222222),
            fontSize: 28,
          ),
        ),
        const WaveNoticeBarWithButton(
          leftTagText: 'task',
          content: 'This is the notification content',
        ),
        const Text(
          "Notify the copywriter, don't rewind",
          style: TextStyle(
            color: Color(0xFF222222),
            fontSize: 28,
          ),
        ),
        WaveNoticeBarWithButton(
          leftTagText: 'task',
          content:
              'This is the notification content This is the notification content This is the notification content This is the notification content This is the notification content',
          rightButtonText: 'Go to finish',
          onRightButtonTap: () {
            showSnackBar(context, msg: 'Click the right button');
          },
        ),
        const Text(
          'Custom text and background color',
          style: TextStyle(
            color: Color(0xFF222222),
            fontSize: 28,
          ),
        ),
        WaveNoticeBarWithButton(
          leftTagText: 'task',
          leftTagBackgroundColor: const Color(0xFFE0EDFF),
          leftTagTextColor: const Color(0xFF0984F9),
          content:
              'This is the notification content This is the notification content This is the notification content This is the notification content This is the notification content',
          backgroundColor: const Color(0xFFEBFFF7),
          contentTextColor: const Color(0xFF00AE66),
          rightButtonText: 'Go to finish',
          rightButtonBorderColor: const Color(0xFF0984F9),
          rightButtonTextColor: const Color(0xFF0984F9),
          onRightButtonTap: () {
            showSnackBar(context, msg: 'Click the right button');
          },
        ),
        const SizedBox(
          height: 50,
        ),
      ])),
    );
  }
}
