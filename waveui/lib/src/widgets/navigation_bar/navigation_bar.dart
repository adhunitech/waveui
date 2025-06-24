import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:waveui/waveui.dart';

class WaveNavigationBar extends StatelessWidget {
  final List<WaveNavigationBarItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final Color? backgroundColor;
  final Color? foregroundColor;
  const WaveNavigationBar({
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    super.key,
    this.backgroundColor,
    this.foregroundColor,
  });
  @override
  Widget build(BuildContext context) {
    final theme = WaveTheme.of(context);
    return ColoredBox(
      color: backgroundColor ?? theme.colorScheme.surfacePrimary,
      child: SafeArea(
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            // Navigation items
            Row(
              children: List.generate(
                items.length,
                (index) => Expanded(child: _buildItem(context, items[index], index)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, WaveNavigationBarItem item, int index) {
    final theme = WaveTheme.of(context);
    return WaveTappable(
      onTap: () => onSelected(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.icon,
              color: selectedIndex == index ? theme.colorScheme.brandPrimary : theme.colorScheme.textSecondary,
            ),
            const SizedBox(height: 2),
            Text(
              item.label,
              maxLines: 1,
              style: theme.textTheme.small.copyWith(
                color: selectedIndex == index ? theme.colorScheme.brandPrimary : theme.colorScheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('backgroundColor', backgroundColor))
      ..add(IntProperty('selectedIndex', selectedIndex))
      ..add(ObjectFlagProperty<ValueChanged<int>>.has('onTap', onSelected))
      ..add(ColorProperty('foregroundColor', foregroundColor))
      ..add(IterableProperty<WaveNavigationBarItem>('items', items));
  }
}
