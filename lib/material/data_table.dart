// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;
import 'dart:ui' show SemanticsRole;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/checkbox.dart';
import 'package:waveui/material/constants.dart';
import 'package:waveui/material/data_table_theme.dart';
import 'package:waveui/material/debug.dart';
import 'package:waveui/material/divider.dart';
import 'package:waveui/material/dropdown.dart';
import 'package:waveui/material/icons.dart';
import 'package:waveui/material/ink_well.dart';
import 'package:waveui/material/material.dart';
import 'package:waveui/material/material_state.dart';
import 'package:waveui/material/theme.dart';
import 'package:waveui/material/tooltip.dart';

// Examples can assume:
// late BuildContext context;
// late List<DataColumn> _columns;
// late List<DataRow> _rows;

typedef DataColumnSortCallback = void Function(int columnIndex, bool ascending);

@immutable
class DataColumn {
  const DataColumn({
    required this.label,
    this.columnWidth,
    this.tooltip,
    this.numeric = false,
    this.onSort,
    this.mouseCursor,
    this.headingRowAlignment,
  });

  final Widget label;

  final TableColumnWidth? columnWidth;

  final String? tooltip;

  final bool numeric;

  final DataColumnSortCallback? onSort;

  bool get _debugInteractive => onSort != null;

  final WidgetStateProperty<MouseCursor?>? mouseCursor;

  final MainAxisAlignment? headingRowAlignment;
}

@immutable
class DataRow {
  const DataRow({
    required this.cells,
    this.key,
    this.selected = false,
    this.onSelectChanged,
    this.onLongPress,
    this.color,
    this.mouseCursor,
  });

  DataRow.byIndex({
    required this.cells,
    int? index,
    this.selected = false,
    this.onSelectChanged,
    this.onLongPress,
    this.color,
    this.mouseCursor,
  }) : key = ValueKey<int?>(index);

  final LocalKey? key;

  final ValueChanged<bool?>? onSelectChanged;

  final GestureLongPressCallback? onLongPress;

  final bool selected;

  final List<DataCell> cells;

  final WidgetStateProperty<Color?>? color;

  final WidgetStateProperty<MouseCursor?>? mouseCursor;

  bool get _debugInteractive => onSelectChanged != null || cells.any((cell) => cell._debugInteractive);
}

@immutable
class DataCell {
  const DataCell(
    this.child, {
    this.placeholder = false,
    this.showEditIcon = false,
    this.onTap,
    this.onLongPress,
    this.onTapDown,
    this.onDoubleTap,
    this.onTapCancel,
  });

  static const DataCell empty = DataCell(SizedBox.shrink());

  final Widget child;

  final bool placeholder;

  final bool showEditIcon;

  final GestureTapCallback? onTap;

  final GestureTapCallback? onDoubleTap;

  final GestureLongPressCallback? onLongPress;

  final GestureTapDownCallback? onTapDown;

  final GestureTapCancelCallback? onTapCancel;

  bool get _debugInteractive =>
      onTap != null || onDoubleTap != null || onLongPress != null || onTapDown != null || onTapCancel != null;
}

