import 'dart:io';
import 'package:path/path.dart' as path;

class WaveFileUtils {
  /// Get file name without extension
  static String getFileName(File file) => path.basenameWithoutExtension(file.path);

  /// Get file extension (e.g., "jpg", "pdf")
  static String getFileExtension(File file) => path.extension(file.path).replaceFirst('.', '');

  /// Get file size in bytes
  static Future<int> getFileSize(File file) async => file.length();

  /// Convert bytes into human-readable string
  static String formatBytes(int bytes, [int decimals = 2]) {
    if (bytes <= 0) {
      return '0 B';
    }
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    final i = (bytes != 0) ? (bytes.bitLength / 10).floor() : 0;
    final size = bytes / (1 << (10 * i));
    return '${size.toStringAsFixed(decimals)} ${suffixes[i]}';
  }
}
