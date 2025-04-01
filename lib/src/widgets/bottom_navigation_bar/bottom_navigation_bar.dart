import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:waveui/waveui.dart';

class WaveBottomNavigationBar extends StatelessWidget {
  final List<WaveBottomNavigationBarItem> items;
  final int selectedIndex;
  final Function(int) onSelected;
  final bool showSeparator;

  /// Creates an instance of [WaveBottomNavigationBar].
  const WaveBottomNavigationBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    required this.showSeparator,
  });

  @override
  Widget build(BuildContext context) {
    final waveTheme = WaveTheme.of(context);
    return ColoredBox(
      color: waveTheme.colorScheme.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showSeparator) Divider(color: waveTheme.colorScheme.separator.withValues(alpha: 0.1)),
          SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children:
                      items.map((item) {
                        final isSelected = item.index == selectedIndex;
                        final selectedUnselectedColor =
                            isSelected ? waveTheme.colorScheme.primary : waveTheme.colorScheme.primaryText;
                        return Expanded(
                          child: WaveTappable(
                            onTap: () => onSelected(item.index),
                            scale: 0.85,
                            child: Column(
                              children: [
                                Icon(
                                  isSelected ? item.selectedIcon : item.unselectedIcon,
                                  color: selectedUnselectedColor,
                                  size: 24,
                                ),
                                const SizedBox(height: 2),
                                Text(item.label, style: TextStyle(color: selectedUnselectedColor, fontSize: 14)),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<WaveBottomNavigationBarItem>('items', items))
      ..add(IntProperty('selectedIndex', selectedIndex))
      ..add(ObjectFlagProperty<Function(int p1)>.has('onSelected', onSelected))
      ..add(DiagnosticsProperty<bool>('showSeparator', showSeparator));
  }
}
