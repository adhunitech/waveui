// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/button_style.dart';
import 'package:waveui/material/dropdown_menu_theme.dart';
import 'package:waveui/material/icon_button.dart';
import 'package:waveui/material/icons.dart';
import 'package:waveui/material/input_border.dart';
import 'package:waveui/material/input_decorator.dart';
import 'package:waveui/material/menu_anchor.dart';
import 'package:waveui/material/menu_button_theme.dart';
import 'package:waveui/material/menu_style.dart';
import 'package:waveui/material/text_field.dart';
import 'package:waveui/material/theme.dart';
import 'package:waveui/material/theme_data.dart';

// Examples can assume:
// late BuildContext context;
// late FocusNode myFocusNode;

typedef FilterCallback<T> = List<DropdownMenuEntry<T>> Function(List<DropdownMenuEntry<T>> entries, String filter);

typedef SearchCallback<T> = int? Function(List<DropdownMenuEntry<T>> entries, String query);

const double _kMinimumWidth = 112.0;

const double _kDefaultHorizontalPadding = 12.0;

const double _kLeadingIconToInputPadding = 4.0;

class DropdownMenuEntry<T> {
  const DropdownMenuEntry({
    required this.value,
    required this.label,
    this.labelWidget,
    this.leadingIcon,
    this.trailingIcon,
    this.enabled = true,
    this.style,
  });

  final T value;

  final String label;

  final Widget? labelWidget;

  final Widget? leadingIcon;

  final Widget? trailingIcon;

  final bool enabled;

  final ButtonStyle? style;
}

enum DropdownMenuCloseBehavior { all, self, none }

class DropdownMenu<T> extends StatefulWidget {
  const DropdownMenu({
    required this.dropdownMenuEntries,
    super.key,
    this.enabled = true,
    this.width,
    this.menuHeight,
    this.leadingIcon,
    this.trailingIcon,
    this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.selectedTrailingIcon,
    this.enableFilter = false,
    this.enableSearch = true,
    this.keyboardType,
    this.textStyle,
    this.textAlign = TextAlign.start,
    this.inputDecorationTheme,
    this.menuStyle,
    this.controller,
    this.initialSelection,
    this.onSelected,
    this.focusNode,
    this.requestFocusOnTap,
    this.expandedInsets,
    this.filterCallback,
    this.searchCallback,
    this.alignmentOffset,
    this.inputFormatters,
    this.closeBehavior = DropdownMenuCloseBehavior.all,
    this.maxLines = 1,
    this.textInputAction,
  }) : assert(filterCallback == null || enableFilter);

  final bool enabled;

  final double? width;

  final double? menuHeight;

  final Widget? leadingIcon;

  final Widget? trailingIcon;

  final Widget? label;

  final String? hintText;

  final String? helperText;

  final String? errorText;

  final Widget? selectedTrailingIcon;

  final bool enableFilter;

  final bool enableSearch;

  final TextInputType? keyboardType;

  final TextStyle? textStyle;

  final TextAlign textAlign;

  final InputDecorationTheme? inputDecorationTheme;

  final MenuStyle? menuStyle;

  final TextEditingController? controller;

  final T? initialSelection;

  final ValueChanged<T?>? onSelected;

  final FocusNode? focusNode;

  final bool? requestFocusOnTap;

  final List<DropdownMenuEntry<T>> dropdownMenuEntries;

  final EdgeInsetsGeometry? expandedInsets;

  final FilterCallback<T>? filterCallback;

  final SearchCallback<T>? searchCallback;

  final List<TextInputFormatter>? inputFormatters;

  final Offset? alignmentOffset;

  final DropdownMenuCloseBehavior closeBehavior;

  final int? maxLines;

  final TextInputAction? textInputAction;

