// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/ink_well.dart';
import 'package:waveui/material/material.dart';
import 'package:waveui/material/text_form_field.dart';
import 'package:waveui/material/theme.dart';

class Autocomplete<T extends Object> extends StatelessWidget {
  const Autocomplete({
    required this.optionsBuilder,
    super.key,
    this.displayStringForOption = RawAutocomplete.defaultStringForOption,
    this.fieldViewBuilder = _defaultFieldViewBuilder,
    this.onSelected,
    this.optionsMaxHeight = 200.0,
    this.optionsViewBuilder,
    this.optionsViewOpenDirection = OptionsViewOpenDirection.down,
    this.initialValue,
  });

  final AutocompleteOptionToString<T> displayStringForOption;

  final AutocompleteFieldViewBuilder fieldViewBuilder;

  final AutocompleteOnSelected<T>? onSelected;

  final AutocompleteOptionsBuilder<T> optionsBuilder;

  final AutocompleteOptionsViewBuilder<T>? optionsViewBuilder;

  final OptionsViewOpenDirection optionsViewOpenDirection;

  final double optionsMaxHeight;

  final TextEditingValue? initialValue;

  static Widget _defaultFieldViewBuilder(
    BuildContext context,
    TextEditingController textEditingController,
    FocusNode focusNode,
    VoidCallback onFieldSubmitted,
  ) => _AutocompleteField(
    focusNode: focusNode,
    textEditingController: textEditingController,
    onFieldSubmitted: onFieldSubmitted,
  );

  @override
  Widget build(BuildContext context) => RawAutocomplete<T>(
    displayStringForOption: displayStringForOption,
    fieldViewBuilder: fieldViewBuilder,
    initialValue: initialValue,
    optionsBuilder: optionsBuilder,
    optionsViewOpenDirection: optionsViewOpenDirection,
    optionsViewBuilder:
        optionsViewBuilder ??
        (BuildContext context, AutocompleteOnSelected<T> onSelected, Iterable<T> options) => _AutocompleteOptions<T>(
          displayStringForOption: displayStringForOption,
          onSelected: onSelected,
          options: options,
          openDirection: optionsViewOpenDirection,
          optionsMaxHeight: optionsMaxHeight,
        ),
    onSelected: onSelected,
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<AutocompleteOptionToString<T>>.has('displayStringForOption', displayStringForOption));
    properties.add(ObjectFlagProperty<AutocompleteFieldViewBuilder>.has('fieldViewBuilder', fieldViewBuilder));
    properties.add(ObjectFlagProperty<AutocompleteOnSelected<T>?>.has('onSelected', onSelected));
    properties.add(ObjectFlagProperty<AutocompleteOptionsBuilder<T>>.has('optionsBuilder', optionsBuilder));
    properties.add(ObjectFlagProperty<AutocompleteOptionsViewBuilder<T>?>.has('optionsViewBuilder', optionsViewBuilder));
    properties.add(EnumProperty<OptionsViewOpenDirection>('optionsViewOpenDirection', optionsViewOpenDirection));
    properties.add(DoubleProperty('optionsMaxHeight', optionsMaxHeight));
    properties.add(DiagnosticsProperty<TextEditingValue?>('initialValue', initialValue));
  }
}

// The default Material-style Autocomplete text field.
class _AutocompleteField extends StatelessWidget {
  const _AutocompleteField({
    required this.focusNode,
    required this.textEditingController,
    required this.onFieldSubmitted,
  });

  final FocusNode focusNode;

  final VoidCallback onFieldSubmitted;

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: textEditingController,
    focusNode: focusNode,
    onFieldSubmitted: (value) {
      onFieldSubmitted();
    },
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<FocusNode>('focusNode', focusNode));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onFieldSubmitted', onFieldSubmitted));
    properties.add(DiagnosticsProperty<TextEditingController>('textEditingController', textEditingController));
  }
}

