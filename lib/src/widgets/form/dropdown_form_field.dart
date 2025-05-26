import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:waveui/waveui.dart';

class WaveDropdownFormField<T> extends StatefulWidget {
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String? hintText;
  final String? title;
  final String? subtitle;
  final String? Function(String?)? validator;
  final bool enabled;
  final bool readOnly;
  final Widget? suffixIcon;
  final AutovalidateMode autovalidateMode;
  final InputDecoration? decoration;
  final Color? backgroundColor;

  const WaveDropdownFormField({
    required this.items,
    super.key,
    this.value,
    this.onChanged,
    this.hintText,
    this.title,
    this.subtitle,
    this.validator,
    this.enabled = true,
    this.readOnly = false,
    this.suffixIcon,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.decoration,
    this.backgroundColor,
  });

  @override
  _WaveDropdownFormFieldState<T> createState() => _WaveDropdownFormFieldState<T>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<T?>('value', value))
      ..add(ObjectFlagProperty<ValueChanged<T?>?>.has('onChanged', onChanged))
      ..add(StringProperty('hintText', hintText))
      ..add(StringProperty('title', title))
      ..add(StringProperty('subtitle', subtitle))
      ..add(DiagnosticsProperty<bool>('enabled', enabled))
      ..add(DiagnosticsProperty<bool>('readOnly', readOnly))
      ..add(EnumProperty<AutovalidateMode>('autovalidateMode', autovalidateMode))
      ..add(DiagnosticsProperty<InputDecoration?>('decoration', decoration))
      ..add(ColorProperty('backgroundColor', backgroundColor))
      ..add(ObjectFlagProperty<String? Function(String? p1)?>.has('validator', validator));
  }
}

class _WaveDropdownFormFieldState<T> extends State<WaveDropdownFormField<T>> {
  late TextEditingController _searchController;
  late List<DropdownMenuItem<T>> _filteredItems;
  late WaveTheme theme;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredItems = widget.items;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    theme = WaveApp.themeOf(context);
  }

  void _filterItems(String query) {
    setState(() {
      _filteredItems =
          widget.items.where((item) {
            final String title = item.value.toString().toLowerCase();
            final String searchQuery = query.toLowerCase();
            return title.contains(searchQuery);
          }).toList();
    });
  }

  void _showModal(BuildContext context) {
    showWaveModalBottomSheet(
      context: context,
      isScrollControlled: false,
      builder:
          (context) => GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search TextField
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: WaveTextFormField(
                    controller: _searchController,
                    hintText: 'Search...',
                    onChanged: _filterItems,
                    textInputAction: TextInputAction.search,
                  ),
                ),
                const SizedBox(height: 8),
                // List of items
                Expanded(
                  child: ListView(
                    children:
                        _filteredItems
                            .map(
                              (item) => WaveListTile(
                                title: Text(item.value.toString()),
                                onTap: () {
                                  if (widget.onChanged != null) {
                                    widget.onChanged!(item.value);
                                  }
                                  Navigator.of(context).pop();
                                },
                              ),
                            )
                            .toList(),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (widget.title != null) ...[Text(widget.title!, style: theme.textTheme.h4), const SizedBox(height: 8)],
      GestureDetector(
        onTap: widget.enabled && !widget.readOnly ? () => _showModal(context) : null,
        child: AbsorbPointer(
          child: WaveTextFormField(
            controller: TextEditingController(text: widget.value?.toString()),
            hintText: widget.hintText,
            suffixIcon: widget.suffixIcon,
            autovalidateMode: widget.autovalidateMode,
            readOnly: true,
            validator: widget.validator,
          ),
        ),
      ),
      if (widget.subtitle != null) ...[const SizedBox(height: 8), Text(widget.subtitle!, style: theme.textTheme.small)],
    ],
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<WaveTheme>('theme', theme));
  }
}