class DataTable extends StatelessWidget {
  DataTable({
    required this.columns,
    required this.rows,
    super.key,
    this.sortColumnIndex,
    this.sortAscending = true,
    this.onSelectAll,
    this.decoration,
    this.dataRowColor,
    @Deprecated(
      'Migrate to use dataRowMinHeight and dataRowMaxHeight instead. '
      'This feature was deprecated after v3.7.0-5.0.pre.',
    )
    double? dataRowHeight,
    double? dataRowMinHeight,
    double? dataRowMaxHeight,
    this.dataTextStyle,
    this.headingRowColor,
    this.headingRowHeight,
    this.headingTextStyle,
    this.horizontalMargin,
    this.columnSpacing,
    this.showCheckboxColumn = true,
    this.showBottomBorder = false,
    this.dividerThickness,
    this.checkboxHorizontalMargin,
    this.border,
    this.clipBehavior = Clip.none,
  }) : assert(columns.isNotEmpty),
       assert(sortColumnIndex == null || (sortColumnIndex >= 0 && sortColumnIndex < columns.length)),
       assert(
         !rows.any((row) => row.cells.length != columns.length),
         'All rows must have the same number of cells as there are header cells (${columns.length})',
       ),
       assert(dividerThickness == null || dividerThickness >= 0),
       assert(dataRowMinHeight == null || dataRowMaxHeight == null || dataRowMaxHeight >= dataRowMinHeight),
       assert(
         dataRowHeight == null || (dataRowMinHeight == null && dataRowMaxHeight == null),
         'dataRowHeight ($dataRowHeight) must not be set if dataRowMinHeight ($dataRowMinHeight) or dataRowMaxHeight ($dataRowMaxHeight) are set.',
       ),
       dataRowMinHeight = dataRowHeight ?? dataRowMinHeight,
       dataRowMaxHeight = dataRowHeight ?? dataRowMaxHeight,
       _onlyTextColumn = _initOnlyTextColumn(columns);

  final List<DataColumn> columns;

  final int? sortColumnIndex;

  final bool sortAscending;

  final ValueSetter<bool?>? onSelectAll;

  final Decoration? decoration;

  final WidgetStateProperty<Color?>? dataRowColor;

  @Deprecated(
    'Migrate to use dataRowMinHeight and dataRowMaxHeight instead. '
    'This feature was deprecated after v3.7.0-5.0.pre.',
  )
  double? get dataRowHeight => dataRowMinHeight == dataRowMaxHeight ? dataRowMinHeight : null;

  final double? dataRowMinHeight;

  final double? dataRowMaxHeight;

  final TextStyle? dataTextStyle;

  final WidgetStateProperty<Color?>? headingRowColor;

  final double? headingRowHeight;

  final TextStyle? headingTextStyle;

  final double? horizontalMargin;

  final double? columnSpacing;

  final bool showCheckboxColumn;

  final List<DataRow> rows;

  final double? dividerThickness;

  final bool showBottomBorder;

  final double? checkboxHorizontalMargin;

  final TableBorder? border;

  final Clip clipBehavior;

  // Set by the constructor to the index of the only Column that is
  // non-numeric, if there is exactly one, otherwise null.
  final int? _onlyTextColumn;
  static int? _initOnlyTextColumn(List<DataColumn> columns) {
    int? result;
    for (int index = 0; index < columns.length; index += 1) {
      final DataColumn column = columns[index];
      if (!column.numeric) {
        if (result != null) {
          return null;
        }
        result = index;
      }
    }
    return result;
  }

  bool get _debugInteractive =>
      columns.any((column) => column._debugInteractive) || rows.any((row) => row._debugInteractive);

  static final LocalKey _headingRowKey = UniqueKey();

  void _handleSelectAll(bool? checked, bool someChecked) {
    // If some checkboxes are checked, all checkboxes are selected. Otherwise,
    // use the new checked value but default to false if it's null.
    final bool effectiveChecked = someChecked || (checked ?? false);
    if (onSelectAll != null) {
      onSelectAll!(effectiveChecked);
    } else {
      for (final DataRow row in rows) {
        if (row.onSelectChanged != null && row.selected != effectiveChecked) {
          row.onSelectChanged!(effectiveChecked);
        }
      }
    }
  }

  static const double _headingRowHeight = 56.0;

  static const double _horizontalMargin = 24.0;

  static const double _columnSpacing = 56.0;

  static const double _sortArrowPadding = 2.0;

  static const double _dividerThickness = 1.0;

  static const Duration _sortArrowAnimationDuration = Duration(milliseconds: 150);

