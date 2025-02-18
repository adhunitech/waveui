// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;

import 'package:flutter/widgets.dart';
import 'package:waveui/material/theme.dart' show ThemeData;
import 'package:waveui/material/theme_data.dart' show ThemeData;

import 'package:waveui/material/colors.dart';
import 'package:waveui/material/debug.dart';
import 'package:waveui/material/drawer_theme.dart';
import 'package:waveui/material/list_tile.dart';
import 'package:waveui/material/list_tile_theme.dart';
import 'package:waveui/material/material.dart';
import 'package:waveui/material/material_localizations.dart';
import 'package:waveui/material/theme.dart';
import 'package:waveui/waveui.dart' show ThemeData;

// Examples can assume:
// late BuildContext context;

enum DrawerAlignment { start, end }

// TODO(eseidel): Draw width should vary based on device size:
// https://material.io/design/components/navigation-drawer.html#specs

// Mobile:
// Width = Screen width − 56 dp
// Maximum width: 320dp
// Maximum width applies only when using a left nav. When using a right nav,
// the panel can cover the full width of the screen.

// Desktop/Tablet:
// Maximum width for a left nav is 400dp.
// The right nav can vary depending on content.

const double _kWidth = 304.0;
const double _kEdgeDragWidth = 20.0;
const double _kMinFlingVelocity = 365.0;
const Duration _kBaseSettleDuration = Duration(milliseconds: 246);

class Drawer extends StatelessWidget {
  const Drawer({
    super.key,
    this.backgroundColor,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.shape,
    this.width,
    this.child,
    this.semanticLabel,
    this.clipBehavior,
  }) : assert(elevation == null || elevation >= 0.0);

  final Color? backgroundColor;

  final double? elevation;

  final Color? shadowColor;

  final Color? surfaceTintColor;

  final ShapeBorder? shape;

  final double? width;

  final Widget? child;

  final String? semanticLabel;

  final Clip? clipBehavior;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final DrawerThemeData drawerTheme = DrawerTheme.of(context);
    String? label = semanticLabel;
    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        break;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        label = semanticLabel ?? MaterialLocalizations.of(context).drawerLabel;
    }
    final bool isDrawerStart = DrawerController.maybeOf(context)?.alignment != DrawerAlignment.end;
    final DrawerThemeData defaults = _DrawerDefaultsM3(context);
    final ShapeBorder? effectiveShape =
        shape ?? (isDrawerStart ? (drawerTheme.shape ?? defaults.shape) : (drawerTheme.endShape ?? defaults.endShape));
    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: label,
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(width: width ?? drawerTheme.width ?? _kWidth),
        child: Material(
          color: backgroundColor ?? drawerTheme.backgroundColor ?? defaults.backgroundColor,
          elevation: elevation ?? drawerTheme.elevation ?? defaults.elevation!,
          shadowColor: shadowColor ?? drawerTheme.shadowColor ?? defaults.shadowColor,
          surfaceTintColor: surfaceTintColor ?? drawerTheme.surfaceTintColor ?? defaults.surfaceTintColor,
          shape: effectiveShape,
          clipBehavior:
              effectiveShape != null ? (clipBehavior ?? drawerTheme.clipBehavior ?? defaults.clipBehavior!) : Clip.none,
          child: child,
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(DoubleProperty('elevation', elevation));
    properties.add(ColorProperty('shadowColor', shadowColor));
    properties.add(ColorProperty('surfaceTintColor', surfaceTintColor));
    properties.add(DiagnosticsProperty<ShapeBorder?>('shape', shape));
    properties.add(DoubleProperty('width', width));
    properties.add(StringProperty('semanticLabel', semanticLabel));
    properties.add(EnumProperty<Clip?>('clipBehavior', clipBehavior));
  }
}

typedef DrawerCallback = void Function(bool isOpened);

class _DrawerControllerScope extends InheritedWidget {
  const _DrawerControllerScope({required this.controller, required super.child});

  final DrawerController controller;

