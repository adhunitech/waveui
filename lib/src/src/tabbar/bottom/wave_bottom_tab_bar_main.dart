import 'package:waveui/waveui.dart';

class WaveBottomNavigationBar extends StatelessWidget {
  const WaveBottomNavigationBar({
    super.key,
    required this.items,
    this.showDivider = true,
    this.backgroundColor,
    this.currentIndex = 0,
    this.showUnselectedLabels = false,
    this.showSelectedLabels = false,
    this.onTap,
  });

  final List<BottomNavigationBarItem> items;
  final bool showDivider, showUnselectedLabels, showSelectedLabels;
  final Color? backgroundColor;
  final int currentIndex;
  final Function(int)? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showDivider) const Divider(),
        BottomNavigationBar(
          useLegacyColorScheme: false,
          showSelectedLabels: showSelectedLabels,
          showUnselectedLabels: showUnselectedLabels,
          currentIndex: currentIndex,
          onTap: onTap,
          items: items,
          backgroundColor:
              backgroundColor ?? Get.theme.appBarTheme.backgroundColor,
        ),
      ],
    );
  }
}
