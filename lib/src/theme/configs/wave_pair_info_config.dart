import 'package:get/get.dart';
import 'package:waveui/src/theme/base/wave_base_config.dart';
import 'package:waveui/src/theme/base/wave_default_config_utils.dart';
import 'package:waveui/src/theme/base/wave_text_style.dart';
import 'package:waveui/src/theme/wave_theme_configurator.dart';
import 'package:waveui/src/theme/configs/wave_common_config.dart';

/// WavePairInfoTable 的配置文件 全局配置
class WavePairInfoTableConfig extends WaveBaseConfig {
  /// 遵循外部主题配置
  /// 默认为 [WaveDefaultConfigUtils.defaultPairInfoTableConfig]
  WavePairInfoTableConfig({
    double? rowSpacing,
    double? itemSpacing,
    WaveTextStyle? keyTextStyle,
    WaveTextStyle? valueTextStyle,
    WaveTextStyle? linkTextStyle,
    String configId = GLOBAL_CONFIG_ID,
  })  : _rowSpacing = rowSpacing,
        _itemSpacing = itemSpacing,
        _keyTextStyle = keyTextStyle,
        _valueTextStyle = valueTextStyle,
        _linkTextStyle = linkTextStyle,
        super(configId: configId);

  /// 行间距 纵向
  double? _rowSpacing;

  /// WaveInfoModal 属性配置 行间距
  double? _itemSpacing;

  /// WaveInfoModal key文字样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextSecondary],
  ///   fontSize: [WaveCommonConfig.fontSizeBase],
  ///   fontWeight: FontWeight.w400,
  /// )
  WaveTextStyle? _keyTextStyle;

  /// WaveInfoModal value文字样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextBase],
  ///   fontSize: [WaveCommonConfig.fontSizeBase],
  ///   fontWeight: FontWeight.w400,
  /// )
  WaveTextStyle? _valueTextStyle;

  /// WaveInfoModal 链接文字样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveGet.theme.colorScheme.primary],
  ///   fontWeight: FontWeight.w400,
  ///   fontSize: [WaveCommonConfig.fontSizeBase]
  /// )
  WaveTextStyle? _linkTextStyle;

  double get rowSpacing =>
      _rowSpacing ??
      WaveDefaultConfigUtils.defaultPairInfoTableConfig.rowSpacing;

  double get itemSpacing =>
      _itemSpacing ??
      WaveDefaultConfigUtils.defaultPairInfoTableConfig.itemSpacing;

  WaveTextStyle get keyTextStyle =>
      _keyTextStyle ??
      WaveDefaultConfigUtils.defaultPairInfoTableConfig.keyTextStyle;

  WaveTextStyle get valueTextStyle =>
      _valueTextStyle ??
      WaveDefaultConfigUtils.defaultPairInfoTableConfig.valueTextStyle;

  WaveTextStyle get linkTextStyle =>
      _linkTextStyle ??
      WaveDefaultConfigUtils.defaultPairInfoTableConfig.linkTextStyle;

  @override
  void initThemeConfig(
    String configId, {
    WaveCommonConfig? currentLevelCommonConfig,
  }) {
    super.initThemeConfig(
      configId,
      currentLevelCommonConfig: currentLevelCommonConfig,
    );

    /// 用户全局组件配置
    WavePairInfoTableConfig pairInfoTableConfig = WaveThemeConfigurator.instance
        .getConfig(configId: configId)
        .pairInfoTableConfig;

    _rowSpacing ??= pairInfoTableConfig._rowSpacing;
    _keyTextStyle = pairInfoTableConfig.keyTextStyle.merge(
      WaveTextStyle(
        color: commonConfig.colorTextSecondary,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_keyTextStyle),
    );
    _valueTextStyle = pairInfoTableConfig.valueTextStyle.merge(
      WaveTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_valueTextStyle),
    );
    _linkTextStyle = pairInfoTableConfig.linkTextStyle.merge(
      WaveTextStyle(
        color: Get.theme.colorScheme.primary,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_linkTextStyle),
    );
    _itemSpacing ??= pairInfoTableConfig._itemSpacing;
  }

  WavePairInfoTableConfig copyWith({
    double? rowSpacing,
    double? itemSpacing,
    WaveTextStyle? keyTextStyle,
    WaveTextStyle? valueTextStyle,
    WaveTextStyle? linkTextStyle,
  }) {
    return WavePairInfoTableConfig(
      rowSpacing: rowSpacing ?? _rowSpacing,
      itemSpacing: itemSpacing ?? _itemSpacing,
      keyTextStyle: keyTextStyle ?? _keyTextStyle,
      valueTextStyle: valueTextStyle ?? _valueTextStyle,
      linkTextStyle: linkTextStyle ?? _linkTextStyle,
    );
  }

  WavePairInfoTableConfig merge(WavePairInfoTableConfig? other) {
    if (other == null) return this;
    return copyWith(
      rowSpacing: other._rowSpacing,
      itemSpacing: other._itemSpacing,
      keyTextStyle: keyTextStyle.merge(other._keyTextStyle),
      valueTextStyle: valueTextStyle.merge(other._valueTextStyle),
      linkTextStyle: linkTextStyle.merge(other._linkTextStyle),
    );
  }
}

