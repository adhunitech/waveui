import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:waveui/waveui.dart';

class WaveAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a [WaveAppBar] widget.
  const WaveAppBar({super.key, this.theme, this.actions = const [], this.title, this.leading, this.scrollController});

  final WaveAppBarTheme? theme;
  final Widget? title;
  final Widget? leading;
  final List<Widget> actions;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final waveTheme = WaveApp.themeOf(context);
    final appBarTheme = theme ?? waveTheme.appBarTheme;

    return AppBar(
      key: key,
      leading: _buildLeading(context),
      backgroundColor: appBarTheme.backgroundColor,
      foregroundColor: appBarTheme.foregroundColor,
      actions: actions,
      title: title,
      toolbarHeight: 65,
      titleTextStyle: TextStyle(color: appBarTheme.foregroundColor, fontWeight: FontWeight.w500, fontSize: 18),
      surfaceTintColor: Colors.transparent,
      centerTitle: appBarTheme.isCenteredTitle,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 0, color: Colors.transparent),
      ),
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) {
      return leading!;
    }
    if (Navigator.canPop(context)) {
      return IconButton(
        tooltip: 'Back',
        icon: const Icon(WaveIcons.chevron_left_24_regular),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
    }
    return null;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<WaveAppBarTheme?>('theme', theme));
  }
}
