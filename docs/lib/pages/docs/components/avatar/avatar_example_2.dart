import 'package:waveui/waveui.dart';

class AvatarExample2 extends StatelessWidget {
  const AvatarExample2({super.key});

  @override
  Widget build(BuildContext context) {
    return Avatar(
      initials: Avatar.getInitials('adhunitech'),
      size: 64,
    );
  }
}