  @override
  State<DropdownMenu<T>> createState() => _DropdownMenuState<T>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('enabled', enabled));
    properties.add(DoubleProperty('width', width));
    properties.add(DoubleProperty('menuHeight', menuHeight));
    properties.add(StringProperty('hintText', hintText));
    properties.add(StringProperty('helperText', helperText));
    properties.add(StringProperty('errorText', errorText));
    properties.add(DiagnosticsProperty<bool>('enableFilter', enableFilter));
    properties.add(DiagnosticsProperty<bool>('enableSearch', enableSearch));
    properties.add(DiagnosticsProperty<TextInputType?>('keyboardType', keyboardType));
    properties.add(DiagnosticsProperty<TextStyle?>('textStyle', textStyle));
    properties.add(EnumProperty<TextAlign>('textAlign', textAlign));
    properties.add(DiagnosticsProperty<InputDecorationTheme?>('inputDecorationTheme', inputDecorationTheme));
    properties.add(DiagnosticsProperty<MenuStyle?>('menuStyle', menuStyle));
    properties.add(DiagnosticsProperty<TextEditingController?>('controller', controller));
    properties.add(DiagnosticsProperty<T?>('initialSelection', initialSelection));
    properties.add(ObjectFlagProperty<ValueChanged<T?>?>.has('onSelected', onSelected));
    properties.add(DiagnosticsProperty<FocusNode?>('focusNode', focusNode));
    properties.add(DiagnosticsProperty<bool?>('requestFocusOnTap', requestFocusOnTap));
    properties.add(IterableProperty<DropdownMenuEntry<T>>('dropdownMenuEntries', dropdownMenuEntries));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('expandedInsets', expandedInsets));
    properties.add(ObjectFlagProperty<FilterCallback<T>?>.has('filterCallback', filterCallback));
    properties.add(ObjectFlagProperty<SearchCallback<T>?>.has('searchCallback', searchCallback));
    properties.add(IterableProperty<TextInputFormatter>('inputFormatters', inputFormatters));
    properties.add(DiagnosticsProperty<Offset?>('alignmentOffset', alignmentOffset));
    properties.add(EnumProperty<DropdownMenuCloseBehavior>('closeBehavior', closeBehavior));
    properties.add(IntProperty('maxLines', maxLines));
    properties.add(EnumProperty<TextInputAction?>('textInputAction', textInputAction));
  }
}

