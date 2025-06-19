import 'dart:io';
import 'package:flutter/material.dart';
import 'package:waveui/waveui.dart';

class WaveFilePickerItem extends StatefulWidget {
  final dynamic source;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;
  final bool isUrl;

  const WaveFilePickerItem({required this.source, this.onDelete, this.onTap, super.key, this.isUrl = false});

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

  String _getExtensionFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final path = uri.path;
      return path.contains('.') ? path.split('.').last.toLowerCase() : '';
    } catch (_) {
      return '';
    }
  }

  String _getNameFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final path = uri.path;
      return path.split('/').last;
    } catch (_) {
      return url;
    }
  }

  Future<_FileInfo> _loadFileInfo() async {
    try {
      if (widget.isUrl) {
        if (widget.source == null || widget.source is! String) {
          throw Exception('Invalid URL');
        }
        final url = widget.source as String;
        if (url.trim().isEmpty) {
          throw Exception('URL cannot be empty');
        }

        final name = _getNameFromUrl(url);
        final extension = _getExtensionFromUrl(url);

        return _FileInfo(name: name.isEmpty ? url : name, extension: extension, readableSize: 'URL Resource');
      } else {
        if (widget.source == null || widget.source is! File) {
          throw Exception('Invalid file');
        }
        final file = widget.source as File;
        if (!file.existsSync()) {
          throw Exception('File does not exist');
        }
        final size = await WaveFileUtils.getFileSize(file);
        final name = WaveFileUtils.getFileName(file);
        final extension = WaveFileUtils.getFileExtension(file);
        return _FileInfo(
          name: name.isEmpty ? 'Unknown' : name,
          extension: extension,
          readableSize: WaveFileUtils.formatBytes(size),
        );
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = WaveApp.themeOf(context);

    return FutureBuilder<_FileInfo>(
      future: _fileInfoFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)));
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.colorScheme.error),
            ),
            child: WaveListTile(
              tileColor: theme.colorScheme.error.withOpacity(0.1),
              title: const Text('Error Loading Resource'),
              subtitle: Text(snapshot.error?.toString() ?? 'Unknown error'),
              trailing:
                  widget.onDelete != null
                      ? WaveTappable(
                        onTap: widget.onDelete,
                        scale: .9,
                        child: const Icon(WaveIcons.delete_24_regular, size: 20),
                      )
                      : null,
              leading: SizedBox(
                height: 45,
                width: 45,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: theme.colorScheme.error, borderRadius: BorderRadius.circular(30)),
                  child: Icon(WaveIcons.dismiss_24_regular, color: theme.colorScheme.onPrimary),
                ),
              ),
            ),
          );
        }

        final fileInfo = snapshot.data!;
        final icon = _getIconForExtension(fileInfo.extension.toUpperCase());

        return WaveListTile(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.divider),
          title: Text(fileInfo.name),
          subtitle: Text(widget.isUrl ? 'URL Resource' : fileInfo.readableSize),
          trailing:
              widget.onDelete != null
                  ? WaveTappable(
                    onTap: widget.onDelete,
                    scale: .9,
                    child: const Icon(WaveIcons.delete_24_regular, size: 20),
                  )
                  : null,
          leading: SizedBox(
            height: 45,
            width: 45,
            child: DecoratedBox(
              decoration: BoxDecoration(color: theme.colorScheme.primary, borderRadius: BorderRadius.circular(30)),
              child: Icon(icon, color: theme.colorScheme.onPrimary),
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
      case 'MP3':
      case 'WAV':
      case 'OGG':
        return WaveIcons.sound_source_24_regular;
      case 'MP4':
      case 'MOV':
      case 'AVI':
        return WaveIcons.video_24_regular;
      default:
        return widget.isUrl ? WaveIcons.link_24_regular : WaveIcons.document_24_regular;
    }
  }
}

class _FileInfo {
  final String name;
  final String extension;
  final String readableSize;

  _FileInfo({required this.name, required this.extension, required this.readableSize});
}
