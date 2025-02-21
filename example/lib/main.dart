import 'package:waveui/waveui.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: ThemeData.from(colorScheme: const ColorScheme.light()),
    home: const Scaffold(body: Center(child: Text('Hello World!'))),
  );
}
