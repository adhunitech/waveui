import 'package:waveui/waveui.dart';

class LayoutPageExample9 extends StatelessWidget {
  const LayoutPageExample9({super.key});

  @override
  Widget build(BuildContext context) {
    return const Basic(
      title: Text('Title'),
      leading: Icon(Icons.star),
      trailing: Icon(Icons.arrow_forward),
      subtitle: Text('Subtitle'),
      content: Text('Lorem ipsum dolor sit amet'),
    );
  }
}
