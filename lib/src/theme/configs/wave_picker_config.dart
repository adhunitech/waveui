import 'package:get/get.dart';
import 'package:waveui/src/theme/base/wave_base_config.dart';
import 'package:waveui/src/theme/base/wave_default_config_utils.dart';
import 'package:waveui/src/theme/base/wave_text_style.dart';
import 'package:waveui/src/theme/wave_theme_configurator.dart';
import 'package:waveui/src/theme/configs/wave_common_config.dart';
import 'package:flutter/material.dart';

/// 选择器配置
class WavePickerConfig extends WaveBaseConfig {
  /// 遵循外部主题配置
  /// 默认为 [WaveDefaultConfigUtils.defaultPickerConfig]
  WavePickerConfig({
    Color? backgroundColor,
    WaveTextStyle? cancelTextStyle,
    WaveTextStyle? confirmTextStyle,
    WaveTextStyle? titleTextStyle,
    double? pickerHeight,
    double? titleHeight,
    double? itemHeight,
    WaveTextStyle? itemTextStyle,
    WaveTextStyle? itemTextSelectedStyle,
    Color? dividerColor,
    double? cornerRadius,
    String configId = GLOBAL_CONFIG_ID,
  })  : _backgroundColor = backgroundColor,
        _cancelTextStyle = cancelTextStyle,
        _confirmTextStyle = confirmTextStyle,
        _titleTextStyle = titleTextStyle,
        _pickerHeight = pickerHeight,
        _titleHeight = titleHeight,
        _itemHeight = itemHeight,
        _itemTextStyle = itemTextStyle,
        _itemTextSelectedStyle = itemTextSelectedStyle,
        _dividerColor = dividerColor,
        _cornerRadius = cornerRadius,
        super(configId: configId);

  /// 日期选择器的背景色
  /// 默认为 [PICKER_BACKGROUND_COLOR]
  Color? _backgroundColor;

  /// 取消文字的样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextBase],
  ///   fontSize: [WaveCommonConfig.fontSizeSubHead],
  /// )
  WaveTextStyle? _cancelTextStyle;

  /// 确认文字的样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveGet.theme.colorScheme.primary],
  ///   fontSize: [WaveCommonConfig.fontSizeSubHead],
  /// )
  WaveTextStyle? _confirmTextStyle;

  /// 标题文字的样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextBase],
  ///   fontSize: [WaveCommonConfig.fontSizeSubHead],
  ///   fontWidget:FontWeight.w600,
  /// )
  WaveTextStyle? _titleTextStyle;

  /// 日期选择器的高度
  /// 默认为 [PICKER_HEIGHT]
  double? _pickerHeight;

  /// 日期选择器标题的高度
  /// 默认为 [PICKER_TITLE_HEIGHT]
  double? _titleHeight;

  /// 日期选择器列表的高度
  /// 默认为 [PICKER_ITEM_HEIGHT]
  double? _itemHeight;

  /// 日期选择器列表的文字样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextBase],
  ///   fontSize: [WaveCommonConfig.fontSizeHead],
  /// )
  WaveTextStyle? _itemTextStyle;

  /// 日期选择器列表选中的文字样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveGet.theme.colorScheme.primary],
  ///   fontSize: [WaveCommonConfig.fontSizeHead],
  ///   fontWidget: FontWeight.w600,
  /// )
  WaveTextStyle? _itemTextSelectedStyle;

  Color? _dividerColor;
  double? _cornerRadius;

  Color get backgroundColor =>
      _backgroundColor ??
      WaveDefaultConfigUtils.defaultPickerConfig.backgroundColor;

  WaveTextStyle get cancelTextStyle =>
      _cancelTextStyle ??
      WaveDefaultConfigUtils.defaultPickerConfig.cancelTextStyle;

  WaveTextStyle get confirmTextStyle =>
      _confirmTextStyle ??
      WaveDefaultConfigUtils.defaultPickerConfig.confirmTextStyle;

  WaveTextStyle get titleTextStyle =>
      _titleTextStyle ??
      WaveDefaultConfigUtils.defaultPickerConfig.titleTextStyle;

  double get pickerHeight =>
      _pickerHeight ?? WaveDefaultConfigUtils.defaultPickerConfig.pickerHeight;

  double get titleHeight =>
      _titleHeight ?? WaveDefaultConfigUtils.defaultPickerConfig.titleHeight;

