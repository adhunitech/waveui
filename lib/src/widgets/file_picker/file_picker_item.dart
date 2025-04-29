import 'dart:io';
import 'package:flutter/material.dart';
import 'package:waveui/waveui.dart';

class WaveFilePickerItem extends StatefulWidget {
  final File file;
  final Function()? onDelete;
  const WaveFilePickerItem({
    required this.file,
    super.key,
    required this.onDelete,
  });

  @override
  State<WaveFilePickerItem> createState() => _WaveFilePickerItemState();
}

class _WaveFilePickerItemState extends State<WaveFilePickerItem> {
  late Future<_FileInfo> _fileInfoFuture;

  @override
  void initState() {
    super.initState();
    _fileInfoFuture = _loadFileInfo();
  }

  Future<_FileInfo> _loadFileInfo() async {
    final size = await WaveFileUtils.getFileSize(widget.file);
    final name = WaveFileUtils.getFileName(widget.file);
    final extension = WaveFileUtils.getFileExtension(widget.file);
    return _FileInfo(
      name: name,
      extension: extension,
      readableSize: WaveFileUtils.formatBytes(size),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = WaveApp.themeOf(context);

    return FutureBuilder<_FileInfo>(
      future: _fileInfoFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final fileInfo = snapshot.data!;
        final icon = _getIconForExtension(fileInfo.extension.toUpperCase());

        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.colorScheme.divider),
          ),
          child: WaveListTile(
            tileColor: const Color(0x00000000),
            title: Text(fileInfo.name),
            subtitle: Text(fileInfo.readableSize),
            trailing: WaveTappable(
              onTap: widget.onDelete,
              scale: .9,
              child: const Icon(WaveIcons.delete_24_regular, size: 20),
            ),
            leading: SizedBox(
              height: 45,
              width: 45,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(icon, color: theme.colorScheme.onPrimary),
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getIconForExtension(String extension) {
    switch (extension) {
      case 'PNG':
      case 'JPG':
      case 'JPEG':
        return WaveIcons.image_24_regular;
      case 'PDF':
      case 'TXT':
        return WaveIcons.book_24_regular;
      default:
        return WaveIcons.document_24_regular;
    }
  }
}

class _FileInfo {
  final String name;
  final String extension;
  final String readableSize;

  _FileInfo({
    required this.name,
    required this.extension,
    required this.readableSize,
  });
}
