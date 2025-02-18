// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter/widgets.dart';

import 'package:waveui/material/card.dart';
import 'package:waveui/material/constants.dart';
import 'package:waveui/material/data_table.dart';
import 'package:waveui/material/data_table_source.dart';
import 'package:waveui/material/debug.dart';
import 'package:waveui/material/dropdown.dart';
import 'package:waveui/material/icon_button.dart';
import 'package:waveui/material/icons.dart';
import 'package:waveui/material/ink_decoration.dart';
import 'package:waveui/material/material_localizations.dart';
import 'package:waveui/material/material_state.dart';
import 'package:waveui/material/progress_indicator.dart';
import 'package:waveui/material/theme.dart';

class PaginatedDataTable extends StatefulWidget {
  PaginatedDataTable({
    required this.columns,
    required this.source,
    super.key,
    this.header,
    this.actions,
    this.sortColumnIndex,
    this.sortAscending = true,
    this.onSelectAll,
    @Deprecated(
      'Migrate to use dataRowMinHeight and dataRowMaxHeight instead. '
      'This feature was deprecated after v3.7.0-5.0.pre.',
    )
    double? dataRowHeight,
    double? dataRowMinHeight,
    double? dataRowMaxHeight,
    this.headingRowHeight = 56.0,
    this.horizontalMargin = 24.0,
    this.columnSpacing = 56.0,
    this.showCheckboxColumn = true,
    this.showFirstLastButtons = false,
    this.initialFirstRowIndex = 0,
    this.onPageChanged,
    this.rowsPerPage = defaultRowsPerPage,
    this.availableRowsPerPage = const <int>[
      defaultRowsPerPage,
      defaultRowsPerPage * 2,
      defaultRowsPerPage * 5,
      defaultRowsPerPage * 10,
    ],
    this.onRowsPerPageChanged,
    this.dragStartBehavior = DragStartBehavior.start,
    this.arrowHeadColor,
    this.checkboxHorizontalMargin,
    this.controller,
    this.primary,
    this.headingRowColor,
    this.dividerThickness,
    this.showEmptyRows = true,
  }) : assert(actions == null || (header != null)),
       assert(columns.isNotEmpty),
       assert(sortColumnIndex == null || (sortColumnIndex >= 0 && sortColumnIndex < columns.length)),
       assert(dataRowMinHeight == null || dataRowMaxHeight == null || dataRowMaxHeight >= dataRowMinHeight),
       assert(
         dataRowHeight == null || (dataRowMinHeight == null && dataRowMaxHeight == null),
         'dataRowHeight ($dataRowHeight) must not be set if dataRowMinHeight ($dataRowMinHeight) or dataRowMaxHeight ($dataRowMaxHeight) are set.',
       ),
       dataRowMinHeight = dataRowHeight ?? dataRowMinHeight,
       dataRowMaxHeight = dataRowHeight ?? dataRowMaxHeight,
       assert(rowsPerPage > 0),
       assert(dividerThickness == null || dividerThickness >= 0),
       assert(() {
         if (onRowsPerPageChanged != null) {
           assert(availableRowsPerPage.contains(rowsPerPage));
         }
         return true;
       }()),
       assert(
         !(controller != null && (primary ?? false)),
         'Primary ScrollViews obtain their ScrollController via inheritance from a PrimaryScrollController widget. '
         'You cannot both set primary to true and pass an explicit controller.',
       );

  final Widget? header;

  final List<Widget>? actions;

  final List<DataColumn> columns;

  final int? sortColumnIndex;

  final bool sortAscending;

  final ValueSetter<bool?>? onSelectAll;

  @Deprecated(
    'Migrate to use dataRowMinHeight and dataRowMaxHeight instead. '
    'This feature was deprecated after v3.7.0-5.0.pre.',
  )
  double? get dataRowHeight => dataRowMinHeight == dataRowMaxHeight ? dataRowMinHeight : null;

  final double? dataRowMinHeight;

  final double? dataRowMaxHeight;

  final double headingRowHeight;

  final double horizontalMargin;

  final double columnSpacing;

  final bool showCheckboxColumn;

  final bool showFirstLastButtons;

  final int? initialFirstRowIndex;

  final double? dividerThickness;

  final ValueChanged<int>? onPageChanged;

  final int rowsPerPage;

  static const int defaultRowsPerPage = 10;

  final List<int> availableRowsPerPage;

  final ValueChanged<int?>? onRowsPerPageChanged;

  final DataTableSource source;

  final DragStartBehavior dragStartBehavior;

  final double? checkboxHorizontalMargin;

  final Color? arrowHeadColor;

