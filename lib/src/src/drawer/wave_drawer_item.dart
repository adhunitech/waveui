import 'package:waveui/waveui.dart';

class WaveDrawerItem extends StatelessWidget {
  const WaveDrawerItem({
    super.key,
    this.index = 0,
    this.selectedIndex = 0,
    this.title,
    this.onTap,
    required this.active,
    required this.inActive,
  });

  final int index;
  final int selectedIndex;
  final String? title;
  final IconData active;
  final IconData inActive;
  final Function(int)? onTap;

  @override
  Widget build(BuildContext context) {
    var isSelected = index == selectedIndex;
    return Column(
      children: [
        ListTile(
          onTap: onTap == null ? null : () => onTap!(index),
          selected: isSelected,
          title: title == null ? null : Text('$title'),
          leading: Icon(isSelected ? active : inActive),
        ),
        const Divider(),
      ],
    );
  }
}
