import 'package:get/get.dart';
import 'package:waveui/src/theme/base/wave_base_config.dart';
import 'package:waveui/src/theme/base/wave_default_config_utils.dart';
import 'package:waveui/src/theme/base/wave_text_style.dart';
import 'package:waveui/src/theme/wave_theme_configurator.dart';
import 'package:waveui/src/theme/configs/wave_common_config.dart';
import 'package:flutter/painting.dart';

/// 筛选项 配置类
class WaveSelectionConfig extends WaveBaseConfig {
  /// 遵循外部主题配置
  /// 默认为 [WaveDefaultConfigUtils.defaultSelectionConfig]
  WaveSelectionConfig({
    WaveTextStyle? menuNormalTextStyle,
    WaveTextStyle? menuSelectedTextStyle,
    WaveTextStyle? tagNormalTextStyle,
    WaveTextStyle? tagSelectedTextStyle,
    double? tagRadius,
    Color? tagNormalBackgroundColor,
    Color? tagSelectedBackgroundColor,
    WaveTextStyle? hintTextStyle,
    WaveTextStyle? rangeTitleTextStyle,
    WaveTextStyle? inputTextStyle,
    WaveTextStyle? itemNormalTextStyle,
    WaveTextStyle? itemSelectedTextStyle,
    WaveTextStyle? itemBoldTextStyle,
    Color? deepNormalBgColor,
    Color? deepSelectBgColor,
    Color? middleNormalBgColor,
    Color? middleSelectBgColor,
    Color? lightNormalBgColor,
    Color? lightSelectBgColor,
    WaveTextStyle? resetTextStyle,
    WaveTextStyle? titleForMoreTextStyle,
    WaveTextStyle? optionTextStyle,
    WaveTextStyle? moreTextStyle,
    WaveTextStyle? flayerNormalTextStyle,
    WaveTextStyle? flayerSelectedTextStyle,
    WaveTextStyle? flayerBoldTextStyle,
    String configId = GLOBAL_CONFIG_ID,
  })  : _menuNormalTextStyle = menuNormalTextStyle,
        _menuSelectedTextStyle = menuSelectedTextStyle,
        _tagNormalTextStyle = tagNormalTextStyle,
        _tagSelectedTextStyle = tagSelectedTextStyle,
        _tagRadius = tagRadius,
        _tagNormalBackgroundColor = tagNormalBackgroundColor,
        _tagSelectedBackgroundColor = tagSelectedBackgroundColor,
        _hintTextStyle = hintTextStyle,
        _rangeTitleTextStyle = rangeTitleTextStyle,
        _inputTextStyle = inputTextStyle,
        _itemNormalTextStyle = itemNormalTextStyle,
        _itemSelectedTextStyle = itemSelectedTextStyle,
        _itemBoldTextStyle = itemBoldTextStyle,
        _deepNormalBgColor = deepNormalBgColor,
        _deepSelectBgColor = deepSelectBgColor,
        _middleNormalBgColor = middleNormalBgColor,
        _middleSelectBgColor = middleSelectBgColor,
        _lightNormalBgColor = lightNormalBgColor,
        _lightSelectBgColor = lightSelectBgColor,
        _resetTextStyle = resetTextStyle,
        _titleForMoreTextStyle = titleForMoreTextStyle,
        _optionTextStyle = optionTextStyle,
        _moreTextStyle = moreTextStyle,
        _flayerNormalTextStyle = flayerNormalTextStyle,
        _flayerSelectedTextStyle = flayerSelectedTextStyle,
        _flayerBoldTextStyle = flayerBoldTextStyle,
        super(configId: configId);

  /// menu 正常文本样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextBase],
  ///   fontSize: [WaveCommonConfig.fontSizeBase],
  ///   fontWeight: FontWeight.normal,
  /// )
  WaveTextStyle? _menuNormalTextStyle;

  /// menu 选中文本样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveGet.theme.colorScheme.primary],
  ///   fontSize: [WaveCommonConfig.fontSizeBase],
  ///   fontWeight: FontWeight.w600,
  /// )
  WaveTextStyle? _menuSelectedTextStyle;

