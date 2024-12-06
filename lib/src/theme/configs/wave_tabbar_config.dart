import 'package:get/get.dart';
import 'package:waveui/src/theme/base/wave_base_config.dart';
import 'package:waveui/src/theme/base/wave_default_config_utils.dart';
import 'package:waveui/src/theme/base/wave_text_style.dart';
import 'package:waveui/src/theme/wave_theme_configurator.dart';
import 'package:waveui/src/theme/configs/wave_common_config.dart';
import 'package:flutter/material.dart';

/// TabBar配置类
class WaveTabBarConfig extends WaveBaseConfig {
  /// 遵循外部主题配置
  /// 默认为 [WaveDefaultConfigUtils.tabBarConfig]
  WaveTabBarConfig({
    double? tabHeight,
    double? indicatorHeight,
    double? indicatorWidth,
    WaveTextStyle? labelStyle,
    WaveTextStyle? unselectedLabelStyle,
    Color? backgroundColor,
    WaveTextStyle? tagNormalTextStyle,
    Color? tagNormalBgColor,
    WaveTextStyle? tagSelectedTextStyle,
    Color? tagSelectedBgColor,
    double? tagRadius,
    double? tagSpacing,
    int? preLineTagCount,
    double? tagHeight,
    String configId = GLOBAL_CONFIG_ID,
  })  : _tabHeight = tabHeight,
        _indicatorHeight = indicatorHeight,
        _indicatorWidth = indicatorWidth,
        _labelStyle = labelStyle,
        _unselectedLabelStyle = unselectedLabelStyle,
        _backgroundColor = backgroundColor,
        _tagNormalTextStyle = tagNormalTextStyle,
        _tagNormalBgColor = tagNormalBgColor,
        _tagSelectedTextStyle = tagSelectedTextStyle,
        _tagSelectedBgColor = tagSelectedBgColor,
        _tagRadius = tagRadius,
        _tagSpacing = tagSpacing,
        _preLineTagCount = preLineTagCount,
        _tagHeight = tagHeight,
        super(configId: configId);

  /// TabBar 的整体高度
  /// 默认为 50
  double? _tabHeight;

  /// 指示器的高度
  /// 默认为 2
  double? _indicatorHeight;

  /// 指示器的宽度
  /// 默认为 24
  double? _indicatorWidth;

  /// 选中 Tab 文本的样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveGet.theme.colorScheme.primary],
  ///   fontSize: [WaveCommonConfig.fontSizeSubHead],
  /// )
  WaveTextStyle? _labelStyle;

  /// 未选中 Tab 文本的样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextBase],
  ///   fontSize: [WaveCommonConfig.fontSizeSubHead],
  /// )
  WaveTextStyle? _unselectedLabelStyle;

  /// 背景色
  /// 默认为 [WaveCommonConfig.fillBase]
  Color? _backgroundColor;

  /// 标签字体样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextBase],
  ///   fontSize: [WaveCommonConfig.fontSizeCaption],
  /// )
  WaveTextStyle? _tagNormalTextStyle;

  /// 标签背景色
  /// 默认为 [WaveGet.theme.colorScheme.primary].withAlpha(0x14),
  Color? _tagNormalBgColor;

  /// 标签字体样式
  ///
  /// WaveTextStyle(
  ///   color:[WaveGet.theme.colorScheme.primary],
  ///   fontSize: [WaveCommonConfig.fontSizeCaption],
  /// )
  WaveTextStyle? _tagSelectedTextStyle;

  /// 标签选中背景色
  /// 默认为 [WaveCommonConfig.fillBody]
  Color? _tagSelectedBgColor;

  /// tag圆角
  /// 默认为 [WaveCommonConfig.radiusSm]
  double? _tagRadius;

  /// tag间距
  /// 默认为 12
  double? _tagSpacing;

  /// 每行的tag数
  /// 默认为 4
  int? _preLineTagCount;

  /// tag高度
  /// 默认为 32
  double? _tagHeight;

  double get tabHeight =>
      _tabHeight ?? WaveDefaultConfigUtils.defaultTabBarConfig.tabHeight;

  double get indicatorHeight =>
      _indicatorHeight ??
      WaveDefaultConfigUtils.defaultTabBarConfig.indicatorHeight;

  double get indicatorWidth =>
      _indicatorWidth ??
      WaveDefaultConfigUtils.defaultTabBarConfig.indicatorWidth;

  WaveTextStyle get labelStyle =>
      _labelStyle ?? WaveDefaultConfigUtils.defaultTabBarConfig.labelStyle;

  WaveTextStyle get unselectedLabelStyle =>
      _unselectedLabelStyle ??
      WaveDefaultConfigUtils.defaultTabBarConfig.unselectedLabelStyle;

  Color get backgroundColor =>
      _backgroundColor ??
      WaveDefaultConfigUtils.defaultTabBarConfig.backgroundColor;

  WaveTextStyle get tagNormalTextStyle =>
      _tagNormalTextStyle ??
      WaveDefaultConfigUtils.defaultTabBarConfig.tagNormalTextStyle;

  Color get tagNormalBgColor =>
      _tagNormalBgColor ??
      WaveDefaultConfigUtils.defaultTabBarConfig.tagNormalBgColor;

  WaveTextStyle get tagSelectedTextStyle =>
      _tagSelectedTextStyle ??
      WaveDefaultConfigUtils.defaultTabBarConfig.tagSelectedTextStyle;