class _DropdownMenuState<T> extends State<DropdownMenu<T>> {
  final GlobalKey _anchorKey = GlobalKey();
  final GlobalKey _leadingKey = GlobalKey();
  late List<GlobalKey> buttonItemKeys;
  final MenuController _controller = MenuController();
  bool _enableFilter = false;
  late bool _enableSearch;
  late List<DropdownMenuEntry<T>> filteredEntries;
  List<Widget>? _initialMenu;
  int? currentHighlight;
  double? leadingPadding;
  bool _menuHasEnabledItem = false;
  TextEditingController? _localTextEditingController;
  final FocusNode _internalFocudeNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _localTextEditingController = widget.controller;
    } else {
      _localTextEditingController = TextEditingController();
    }
    _enableSearch = widget.enableSearch;
    filteredEntries = widget.dropdownMenuEntries;
    buttonItemKeys = List<GlobalKey>.generate(filteredEntries.length, (index) => GlobalKey());
    _menuHasEnabledItem = filteredEntries.any((entry) => entry.enabled);
    final int index = filteredEntries.indexWhere((entry) => entry.value == widget.initialSelection);
    if (index != -1) {
      _localTextEditingController?.value = TextEditingValue(
        text: filteredEntries[index].label,
        selection: TextSelection.collapsed(offset: filteredEntries[index].label.length),
      );
    }
    refreshLeadingPadding();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _localTextEditingController?.dispose();
      _localTextEditingController = null;
    }
    _internalFocudeNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(DropdownMenu<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      if (widget.controller != null) {
        _localTextEditingController?.dispose();
      }
      _localTextEditingController = widget.controller ?? TextEditingController();
    }
    if (oldWidget.enableFilter != widget.enableFilter) {
      if (!widget.enableFilter) {
        _enableFilter = false;
      }
    }
    if (oldWidget.enableSearch != widget.enableSearch) {
      if (!widget.enableSearch) {
        _enableSearch = widget.enableSearch;
        currentHighlight = null;
      }
    }
    if (oldWidget.dropdownMenuEntries != widget.dropdownMenuEntries) {
      currentHighlight = null;
      filteredEntries = widget.dropdownMenuEntries;
      buttonItemKeys = List<GlobalKey>.generate(filteredEntries.length, (index) => GlobalKey());
      _menuHasEnabledItem = filteredEntries.any((entry) => entry.enabled);
    }
    if (oldWidget.leadingIcon != widget.leadingIcon) {
      refreshLeadingPadding();
    }
    if (oldWidget.initialSelection != widget.initialSelection) {
      final int index = filteredEntries.indexWhere((entry) => entry.value == widget.initialSelection);
      if (index != -1) {
        _localTextEditingController?.value = TextEditingValue(
          text: filteredEntries[index].label,
          selection: TextSelection.collapsed(offset: filteredEntries[index].label.length),
        );
      }
    }
  }

  bool canRequestFocus() =>
      widget.focusNode?.canRequestFocus ??
      widget.requestFocusOnTap ??
      switch (Theme.of(context).platform) {
        TargetPlatform.iOS || TargetPlatform.android || TargetPlatform.fuchsia => false,
        TargetPlatform.macOS || TargetPlatform.linux || TargetPlatform.windows => true,
      };

  void refreshLeadingPadding() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        final double? leadingWidgetWidth = getWidth(_leadingKey);
        if (leadingWidgetWidth != null) {
          leadingPadding = leadingWidgetWidth + _kLeadingIconToInputPadding;
        } else {
          leadingPadding = leadingWidgetWidth;
        }
      });
    }, debugLabel: 'DropdownMenu.refreshLeadingPadding');
  }

  void scrollToHighlight() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final BuildContext? highlightContext = buttonItemKeys[currentHighlight!].currentContext;
      if (highlightContext != null) {
        Scrollable.of(highlightContext).position.ensureVisible(highlightContext.findRenderObject()!);
      }
    }, debugLabel: 'DropdownMenu.scrollToHighlight');
  }

  double? getWidth(GlobalKey key) {
    final BuildContext? context = key.currentContext;
    if (context != null) {
      final RenderBox box = context.findRenderObject()! as RenderBox;
      return box.hasSize ? box.size.width : null;
    }
    return null;
  }

  List<DropdownMenuEntry<T>> filter(List<DropdownMenuEntry<T>> entries, TextEditingController textEditingController) {
    final String filterText = textEditingController.text.toLowerCase();
    return entries.where((entry) => entry.label.toLowerCase().contains(filterText)).toList();
  }

  bool _shouldUpdateCurrentHighlight(List<DropdownMenuEntry<T>> entries) {
    final String searchText = _localTextEditingController!.value.text.toLowerCase();
    if (searchText.isEmpty) {
      return true;
    }

    // When `entries` are filtered by filter algorithm, currentHighlight may exceed the valid range of `entries` and should be updated.
    if (currentHighlight == null || currentHighlight! >= entries.length) {
      return true;
    }

    if (entries[currentHighlight!].label.toLowerCase().contains(searchText)) {
      return false;
    }

    return true;
  }

  int? search(List<DropdownMenuEntry<T>> entries, TextEditingController textEditingController) {
    final String searchText = textEditingController.value.text.toLowerCase();
    if (searchText.isEmpty) {
      return null;
    }

    final int index = entries.indexWhere((entry) => entry.label.toLowerCase().contains(searchText));

    return index != -1 ? index : null;
  }

  List<Widget> _buildButtons(
    List<DropdownMenuEntry<T>> filteredEntries,
    TextDirection textDirection, {
    int? focusedIndex,
    bool enableScrollToHighlight = true,
    bool excludeSemantics = false,
  }) {
    final List<Widget> result = <Widget>[];
    for (int i = 0; i < filteredEntries.length; i++) {
      final DropdownMenuEntry<T> entry = filteredEntries[i];

      // By default, when the text field has a leading icon but a menu entry doesn't
      // have one, the label of the entry should have extra padding to be aligned
      // with the text in the text input field. When both the text field and the
      // menu entry have leading icons, the menu entry should remove the extra
      // paddings so its leading icon will be aligned with the leading icon of
      // the text field.
      final double padding =
          entry.leadingIcon == null ? (leadingPadding ?? _kDefaultHorizontalPadding) : _kDefaultHorizontalPadding;
      ButtonStyle effectiveStyle =
          entry.style ??
          switch (textDirection) {
            TextDirection.rtl => MenuItemButton.styleFrom(
              padding: EdgeInsets.only(left: _kDefaultHorizontalPadding, right: padding),
            ),
            TextDirection.ltr => MenuItemButton.styleFrom(
              padding: EdgeInsets.only(left: padding, right: _kDefaultHorizontalPadding),
            ),
          };

      final ButtonStyle? themeStyle = MenuButtonTheme.of(context).style;

      final WidgetStateProperty<Color?>? effectiveForegroundColor =
          entry.style?.foregroundColor ?? themeStyle?.foregroundColor;
      final WidgetStateProperty<Color?>? effectiveIconColor = entry.style?.iconColor ?? themeStyle?.iconColor;
      final WidgetStateProperty<Color?>? effectiveOverlayColor = entry.style?.overlayColor ?? themeStyle?.overlayColor;
      final WidgetStateProperty<Color?>? effectiveBackgroundColor =
          entry.style?.backgroundColor ?? themeStyle?.backgroundColor;

      // Simulate the focused state because the text field should always be focused
      // during traversal. Include potential MenuItemButton theme in the focus
      // simulation for all colors in the theme.
      if (entry.enabled && i == focusedIndex) {
        // Query the Material 3 default style.
        // TODO(bleroux): replace once a standard way for accessing defaults will be defined.
        // See: https://github.com/flutter/flutter/issues/130135.
        final ButtonStyle defaultStyle = const MenuItemButton().defaultStyleOf(context);

        Color? resolveFocusedColor(WidgetStateProperty<Color?>? colorStateProperty) =>
            colorStateProperty?.resolve(<WidgetState>{WidgetState.focused});

        final Color focusedForegroundColor =
            resolveFocusedColor(effectiveForegroundColor ?? defaultStyle.foregroundColor!)!;
        final Color focusedIconColor = resolveFocusedColor(effectiveIconColor ?? defaultStyle.iconColor!)!;
        final Color focusedOverlayColor = resolveFocusedColor(effectiveOverlayColor ?? defaultStyle.overlayColor!)!;
        // For the background color we can't rely on the default style which is transparent.
        // Defaults to onSurface.withOpacity(0.12).
        final Color focusedBackgroundColor =
            resolveFocusedColor(effectiveBackgroundColor) ?? Theme.of(context).colorScheme.onSurface.withOpacity(0.12);

        effectiveStyle = effectiveStyle.copyWith(
          backgroundColor: WidgetStatePropertyAll<Color>(focusedBackgroundColor),
          foregroundColor: WidgetStatePropertyAll<Color>(focusedForegroundColor),
          iconColor: WidgetStatePropertyAll<Color>(focusedIconColor),
          overlayColor: WidgetStatePropertyAll<Color>(focusedOverlayColor),
        );
      } else {
        effectiveStyle = effectiveStyle.copyWith(
          backgroundColor: effectiveBackgroundColor,
          foregroundColor: effectiveForegroundColor,
          iconColor: effectiveIconColor,
          overlayColor: effectiveOverlayColor,
        );
      }

      Widget label = entry.labelWidget ?? Text(entry.label);
      if (widget.width != null) {
        final double horizontalPadding = padding + _kDefaultHorizontalPadding;
        label = ConstrainedBox(constraints: BoxConstraints(maxWidth: widget.width! - horizontalPadding), child: label);
      }

      final Widget menuItemButton = ExcludeSemantics(
        excluding: excludeSemantics,
        child: MenuItemButton(
          key: enableScrollToHighlight ? buttonItemKeys[i] : null,
          style: effectiveStyle,
          leadingIcon:
              entry.leadingIcon != null
                  ? Padding(
                    padding: const EdgeInsetsDirectional.only(end: _kLeadingIconToInputPadding),
                    child: entry.leadingIcon,
                  )
                  : null,
          trailingIcon: entry.trailingIcon,
          closeOnActivate: widget.closeBehavior == DropdownMenuCloseBehavior.all,
          onPressed:
              entry.enabled && widget.enabled
                  ? () {
                    _localTextEditingController?.value = TextEditingValue(
                      text: entry.label,
                      selection: TextSelection.collapsed(offset: entry.label.length),
                    );
                    currentHighlight = widget.enableSearch ? i : null;
                    widget.onSelected?.call(entry.value);
                    _enableFilter = false;
                    if (widget.closeBehavior == DropdownMenuCloseBehavior.self) {
                      _controller.close();
                    }
                  }
                  : null,
          requestFocusOnHover: false,
          child: label,
        ),
      );
      result.add(menuItemButton);
    }

    return result;
  }

  void handleUpKeyInvoke(_ArrowUpIntent _) {
    setState(() {
      if (!widget.enabled || !_menuHasEnabledItem || !_controller.isOpen) {
        return;
      }
      _enableFilter = false;
      _enableSearch = false;
      currentHighlight ??= 0;
      currentHighlight = (currentHighlight! - 1) % filteredEntries.length;
      while (!filteredEntries[currentHighlight!].enabled) {
        currentHighlight = (currentHighlight! - 1) % filteredEntries.length;
      }
      final String currentLabel = filteredEntries[currentHighlight!].label;
      _localTextEditingController?.value = TextEditingValue(
        text: currentLabel,
        selection: TextSelection.collapsed(offset: currentLabel.length),
      );
    });
  }

  void handleDownKeyInvoke(_ArrowDownIntent _) {
    setState(() {
      if (!widget.enabled || !_menuHasEnabledItem || !_controller.isOpen) {
        return;
      }
      _enableFilter = false;
      _enableSearch = false;
      currentHighlight ??= -1;
      currentHighlight = (currentHighlight! + 1) % filteredEntries.length;
      while (!filteredEntries[currentHighlight!].enabled) {
        currentHighlight = (currentHighlight! + 1) % filteredEntries.length;
      }
      final String currentLabel = filteredEntries[currentHighlight!].label;
      _localTextEditingController?.value = TextEditingValue(
        text: currentLabel,
        selection: TextSelection.collapsed(offset: currentLabel.length),
      );
    });
  }

  void handlePressed(MenuController controller, {bool focusForKeyboard = true}) {
    if (controller.isOpen) {
      currentHighlight = null;
      controller.close();
    } else {
      // close to open
      if (_localTextEditingController!.text.isNotEmpty) {
        _enableFilter = false;
      }
      controller.open();
      if (focusForKeyboard) {
        _internalFocudeNode.requestFocus();
      }
    }
    setState(() {});
  }

  void _handleEditingComplete() {
    if (currentHighlight != null) {
      final DropdownMenuEntry<T> entry = filteredEntries[currentHighlight!];
      if (entry.enabled) {
        _localTextEditingController?.value = TextEditingValue(
          text: entry.label,
          selection: TextSelection.collapsed(offset: entry.label.length),
        );
        widget.onSelected?.call(entry.value);
      }
    } else {
      if (_controller.isOpen) {
        widget.onSelected?.call(null);
      }
    }
    if (!widget.enableSearch) {
      currentHighlight = null;
    }
    _controller.close();
  }

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);
    _initialMenu ??= _buildButtons(
      widget.dropdownMenuEntries,
      textDirection,
      enableScrollToHighlight: false,
      // The _initialMenu is invisible, we should not add semantics nodes to it
      excludeSemantics: true,
    );
    final DropdownMenuThemeData theme = DropdownMenuTheme.of(context);
    final DropdownMenuThemeData defaults = _DropdownMenuDefaultsM3(context);

    if (_enableFilter) {
      filteredEntries =
          widget.filterCallback?.call(filteredEntries, _localTextEditingController!.text) ??
          filter(widget.dropdownMenuEntries, _localTextEditingController!);
    } else {
      filteredEntries = widget.dropdownMenuEntries;
    }
    _menuHasEnabledItem = filteredEntries.any((entry) => entry.enabled);

    if (_enableSearch) {
      if (widget.searchCallback != null) {
        currentHighlight = widget.searchCallback!(filteredEntries, _localTextEditingController!.text);
      } else {
        final bool shouldUpdateCurrentHighlight = _shouldUpdateCurrentHighlight(filteredEntries);
        if (shouldUpdateCurrentHighlight) {
          currentHighlight = search(filteredEntries, _localTextEditingController!);
        }
      }
      if (currentHighlight != null) {
        scrollToHighlight();
      }
    }

    final List<Widget> menu = _buildButtons(filteredEntries, textDirection, focusedIndex: currentHighlight);

    final TextStyle? effectiveTextStyle = widget.textStyle ?? theme.textStyle ?? defaults.textStyle;

    MenuStyle? effectiveMenuStyle = widget.menuStyle ?? theme.menuStyle ?? defaults.menuStyle!;

    final double? anchorWidth = getWidth(_anchorKey);
    if (widget.width != null) {
      effectiveMenuStyle = effectiveMenuStyle.copyWith(
        minimumSize: WidgetStateProperty.resolveWith<Size?>((states) {
          final double? effectiveMaximumWidth = effectiveMenuStyle!.maximumSize?.resolve(states)?.width;
          return Size(math.min(widget.width!, effectiveMaximumWidth ?? 0.0), 0.0);
        }),
      );
    } else if (anchorWidth != null) {
      effectiveMenuStyle = effectiveMenuStyle.copyWith(
        minimumSize: WidgetStateProperty.resolveWith<Size?>((states) {
          final double? effectiveMaximumWidth = effectiveMenuStyle!.maximumSize?.resolve(states)?.width;
          return Size(math.min(anchorWidth, effectiveMaximumWidth ?? 0.0), 0.0);
        }),
      );
    }

    if (widget.menuHeight != null) {
      effectiveMenuStyle = effectiveMenuStyle.copyWith(
        maximumSize: WidgetStatePropertyAll<Size>(Size(double.infinity, widget.menuHeight!)),
      );
    }
    final InputDecorationTheme effectiveInputDecorationTheme =
        widget.inputDecorationTheme ?? theme.inputDecorationTheme ?? defaults.inputDecorationTheme!;

    final MouseCursor? effectiveMouseCursor = switch (widget.enabled) {
      true => canRequestFocus() ? SystemMouseCursors.text : SystemMouseCursors.click,
      false => null,
    };

    Widget menuAnchor = MenuAnchor(
      style: effectiveMenuStyle,
      alignmentOffset: widget.alignmentOffset,
      controller: _controller,
      menuChildren: menu,
      crossAxisUnconstrained: false,
      builder: (context, controller, child) {
        assert(_initialMenu != null);
        final bool isCollapsed = widget.inputDecorationTheme?.isCollapsed ?? false;
        final Widget trailingButton = Padding(
          padding: isCollapsed ? EdgeInsets.zero : const EdgeInsets.all(4.0),
          child: IconButton(
            isSelected: controller.isOpen,
            constraints: widget.inputDecorationTheme?.suffixIconConstraints,
            padding: isCollapsed ? EdgeInsets.zero : null,
            icon: widget.trailingIcon ?? const Icon(Icons.arrow_drop_down),
            selectedIcon: widget.selectedTrailingIcon ?? const Icon(Icons.arrow_drop_up),
            onPressed: !widget.enabled ? null : () => handlePressed(controller, focusForKeyboard: !canRequestFocus()),
          ),
        );

        final Widget leadingButton = Padding(
          padding: const EdgeInsets.all(8.0),
          child: widget.leadingIcon ?? const SizedBox.shrink(),
        );

        final Widget textField = TextField(
          key: _anchorKey,
          enabled: widget.enabled,
          mouseCursor: effectiveMouseCursor,
          focusNode: widget.focusNode,
          canRequestFocus: canRequestFocus(),
          enableInteractiveSelection: canRequestFocus(),
          readOnly: !canRequestFocus(),
          keyboardType: widget.keyboardType,
          textAlign: widget.textAlign,
          textAlignVertical: TextAlignVertical.center,
          maxLines: widget.maxLines,
          textInputAction: widget.textInputAction,
          style: effectiveTextStyle,
          controller: _localTextEditingController,
          onEditingComplete: _handleEditingComplete,
          onTap:
              !widget.enabled
                  ? null
                  : () {
                    handlePressed(controller);
                  },
          onChanged: (text) {
            controller.open();
            setState(() {
              filteredEntries = widget.dropdownMenuEntries;
              _enableFilter = widget.enableFilter;
              _enableSearch = widget.enableSearch;
            });
          },
          inputFormatters: widget.inputFormatters,
          decoration: InputDecoration(
            label: widget.label,
            hintText: widget.hintText,
            helperText: widget.helperText,
            errorText: widget.errorText,
            prefixIcon: widget.leadingIcon != null ? SizedBox(key: _leadingKey, child: widget.leadingIcon) : null,
            suffixIcon: trailingButton,
          ).applyDefaults(effectiveInputDecorationTheme),
        );

        // If [expandedInsets] is not null, the width of the text field should depend
        // on its parent width. So we don't need to use `_DropdownMenuBody` to
        // calculate the children's width.
        final Widget body =
            widget.expandedInsets != null
                ? textField
                : _DropdownMenuBody(
                  width: widget.width,
                  // The children, except the text field, are used to compute the preferred width,
                  // which is the width of the longest children, plus the width of trailingButton
                  // and leadingButton.
                  //
                  // See _RenderDropdownMenuBody layout logic.
                  children: <Widget>[
                    textField,
                    ..._initialMenu!.map((item) => ExcludeFocus(excluding: !controller.isOpen, child: item)),
                    if (widget.label != null)
                      ExcludeSemantics(
                        child: Padding(
                          // See RenderEditable.floatingCursorAddedMargin for the default horizontal padding.
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: DefaultTextStyle(style: effectiveTextStyle!, child: widget.label!),
                        ),
                      ),
                    trailingButton,
                    leadingButton,
                  ],
                );

        return Shortcuts(
          shortcuts: const <ShortcutActivator, Intent>{
            SingleActivator(LogicalKeyboardKey.arrowLeft): ExtendSelectionByCharacterIntent(
              forward: false,
              collapseSelection: true,
            ),
            SingleActivator(LogicalKeyboardKey.arrowRight): ExtendSelectionByCharacterIntent(
              forward: true,
              collapseSelection: true,
            ),
            SingleActivator(LogicalKeyboardKey.arrowUp): _ArrowUpIntent(),
            SingleActivator(LogicalKeyboardKey.arrowDown): _ArrowDownIntent(),
          },
          child: body,
        );
      },
    );

    if (widget.expandedInsets case final EdgeInsetsGeometry padding) {
      menuAnchor = Padding(
        // Clamp the top and bottom padding to 0.
        padding: padding.clamp(
          EdgeInsets.zero,
          const EdgeInsets.only(
            left: double.infinity,
            right: double.infinity,
          ).add(const EdgeInsetsDirectional.only(end: double.infinity, start: double.infinity)),
        ),
        child: menuAnchor,
      );
    }

    // Wrap the menu anchor with an Align to narrow down the constraints.
    // Without this Align, when tight constraints are applied to DropdownMenu,
    // the menu will appear below these constraints instead of below the
    // text field.
    menuAnchor = Align(
      alignment: AlignmentDirectional.topStart,
      widthFactor: 1.0,
      heightFactor: 1.0,
      child: menuAnchor,
    );

    return Actions(
      actions: <Type, Action<Intent>>{
        _ArrowUpIntent: CallbackAction<_ArrowUpIntent>(onInvoke: handleUpKeyInvoke),
        _ArrowDownIntent: CallbackAction<_ArrowDownIntent>(onInvoke: handleDownKeyInvoke),
        _EnterIntent: CallbackAction<_EnterIntent>(onInvoke: (_) => _handleEditingComplete()),
      },
      child: Stack(
        children: <Widget>[
          // Handling keyboard navigation when the Textfield has no focus.
          Shortcuts(
            shortcuts: const <ShortcutActivator, Intent>{
              SingleActivator(LogicalKeyboardKey.arrowUp): _ArrowUpIntent(),
              SingleActivator(LogicalKeyboardKey.arrowDown): _ArrowDownIntent(),
              SingleActivator(LogicalKeyboardKey.enter): _EnterIntent(),
            },
            child: Focus(focusNode: _internalFocudeNode, skipTraversal: true, child: const SizedBox.shrink()),
          ),
          menuAnchor,
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<GlobalKey<State<StatefulWidget>>>('buttonItemKeys', buttonItemKeys));
    properties.add(IterableProperty<DropdownMenuEntry<T>>('filteredEntries', filteredEntries));
    properties.add(IntProperty('currentHighlight', currentHighlight));
    properties.add(DoubleProperty('leadingPadding', leadingPadding));
  }
}

