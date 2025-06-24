import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:waveui/waveui.dart';

class WaveSelectableItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback? onTap;
  const WaveSelectableItem({required this.title, required this.isSelected, super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = WaveTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    return WaveTappable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.brandPrimary.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? colorScheme.brandPrimary : colorScheme.outlineStandard),
        ),
        child: Text(
          title,
          style: textTheme.small.copyWith(color: isSelected ? colorScheme.brandPrimary : colorScheme.textPrimary),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('title', title))
      ..add(DiagnosticsProperty<bool>('isSelected', isSelected))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap));
  }
}

class WaveSelectableItemFormField extends FormField<List<String>> {
  final bool isMultiSelect;
  final bool canUnselect;
  final void Function(List<String> value)? onChanged;

  WaveSelectableItemFormField(
    BuildContext context, {
    required List<String> options,
    super.key,
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
           final theme = WaveTheme.of(context);
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
                   child: Text(
                     state.errorText!,
                     style: theme.textTheme.small.copyWith(color: theme.colorScheme.statusError),
                   ),
                 ),
             ],
           );
         },
       );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('isMultiSelect', isMultiSelect))
      ..add(DiagnosticsProperty<bool>('canUnselect', canUnselect))
      ..add(ObjectFlagProperty<void Function(List<String> value)?>.has('onChanged', onChanged));
  }
}
