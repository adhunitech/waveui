import 'package:waveui/waveui.dart';
import 'package:example/sample/home/root_page.dart';

void main() {
  runApp(const WaveApp());
}

class WaveApp extends StatelessWidget {
  const WaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wave UI',
      theme: WaveTheme(themeColor: Colors.blue, darkMode: false),
      home: const RootPage(),
    );
  }
}
