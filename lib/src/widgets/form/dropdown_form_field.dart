import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Icons, Theme;
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
  WaveDropdownFormFieldState<T> createState() => WaveDropdownFormFieldState<T>();

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

class WaveDropdownFormFieldState<T> extends State<WaveDropdownFormField<T>> {
  late TextEditingController _searchController;
  late Theme theme;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    theme = Theme.of(context);
  }

  void _showModal(BuildContext context, FormFieldState<T> formFieldState) {
    showWaveModalBottomSheet(
      context: context,
      builder: (context) {
        final bottomInset = MediaQuery.of(context).viewInsets.bottom;
        List<DropdownMenuItem<T>> localFilteredItems = widget.items;

        return StatefulBuilder(
          builder: (context, modalSetState) {
            _searchController.addListener(() {
              final query = _searchController.text.toLowerCase();
              modalSetState(() {
                localFilteredItems =
                    widget.items.where((item) {
                      final label = (item.child as Text?)?.data?.toLowerCase() ?? item.value.toString().toLowerCase();
                      return label.contains(query);
                    }).toList();
              });
            });

            return Padding(
              padding: EdgeInsets.only(bottom: bottomInset),
              child: FractionallySizedBox(
                heightFactor: 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: WaveTextFormField(
                        controller: _searchController,
                        hintText: 'Search...',
                        textInputAction: TextInputAction.search,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: localFilteredItems.length,
                        itemBuilder: (context, index) {
                          final item = localFilteredItems[index];
                          return WaveListTile(
                            title: item.child,
                            onTap: () {
                              formFieldState.didChange(item.value); // ✅ Notify form of change
                              widget.onChanged?.call(item.value);
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => FormField<T>(
    initialValue: widget.value,
    validator: (val) => widget.validator?.call(val?.toString()),
    autovalidateMode: widget.autovalidateMode,
    builder:
        (formFieldState) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.title != null) ...[
              Text(widget.title!, style: theme.textTheme.h4.copyWith(fontSize: 16)),
              const SizedBox(height: 8),
            ],
            GestureDetector(
              onTap: widget.enabled ? () => _showModal(context, formFieldState) : null,
              child: InputDecorator(
                decoration:
                    widget.decoration ??
                    InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: theme.colorScheme.outlineStandard),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      errorText: formFieldState.errorText,
                      suffixIcon:
                          widget.suffixIcon ??
                          Icon(Icons.caret_down_12_filled, color: theme.colorScheme.outlineStandard),
                      enabled: widget.enabled,
                      filled: widget.backgroundColor != null,
                      fillColor: widget.backgroundColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: theme.colorScheme.outlineStandard),
                      ),
                    ),
                isEmpty: widget.value == null,
                child:
                    widget.items
                        .firstWhere(
                          (item) => item.value == widget.value,
                          orElse:
                              () => DropdownMenuItem<T>(
                                value: null,
                                child: Text(
                                  widget.hintText ?? '',
                                  style: theme.textTheme.small.copyWith(color: theme.colorScheme.outlineStandard),
                                ),
                              ),
                        )
                        .child,
              ),
            ),
            if (widget.subtitle != null) ...[
              const SizedBox(height: 8),
              Text(widget.subtitle!, style: theme.textTheme.small),
            ],
          ],
        ),
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Theme>('theme', theme));
  }
}
