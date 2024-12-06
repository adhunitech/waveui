import 'package:waveui/waveui.dart';

class WaveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final dynamic title;
  final Widget? leading;
  final bool showDivider;
  final List<Widget>? actions;
  final bool isCenteredTitle;
  final Color? backgroundColor;

  const WaveAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.showDivider = true,
    this.isCenteredTitle = true,
    this.backgroundColor,
  });
  @override
  Size get preferredSize => const Size.fromHeight(65);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title is String || title is int ? Text('$title') : title,
      actions: actions,
      automaticallyImplyLeading: false,
      centerTitle: isCenteredTitle,
      bottom: showDivider ? _buildBottom() : null,
      scrolledUnderElevation: 0,
      backgroundColor: backgroundColor ?? Get.theme.appBarTheme.backgroundColor,
      leading: leading ?? _backButton(context),
    );
  }

  IconButton _backButton(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.pop(context),
      icon: const Icon(FluentIcons.chevron_left_28_regular),
    );
  }

  PreferredSizeWidget _buildBottom() {
    return const PreferredSize(
      preferredSize: Size.fromHeight(1),
      child: Divider(),
    );
  }
}
