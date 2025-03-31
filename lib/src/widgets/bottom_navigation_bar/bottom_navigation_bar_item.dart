import 'package:flutter/widgets.dart';

class WaveBottomNavigationBarItem {
  final int index;
  final String label;
  final IconData unselectedIcon;
  final IconData selectedIcon;

  /// Creates an instance of [WaveBottomNavigationBarItem].
  const WaveBottomNavigationBarItem({
    required this.selectedIcon,
    required this.label,
    required this.unselectedIcon,
    required this.index,
  });
}
