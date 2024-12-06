import 'package:waveui/src/theme/base/wave_base_config.dart';
import 'package:waveui/src/theme/base/wave_default_config_utils.dart';
import 'package:waveui/src/theme/base/wave_text_style.dart';
import 'package:waveui/src/theme/wave_theme_configurator.dart';
import 'package:waveui/src/theme/configs/wave_common_config.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';

/// 标签配置类
class WaveTagConfig extends WaveBaseConfig {
  WaveTagConfig({
    WaveTextStyle? tagTextStyle,
    WaveTextStyle? selectTagTextStyle,
    double? tagRadius,
    Color? tagBackgroundColor,
    Color? selectedTagBackgroundColor,
    double? tagHeight,
    double? tagWidth,
    double? tagMinWidth,
    String configId = GLOBAL_CONFIG_ID,
  })  : _tagTextStyle = tagTextStyle,
        _selectTagTextStyle = selectTagTextStyle,
        _tagRadius = tagRadius,
        _tagBackgroundColor = tagBackgroundColor,
        _selectedTagBackgroundColor = selectedTagBackgroundColor,
        _tagHeight = tagHeight,
        _tagWidth = tagWidth,
        _tagMinWidth = tagMinWidth,
        super(configId: configId);

  /// tag 文本样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextBase],
  ///   fontSize: [WaveCommonConfig.fontSizeCaption],
  /// )
  WaveTextStyle? _tagTextStyle;

  /// tag选中文本样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveGet.theme.colorScheme.primary],
  ///   fontSize: [WaveCommonConfig.fontSizeCaption],
  ///   fontWeight: FontWeight.w600,
  /// )
  WaveTextStyle? _selectTagTextStyle;

  /// 标签背景色
  /// default [WaveCommonConfig.fillBody]
  Color? _tagBackgroundColor;

  /// 选中背景色
  /// default [WaveGet.theme.colorScheme.primary]
  Color? _selectedTagBackgroundColor;

  /// 标签圆角
  /// 默认为 [WaveCommonConfig.radiusXs]
  double? _tagRadius;

  /// 标签高度，跟 fixWidthMode 无关
  /// 默认为 34
  double? _tagHeight;

  /// 标签宽度，且仅在组件设置了固定宽度（fixWidthMode 为 true）时才生效
  /// 默认为 75
  double? _tagWidth;

  /// 标签最小宽度
  /// 默认为 75
  double? _tagMinWidth;

  WaveTextStyle get tagTextStyle =>
      _tagTextStyle ?? WaveDefaultConfigUtils.defaultTagConfig.tagTextStyle;

  WaveTextStyle get selectTagTextStyle =>
      _selectTagTextStyle ??
      WaveDefaultConfigUtils.defaultTagConfig.selectTagTextStyle;

  Color get tagBackgroundColor =>
      _tagBackgroundColor ??
      WaveDefaultConfigUtils.defaultTagConfig.tagBackgroundColor;

  Color get selectedTagBackgroundColor =>
      _selectedTagBackgroundColor ??
      WaveDefaultConfigUtils.defaultTagConfig.selectedTagBackgroundColor;

  double get tagRadius =>
      _tagRadius ?? WaveDefaultConfigUtils.defaultTagConfig.tagRadius;

  double get tagHeight =>
      _tagHeight ?? WaveDefaultConfigUtils.defaultTagConfig.tagHeight;

  double get tagWidth =>
      _tagWidth ?? WaveDefaultConfigUtils.defaultTagConfig.tagWidth;

  double get tagMinWidth =>
      _tagMinWidth ?? WaveDefaultConfigUtils.defaultTagConfig.tagMinWidth;

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
    WaveTagConfig tagConfig =
        WaveThemeConfigurator.instance.getConfig(configId: configId).tagConfig;

    _tagHeight ??= tagConfig._tagHeight;
    _tagWidth ??= tagConfig._tagWidth;
    _tagMinWidth ??= tagConfig._tagMinWidth;
    _tagRadius ??= commonConfig.radiusXs;
    _tagBackgroundColor ??= commonConfig.fillBody;
    _selectedTagBackgroundColor ??= Get.theme.colorScheme.primary;
    _tagTextStyle = tagConfig.tagTextStyle.merge(
      WaveTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeCaption,
      ).merge(_tagTextStyle),
    );
    _selectTagTextStyle = tagConfig.selectTagTextStyle.merge(
      WaveTextStyle(
        color: Get.theme.colorScheme.primary,
        fontSize: commonConfig.fontSizeCaption,
      ).merge(_selectTagTextStyle),
    );
  }

  WaveTagConfig copyWith({
    WaveTextStyle? textStyle,
    WaveTextStyle? selectTextStyle,
    double? radius,
    Color? backgroundColor,
    Color? selectedBackgroundColor,
    double? height,
    double? width,
    double? tagMinWidth,
  }) {
    return WaveTagConfig(
      tagTextStyle: textStyle ?? _tagTextStyle,
      selectTagTextStyle: selectTextStyle ?? _selectTagTextStyle,
      tagRadius: radius ?? _tagRadius,
      tagBackgroundColor: backgroundColor ?? _tagBackgroundColor,
      selectedTagBackgroundColor:
          selectedBackgroundColor ?? _selectedTagBackgroundColor,
      tagHeight: height ?? _tagHeight,
      tagWidth: width ?? _tagWidth,
      tagMinWidth: tagMinWidth ?? _tagMinWidth,
    );
  }

  WaveTagConfig merge(WaveTagConfig? other) {
    if (other == null) return this;
    return copyWith(
      textStyle: tagTextStyle.merge(other._tagTextStyle),
      selectTextStyle: selectTagTextStyle.merge(other._selectTagTextStyle),
      radius: other._tagRadius,
      backgroundColor: other._tagBackgroundColor,
      selectedBackgroundColor: other._selectedTagBackgroundColor,
      height: other._tagHeight,
      width: other._tagWidth,
      tagMinWidth: other._tagMinWidth,
    );
  }
}
