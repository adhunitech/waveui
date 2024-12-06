import 'package:get/get.dart';
import 'package:waveui/src/theme/base/wave_base_config.dart';
import 'package:waveui/src/theme/base/wave_default_config_utils.dart';
import 'package:waveui/src/theme/base/wave_text_style.dart';
import 'package:waveui/src/theme/wave_theme_configurator.dart';
import 'package:waveui/src/theme/configs/wave_common_config.dart';
import 'package:flutter/material.dart';

/// 描述: form 表单项主配置类
class WaveFormItemConfig extends WaveBaseConfig {
  /// 遵循全局配置
  /// 默认为 [WaveDefaultConfigUtils.defaultFormItemConfig]
  WaveFormItemConfig({
    Color? backgroundColor,
    WaveTextStyle? titleTextStyle,
    WaveTextStyle? subTitleTextStyle,
    WaveTextStyle? errorTextStyle,
    WaveTextStyle? hintTextStyle,
    WaveTextStyle? contentTextStyle,
    EdgeInsets? formPadding,
    EdgeInsets? titlePaddingSm,
    EdgeInsets? titlePaddingLg,
    EdgeInsets? optionsMiddlePadding,
    EdgeInsets? subTitlePadding,
    EdgeInsets? errorPadding,
    WaveTextStyle? disableTextStyle,
    WaveTextStyle? tipsTextStyle,
    WaveTextStyle? headTitleTextStyle,
    WaveTextStyle? optionTextStyle,
    WaveTextStyle? optionSelectedTextStyle,
    String configId = GLOBAL_CONFIG_ID,
  })  : _backgroundColor = backgroundColor,
        _titleTextStyle = titleTextStyle,
        _subTitleTextStyle = subTitleTextStyle,
        _errorTextStyle = errorTextStyle,
        _hintTextStyle = hintTextStyle,
        _contentTextStyle = contentTextStyle,
        _formPadding = formPadding,
        _titlePaddingSm = titlePaddingSm,
        _titlePaddingLg = titlePaddingLg,
        _optionsMiddlePadding = optionsMiddlePadding,
        _subTitlePadding = subTitlePadding,
        _errorPadding = errorPadding,
        _disableTextStyle = disableTextStyle,
        _tipsTextStyle = tipsTextStyle,
        _headTitleTextStyle = headTitleTextStyle,
        _optionTextStyle = optionTextStyle,
        _optionSelectedTextStyle = optionSelectedTextStyle,
        super(configId: configId);

  WaveFormItemConfig.generatorFromConfigId(String configId) {
    initThemeConfig(configId);
  }

  /// 表单项整体背景色
  /// default color is Colors.White
  Color? _backgroundColor;

  /// 左侧标题文本样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextBase],
  ///   fontSize: [WaveCommonConfig.fontSizeHead],
  /// )
  WaveTextStyle? _headTitleTextStyle;

  /// 左侧标题文本样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextBase],
  ///   fontSize: [WaveCommonConfig.fontSizeSubHead],
  /// )
  WaveTextStyle? _titleTextStyle;

  /// 左侧辅助文本样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextSecondary],
  ///   fontSize: [WaveCommonConfig.fontSizeCaption],
  /// )
  WaveTextStyle? _subTitleTextStyle;

  /// 左侧 Error 文本样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.brandError],
  ///   fontSize: [WaveCommonConfig.fontSizeCaption],
  /// )
  WaveTextStyle? _errorTextStyle;

  /// 右侧 输入、选择提示文本样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextHint],
  ///   fontSize: [WaveCommonConfig.fontSizeSubHead],
  /// )
  WaveTextStyle? _hintTextStyle;

  /// 右侧 主要内容样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextBase],
  ///   fontSize: [WaveCommonConfig.fontSizeSubHead],
  /// )
  WaveTextStyle? _contentTextStyle;

  /// 表单项 当有星号标识 上下右边距
  ///
  /// EdgeInsets.only(
  ///   left: 0,
  ///   top: [WaveCommonConfig.vSpacingLg],
  ///   right: [WaveCommonConfig.hSpacingLg],
  ///   bottom: [WaveCommonConfig.vSpacingLg],
  /// )
  EdgeInsets? _formPadding;

