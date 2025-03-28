import 'package:flutter/material.dart';
import 'package:waveui/waveui.dart';

/// Implements the basic visual layout structure.
///
/// This class provides APIs for showing drawers and bottom sheets.
class WaveScaffold extends Scaffold {
  final BuildContext context;

  /// Creates a visual scaffold for widgets.
  const WaveScaffold({
    required this.context,
    super.key,
    super.appBar,
    super.body,
    super.floatingActionButton,
    super.floatingActionButtonLocation,
    super.floatingActionButtonAnimator,
    super.persistentFooterButtons,
    super.persistentFooterAlignment,
    super.drawer,
    super.onDrawerChanged,
    super.endDrawer,
    super.onEndDrawerChanged,
    super.bottomNavigationBar,
    super.bottomSheet,
    super.backgroundColor,
    super.resizeToAvoidBottomInset,
    super.primary,
    super.drawerDragStartBehavior,
    super.extendBody,
    super.extendBodyBehindAppBar,
    super.drawerScrimColor,
    super.drawerEdgeDragWidth,
    super.drawerEnableOpenDragGesture,
    super.endDrawerEnableOpenDragGesture,
    super.restorationId,
  });

  @override
  Color? get backgroundColor => WaveTheme.of(context).colorScheme.background;
}