  Widget _buildCheckbox({
    required BuildContext context,
    required bool? checked,
    required VoidCallback? onRowTap,
    required ValueChanged<bool?>? onCheckboxChanged,
    required WidgetStateProperty<Color?>? overlayColor,
    required bool tristate,
    MouseCursor? rowMouseCursor,
  }) {
    final ThemeData themeData = Theme.of(context);
    final double effectiveHorizontalMargin =
        horizontalMargin ?? themeData.dataTableTheme.horizontalMargin ?? _horizontalMargin;
    final double effectiveCheckboxHorizontalMarginStart =
        checkboxHorizontalMargin ?? themeData.dataTableTheme.checkboxHorizontalMargin ?? effectiveHorizontalMargin;
    final double effectiveCheckboxHorizontalMarginEnd =
        checkboxHorizontalMargin ??
        themeData.dataTableTheme.checkboxHorizontalMargin ??
        effectiveHorizontalMargin / 2.0;
    Widget contents = Semantics(
      container: true,
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          start: effectiveCheckboxHorizontalMarginStart,
          end: effectiveCheckboxHorizontalMarginEnd,
        ),
        child: Center(child: Checkbox(value: checked, onChanged: onCheckboxChanged, tristate: tristate)),
      ),
    );
    if (onRowTap != null) {
      contents = TableRowInkWell(
        onTap: onRowTap,
        overlayColor: overlayColor,
        mouseCursor: rowMouseCursor,
        child: contents,
      );
    }
    return TableCell(verticalAlignment: TableCellVerticalAlignment.fill, child: contents);
  }

  Widget _buildHeadingCell({
    required BuildContext context,
    required EdgeInsetsGeometry padding,
    required Widget label,
    required String? tooltip,
    required bool numeric,
    required VoidCallback? onSort,
    required bool sorted,
    required bool ascending,
    required WidgetStateProperty<Color?>? overlayColor,
    required MouseCursor? mouseCursor,
    required MainAxisAlignment headingRowAlignment,
  }) {
    final ThemeData themeData = Theme.of(context);
    final DataTableThemeData dataTableTheme = DataTableTheme.of(context);
    label = Semantics(
      role: SemanticsRole.columnHeader,
      child: Row(
        textDirection: numeric ? TextDirection.rtl : null,
        mainAxisAlignment: headingRowAlignment,
        children: <Widget>[
          if (headingRowAlignment == MainAxisAlignment.center && onSort != null)
            const SizedBox(width: _SortArrowState._arrowIconSize + _sortArrowPadding),
          label,
          if (onSort != null) ...<Widget>[
            _SortArrow(visible: sorted, up: sorted ? ascending : null, duration: _sortArrowAnimationDuration),
            const SizedBox(width: _sortArrowPadding),
          ],
        ],
      ),
    );

    final TextStyle effectiveHeadingTextStyle =
        headingTextStyle ??
        dataTableTheme.headingTextStyle ??
        themeData.dataTableTheme.headingTextStyle ??
        themeData.textTheme.titleSmall!;
    final double effectiveHeadingRowHeight =
        headingRowHeight ??
        dataTableTheme.headingRowHeight ??
        themeData.dataTableTheme.headingRowHeight ??
        _headingRowHeight;
    label = Container(
      padding: padding,
      height: effectiveHeadingRowHeight,
      alignment: numeric ? Alignment.centerRight : AlignmentDirectional.centerStart,
      child: AnimatedDefaultTextStyle(
        style: DefaultTextStyle.of(context).style.merge(effectiveHeadingTextStyle),
        softWrap: false,
        duration: _sortArrowAnimationDuration,
        child: label,
      ),
    );
    if (tooltip != null) {
      label = Tooltip(message: tooltip, child: label);
    }

    // TODO(dkwingsmt): Only wrap Inkwell if onSort != null. Blocked by
    // https://github.com/flutter/flutter/issues/51152
    label = InkWell(onTap: onSort, overlayColor: overlayColor, mouseCursor: mouseCursor, child: label);
    return label;
  }

  Widget _buildDataCell({
    required BuildContext context,
    required EdgeInsetsGeometry padding,
    required Widget label,
    required bool numeric,
    required bool placeholder,
    required bool showEditIcon,
    required GestureTapCallback? onTap,
    required VoidCallback? onSelectChanged,
    required GestureTapCallback? onDoubleTap,
    required GestureLongPressCallback? onLongPress,
    required GestureTapDownCallback? onTapDown,
    required GestureTapCancelCallback? onTapCancel,
    required WidgetStateProperty<Color?>? overlayColor,
    required GestureLongPressCallback? onRowLongPress,
    required MouseCursor? mouseCursor,
  }) {
    final ThemeData themeData = Theme.of(context);
    final DataTableThemeData dataTableTheme = DataTableTheme.of(context);
    if (showEditIcon) {
      const Widget icon = Icon(Icons.edit, size: 18.0);
      label = Expanded(child: label);
      label = Row(textDirection: numeric ? TextDirection.rtl : null, children: <Widget>[label, icon]);
    }

    final TextStyle effectiveDataTextStyle =
        dataTextStyle ??
        dataTableTheme.dataTextStyle ??
        themeData.dataTableTheme.dataTextStyle ??
        themeData.textTheme.bodyMedium!;
    final double effectiveDataRowMinHeight =
        dataRowMinHeight ??
        dataTableTheme.dataRowMinHeight ??
        themeData.dataTableTheme.dataRowMinHeight ??
        kMinInteractiveDimension;
    final double effectiveDataRowMaxHeight =
        dataRowMaxHeight ??
        dataTableTheme.dataRowMaxHeight ??
        themeData.dataTableTheme.dataRowMaxHeight ??
        kMinInteractiveDimension;
    label = Container(
      padding: padding,
      constraints: BoxConstraints(minHeight: effectiveDataRowMinHeight, maxHeight: effectiveDataRowMaxHeight),
      alignment: numeric ? Alignment.centerRight : AlignmentDirectional.centerStart,
      child: DefaultTextStyle(
        style: DefaultTextStyle.of(context).style
            .merge(effectiveDataTextStyle)
            .copyWith(color: placeholder ? effectiveDataTextStyle.color!.withValues(alpha: 0.6) : null),
        child: DropdownButtonHideUnderline(child: label),
      ),
    );
    if (onTap != null || onDoubleTap != null || onLongPress != null || onTapDown != null || onTapCancel != null) {
      label = InkWell(
        onTap: onTap,
        onDoubleTap: onDoubleTap,
        onLongPress: onLongPress,
        onTapCancel: onTapCancel,
        onTapDown: onTapDown,
        overlayColor: overlayColor,
        child: label,
      );
    } else if (onSelectChanged != null || onRowLongPress != null) {
      label = TableRowInkWell(
        onTap: onSelectChanged,
        onLongPress: onRowLongPress,
        overlayColor: overlayColor,
        mouseCursor: mouseCursor,
        child: label,
      );
    }
    return TableCell(child: label);
  }

  @override
  Widget build(BuildContext context) {
    assert(!_debugInteractive || debugCheckHasMaterial(context));

    final ThemeData theme = Theme.of(context);
    final DataTableThemeData dataTableTheme = DataTableTheme.of(context);
    final WidgetStateProperty<Color?>? effectiveHeadingRowColor =
        headingRowColor ?? dataTableTheme.headingRowColor ?? theme.dataTableTheme.headingRowColor;
    final WidgetStateProperty<Color?>? effectiveDataRowColor =
        dataRowColor ?? dataTableTheme.dataRowColor ?? theme.dataTableTheme.dataRowColor;
    final WidgetStateProperty<Color?> defaultRowColor = WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return theme.colorScheme.primary.withValues(alpha: 0.08);
      }
      return null;
    });
    final bool anyRowSelectable = rows.any((row) => row.onSelectChanged != null);
    final bool displayCheckboxColumn = showCheckboxColumn && anyRowSelectable;
    final Iterable<DataRow> rowsWithCheckbox =
        displayCheckboxColumn ? rows.where((row) => row.onSelectChanged != null) : <DataRow>[];
    final Iterable<DataRow> rowsChecked = rowsWithCheckbox.where((row) => row.selected);
    final bool allChecked = displayCheckboxColumn && rowsChecked.length == rowsWithCheckbox.length;
    final bool anyChecked = displayCheckboxColumn && rowsChecked.isNotEmpty;
    final bool someChecked = anyChecked && !allChecked;
    final double effectiveHorizontalMargin =
        horizontalMargin ??
        dataTableTheme.horizontalMargin ??
        theme.dataTableTheme.horizontalMargin ??
        _horizontalMargin;
    final double effectiveCheckboxHorizontalMarginStart =
        checkboxHorizontalMargin ??
        dataTableTheme.checkboxHorizontalMargin ??
        theme.dataTableTheme.checkboxHorizontalMargin ??
        effectiveHorizontalMargin;
    final double effectiveCheckboxHorizontalMarginEnd =
        checkboxHorizontalMargin ??
        dataTableTheme.checkboxHorizontalMargin ??
        theme.dataTableTheme.checkboxHorizontalMargin ??
        effectiveHorizontalMargin / 2.0;
    final double effectiveColumnSpacing =
        columnSpacing ?? dataTableTheme.columnSpacing ?? theme.dataTableTheme.columnSpacing ?? _columnSpacing;

    final List<TableColumnWidth> tableColumns = List<TableColumnWidth>.filled(
      columns.length + (displayCheckboxColumn ? 1 : 0),
      const _NullTableColumnWidth(),
    );
    final List<TableRow> tableRows = List<TableRow>.generate(
      rows.length + 1, // the +1 is for the header row
      (index) {
        final bool isSelected = index > 0 && rows[index - 1].selected;
        final bool isDisabled = index > 0 && anyRowSelectable && rows[index - 1].onSelectChanged == null;
        final Set<WidgetState> states = <WidgetState>{
          if (isSelected) WidgetState.selected,
          if (isDisabled) WidgetState.disabled,
        };
        final Color? resolvedDataRowColor =
            index > 0 ? (rows[index - 1].color ?? effectiveDataRowColor)?.resolve(states) : null;
        final Color? resolvedHeadingRowColor = effectiveHeadingRowColor?.resolve(<WidgetState>{});
        final Color? rowColor = index > 0 ? resolvedDataRowColor : resolvedHeadingRowColor;
        final BorderSide borderSide = Divider.createBorderSide(
          context,
          width:
              dividerThickness ??
              dataTableTheme.dividerThickness ??
              theme.dataTableTheme.dividerThickness ??
              _dividerThickness,
        );
        final Border? border =
            showBottomBorder
                ? Border(bottom: borderSide)
                : index == 0
                ? null
                : Border(top: borderSide);
        return TableRow(
          key: index == 0 ? _headingRowKey : rows[index - 1].key,
          decoration: BoxDecoration(border: border, color: rowColor ?? defaultRowColor.resolve(states)),
          children: List<Widget>.filled(tableColumns.length, const _NullWidget()),
        );
      },
    );

    int rowIndex;

    int displayColumnIndex = 0;
    if (displayCheckboxColumn) {
      tableColumns[0] = FixedColumnWidth(
        effectiveCheckboxHorizontalMarginStart + Checkbox.width + effectiveCheckboxHorizontalMarginEnd,
      );
      tableRows[0].children[0] = _buildCheckbox(
        context: context,
        checked: someChecked ? null : allChecked,
        onRowTap: null,
        onCheckboxChanged: (checked) => _handleSelectAll(checked, someChecked),
        overlayColor: null,
        tristate: true,
      );
      rowIndex = 1;
      for (final DataRow row in rows) {
        final Set<WidgetState> states = <WidgetState>{if (row.selected) WidgetState.selected};
        tableRows[rowIndex].children[0] = _buildCheckbox(
          context: context,
          checked: row.selected,
          onRowTap: row.onSelectChanged == null ? null : () => row.onSelectChanged?.call(!row.selected),
          onCheckboxChanged: row.onSelectChanged,
          overlayColor: row.color ?? effectiveDataRowColor,
          rowMouseCursor: row.mouseCursor?.resolve(states) ?? dataTableTheme.dataRowCursor?.resolve(states),
          tristate: false,
        );
        rowIndex += 1;
      }
      displayColumnIndex += 1;
    }

    for (int dataColumnIndex = 0; dataColumnIndex < columns.length; dataColumnIndex += 1) {
      final DataColumn column = columns[dataColumnIndex];

      final double paddingStart = switch (dataColumnIndex) {
        0 when displayCheckboxColumn && checkboxHorizontalMargin == null => effectiveHorizontalMargin / 2.0,
        0 => effectiveHorizontalMargin,
        _ => effectiveColumnSpacing / 2.0,
      };

      final double paddingEnd;
      if (dataColumnIndex == columns.length - 1) {
        paddingEnd = effectiveHorizontalMargin;
      } else {
        paddingEnd = effectiveColumnSpacing / 2.0;
      }

      final EdgeInsetsDirectional padding = EdgeInsetsDirectional.only(start: paddingStart, end: paddingEnd);
      if (column.columnWidth != null) {
        tableColumns[displayColumnIndex] = column.columnWidth!;
      } else if (dataColumnIndex == _onlyTextColumn) {
        tableColumns[displayColumnIndex] = const IntrinsicColumnWidth(flex: 1.0);
      } else {
        tableColumns[displayColumnIndex] = const IntrinsicColumnWidth();
      }

      final Set<WidgetState> headerStates = <WidgetState>{if (column.onSort == null) WidgetState.disabled};
      tableRows[0].children[displayColumnIndex] = _buildHeadingCell(
        context: context,
        padding: padding,
        label: column.label,
        tooltip: column.tooltip,
        numeric: column.numeric,
        onSort:
            column.onSort != null
                ? () => column.onSort!(dataColumnIndex, sortColumnIndex != dataColumnIndex || !sortAscending)
                : null,
        sorted: dataColumnIndex == sortColumnIndex,
        ascending: sortAscending,
        overlayColor: effectiveHeadingRowColor,
        mouseCursor:
            column.mouseCursor?.resolve(headerStates) ?? dataTableTheme.headingCellCursor?.resolve(headerStates),
        headingRowAlignment:
            column.headingRowAlignment ?? dataTableTheme.headingRowAlignment ?? MainAxisAlignment.start,
      );
      rowIndex = 1;
      for (final DataRow row in rows) {
        final Set<WidgetState> states = <WidgetState>{if (row.selected) WidgetState.selected};
        final DataCell cell = row.cells[dataColumnIndex];
        tableRows[rowIndex].children[displayColumnIndex] = _buildDataCell(
          context: context,
          padding: padding,
          label: cell.child,
          numeric: column.numeric,
          placeholder: cell.placeholder,
          showEditIcon: cell.showEditIcon,
          onTap: cell.onTap,
          onDoubleTap: cell.onDoubleTap,
          onLongPress: cell.onLongPress,
          onTapCancel: cell.onTapCancel,
          onTapDown: cell.onTapDown,
          onSelectChanged: row.onSelectChanged == null ? null : () => row.onSelectChanged?.call(!row.selected),
          overlayColor: row.color ?? effectiveDataRowColor,
          onRowLongPress: row.onLongPress,
          mouseCursor: row.mouseCursor?.resolve(states) ?? dataTableTheme.dataRowCursor?.resolve(states),
        );
        rowIndex += 1;
      }
      displayColumnIndex += 1;
    }

    return Container(
      decoration: decoration ?? dataTableTheme.decoration ?? theme.dataTableTheme.decoration,
      child: Material(
        type: MaterialType.transparency,
        borderRadius: border?.borderRadius,
        clipBehavior: clipBehavior,
        child: Table(
          columnWidths: tableColumns.asMap(),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: tableRows,
          border: border,
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<DataColumn>('columns', columns));
    properties.add(IntProperty('sortColumnIndex', sortColumnIndex));
    properties.add(DiagnosticsProperty<bool>('sortAscending', sortAscending));
    properties.add(ObjectFlagProperty<ValueSetter<bool?>?>.has('onSelectAll', onSelectAll));
    properties.add(DiagnosticsProperty<Decoration?>('decoration', decoration));
    properties.add(DiagnosticsProperty<WidgetStateProperty<Color?>?>('dataRowColor', dataRowColor));
    properties.add(DoubleProperty('dataRowHeight', dataRowHeight));
    properties.add(DoubleProperty('dataRowMinHeight', dataRowMinHeight));
    properties.add(DoubleProperty('dataRowMaxHeight', dataRowMaxHeight));
    properties.add(DiagnosticsProperty<TextStyle?>('dataTextStyle', dataTextStyle));
    properties.add(DiagnosticsProperty<WidgetStateProperty<Color?>?>('headingRowColor', headingRowColor));
    properties.add(DoubleProperty('headingRowHeight', headingRowHeight));
    properties.add(DiagnosticsProperty<TextStyle?>('headingTextStyle', headingTextStyle));
    properties.add(DoubleProperty('horizontalMargin', horizontalMargin));
    properties.add(DoubleProperty('columnSpacing', columnSpacing));
    properties.add(DiagnosticsProperty<bool>('showCheckboxColumn', showCheckboxColumn));
    properties.add(IterableProperty<DataRow>('rows', rows));
    properties.add(DoubleProperty('dividerThickness', dividerThickness));
    properties.add(DiagnosticsProperty<bool>('showBottomBorder', showBottomBorder));
    properties.add(DoubleProperty('checkboxHorizontalMargin', checkboxHorizontalMargin));
    properties.add(DiagnosticsProperty<TableBorder?>('border', border));
    properties.add(EnumProperty<Clip>('clipBehavior', clipBehavior));
  }
}

