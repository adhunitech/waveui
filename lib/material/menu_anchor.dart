// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/button_style.dart';
import 'package:waveui/material/button_style_button.dart';
import 'package:waveui/material/checkbox.dart';
import 'package:waveui/material/color_scheme.dart';
import 'package:waveui/material/colors.dart';
import 'package:waveui/material/constants.dart';
import 'package:waveui/material/icons.dart';
import 'package:waveui/material/ink_well.dart';
import 'package:waveui/material/material.dart';
import 'package:waveui/material/material_localizations.dart';
import 'package:waveui/material/menu_bar_theme.dart';
import 'package:waveui/material/menu_button_theme.dart';
import 'package:waveui/material/menu_style.dart';
import 'package:waveui/material/menu_theme.dart';
import 'package:waveui/material/radio.dart';
import 'package:waveui/material/scrollbar.dart';
import 'package:waveui/material/text_button.dart';
import 'package:waveui/src/theme/text_theme.dart';
import 'package:waveui/material/theme.dart';
import 'package:waveui/material/theme_data.dart';

// Examples can assume:
// bool _throwShotAway = false;
// late BuildContext context;
// enum SingingCharacter { lafayette }
// late SingingCharacter? _character;
// late StateSetter setState;

// Enable if you want verbose logging about menu changes.
const bool _kDebugMenus = false;

// The default size of the arrow in _MenuItemLabel that indicates that a menu
// has a submenu.
const double _kDefaultSubmenuIconSize = 24;

// The default spacing between the leading icon, label, trailing icon, and
// shortcut label in a _MenuItemLabel.
const double _kLabelItemDefaultSpacing = 12;

// The minimum spacing between the leading icon, label, trailing icon, and
// shortcut label in a _MenuItemLabel.
const double _kLabelItemMinSpacing = 4;

// Navigation shortcuts that we need to make sure are active when menus are
// open.
const Map<ShortcutActivator, Intent> _kMenuTraversalShortcuts = <ShortcutActivator, Intent>{
  SingleActivator(LogicalKeyboardKey.gameButtonA): ActivateIntent(),
  SingleActivator(LogicalKeyboardKey.escape): DismissIntent(),
  SingleActivator(LogicalKeyboardKey.tab): NextFocusIntent(),
  SingleActivator(LogicalKeyboardKey.tab, shift: true): PreviousFocusIntent(),
  SingleActivator(LogicalKeyboardKey.arrowDown): DirectionalFocusIntent(TraversalDirection.down),
  SingleActivator(LogicalKeyboardKey.arrowUp): DirectionalFocusIntent(TraversalDirection.up),
  SingleActivator(LogicalKeyboardKey.arrowLeft): DirectionalFocusIntent(TraversalDirection.left),
  SingleActivator(LogicalKeyboardKey.arrowRight): DirectionalFocusIntent(TraversalDirection.right),
};

// The minimum vertical spacing on the outside of menus.
const double _kMenuVerticalMinPadding = 8;

// How close to the edge of the safe area the menu will be placed.
const double _kMenuViewPadding = 8;

// The minimum horizontal spacing on the outside of the top level menu.
const double _kTopLevelMenuHorizontalMinPadding = 4;

typedef MenuAnchorChildBuilder = Widget Function(BuildContext context, MenuController controller, Widget? child);

class _MenuAnchorScope extends InheritedWidget {
  const _MenuAnchorScope({required this.state, required super.child});

  final _MenuAnchorState state;

  @override
  bool updateShouldNotify(_MenuAnchorScope oldWidget) {
    assert(oldWidget.state == state, 'The state of a MenuAnchor should not change.');
    return false;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<_MenuAnchorState>('state', state));
  }
}

class MenuAnchor extends StatefulWidget {
  const MenuAnchor({
    required this.menuChildren,
    super.key,
    this.controller,
    this.childFocusNode,
    this.style,
    this.alignmentOffset = Offset.zero,
    this.layerLink,
    this.clipBehavior = Clip.hardEdge,
    @Deprecated(
      'Use consumeOutsideTap instead. '
      'This feature was deprecated after v3.16.0-8.0.pre.',
    )
    this.anchorTapClosesMenu = false,
    this.consumeOutsideTap = false,
    this.onOpen,
    this.onClose,
    this.crossAxisUnconstrained = true,
    this.useRootOverlay = false,
    this.builder,
    this.child,
  });

  final MenuController? controller;

  final FocusNode? childFocusNode;

  final MenuStyle? style;

  final Offset? alignmentOffset;

  final LayerLink? layerLink;

  final Clip clipBehavior;

  @Deprecated(
    'Use consumeOutsideTap instead. '
    'This feature was deprecated after v3.16.0-8.0.pre.',
  )
  final bool anchorTapClosesMenu;

  final bool consumeOutsideTap;

  final VoidCallback? onOpen;

  final VoidCallback? onClose;

  final bool crossAxisUnconstrained;

  final bool useRootOverlay;

  final List<Widget> menuChildren;

  final MenuAnchorChildBuilder? builder;

  final Widget? child;

  @override
  State<MenuAnchor> createState() => _MenuAnchorState();

  @override
  List<DiagnosticsNode> debugDescribeChildren() =>
      menuChildren.map<DiagnosticsNode>((child) => child.toDiagnosticsNode()).toList();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(FlagProperty('anchorTapClosesMenu', value: anchorTapClosesMenu, ifTrue: 'AUTO-CLOSE'));
    properties.add(DiagnosticsProperty<FocusNode?>('focusNode', childFocusNode));
    properties.add(DiagnosticsProperty<MenuStyle?>('style', style));
    properties.add(EnumProperty<Clip>('clipBehavior', clipBehavior));
    properties.add(DiagnosticsProperty<Offset?>('alignmentOffset', alignmentOffset));
    properties.add(DiagnosticsProperty<MenuController?>('controller', controller));
    properties.add(DiagnosticsProperty<LayerLink?>('layerLink', layerLink));
    properties.add(DiagnosticsProperty<bool>('consumeOutsideTap', consumeOutsideTap));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onOpen', onOpen));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onClose', onClose));
    properties.add(DiagnosticsProperty<bool>('crossAxisUnconstrained', crossAxisUnconstrained));
    properties.add(DiagnosticsProperty<bool>('useRootOverlay', useRootOverlay));
    properties.add(ObjectFlagProperty<MenuAnchorChildBuilder?>.has('builder', builder));
  }
}

class _MenuAnchorState extends State<MenuAnchor> {
  Axis get _orientation => Axis.vertical;
  MenuController get _menuController => widget.controller ?? _internalMenuController!;
  MenuController? _internalMenuController;
  final FocusScopeNode _menuScopeNode = FocusScopeNode();
  _MenuAnchorState? get _parent => _MenuAnchorState._maybeOf(context);

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalMenuController = MenuController();
    }
  }

  @override
  void didUpdateWidget(MenuAnchor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _internalMenuController = widget.controller != null ? MenuController() : null;
    }
  }

  @override
  void dispose() {
    assert(_debugMenuInfo('Disposing of $this'));
    _internalMenuController = null;
    _menuScopeNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget child = _MenuAnchorScope(
      state: this,
      child: RawMenuAnchor(
        useRootOverlay: widget.useRootOverlay,
        onOpen: widget.onOpen,
        onClose: widget.onClose,
        consumeOutsideTaps: widget.consumeOutsideTap,
        controller: _menuController,
        childFocusNode: widget.childFocusNode,
        overlayBuilder: _buildOverlay,
        builder: widget.builder,
        child: widget.child,
      ),
    );

    if (widget.layerLink == null) {
      return child;
    }

    return CompositedTransformTarget(link: widget.layerLink!, child: child);
  }

  Widget _buildOverlay(BuildContext context, RawMenuOverlayInfo position) => _Submenu(
    layerLink: widget.layerLink,
    consumeOutsideTaps: widget.consumeOutsideTap,
    menuScopeNode: _menuScopeNode,
    menuStyle: widget.style,
    clipBehavior: widget.clipBehavior,
    menuChildren: widget.menuChildren,
    crossAxisUnconstrained: widget.crossAxisUnconstrained,
    menuPosition: position,
    anchor: this,
    alignmentOffset: widget.alignmentOffset ?? Offset.zero,
  );

  _MenuAnchorState get _root {
    _MenuAnchorState anchor = this;
    while (anchor._parent != null) {
      anchor = anchor._parent!;
    }
    return anchor;
  }

  void _focusButton() {
    if (widget.childFocusNode == null) {
      return;
    }
    assert(_debugMenuInfo('Requesting focus for ${widget.childFocusNode}'));
    widget.childFocusNode!.requestFocus();
  }

  void _focusFirstMenuItem() {
    if (_menuScopeNode.context?.mounted != true) {
      return;
    }
    final FocusTraversalPolicy policy =
        FocusTraversalGroup.maybeOf(_menuScopeNode.context!) ?? ReadingOrderTraversalPolicy();
    final FocusNode? firstFocus = policy.findFirstFocus(_menuScopeNode, ignoreCurrentFocus: true);
    if (firstFocus != null) {
      firstFocus.requestFocus();
    }
  }

  void _focusLastMenuItem() {
    if (_menuScopeNode.context?.mounted != true) {
      return;
    }
    final FocusTraversalPolicy policy =
        FocusTraversalGroup.maybeOf(_menuScopeNode.context!) ?? ReadingOrderTraversalPolicy();
    final FocusNode lastFocus = policy.findLastFocus(_menuScopeNode, ignoreCurrentFocus: true);
    lastFocus.requestFocus();
  }

  static _MenuAnchorState? _maybeOf(BuildContext context) =>
      context.getInheritedWidgetOfExactType<_MenuAnchorScope>()?.state;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) => describeIdentity(this);
}

class MenuBar extends StatelessWidget {
  const MenuBar({required this.children, super.key, this.style, this.clipBehavior = Clip.none, this.controller});

  final MenuStyle? style;

  final Clip clipBehavior;

  final MenuController? controller;

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasOverlay(context));
    return _MenuBarAnchor(controller: controller, clipBehavior: clipBehavior, style: style, menuChildren: children);
  }

  @override
  List<DiagnosticsNode> debugDescribeChildren() => <DiagnosticsNode>[
    ...children.map<DiagnosticsNode>((item) => item.toDiagnosticsNode()),
  ];

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<MenuStyle?>('style', style, defaultValue: null));
    properties.add(DiagnosticsProperty<Clip>('clipBehavior', clipBehavior, defaultValue: null));
    properties.add(DiagnosticsProperty<MenuController?>('controller', controller));
  }
}

class MenuItemButton extends StatefulWidget {
  const MenuItemButton({
    super.key,
    this.onPressed,
    this.onHover,
    this.requestFocusOnHover = true,
    this.onFocusChange,
    this.focusNode,
    this.autofocus = false,
    this.shortcut,
    this.semanticsLabel,
    this.style,
    this.statesController,
    this.clipBehavior = Clip.none,
    this.leadingIcon,
    this.trailingIcon,
    this.closeOnActivate = true,
    this.overflowAxis = Axis.horizontal,
    this.child,
  });

  final VoidCallback? onPressed;

  final ValueChanged<bool>? onHover;

  final bool requestFocusOnHover;

  final ValueChanged<bool>? onFocusChange;

  final FocusNode? focusNode;

  final bool autofocus;

  final MenuSerializableShortcut? shortcut;

  final String? semanticsLabel;

  final ButtonStyle? style;

  final WidgetStatesController? statesController;

  final Clip clipBehavior;

  final Widget? leadingIcon;

  final Widget? trailingIcon;

  final bool closeOnActivate;

  final Axis overflowAxis;

  final Widget? child;

  bool get enabled => onPressed != null;