  /// 表单项 当有星号标识 左边距
  ///
  /// EdgeInsets.only(left: 10)
  EdgeInsets? _titlePaddingSm;

  /// 表单项 当无星号标识 左右边距
  ///
  /// EdgeInsets.only(left: [WaveCommonConfig.hSpacingLg])
  EdgeInsets? _titlePaddingLg;

  /// 选项之间间距 单选 or 多选
  ///
  /// EdgeInsets.only(left: [WaveCommonConfig.hSpacingMd])
  EdgeInsets? _optionsMiddlePadding;

  /// 选项普通文本样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextBase],
  ///   fontSize: [WaveCommonConfig.fontSizeSubHead],
  ///   height: 1.3,
  /// )
  WaveTextStyle? _optionTextStyle;

  /// 选项选中文本样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveGet.theme.colorScheme.primary],
  ///   fontSize: [WaveCommonConfig.fontSizeSubHead],
  ///   height: 1.3,
  /// )
  WaveTextStyle? _optionSelectedTextStyle;

  /// 子标题 左上间距
  ///
  /// EdgeInsets.only(
  ///   left: [WaveCommonConfig.hSpacingLg],
  ///   top: [WaveCommonConfig.vSpacingXs],
  /// )
  EdgeInsets? _subTitlePadding;

  /// error提示 左上间距
  ///
  /// EdgeInsets.only(
  ///   left: [WaveCommonConfig.hSpacingLg],
  ///   top: [WaveCommonConfig.vSpacingXs],
  /// )
  EdgeInsets? _errorPadding;

