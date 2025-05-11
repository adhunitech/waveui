import 'package:flutter/material.dart';
import 'package:waveui/waveui.dart';

class WaveSelectableItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback? onTap;
  const WaveSelectableItem({super.key, required this.title, required this.isSelected, this.onTap});

  @override
  Widget build(BuildContext context) {
    var theme = WaveApp.themeOf(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    return WaveTappable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? colorScheme.primary : colorScheme.border),
        ),
        child: Text(
          title,
          style: textTheme.small.copyWith(color: isSelected ? colorScheme.primary : colorScheme.labelPrimary),
        ),
      ),
    );
  }
}

class WaveSelectableItemFormField extends FormField<List<String>> {
  WaveSelectableItemFormField(
    BuildContext context, {
    super.key,
    required List<String> options,
    List<String>? initialValue,
    super.onSaved,
    super.validator,
    AutovalidateMode super.autovalidateMode = AutovalidateMode.disabled,
  }) : super(
         initialValue: initialValue ?? [],
         builder: (FormFieldState<List<String>> state) {
           final theme = WaveApp.themeOf(context);
           return Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Wrap(
                 spacing: 8,
                 runSpacing: 8,
                 children:
                     options.map((title) {
                       final isSelected = state.value!.contains(title);
                       return WaveSelectableItem(
                         title: title,
                         isSelected: isSelected,
                         onTap: () {
                           final updated = List<String>.from(state.value!);
                           isSelected ? updated.remove(title) : updated.add(title);
                           state.didChange(updated);
                         },
                       );
                     }).toList(),
               ),
               if (state.hasError)
                 Padding(
                   padding: const EdgeInsets.only(top: 8.0),
                   child: Text(state.errorText!, style: theme.textTheme.small.copyWith(color: theme.colorScheme.error)),
                 ),
             ],
           );
         },
       );
}