  final ScrollController? controller;

  final bool? primary;

  final WidgetStateProperty<Color?>? headingRowColor;

  final bool showEmptyRows;

  @override
  PaginatedDataTableState createState() => PaginatedDataTableState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<DataColumn>('columns', columns));
    properties.add(IntProperty('sortColumnIndex', sortColumnIndex));
    properties.add(DiagnosticsProperty<bool>('sortAscending', sortAscending));
    properties.add(ObjectFlagProperty<ValueSetter<bool?>?>.has('onSelectAll', onSelectAll));
    properties.add(DoubleProperty('dataRowHeight', dataRowHeight));
    properties.add(DoubleProperty('dataRowMinHeight', dataRowMinHeight));
    properties.add(DoubleProperty('dataRowMaxHeight', dataRowMaxHeight));
    properties.add(DoubleProperty('headingRowHeight', headingRowHeight));
    properties.add(DoubleProperty('horizontalMargin', horizontalMargin));
    properties.add(DoubleProperty('columnSpacing', columnSpacing));
    properties.add(DiagnosticsProperty<bool>('showCheckboxColumn', showCheckboxColumn));
    properties.add(DiagnosticsProperty<bool>('showFirstLastButtons', showFirstLastButtons));
    properties.add(IntProperty('initialFirstRowIndex', initialFirstRowIndex));
    properties.add(DoubleProperty('dividerThickness', dividerThickness));
    properties.add(ObjectFlagProperty<ValueChanged<int>?>.has('onPageChanged', onPageChanged));
    properties.add(IntProperty('rowsPerPage', rowsPerPage));
    properties.add(IterableProperty<int>('availableRowsPerPage', availableRowsPerPage));
    properties.add(ObjectFlagProperty<ValueChanged<int?>?>.has('onRowsPerPageChanged', onRowsPerPageChanged));
    properties.add(DiagnosticsProperty<DataTableSource>('source', source));
    properties.add(EnumProperty<DragStartBehavior>('dragStartBehavior', dragStartBehavior));
    properties.add(DoubleProperty('checkboxHorizontalMargin', checkboxHorizontalMargin));
    properties.add(ColorProperty('arrowHeadColor', arrowHeadColor));
    properties.add(DiagnosticsProperty<ScrollController?>('controller', controller));
    properties.add(DiagnosticsProperty<bool?>('primary', primary));
    properties.add(DiagnosticsProperty<WidgetStateProperty<Color?>?>('headingRowColor', headingRowColor));
    properties.add(DiagnosticsProperty<bool>('showEmptyRows', showEmptyRows));
  }
}

class PaginatedDataTableState extends State<PaginatedDataTable> {
  late int _firstRowIndex;
  late int _rowCount;
  late bool _rowCountApproximate;
  int _selectedRowCount = 0;
  final Map<int, DataRow?> _rows = <int, DataRow?>{};

  @protected
  @override
  void initState() {
    super.initState();
    _firstRowIndex = PageStorage.maybeOf(context)?.readState(context) as int? ?? widget.initialFirstRowIndex ?? 0;
    widget.source.addListener(_handleDataSourceChanged);
    _handleDataSourceChanged();
  }