  @override
  bool updateShouldNotify(_DrawerControllerScope old) => controller != old.controller;
}

class DrawerController extends StatefulWidget {
  const DrawerController({
    required this.child,
    required this.alignment,
    GlobalKey? key,
    this.isDrawerOpen = false,
    this.drawerCallback,
    this.dragStartBehavior = DragStartBehavior.start,
    this.scrimColor,
    this.edgeDragWidth,
    this.enableOpenDragGesture = true,
  }) : super(key: key);

  final Widget child;

  final DrawerAlignment alignment;

  final DrawerCallback? drawerCallback;

  final DragStartBehavior dragStartBehavior;

  final Color? scrimColor;

  final bool enableOpenDragGesture;

  final double? edgeDragWidth;

  final bool isDrawerOpen;

  static DrawerController? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_DrawerControllerScope>()?.controller;

  static DrawerController of(BuildContext context) {
    final DrawerController? controller = maybeOf(context);
    assert(() {
      if (controller == null) {
        throw FlutterError(
          'DrawerController.of() was called with a context that does not '
          'contain a DrawerController widget.\n'
          'No DrawerController widget ancestor could be found starting from '
          'the context that was passed to DrawerController.of(). This can '
          'happen because you are using a widget that looks for a DrawerController '
          'ancestor, but no such ancestor exists.\n'
          'The context used was:\n'
          '  $context',
        );
      }
      return true;
    }());
    return controller!;
  }

  @override
  DrawerControllerState createState() => DrawerControllerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<DrawerAlignment>('alignment', alignment));
    properties.add(ObjectFlagProperty<DrawerCallback?>.has('drawerCallback', drawerCallback));
    properties.add(EnumProperty<DragStartBehavior>('dragStartBehavior', dragStartBehavior));
    properties.add(ColorProperty('scrimColor', scrimColor));
    properties.add(DiagnosticsProperty<bool>('enableOpenDragGesture', enableOpenDragGesture));
    properties.add(DoubleProperty('edgeDragWidth', edgeDragWidth));
    properties.add(DiagnosticsProperty<bool>('isDrawerOpen', isDrawerOpen));
  }
}