class TableRowInkWell extends InkResponse {
  const TableRowInkWell({
    super.key,
    super.child,
    super.onTap,
    super.onDoubleTap,
    super.onLongPress,
    super.onHighlightChanged,
    super.onSecondaryTap,
    super.onSecondaryTapDown,
    super.overlayColor,
    super.mouseCursor,
  }) : super(containedInkWell: true, highlightShape: BoxShape.rectangle);

  @override
  RectCallback getRectCallback(RenderBox referenceBox) => () {
    RenderObject cell = referenceBox;
    RenderObject? table = cell.parent;
    final Matrix4 transform = Matrix4.identity();
    while (table is RenderObject && table is! RenderTable) {
      table.applyPaintTransform(cell, transform);
      assert(table == cell.parent);
      cell = table;
      table = table.parent;
    }
    if (table is RenderTable) {
      final TableCellParentData cellParentData = cell.parentData! as TableCellParentData;
      assert(cellParentData.y != null);
      final Rect rect = table.getRowBox(cellParentData.y!);
      // The rect is in the table's coordinate space. We need to change it to the
      // TableRowInkWell's coordinate space.
      table.applyPaintTransform(cell, transform);
      final Offset? offset = MatrixUtils.getAsTranslation(transform);
      if (offset != null) {
        return rect.shift(-offset);
      }
    }
    return Rect.zero;
  };