  /// 不可修改内容展示
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextDisabled],
  ///   fontSize: [WaveCommonConfig.fontSizeSubHead],
  /// )
  WaveTextStyle? _disableTextStyle;

  /// 提示文本样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextSecondary],
  ///   fontSize: [WaveCommonConfig.fontSizeBase],
  /// )
  WaveTextStyle? _tipsTextStyle;

  Color get backgroundColor =>
      _backgroundColor ??
      WaveDefaultConfigUtils.defaultFormItemConfig.backgroundColor;

  WaveTextStyle get headTitleTextStyle =>
      _headTitleTextStyle ??
      WaveDefaultConfigUtils.defaultFormItemConfig.headTitleTextStyle;

  WaveTextStyle get titleTextStyle =>
      _titleTextStyle ??
      WaveDefaultConfigUtils.defaultFormItemConfig.titleTextStyle;

  WaveTextStyle get subTitleTextStyle =>
      _subTitleTextStyle ??
      WaveDefaultConfigUtils.defaultFormItemConfig.subTitleTextStyle;

  WaveTextStyle get errorTextStyle =>
      _errorTextStyle ??
      WaveDefaultConfigUtils.defaultFormItemConfig.errorTextStyle;

  WaveTextStyle get hintTextStyle =>
      _hintTextStyle ??
      WaveDefaultConfigUtils.defaultFormItemConfig.hintTextStyle;

  WaveTextStyle get contentTextStyle =>
      _contentTextStyle ??
      WaveDefaultConfigUtils.defaultFormItemConfig.contentTextStyle;

  EdgeInsets get formPadding =>
      _formPadding ?? WaveDefaultConfigUtils.defaultFormItemConfig.formPadding;

  EdgeInsets get titlePaddingSm =>
      _titlePaddingSm ??
      WaveDefaultConfigUtils.defaultFormItemConfig.titlePaddingSm;

  EdgeInsets get titlePaddingLg =>
      _titlePaddingLg ??
      WaveDefaultConfigUtils.defaultFormItemConfig.titlePaddingLg;

  EdgeInsets get optionsMiddlePadding =>
      _optionsMiddlePadding ??
      WaveDefaultConfigUtils.defaultFormItemConfig.optionsMiddlePadding;

  WaveTextStyle get optionTextStyle =>
      _optionTextStyle ??
      WaveDefaultConfigUtils.defaultFormItemConfig.optionTextStyle;

  WaveTextStyle get optionSelectedTextStyle =>
      _optionSelectedTextStyle ??
      WaveDefaultConfigUtils.defaultFormItemConfig.optionSelectedTextStyle;

  EdgeInsets get subTitlePadding =>
      _subTitlePadding ??
      WaveDefaultConfigUtils.defaultFormItemConfig.subTitlePadding;

  EdgeInsets get errorPadding =>
      _errorPadding ??
      WaveDefaultConfigUtils.defaultFormItemConfig.errorPadding;

  WaveTextStyle get disableTextStyle =>
      _disableTextStyle ??
      WaveDefaultConfigUtils.defaultFormItemConfig.disableTextStyle;

  WaveTextStyle get tipsTextStyle =>
      _tipsTextStyle ??
      WaveDefaultConfigUtils.defaultFormItemConfig.tipsTextStyle;

  /// 举例：
  /// ① 尝试获取最近的配置 [topRadius] 若配不为 null，直接使用该配置.
  /// ② [topRadius] 若为 null，尝试使用 全局配置中的配置 WaveFormItemConfig.
  /// ③ 如果全局配置中的配置同样为 null 则根据 [configId] 取出全局配置。
  /// ④ 如果没有配置 [configId] 的全局配置，则使用 WaveUI 默认的配置
  @override
  void initThemeConfig(
    String configId, {
    WaveCommonConfig? currentLevelCommonConfig,
  }) {
    super.initThemeConfig(
      configId,
      currentLevelCommonConfig: currentLevelCommonConfig,
    );

    /// 用户全局form组件配置
    WaveFormItemConfig formItemThemeData = WaveThemeConfigurator.instance
        .getConfig(configId: configId)
        .formItemConfig;

    _backgroundColor ??= formItemThemeData.backgroundColor;
    _titlePaddingSm ??= formItemThemeData.titlePaddingSm;
    _titlePaddingLg ??= formItemThemeData.titlePaddingLg;
    _optionSelectedTextStyle = formItemThemeData.optionSelectedTextStyle.merge(
      WaveTextStyle(
        color: Get.theme.colorScheme.primary,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_optionSelectedTextStyle),
    );
    _optionTextStyle = formItemThemeData.optionTextStyle.merge(
      WaveTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_optionTextStyle),
    );
    _headTitleTextStyle = formItemThemeData.headTitleTextStyle.merge(
      WaveTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeHead,
      ).merge(_headTitleTextStyle),
    );
    _errorPadding ??= EdgeInsets.only(
      left: commonConfig.hSpacingLg,
      right: formItemThemeData.errorPadding.right,
      top: commonConfig.vSpacingXs,
      bottom: formItemThemeData.errorPadding.bottom,
    );
    _subTitlePadding ??= EdgeInsets.only(
      left: commonConfig.hSpacingLg,
      right: formItemThemeData.subTitlePadding.right,
      top: commonConfig.vSpacingXs,
      bottom: formItemThemeData.subTitlePadding.bottom,
    );
    _formPadding ??= EdgeInsets.only(
      left: formItemThemeData.formPadding.left,
      right: commonConfig.hSpacingLg,
      top: commonConfig.vSpacingLg,
      bottom: commonConfig.vSpacingLg,
    );
    _tipsTextStyle = formItemThemeData.tipsTextStyle.merge(
      WaveTextStyle(
        color: commonConfig.colorTextSecondary,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_tipsTextStyle),
    );
    _disableTextStyle = formItemThemeData.disableTextStyle.merge(
      WaveTextStyle(
        color: commonConfig.colorTextDisabled,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_disableTextStyle),
    );
    _contentTextStyle = formItemThemeData.contentTextStyle.merge(
      WaveTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_contentTextStyle),
    );
    _hintTextStyle = formItemThemeData.hintTextStyle.merge(
      WaveTextStyle(
        color: commonConfig.colorTextHint,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_hintTextStyle),
    );
    _titleTextStyle = formItemThemeData.titleTextStyle.merge(
      WaveTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_titleTextStyle),
    );
    _subTitleTextStyle = formItemThemeData.subTitleTextStyle.merge(
      WaveTextStyle(
        color: commonConfig.colorTextSecondary,
        fontSize: commonConfig.fontSizeCaption,
      ).merge(_subTitleTextStyle),
    );
    _errorTextStyle = formItemThemeData.errorTextStyle.merge(
      WaveTextStyle(
        color: commonConfig.brandError,
        fontSize: commonConfig.fontSizeCaption,
      ).merge(_errorTextStyle),
    );
    _optionsMiddlePadding ??= formItemThemeData.optionsMiddlePadding;
  }

  WaveFormItemConfig copyWith({
    Color? backgroundColor,
    WaveTextStyle? titleTextStyle,
    WaveTextStyle? subTitleTextStyle,
    WaveTextStyle? errorTextStyle,
    WaveTextStyle? hintTextStyle,
    WaveTextStyle? contentTextStyle,
    EdgeInsets? formPadding,
    EdgeInsets? titlePaddingSm,
    EdgeInsets? titlePaddingLg,
    EdgeInsets? optionsMiddlePadding,
    EdgeInsets? subTitlePadding,
    EdgeInsets? errorPadding,
    WaveTextStyle? disableTextStyle,
    WaveTextStyle? tipsTextStyle,
    WaveTextStyle? headTitleTextStyle,
    WaveTextStyle? optionTextStyle,
    WaveTextStyle? optionSelectedTextStyle,
  }) {
    return WaveFormItemConfig(
      backgroundColor: backgroundColor ?? _backgroundColor,
      titleTextStyle: titleTextStyle ?? _titleTextStyle,
      subTitleTextStyle: subTitleTextStyle ?? _subTitleTextStyle,
      errorTextStyle: errorTextStyle ?? _errorTextStyle,
      hintTextStyle: hintTextStyle ?? _hintTextStyle,
      contentTextStyle: contentTextStyle ?? _contentTextStyle,
      formPadding: formPadding ?? _formPadding,
      titlePaddingSm: titlePaddingSm ?? _titlePaddingSm,
      titlePaddingLg: titlePaddingLg ?? _titlePaddingLg,
      optionsMiddlePadding: optionsMiddlePadding ?? _optionsMiddlePadding,
      subTitlePadding: subTitlePadding ?? _subTitlePadding,
      errorPadding: errorPadding ?? _errorPadding,
      disableTextStyle: disableTextStyle ?? _disableTextStyle,
      tipsTextStyle: tipsTextStyle ?? _tipsTextStyle,
      headTitleTextStyle: headTitleTextStyle ?? _headTitleTextStyle,
      optionTextStyle: optionTextStyle ?? _optionTextStyle,
      optionSelectedTextStyle:
          optionSelectedTextStyle ?? _optionSelectedTextStyle,
    );
  }

  WaveFormItemConfig merge(WaveFormItemConfig? other) {
    if (other == null) return this;
    return copyWith(
      backgroundColor: other._backgroundColor,
      titleTextStyle: titleTextStyle.merge(other._titleTextStyle),
      subTitleTextStyle: subTitleTextStyle.merge(other._subTitleTextStyle),
      errorTextStyle: errorTextStyle.merge(other._errorTextStyle),
      hintTextStyle: hintTextStyle.merge(other._hintTextStyle),
      contentTextStyle: contentTextStyle.merge(other._contentTextStyle),
      formPadding: other._formPadding,
      titlePaddingSm: other._titlePaddingSm,
      titlePaddingLg: other._titlePaddingLg,
      optionsMiddlePadding: other._optionsMiddlePadding,
      subTitlePadding: other._subTitlePadding,
      errorPadding: other._errorPadding,
      disableTextStyle: disableTextStyle.merge(other._disableTextStyle),
      tipsTextStyle: tipsTextStyle.merge(other._tipsTextStyle),
      headTitleTextStyle: headTitleTextStyle.merge(other._headTitleTextStyle),
      optionTextStyle: optionTextStyle.merge(other._optionTextStyle),
      optionSelectedTextStyle:
          optionSelectedTextStyle.merge(other._optionSelectedTextStyle),
    );
  }
}
