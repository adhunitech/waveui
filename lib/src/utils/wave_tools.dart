import 'package:get/get.dart';
import 'package:waveui/src/constants/wave_strings_constants.dart';
import 'package:waveui/src/theme/wave_theme_configurator.dart';
import 'package:flutter/material.dart';

class WaveUITools {
  const WaveUITools._();

  /// 将 icon 根据主题色变色后返回
  static Image getAssetImageWithBandColor(
    String assetFilePath, {
    String configId = GLOBAL_CONFIG_ID,
  }) {
    if (!assetFilePath.startsWith('assets')) {
      assetFilePath = 'assets/$assetFilePath';
    }
    return getAssetImageWithColor(assetFilePath, Get.theme.colorScheme.primary);
  }

  /// 将 icon 根据传入颜色变后返回
  static Image getAssetImageWithColor(String assetFilePath, Color? color) {
    if (!assetFilePath.startsWith('assets')) {
      assetFilePath = 'assets/$assetFilePath';
    }
    return Image.asset(
      assetFilePath,
      color: color,
      package: WaveStrings.flutterPackageName,
      scale: 3.0,
    );
  }

  /// [assetFilePath] assets 资源文件路径
  /// [package] 访问某个 package 里的资源，这里默认为 'waveui'
  /// [scale] 与所用的 png 资源是 icon_2x.png (scale=2.0)，icon_3x.png(scale=3.0)
  static Image getAssetImage(
    String assetFilePath, {
    BoxFit? fit,
    bool gaplessPlayback = false,
  }) {
    if (!assetFilePath.startsWith('assets')) {
      assetFilePath = 'assets/$assetFilePath';
    }
    return Image.asset(
      assetFilePath,
      package: WaveStrings.flutterPackageName,
      fit: fit,
      scale: 3.0,
      gaplessPlayback: gaplessPlayback,
    );
  }

  static Image getAssetScaleImage(String assetFilePath) {
    if (!assetFilePath.startsWith('assets')) {
      assetFilePath = 'assets/$assetFilePath';
    }
    return Image.asset(
      assetFilePath,
      package: WaveStrings.flutterPackageName,
    );
  }

  static Image getAssetSizeImage(
    String assetFilePath,
    double w,
    double h, {
    Color? color,
  }) {
    if (!assetFilePath.startsWith('assets')) {
      assetFilePath = 'assets/$assetFilePath';
    }
    return Image.asset(
      assetFilePath,
      package: WaveStrings.flutterPackageName,
//      scale: 3.0,
      width: w,
      height: h,
      color: color,
    );
  }

  /// 从16进制数字字符串，生成Color，例如EDF0F3
  static Color colorFromHexString(String? s) {
    if (s == null || s.length != 6 || int.tryParse(s, radix: 16) == null) {
      return Colors.black;
    }
    return Color(int.parse(s, radix: 16) + 0xFF000000);
  }

  /// 获取本地 [AssetImage]
  /// [assetFilePath] assets资源文件路径
  static ImageProvider getAssetImageProvider(String assetFilePath) {
    if (!assetFilePath.startsWith('assets')) {
      assetFilePath = 'assets/$assetFilePath';
    }

    final AssetImage image = AssetImage(
      assetFilePath,
      package: WaveStrings.flutterPackageName,
    );
    return image;
  }

  /// 根据 TextStyle 计算 text 宽度。
  static Size textSize(String text, TextStyle style) {
    if (isEmpty(text)) return const Size(0, 0);
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  /// 判空
  static bool isEmpty(Object? obj) {
    if (obj is String) {
      return obj.isEmpty;
    }
    if (obj is Iterable) {
      return obj.isEmpty;
    }
    if (obj is Map) {
      return obj.isEmpty;
    }
    return obj == null;
  }
}
