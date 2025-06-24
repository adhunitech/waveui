import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waveui/waveui.dart';

class WaveTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final bool enabled;
  final InputDecoration? decoration;
  final String? hintText;
  final String? title;
  final bool readOnly;
  final TextInputType? keyboardType;
  final AutovalidateMode autovalidateMode;
  final String? subtitle;
  final String? Function(String?)? validator;
  final int maxLines;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? initialValue;
  final Function(String)? onChanged;
  final bool autofocus;
  final String? suffixText;
  final String? errorText;
  final FocusNode? focusNode;
  final Function(String?)? onSaved;
  final Function(String)? onFieldSubmitted;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  const WaveTextFormField({
    super.key,
    this.inputFormatters,
    this.autofillHints,
    this.controller,
    this.initialValue,
    this.textInputAction,
    this.enabled = true,
    this.decoration,
    this.obscureText = false,
    this.hintText,
    this.suffixText,
    this.errorText,
    this.maxLength,
    this.suffixIcon,
    this.prefixIcon,
    this.maxLines = 1,
    this.title,
    this.keyboardType = TextInputType.text,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.readOnly = false,
    this.subtitle,
    this.onChanged,
    this.validator,
    this.autofocus = false,
    this.focusNode,
    this.onSaved,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = WaveTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(title!, style: theme.textTheme.h4.copyWith(fontSize: 16)),
          const SizedBox(height: 8),
        ],
        TextFormField(
          inputFormatters: inputFormatters,
          autofillHints: autofillHints,
          autofocus: autofocus,
          focusNode: focusNode,
          initialValue: initialValue,
          obscureText: obscureText,
          onChanged: onChanged,
          maxLines: maxLines,
          maxLength: maxLength,
          onSaved: onSaved,
          style: theme.textTheme.body,
          key: key,
          validator: validator,
          textInputAction: textInputAction,
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          onFieldSubmitted: onFieldSubmitted,
          autovalidateMode: autovalidateMode,
          readOnly: readOnly,
          cursorErrorColor: theme.colorScheme.statusError,
          decoration:
              decoration ??
              InputDecoration(
                suffixIcon: suffixIcon,
                prefixIcon: prefixIcon,
                errorText: errorText,
                suffixText: suffixText,
                errorStyle: theme.textTheme.small.copyWith(color: theme.colorScheme.statusError),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                hintText: hintText,
                hintStyle: theme.textTheme.body.copyWith(color: theme.colorScheme.textSecondary),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: theme.colorScheme.outlineStandard),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: theme.colorScheme.brandPrimary, width: 2),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: theme.colorScheme.outlineStandard.withValues(alpha: .3)),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: theme.colorScheme.statusError),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: theme.colorScheme.statusError, width: 2),
                ),
              ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(subtitle!, style: theme.textTheme.small.copyWith(color: theme.colorScheme.textTertiary)),
        ],
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<TextEditingController?>('controller', controller))
      ..add(DiagnosticsProperty<bool>('enabled', enabled))
      ..add(DiagnosticsProperty<InputDecoration?>('decoration', decoration))
      ..add(StringProperty('hintText', hintText))
      ..add(StringProperty('title', title))
      ..add(DiagnosticsProperty<bool>('readOnly', readOnly))
      ..add(DiagnosticsProperty<TextInputType?>('keyboardType', keyboardType))
      ..add(EnumProperty<AutovalidateMode>('autovalidateMode', autovalidateMode))
      ..add(StringProperty('subtitle', subtitle))
      ..add(ObjectFlagProperty<String? Function(String? p1)?>.has('validator', validator))
      ..add(IntProperty('maxLines', maxLines))
      ..add(EnumProperty<TextInputAction?>('textInputAction', textInputAction))
      ..add(ObjectFlagProperty<Function(String p1)?>.has('onChanged', onChanged));
  }
}
