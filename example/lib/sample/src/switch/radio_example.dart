import 'package:example/sample/widgets.dart';
import 'package:waveui/waveui.dart';

class RadioExample extends StatefulWidget {
  const RadioExample({super.key});

  @override
  _RadioExampleState createState() => _RadioExampleState();
}

class _RadioExampleState extends State<RadioExample> {
  /// The selected index of the radio
  int _singleSelectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const WaveAppBar(
        title: 'Single choice example',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'rule',
                style: TextStyle(color: Color(0xFF222222), fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const WaveBubbleText(
                  maxLines: 2,
                  text: 'Have selected, unselected, and disabled states, support setting left and right widgets'),
              const Text(
                'Normal case: single selection, the control is on the right side of the selection button',
                style: TextStyle(
                  color: Color(0xFF222222),
                  fontSize: 28,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  const SizedBox(
                    width: 5,
                  ),
                  const Text("Options:"),
                  WaveRadioButton(
                    radioIndex: 0,
                    isSelected: _singleSelectedIndex == 0,
                    child: const Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        "Option A",
                      ),
                    ),
                    onValueChangedAtIndex: (index, value) {
                      setState(() {
                        _singleSelectedIndex = index;
                        showSnackBar(
                          context,
                          msg: "Single selection, select $index",
                        );
                      });
                    },
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  WaveRadioButton(
                    radioIndex: 1,
                    isSelected: _singleSelectedIndex == 1,
                    child: const Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        "选项B",
                      ),
                    ),
                    onValueChangedAtIndex: (index, value) {
                      setState(() {
                        _singleSelectedIndex = index;
                        showSnackBar(
                          context,
                          msg: "Single selection, select $index",
                        );
                      });
                    },
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  WaveRadioButton(
                    radioIndex: 1,
                    disable: true,
                    isSelected: _singleSelectedIndex == 1,
                    child: const Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        "Option C",
                      ),
                    ),
                    onValueChangedAtIndex: (index, value) {
                      setState(() {
                        _singleSelectedIndex = index;
                        showSnackBar(
                          context,
                          msg: "Single selection, select $index",
                        );
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                'Single selection, unselected, disabled',
                style: TextStyle(
                  color: Color(0xFF222222),
                  fontSize: 28,
                ),
              ),
              WaveRadioButton(
                disable: true,
                radioIndex: 0,
                onValueChangedAtIndex: (index, value) {},
              ),
              const Text(
                'Single selection, selected, disabled',
                style: TextStyle(
                  color: Color(0xFF222222),
                  fontSize: 28,
                ),
              ),
              WaveRadioButton(
                disable: true,
                radioIndex: 0,
                isSelected: true,
                onValueChangedAtIndex: (index, value) {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
