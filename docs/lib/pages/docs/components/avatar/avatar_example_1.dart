import 'package:waveui/waveui.dart';

class AvatarExample1 extends StatelessWidget {
  const AvatarExample1({super.key});

  @override
  Widget build(BuildContext context) {
    return Avatar(
      backgroundColor: Colors.red,
      initials: Avatar.getInitials('adhunitech'),
      provider: const NetworkImage('https://avatars.githubusercontent.com/u/189438413?v=4'),
    );
  }
}