  /// tag 正常文本样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextBase],
  ///   fontSize: [WaveCommonConfig.fontSizeCaption],
  ///   fontWeight: FontWeight.w400,
  /// )
  WaveTextStyle? _tagNormalTextStyle;

  /// tag 选中文本样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveGet.theme.colorScheme.primary],
  ///   fontSize: [WaveCommonConfig.fontSizeCaption],
  ///   fontWeight: FontWeight.w600,
  /// )
  WaveTextStyle? _tagSelectedTextStyle;

  /// tag 圆角
  /// 默认为 [WaveCommonConfig.radiusSm]
  double? _tagRadius;

  /// tag 正常背景色
  /// 默认为 [WaveCommonConfig.fillBody]
  Color? _tagNormalBackgroundColor;

  /// tag 选中背景色
  /// 默认为 [WaveGet.theme.colorScheme.primary].withOpacity(0.12)
  Color? _tagSelectedBackgroundColor;

  /// 输入选项标题文本样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextBase],
  ///   fontSize: [WaveCommonConfig.fontSizeSubHead],
  ///   fontWeight: FontWeight.w600,
  /// )
  WaveTextStyle? _rangeTitleTextStyle;

  /// 输入提示文本样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextHint],
  ///   fontSize: [WaveCommonConfig.fontSizeBase],
  /// )
  WaveTextStyle? _hintTextStyle;

  /// 输入框默认文本样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextBase],
  ///   fontSize: [WaveCommonConfig.fontSizeBase],
  /// )
  WaveTextStyle? _inputTextStyle;

  /// item 正常字体样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextBase],
  ///   fontSize: [WaveCommonConfig.fontSizeBase],
  /// )
  WaveTextStyle? _itemNormalTextStyle;

  /// item 选中文本样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveGet.theme.colorScheme.primary],
  ///   fontSize: [WaveCommonConfig.fontSizeBase],
  ///   fontWeight: FontWeight.w600,
  /// )
  WaveTextStyle? _itemSelectedTextStyle;

  /// item 仅加粗样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextBase],
  ///   fontSize: [WaveCommonConfig.fontSizeBase],
  ///   fontWeight: FontWeight.w600,
  /// )
  WaveTextStyle? _itemBoldTextStyle;

  /// 三级 item 背景色
  /// 默认为 Color(0xFFF0F0F0)
  Color? _deepNormalBgColor;

  /// 三级 item 选中背景色
  /// 默认为 Color(0xFFF8F8F8)
  Color? _deepSelectBgColor;

  /// 二级 item 背景色
  /// 默认为 Color(0xFFF8F8F8)
  Color? _middleNormalBgColor;

  /// 二级 item 选中背景色
  /// 默认为 Colors.white
  Color? _middleSelectBgColor;

  /// 一级 item 背景色
  /// 默认为 Colors.white
  Color? _lightNormalBgColor;

  /// 一级 item 选中背景色
  /// 默认为 Colors.white
  Color? _lightSelectBgColor;

