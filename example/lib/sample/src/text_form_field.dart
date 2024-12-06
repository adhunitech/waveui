import 'package:waveui/waveui.dart';

class TextFormFieldExample extends StatefulWidget {
  const TextFormFieldExample({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TextFormFieldExampleState();
  }
}

class _TextFormFieldExampleState extends State<TextFormFieldExample> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WaveAppBar(
        title: 'Text Form Field',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Just use TextFormField(). You don't need to add Wave before TextFormField()."),
              const SizedBox(height: 8),
              _inputText(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputText() {
    return TextFormField(
      minLines: 1,
      maxLength: 100,
      textInputAction: TextInputAction.newline,
      decoration: const InputDecoration(
        hintText: 'Type something here...',
      ),
    );
  }
}
