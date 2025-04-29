import 'package:flutter/widgets.dart';
import 'package:waveui/waveui.dart';

class WaveFilePicker extends StatelessWidget {
  final String maxFileSize;
  final List<String> supportedFileTypes;
  final Function()? onTap;
  final List<WaveFilePickerItem> pickerItems;
  const WaveFilePicker({
    required this.pickerItems,
    super.key,
    this.maxFileSize = '5MB',
    this.supportedFileTypes = const ['PDF', 'PNG', 'JPEG'],
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = WaveApp.themeOf(context);
    return Column(
      children: [
        WaveTappable(
          onTap: onTap,
          scale: .98,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.05),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                children: [
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    ),
                    child: Icon(
                      WaveIcons.cloud_arrow_up_24_filled,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Click here to pick files',
                    style: theme.textTheme.small.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${supportedFileTypes.length > 1 ? '${supportedFileTypes.sublist(0, supportedFileTypes.length - 1).join(', ').toUpperCase()} and ${supportedFileTypes.last.toUpperCase()}' : supportedFileTypes.join().toUpperCase()} (max. $maxFileSize)",
                    style: theme.textTheme.small.copyWith(
                      color: theme.colorScheme.labelSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Column(
          children:
              pickerItems
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: e,
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }
}
