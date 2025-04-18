import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
  final int? maxLines;
  final TextInputAction? textInputAction;
  final Function(String)? onChanged;
  const WaveTextFormField({
    super.key,
    this.controller,
    this.textInputAction,
    this.enabled = true,
    this.decoration,
    this.hintText,
    this.maxLines,
    this.title,
    this.keyboardType = TextInputType.text,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.readOnly = false,
    this.subtitle,
    this.onChanged,
    this.validator,
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
        TextFormField(
          onChanged: onChanged,
          maxLines: maxLines,
          style: theme.textTheme.body,
          key: key,
          validator: validator,
          textInputAction: textInputAction,
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          autovalidateMode: autovalidateMode,
          readOnly: readOnly,
          cursorErrorColor: theme.colorScheme.error,
          decoration:
              decoration ??
              InputDecoration(
                errorStyle: theme.textTheme.small.copyWith(color: theme.colorScheme.error),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                hintText: hintText,
                hintStyle: theme.textTheme.body.copyWith(color: theme.colorScheme.labelSecondary),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: theme.colorScheme.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: theme.colorScheme.border.withValues(alpha: .3)),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: theme.colorScheme.error),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: theme.colorScheme.error, width: 2),
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
