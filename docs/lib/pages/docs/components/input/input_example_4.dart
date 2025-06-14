import 'package:waveui/waveui.dart';

class InputExample4 extends StatelessWidget {
  const InputExample4({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: FormField(
        key: const InputKey(#test),
        label: const Text('Username'),
        validator: ConditionalValidator((value) async {
          // simulate a network delay for example purpose
          await Future.delayed(const Duration(seconds: 1));
          return !['adhunitech', 'septogeddon', 'admin'].contains(value);
        }, message: 'Username already taken'),
        child: const TextField(
          placeholder: Text('Enter your username'),
          initialValue: 'adhunitech',
          features: [
            InputFeature.revalidate(),
          ],
        ),
      ),
    );
  }
}
