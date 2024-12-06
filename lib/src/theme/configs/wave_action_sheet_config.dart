import 'package:waveui/src/theme/base/wave_base_config.dart';
import 'package:waveui/src/theme/base/wave_default_config_utils.dart';
import 'package:waveui/src/theme/base/wave_text_style.dart';
import 'package:waveui/src/theme/wave_theme_configurator.dart';
import 'package:waveui/src/theme/configs/wave_common_config.dart';
import 'package:flutter/material.dart';

/// WaveActionSheet 主题配置
class WaveActionSheetConfig extends WaveBaseConfig {
  /// 遵循外部主题配置
  /// 默认为 [WaveDefaultConfigUtils.defaultActionSheetConfig]
  WaveActionSheetConfig({
    WaveTextStyle? titleStyle,
    WaveTextStyle? itemTitleStyle,
    WaveTextStyle? itemTitleStyleLink,
    WaveTextStyle? itemTitleStyleAlert,
    WaveTextStyle? itemDescStyle,
    WaveTextStyle? itemDescStyleLink,
    WaveTextStyle? itemDescStyleAlert,
    WaveTextStyle? cancelStyle,
    double? topRadius,
    EdgeInsets? contentPadding,
    EdgeInsets? titlePadding,
    String configId = GLOBAL_CONFIG_ID,
  })  : _titleStyle = titleStyle,
        _itemTitleStyle = itemTitleStyle,
        _itemTitleStyleLink = itemTitleStyleLink,
        _itemTitleStyleAlert = itemTitleStyleAlert,
        _itemDescStyle = itemDescStyle,
        _itemDescStyleLink = itemDescStyleLink,
        _itemDescStyleAlert = itemDescStyleAlert,
        _cancelStyle = cancelStyle,
        _topRadius = topRadius,
        _contentPadding = contentPadding,
        _titlePadding = titlePadding,
        super(configId: configId);

  /// ActionSheet 的顶部圆角
  /// 默认值为 [WaveCommonConfig.radiusLg]
  double? _topRadius;

  /// 标题样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextSecondary],
  ///   fontSize: [WaveCommonConfig.fontSizeBase],
  /// )
  WaveTextStyle? _titleStyle;

  /// 元素标题默认样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextBase],
  ///   fontSize:[WaveCommonConfig.fontSizeSubHead],
  /// )
  WaveTextStyle? _itemTitleStyle;

  /// 元素标题链接样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorLink],
  ///   fontSize: [WaveCommonConfig.fontSizeSubHead],
  ///   fontWeight: FontWeight.w600,
  /// )
  WaveTextStyle? _itemTitleStyleLink;

  /// 元素警示项标题样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.brandError],
  ///   fontSize: [WaveCommonConfig.fontSizeBase],
  ///   fontWeight: FontWeight.w600,
  /// )
  WaveTextStyle? _itemTitleStyleAlert;

  /// 元素描述默认样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextBase],
  ///   fontSize: [WaveCommonConfig.fontSizeCaption],
  ///   fontWeight: FontWeight.w600,
  /// )
  WaveTextStyle? _itemDescStyle;

  /// 元素标题描述链接样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorLink],
  ///   fontSize: [WaveCommonConfig.fontSizeCaption],
  ///   fontWeight: FontWeight.w600,
  /// )
  WaveTextStyle? _itemDescStyleLink;

  /// 元素警示项标题描述样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.brandError],
  ///   fontSize: [WaveCommonConfig.fontSizeCaption],
  ///   fontWeight: FontWeight.w600,
  /// )
  WaveTextStyle? _itemDescStyleAlert;

  /// 取消按钮样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextBase],
  ///   fontSize: [WaveCommonConfig.fontSizeSubHead],
  ///   fontWeight: FontWeight.w600,
  /// )
  WaveTextStyle? _cancelStyle;

  /// 内容左右间距
  ///
  /// EdgeInsets.symmetric(horizontal: 60, vertical: 12)
  EdgeInsets? _contentPadding;

  /// 标题左右间距
  ///
  /// EdgeInsets.symmetric(horizontal: 60, vertical: 16)
  EdgeInsets? _titlePadding;

  double get topRadius =>
      _topRadius ?? WaveDefaultConfigUtils.defaultActionSheetConfig.topRadius;

  WaveTextStyle get titleStyle =>
      _titleStyle ?? WaveDefaultConfigUtils.defaultActionSheetConfig.titleStyle;

  WaveTextStyle get itemTitleStyle =>
      _itemTitleStyle ??
      WaveDefaultConfigUtils.defaultActionSheetConfig.itemTitleStyle;

  WaveTextStyle get itemTitleStyleLink =>
      _itemTitleStyleLink ??
      WaveDefaultConfigUtils.defaultActionSheetConfig.itemTitleStyleLink;

  WaveTextStyle get itemTitleStyleAlert =>
      _itemTitleStyleAlert ??
      WaveDefaultConfigUtils.defaultActionSheetConfig.itemTitleStyleAlert;

  WaveTextStyle get itemDescStyle =>
      _itemDescStyle ??
      WaveDefaultConfigUtils.defaultActionSheetConfig.itemDescStyle;