  /// 重置按钮颜色
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextImportant],
  ///   fontSize: [WaveCommonConfig.fontSizeCaption]
  /// )
  WaveTextStyle? _resetTextStyle;

  /// 更多筛选-标题文本样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextBase],
  ///   fontSize: [WaveCommonConfig.fontSizeBase],
  ///   fontWeight: FontWeight.w600,
  /// )
  WaveTextStyle? _titleForMoreTextStyle;

  /// 选项-显示文本
  ///
  /// WaveTextStyle(
  ///   color: [WaveGet.theme.colorScheme.primary],
  ///   fontSize: [WaveCommonConfig.fontSizeBase],
  /// )
  WaveTextStyle? _optionTextStyle;

  /// 更多文本样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextSecondary],
  ///   fontSize: [WaveCommonConfig.fontSizeCaption],
  /// )
  WaveTextStyle? _moreTextStyle;

  /// 跳转二级页-正常文本样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextBase],
  ///   fontSize: [WaveCommonConfig.fontSizeSubHead],
  ///   fontWeight: FontWeight.normal,
  /// )
  WaveTextStyle? _flayerNormalTextStyle;

  /// 跳转二级页-选中文本样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveGet.theme.colorScheme.primary],
  ///   fontSize: [WaveCommonConfig.fontSizeSubHead],
  ///   fontWeight: FontWeight.w600,
  /// )
  WaveTextStyle? _flayerSelectedTextStyle;

  /// 跳转二级页-加粗文本样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextBase],
  ///   fontSize: [WaveCommonConfig.fontSizeSubHead],
  ///   fontWeight: FontWeight.w600
  /// )
  WaveTextStyle? _flayerBoldTextStyle;

  WaveTextStyle get menuNormalTextStyle =>
      _menuNormalTextStyle ??
      WaveDefaultConfigUtils.defaultSelectionConfig.menuNormalTextStyle;

  WaveTextStyle get menuSelectedTextStyle =>
      _menuSelectedTextStyle ??
      WaveDefaultConfigUtils.defaultSelectionConfig.menuSelectedTextStyle;

  WaveTextStyle get tagNormalTextStyle =>
      _tagNormalTextStyle ??
      WaveDefaultConfigUtils.defaultSelectionConfig.tagNormalTextStyle;

  WaveTextStyle get tagSelectedTextStyle =>
      _tagSelectedTextStyle ??
      WaveDefaultConfigUtils.defaultSelectionConfig.tagSelectedTextStyle;

  double get tagRadius =>
      _tagRadius ?? WaveDefaultConfigUtils.defaultSelectionConfig.tagRadius;

  Color get tagNormalBackgroundColor =>
      _tagNormalBackgroundColor ??
      WaveDefaultConfigUtils.defaultSelectionConfig.tagNormalBackgroundColor;

  Color get tagSelectedBackgroundColor =>
      _tagSelectedBackgroundColor ??
      WaveDefaultConfigUtils.defaultSelectionConfig.tagSelectedBackgroundColor;

  WaveTextStyle get rangeTitleTextStyle =>
      _rangeTitleTextStyle ??
      WaveDefaultConfigUtils.defaultSelectionConfig.rangeTitleTextStyle;

  WaveTextStyle get hintTextStyle =>
      _hintTextStyle ??
      WaveDefaultConfigUtils.defaultSelectionConfig.hintTextStyle;

  WaveTextStyle get inputTextStyle =>
      _inputTextStyle ??
      WaveDefaultConfigUtils.defaultSelectionConfig.inputTextStyle;

  WaveTextStyle get itemNormalTextStyle =>
      _itemNormalTextStyle ??
      WaveDefaultConfigUtils.defaultSelectionConfig.itemNormalTextStyle;

  WaveTextStyle get itemSelectedTextStyle =>
      _itemSelectedTextStyle ??
      WaveDefaultConfigUtils.defaultSelectionConfig.itemSelectedTextStyle;

  WaveTextStyle get itemBoldTextStyle =>
      _itemBoldTextStyle ??
      WaveDefaultConfigUtils.defaultSelectionConfig.itemBoldTextStyle;

  Color get deepNormalBgColor =>
      _deepNormalBgColor ??
      WaveDefaultConfigUtils.defaultSelectionConfig.deepNormalBgColor;

  Color get deepSelectBgColor =>
      _deepSelectBgColor ??
      WaveDefaultConfigUtils.defaultSelectionConfig.deepSelectBgColor;

  Color get middleNormalBgColor =>
      _middleNormalBgColor ??
      WaveDefaultConfigUtils.defaultSelectionConfig.middleNormalBgColor;

  Color get middleSelectBgColor =>
      _middleSelectBgColor ??
      WaveDefaultConfigUtils.defaultSelectionConfig.middleSelectBgColor;

  Color get lightNormalBgColor =>
      _lightNormalBgColor ??
      WaveDefaultConfigUtils.defaultSelectionConfig.lightNormalBgColor;

  Color get lightSelectBgColor =>
      _lightSelectBgColor ??
      WaveDefaultConfigUtils.defaultSelectionConfig.lightSelectBgColor;

  WaveTextStyle get resetTextStyle =>
      _resetTextStyle ??
      WaveDefaultConfigUtils.defaultSelectionConfig.resetTextStyle;

  WaveTextStyle get titleForMoreTextStyle =>
      _titleForMoreTextStyle ??
      WaveDefaultConfigUtils.defaultSelectionConfig.titleForMoreTextStyle;

  WaveTextStyle get optionTextStyle =>
      _optionTextStyle ??
      WaveDefaultConfigUtils.defaultSelectionConfig.optionTextStyle;

  WaveTextStyle get moreTextStyle =>
      _moreTextStyle ??
      WaveDefaultConfigUtils.defaultSelectionConfig.moreTextStyle;

  WaveTextStyle get flayerNormalTextStyle =>
      _flayerNormalTextStyle ??
      WaveDefaultConfigUtils.defaultSelectionConfig.flayerNormalTextStyle;

  WaveTextStyle get flayerSelectedTextStyle =>
      _flayerSelectedTextStyle ??
      WaveDefaultConfigUtils.defaultSelectionConfig.flayerSelectedTextStyle;

  WaveTextStyle get flayerBoldTextStyle =>
      _flayerBoldTextStyle ??
      WaveDefaultConfigUtils.defaultSelectionConfig.flayerBoldTextStyle;

  @override
  void initThemeConfig(
    String configId, {
    WaveCommonConfig? currentLevelCommonConfig,
  }) {
    super.initThemeConfig(
      configId,
      currentLevelCommonConfig: currentLevelCommonConfig,
    );

    /// 用户全局筛选配置
    WaveSelectionConfig selectionConfig = WaveThemeConfigurator.instance
        .getConfig(configId: configId)
        .selectionConfig;

    _lightSelectBgColor ??= selectionConfig._lightSelectBgColor;
    _lightNormalBgColor ??= selectionConfig._lightNormalBgColor;
    _middleSelectBgColor ??= selectionConfig._middleSelectBgColor;
    _middleNormalBgColor ??= selectionConfig._middleNormalBgColor;
    _deepSelectBgColor ??= selectionConfig._deepSelectBgColor;
    _deepNormalBgColor ??= selectionConfig._deepNormalBgColor;
    _tagSelectedBackgroundColor ??=
        Get.theme.colorScheme.primary.withOpacity(0.12);
    _tagNormalBackgroundColor ??= commonConfig.fillBody;
    _tagRadius ??= commonConfig.radiusSm;
    _flayerBoldTextStyle = selectionConfig.flayerBoldTextStyle.merge(
      WaveTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_flayerBoldTextStyle),
    );
    _flayerSelectedTextStyle = selectionConfig.flayerSelectedTextStyle.merge(
      WaveTextStyle(
        color: Get.theme.colorScheme.primary,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_flayerSelectedTextStyle),
    );
    _flayerNormalTextStyle = selectionConfig.flayerNormalTextStyle.merge(
      WaveTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_flayerNormalTextStyle),
    );
    _moreTextStyle = selectionConfig.moreTextStyle.merge(
      WaveTextStyle(
        color: commonConfig.colorTextSecondary,
        fontSize: commonConfig.fontSizeCaption,
      ).merge(_moreTextStyle),
    );
    _optionTextStyle = selectionConfig.optionTextStyle.merge(
      WaveTextStyle(
        color: Get.theme.colorScheme.primary,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_optionTextStyle),
    );
    _titleForMoreTextStyle = selectionConfig.titleForMoreTextStyle.merge(
      WaveTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_titleForMoreTextStyle),
    );
    _resetTextStyle = selectionConfig.resetTextStyle.merge(WaveTextStyle(
      color: commonConfig.colorTextImportant,
      fontSize: commonConfig.fontSizeCaption,
    ).merge(_resetTextStyle));
    _itemBoldTextStyle = selectionConfig.itemBoldTextStyle.merge(
      WaveTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_itemBoldTextStyle),
    );
    _itemSelectedTextStyle = selectionConfig.itemSelectedTextStyle.merge(
      WaveTextStyle(
        color: Get.theme.colorScheme.primary,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_itemSelectedTextStyle),
    );
    _itemNormalTextStyle = selectionConfig.itemNormalTextStyle.merge(
      WaveTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_itemNormalTextStyle),
    );
    _inputTextStyle = selectionConfig.inputTextStyle.merge(
      WaveTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_inputTextStyle),
    );
    _hintTextStyle = selectionConfig.hintTextStyle.merge(
      WaveTextStyle(
        color: commonConfig.colorTextHint,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_hintTextStyle),
    );
    _rangeTitleTextStyle = selectionConfig.rangeTitleTextStyle.merge(
      WaveTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_rangeTitleTextStyle),
    );
    _tagSelectedTextStyle = selectionConfig.tagSelectedTextStyle.merge(
      WaveTextStyle(
        color: Get.theme.colorScheme.primary,
        fontSize: commonConfig.fontSizeCaption,
      ).merge(_tagSelectedTextStyle),
    );
    _tagNormalTextStyle = selectionConfig.tagNormalTextStyle.merge(
      WaveTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeCaption,
      ).merge(_tagNormalTextStyle),
    );
    _menuNormalTextStyle = selectionConfig.menuNormalTextStyle.merge(
      WaveTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_menuNormalTextStyle),
    );
    _menuSelectedTextStyle = selectionConfig.menuSelectedTextStyle.merge(
      WaveTextStyle(
        color: Get.theme.colorScheme.primary,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_menuSelectedTextStyle),
    );
  }

  WaveSelectionConfig copyWith({
    WaveTextStyle? menuNormalTextStyle,
    WaveTextStyle? menuSelectedTextStyle,
    WaveTextStyle? tagTextStyle,
    WaveTextStyle? tagSelectedTextStyle,
    double? tagRadius,
    Color? tagBackgroundColor,
    Color? tagSelectedBackgroundColor,
    WaveTextStyle? hintTextStyle,
    WaveTextStyle? rangeTitleTextStyle,
    WaveTextStyle? inputTextStyle,
    WaveTextStyle? itemNormalTextStyle,
    WaveTextStyle? itemSelectedTextStyle,
    WaveTextStyle? itemBoldTextStyle,
    Color? deepNormalBgColor,
    Color? deepSelectBgColor,
    Color? middleNormalBgColor,
    Color? middleSelectBgColor,
    Color? lightNormalBgColor,
    Color? lightSelectBgColor,
    WaveTextStyle? resetTextStyle,
    WaveTextStyle? titleForMoreTextStyle,
    WaveTextStyle? optionTextStyle,
    WaveTextStyle? moreTextStyle,
    WaveTextStyle? flayerNormalTextStyle,
    WaveTextStyle? flayerSelectedTextStyle,
    WaveTextStyle? flayerBoldTextStyle,
  }) {
    return WaveSelectionConfig(
      menuNormalTextStyle: menuNormalTextStyle ?? _menuNormalTextStyle,
      menuSelectedTextStyle: menuSelectedTextStyle ?? _menuSelectedTextStyle,
      tagNormalTextStyle: tagTextStyle ?? _tagNormalTextStyle,
      tagSelectedTextStyle: tagSelectedTextStyle ?? _tagSelectedTextStyle,
      tagRadius: tagRadius ?? _tagRadius,
      tagNormalBackgroundColor: tagBackgroundColor ?? _tagNormalBackgroundColor,
      tagSelectedBackgroundColor:
          tagSelectedBackgroundColor ?? _tagSelectedBackgroundColor,
      hintTextStyle: hintTextStyle ?? _hintTextStyle,
      rangeTitleTextStyle: rangeTitleTextStyle ?? _rangeTitleTextStyle,
      inputTextStyle: inputTextStyle ?? _inputTextStyle,
      itemNormalTextStyle: itemNormalTextStyle ?? _itemNormalTextStyle,
      itemSelectedTextStyle: itemSelectedTextStyle ?? _itemSelectedTextStyle,
      itemBoldTextStyle: itemBoldTextStyle ?? _itemBoldTextStyle,
      deepNormalBgColor: deepNormalBgColor ?? _deepNormalBgColor,
      deepSelectBgColor: deepSelectBgColor ?? _deepSelectBgColor,
      middleNormalBgColor: middleNormalBgColor ?? _middleNormalBgColor,
      middleSelectBgColor: middleSelectBgColor ?? _middleSelectBgColor,
      lightNormalBgColor: lightNormalBgColor ?? _lightNormalBgColor,
      lightSelectBgColor: lightSelectBgColor ?? _lightSelectBgColor,
      resetTextStyle: resetTextStyle ?? _resetTextStyle,
      titleForMoreTextStyle: titleForMoreTextStyle ?? _titleForMoreTextStyle,
      optionTextStyle: optionTextStyle ?? _optionTextStyle,
      moreTextStyle: moreTextStyle ?? _moreTextStyle,
      flayerNormalTextStyle: flayerNormalTextStyle ?? _flayerNormalTextStyle,
      flayerSelectedTextStyle:
          flayerSelectedTextStyle ?? _flayerSelectedTextStyle,
      flayerBoldTextStyle: flayerBoldTextStyle ?? _flayerBoldTextStyle,
    );
  }

  WaveSelectionConfig merge(WaveSelectionConfig other) {
    return copyWith(
      menuNormalTextStyle:
          menuNormalTextStyle.merge(other._menuNormalTextStyle),
      menuSelectedTextStyle:
          menuSelectedTextStyle.merge(other._menuSelectedTextStyle),
      tagTextStyle: tagNormalTextStyle.merge(other._tagNormalTextStyle),
      tagSelectedTextStyle:
          tagSelectedTextStyle.merge(other._tagSelectedTextStyle),
      tagRadius: other._tagRadius,
      tagBackgroundColor: other._tagNormalBackgroundColor,
      tagSelectedBackgroundColor: other._tagSelectedBackgroundColor,
      hintTextStyle: hintTextStyle.merge(other._hintTextStyle),
      rangeTitleTextStyle:
          rangeTitleTextStyle.merge(other._rangeTitleTextStyle),
      inputTextStyle: inputTextStyle.merge(other._inputTextStyle),
      itemNormalTextStyle:
          itemNormalTextStyle.merge(other._itemNormalTextStyle),
      itemSelectedTextStyle:
          itemSelectedTextStyle.merge(other._itemSelectedTextStyle),
      itemBoldTextStyle: itemBoldTextStyle.merge(other._itemBoldTextStyle),
      deepNormalBgColor: other._deepNormalBgColor,
      deepSelectBgColor: other._deepSelectBgColor,
      middleNormalBgColor: other._middleNormalBgColor,
      middleSelectBgColor: other._middleSelectBgColor,
      lightNormalBgColor: other._lightNormalBgColor,
      lightSelectBgColor: other._lightSelectBgColor,
      resetTextStyle: resetTextStyle.merge(other._resetTextStyle),
      titleForMoreTextStyle:
          titleForMoreTextStyle.merge(other._titleForMoreTextStyle),
      optionTextStyle: optionTextStyle.merge(other._optionTextStyle),
      moreTextStyle: moreTextStyle.merge(other._moreTextStyle),
      flayerNormalTextStyle:
          flayerNormalTextStyle.merge(other._flayerNormalTextStyle),
      flayerSelectedTextStyle:
          flayerSelectedTextStyle.merge(other._flayerSelectedTextStyle),
      flayerBoldTextStyle:
          flayerBoldTextStyle.merge(other._flayerBoldTextStyle),
    );
  }
}