  double get itemHeight =>
      _itemHeight ?? WaveDefaultConfigUtils.defaultPickerConfig.itemHeight;

  WaveTextStyle get itemTextStyle =>
      _itemTextStyle ??
      WaveDefaultConfigUtils.defaultPickerConfig.itemTextStyle;

  WaveTextStyle get itemTextSelectedStyle =>
      _itemTextSelectedStyle ??
      WaveDefaultConfigUtils.defaultPickerConfig.itemTextSelectedStyle;

  Color get dividerColor =>
      _dividerColor ?? WaveDefaultConfigUtils.defaultPickerConfig.dividerColor;

  double get cornerRadius =>
      _cornerRadius ?? WaveDefaultConfigUtils.defaultPickerConfig.cornerRadius;

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
    WavePickerConfig pickerConfig = WaveThemeConfigurator.instance
        .getConfig(configId: configId)
        .pickerConfig;

    _backgroundColor ??= pickerConfig.backgroundColor;
    _pickerHeight ??= pickerConfig.pickerHeight;
    _titleHeight ??= pickerConfig.titleHeight;
    _itemHeight ??= pickerConfig.itemHeight;
    _dividerColor ??= pickerConfig.dividerColor;
    _cornerRadius ??= pickerConfig.cornerRadius;
    _titleTextStyle = pickerConfig.titleTextStyle.merge(
      WaveTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_titleTextStyle),
    );
    _cancelTextStyle = pickerConfig.cancelTextStyle
        .merge(
          WaveTextStyle(
            color: commonConfig.colorTextBase,
            fontSize: commonConfig.fontSizeSubHead,
          ),
        )
        .merge(_cancelTextStyle);
    _confirmTextStyle = pickerConfig.confirmTextStyle.merge(
      WaveTextStyle(
        color: Get.theme.colorScheme.primary,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_confirmTextStyle),
    );
    _itemTextStyle = pickerConfig.itemTextStyle.merge(
      WaveTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeHead,
      ).merge(_itemTextStyle),
    );
    _itemTextSelectedStyle = pickerConfig.itemTextSelectedStyle.merge(
      WaveTextStyle(
        color: Get.theme.colorScheme.primary,
        fontSize: commonConfig.fontSizeHead,
      ).merge(_itemTextSelectedStyle),
    );
  }

  WavePickerConfig copyWith({
    Color? backgroundColor,
    WaveTextStyle? cancelTextStyle,
    WaveTextStyle? confirmTextStyle,
    WaveTextStyle? titleTextStyle,
    double? pickerHeight,
    double? titleHeight,
    double? itemHeight,
    WaveTextStyle? itemTextStyle,
    WaveTextStyle? itemTextSelectedStyle,
    Color? dividerColor,
    double? cornerRadius,
  }) {
    return WavePickerConfig(
      backgroundColor: backgroundColor ?? _backgroundColor,
      cancelTextStyle: cancelTextStyle ?? _cancelTextStyle,
      confirmTextStyle: confirmTextStyle ?? _confirmTextStyle,
      titleTextStyle: titleTextStyle ?? _titleTextStyle,
      pickerHeight: pickerHeight ?? _pickerHeight,
      titleHeight: titleHeight ?? _titleHeight,
      itemHeight: itemHeight ?? _itemHeight,
      itemTextStyle: itemTextStyle ?? _itemTextStyle,
      itemTextSelectedStyle: itemTextSelectedStyle ?? _itemTextSelectedStyle,
      dividerColor: dividerColor ?? _dividerColor,
      cornerRadius: cornerRadius ?? _cornerRadius,
    );
  }

  WavePickerConfig merge(WavePickerConfig? other) {
    if (other == null) return this;
    return copyWith(
      backgroundColor: other._backgroundColor,
      cancelTextStyle: cancelTextStyle.merge(other._cancelTextStyle),
      confirmTextStyle: confirmTextStyle.merge(other._confirmTextStyle),
      titleTextStyle: titleTextStyle.merge(other._titleTextStyle),
      pickerHeight: other._pickerHeight,
      titleHeight: other._titleHeight,
      itemHeight: other._itemHeight,
      itemTextStyle: itemTextStyle.merge(other._itemTextStyle),
      itemTextSelectedStyle:
          itemTextSelectedStyle.merge(other._itemTextSelectedStyle),
      dividerColor: other._dividerColor,
      cornerRadius: other._cornerRadius,
    );
  }
}