  WaveTextStyle get itemDescStyleLink =>
      _itemDescStyleLink ??
      WaveDefaultConfigUtils.defaultActionSheetConfig.itemDescStyleLink;

  WaveTextStyle get itemDescStyleAlert =>
      _itemDescStyleAlert ??
      WaveDefaultConfigUtils.defaultActionSheetConfig.itemDescStyleAlert;

  WaveTextStyle get cancelStyle =>
      _cancelStyle ??
      WaveDefaultConfigUtils.defaultActionSheetConfig.cancelStyle;

  EdgeInsets get contentPadding =>
      _contentPadding ??
      WaveDefaultConfigUtils.defaultActionSheetConfig.contentPadding;

  EdgeInsets get titlePadding =>
      _titlePadding ??
      WaveDefaultConfigUtils.defaultActionSheetConfig.titlePadding;

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
    WaveActionSheetConfig actionSheetConfig = WaveThemeConfigurator.instance
        .getConfig(configId: configId)
        .actionSheetConfig;

    _titlePadding ??= actionSheetConfig.titlePadding;
    _contentPadding ??= actionSheetConfig.contentPadding;
    _titleStyle = actionSheetConfig.titleStyle.merge(
      WaveTextStyle(
        color: commonConfig.colorTextSecondary,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_titleStyle),
    );
    _itemTitleStyle = actionSheetConfig.itemTitleStyle.merge(
      WaveTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_itemTitleStyle),
    );
    _itemTitleStyleLink = actionSheetConfig.itemTitleStyleLink.merge(
      WaveTextStyle(
        color: commonConfig.colorLink,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_itemTitleStyleLink),
    );
    _itemTitleStyleAlert = actionSheetConfig.itemTitleStyleAlert.merge(
      WaveTextStyle(
        color: commonConfig.brandError,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_itemTitleStyleAlert),
    );
    _itemDescStyle = actionSheetConfig.itemDescStyle.merge(
      WaveTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeCaption,
      ).merge(_itemDescStyle),
    );
    _itemDescStyleLink = actionSheetConfig.itemDescStyleLink.merge(
      WaveTextStyle(
        color: commonConfig.colorLink,
        fontSize: commonConfig.fontSizeCaption,
      ).merge(_itemDescStyleLink),
    );
    _itemDescStyleAlert = actionSheetConfig.itemDescStyleAlert.merge(
      WaveTextStyle(
        color: commonConfig.brandError,
        fontSize: commonConfig.fontSizeCaption,
      ).merge(_itemDescStyleAlert),
    );
    _cancelStyle = actionSheetConfig.cancelStyle.merge(
      WaveTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_cancelStyle),
    );
    _topRadius ??= commonConfig.radiusLg;
  }

  WaveActionSheetConfig copyWith({
    double? topRadius,
    WaveTextStyle? titleStyle,
    WaveTextStyle? itemTitleStyle,
    WaveTextStyle? itemTitleStyleLink,
    WaveTextStyle? itemTitleStyleAlert,
    WaveTextStyle? itemDescStyle,
    WaveTextStyle? itemDescStyleLink,
    WaveTextStyle? itemDescStyleAlert,
    WaveTextStyle? cancelStyle,
    EdgeInsets? contentPadding,
    EdgeInsets? titlePadding,
  }) {
    return WaveActionSheetConfig(
      titleStyle: titleStyle ?? _titleStyle,
      itemTitleStyle: itemTitleStyle ?? _itemTitleStyle,
      itemTitleStyleLink: itemTitleStyleLink ?? _itemTitleStyleLink,
      itemTitleStyleAlert: itemTitleStyleAlert ?? _itemTitleStyleAlert,
      itemDescStyle: itemDescStyle ?? _itemDescStyle,
      itemDescStyleLink: itemDescStyleLink ?? _itemDescStyleLink,
      itemDescStyleAlert: itemDescStyleAlert ?? _itemDescStyleAlert,
      cancelStyle: cancelStyle ?? _cancelStyle,
      topRadius: topRadius ?? _topRadius,
      contentPadding: contentPadding ?? _contentPadding,
      titlePadding: titlePadding ?? _titlePadding,
    );
  }

  WaveActionSheetConfig merge(WaveActionSheetConfig? other) {
    if (other == null) return this;
    return copyWith(
      titleStyle: titleStyle.merge(other._titleStyle),
      itemTitleStyle: itemTitleStyle.merge(other._itemTitleStyle),
      itemTitleStyleLink: itemTitleStyleLink.merge(other._itemTitleStyleLink),
      itemTitleStyleAlert:
          itemTitleStyleAlert.merge(other._itemTitleStyleAlert),
      itemDescStyle: itemDescStyle.merge(other._itemDescStyle),
      itemDescStyleLink: itemDescStyleLink.merge(other._itemDescStyleLink),
      itemDescStyleAlert: itemDescStyleAlert.merge(other._itemDescStyleAlert),
      cancelStyle: cancelStyle.merge(other._cancelStyle),
      topRadius: other._topRadius,
      contentPadding: other._contentPadding,
      titlePadding: other._titlePadding,
    );
  }
}
