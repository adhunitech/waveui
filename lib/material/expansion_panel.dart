// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:waveui/material/theme.dart' show ThemeData;
import 'package:waveui/material/theme_data.dart' show ThemeData;

import 'package:waveui/material/constants.dart';
import 'package:waveui/material/expand_icon.dart';
import 'package:waveui/material/icon_button.dart';
import 'package:waveui/material/ink_well.dart';
import 'package:waveui/material/material_localizations.dart';
import 'package:waveui/material/mergeable_material.dart';
import 'package:waveui/material/shadows.dart';
import 'package:waveui/material/theme.dart';
import 'package:waveui/waveui.dart' show ThemeData;

const double _kPanelHeaderCollapsedHeight = kMinInteractiveDimension;
const EdgeInsets _kPanelHeaderExpandedDefaultPadding = EdgeInsets.symmetric(
  vertical: 64.0 - _kPanelHeaderCollapsedHeight,
);
const EdgeInsets _kExpandIconPadding = EdgeInsets.all(12.0);

class _SaltedKey<S, V> extends LocalKey {
  const _SaltedKey(this.salt, this.value);

  final S salt;
  final V value;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is _SaltedKey<S, V> && other.salt == salt && other.value == value;
  }

  @override
  int get hashCode => Object.hash(runtimeType, salt, value);

  @override
  String toString() {
    final String saltString = S == String ? "<'$salt'>" : '<$salt>';
    final String valueString = V == String ? "<'$value'>" : '<$value>';
    return '[$saltString $valueString]';
  }
}

typedef ExpansionPanelCallback = void Function(int panelIndex, bool isExpanded);

typedef ExpansionPanelHeaderBuilder = Widget Function(BuildContext context, bool isExpanded);

class ExpansionPanel {
  ExpansionPanel({
    required this.headerBuilder,
    required this.body,
    this.isExpanded = false,
    this.canTapOnHeader = false,
    this.backgroundColor,
    this.splashColor,
    this.highlightColor,
  });

  final ExpansionPanelHeaderBuilder headerBuilder;

  final Widget body;

  final bool isExpanded;

  final Color? splashColor;

  final Color? highlightColor;

  final bool canTapOnHeader;

  final Color? backgroundColor;
}

class ExpansionPanelRadio extends ExpansionPanel {
  ExpansionPanelRadio({
    required this.value,
    required super.headerBuilder,
    required super.body,
    super.canTapOnHeader,
    super.backgroundColor,
    super.splashColor,
    super.highlightColor,
  });

  final Object value;
}

class ExpansionPanelList extends StatefulWidget {
  const ExpansionPanelList({
    super.key,
    this.children = const <ExpansionPanel>[],
    this.expansionCallback,
    this.animationDuration = kThemeAnimationDuration,
    this.expandedHeaderPadding = _kPanelHeaderExpandedDefaultPadding,
    this.dividerColor,
    this.elevation = 2,
    this.expandIconColor,
    this.materialGapSize = 16.0,
  }) : _allowOnlyOnePanelOpen = false,
       initialOpenPanelValue = null;

  const ExpansionPanelList.radio({
    super.key,
    this.children = const <ExpansionPanelRadio>[],
    this.expansionCallback,
    this.animationDuration = kThemeAnimationDuration,
    this.initialOpenPanelValue,
    this.expandedHeaderPadding = _kPanelHeaderExpandedDefaultPadding,
    this.dividerColor,
    this.elevation = 2,
    this.expandIconColor,
    this.materialGapSize = 16.0,
  }) : _allowOnlyOnePanelOpen = true;

  final List<ExpansionPanel> children;

  final ExpansionPanelCallback? expansionCallback;

  final Duration animationDuration;

  // Whether multiple panels can be open simultaneously
  final bool _allowOnlyOnePanelOpen;

  final Object? initialOpenPanelValue;

  final EdgeInsets expandedHeaderPadding;

  final Color? dividerColor;

  final double elevation;

  final Color? expandIconColor;

  final double materialGapSize;

  @override
  State<StatefulWidget> createState() => _ExpansionPanelListState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<ExpansionPanel>('children', children));
    properties.add(ObjectFlagProperty<ExpansionPanelCallback?>.has('expansionCallback', expansionCallback));
    properties.add(DiagnosticsProperty<Duration>('animationDuration', animationDuration));
    properties.add(DiagnosticsProperty<Object?>('initialOpenPanelValue', initialOpenPanelValue));
    properties.add(DiagnosticsProperty<EdgeInsets>('expandedHeaderPadding', expandedHeaderPadding));
    properties.add(ColorProperty('dividerColor', dividerColor));
    properties.add(DoubleProperty('elevation', elevation));
    properties.add(ColorProperty('expandIconColor', expandIconColor));
    properties.add(DoubleProperty('materialGapSize', materialGapSize));
  }
}

class _ExpansionPanelListState extends State<ExpansionPanelList> {
  ExpansionPanelRadio? _currentOpenPanel;

  @override
  void initState() {
    super.initState();
    if (widget._allowOnlyOnePanelOpen) {
      assert(_allIdentifiersUnique(), 'All ExpansionPanelRadio identifier values must be unique.');
      if (widget.initialOpenPanelValue != null) {
        _currentOpenPanel = searchPanelByValue(
          widget.children.cast<ExpansionPanelRadio>(),
          widget.initialOpenPanelValue,
        );
      }
    }
  }

