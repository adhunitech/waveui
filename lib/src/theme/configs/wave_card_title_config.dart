import 'package:waveui/src/theme/base/wave_base_config.dart';
import 'package:waveui/src/theme/base/wave_default_config_utils.dart';
import 'package:waveui/src/theme/base/wave_text_style.dart';
import 'package:waveui/src/theme/wave_theme_configurator.dart';
import 'package:waveui/src/theme/configs/wave_common_config.dart';
import 'package:flutter/material.dart';

/// 卡片标题 配置类
class WaveCardTitleConfig extends WaveBaseConfig {
  WaveCardTitleConfig({
    WaveTextStyle? titleWithHeightTextStyle,
    WaveTextStyle? detailTextStyle,
    WaveTextStyle? accessoryTextStyle,
    EdgeInsets? cardTitlePadding,
    WaveTextStyle? titleTextStyle,
    WaveTextStyle? subtitleTextStyle,
    PlaceholderAlignment? alignment,
    Color? cardBackgroundColor,
    String configId = GLOBAL_CONFIG_ID,
  })  : _titleWithHeightTextStyle = titleWithHeightTextStyle,
        _detailTextStyle = detailTextStyle,
        _accessoryTextStyle = accessoryTextStyle,
        _cardTitlePadding = cardTitlePadding,
        _titleTextStyle = titleTextStyle,
        _subtitleTextStyle = subtitleTextStyle,
        _alignment = alignment,
        _cardBackgroundColor = cardBackgroundColor,
        super(configId: configId);

  /// 标题外边距间距
  ///
  /// EdgeInsets.only(
  ///   top: [WaveCommonConfig.vSpacingXl],
  ///   bottom: [WaveCommonConfig.vSpacingMd],
  /// )
  EdgeInsets? _cardTitlePadding;

  EdgeInsets get cardTitlePadding =>
      _cardTitlePadding ??
      WaveDefaultConfigUtils.defaultCardTitleConfig.cardTitlePadding;

  /// 标题文本样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextBase],
  ///   fontSize: [WaveCommonConfig.fontSizeHead],
  ///   fontWeight: FontWeight.w600,
  ///   height: 25 / 18,
  /// )
  WaveTextStyle? _titleWithHeightTextStyle;

  WaveTextStyle get titleWithHeightTextStyle =>
      _titleWithHeightTextStyle ??
      WaveDefaultConfigUtils.defaultCardTitleConfig.titleWithHeightTextStyle;

  /// 标题文本样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextBase],
  ///   fontSize: [WaveCommonConfig.fontSizeHead],
  ///   fontWeight: FontWeight.w600,
  /// )
  WaveTextStyle? _titleTextStyle;

  WaveTextStyle get titleTextStyle =>
      _titleTextStyle ??
      WaveDefaultConfigUtils.defaultCardTitleConfig.titleTextStyle;

  /// 标题右边的副标题文本样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextSecondary],
  ///   fontSize: [WaveCommonConfig.fontSizeBase],
  /// )
  WaveTextStyle? _subtitleTextStyle;

  WaveTextStyle get subtitleTextStyle =>
      _subtitleTextStyle ??
      WaveDefaultConfigUtils.defaultCardTitleConfig.subtitleTextStyle;

  /// 详情文本样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextBase],
  ///   fontSize: [WaveCommonConfig.fontSizeBase],
  /// )
  WaveTextStyle? _detailTextStyle;

  WaveTextStyle get detailTextStyle =>
      _detailTextStyle ??
      WaveDefaultConfigUtils.defaultCardTitleConfig.detailTextStyle;

  /// 辅助文本样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextSecondary],
  ///   fontSize: [WaveCommonConfig.fontSizeBase],
  /// )
  WaveTextStyle? _accessoryTextStyle;

  WaveTextStyle get accessoryTextStyle =>
      _accessoryTextStyle ??
      WaveDefaultConfigUtils.defaultCardTitleConfig.accessoryTextStyle;

  /// 对齐方式
  /// 默认为 [PlaceholderAlignment.middle]
  PlaceholderAlignment? _alignment;