// `DropdownMenu` dispatches these private intents on arrow up/down keys.
// They are needed instead of the typical `DirectionalFocusIntent`s because
// `DropdownMenu` does not really navigate the focus tree upon arrow up/down
// keys: the focus stays on the text field and the menu items are given fake
// highlights as if they are focused. Using `DirectionalFocusIntent`s will cause
// the action to be processed by `EditableText`.
class _ArrowUpIntent extends Intent {
  const _ArrowUpIntent();
}

class _ArrowDownIntent extends Intent {
  const _ArrowDownIntent();
}

class _EnterIntent extends Intent {
  const _EnterIntent();
}

class _DropdownMenuBody extends MultiChildRenderObjectWidget {
  const _DropdownMenuBody({super.children, this.width});

  final double? width;

  @override
  _RenderDropdownMenuBody createRenderObject(BuildContext context) => _RenderDropdownMenuBody(width: width);

  @override
  void updateRenderObject(BuildContext context, _RenderDropdownMenuBody renderObject) {
    renderObject.width = width;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('width', width));
  }
}

class _DropdownMenuBodyParentData extends ContainerBoxParentData<RenderBox> {}

class _RenderDropdownMenuBody extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _DropdownMenuBodyParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _DropdownMenuBodyParentData> {
  _RenderDropdownMenuBody({double? width}) : _width = width;