  @override
  State<MenuItemButton> createState() => _MenuItemButtonState();

  ButtonStyle defaultStyleOf(BuildContext context) => _MenuButtonDefaultsM3(context);

  ButtonStyle? themeStyleOf(BuildContext context) => MenuButtonTheme.of(context).style;

  static ButtonStyle styleFrom({
    Color? foregroundColor,
    Color? backgroundColor,
    Color? disabledForegroundColor,
    Color? disabledBackgroundColor,
    Color? shadowColor,
    Color? surfaceTintColor,
    Color? iconColor,
    double? iconSize,
    Color? disabledIconColor,
    TextStyle? textStyle,
    Color? overlayColor,
    double? elevation,
    EdgeInsetsGeometry? padding,
    Size? minimumSize,
    Size? fixedSize,
    Size? maximumSize,
    MouseCursor? enabledMouseCursor,
    MouseCursor? disabledMouseCursor,
    BorderSide? side,
    OutlinedBorder? shape,
    VisualDensity? visualDensity,
    MaterialTapTargetSize? tapTargetSize,
    Duration? animationDuration,
    bool? enableFeedback,
    AlignmentGeometry? alignment,
    InteractiveInkFeatureFactory? splashFactory,
  }) => TextButton.styleFrom(
    foregroundColor: foregroundColor,
    backgroundColor: backgroundColor,
    disabledBackgroundColor: disabledBackgroundColor,
    disabledForegroundColor: disabledForegroundColor,
    shadowColor: shadowColor,
    surfaceTintColor: surfaceTintColor,
    iconColor: iconColor,
    iconSize: iconSize,
    disabledIconColor: disabledIconColor,
    textStyle: textStyle,
    overlayColor: overlayColor,
    elevation: elevation,
    padding: padding,
    minimumSize: minimumSize,
    fixedSize: fixedSize,
    maximumSize: maximumSize,
    enabledMouseCursor: enabledMouseCursor,
    disabledMouseCursor: disabledMouseCursor,
    side: side,
    shape: shape,
    visualDensity: visualDensity,
    tapTargetSize: tapTargetSize,
    animationDuration: animationDuration,
    enableFeedback: enableFeedback,
    alignment: alignment,
    splashFactory: splashFactory,
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(FlagProperty('enabled', value: onPressed != null, ifFalse: 'DISABLED'));
    properties.add(DiagnosticsProperty<ButtonStyle?>('style', style, defaultValue: null));
    properties.add(DiagnosticsProperty<MenuSerializableShortcut?>('shortcut', shortcut, defaultValue: null));
    properties.add(DiagnosticsProperty<FocusNode?>('focusNode', focusNode, defaultValue: null));
    properties.add(EnumProperty<Clip>('clipBehavior', clipBehavior, defaultValue: Clip.none));
    properties.add(
      DiagnosticsProperty<WidgetStatesController?>('statesController', statesController, defaultValue: null),
    );
    properties.add(ObjectFlagProperty<ValueChanged<bool>?>.has('onHover', onHover));
    properties.add(DiagnosticsProperty<bool>('requestFocusOnHover', requestFocusOnHover));
    properties.add(ObjectFlagProperty<ValueChanged<bool>?>.has('onFocusChange', onFocusChange));
    properties.add(DiagnosticsProperty<bool>('autofocus', autofocus));
    properties.add(StringProperty('semanticsLabel', semanticsLabel));
    properties.add(DiagnosticsProperty<bool>('closeOnActivate', closeOnActivate));
    properties.add(EnumProperty<Axis>('overflowAxis', overflowAxis));
    properties.add(DiagnosticsProperty<bool>('enabled', enabled));
  }
}

class _MenuItemButtonState extends State<MenuItemButton> {
  // If a focus node isn't given to the widget, then we have to manage our own.
  FocusNode? _internalFocusNode;
  FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode!;
  _MenuAnchorState? get _anchor => _MenuAnchorState._maybeOf(context);
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _createInternalFocusNodeIfNeeded();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _internalFocusNode?.dispose();
    _internalFocusNode = null;
    super.dispose();
  }

  @override
  void didUpdateWidget(MenuItemButton oldWidget) {
    if (widget.focusNode != oldWidget.focusNode) {
      (oldWidget.focusNode ?? _internalFocusNode)?.removeListener(_handleFocusChange);
      if (widget.focusNode != null) {
        _internalFocusNode?.dispose();
        _internalFocusNode = null;
      }
      _createInternalFocusNodeIfNeeded();
      _focusNode.addListener(_handleFocusChange);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    // Since we don't want to use the theme style or default style from the
    // TextButton, we merge the styles, merging them in the right order when
    // each type of style exists. Each "*StyleOf" function is only called once.
    ButtonStyle mergedStyle =
        widget.themeStyleOf(context)?.merge(widget.defaultStyleOf(context)) ?? widget.defaultStyleOf(context);
    if (widget.style != null) {
      mergedStyle = widget.style!.merge(mergedStyle);
    }

    Widget child = TextButton(
      onPressed: widget.enabled ? _handleSelect : null,
      onFocusChange: widget.enabled ? widget.onFocusChange : null,
      focusNode: _focusNode,
      style: mergedStyle,
      autofocus: widget.enabled && widget.autofocus,
      statesController: widget.statesController,
      clipBehavior: widget.clipBehavior,
      isSemanticButton: null,
      child: _MenuItemLabel(
        leadingIcon: widget.leadingIcon,
        shortcut: widget.shortcut,
        semanticsLabel: widget.semanticsLabel,
        trailingIcon: widget.trailingIcon,
        hasSubmenu: false,
        overflowAxis: _anchor?._orientation ?? widget.overflowAxis,
        child: widget.child,
      ),
    );

    if (_platformSupportsAccelerators && widget.enabled) {
      child = MenuAcceleratorCallbackBinding(onInvoke: _handleSelect, child: child);
    }

    if (widget.onHover != null || widget.requestFocusOnHover) {
      child = MouseRegion(onHover: _handlePointerHover, onExit: _handlePointerExit, child: child);
    }

    return MergeSemantics(child: child);
  }

  void _handleFocusChange() {
    if (!_focusNode.hasPrimaryFocus) {
      // Close any child menus of this button's menu.
      MenuController.maybeOf(context)?.closeChildren();
    }
  }

  void _handlePointerExit(PointerExitEvent event) {
    if (_isHovered) {
      widget.onHover?.call(false);
      _isHovered = false;
    }
  }

  // TextButton.onHover and MouseRegion.onHover can't be used without triggering
  // focus on scroll.
  void _handlePointerHover(PointerHoverEvent event) {
    if (!_isHovered) {
      _isHovered = true;
      widget.onHover?.call(true);
      if (widget.requestFocusOnHover) {
        assert(_debugMenuInfo('Requesting focus for $_focusNode from hover'));
        _focusNode.requestFocus();

        // Without invalidating the focus policy, switching to directional focus
        // may not originate at this node.
        FocusTraversalGroup.of(context).invalidateScopeData(FocusScope.of(context));
      }
    }
  }

  void _handleSelect() {
    assert(_debugMenuInfo('Selected ${widget.child} menu'));
    if (widget.closeOnActivate) {
      _anchor?._root._menuController.close();
    }
    // Delay the call to onPressed until post-frame so that the focus is
    // restored to what it was before the menu was opened before the action is
    // executed.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      FocusManager.instance.applyFocusChangesIfNeeded();
      widget.onPressed?.call();
    }, debugLabel: 'MenuAnchor.onPressed');
  }

  void _createInternalFocusNodeIfNeeded() {
    if (widget.focusNode == null) {
      _internalFocusNode = FocusNode();
      assert(() {
        _internalFocusNode?.debugLabel = '$MenuItemButton(${widget.child})';
        return true;
      }());
    }
  }
}

class CheckboxMenuButton extends StatelessWidget {
  const CheckboxMenuButton({
    required this.value,
    required this.onChanged,
    required this.child,
    super.key,
    this.tristate = false,
    this.isError = false,
    this.onHover,
    this.onFocusChange,
    this.focusNode,
    this.shortcut,
    this.style,
    this.statesController,
    this.clipBehavior = Clip.none,
    this.trailingIcon,
    this.closeOnActivate = true,
  });

  final bool? value;

  final bool tristate;

  final bool isError;

  final ValueChanged<bool?>? onChanged;

  final ValueChanged<bool>? onHover;

  final ValueChanged<bool>? onFocusChange;

  final FocusNode? focusNode;

  final MenuSerializableShortcut? shortcut;

  final ButtonStyle? style;

  final WidgetStatesController? statesController;

  final Clip clipBehavior;

  final Widget? trailingIcon;

  final bool closeOnActivate;

  final Widget? child;

  bool get enabled => onChanged != null;

  @override
  Widget build(BuildContext context) => MenuItemButton(
    key: key,
    onPressed:
        onChanged == null
            ? null
            : () {
              switch (value) {
                case false:
                  onChanged!(true);
                case true:
                  onChanged!(tristate ? null : false);
                case null:
                  onChanged!(false);
              }
            },
    onHover: onHover,
    onFocusChange: onFocusChange,
    focusNode: focusNode,
    style: style,
    shortcut: shortcut,
    statesController: statesController,
    leadingIcon: ExcludeFocus(
      child: IgnorePointer(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: Checkbox.width, maxWidth: Checkbox.width),
          child: Checkbox(tristate: tristate, value: value, onChanged: onChanged, isError: isError),
        ),
      ),
    ),
    clipBehavior: clipBehavior,
    trailingIcon: trailingIcon,
    closeOnActivate: closeOnActivate,
    child: child,
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool?>('value', value));
    properties.add(DiagnosticsProperty<bool>('tristate', tristate));
    properties.add(DiagnosticsProperty<bool>('isError', isError));
    properties.add(ObjectFlagProperty<ValueChanged<bool?>?>.has('onChanged', onChanged));
    properties.add(ObjectFlagProperty<ValueChanged<bool>?>.has('onHover', onHover));
    properties.add(ObjectFlagProperty<ValueChanged<bool>?>.has('onFocusChange', onFocusChange));
    properties.add(DiagnosticsProperty<FocusNode?>('focusNode', focusNode));
    properties.add(DiagnosticsProperty<MenuSerializableShortcut?>('shortcut', shortcut));
    properties.add(DiagnosticsProperty<ButtonStyle?>('style', style));
    properties.add(DiagnosticsProperty<WidgetStatesController?>('statesController', statesController));
    properties.add(EnumProperty<Clip>('clipBehavior', clipBehavior));
    properties.add(DiagnosticsProperty<bool>('closeOnActivate', closeOnActivate));
    properties.add(DiagnosticsProperty<bool>('enabled', enabled));
  }
}

class RadioMenuButton<T> extends StatelessWidget {
  const RadioMenuButton({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.child,
    super.key,
    this.toggleable = false,
    this.onHover,
    this.onFocusChange,
    this.focusNode,
    this.shortcut,
    this.style,
    this.statesController,
    this.clipBehavior = Clip.none,
    this.trailingIcon,
    this.closeOnActivate = true,
  });

  final T value;

  final T? groupValue;

  final bool toggleable;

  final ValueChanged<T?>? onChanged;

  final ValueChanged<bool>? onHover;

  final ValueChanged<bool>? onFocusChange;

  final FocusNode? focusNode;

  final MenuSerializableShortcut? shortcut;

  final ButtonStyle? style;

  final WidgetStatesController? statesController;

  final Clip clipBehavior;

  final Widget? trailingIcon;

  final bool closeOnActivate;

  final Widget? child;

  bool get enabled => onChanged != null;

