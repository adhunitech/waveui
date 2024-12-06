import 'package:waveui/src/theme/base/wave_base_config.dart';
import 'package:waveui/src/theme/base/wave_default_config_utils.dart';
import 'package:waveui/src/theme/base/wave_text_style.dart';
import 'package:waveui/src/theme/wave_theme_configurator.dart';
import 'package:waveui/src/theme/configs/wave_common_config.dart';

/// 强化数字展示组件配置
class WaveEnhanceNumberCardConfig extends WaveBaseConfig {
  /// 遵循外部主题配置
  /// 默认为 [WaveDefaultConfigUtils.defaultEnhanceNumberInfoConfig]
  WaveEnhanceNumberCardConfig({
    double? runningSpace,
    double? itemRunningSpace,
    WaveTextStyle? titleTextStyle,
    WaveTextStyle? descTextStyle,
    double? dividerWidth,
    String configId = GLOBAL_CONFIG_ID,
  })  : _runningSpace = runningSpace,
        _itemRunningSpace = itemRunningSpace,
        _titleTextStyle = titleTextStyle,
        _descTextStyle = descTextStyle,
        _dividerWidth = dividerWidth,
        super(configId: configId);

  /// 如果超过一行，行间距
  double? _runningSpace;

  double get runningSpace =>
      _runningSpace ??
      WaveDefaultConfigUtils.defaultEnhanceNumberInfoConfig.runningSpace;

  /// Item的上半部分和下半部分的间距
  double? _itemRunningSpace;

  double get itemRunningSpace =>
      _itemRunningSpace ??
      WaveDefaultConfigUtils.defaultEnhanceNumberInfoConfig.itemRunningSpace;

  double? _dividerWidth;

  double get dividerWidth =>
      _dividerWidth ??
      WaveDefaultConfigUtils.defaultEnhanceNumberInfoConfig.dividerWidth;
  WaveTextStyle? _titleTextStyle;

  WaveTextStyle get titleTextStyle =>
      _titleTextStyle ??
      WaveDefaultConfigUtils.defaultEnhanceNumberInfoConfig.titleTextStyle;
  WaveTextStyle? _descTextStyle;

  WaveTextStyle get descTextStyle =>
      _descTextStyle ??
      WaveDefaultConfigUtils.defaultEnhanceNumberInfoConfig.descTextStyle;

  @override
  void initThemeConfig(
    String configId, {
    WaveCommonConfig? currentLevelCommonConfig,
  }) {
    super.initThemeConfig(
      configId,
      currentLevelCommonConfig: currentLevelCommonConfig,
    );

    WaveEnhanceNumberCardConfig userConfig = WaveThemeConfigurator.instance
        .getConfig(configId: configId)
        .enhanceNumberCardConfig;

    _runningSpace ??= userConfig._runningSpace;
    _itemRunningSpace ??= userConfig._itemRunningSpace;
    _dividerWidth ??= userConfig._dividerWidth;
    _titleTextStyle = userConfig.titleTextStyle.merge(
      WaveTextStyle(color: commonConfig.colorTextBase).merge(_titleTextStyle),
    );
    _descTextStyle = userConfig.descTextStyle.merge(
      WaveTextStyle(color: commonConfig.colorTextSecondary)
          .merge(_descTextStyle),
    );
  }

  WaveEnhanceNumberCardConfig copyWith({
    double? runningSpace,
    double? itemRunningSpace,
    double? dividerWidth,
    WaveTextStyle? titleTextStyle,
    WaveTextStyle? descTextStyle,
  }) {
    return WaveEnhanceNumberCardConfig(
      runningSpace: runningSpace ?? _runningSpace,
      itemRunningSpace: itemRunningSpace ?? _itemRunningSpace,
      dividerWidth: dividerWidth ?? _dividerWidth,
      titleTextStyle: titleTextStyle ?? _titleTextStyle,
      descTextStyle: descTextStyle ?? _descTextStyle,
    );
  }

  WaveEnhanceNumberCardConfig merge(WaveEnhanceNumberCardConfig? other) {
    if (other == null) return this;
    return copyWith(
      runningSpace: other._runningSpace,
      itemRunningSpace: other._itemRunningSpace,
      dividerWidth: other._dividerWidth,
      titleTextStyle: titleTextStyle.merge(other._titleTextStyle),
      descTextStyle: descTextStyle.merge(other._descTextStyle),
    );
  }
}