  @protected
  @override
  void didUpdateWidget(PaginatedDataTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.source != widget.source) {
      oldWidget.source.removeListener(_handleDataSourceChanged);
      widget.source.addListener(_handleDataSourceChanged);
      _updateCaches();
    }
  }

  @protected
  @override
  void reassemble() {
    super.reassemble();
    // This function is called during hot reload.
    //
    // Normally, if the data source changes, it would notify its listeners and
    // thus trigger _handleDataSourceChanged(), which clears the row cache and
    // causes the widget to rebuild.
    //
    // During a hot reload, though, a data source can change in ways that will
    // invalidate the row cache (e.g. adding or removing columns) without ever
    // triggering a notification, leaving the PaginatedDataTable in an invalid
    // state. This method handles this case by clearing the cache any time the
    // widget is involved in a hot reload.
    _updateCaches();
  }

  @protected
  @override
  void dispose() {
    widget.source.removeListener(_handleDataSourceChanged);
    super.dispose();
  }

  void _handleDataSourceChanged() {
    setState(_updateCaches);
  }

  void _updateCaches() {
    _rowCount = widget.source.rowCount;
    _rowCountApproximate = widget.source.isRowCountApproximate;
    _selectedRowCount = widget.source.selectedRowCount;
    _rows.clear();
  }

  void pageTo(int rowIndex) {
    final int oldFirstRowIndex = _firstRowIndex;
    setState(() {
      final int rowsPerPage = widget.rowsPerPage;
      _firstRowIndex = (rowIndex ~/ rowsPerPage) * rowsPerPage;
    });
    if ((widget.onPageChanged != null) && (oldFirstRowIndex != _firstRowIndex)) {
      widget.onPageChanged!(_firstRowIndex);
    }
  }

  DataRow _getBlankRowFor(int index) =>
      DataRow.byIndex(index: index, cells: widget.columns.map<DataCell>((column) => DataCell.empty).toList());

  DataRow _getProgressIndicatorRowFor(int index) {
    bool haveProgressIndicator = false;
    final List<DataCell> cells =
        widget.columns.map<DataCell>((column) {
          if (!column.numeric) {
            haveProgressIndicator = true;
            return const DataCell(CircularProgressIndicator());
          }
          return DataCell.empty;
        }).toList();
    if (!haveProgressIndicator) {
      haveProgressIndicator = true;
      cells[0] = const DataCell(CircularProgressIndicator());
    }
    return DataRow.byIndex(index: index, cells: cells);
  }

  List<DataRow> _getRows(int firstRowIndex, int rowsPerPage) {
    final List<DataRow> result = <DataRow>[];
    final int nextPageFirstRowIndex = firstRowIndex + rowsPerPage;
    bool haveProgressIndicator = false;
    for (int index = firstRowIndex; index < nextPageFirstRowIndex; index += 1) {
      DataRow? row;
      if (index < _rowCount || _rowCountApproximate) {
        row = _rows.putIfAbsent(index, () => widget.source.getRow(index));
        if (row == null && !haveProgressIndicator) {
          row ??= _getProgressIndicatorRowFor(index);
          haveProgressIndicator = true;
        }
      }

      if (widget.showEmptyRows) {
        row ??= _getBlankRowFor(index);
      }

      if (row != null) {
        result.add(row);
      }
    }
    return result;
  }

  void _handleFirst() {
    pageTo(0);
  }

  void _handlePrevious() {
    pageTo(math.max(_firstRowIndex - widget.rowsPerPage, 0));
  }

  void _handleNext() {
    pageTo(_firstRowIndex + widget.rowsPerPage);
  }

  void _handleLast() {
    pageTo(((_rowCount - 1) / widget.rowsPerPage).floor() * widget.rowsPerPage);
  }

  bool _isNextPageUnavailable() => !_rowCountApproximate && (_firstRowIndex + widget.rowsPerPage >= _rowCount);

  final GlobalKey _tableKey = GlobalKey();

  @protected
  @override
  Widget build(BuildContext context) {
    // TODO(ianh): This whole build function doesn't handle RTL yet.
    assert(debugCheckHasMaterialLocalizations(context));
    final ThemeData themeData = Theme.of(context);
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    // HEADER
    final List<Widget> headerWidgets = <Widget>[];
    if (_selectedRowCount == 0 && widget.header != null) {
      headerWidgets.add(Expanded(child: widget.header!));
    } else if (widget.header != null) {
      headerWidgets.add(Expanded(child: Text(localizations.selectedRowCountTitle(_selectedRowCount))));
    }
    if (widget.actions != null) {
      headerWidgets.addAll(
        widget.actions!
            .map<Widget>(
              (action) => Padding(
                // 8.0 is the default padding of an icon button
                padding: const EdgeInsetsDirectional.only(start: 24.0 - 8.0 * 2.0),
                child: action,
              ),
            )
            .toList(),
      );
    }

    // FOOTER
    final TextStyle? footerTextStyle = themeData.textTheme.bodySmall;
    final List<Widget> footerWidgets = <Widget>[];
    if (widget.onRowsPerPageChanged != null) {
      final List<Widget> availableRowsPerPage =
          widget.availableRowsPerPage
              .where((value) => value <= _rowCount || value == widget.rowsPerPage)
              .map<DropdownMenuItem<int>>((value) => DropdownMenuItem<int>(value: value, child: Text('$value')))
              .toList();
      footerWidgets.addAll(<Widget>[
        // Match trailing padding, in case we overflow and end up scrolling.
        const SizedBox(width: 14.0),
        Text(localizations.rowsPerPageTitle),
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 64.0), // 40.0 for the text, 24.0 for the icon
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                items: availableRowsPerPage.cast<DropdownMenuItem<int>>(),
                value: widget.rowsPerPage,
                onChanged: widget.onRowsPerPageChanged,
                style: footerTextStyle,
              ),
            ),
          ),
        ),
      ]);
    }
    footerWidgets.addAll(<Widget>[
      const SizedBox(width: 32.0),
      Text(
        localizations.pageRowsInfoTitle(
          _firstRowIndex + 1,
          math.min(_firstRowIndex + widget.rowsPerPage, _rowCount),
          _rowCount,
          _rowCountApproximate,
        ),
      ),
      const SizedBox(width: 32.0),
      if (widget.showFirstLastButtons)
        IconButton(
          icon: Icon(Icons.skip_previous, color: widget.arrowHeadColor),
          padding: EdgeInsets.zero,
          tooltip: localizations.firstPageTooltip,
          onPressed: _firstRowIndex <= 0 ? null : _handleFirst,
        ),
      IconButton(
        icon: Icon(Icons.chevron_left, color: widget.arrowHeadColor),
        padding: EdgeInsets.zero,
        tooltip: localizations.previousPageTooltip,
        onPressed: _firstRowIndex <= 0 ? null : _handlePrevious,
      ),
      const SizedBox(width: 24.0),
      IconButton(
        icon: Icon(Icons.chevron_right, color: widget.arrowHeadColor),
        padding: EdgeInsets.zero,
        tooltip: localizations.nextPageTooltip,
        onPressed: _isNextPageUnavailable() ? null : _handleNext,
      ),
      if (widget.showFirstLastButtons)
        IconButton(
          icon: Icon(Icons.skip_next, color: widget.arrowHeadColor),
          padding: EdgeInsets.zero,
          tooltip: localizations.lastPageTooltip,
          onPressed: _isNextPageUnavailable() ? null : _handleLast,
        ),
      const SizedBox(width: 14.0),
    ]);

    // CARD
    return Card(
      semanticContainer: false,
      child: LayoutBuilder(
        builder:
            (context, constraints) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (headerWidgets.isNotEmpty)
                  Semantics(
                    container: true,
                    child: DefaultTextStyle(
                      // These typographic styles aren't quite the regular ones. We pick the closest ones from the regular
                      // list and then tweak them appropriately.
                      // See https://material.io/design/components/data-tables.html#tables-within-cards
                      style:
                          _selectedRowCount > 0
                              ? themeData.textTheme.titleMedium!.copyWith(color: themeData.colorScheme.secondary)
                              : themeData.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w400),
                      child: IconTheme.merge(
                        data: const IconThemeData(opacity: 0.54),
                        child: Ink(
                          height: 64.0,
                          color: _selectedRowCount > 0 ? themeData.secondaryHeaderColor : null,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(start: 24, end: 14.0),
                            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: headerWidgets),
                          ),
                        ),
                      ),
                    ),
                  ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  primary: widget.primary,
                  controller: widget.controller,
                  dragStartBehavior: widget.dragStartBehavior,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.minWidth),
                    child: DataTable(
                      key: _tableKey,
                      columns: widget.columns,
                      sortColumnIndex: widget.sortColumnIndex,
                      sortAscending: widget.sortAscending,
                      onSelectAll: widget.onSelectAll,
                      dividerThickness: widget.dividerThickness,
                      // Make sure no decoration is set on the DataTable
                      // from the theme, as its already wrapped in a Card.
                      decoration: const BoxDecoration(),
                      dataRowMinHeight: widget.dataRowMinHeight,
                      dataRowMaxHeight: widget.dataRowMaxHeight,
                      headingRowHeight: widget.headingRowHeight,
                      horizontalMargin: widget.horizontalMargin,
                      checkboxHorizontalMargin: widget.checkboxHorizontalMargin,
                      columnSpacing: widget.columnSpacing,
                      showCheckboxColumn: widget.showCheckboxColumn,
                      showBottomBorder: true,
                      rows: _getRows(_firstRowIndex, widget.rowsPerPage),
                      headingRowColor: widget.headingRowColor,
                    ),
                  ),
                ),
                if (!widget.showEmptyRows)
                  SizedBox(
                    height:
                        (widget.dataRowMaxHeight ?? kMinInteractiveDimension) *
                        (widget.rowsPerPage - _rowCount + _firstRowIndex).clamp(0, widget.rowsPerPage),
                  ),
                DefaultTextStyle(
                  style: footerTextStyle!,
                  child: IconTheme.merge(
                    data: const IconThemeData(opacity: 0.54),
                    child: SizedBox(
                      // TODO(bkonyi): this won't handle text zoom correctly,
                      //  https://github.com/flutter/flutter/issues/48522
                      height: 56.0,
                      child: SingleChildScrollView(
                        dragStartBehavior: widget.dragStartBehavior,
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        child: Row(children: footerWidgets),
                      ),
                    ),
                  ),
                ),
              ],
            ),
      ),
    );
  }
}