  @override
  Widget build(BuildContext context) => MenuItemButton(
    key: key,
    onPressed:
        onChanged == null
            ? null
            : () {
              if (toggleable && groupValue == value) {
                return onChanged!(null);
              }
              onChanged!(value);
            },
    onHover: onHover,
    onFocusChange: onFocusChange,
    focusNode: focusNode,
    style: style,
    shortcut: shortcut,
    statesController: statesController,
    leadingIcon: ExcludeFocus(
      child: IgnorePointer(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: Checkbox.width, maxWidth: Checkbox.width),
          child: Radio<T>(value: value, groupValue: groupValue, onChanged: onChanged, toggleable: toggleable),
        ),
      ),
    ),
    clipBehavior: clipBehavior,
    trailingIcon: trailingIcon,
    closeOnActivate: closeOnActivate,
    child: child,
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<T>('value', value));
    properties.add(DiagnosticsProperty<T?>('groupValue', groupValue));
    properties.add(DiagnosticsProperty<bool>('toggleable', toggleable));
    properties.add(ObjectFlagProperty<ValueChanged<T?>?>.has('onChanged', onChanged));
    properties.add(ObjectFlagProperty<ValueChanged<bool>?>.has('onHover', onHover));
    properties.add(ObjectFlagProperty<ValueChanged<bool>?>.has('onFocusChange', onFocusChange));
    properties.add(DiagnosticsProperty<FocusNode?>('focusNode', focusNode));
    properties.add(DiagnosticsProperty<MenuSerializableShortcut?>('shortcut', shortcut));
    properties.add(DiagnosticsProperty<ButtonStyle?>('style', style));
    properties.add(DiagnosticsProperty<WidgetStatesController?>('statesController', statesController));
    properties.add(EnumProperty<Clip>('clipBehavior', clipBehavior));
    properties.add(DiagnosticsProperty<bool>('closeOnActivate', closeOnActivate));
    properties.add(DiagnosticsProperty<bool>('enabled', enabled));
  }
}

class SubmenuButton extends StatefulWidget {
  const SubmenuButton({
    required this.menuChildren,
    required this.child,
    super.key,
    this.onHover,
    this.onFocusChange,
    this.onOpen,
    this.onClose,
    this.controller,
    this.style,
    this.menuStyle,
    this.alignmentOffset,
    this.clipBehavior = Clip.hardEdge,
    this.focusNode,
    this.statesController,
    this.leadingIcon,
    this.trailingIcon,
    this.submenuIcon,
    this.useRootOverlay = false,
  });

  final ValueChanged<bool>? onHover;

  final ValueChanged<bool>? onFocusChange;

  final VoidCallback? onOpen;

  final VoidCallback? onClose;

  final MenuController? controller;

  final ButtonStyle? style;

  final MenuStyle? menuStyle;

  final Offset? alignmentOffset;

  final Clip clipBehavior;

  final FocusNode? focusNode;

  final WidgetStatesController? statesController;

  final Widget? leadingIcon;

  final WidgetStateProperty<Widget?>? submenuIcon;

  final Widget? trailingIcon;

  final bool useRootOverlay;

  final List<Widget> menuChildren;

  final Widget? child;

  @override
  State<SubmenuButton> createState() => _SubmenuButtonState();

  ButtonStyle defaultStyleOf(BuildContext context) => _MenuButtonDefaultsM3(context);

  ButtonStyle? themeStyleOf(BuildContext context) => MenuButtonTheme.of(context).style;

  static ButtonStyle styleFrom({
    Color? foregroundColor,
    Color? backgroundColor,
    Color? disabledForegroundColor,
    Color? disabledBackgroundColor,
    Color? shadowColor,
    Color? surfaceTintColor,
    Color? iconColor,
    double? iconSize,
    Color? disabledIconColor,
    TextStyle? textStyle,
    Color? overlayColor,
    double? elevation,
    EdgeInsetsGeometry? padding,
    Size? minimumSize,
    Size? fixedSize,
    Size? maximumSize,
    MouseCursor? enabledMouseCursor,
    MouseCursor? disabledMouseCursor,
    BorderSide? side,
    OutlinedBorder? shape,
    VisualDensity? visualDensity,
    MaterialTapTargetSize? tapTargetSize,
    Duration? animationDuration,
    bool? enableFeedback,
    AlignmentGeometry? alignment,
    InteractiveInkFeatureFactory? splashFactory,
  }) => TextButton.styleFrom(
    foregroundColor: foregroundColor,
    backgroundColor: backgroundColor,
    disabledBackgroundColor: disabledBackgroundColor,
    disabledForegroundColor: disabledForegroundColor,
    shadowColor: shadowColor,
    surfaceTintColor: surfaceTintColor,
    iconColor: iconColor,
    disabledIconColor: disabledIconColor,
    iconSize: iconSize,
    textStyle: textStyle,
    overlayColor: overlayColor,
    elevation: elevation,
    padding: padding,
    minimumSize: minimumSize,
    fixedSize: fixedSize,
    maximumSize: maximumSize,
    enabledMouseCursor: enabledMouseCursor,
    disabledMouseCursor: disabledMouseCursor,
    side: side,
    shape: shape,
    visualDensity: visualDensity,
    tapTargetSize: tapTargetSize,
    animationDuration: animationDuration,
    enableFeedback: enableFeedback,
    alignment: alignment,
    splashFactory: splashFactory,
  );

  @override
  List<DiagnosticsNode> debugDescribeChildren() => <DiagnosticsNode>[
    ...menuChildren.map<DiagnosticsNode>((child) => child.toDiagnosticsNode()),
  ];

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<FocusNode?>('focusNode', focusNode));
    properties.add(DiagnosticsProperty<MenuStyle>('menuStyle', menuStyle, defaultValue: null));
    properties.add(DiagnosticsProperty<Offset>('alignmentOffset', alignmentOffset));
    properties.add(EnumProperty<Clip>('clipBehavior', clipBehavior));
    properties.add(ObjectFlagProperty<ValueChanged<bool>?>.has('onHover', onHover));
    properties.add(ObjectFlagProperty<ValueChanged<bool>?>.has('onFocusChange', onFocusChange));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onOpen', onOpen));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onClose', onClose));
    properties.add(DiagnosticsProperty<MenuController?>('controller', controller));
    properties.add(DiagnosticsProperty<ButtonStyle?>('style', style));
    properties.add(DiagnosticsProperty<WidgetStatesController?>('statesController', statesController));
    properties.add(DiagnosticsProperty<WidgetStateProperty<Widget?>?>('submenuIcon', submenuIcon));
    properties.add(DiagnosticsProperty<bool>('useRootOverlay', useRootOverlay));
  }
}

class _SubmenuButtonState extends State<SubmenuButton> {
  late final Map<Type, Action<Intent>> actions = <Type, Action<Intent>>{
    DirectionalFocusIntent: _SubmenuDirectionalFocusAction(submenu: this),
  };
  bool _waitingToFocusMenu = false;
  bool _isOpenOnFocusEnabled = true;
  MenuController? _internalMenuController;
  MenuController get _menuController => widget.controller ?? _internalMenuController!;
  _MenuAnchorState? get _parent => _MenuAnchorState._maybeOf(context);
  _MenuAnchorState? get _anchorState => _anchorKey.currentState;
  FocusNode? _internalFocusNode;
  final GlobalKey<_MenuAnchorState> _anchorKey = GlobalKey<_MenuAnchorState>();
  FocusNode get _buttonFocusNode => widget.focusNode ?? _internalFocusNode!;
  bool get _enabled => widget.menuChildren.isNotEmpty;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode == null) {
      _internalFocusNode = FocusNode();
      assert(() {
        _internalFocusNode?.debugLabel = '$SubmenuButton(${widget.child})';
        return true;
      }());
    }
    if (widget.controller == null) {
      _internalMenuController = MenuController();
    }
    _buttonFocusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _buttonFocusNode.removeListener(_handleFocusChange);
    _internalFocusNode?.dispose();
    _internalFocusNode = null;
    super.dispose();
  }

  @override
  void didUpdateWidget(SubmenuButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      if (oldWidget.focusNode == null) {
        _internalFocusNode?.removeListener(_handleFocusChange);
        _internalFocusNode?.dispose();
        _internalFocusNode = null;
      } else {
        oldWidget.focusNode!.removeListener(_handleFocusChange);
      }
      if (widget.focusNode == null) {
        _internalFocusNode ??= FocusNode();
        assert(() {
          _internalFocusNode?.debugLabel = '$SubmenuButton(${widget.child})';
          return true;
        }());
      }
      _buttonFocusNode.addListener(_handleFocusChange);
    }
    if (widget.controller != oldWidget.controller) {
      _internalMenuController = (oldWidget.controller == null) ? null : MenuController();
    }
  }

  @override
  Widget build(BuildContext context) {
    Offset menuPaddingOffset = widget.alignmentOffset ?? Offset.zero;
    final EdgeInsets menuPadding = _computeMenuPadding(context);
    final Axis orientation = _parent?._orientation ?? Axis.vertical;
    // Move the submenu over by the size of the menu padding, so that
    // the first menu item aligns with the submenu button that opens it.
    menuPaddingOffset += switch ((orientation, Directionality.of(context))) {
      (Axis.horizontal, TextDirection.rtl) => Offset(menuPadding.right, 0),
      (Axis.horizontal, TextDirection.ltr) => Offset(-menuPadding.left, 0),
      (Axis.vertical, TextDirection.rtl) => Offset(0, -menuPadding.top),
      (Axis.vertical, TextDirection.ltr) => Offset(0, -menuPadding.top),
    };
    final Set<WidgetState> states = <WidgetState>{
      if (!_enabled) WidgetState.disabled,
      if (_isHovered) WidgetState.hovered,
      if (_buttonFocusNode.hasFocus) WidgetState.focused,
    };
    final Widget submenuIcon =
        widget.submenuIcon?.resolve(states) ??
        MenuTheme.of(context).submenuIcon?.resolve(states) ??
        const Icon(
          Icons.arrow_right, // Automatically switches with text direction.
          size: _kDefaultSubmenuIconSize,
        );

    return Actions(
      actions: actions,
      child: MenuAnchor(
        key: _anchorKey,
        controller: _menuController,
        childFocusNode: _buttonFocusNode,
        alignmentOffset: menuPaddingOffset,
        clipBehavior: widget.clipBehavior,
        onClose: _onClose,
        onOpen: _onOpen,
        style: widget.menuStyle,
        useRootOverlay: widget.useRootOverlay,
        builder: (context, controller, child) {
          // Since we don't want to use the theme style or default style from the
          // TextButton, we merge the styles, merging them in the right order when
          // each type of style exists. Each "*StyleOf" function is only called
          // once.
          ButtonStyle mergedStyle =
              widget.themeStyleOf(context)?.merge(widget.defaultStyleOf(context)) ?? widget.defaultStyleOf(context);
          mergedStyle = widget.style?.merge(mergedStyle) ?? mergedStyle;

          void toggleShowMenu() {
            if (!mounted) {
              return;
            }
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          }

          void handlePointerExit(PointerExitEvent event) {
            if (_isHovered) {
              widget.onHover?.call(false);
              _isHovered = false;
            }
          }

          // MouseRegion.onEnter and TextButton.onHover are called
          // if a button is hovered after scrolling. This interferes with
          // focus traversal and scroll position. MouseRegion.onHover avoids
          // this issue.
          void handlePointerHover(PointerHoverEvent event) {
            if (!_isHovered) {
              _isHovered = true;
              widget.onHover?.call(true);
              final _MenuAnchorState root = _MenuAnchorState._maybeOf(context)!._root;
              // Don't open the root menu bar menus on hover unless something else
              // is already open. This means that the user has to first click to
              // open a menu on the menu bar before hovering allows them to traverse
              // it.
              if (root._orientation == Axis.horizontal && !root._menuController.isOpen) {
                return;
              }

              controller.open();
              _buttonFocusNode.requestFocus();
            }
          }

          child = MergeSemantics(
            child: Semantics(
              expanded: _enabled && controller.isOpen,
              child: TextButton(
                style: mergedStyle,
                focusNode: _buttonFocusNode,
                onFocusChange: _enabled ? widget.onFocusChange : null,
                onPressed: _enabled ? toggleShowMenu : null,
                isSemanticButton: null,
                child: _MenuItemLabel(
                  leadingIcon: widget.leadingIcon,
                  trailingIcon: widget.trailingIcon,
                  hasSubmenu: true,
                  showDecoration: (_parent?._orientation ?? Axis.horizontal) == Axis.vertical,
                  submenuIcon: submenuIcon,
                  child: child,
                ),
              ),
            ),
          );

          if (!_enabled) {
            return child;
          }

          child = MouseRegion(onHover: handlePointerHover, onExit: handlePointerExit, child: child);

          if (_platformSupportsAccelerators) {
            return MenuAcceleratorCallbackBinding(onInvoke: toggleShowMenu, hasSubmenu: true, child: child);
          }

          return child;
        },
        menuChildren: widget.menuChildren,
        child: widget.child,
      ),
    );
  }

  void _onClose() {
    // After closing the children of this submenu, this submenu button will
    // regain focus. Because submenu buttons open on focus, this submenu will
    // immediately reopen. To prevent this from happening, we prevent focus on
    // SubmenuButtons that do not already have focus using the _openOnFocus
    // flag. This flag is reset after one frame.
    if (!_buttonFocusNode.hasFocus) {
      _isOpenOnFocusEnabled = false;
      SchedulerBinding.instance.addPostFrameCallback((timestamp) {
        FocusManager.instance.applyFocusChangesIfNeeded();
        _isOpenOnFocusEnabled = true;
      }, debugLabel: 'MenuAnchor.preventOpenOnFocus');
    }
    widget.onClose?.call();
  }

  void _onOpen() {
    if (!_waitingToFocusMenu) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _buttonFocusNode.requestFocus();
          _waitingToFocusMenu = false;
        }
      }, debugLabel: 'MenuAnchor.focus');
      _waitingToFocusMenu = true;
    }
    setState(() {
      /* Rebuild with updated controller.isOpen value */
    });
    widget.onOpen?.call();
  }

  EdgeInsets _computeMenuPadding(BuildContext context) {
    final WidgetStateProperty<EdgeInsetsGeometry?> insets =
        widget.menuStyle?.padding ?? MenuTheme.of(context).style?.padding ?? _MenuDefaultsM3(context).padding!;
    return insets.resolve(widget.statesController?.value ?? const <WidgetState>{})!.resolve(Directionality.of(context));
  }

  void _handleFocusChange() {
    if (_buttonFocusNode.hasPrimaryFocus) {
      if (!_menuController.isOpen && _isOpenOnFocusEnabled) {
        _menuController.open();
      }
    } else {
      if (!_anchorState!._menuScopeNode.hasFocus && _menuController.isOpen) {
        _menuController.close();
      }
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Map<Type, Action<Intent>>>('actions', actions));
  }
}