  double? get width => _width;
  double? _width;
  set width(double? value) {
    if (_width == value) {
      return;
    }
    _width = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _DropdownMenuBodyParentData) {
      child.parentData = _DropdownMenuBodyParentData();
    }
  }

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    double maxWidth = 0.0;
    double? maxHeight;
    RenderBox? child = firstChild;

    final double intrinsicWidth = width ?? getMaxIntrinsicWidth(constraints.maxHeight);
    final double widthConstraint = math.min(intrinsicWidth, constraints.maxWidth);
    final BoxConstraints innerConstraints = BoxConstraints(
      maxWidth: widthConstraint,
      maxHeight: getMaxIntrinsicHeight(widthConstraint),
    );
    while (child != null) {
      if (child == firstChild) {
        child.layout(innerConstraints, parentUsesSize: true);
        maxHeight ??= child.size.height;
        final _DropdownMenuBodyParentData childParentData = child.parentData! as _DropdownMenuBodyParentData;
        assert(child.parentData == childParentData);
        child = childParentData.nextSibling;
        continue;
      }
      child.layout(innerConstraints, parentUsesSize: true);
      final _DropdownMenuBodyParentData childParentData = child.parentData! as _DropdownMenuBodyParentData;
      childParentData.offset = Offset.zero;
      maxWidth = math.max(maxWidth, child.size.width);
      maxHeight ??= child.size.height;
      assert(child.parentData == childParentData);
      child = childParentData.nextSibling;
    }

    assert(maxHeight != null);
    maxWidth = math.max(_kMinimumWidth, maxWidth);
    size = constraints.constrain(Size(width ?? maxWidth, maxHeight!));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final RenderBox? child = firstChild;
    if (child != null) {
      final _DropdownMenuBodyParentData childParentData = child.parentData! as _DropdownMenuBodyParentData;
      context.paintChild(child, offset + childParentData.offset);
    }
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final BoxConstraints constraints = this.constraints;
    double maxWidth = 0.0;
    double? maxHeight;
    RenderBox? child = firstChild;
    final double intrinsicWidth = width ?? getMaxIntrinsicWidth(constraints.maxHeight);
    final double widthConstraint = math.min(intrinsicWidth, constraints.maxWidth);
    final BoxConstraints innerConstraints = BoxConstraints(
      maxWidth: widthConstraint,
      maxHeight: getMaxIntrinsicHeight(widthConstraint),
    );

    while (child != null) {
      if (child == firstChild) {
        final Size childSize = child.getDryLayout(innerConstraints);
        maxHeight ??= childSize.height;
        final _DropdownMenuBodyParentData childParentData = child.parentData! as _DropdownMenuBodyParentData;
        assert(child.parentData == childParentData);
        child = childParentData.nextSibling;
        continue;
      }
      final Size childSize = child.getDryLayout(innerConstraints);
      final _DropdownMenuBodyParentData childParentData = child.parentData! as _DropdownMenuBodyParentData;
      childParentData.offset = Offset.zero;
      maxWidth = math.max(maxWidth, childSize.width);
      maxHeight ??= childSize.height;
      assert(child.parentData == childParentData);
      child = childParentData.nextSibling;
    }

    assert(maxHeight != null);
    maxWidth = math.max(_kMinimumWidth, maxWidth);
    return constraints.constrain(Size(width ?? maxWidth, maxHeight!));
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    RenderBox? child = firstChild;
    double width = 0;
    while (child != null) {
      if (child == firstChild) {
        final _DropdownMenuBodyParentData childParentData = child.parentData! as _DropdownMenuBodyParentData;
        child = childParentData.nextSibling;
        continue;
      }
      final double maxIntrinsicWidth = child.getMinIntrinsicWidth(height);
      // Add the width of leading icon.
      if (child == lastChild) {
        width += maxIntrinsicWidth;
      }
      // Add the width of trailing icon.
      if (child == childBefore(lastChild!)) {
        width += maxIntrinsicWidth;
      }
      width = math.max(width, maxIntrinsicWidth);
      final _DropdownMenuBodyParentData childParentData = child.parentData! as _DropdownMenuBodyParentData;
      child = childParentData.nextSibling;
    }

    return math.max(width, _kMinimumWidth);
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    RenderBox? child = firstChild;
    double width = 0;
    while (child != null) {
      if (child == firstChild) {
        final _DropdownMenuBodyParentData childParentData = child.parentData! as _DropdownMenuBodyParentData;
        child = childParentData.nextSibling;
        continue;
      }
      final double maxIntrinsicWidth = child.getMaxIntrinsicWidth(height);
      // Add the width of leading icon.
      if (child == lastChild) {
        width += maxIntrinsicWidth;
      }
      // Add the width of trailing icon.
      if (child == childBefore(lastChild!)) {
        width += maxIntrinsicWidth;
      }
      width = math.max(width, maxIntrinsicWidth);
      final _DropdownMenuBodyParentData childParentData = child.parentData! as _DropdownMenuBodyParentData;
      child = childParentData.nextSibling;
    }

    return math.max(width, _kMinimumWidth);
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    final RenderBox? child = firstChild;
    double width = 0;
    if (child != null) {
      width = math.max(width, child.getMinIntrinsicHeight(width));
    }
    return width;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    final RenderBox? child = firstChild;
    double width = 0;
    if (child != null) {
      width = math.max(width, child.getMaxIntrinsicHeight(width));
    }
    return width;
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    final RenderBox? child = firstChild;
    if (child != null) {
      final _DropdownMenuBodyParentData childParentData = child.parentData! as _DropdownMenuBodyParentData;
      final bool isHit = result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (result, transformed) {
          assert(transformed == position - childParentData.offset);
          return child.hitTest(result, position: transformed);
        },
      );
      if (isHit) {
        return true;
      }
    }
    return false;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('width', width));
  }
}

// Hand coded defaults. These will be updated once we have tokens/spec.
class _DropdownMenuDefaultsM3 extends DropdownMenuThemeData {
  _DropdownMenuDefaultsM3(this.context);

  final BuildContext context;
  late final ThemeData _theme = Theme.of(context);

  @override
  TextStyle? get textStyle => _theme.textTheme.bodyLarge;

  @override
  MenuStyle get menuStyle => const MenuStyle(
    minimumSize: WidgetStatePropertyAll<Size>(Size(_kMinimumWidth, 0.0)),
    maximumSize: WidgetStatePropertyAll<Size>(Size.infinite),
    visualDensity: VisualDensity.standard,
  );

  @override
  InputDecorationTheme get inputDecorationTheme => const InputDecorationTheme(border: OutlineInputBorder());

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BuildContext>('context', context));
  }
}
