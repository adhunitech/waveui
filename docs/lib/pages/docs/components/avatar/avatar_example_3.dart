import 'package:waveui/waveui.dart';

class AvatarExample3 extends StatelessWidget {
  const AvatarExample3({super.key});

  @override
  Widget build(BuildContext context) {
    return Avatar(
      initials: Avatar.getInitials('adhunitech'),
      size: 64,
      badge: const AvatarBadge(
        size: 20,
        color: Colors.green,
      ),
    );
  }
}