class _SubmenuDirectionalFocusAction extends DirectionalFocusAction {
  _SubmenuDirectionalFocusAction({required this.submenu});

  final _SubmenuButtonState submenu;
  _MenuAnchorState? get _parent => submenu._parent;
  _MenuAnchorState? get _anchorState => submenu._anchorState;
  MenuController get _controller => submenu._menuController;

  Axis? get _orientation => _parent?._orientation;

  bool get isSubmenu => submenu._buttonFocusNode.hasPrimaryFocus;
  FocusNode get _button => submenu._buttonFocusNode;

  @override
  void invoke(DirectionalFocusIntent intent) {
    assert(_debugMenuInfo('${intent.direction}: Invoking directional focus intent.'));
    final TextDirection directionality = Directionality.of(submenu.context);
    switch ((_orientation, directionality, intent.direction)) {
      case (Axis.horizontal, TextDirection.ltr, TraversalDirection.left):
      case (Axis.horizontal, TextDirection.rtl, TraversalDirection.right):
        assert(_debugMenuInfo('Moving to previous $MenuBar item'));
        // Focus this MenuBar SubmenuButton, then move focus to the previous focusable
        // MenuBar item.
        _button
          ..requestFocus()
          ..previousFocus();
        return;
      case (Axis.horizontal, TextDirection.ltr, TraversalDirection.right):
      case (Axis.horizontal, TextDirection.rtl, TraversalDirection.left):
        assert(_debugMenuInfo('Moving to next $MenuBar item'));
        // Focus this MenuBar SubmenuButton, then move focus to the next focusable
        // MenuBar item.
        _button
          ..requestFocus()
          ..nextFocus();
        return;
      case (Axis.horizontal, _, TraversalDirection.down):
        if (isSubmenu) {
          // If this is a top-level (horizontal) button in a menubar, focus the
          // first item in this button's submenu.
          _anchorState?._focusFirstMenuItem();
          return;
        }
      case (Axis.horizontal, _, TraversalDirection.up):
        if (isSubmenu) {
          // If this is a top-level (horizontal) button in a menubar, focus the
          // last item in this button's submenu. This makes navigating into
          // upward-oriented submenus more intuitive.
          _anchorState?._focusLastMenuItem();
          return;
        }
      case (Axis.vertical, TextDirection.ltr, TraversalDirection.left):
      case (Axis.vertical, TextDirection.rtl, TraversalDirection.right):
        if (_parent?._parent?._orientation == Axis.horizontal) {
          if (isSubmenu) {
            _parent!.widget.childFocusNode
              ?..requestFocus()
              ..previousFocus();
          } else {
            assert(_debugMenuInfo('Exiting submenu'));
            // MenuBar SubmenuButton => SubmenuButton => child
            // Focus the parent SubmenuButton anchor attached to this child.
            _anchorState?._focusButton();
          }
        } else {
          if (isSubmenu) {
            if (_parent?._parent == null) {
              // Moving in the closing direction while focused on a
              // SubmenuButton within a root MenuAnchor menu should not close
              // the menu.
              return;
            }
            _parent?._focusButton();
            _parent?._menuController.close();
          } else {
            // If focus is not on a submenu button, closing the anchor this item
            // presides in will close the menu and focus the anchor button.
            _controller.close();
          }
          assert(_debugMenuInfo('Exiting submenu'));
        }
        return;
      case (Axis.vertical, TextDirection.ltr, TraversalDirection.right) when isSubmenu:
      case (Axis.vertical, TextDirection.rtl, TraversalDirection.left) when isSubmenu:
        assert(_debugMenuInfo('Entering submenu'));
        if (_controller.isOpen) {
          _anchorState?._focusFirstMenuItem();
        } else {
          _controller.open();
          SchedulerBinding.instance.addPostFrameCallback((timestamp) {
            if (_controller.isOpen) {
              _anchorState?._focusFirstMenuItem();
            }
          });
        }
        return;
      default:
        break;
    }

    Actions.maybeInvoke(submenu.context, intent);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<_SubmenuButtonState>('submenu', submenu));
    properties.add(DiagnosticsProperty<bool>('isSubmenu', isSubmenu));
  }
}

class _LocalizedShortcutLabeler {
  _LocalizedShortcutLabeler._();

  static _LocalizedShortcutLabeler? _instance;

  static final Map<LogicalKeyboardKey, String> _shortcutGraphicEquivalents = <LogicalKeyboardKey, String>{
    LogicalKeyboardKey.arrowLeft: '←',
    LogicalKeyboardKey.arrowRight: '→',
    LogicalKeyboardKey.arrowUp: '↑',
    LogicalKeyboardKey.arrowDown: '↓',
    LogicalKeyboardKey.enter: '↵',
  };

  static final Set<LogicalKeyboardKey> _modifiers = <LogicalKeyboardKey>{
    LogicalKeyboardKey.alt,
    LogicalKeyboardKey.control,
    LogicalKeyboardKey.meta,
    LogicalKeyboardKey.shift,
    LogicalKeyboardKey.altLeft,
    LogicalKeyboardKey.controlLeft,
    LogicalKeyboardKey.metaLeft,
    LogicalKeyboardKey.shiftLeft,
    LogicalKeyboardKey.altRight,
    LogicalKeyboardKey.controlRight,
    LogicalKeyboardKey.metaRight,
    LogicalKeyboardKey.shiftRight,
  };

  static _LocalizedShortcutLabeler get instance => _instance ??= _LocalizedShortcutLabeler._();

  // Caches the created shortcut key maps so that creating one of these isn't
  // expensive after the first time for each unique localizations object.
  final Map<MaterialLocalizations, Map<LogicalKeyboardKey, String>> _cachedShortcutKeys =
      <MaterialLocalizations, Map<LogicalKeyboardKey, String>>{};

  String getShortcutLabel(MenuSerializableShortcut shortcut, MaterialLocalizations localizations) {
    final ShortcutSerialization serialized = shortcut.serializeForMenu();
    final String keySeparator;
    if (_usesSymbolicModifiers) {
      // Use "⌃ ⇧ A" style on macOS and iOS.
      keySeparator = ' ';
    } else {
      // Use "Ctrl+Shift+A" style.
      keySeparator = '+';
    }
    if (serialized.trigger != null) {
      final LogicalKeyboardKey trigger = serialized.trigger!;
      final List<String> modifiers = <String>[
        if (_usesSymbolicModifiers) ...<String>[
          // macOS/iOS platform convention uses this ordering, with ⌘ always last.
          if (serialized.control!) _getModifierLabel(LogicalKeyboardKey.control, localizations),
          if (serialized.alt!) _getModifierLabel(LogicalKeyboardKey.alt, localizations),
          if (serialized.shift!) _getModifierLabel(LogicalKeyboardKey.shift, localizations),
          if (serialized.meta!) _getModifierLabel(LogicalKeyboardKey.meta, localizations),
        ] else ...<String>[
          // This order matches the LogicalKeySet version.
          if (serialized.alt!) _getModifierLabel(LogicalKeyboardKey.alt, localizations),
          if (serialized.control!) _getModifierLabel(LogicalKeyboardKey.control, localizations),
          if (serialized.meta!) _getModifierLabel(LogicalKeyboardKey.meta, localizations),
          if (serialized.shift!) _getModifierLabel(LogicalKeyboardKey.shift, localizations),
        ],
      ];
      String? shortcutTrigger;
      final int logicalKeyId = trigger.keyId;
      if (_shortcutGraphicEquivalents.containsKey(trigger)) {
        shortcutTrigger = _shortcutGraphicEquivalents[trigger];
      } else {
        // Otherwise, look it up, and if we don't have a translation for it,
        // then fall back to the key label.
        shortcutTrigger = _getLocalizedName(trigger, localizations);
        if (shortcutTrigger == null && logicalKeyId & LogicalKeyboardKey.planeMask == 0x0) {
          // If the trigger is a Unicode-character-producing key, then use the
          // character.
          shortcutTrigger = String.fromCharCode(logicalKeyId & LogicalKeyboardKey.valueMask).toUpperCase();
        }
        // Fall back to the key label if all else fails.
        shortcutTrigger ??= trigger.keyLabel;
      }
      return <String>[
        ...modifiers,
        if (shortcutTrigger != null && shortcutTrigger.isNotEmpty) shortcutTrigger,
      ].join(keySeparator);
    } else if (serialized.character != null) {
      final List<String> modifiers = <String>[
        // Character based shortcuts cannot check shifted keys.
        if (_usesSymbolicModifiers) ...<String>[
          // macOS/iOS platform convention uses this ordering, with ⌘ always last.
          if (serialized.control!) _getModifierLabel(LogicalKeyboardKey.control, localizations),
          if (serialized.alt!) _getModifierLabel(LogicalKeyboardKey.alt, localizations),
          if (serialized.meta!) _getModifierLabel(LogicalKeyboardKey.meta, localizations),
        ] else ...<String>[
          // This order matches the LogicalKeySet version.
          if (serialized.alt!) _getModifierLabel(LogicalKeyboardKey.alt, localizations),
          if (serialized.control!) _getModifierLabel(LogicalKeyboardKey.control, localizations),
          if (serialized.meta!) _getModifierLabel(LogicalKeyboardKey.meta, localizations),
        ],
      ];
      return <String>[...modifiers, serialized.character!].join(keySeparator);
    }
    throw UnimplementedError(
      'Shortcut labels for ShortcutActivators that do not implement '
      'MenuSerializableShortcut (e.g. ShortcutActivators other than SingleActivator or '
      'CharacterActivator) are not supported.',
    );
  }