  @override
  bool debugCheckContext(BuildContext context) {
    assert(debugCheckHasTable(context));
    return super.debugCheckContext(context);
  }
}

class _SortArrow extends StatefulWidget {
  const _SortArrow({required this.visible, required this.up, required this.duration});

  final bool visible;

  final bool? up;

  final Duration duration;

  @override
  _SortArrowState createState() => _SortArrowState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('visible', visible));
    properties.add(DiagnosticsProperty<bool?>('up', up));
    properties.add(DiagnosticsProperty<Duration>('duration', duration));
  }
}

class _SortArrowState extends State<_SortArrow> with TickerProviderStateMixin {
  late final AnimationController _opacityController;
  late final CurvedAnimation _opacityAnimation;

  late final AnimationController _orientationController;
  late final Animation<double> _orientationAnimation;
  double _orientationOffset = 0.0;

  bool? _up;

  static final Animatable<double> _turnTween = Tween<double>(
    begin: 0.0,
    end: math.pi,
  ).chain(CurveTween(curve: Curves.easeIn));

  @override
  void initState() {
    super.initState();
    _up = widget.up;
    _opacityAnimation = CurvedAnimation(
      parent: _opacityController = AnimationController(duration: widget.duration, vsync: this),
      curve: Curves.fastOutSlowIn,
    )..addListener(_rebuild);
    _opacityController.value = widget.visible ? 1.0 : 0.0;
    _orientationController = AnimationController(duration: widget.duration, vsync: this);
    _orientationAnimation =
        _orientationController.drive(_turnTween)
          ..addListener(_rebuild)
          ..addStatusListener(_resetOrientationAnimation);
    if (widget.visible) {
      _orientationOffset = widget.up! ? 0.0 : math.pi;
    }
  }