class DrawerControllerState extends State<DrawerController> with SingleTickerProviderStateMixin {
  @protected
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      value: widget.isDrawerOpen ? 1.0 : 0.0,
      duration: _kBaseSettleDuration,
      vsync: this,
    );
    _controller
      ..addListener(_animationChanged)
      ..addStatusListener(_animationStatusChanged);
  }

  @protected
  @override
  void dispose() {
    _historyEntry?.remove();
    _controller.dispose();
    _focusScopeNode.dispose();
    super.dispose();
  }

  @protected
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrimColorTween = _buildScrimColorTween();
  }

  @protected
  @override
  void didUpdateWidget(DrawerController oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.scrimColor != oldWidget.scrimColor) {
      _scrimColorTween = _buildScrimColorTween();
    }

    if (_controller.status.isAnimating) {
      return; // Don't snap the drawer open or shut while the user is dragging.
    }
    if (widget.isDrawerOpen != oldWidget.isDrawerOpen) {
      _controller.value = widget.isDrawerOpen ? 1.0 : 0.0;
    }
  }

  void _animationChanged() {
    setState(() {
      // The animation controller's state is our build state, and it changed already.
    });
  }

  LocalHistoryEntry? _historyEntry;
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  void _ensureHistoryEntry() {
    if (_historyEntry == null) {
      final ModalRoute<dynamic>? route = ModalRoute.of(context);
      if (route != null) {
        _historyEntry = LocalHistoryEntry(onRemove: _handleHistoryEntryRemoved, impliesAppBarDismissal: false);
        route.addLocalHistoryEntry(_historyEntry!);
        FocusScope.of(context).setFirstFocus(_focusScopeNode);
      }
    }
  }

  void _animationStatusChanged(AnimationStatus status) {
    switch (status) {
      case AnimationStatus.forward:
        _ensureHistoryEntry();
      case AnimationStatus.reverse:
        _historyEntry?.remove();
        _historyEntry = null;
      case AnimationStatus.dismissed:
      case AnimationStatus.completed:
        break;
    }
  }

  void _handleHistoryEntryRemoved() {
    _historyEntry = null;
    close();
  }

  late AnimationController _controller;

  void _handleDragDown(DragDownDetails details) {
    _controller.stop();
    _ensureHistoryEntry();
  }

  void _handleDragCancel() {
    if (_controller.isDismissed || _controller.isAnimating) {
      return;
    }
    if (_controller.value < 0.5) {
      close();
    } else {
      open();
    }
  }

  final GlobalKey _drawerKey = GlobalKey();

  double get _width {
    final RenderBox? box = _drawerKey.currentContext?.findRenderObject() as RenderBox?;
    // return _kWidth if drawer not being shown currently
    return box?.size.width ?? _kWidth;
  }

  bool _previouslyOpened = false;

  int get _directionFactor => switch ((Directionality.of(context), widget.alignment)) {
    (TextDirection.rtl, DrawerAlignment.start) => -1,
    (TextDirection.rtl, DrawerAlignment.end) => 1,
    (TextDirection.ltr, DrawerAlignment.start) => 1,
    (TextDirection.ltr, DrawerAlignment.end) => -1,
  };

  void _move(DragUpdateDetails details) {
    _controller.value += details.primaryDelta! / _width * _directionFactor;

    final bool opened = _controller.value > 0.5;
    if (opened != _previouslyOpened && widget.drawerCallback != null) {
      widget.drawerCallback!(opened);
    }
    _previouslyOpened = opened;
  }

  void _settle(DragEndDetails details) {
    if (_controller.isDismissed) {
      return;
    }
    final double xVelocity = details.velocity.pixelsPerSecond.dx;
    if (xVelocity.abs() >= _kMinFlingVelocity) {
      final double visualVelocity = xVelocity / _width * _directionFactor;

      _controller.fling(velocity: visualVelocity);
      widget.drawerCallback?.call(visualVelocity > 0.0);
    } else if (_controller.value < 0.5) {
      close();
    } else {
      open();
    }
  }

  void open() {
    _controller.fling();
    widget.drawerCallback?.call(true);
  }

  void close() {
    _controller.fling(velocity: -1.0);
    widget.drawerCallback?.call(false);
  }

  late ColorTween _scrimColorTween;
  final GlobalKey _gestureDetectorKey = GlobalKey();

  ColorTween _buildScrimColorTween() => ColorTween(
    begin: Colors.transparent,
    end: widget.scrimColor ?? DrawerTheme.of(context).scrimColor ?? Colors.black54,
  );

  AlignmentDirectional get _drawerOuterAlignment => switch (widget.alignment) {
    DrawerAlignment.start => AlignmentDirectional.centerStart,
    DrawerAlignment.end => AlignmentDirectional.centerEnd,
  };

  AlignmentDirectional get _drawerInnerAlignment => switch (widget.alignment) {
    DrawerAlignment.start => AlignmentDirectional.centerEnd,
    DrawerAlignment.end => AlignmentDirectional.centerStart,
  };

  Widget _buildDrawer(BuildContext context) {
    final bool isDesktop = switch (Theme.of(context).platform) {
      TargetPlatform.android || TargetPlatform.iOS || TargetPlatform.fuchsia => false,
      TargetPlatform.macOS || TargetPlatform.linux || TargetPlatform.windows => true,
    };

    final double dragAreaWidth =
        widget.edgeDragWidth ??
        _kEdgeDragWidth +
            switch ((widget.alignment, Directionality.of(context))) {
              (DrawerAlignment.start, TextDirection.ltr) => MediaQuery.paddingOf(context).left,
              (DrawerAlignment.start, TextDirection.rtl) => MediaQuery.paddingOf(context).right,
              (DrawerAlignment.end, TextDirection.rtl) => MediaQuery.paddingOf(context).left,
              (DrawerAlignment.end, TextDirection.ltr) => MediaQuery.paddingOf(context).right,
            };

    if (_controller.isDismissed) {
      if (widget.enableOpenDragGesture && !isDesktop) {
        return Align(
          alignment: _drawerOuterAlignment,
          child: GestureDetector(
            key: _gestureDetectorKey,
            onHorizontalDragUpdate: _move,
            onHorizontalDragEnd: _settle,
            behavior: HitTestBehavior.translucent,
            excludeFromSemantics: true,
            dragStartBehavior: widget.dragStartBehavior,
            child: LimitedBox(maxHeight: 0.0, child: SizedBox(width: dragAreaWidth, height: double.infinity)),
          ),
        );
      } else {
        return const SizedBox.shrink();
      }
    } else {
      final bool platformHasBackButton;
      switch (Theme.of(context).platform) {
        case TargetPlatform.android:
          platformHasBackButton = true;
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
        case TargetPlatform.fuchsia:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
          platformHasBackButton = false;
      }

      Widget drawerScrim = const LimitedBox(maxWidth: 0.0, maxHeight: 0.0, child: SizedBox.expand());
      if (_scrimColorTween.evaluate(_controller) case final Color color) {
        drawerScrim = ColoredBox(color: color, child: drawerScrim);
      }

      final Widget child = _DrawerControllerScope(
        controller: widget,
        child: RepaintBoundary(
          child: Stack(
            children: <Widget>[
              BlockSemantics(
                child: ExcludeSemantics(
                  // On Android, the back button is used to dismiss a modal.
                  excluding: platformHasBackButton,
                  child: GestureDetector(
                    onTap: close,
                    child: Semantics(
                      label: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                      child: drawerScrim,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: _drawerOuterAlignment,
                child: Align(
                  alignment: _drawerInnerAlignment,
                  widthFactor: _controller.value,
                  child: RepaintBoundary(
                    child: FocusScope(key: _drawerKey, node: _focusScopeNode, child: widget.child),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

      if (isDesktop) {
        return child;
      }

      return GestureDetector(
        key: _gestureDetectorKey,
        onHorizontalDragDown: _handleDragDown,
        onHorizontalDragUpdate: _move,
        onHorizontalDragEnd: _settle,
        onHorizontalDragCancel: _handleDragCancel,
        excludeFromSemantics: true,
        dragStartBehavior: widget.dragStartBehavior,
        child: child,
      );
    }
  }

  @protected
  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    return ListTileTheme.merge(style: ListTileStyle.drawer, child: _buildDrawer(context));
  }
}

// BEGIN GENERATED TOKEN PROPERTIES - Drawer

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// dart format off
class _DrawerDefaultsM3 extends DrawerThemeData {
  _DrawerDefaultsM3(this.context)
      : super(
          elevation: 1.0,
          clipBehavior: Clip.hardEdge,
        );

  final BuildContext context;
  late final TextDirection direction = Directionality.of(context);

  @override
  Color? get backgroundColor => Theme.of(context).colorScheme.surfaceContainerLow;

  @override
  Color? get surfaceTintColor => Colors.transparent;

  @override
  Color? get shadowColor => Colors.transparent;

  // There isn't currently a token for this value, but it is shown in the spec,
  // so hard coding here for now.
  @override
  ShapeBorder? get shape => RoundedRectangleBorder(
    borderRadius: const BorderRadiusDirectional.horizontal(
      end: Radius.circular(16.0),
    ).resolve(direction),
  );

  // There isn't currently a token for this value, but it is shown in the spec,
  // so hard coding here for now.
  @override
  ShapeBorder? get endShape => RoundedRectangleBorder(
    borderRadius: const BorderRadiusDirectional.horizontal(
      start: Radius.circular(16.0),
    ).resolve(direction),
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BuildContext>('context', context));
    properties.add(EnumProperty<TextDirection>('direction', direction));
  }
}
// dart format on

// END GENERATED TOKEN PROPERTIES - Drawer