  // Tries to look up the key in an internal table, and if it can't find it,
  // then fall back to the key's keyLabel.
  String? _getLocalizedName(LogicalKeyboardKey key, MaterialLocalizations localizations) {
    // Since this is an expensive table to build, we cache it based on the
    // localization object. There's currently no way to clear the cache, but
    // it's unlikely that more than one or two will be cached for each run, and
    // they're not huge.
    _cachedShortcutKeys[localizations] ??= <LogicalKeyboardKey, String>{
      LogicalKeyboardKey.altGraph: localizations.keyboardKeyAltGraph,
      LogicalKeyboardKey.backspace: localizations.keyboardKeyBackspace,
      LogicalKeyboardKey.capsLock: localizations.keyboardKeyCapsLock,
      LogicalKeyboardKey.channelDown: localizations.keyboardKeyChannelDown,
      LogicalKeyboardKey.channelUp: localizations.keyboardKeyChannelUp,
      LogicalKeyboardKey.delete: localizations.keyboardKeyDelete,
      LogicalKeyboardKey.eject: localizations.keyboardKeyEject,
      LogicalKeyboardKey.end: localizations.keyboardKeyEnd,
      LogicalKeyboardKey.escape: localizations.keyboardKeyEscape,
      LogicalKeyboardKey.fn: localizations.keyboardKeyFn,
      LogicalKeyboardKey.home: localizations.keyboardKeyHome,
      LogicalKeyboardKey.insert: localizations.keyboardKeyInsert,
      LogicalKeyboardKey.numLock: localizations.keyboardKeyNumLock,
      LogicalKeyboardKey.numpad1: localizations.keyboardKeyNumpad1,
      LogicalKeyboardKey.numpad2: localizations.keyboardKeyNumpad2,
      LogicalKeyboardKey.numpad3: localizations.keyboardKeyNumpad3,
      LogicalKeyboardKey.numpad4: localizations.keyboardKeyNumpad4,
      LogicalKeyboardKey.numpad5: localizations.keyboardKeyNumpad5,
      LogicalKeyboardKey.numpad6: localizations.keyboardKeyNumpad6,
      LogicalKeyboardKey.numpad7: localizations.keyboardKeyNumpad7,
      LogicalKeyboardKey.numpad8: localizations.keyboardKeyNumpad8,
      LogicalKeyboardKey.numpad9: localizations.keyboardKeyNumpad9,
      LogicalKeyboardKey.numpad0: localizations.keyboardKeyNumpad0,
      LogicalKeyboardKey.numpadAdd: localizations.keyboardKeyNumpadAdd,
      LogicalKeyboardKey.numpadComma: localizations.keyboardKeyNumpadComma,
      LogicalKeyboardKey.numpadDecimal: localizations.keyboardKeyNumpadDecimal,
      LogicalKeyboardKey.numpadDivide: localizations.keyboardKeyNumpadDivide,
      LogicalKeyboardKey.numpadEnter: localizations.keyboardKeyNumpadEnter,
      LogicalKeyboardKey.numpadEqual: localizations.keyboardKeyNumpadEqual,
      LogicalKeyboardKey.numpadMultiply: localizations.keyboardKeyNumpadMultiply,
      LogicalKeyboardKey.numpadParenLeft: localizations.keyboardKeyNumpadParenLeft,
      LogicalKeyboardKey.numpadParenRight: localizations.keyboardKeyNumpadParenRight,
      LogicalKeyboardKey.numpadSubtract: localizations.keyboardKeyNumpadSubtract,
      LogicalKeyboardKey.pageDown: localizations.keyboardKeyPageDown,
      LogicalKeyboardKey.pageUp: localizations.keyboardKeyPageUp,
      LogicalKeyboardKey.power: localizations.keyboardKeyPower,
      LogicalKeyboardKey.powerOff: localizations.keyboardKeyPowerOff,
      LogicalKeyboardKey.printScreen: localizations.keyboardKeyPrintScreen,
      LogicalKeyboardKey.scrollLock: localizations.keyboardKeyScrollLock,
      LogicalKeyboardKey.select: localizations.keyboardKeySelect,
      LogicalKeyboardKey.space: localizations.keyboardKeySpace,
    };
    return _cachedShortcutKeys[localizations]![key];
  }

  String _getModifierLabel(LogicalKeyboardKey modifier, MaterialLocalizations localizations) {
    assert(_modifiers.contains(modifier), '${modifier.keyLabel} is not a modifier key');
    if (modifier == LogicalKeyboardKey.meta ||
        modifier == LogicalKeyboardKey.metaLeft ||
        modifier == LogicalKeyboardKey.metaRight) {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
        case TargetPlatform.linux:
          return localizations.keyboardKeyMeta;
        case TargetPlatform.windows:
          return localizations.keyboardKeyMetaWindows;
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
          return '⌘';
      }
    }
    if (modifier == LogicalKeyboardKey.alt ||
        modifier == LogicalKeyboardKey.altLeft ||
        modifier == LogicalKeyboardKey.altRight) {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
          return localizations.keyboardKeyAlt;
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
          return '⌥';
      }
    }
    if (modifier == LogicalKeyboardKey.control ||
        modifier == LogicalKeyboardKey.controlLeft ||
        modifier == LogicalKeyboardKey.controlRight) {
      // '⎈' (a boat helm wheel, not an asterisk) is apparently the standard
      // icon for "control", but only seems to appear on the French Canadian
      // keyboard. A '✲' (an open center asterisk) appears on some Microsoft
      // keyboards. For all but macOS (which has standardized on "⌃", it seems),
      // we just return the local translation of "Ctrl".
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
          return localizations.keyboardKeyControl;
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
          return '⌃';
      }
    }
    if (modifier == LogicalKeyboardKey.shift ||
        modifier == LogicalKeyboardKey.shiftLeft ||
        modifier == LogicalKeyboardKey.shiftRight) {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
          return localizations.keyboardKeyShift;
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
          return '⇧';
      }
    }
    throw ArgumentError('Keyboard key ${modifier.keyLabel} is not a modifier.');
  }
}

class _MenuBarAnchor extends MenuAnchor {
  const _MenuBarAnchor({required super.menuChildren, super.controller, super.clipBehavior, super.style});

  @override
  State<MenuAnchor> createState() => _MenuBarAnchorState();
}

class _MenuBarAnchorState extends _MenuAnchorState {
  late final Map<Type, Action<Intent>> actions = <Type, Action<Intent>>{
    DismissIntent: DismissMenuAction(controller: _menuController),
  };

  @override
  Axis get _orientation => Axis.horizontal;

  @override
  Widget build(BuildContext context) {
    final Actions child = Actions(
      actions: actions,
      child: Shortcuts(
        shortcuts: _kMenuTraversalShortcuts,
        child: _MenuPanel(
          menuStyle: widget.style,
          clipBehavior: widget.clipBehavior,
          orientation: _orientation,
          children: widget.menuChildren,
        ),
      ),
    );
    return _MenuAnchorScope(
      state: this,
      child: RawMenuAnchorGroup(
        controller: _menuController,
        child: Builder(
          builder: (context) {
            final bool isOpen = MenuController.maybeIsOpenOf(context) ?? false;
            return FocusScope(
              node: _menuScopeNode,
              skipTraversal: !isOpen,
              canRequestFocus: isOpen,
              descendantsAreFocusable: true,
              child: ExcludeFocus(excluding: !isOpen, child: child),
            );
          },
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Map<Type, Action<Intent>>>('actions', actions));
  }
}

class MenuAcceleratorCallbackBinding extends InheritedWidget {
  const MenuAcceleratorCallbackBinding({required super.child, super.key, this.onInvoke, this.hasSubmenu = false});

  final VoidCallback? onInvoke;

  final bool hasSubmenu;

  @override
  bool updateShouldNotify(MenuAcceleratorCallbackBinding oldWidget) =>
      onInvoke != oldWidget.onInvoke || hasSubmenu != oldWidget.hasSubmenu;

  static MenuAcceleratorCallbackBinding? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MenuAcceleratorCallbackBinding>();

  static MenuAcceleratorCallbackBinding of(BuildContext context) {
    final MenuAcceleratorCallbackBinding? result = maybeOf(context);
    assert(() {
      if (result == null) {
        throw FlutterError(
          'MenuAcceleratorWrapper.of() was called with a context that does not '
          'contain a MenuAcceleratorWrapper in the given context.\n'
          'No MenuAcceleratorWrapper ancestor could be found in the context that '
          'was passed to MenuAcceleratorWrapper.of(). This can happen because '
          'you are using a widget that looks for a MenuAcceleratorWrapper '
          'ancestor, and do not have a MenuAcceleratorWrapper widget ancestor.\n'
          'The context used was:\n'
          '  $context',
        );
      }
      return true;
    }());
    return result!;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onInvoke', onInvoke));
    properties.add(DiagnosticsProperty<bool>('hasSubmenu', hasSubmenu));
  }
}

typedef MenuAcceleratorChildBuilder = Widget Function(BuildContext context, String label, int index);

class MenuAcceleratorLabel extends StatefulWidget {
  const MenuAcceleratorLabel(this.label, {super.key, this.builder = defaultLabelBuilder});

  final String label;

  String get displayLabel => stripAcceleratorMarkers(label);

  final MenuAcceleratorChildBuilder builder;

  bool get hasAccelerator => RegExp(r'&(?!([&\s]|$))').hasMatch(label);

  static Widget defaultLabelBuilder(BuildContext context, String label, int index) {
    if (index < 0) {
      return Text(label);
    }
    final TextStyle defaultStyle = DefaultTextStyle.of(context).style;
    final Characters characters = label.characters;
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          if (index > 0) TextSpan(text: characters.getRange(0, index).toString(), style: defaultStyle),
          TextSpan(
            text: characters.getRange(index, index + 1).toString(),
            style: defaultStyle.copyWith(decoration: TextDecoration.underline),
          ),
          if (index < characters.length - 1)
            TextSpan(text: characters.getRange(index + 1).toString(), style: defaultStyle),
        ],
      ),
    );
  }

  static String stripAcceleratorMarkers(String label, {void Function(int index)? setIndex}) {
    int quotedAmpersands = 0;
    final StringBuffer displayLabel = StringBuffer();
    int acceleratorIndex = -1;
    // Use characters so that we don't split up surrogate pairs and interpret
    // them incorrectly.
    final Characters labelChars = label.characters;
    final Characters ampersand = '&'.characters;
    bool lastWasAmpersand = false;
    for (int i = 0; i < labelChars.length; i += 1) {
      // Stop looking one before the end, since a single ampersand at the end is
      // just treated as a quoted ampersand.
      final Characters character = labelChars.characterAt(i);
      if (lastWasAmpersand) {
        lastWasAmpersand = false;
        displayLabel.write(character);
        continue;
      }
      if (character != ampersand) {
        displayLabel.write(character);
        continue;
      }
      if (i == labelChars.length - 1) {
        // Strip bare ampersands at the end of a string.
        break;
      }
      lastWasAmpersand = true;
      final Characters acceleratorCharacter = labelChars.characterAt(i + 1);
      if (acceleratorIndex == -1 &&
          acceleratorCharacter != ampersand &&
          acceleratorCharacter.toString().trim().isNotEmpty) {
        // Don't set the accelerator index if the character is an ampersand,
        // or whitespace.
        acceleratorIndex = i - quotedAmpersands;
      }
      // As we encounter '&<character>' pairs, the following indices must be
      // adjusted so that they correspond with indices in the stripped string.
      quotedAmpersands += 1;
    }
    setIndex?.call(acceleratorIndex);
    return displayLabel.toString();
  }

  @override
  State<MenuAcceleratorLabel> createState() => _MenuAcceleratorLabelState();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) => '$MenuAcceleratorLabel("$label")';

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('label', label));
    properties.add(StringProperty('displayLabel', displayLabel));
    properties.add(ObjectFlagProperty<MenuAcceleratorChildBuilder>.has('builder', builder));
    properties.add(DiagnosticsProperty<bool>('hasAccelerator', hasAccelerator));
  }
}

