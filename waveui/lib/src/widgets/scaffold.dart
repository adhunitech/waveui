import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:waveui/waveui.dart';

class WaveScaffold extends StatelessWidget {
  const WaveScaffold({
    this.appBar,
    this.body,
    this.globalKey,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    this.persistentFooterAlignment = AlignmentDirectional.centerEnd,
    this.drawer,
    this.onDrawerChanged,
    this.endDrawer,
    this.onEndDrawerChanged,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.primary = true,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.drawerScrimColor,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
    this.restorationId,
    this.isLoading = false,
    this.loadingText,
  });

  final bool extendBody;
  final Key? globalKey;
  final bool extendBodyBehindAppBar;

  final PreferredSizeWidget? appBar;

  final Widget? body;

  final Widget? floatingActionButton;

  final FloatingActionButtonLocation? floatingActionButtonLocation;

  final FloatingActionButtonAnimator? floatingActionButtonAnimator;

  final List<Widget>? persistentFooterButtons;

  final AlignmentDirectional persistentFooterAlignment;

  final Widget? drawer;

  final DrawerCallback? onDrawerChanged;

  final Widget? endDrawer;

  final DrawerCallback? onEndDrawerChanged;

  final Color? drawerScrimColor;

  final Color? backgroundColor;

  final Widget? bottomNavigationBar;

  final Widget? bottomSheet;

  final bool? resizeToAvoidBottomInset;

  final bool primary;

  final DragStartBehavior drawerDragStartBehavior;

  final double? drawerEdgeDragWidth;

  final bool drawerEnableOpenDragGesture;

  final bool endDrawerEnableOpenDragGesture;

  final String? restorationId;

  final bool isLoading;
  final String? loadingText;

  @override
  Widget build(BuildContext context) {
    final colorScheme = WaveTheme.of(context).colorScheme;
    final textTheme = WaveTheme.of(context).textTheme;
    return PopScope(
      canPop: !isLoading,
      child: Stack(
        children: [
          Scaffold(
            key: globalKey,
            extendBody: extendBody,
            extendBodyBehindAppBar: extendBodyBehindAppBar,
            appBar: appBar,
            body: body,
            floatingActionButton: floatingActionButton,
            floatingActionButtonLocation: floatingActionButtonLocation,
            floatingActionButtonAnimator: floatingActionButtonAnimator,
            persistentFooterButtons: persistentFooterButtons,
            persistentFooterAlignment: persistentFooterAlignment,
            drawer: drawer,
            onDrawerChanged: onDrawerChanged,
            endDrawer: endDrawer,
            onEndDrawerChanged: onEndDrawerChanged,
            drawerScrimColor: drawerScrimColor ?? colorScheme.scrim,
            backgroundColor: backgroundColor ?? colorScheme.canvas,
            bottomNavigationBar: bottomNavigationBar,
            bottomSheet: bottomSheet,
            resizeToAvoidBottomInset: resizeToAvoidBottomInset,
            primary: primary,
            drawerDragStartBehavior: drawerDragStartBehavior,
            drawerEdgeDragWidth: drawerEdgeDragWidth,
            drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
            endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture,
            restorationId: restorationId,
          ),
          if (isLoading)
            IgnorePointer(
              child: ColoredBox(
                color: colorScheme.scrim.withValues(alpha: 0.2),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: SizedBox.expand(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: colorScheme.surfacePrimary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const WaveCircularProgressIndicator(),
                            if (loadingText != null) ...[
                              const SizedBox(height: 12),
                              Text(loadingText!, style: textTheme.small),
                            ],
                          ],
                        ),
                      ),
                    ),
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
      ..add(
        DiagnosticsProperty<FloatingActionButtonLocation?>(
          'floatingActionButtonLocation',
          floatingActionButtonLocation,
        ),
      )
      ..add(
        DiagnosticsProperty<FloatingActionButtonAnimator?>(
          'floatingActionButtonAnimator',
          floatingActionButtonAnimator,
        ),
      )
      ..add(DiagnosticsProperty<bool>('extendBodyBehindAppBar', extendBodyBehindAppBar))
      ..add(DiagnosticsProperty<bool>('extendBody', extendBody))
      ..add(DiagnosticsProperty<AlignmentDirectional>('persistentFooterAlignment', persistentFooterAlignment))
      ..add(ObjectFlagProperty<DrawerCallback?>.has('onDrawerChanged', onDrawerChanged))
      ..add(ObjectFlagProperty<DrawerCallback?>.has('onEndDrawerChanged', onEndDrawerChanged))
      ..add(ColorProperty('drawerScrimColor', drawerScrimColor))
      ..add(ColorProperty('backgroundColor', backgroundColor))
      ..add(DiagnosticsProperty<bool?>('resizeToAvoidBottomInset', resizeToAvoidBottomInset))
      ..add(DiagnosticsProperty<bool>('primary', primary))
      ..add(EnumProperty<DragStartBehavior>('drawerDragStartBehavior', drawerDragStartBehavior))
      ..add(DoubleProperty('drawerEdgeDragWidth', drawerEdgeDragWidth))
      ..add(DiagnosticsProperty<bool>('drawerEnableOpenDragGesture', drawerEnableOpenDragGesture))
      ..add(DiagnosticsProperty<bool>('endDrawerEnableOpenDragGesture', endDrawerEnableOpenDragGesture))
      ..add(StringProperty('restorationId', restorationId))
      ..add(DiagnosticsProperty<bool>('isLoading', isLoading));
    properties.add(StringProperty('loadingText', loadingText));
    properties.add(DiagnosticsProperty<Key>('globalKey', globalKey));
  }
}
