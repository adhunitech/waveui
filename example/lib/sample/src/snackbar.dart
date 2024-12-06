import 'package:waveui/waveui.dart';

class SnackbarExample extends StatelessWidget {
  const SnackbarExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WaveAppBar(title: 'Snackbar Example'),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("This is a content"),
                action: SnackBarAction(
                  label: "Action",
                  onPressed: () => debugPrint("Snackbar action pressed"),
                ),
                showCloseIcon: true,
              ),
            );
          },
          child: const Text("Show SnackBar"),
        ),
      ),
    );
  }
}