  Color get tagSelectedBgColor =>
      _tagSelectedBgColor ??
      WaveDefaultConfigUtils.defaultTabBarConfig.tagSelectedBgColor;

  double get tagRadius =>
      _tagRadius ?? WaveDefaultConfigUtils.defaultTabBarConfig.tagRadius;

  double get tagSpacing =>
      _tagSpacing ?? WaveDefaultConfigUtils.defaultTabBarConfig.tagSpacing;

  int get preLineTagCount =>
      _preLineTagCount ??
      WaveDefaultConfigUtils.defaultTabBarConfig.preLineTagCount;

  double get tagHeight =>
      _tagHeight ?? WaveDefaultConfigUtils.defaultTabBarConfig.tagHeight;

  @override
  void initThemeConfig(
    String configId, {
    WaveCommonConfig? currentLevelCommonConfig,
  }) {
    super.initThemeConfig(
      configId,
      currentLevelCommonConfig: currentLevelCommonConfig,
    );

    WaveTabBarConfig tabBarConfig = WaveThemeConfigurator.instance
        .getConfig(configId: configId)
        .tabBarConfig;

    _tabHeight ??= tabBarConfig._tabHeight;
    _indicatorHeight ??= tabBarConfig._indicatorHeight;
    _indicatorWidth ??= tabBarConfig._indicatorWidth;
    _labelStyle = tabBarConfig.labelStyle.merge(
      WaveTextStyle(
        color: Get.theme.colorScheme.primary,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_labelStyle),
    );
    _unselectedLabelStyle = tabBarConfig.unselectedLabelStyle.merge(
      WaveTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_unselectedLabelStyle),
    );
    _backgroundColor ??= tabBarConfig._backgroundColor;
    _tagNormalTextStyle = tabBarConfig.tagNormalTextStyle.merge(
      WaveTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeCaption,
      ).merge(_tagNormalTextStyle),
    );
    _tagSelectedTextStyle = tabBarConfig.tagSelectedTextStyle.merge(
      WaveTextStyle(
        color: Get.theme.colorScheme.primary,
        fontSize: commonConfig.fontSizeCaption,
      ).merge(_tagSelectedTextStyle),
    );
    _tagNormalBgColor ??= tabBarConfig._tagNormalBgColor;
    _tagSelectedBgColor ??= tabBarConfig._tagSelectedBgColor;
    _tagRadius ??= commonConfig.radiusSm;
    _tagSpacing ??= tabBarConfig._tagSpacing;
    _preLineTagCount ??= tabBarConfig._preLineTagCount;
    _tagHeight ??= tabBarConfig._tagHeight;
  }

  WaveTabBarConfig copyWith({
    double? tabHeight,
    double? indicatorHeight,
    double? indicatorWidth,
    WaveTextStyle? labelStyle,
    WaveTextStyle? unselectedLabelStyle,
    Color? backgroundColor,
    WaveTextStyle? tagNormalTextStyle,
    Color? tagNormalColor,
    WaveTextStyle? tagSelectedTextStyle,
    Color? tagSelectedColor,
    double? tagRadius,
    double? tagSpacing,
    int? preLineTagSize,
    double? tagHeight,
  }) {
    return WaveTabBarConfig(
      tabHeight: tabHeight ?? _tabHeight,
      indicatorHeight: indicatorHeight ?? _indicatorHeight,
      indicatorWidth: indicatorWidth ?? _indicatorWidth,
      labelStyle: labelStyle ?? _labelStyle,
      unselectedLabelStyle: unselectedLabelStyle ?? _unselectedLabelStyle,
      backgroundColor: backgroundColor ?? _backgroundColor,
      tagNormalTextStyle: tagNormalTextStyle ?? _tagNormalTextStyle,
      tagNormalBgColor: tagNormalColor ?? _tagNormalBgColor,
      tagSelectedTextStyle: tagSelectedTextStyle ?? _tagSelectedTextStyle,
      tagSelectedBgColor: tagSelectedColor ?? _tagSelectedBgColor,
      tagRadius: tagRadius ?? _tagRadius,
      tagSpacing: tagSpacing ?? _tagSpacing,
      preLineTagCount: preLineTagSize ?? _preLineTagCount,
      tagHeight: tagHeight ?? _tagHeight,
    );
  }

  WaveTabBarConfig merge(WaveTabBarConfig? other) {
    if (other == null) return this;
    return copyWith(
      tabHeight: other._tabHeight,
      indicatorHeight: other._indicatorHeight,
      indicatorWidth: other._indicatorWidth,
      labelStyle: labelStyle.merge(other._labelStyle),
      unselectedLabelStyle:
          unselectedLabelStyle.merge(other._unselectedLabelStyle),
      backgroundColor: other._backgroundColor,
      tagNormalTextStyle: tagNormalTextStyle.merge(other._tagNormalTextStyle),
      tagNormalColor: other._tagNormalBgColor,
      tagSelectedTextStyle:
          tagSelectedTextStyle.merge(other._tagSelectedTextStyle),
      tagSelectedColor: other._tagSelectedBgColor,
      tagRadius: other._tagRadius,
      tagSpacing: other._tagSpacing,
      preLineTagSize: other._preLineTagCount,
      tagHeight: other._tagHeight,
    );
  }
}