class _MenuAcceleratorLabelState extends State<MenuAcceleratorLabel> {
  late String _displayLabel;
  int _acceleratorIndex = -1;
  MenuAcceleratorCallbackBinding? _binding;
  MenuController? _menuController;
  ShortcutRegistry? _shortcutRegistry;
  ShortcutRegistryEntry? _shortcutRegistryEntry;
  bool _showAccelerators = false;

  @override
  void initState() {
    super.initState();
    if (_platformSupportsAccelerators) {
      _showAccelerators = _altIsPressed();
      HardwareKeyboard.instance.addHandler(_listenToKeyEvent);
    }
    _updateDisplayLabel();
  }

  @override
  void dispose() {
    assert(_platformSupportsAccelerators || _shortcutRegistryEntry == null);
    _displayLabel = '';
    if (_platformSupportsAccelerators) {
      _shortcutRegistryEntry?.dispose();
      _shortcutRegistryEntry = null;
      _shortcutRegistry = null;
      _menuController = null;
      HardwareKeyboard.instance.removeHandler(_listenToKeyEvent);
    }
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_platformSupportsAccelerators) {
      return;
    }
    _binding = MenuAcceleratorCallbackBinding.maybeOf(context);
    _menuController = MenuController.maybeOf(context);
    _shortcutRegistry = ShortcutRegistry.maybeOf(context);
    _updateAcceleratorShortcut();
  }

  @override
  void didUpdateWidget(MenuAcceleratorLabel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.label != oldWidget.label) {
      _updateDisplayLabel();
    }
  }

  static bool _altIsPressed() =>
      HardwareKeyboard.instance.logicalKeysPressed.intersection(<LogicalKeyboardKey>{
        LogicalKeyboardKey.altLeft,
        LogicalKeyboardKey.altRight,
        LogicalKeyboardKey.alt,
      }).isNotEmpty;

  bool _listenToKeyEvent(KeyEvent event) {
    assert(_platformSupportsAccelerators);
    setState(() {
      _showAccelerators = _altIsPressed();
      _updateAcceleratorShortcut();
    });
    // Just listening, so it doesn't ever handle a key.
    return false;
  }

  void _updateAcceleratorShortcut() {
    assert(_platformSupportsAccelerators);
    _shortcutRegistryEntry?.dispose();
    _shortcutRegistryEntry = null;
    // Before registering an accelerator as a shortcut it should meet these
    // conditions:
    //
    // 1) Is showing accelerators (i.e. Alt key is down).
    // 2) Has an accelerator marker in the label.
    // 3) Has an associated action callback for the label (from the
    //    MenuAcceleratorCallbackBinding).
    // 4) Is part of an anchor that either doesn't have a submenu, or doesn't
    //    have any submenus currently open (only the "deepest" open menu should
    //    have accelerator shortcuts registered).
    if (_showAccelerators &&
        _acceleratorIndex != -1 &&
        _binding?.onInvoke != null &&
        (!_binding!.hasSubmenu || !(_menuController?.isOpen ?? false))) {
      final String acceleratorCharacter = _displayLabel[_acceleratorIndex].toLowerCase();
      _shortcutRegistryEntry = _shortcutRegistry?.addAll(<ShortcutActivator, Intent>{
        CharacterActivator(acceleratorCharacter, alt: true): VoidCallbackIntent(_binding!.onInvoke!),
      });
    }
  }

  void _updateDisplayLabel() {
    _displayLabel = MenuAcceleratorLabel.stripAcceleratorMarkers(
      widget.label,
      setIndex: (index) {
        _acceleratorIndex = index;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final int index = _showAccelerators ? _acceleratorIndex : -1;
    return widget.builder(context, _displayLabel, index);
  }
}

class _MenuItemLabel extends StatelessWidget {
  const _MenuItemLabel({
    required this.hasSubmenu,
    this.showDecoration = true,
    this.leadingIcon,
    this.trailingIcon,
    this.shortcut,
    this.semanticsLabel,
    this.overflowAxis = Axis.vertical,
    this.submenuIcon,
    this.child,
  });

  final bool hasSubmenu;

  final bool showDecoration;

  final Widget? leadingIcon;

  final Widget? trailingIcon;

  final MenuSerializableShortcut? shortcut;

  final String? semanticsLabel;

  final Axis overflowAxis;

  final Widget? submenuIcon;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final VisualDensity density = Theme.of(context).visualDensity;
    final double horizontalPadding = math.max(
      _kLabelItemMinSpacing,
      _kLabelItemDefaultSpacing + density.horizontal * 2,
    );
    Widget leadings;
    if (overflowAxis == Axis.vertical) {
      leadings = Expanded(
        child: ClipRect(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (leadingIcon != null) leadingIcon!,
              if (child != null)
                Expanded(
                  child: ClipRect(
                    child: Padding(
                      padding:
                          leadingIcon != null ? EdgeInsetsDirectional.only(start: horizontalPadding) : EdgeInsets.zero,
                      child: child,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    } else {
      leadings = Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (leadingIcon != null) leadingIcon!,
          if (child != null)
            Padding(
              padding: leadingIcon != null ? EdgeInsetsDirectional.only(start: horizontalPadding) : EdgeInsets.zero,
              child: child,
            ),
        ],
      );
    }

    Widget menuItemLabel = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        leadings,
        if (trailingIcon != null)
          Padding(padding: EdgeInsetsDirectional.only(start: horizontalPadding), child: trailingIcon),
        if (showDecoration && shortcut != null)
          Padding(
            padding: EdgeInsetsDirectional.only(start: horizontalPadding),
            child: Text(
              _LocalizedShortcutLabeler.instance.getShortcutLabel(shortcut!, MaterialLocalizations.of(context)),
            ),
          ),
        if (showDecoration && hasSubmenu)
          Padding(padding: EdgeInsetsDirectional.only(start: horizontalPadding), child: submenuIcon),
      ],
    );
    if (semanticsLabel != null) {
      menuItemLabel = Semantics(label: semanticsLabel, excludeSemantics: true, child: menuItemLabel);
    }
    return menuItemLabel;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<MenuSerializableShortcut>('shortcut', shortcut, defaultValue: null));
    properties.add(DiagnosticsProperty<bool>('hasSubmenu', hasSubmenu));
    properties.add(DiagnosticsProperty<bool>('showDecoration', showDecoration));
    properties.add(StringProperty('semanticsLabel', semanticsLabel));
    properties.add(EnumProperty<Axis>('overflowAxis', overflowAxis));
  }
}

// Positions the menu in the view while trying to keep as much as possible
// visible in the view.
class _MenuLayout extends SingleChildLayoutDelegate {
  const _MenuLayout({
    required this.anchorRect,
    required this.textDirection,
    required this.alignment,
    required this.alignmentOffset,
    required this.menuPosition,
    required this.menuPadding,
    required this.avoidBounds,
    required this.orientation,
    required this.parentOrientation,
  });

  // Rectangle of underlying button, relative to the overlay's dimensions.
  final Rect anchorRect;

  // Whether to prefer going to the left or to the right.
  final TextDirection textDirection;

  // The alignment to use when finding the ideal location for the menu.
  final AlignmentGeometry alignment;

  // The offset from the alignment position to find the ideal location for the
  // menu.
  final Offset alignmentOffset;

  // The position passed to the open method, if any.
  final Offset? menuPosition;

  // The padding on the inside of the menu, so it can be accounted for when
  // positioning.
  final EdgeInsetsGeometry menuPadding;

  // List of rectangles that we should avoid overlapping. Unusable screen area.
  final Set<Rect> avoidBounds;

  // The orientation of this menu.
  final Axis orientation;

  // The orientation of this menu's parent.
  final Axis parentOrientation;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // The menu can be at most the size of the overlay minus _kMenuViewPadding
    // pixels in each direction.
    return BoxConstraints.loose(constraints.biggest).deflate(const EdgeInsets.all(_kMenuViewPadding));
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    // size: The size of the overlay.
    // childSize: The size of the menu, when fully open, as determined by
    // getConstraintsForChild.
    final Rect overlayRect = Offset.zero & size;
    double x;
    double y;
    if (menuPosition == null) {
      Offset desiredPosition = alignment.resolve(textDirection).withinRect(anchorRect);
      final Offset directionalOffset;
      if (alignment is AlignmentDirectional) {
        directionalOffset = switch (textDirection) {
          TextDirection.rtl => Offset(-alignmentOffset.dx, alignmentOffset.dy),
          TextDirection.ltr => alignmentOffset,
        };
      } else {
        directionalOffset = alignmentOffset;
      }
      desiredPosition += directionalOffset;
      x = desiredPosition.dx;
      y = desiredPosition.dy;
      switch (textDirection) {
        case TextDirection.rtl:
          x -= childSize.width;
        case TextDirection.ltr:
          break;
      }
    } else {
      final Offset adjustedPosition = menuPosition! + anchorRect.topLeft;
      x = adjustedPosition.dx;
      y = adjustedPosition.dy;
    }