class WavePairRichInfoGridConfig extends WaveBaseConfig {
  /// 遵循外部主题配置
  /// 默认为 [WaveDefaultConfigUtils.defaultPairRichInfoGridConfig]
  WavePairRichInfoGridConfig({
    double? rowSpacing,
    double? itemSpacing,
    double? itemHeight,
    WaveTextStyle? keyTextStyle,
    WaveTextStyle? valueTextStyle,
    WaveTextStyle? linkTextStyle,
    String configId = GLOBAL_CONFIG_ID,
  })  : _rowSpacing = rowSpacing,
        _itemSpacing = itemSpacing,
        _itemHeight = itemHeight,
        _keyTextStyle = keyTextStyle,
        _valueTextStyle = valueTextStyle,
        _linkTextStyle = linkTextStyle,
        super(configId: configId);

  /// 行间距 纵向
  double? _rowSpacing;

  /// 元素间距 横向
  double? _itemSpacing;

  /// 元素高度
  double? _itemHeight;

  /// key文字样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextSecondary],
  ///   fontSize: [WaveCommonConfig.fontSizeBase],
  ///   fontWeight: FontWeight.w400,
  /// )
  WaveTextStyle? _keyTextStyle;

  /// value文字样式
  ///
  /// WaveTextStyle(
  ///   fontWeight: FontWeight.w400,
  ///   color: [WaveCommonConfig.colorTextBase],
  ///   fontSize: [WaveCommonConfig.fontSizeBase],
  /// )
  WaveTextStyle? _valueTextStyle;

  /// 链接文字样式
  ///
  /// WaveTextStyle(
  ///   fontWeight: FontWeight.w400,
  ///   color: [WaveGet.theme.colorScheme.primary],
  ///   fontSize: [WaveCommonConfig.fontSizeBase],
  /// )
  WaveTextStyle? _linkTextStyle;

  double get rowSpacing =>
      _rowSpacing ??
      WaveDefaultConfigUtils.defaultPairRichInfoGridConfig.rowSpacing;

  double get itemSpacing =>
      _itemSpacing ??
      WaveDefaultConfigUtils.defaultPairRichInfoGridConfig.itemSpacing;

  double get itemHeight =>
      _itemHeight ??
      WaveDefaultConfigUtils.defaultPairRichInfoGridConfig.itemHeight;

  WaveTextStyle get keyTextStyle =>
      _keyTextStyle ??
      WaveDefaultConfigUtils.defaultPairRichInfoGridConfig.keyTextStyle;

  WaveTextStyle get valueTextStyle =>
      _valueTextStyle ??
      WaveDefaultConfigUtils.defaultPairRichInfoGridConfig.valueTextStyle;

  WaveTextStyle get linkTextStyle =>
      _linkTextStyle ??
      WaveDefaultConfigUtils.defaultPairRichInfoGridConfig.linkTextStyle;

  @override
  void initThemeConfig(
    String configId, {
    WaveCommonConfig? currentLevelCommonConfig,
  }) {
    super.initThemeConfig(
      configId,
      currentLevelCommonConfig: currentLevelCommonConfig,
    );

    /// 用户全局组件配置
    WavePairRichInfoGridConfig pairRichInfoGridConfig = WaveThemeConfigurator
        .instance
        .getConfig(configId: configId)
        .pairRichInfoGridConfig;

    _rowSpacing ??= pairRichInfoGridConfig._rowSpacing;
    _itemSpacing ??= pairRichInfoGridConfig._itemSpacing;
    _itemHeight ??= pairRichInfoGridConfig._itemHeight;
    _keyTextStyle = pairRichInfoGridConfig.keyTextStyle.merge(
      WaveTextStyle(
        color: commonConfig.colorTextSecondary,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_keyTextStyle),
    );
    _valueTextStyle = pairRichInfoGridConfig.valueTextStyle.merge(
      WaveTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_valueTextStyle),
    );
    _linkTextStyle = pairRichInfoGridConfig.linkTextStyle.merge(
      WaveTextStyle(
        color: Get.theme.colorScheme.primary,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_linkTextStyle),
    );
  }

  WavePairRichInfoGridConfig copyWith({
    double? rowSpacing,
    double? itemSpacing,
    double? itemHeight,
    WaveTextStyle? keyTextStyle,
    WaveTextStyle? valueTextStyle,
    WaveTextStyle? linkTextStyle,
    WaveTextStyle? titleTextsStyle,
  }) {
    return WavePairRichInfoGridConfig(
      rowSpacing: rowSpacing ?? _rowSpacing,
      itemSpacing: itemSpacing ?? _itemSpacing,
      itemHeight: itemHeight ?? _itemHeight,
      keyTextStyle: keyTextStyle ?? _keyTextStyle,
      valueTextStyle: valueTextStyle ?? _valueTextStyle,
      linkTextStyle: linkTextStyle ?? _linkTextStyle,
    );
  }

  WavePairRichInfoGridConfig merge(WavePairRichInfoGridConfig? other) {
    if (other == null) return this;
    return copyWith(
      rowSpacing: other._rowSpacing,
      itemSpacing: other._itemSpacing,
      itemHeight: other._itemHeight,
      keyTextStyle: keyTextStyle.merge(other._keyTextStyle),
      valueTextStyle: valueTextStyle.merge(other._valueTextStyle),
      linkTextStyle: linkTextStyle.merge(other._linkTextStyle),
    );
  }
}