  void _rebuild() {
    setState(() {
      // The animations changed, so we need to rebuild.
    });
  }

  void _resetOrientationAnimation(AnimationStatus status) {
    if (status.isCompleted) {
      assert(_orientationAnimation.value == math.pi);
      _orientationOffset += math.pi;
      _orientationController.value = 0.0; // TODO(ianh): This triggers a pointless rebuild.
    }
  }

  @override
  void didUpdateWidget(_SortArrow oldWidget) {
    super.didUpdateWidget(oldWidget);
    bool skipArrow = false;
    final bool? newUp = widget.up ?? _up;
    if (oldWidget.visible != widget.visible) {
      if (widget.visible && _opacityController.isDismissed) {
        _orientationController.stop();
        _orientationController.value = 0.0;
        _orientationOffset = newUp! ? 0.0 : math.pi;
        skipArrow = true;
      }
      if (widget.visible) {
        _opacityController.forward();
      } else {
        _opacityController.reverse();
      }
    }
    if ((_up != newUp) && !skipArrow) {
      if (_orientationController.isDismissed) {
        _orientationController.forward();
      } else {
        _orientationController.reverse();
      }
    }
    _up = newUp;
  }

  @override
  void dispose() {
    _opacityController.dispose();
    _orientationController.dispose();
    _opacityAnimation.dispose();
    super.dispose();
  }

  static const double _arrowIconBaselineOffset = -1.5;
  static const double _arrowIconSize = 16.0;

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: _opacityAnimation,
    child: Transform(
      transform: Matrix4.rotationZ(_orientationOffset + _orientationAnimation.value)
        ..setTranslationRaw(0.0, _arrowIconBaselineOffset, 0.0),
      alignment: Alignment.center,
      child: const Icon(Icons.arrow_upward, size: _arrowIconSize),
    ),
  );
}

class _NullTableColumnWidth extends TableColumnWidth {
  const _NullTableColumnWidth();

  @override
  double maxIntrinsicWidth(Iterable<RenderBox> cells, double containerWidth) => throw UnimplementedError();

  @override
  double minIntrinsicWidth(Iterable<RenderBox> cells, double containerWidth) => throw UnimplementedError();
}

class _NullWidget extends Widget {
  const _NullWidget();

  @override
  Element createElement() => throw UnimplementedError();
}