    final Iterable<Rect> subScreens = DisplayFeatureSubScreen.subScreensInBounds(overlayRect, avoidBounds);
    final Rect allowedRect = _closestScreen(subScreens, anchorRect.center);
    bool offLeftSide(double x) => x < allowedRect.left;
    bool offRightSide(double x) => x + childSize.width > allowedRect.right;
    bool offTop(double y) => y < allowedRect.top;
    bool offBottom(double y) => y + childSize.height > allowedRect.bottom;
    // Avoid going outside an area defined as the rectangle offset from the
    // edge of the screen by the button padding. If the menu is off of the screen,
    // move the menu to the other side of the button first, and then if it
    // doesn't fit there, then just move it over as much as needed to make it
    // fit.
    if (childSize.width >= allowedRect.width) {
      // It just doesn't fit, so put as much on the screen as possible.
      x = allowedRect.left;
    } else {
      if (offLeftSide(x)) {
        // If the parent is a different orientation than the current one, then
        // just push it over instead of trying the other side.
        if (parentOrientation != orientation) {
          x = allowedRect.left;
        } else {
          final double newX = anchorRect.right + alignmentOffset.dx;
          if (!offRightSide(newX)) {
            x = newX;
          } else {
            x = allowedRect.left;
          }
        }
      } else if (offRightSide(x)) {
        if (parentOrientation != orientation) {
          x = allowedRect.right - childSize.width;
        } else {
          final double newX = anchorRect.left - childSize.width - alignmentOffset.dx;
          if (!offLeftSide(newX)) {
            x = newX;
          } else {
            x = allowedRect.right - childSize.width;
          }
        }
      }
    }
    if (childSize.height >= allowedRect.height) {
      // Too tall to fit, fit as much on as possible.
      y = allowedRect.top;
    } else {
      if (offTop(y)) {
        final double newY = anchorRect.bottom;
        if (!offBottom(newY)) {
          y = newY;
        } else {
          y = allowedRect.top;
        }
      } else if (offBottom(y)) {
        final double newY = anchorRect.top - childSize.height;
        if (!offTop(newY)) {
          // Only move the menu up if its parent is horizontal (MenuAnchor/MenuBar).
          if (parentOrientation == Axis.horizontal) {
            y = newY - alignmentOffset.dy;
          } else {
            y = newY;
          }
        } else {
          y = allowedRect.bottom - childSize.height;
        }
      }
    }
    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_MenuLayout oldDelegate) =>
      anchorRect != oldDelegate.anchorRect ||
      textDirection != oldDelegate.textDirection ||
      alignment != oldDelegate.alignment ||
      alignmentOffset != oldDelegate.alignmentOffset ||
      menuPosition != oldDelegate.menuPosition ||
      menuPadding != oldDelegate.menuPadding ||
      orientation != oldDelegate.orientation ||
      parentOrientation != oldDelegate.parentOrientation ||
      !setEquals(avoidBounds, oldDelegate.avoidBounds);

  Rect _closestScreen(Iterable<Rect> screens, Offset point) {
    Rect closest = screens.first;
    for (final Rect screen in screens) {
      if ((screen.center - point).distance < (closest.center - point).distance) {
        closest = screen;
      }
    }
    return closest;
  }
}

class _MenuPanel extends StatefulWidget {
  const _MenuPanel({
    required this.menuStyle,
    required this.orientation,
    required this.children,
    this.clipBehavior = Clip.none,
    this.crossAxisUnconstrained = true,
  });

  final MenuStyle? menuStyle;

  final Clip clipBehavior;

  final bool crossAxisUnconstrained;

  final Axis orientation;

  final List<Widget> children;

  @override
  State<_MenuPanel> createState() => _MenuPanelState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<MenuStyle?>('menuStyle', menuStyle));
    properties.add(EnumProperty<Clip>('clipBehavior', clipBehavior));
    properties.add(DiagnosticsProperty<bool>('crossAxisUnconstrained', crossAxisUnconstrained));
    properties.add(EnumProperty<Axis>('orientation', orientation));
  }
}

class _MenuPanelState extends State<_MenuPanel> {
  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final (MenuStyle? themeStyle, MenuStyle defaultStyle) = switch (widget.orientation) {
      Axis.horizontal => (MenuBarTheme.of(context).style, _MenuBarDefaultsM3(context)),
      Axis.vertical => (MenuTheme.of(context).style, _MenuDefaultsM3(context)),
    };
    final MenuStyle? widgetStyle = widget.menuStyle;

    T? effectiveValue<T>(T? Function(MenuStyle? style) getProperty) =>
        getProperty(widgetStyle) ?? getProperty(themeStyle) ?? getProperty(defaultStyle);

    T? resolve<T>(WidgetStateProperty<T>? Function(MenuStyle? style) getProperty) =>
        effectiveValue((style) => getProperty(style)?.resolve(<WidgetState>{}));

    final Color? backgroundColor = resolve<Color?>((style) => style?.backgroundColor);
    final Color? shadowColor = resolve<Color?>((style) => style?.shadowColor);
    final Color? surfaceTintColor = resolve<Color?>((style) => style?.surfaceTintColor);
    final double elevation = resolve<double?>((style) => style?.elevation) ?? 0;
    final Size? minimumSize = resolve<Size?>((style) => style?.minimumSize);
    final Size? fixedSize = resolve<Size?>((style) => style?.fixedSize);
    final Size? maximumSize = resolve<Size?>((style) => style?.maximumSize);
    final BorderSide? side = resolve<BorderSide?>((style) => style?.side);
    final OutlinedBorder shape = resolve<OutlinedBorder?>((style) => style?.shape)!.copyWith(side: side);
    final VisualDensity visualDensity = effectiveValue((style) => style?.visualDensity) ?? VisualDensity.standard;
    final EdgeInsetsGeometry padding = resolve<EdgeInsetsGeometry?>((style) => style?.padding) ?? EdgeInsets.zero;
    final Offset densityAdjustment = visualDensity.baseSizeAdjustment;
    // Per the Material Design team: don't allow the VisualDensity
    // adjustment to reduce the width of the left/right padding. If we
    // did, VisualDensity.compact, the default for desktop/web, would
    // reduce the horizontal padding to zero.
    final double dy = densityAdjustment.dy;
    final double dx = math.max(0, densityAdjustment.dx);
    final EdgeInsetsGeometry resolvedPadding = padding
        .add(EdgeInsets.symmetric(horizontal: dx, vertical: dy))
        .clamp(EdgeInsets.zero, EdgeInsetsGeometry.infinity);

    BoxConstraints effectiveConstraints = visualDensity.effectiveConstraints(
      BoxConstraints(
        minWidth: minimumSize?.width ?? 0,
        minHeight: minimumSize?.height ?? 0,
        maxWidth: maximumSize?.width ?? double.infinity,
        maxHeight: maximumSize?.height ?? double.infinity,
      ),
    );
    if (fixedSize != null) {
      final Size size = effectiveConstraints.constrain(fixedSize);
      if (size.width.isFinite) {
        effectiveConstraints = effectiveConstraints.copyWith(minWidth: size.width, maxWidth: size.width);
      }
      if (size.height.isFinite) {
        effectiveConstraints = effectiveConstraints.copyWith(minHeight: size.height, maxHeight: size.height);
      }
    }

    // If the menu panel is horizontal, then the children should be wrapped in
    // an IntrinsicWidth widget to ensure that the children are as wide as the
    // widest child.
    List<Widget> children = widget.children;
    if (widget.orientation == Axis.horizontal) {
      children = children.map<Widget>((child) => IntrinsicWidth(child: child)).toList();
    }

    Widget menuPanel = _intrinsicCrossSize(
      child: Material(
        elevation: elevation,
        shape: shape,
        color: backgroundColor,
        shadowColor: shadowColor,
        surfaceTintColor: surfaceTintColor,
        type: backgroundColor == null ? MaterialType.transparency : MaterialType.canvas,
        clipBehavior: widget.clipBehavior,
        child: Padding(
          padding: resolvedPadding,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(scrollbars: false, overscroll: false, physics: const ClampingScrollPhysics()),
            child: PrimaryScrollController(
              controller: scrollController,
              child: Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: scrollController,
                  scrollDirection: widget.orientation,
                  child: Flex(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    textDirection: Directionality.of(context),
                    direction: widget.orientation,
                    mainAxisSize: MainAxisSize.min,
                    children: children,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.crossAxisUnconstrained) {
      menuPanel = UnconstrainedBox(
        constrainedAxis: widget.orientation,
        clipBehavior: Clip.hardEdge,
        alignment: AlignmentDirectional.centerStart,
        child: menuPanel,
      );
    }

    return ConstrainedBox(constraints: effectiveConstraints, child: menuPanel);
  }

  Widget _intrinsicCrossSize({required Widget child}) => switch (widget.orientation) {
    Axis.horizontal => IntrinsicHeight(child: child),
    Axis.vertical => IntrinsicWidth(child: child),
  };

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ScrollController>('scrollController', scrollController));
  }
}

// A widget that defines the menu drawn in the overlay.
class _Submenu extends StatelessWidget {
  const _Submenu({
    required this.anchor,
    required this.layerLink,
    required this.menuStyle,
    required this.menuPosition,
    required this.alignmentOffset,
    required this.consumeOutsideTaps,
    required this.clipBehavior,
    required this.menuChildren,
    required this.menuScopeNode,
    this.crossAxisUnconstrained = true,
  });

  final FocusScopeNode menuScopeNode;
  final RawMenuOverlayInfo menuPosition;
  final _MenuAnchorState anchor;
  final LayerLink? layerLink;
  final MenuStyle? menuStyle;
  final bool consumeOutsideTaps;
  final Offset alignmentOffset;
  final Clip clipBehavior;
  final bool crossAxisUnconstrained;
  final List<Widget> menuChildren;

  @override
  Widget build(BuildContext context) {
    // Use the text direction of the context where the button is.
    final TextDirection textDirection = Directionality.of(context);
    final (MenuStyle? themeStyle, MenuStyle defaultStyle) = switch (anchor._parent?._orientation) {
      Axis.horizontal || null => (MenuBarTheme.of(context).style, _MenuBarDefaultsM3(context)),
      Axis.vertical => (MenuTheme.of(context).style, _MenuDefaultsM3(context)),
    };
    T? effectiveValue<T>(T? Function(MenuStyle? style) getProperty) =>
        getProperty(menuStyle) ?? getProperty(themeStyle) ?? getProperty(defaultStyle);

    T? resolve<T>(WidgetStateProperty<T>? Function(MenuStyle? style) getProperty) =>
        effectiveValue((style) => getProperty(style)?.resolve(<WidgetState>{}));

    final WidgetStateMouseCursor mouseCursor = _MouseCursor(
      (states) => effectiveValue((style) => style?.mouseCursor?.resolve(states)),
    );

    final VisualDensity visualDensity =
        effectiveValue((style) => style?.visualDensity) ?? Theme.of(context).visualDensity;
    final AlignmentGeometry alignment = effectiveValue((style) => style?.alignment)!;
    final EdgeInsetsGeometry padding = resolve<EdgeInsetsGeometry?>((style) => style?.padding) ?? EdgeInsets.zero;
    final Offset densityAdjustment = visualDensity.baseSizeAdjustment;
    // Per the Material Design team: don't allow the VisualDensity
    // adjustment to reduce the width of the left/right padding. If we
    // did, VisualDensity.compact, the default for desktop/web, would
    // reduce the horizontal padding to zero.
    final double dy = densityAdjustment.dy;
    final double dx = math.max(0, densityAdjustment.dx);
    final EdgeInsetsGeometry resolvedPadding = padding
        .add(EdgeInsets.fromLTRB(dx, dy, dx, dy))
        .clamp(EdgeInsets.zero, EdgeInsetsGeometry.infinity);

    final Rect anchorRect =
        layerLink == null
            ? Rect.fromLTRB(
              menuPosition.anchorRect.left + dx,
              menuPosition.anchorRect.top - dy,
              menuPosition.anchorRect.right,
              menuPosition.anchorRect.bottom,
            )
            : Rect.zero;

    final Widget menuPanel = TapRegion(
      groupId: menuPosition.tapRegionGroupId,
      consumeOutsideTaps: anchor._root._menuController.isOpen && anchor.widget.consumeOutsideTap,
      onTapOutside: (event) {
        anchor._menuController.close();
      },
      child: MouseRegion(
        cursor: mouseCursor,
        hitTestBehavior: HitTestBehavior.deferToChild,
        child: FocusScope(
          node: anchor._menuScopeNode,
          skipTraversal: true,
          child: Actions(
            actions: <Type, Action<Intent>>{DismissIntent: DismissMenuAction(controller: anchor._menuController)},
            child: Shortcuts(
              shortcuts: _kMenuTraversalShortcuts,
              child: _MenuPanel(
                menuStyle: menuStyle,
                clipBehavior: clipBehavior,
                orientation: anchor._orientation,
                crossAxisUnconstrained: crossAxisUnconstrained,
                children: menuChildren,
              ),
            ),
          ),
        ),
      ),
    );

    final Widget layout = Theme(
      data: Theme.of(context).copyWith(visualDensity: visualDensity),
      child: ConstrainedBox(
        constraints: BoxConstraints.loose(menuPosition.overlaySize),
        child: Builder(
          builder: (context) {
            final MediaQueryData mediaQuery = MediaQuery.of(context);
            return CustomSingleChildLayout(
              delegate: _MenuLayout(
                anchorRect: anchorRect,
                textDirection: textDirection,
                avoidBounds: DisplayFeatureSubScreen.avoidBounds(mediaQuery).toSet(),
                menuPadding: resolvedPadding,
                alignment: alignment,
                alignmentOffset: alignmentOffset,
                menuPosition: menuPosition.position,
                orientation: anchor._orientation,
                parentOrientation: anchor._parent?._orientation ?? Axis.horizontal,
              ),
              child: menuPanel,
            );
          },
        ),
      ),
    );

    if (layerLink == null) {
      return layout;
    }

    return CompositedTransformFollower(link: layerLink!, targetAnchor: Alignment.bottomLeft, child: layout);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<FocusScopeNode>('menuScopeNode', menuScopeNode));
    properties.add(DiagnosticsProperty<RawMenuOverlayInfo>('menuPosition', menuPosition));
    properties.add(DiagnosticsProperty<_MenuAnchorState>('anchor', anchor));
    properties.add(DiagnosticsProperty<LayerLink?>('layerLink', layerLink));
    properties.add(DiagnosticsProperty<MenuStyle?>('menuStyle', menuStyle));
    properties.add(DiagnosticsProperty<bool>('consumeOutsideTaps', consumeOutsideTaps));
    properties.add(DiagnosticsProperty<Offset>('alignmentOffset', alignmentOffset));
    properties.add(EnumProperty<Clip>('clipBehavior', clipBehavior));
    properties.add(DiagnosticsProperty<bool>('crossAxisUnconstrained', crossAxisUnconstrained));
  }
}

