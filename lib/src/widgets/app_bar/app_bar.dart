import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:waveui/waveui.dart';

class WaveAppBar extends StatefulWidget implements PreferredSizeWidget {
  const WaveAppBar({
    super.key,
    this.theme,
    this.actions = const [],
    this.title,
    this.leading,
    this.scrollController,
    this.bottom,
  });

  final WaveAppBarTheme? theme;
  final Widget? title;
  final Widget? leading;
  final List<Widget> actions;
  final ScrollController? scrollController;
  final Widget? bottom;

  @override
  State<WaveAppBar> createState() => _WaveAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<ScrollController?>('scrollController', scrollController))
      ..add(DiagnosticsProperty<WaveAppBarTheme?>('theme', theme));
  }
}

class _WaveAppBarState extends State<WaveAppBar> with WidgetsBindingObserver {
  double _dividerOpacity = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.scrollController?.addListener(_onScrollChanged);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.scrollController?.removeListener(_onScrollChanged);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateDividerOpacity());
  }

  void _onScrollChanged() => _updateDividerOpacity();

  void _updateDividerOpacity() {
    final offset = widget.scrollController?.offset ?? 0;
    final newOpacity = (offset / 20).clamp(0.0, 1.0);

    if (newOpacity != _dividerOpacity) {
      setState(() {
        _dividerOpacity = newOpacity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final waveTheme = WaveApp.themeOf(context);
    final appBarTheme = widget.theme ?? waveTheme.appBarTheme;

    return AppBar(
      key: widget.key,
      leading: _buildLeading(context),
      backgroundColor: appBarTheme.backgroundColor,
      foregroundColor: appBarTheme.foregroundColor,
      actions: widget.actions,
      title: widget.title,
      toolbarHeight: 65,
      centerTitle: appBarTheme.isCenteredTitle,
      titleTextStyle: TextStyle(color: appBarTheme.foregroundColor, fontWeight: FontWeight.w500, fontSize: 18),
      surfaceTintColor: Colors.transparent,
      bottom:
          widget.scrollController == null
              ? null
              : PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: AnimatedOpacity(
                  opacity: _dividerOpacity,
                  duration: const Duration(milliseconds: 200),
                  child: const WaveDivider(),
                ),
              ),
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (widget.leading != null) {
      return widget.leading;
    }

    if (Navigator.canPop(context)) {
      return IconButton(
        tooltip: 'Back',
        icon: const Icon(WaveIcons.arrow_left_24_regular),
        onPressed: () => Navigator.of(context).pop(),
      );
    }

    return null;
  }
}
