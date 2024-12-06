import 'package:example/sample/widgets.dart';
import 'package:waveui/waveui.dart';

/// 评价组件example

class AppraiseExample extends StatefulWidget {
  const AppraiseExample({super.key});

  @override
  _AppraiseExampleState createState() => _AppraiseExampleState();
}

class _AppraiseExampleState extends State<AppraiseExample> {
  List<String> tags = [
    'I',
    'I am optional',
    'I am an optional label',
    'My copywriting is very long and occupies a single line',
    'I am optional label 1',
    'I am optional label 1',
    'I am optional label 1',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WaveAppBar(
        title: 'Evaluation component',
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Text('Rule', style: Get.textTheme.headlineMedium),
          const SizedBox(height: 8),
          const WaveCard(
            backgroundColor: Color(0x260984F9),
            padding: EdgeInsets.all(12),
            child: Text(
              'Support the use of pages and pop-up windows, use WaveAppraise in the page, use WaveAppraiseBottomPicker in the pop-up window, the picker encapsulates the widget, and the parameters of the two are exactly the same',
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Displayed inside the page',
            style: Get.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Description: When displayed on the page, the submit button needs to be hidden. If it is called back, call the inputChangeCallback, iconClickCallback and tagSelectCallback in the config',
            style: Get.textTheme.bodySmall,
          ),
          const SizedBox(height: 24),
          WaveAppraise(
            title: "Here is the title text",
            headerType: WaveAppraiseHeaderType.center,
            type: WaveAppraiseType.star,
            tags: tags,
            inputHintText: 'Here is the text input component',
            config: WaveAppraiseConfig(
                showConfirmButton: false,
                starAppraiseHint: 'The copywriting when the star is not selected',
                inputDefaultText: 'This is a default text',
                iconClickCallback: (index) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('The selected evaluation is $index')),
                  );
                },
                tagSelectCallback: (list) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('The selected label is:$list')),
                  );
                }),
          ),
          const SizedBox(
            height: 50,
          ),
          const Text(
            'Show pop-up window',
            style: TextStyle(
              color: Color(0xFF222222),
              fontSize: 28,
            ),
          ),
          const Text(
            '--Description: default style',
            style: TextStyle(
              color: Color(0xFF999999),
              fontSize: 14,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          FilledButton(
            child: const Text('Click to display the default style popup'),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return WaveAppraiseBottomPicker(
                      title: "Here is the title text",
                      tags: tags,
                      inputHintText: 'Here is the text input component',
                      onConfirm: (index, list, input) {
                        showToast(index, list, input, context);
                        Navigator.pop(context);
                      },
                      config: WaveAppraiseConfig(
                          showConfirmButton: true,
                          count: 5,
                          starAppraiseHint: 'The copywriting when the star is not selected',
                          iconClickCallback: (index) {
                            showSnackBar(
                              context,
                              msg: 'The selected evaluation is $index',
                            );
                          },
                          tagSelectCallback: (list) {
                            showSnackBar(
                              context,
                              msg: 'The selected label is:$list',
                            );
                          }),
                    );
                  });
            },
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            '--Description: Display 3 emoticon pop-up windows, tags pass empty to hide tags',
            style: TextStyle(
              color: Color(0xFF999999),
              fontSize: 14,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          FilledButton(
            child: const Text('Click to display the evaluation pop-up window'),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return WaveAppraiseBottomPicker(
                      title:
                          "Title text here is title text here is title text here is title text here is title text here is title text here is title text here is title text here",
                      inputHintText: 'Here is the text input component',
                      onConfirm: (index, list, input) {
                        showToast(index, list, input, context);
                        Navigator.pop(context);
                      },

                      ///Must pass in 5 strings, if there is no position pass ''
                      type: WaveAppraiseType.emoji,
                      iconDescriptions: const ['poor', '', 'ok', '', 'very good'],
                      config: const WaveAppraiseConfig(indexes: [0, 2, 4], titleMaxLines: 3),
                    );
                  });
            },
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            '--Description: Display 4 stars, hide the input box',
            style: TextStyle(
              color: Color(0xFF999999),
              fontSize: 14,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          FilledButton(
            child: const Text('Click to display the evaluation pop-up window'),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return WaveAppraiseBottomPicker(
                      title: "Here is the title text",
                      tags: tags,
                      onConfirm: (index, list, input) {
                        showToast(index, list, input, context);
                        Navigator.pop(context);
                      },
                      type: WaveAppraiseType.star,
                      iconDescriptions: const ['poor', 'no', 'ok', 'good'],
                      config: const WaveAppraiseConfig(showTextInput: false, count: 4, starAppraiseHint: 'Please rate'),
                    );
                  });
            },
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  void showToast(int index, List<String> selectedTags, String input, BuildContext context) {
    String str = 'The selected evaluation is $index';
    if (selectedTags.isNotEmpty) {
      str = '$str, the selected tag is:$selectedTags';
    }
    if (input.isNotEmpty) {
      str = '$str, the input content is:$input';
    }
    showSnackBar(
      context,
      msg: str,
    );
  }
}