class _MouseCursor extends WidgetStateMouseCursor {
  const _MouseCursor(this.resolveCallback);

  final WidgetPropertyResolver<MouseCursor?> resolveCallback;

  @override
  MouseCursor resolve(Set<WidgetState> states) => resolveCallback(states) ?? MouseCursor.uncontrolled;

  @override
  String get debugDescription => 'Menu_MouseCursor';

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<WidgetPropertyResolver<MouseCursor?>>.has('resolveCallback', resolveCallback));
  }
}

bool _debugMenuInfo(String message, [Iterable<String>? details]) {
  assert(() {
    if (_kDebugMenus) {
      debugPrint('MENU: $message');
      if (details != null && details.isNotEmpty) {
        for (final String detail in details) {
          debugPrint('    $detail');
        }
      }
    }
    return true;
  }());
  // Return true so that it can be easily used inside of an assert.
  return true;
}

bool get _isCupertino {
  switch (defaultTargetPlatform) {
    case TargetPlatform.iOS:
    case TargetPlatform.macOS:
      return true;
    case TargetPlatform.android:
    case TargetPlatform.fuchsia:
    case TargetPlatform.linux:
    case TargetPlatform.windows:
      return false;
  }
}

bool get _usesSymbolicModifiers => _isCupertino;

bool get _platformSupportsAccelerators {
  // On iOS and macOS, pressing the Option key (a.k.a. the Alt key) causes a
  // different set of characters to be generated, and the native menus don't
  // support accelerators anyhow, so we just disable accelerators on these
  // platforms.
  return !_isCupertino;
}

// BEGIN GENERATED TOKEN PROPERTIES - Menu

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// dart format off
class _MenuBarDefaultsM3 extends MenuStyle {
  _MenuBarDefaultsM3(this.context)
    : super(
      elevation: const WidgetStatePropertyAll<double?>(3.0),
      shape: const WidgetStatePropertyAll<OutlinedBorder>(_defaultMenuBorder),
      alignment: AlignmentDirectional.bottomStart,
    );

  static const RoundedRectangleBorder _defaultMenuBorder =
    RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)));

  final BuildContext context;

  late final ColorScheme _colors = Theme.of(context).colorScheme;

  @override
  WidgetStateProperty<Color?> get backgroundColor => WidgetStatePropertyAll<Color?>(_colors.surfaceContainer);

  @override
  WidgetStateProperty<Color?>? get shadowColor => WidgetStatePropertyAll<Color?>(_colors.shadow);

  @override
  WidgetStateProperty<Color?>? get surfaceTintColor => const WidgetStatePropertyAll<Color?>(Colors.transparent);

  @override
  WidgetStateProperty<EdgeInsetsGeometry?>? get padding => const WidgetStatePropertyAll<EdgeInsetsGeometry>(
      EdgeInsetsDirectional.symmetric(
        horizontal: _kTopLevelMenuHorizontalMinPadding
      ),
    );

  @override
  VisualDensity get visualDensity => Theme.of(context).visualDensity;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BuildContext>('context', context));
  }
}

class _MenuButtonDefaultsM3 extends ButtonStyle {
  _MenuButtonDefaultsM3(this.context)
    : super(
      animationDuration: kThemeChangeDuration,
      enableFeedback: true,
      alignment: AlignmentDirectional.centerStart,
    );

  final BuildContext context;

  late final ColorScheme _colors = Theme.of(context).colorScheme;
  late final TextTheme _textTheme = Theme.of(context).textTheme;

  @override
  WidgetStateProperty<Color?>? get backgroundColor => ButtonStyleButton.allOrNull<Color>(Colors.transparent);

  // No default shadow color

  // No default surface tint color

  @override
  WidgetStateProperty<double>? get elevation => ButtonStyleButton.allOrNull<double>(0.0);

  @override
  WidgetStateProperty<Color?>? get foregroundColor => WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return _colors.onSurface.withOpacity(0.38);
      }
      if (states.contains(WidgetState.pressed)) {
        return _colors.onSurface;
      }
      if (states.contains(WidgetState.hovered)) {
        return _colors.onSurface;
      }
      if (states.contains(WidgetState.focused)) {
        return _colors.onSurface;
      }
      return _colors.onSurface;
    });

  @override
  WidgetStateProperty<Color?>? get iconColor => WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return _colors.onSurface.withOpacity(0.38);
      }
      if (states.contains(WidgetState.pressed)) {
        return _colors.onSurfaceVariant;
      }
      if (states.contains(WidgetState.hovered)) {
        return _colors.onSurfaceVariant;
      }
      if (states.contains(WidgetState.focused)) {
        return _colors.onSurfaceVariant;
      }
      return _colors.onSurfaceVariant;
    });

  // No default fixedSize

  @override
  WidgetStateProperty<double>? get iconSize => const WidgetStatePropertyAll<double>(24.0);

  @override
  WidgetStateProperty<Size>? get maximumSize => ButtonStyleButton.allOrNull<Size>(Size.infinite);

  @override
  WidgetStateProperty<Size>? get minimumSize => ButtonStyleButton.allOrNull<Size>(const Size(64.0, 48.0));

  @override
  WidgetStateProperty<MouseCursor?>? get mouseCursor => WidgetStateProperty.resolveWith(
      (states) {
        if (states.contains(WidgetState.disabled)) {
          return SystemMouseCursors.basic;
        }
        return SystemMouseCursors.click;
      },
    );

  @override
  WidgetStateProperty<Color?>? get overlayColor => WidgetStateProperty.resolveWith(
      (states) {
        if (states.contains(WidgetState.pressed)) {
          return _colors.onSurface.withOpacity(0.1);
        }
        if (states.contains(WidgetState.hovered)) {
          return _colors.onSurface.withOpacity(0.08);
        }
        if (states.contains(WidgetState.focused)) {
          return _colors.onSurface.withOpacity(0.1);
        }
        return Colors.transparent;
      },
    );

  @override
  WidgetStateProperty<EdgeInsetsGeometry>? get padding => ButtonStyleButton.allOrNull<EdgeInsetsGeometry>(_scaledPadding(context));

  // No default side

  @override
  WidgetStateProperty<OutlinedBorder>? get shape => ButtonStyleButton.allOrNull<OutlinedBorder>(const RoundedRectangleBorder());

  @override
  InteractiveInkFeatureFactory? get splashFactory => Theme.of(context).splashFactory;

  @override
  MaterialTapTargetSize? get tapTargetSize => Theme.of(context).materialTapTargetSize;

  @override
  WidgetStateProperty<TextStyle?> get textStyle {
    // TODO(tahatesser): This is taken from https://m3.material.io/components/menus/specs
    // Update this when the token is available.
    return WidgetStatePropertyAll<TextStyle?>(_textTheme.labelLarge);
  }

  @override
  VisualDensity? get visualDensity => Theme.of(context).visualDensity;

  // The horizontal padding number comes from the spec.
  EdgeInsetsGeometry _scaledPadding(BuildContext context) {
    VisualDensity visualDensity = Theme.of(context).visualDensity;
    // When horizontal VisualDensity is greater than zero, set it to zero
    // because the [ButtonStyleButton] has already handle the padding based on the density.
    // However, the [ButtonStyleButton] doesn't allow the [VisualDensity] adjustment
    // to reduce the width of the left/right padding, so we need to handle it here if
    // the density is less than zero, such as on desktop platforms.
    if (visualDensity.horizontal > 0) {
      visualDensity = VisualDensity(vertical: visualDensity.vertical);
    }
    // Since the threshold paddings used below are empirical values determined
    // at a font size of 14.0, 14.0 is used as the base value for scaling the
    // padding.
    final double fontSize = Theme.of(context).textTheme.labelLarge?.fontSize ?? 14.0;
    final double fontSizeRatio = MediaQuery.textScalerOf(context).scale(fontSize) / 14.0;
    return ButtonStyleButton.scaledPadding(
      EdgeInsets.symmetric(horizontal: math.max(
        _kMenuViewPadding,
        _kLabelItemDefaultSpacing + visualDensity.baseSizeAdjustment.dx,
      )),
      EdgeInsets.symmetric(horizontal: math.max(
        _kMenuViewPadding,
        8 + visualDensity.baseSizeAdjustment.dx,
      )),
      const EdgeInsets.symmetric(horizontal: _kMenuViewPadding),
      fontSizeRatio,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BuildContext>('context', context));
  }
}

class _MenuDefaultsM3 extends MenuStyle {
  _MenuDefaultsM3(this.context)
    : super(
      elevation: const WidgetStatePropertyAll<double?>(3.0),
      shape: const WidgetStatePropertyAll<OutlinedBorder>(_defaultMenuBorder),
      alignment: AlignmentDirectional.topEnd,
    );

  static const RoundedRectangleBorder _defaultMenuBorder =
    RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)));

  final BuildContext context;

  late final ColorScheme _colors = Theme.of(context).colorScheme;

  @override
  WidgetStateProperty<Color?> get backgroundColor => WidgetStatePropertyAll<Color?>(_colors.surfaceContainer);

  @override
  WidgetStateProperty<Color?>? get surfaceTintColor => const WidgetStatePropertyAll<Color?>(Colors.transparent);

  @override
  WidgetStateProperty<Color?>? get shadowColor => WidgetStatePropertyAll<Color?>(_colors.shadow);

  @override
  WidgetStateProperty<EdgeInsetsGeometry?>? get padding => const WidgetStatePropertyAll<EdgeInsetsGeometry>(
      EdgeInsetsDirectional.symmetric(vertical: _kMenuVerticalMinPadding),
    );

  @override
  VisualDensity get visualDensity => Theme.of(context).visualDensity;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BuildContext>('context', context));
  }
}
// dart format on

// END GENERATED TOKEN PROPERTIES - Menu
