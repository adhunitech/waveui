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
    final theme = WaveApp.themeOf(context);
    return SafeArea(
      child: ColoredBox(
        color: backgroundColor ?? theme.colorScheme.contentPrimary,
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              alignment: Alignment(-1 + (2 / (items.length - 1)) * selectedIndex, 1),
              child: FractionallySizedBox(
                widthFactor: 1 / items.length,
                child: Container(height: 2, color: theme.colorScheme.primary),
              ),
            ),
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
    final theme = WaveApp.themeOf(context);
    return WaveTappable(
      onTap: () => onSelected(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.icon,
              color: selectedIndex == index ? theme.colorScheme.primary : theme.colorScheme.labelSecondary,
            ),
            const SizedBox(height: 2),
            Text(
              item.label,
              maxLines: 1,
              style: theme.textTheme.small.copyWith(
                color: selectedIndex == index ? theme.colorScheme.primary : theme.colorScheme.labelSecondary,
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
      ..add(ColorProperty('foregroundColor', foregroundColor));
  }
}
