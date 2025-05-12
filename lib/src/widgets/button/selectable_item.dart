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
  final bool isMultiSelect;
  final bool canUnselect;
  final void Function(List<String> value)? onChanged;

  WaveSelectableItemFormField(
    BuildContext context, {
    super.key,
    required List<String> options,
    List<String>? initialValue,
    this.onChanged,
    this.canUnselect = true,
    this.isMultiSelect = true,
    super.onSaved,
    super.validator,
    AutovalidateMode super.autovalidateMode = AutovalidateMode.onUserInteraction,
  }) : super(
         initialValue: initialValue ?? [],
         builder: (state) {
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
                           List<String> updated = List<String>.from(state.value!);

                           if (isMultiSelect) {
                             if (isSelected) {
                               if (canUnselect) {
                                 updated.remove(title);
                               } else {
                                 return;
                               }
                             } else {
                               updated.add(title);
                             }
                           } else {
                             if (isSelected && !canUnselect) {
                               return;
                             }
                             updated = isSelected ? [] : [title];
                           }

                           state.didChange(updated);
                           if (onChanged != null) {
                             onChanged(updated);
                           }
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
