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
    this.centeredTitle,
    this.bottom,
    this.backgroundColor,
    this.foregroundColor,
    this.toolbarHeight = 66,
    this.dividerColor,
    this.automaticBackButton = true,
    this.alwaysShowDivider = false,
  });

  final WaveAppBarTheme? theme;
  final Widget? title;
  final Widget? leading;
  final List<Widget> actions;
  final ScrollController? scrollController;
  final PreferredSizeWidget? bottom;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double toolbarHeight;
  final Color? dividerColor;
  final bool? centeredTitle;
  final bool automaticBackButton;
  final bool alwaysShowDivider;

  @override
  State<WaveAppBar> createState() => _WaveAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<ScrollController?>('scrollController', scrollController))
      ..add(DiagnosticsProperty<WaveAppBarTheme?>('theme', theme))
      ..add(ColorProperty('foregroundColor', foregroundColor))
      ..add(ColorProperty('backgroundColor', backgroundColor))
      ..add(DoubleProperty('toolbarHeight', toolbarHeight))
      ..add(ColorProperty('dividerColor', dividerColor))
      ..add(DiagnosticsProperty<bool?>('automaticBackButton', automaticBackButton))
      ..add(DiagnosticsProperty<bool?>('centeredTitle', centeredTitle))
      ..add(DiagnosticsProperty<bool>('alwaysShowDivider', alwaysShowDivider));
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
      backgroundColor: widget.backgroundColor ?? appBarTheme.backgroundColor,
      foregroundColor: widget.foregroundColor ?? appBarTheme.foregroundColor,
      actions: widget.actions,
      automaticallyImplyLeading: widget.automaticBackButton,
      title: widget.title,
      toolbarHeight: widget.toolbarHeight,
      centerTitle: widget.centeredTitle ?? appBarTheme.isCenteredTitle,
      titleTextStyle: TextStyle(color: appBarTheme.foregroundColor, fontWeight: FontWeight.w500, fontSize: 18),
      surfaceTintColor: Colors.transparent,
      bottom:
          widget.scrollController == null
              ? widget.bottom
              : widget.alwaysShowDivider
              ? PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: WaveDivider(color: widget.dividerColor ?? waveTheme.colorScheme.outlineDivider),
              )
              : PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: AnimatedOpacity(
                  opacity: _dividerOpacity,
                  duration: const Duration(milliseconds: 200),
                  child: WaveDivider(color: widget.dividerColor ?? waveTheme.colorScheme.outlineDivider),
                ),
              ),
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (widget.leading != null) {
      return widget.leading;
    }
    if (!widget.automaticBackButton) {
      return null;
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