  @override
  void didUpdateWidget(ExpansionPanelList oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget._allowOnlyOnePanelOpen) {
      assert(_allIdentifiersUnique(), 'All ExpansionPanelRadio identifier values must be unique.');
      // If the previous widget was non-radio ExpansionPanelList, initialize the
      // open panel to widget.initialOpenPanelValue
      if (!oldWidget._allowOnlyOnePanelOpen) {
        _currentOpenPanel = searchPanelByValue(
          widget.children.cast<ExpansionPanelRadio>(),
          widget.initialOpenPanelValue,
        );
      }
    } else {
      _currentOpenPanel = null;
    }
  }

  bool _allIdentifiersUnique() {
    final Map<Object, bool> identifierMap = <Object, bool>{};
    for (final ExpansionPanelRadio child in widget.children.cast<ExpansionPanelRadio>()) {
      identifierMap[child.value] = true;
    }
    return identifierMap.length == widget.children.length;
  }

  bool _isChildExpanded(int index) {
    if (widget._allowOnlyOnePanelOpen) {
      final ExpansionPanelRadio radioWidget = widget.children[index] as ExpansionPanelRadio;
      return _currentOpenPanel?.value == radioWidget.value;
    }
    return widget.children[index].isExpanded;
  }

  void _handlePressed(bool isExpanded, int index) {
    if (widget._allowOnlyOnePanelOpen) {
      final ExpansionPanelRadio pressedChild = widget.children[index] as ExpansionPanelRadio;

      // If another ExpansionPanelRadio was already open, apply its
      // expansionCallback (if any) to false, because it's closing.
      for (int childIndex = 0; childIndex < widget.children.length; childIndex += 1) {
        final ExpansionPanelRadio child = widget.children[childIndex] as ExpansionPanelRadio;
        if (widget.expansionCallback != null && childIndex != index && child.value == _currentOpenPanel?.value) {
          widget.expansionCallback!(childIndex, false);
        }
      }

      setState(() {
        _currentOpenPanel = isExpanded ? null : pressedChild;
      });
    }
    // !isExpanded is passed because, when _handlePressed, the state of the panel to expand is not yet expanded.
    widget.expansionCallback?.call(index, !isExpanded);
  }

  ExpansionPanelRadio? searchPanelByValue(List<ExpansionPanelRadio> panels, Object? value) {
    for (final ExpansionPanelRadio panel in panels) {
      if (panel.value == value) {
        return panel;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    assert(
      kElevationToShadow.containsKey(widget.elevation),
      'Invalid value for elevation. See the kElevationToShadow constant for'
      ' possible elevation values.',
    );

    final List<MergeableMaterialItem> items = <MergeableMaterialItem>[];

    for (int index = 0; index < widget.children.length; index += 1) {
      if (_isChildExpanded(index) && index != 0 && !_isChildExpanded(index - 1)) {
        items.add(
          MaterialGap(key: _SaltedKey<BuildContext, int>(context, index * 2 - 1), size: widget.materialGapSize),
        );
      }

      final ExpansionPanel child = widget.children[index];
      final Widget headerWidget = child.headerBuilder(context, _isChildExpanded(index));

      Widget expandIconPadded = Padding(
        padding: const EdgeInsetsDirectional.only(end: 8.0),
        child: IgnorePointer(
          ignoring: child.canTapOnHeader,
          child: ExpandIcon(
            color: widget.expandIconColor,
            isExpanded: _isChildExpanded(index),
            padding: _kExpandIconPadding,
            splashColor: child.splashColor,
            highlightColor: child.highlightColor,
            onPressed: (isExpanded) => _handlePressed(isExpanded, index),
          ),
        ),
      );

      if (!child.canTapOnHeader) {
        final MaterialLocalizations localizations = MaterialLocalizations.of(context);
        expandIconPadded = Semantics(
          label: _isChildExpanded(index) ? localizations.expandedIconTapHint : localizations.collapsedIconTapHint,
          container: true,
          child: expandIconPadded,
        );
      }
      Widget header = Row(
        children: <Widget>[
          Expanded(
            child: AnimatedContainer(
              duration: widget.animationDuration,
              curve: Curves.fastOutSlowIn,
              margin: _isChildExpanded(index) ? widget.expandedHeaderPadding : EdgeInsets.zero,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: _kPanelHeaderCollapsedHeight),
                child: headerWidget,
              ),
            ),
          ),
          expandIconPadded,
        ],
      );
      if (child.canTapOnHeader) {
        header = MergeSemantics(
          child: InkWell(
            splashColor: child.splashColor,
            highlightColor: child.highlightColor,
            onTap: () => _handlePressed(_isChildExpanded(index), index),
            child: header,
          ),
        );
      }
      items.add(
        MaterialSlice(
          key: _SaltedKey<BuildContext, int>(context, index * 2),
          color: child.backgroundColor,
          child: Column(
            children: <Widget>[
              header,
              AnimatedCrossFade(
                firstChild: const LimitedBox(maxWidth: 0.0, child: SizedBox(width: double.infinity, height: 0)),
                secondChild: child.body,
                firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
                secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
                sizeCurve: Curves.fastOutSlowIn,
                crossFadeState: _isChildExpanded(index) ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: widget.animationDuration,
              ),
            ],
          ),
        ),
      );

      if (_isChildExpanded(index) && index != widget.children.length - 1) {
        items.add(
          MaterialGap(key: _SaltedKey<BuildContext, int>(context, index * 2 + 1), size: widget.materialGapSize),
        );
      }
    }

    return MergeableMaterial(
      hasDividers: true,
      dividerColor: widget.dividerColor,
      elevation: widget.elevation,
      children: items,
    );
  }
}