// The default Material-style Autocomplete options.
class _AutocompleteOptions<T extends Object> extends StatelessWidget {
  const _AutocompleteOptions({
    required this.displayStringForOption,
    required this.onSelected,
    required this.openDirection,
    required this.options,
    required this.optionsMaxHeight,
    super.key,
  });

  final AutocompleteOptionToString<T> displayStringForOption;
  final AutocompleteOnSelected<T> onSelected;
  final OptionsViewOpenDirection openDirection;
  final Iterable<T> options;
  final double optionsMaxHeight;

  @override
  Widget build(BuildContext context) {
    final int highlightedIndex = AutocompleteHighlightedOption.of(context);

    final AlignmentDirectional optionsAlignment = switch (openDirection) {
      OptionsViewOpenDirection.up => AlignmentDirectional.bottomStart,
      OptionsViewOpenDirection.down => AlignmentDirectional.topStart,
    };

    return Align(
      alignment: optionsAlignment,
      child: Material(
        elevation: 4.0,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: optionsMaxHeight),
          child: _AutocompleteOptionsList<T>(
            displayStringForOption: displayStringForOption,
            highlightedIndex: highlightedIndex,
            onSelected: onSelected,
            options: options,
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<AutocompleteOptionToString<T>>.has('displayStringForOption', displayStringForOption));
    properties.add(ObjectFlagProperty<AutocompleteOnSelected<T>>.has('onSelected', onSelected));
    properties.add(EnumProperty<OptionsViewOpenDirection>('openDirection', openDirection));
    properties.add(IterableProperty<T>('options', options));
    properties.add(DoubleProperty('optionsMaxHeight', optionsMaxHeight));
  }
}

class _AutocompleteOptionsList<T extends Object> extends StatefulWidget {
  const _AutocompleteOptionsList({
    required this.displayStringForOption,
    required this.highlightedIndex,
    required this.onSelected,
    required this.options,
  });

  final AutocompleteOptionToString<T> displayStringForOption;
  final int highlightedIndex;
  final AutocompleteOnSelected<T> onSelected;
  final Iterable<T> options;

  @override
  State<_AutocompleteOptionsList<T>> createState() => _AutocompleteOptionsListState<T>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<AutocompleteOptionToString<T>>.has('displayStringForOption', displayStringForOption));
    properties.add(IntProperty('highlightedIndex', highlightedIndex));
    properties.add(ObjectFlagProperty<AutocompleteOnSelected<T>>.has('onSelected', onSelected));
    properties.add(IterableProperty<T>('options', options));
  }
}

class _AutocompleteOptionsListState<T extends Object> extends State<_AutocompleteOptionsList<T>> {
  final ScrollController _scrollController = ScrollController();

  @override
  void didUpdateWidget(_AutocompleteOptionsList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.highlightedIndex != oldWidget.highlightedIndex) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        if (!mounted) {
          return;
        }
        final BuildContext? highlightedContext =
            GlobalObjectKey(widget.options.elementAt(widget.highlightedIndex)).currentContext;
        if (highlightedContext == null) {
          _scrollController.jumpTo(widget.highlightedIndex == 0 ? 0.0 : _scrollController.position.maxScrollExtent);
        } else {
          Scrollable.ensureVisible(highlightedContext, alignment: 0.5);
        }
      }, debugLabel: 'AutocompleteOptions.ensureVisible');
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int highlightedIndex = AutocompleteHighlightedOption.of(context);

    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      controller: _scrollController,
      itemCount: widget.options.length,
      itemBuilder: (context, index) {
        final T option = widget.options.elementAt(index);
        return InkWell(
          key: GlobalObjectKey(option),
          onTap: () {
            widget.onSelected(option);
          },
          child: Builder(
            builder: (context) {
              final bool highlight = highlightedIndex == index;
              return Container(
                color: highlight ? Theme.of(context).focusColor : null,
                padding: const EdgeInsets.all(16.0),
                child: Text(widget.displayStringForOption(option)),
              );
            },
          ),
        );
      },
    );
  }
}
