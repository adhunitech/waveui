import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:waveui/waveui.dart';

class WaveDropdownFormField<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String? hintText;
  final String? title;
  final String? subtitle;
  final String? Function(T?)? validator;
  final bool enabled;
  final bool readOnly;
  final Widget? suffixIcon;
  final AutovalidateMode autovalidateMode;
  final InputDecoration? decoration;
  final Color? backgroundColor;
  const WaveDropdownFormField({
    super.key,
    required this.items,
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
  Widget build(BuildContext context) {
    final theme = WaveApp.themeOf(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(title!, style: theme.textTheme.h4.copyWith(fontSize: 16)),
          const SizedBox(height: 8),
        ],
        ButtonTheme(
          alignedDropdown: true,
          splashColor: Colors.transparent,
          child: DropdownButtonFormField<T>(
            isExpanded: true,
            value: value,
            borderRadius: BorderRadius.circular(12),
            dropdownColor: theme.colorScheme.contentPrimary,
            style: theme.textTheme.body,
            elevation: 2,
            icon: Icon(WaveIcons.caret_down_12_filled, color: theme.colorScheme.border),
            items: items,
            onChanged: readOnly ? null : onChanged,
            validator: validator,
            autovalidateMode: autovalidateMode,
            decoration:
                decoration ??
                InputDecoration(
                  fillColor: backgroundColor ?? Colors.transparent,
                  filled: true,
                  hintText: hintText,
                  suffixIcon: suffixIcon,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  hintStyle: theme.textTheme.body.copyWith(color: theme.colorScheme.labelSecondary),
                  errorStyle: theme.textTheme.small.copyWith(color: theme.colorScheme.error),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.colorScheme.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.colorScheme.border.withValues(alpha: .3)),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.colorScheme.error),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.colorScheme.error, width: 2),
                  ),
                ),
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(subtitle!, style: theme.textTheme.small.copyWith(color: theme.colorScheme.labelTertiary)),
        ],
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<DropdownMenuItem<T>>('items', items))
      ..add(DiagnosticsProperty<T?>('value', value))
      ..add(ObjectFlagProperty<ValueChanged<T?>>.has('onChanged', onChanged))
      ..add(StringProperty('hintText', hintText))
      ..add(StringProperty('title', title))
      ..add(StringProperty('subtitle', subtitle))
      ..add(DiagnosticsProperty<bool>('enabled', enabled))
      ..add(DiagnosticsProperty<bool>('readOnly', readOnly))
      ..add(ObjectFlagProperty<String? Function(T?)?>.has('validator', validator))
      ..add(DiagnosticsProperty<AutovalidateMode>('autovalidateMode', autovalidateMode))
      ..add(DiagnosticsProperty<InputDecoration?>('decoration', decoration));
  }
}