  PlaceholderAlignment get alignment =>
      _alignment ?? WaveDefaultConfigUtils.defaultCardTitleConfig.alignment;

  /// 卡片背景
  /// 默认为 [WaveCommonConfig.fillBase]
  Color? _cardBackgroundColor;

  Color get cardBackgroundColor =>
      _cardBackgroundColor ??
      WaveDefaultConfigUtils.defaultCardTitleConfig.cardBackgroundColor;

  /// cardTitleConfig  获取逻辑详见 [WaveThemeConfigurator.getConfig] 方法
  @override
  void initThemeConfig(
    String configId, {
    WaveCommonConfig? currentLevelCommonConfig,
  }) {
    super.initThemeConfig(
      configId,
      currentLevelCommonConfig: currentLevelCommonConfig,
    );

    WaveCardTitleConfig cardTitleConfig = WaveThemeConfigurator.instance
        .getConfig(configId: configId)
        .cardTitleConfig;

    _cardBackgroundColor ??= commonConfig.fillBase;
    _cardTitlePadding ??= EdgeInsets.only(
      left: cardTitleConfig.cardTitlePadding.left,
      top: commonConfig.vSpacingXl,
      right: cardTitleConfig.cardTitlePadding.right,
      bottom: commonConfig.vSpacingMd,
    );
    _titleWithHeightTextStyle = cardTitleConfig.titleWithHeightTextStyle.merge(
      WaveTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeHead,
      ).merge(_titleWithHeightTextStyle),
    );
    _titleTextStyle = cardTitleConfig.titleTextStyle.merge(
      WaveTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeHead,
      ).merge(_titleTextStyle),
    );
    _subtitleTextStyle = cardTitleConfig.subtitleTextStyle.merge(
      WaveTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_subtitleTextStyle),
    );
    _accessoryTextStyle = cardTitleConfig.accessoryTextStyle.merge(
      WaveTextStyle(
        color: commonConfig.colorTextSecondary,
        fontSize: commonConfig.fontSizeHead,
      ).merge(_accessoryTextStyle),
    );
    _detailTextStyle = cardTitleConfig.detailTextStyle.merge(
      WaveTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_detailTextStyle),
    );
    _alignment ??= cardTitleConfig._alignment;
  }

  WaveCardTitleConfig copyWith({
    EdgeInsets? cardTitlePadding,
    WaveTextStyle? titleWithHeightTextStyle,
    WaveTextStyle? titleTextStyle,
    WaveTextStyle? subtitleTextStyle,
    WaveTextStyle? detailTextStyle,
    WaveTextStyle? accessoryTextStyle,
    PlaceholderAlignment? alignment,
    Color? cardBackgroundColor,
  }) {
    return WaveCardTitleConfig(
      cardTitlePadding: cardTitlePadding ?? _cardTitlePadding,
      titleWithHeightTextStyle:
          titleWithHeightTextStyle ?? _titleWithHeightTextStyle,
      titleTextStyle: titleTextStyle ?? _titleTextStyle,
      subtitleTextStyle: subtitleTextStyle ?? _subtitleTextStyle,
      detailTextStyle: detailTextStyle ?? _detailTextStyle,
      accessoryTextStyle: accessoryTextStyle ?? _accessoryTextStyle,
      alignment: alignment ?? _alignment,
      cardBackgroundColor: cardBackgroundColor ?? _cardBackgroundColor,
    );
  }

  WaveCardTitleConfig merge(WaveCardTitleConfig? other) {
    if (other == null) return this;
    return copyWith(
      cardTitlePadding: other._cardTitlePadding,
      titleWithHeightTextStyle:
          titleWithHeightTextStyle.merge(other._titleWithHeightTextStyle),
      titleTextStyle: titleTextStyle.merge(other._titleTextStyle),
      subtitleTextStyle: subtitleTextStyle.merge(other._subtitleTextStyle),
      detailTextStyle: detailTextStyle.merge(other._detailTextStyle),
      accessoryTextStyle: accessoryTextStyle.merge(other._accessoryTextStyle),
      alignment: other._alignment,
      cardBackgroundColor: other._cardBackgroundColor,
    );
  }
}
