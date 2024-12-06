import 'package:get/get.dart';
import 'package:waveui/src/theme/base/wave_base_config.dart';
import 'package:waveui/src/theme/base/wave_default_config_utils.dart';
import 'package:waveui/src/theme/base/wave_text_style.dart';
import 'package:waveui/src/theme/wave_theme_configurator.dart';
import 'package:waveui/src/theme/configs/wave_common_config.dart';
import 'package:flutter/material.dart';

/// 描述: Dialog 弹框主配置类
class WaveDialogConfig extends WaveBaseConfig {
  WaveDialogConfig({
    double? dialogWidth,
    double? radius,
    EdgeInsets? iconPadding,
    EdgeInsets? titlePaddingSm,
    EdgeInsets? titlePaddingLg,
    WaveTextStyle? titleTextStyle,
    TextAlign? titleTextAlign,
    EdgeInsets? contentPaddingSm,
    EdgeInsets? contentPaddingLg,
    WaveTextStyle? contentTextStyle,
    TextAlign? contentTextAlign,
    EdgeInsets? warningPaddingSm,
    EdgeInsets? warningPaddingLg,
    WaveTextStyle? warningTextStyle,
    TextAlign? warningTextAlign,
    EdgeInsets? dividerPadding,
    WaveTextStyle? mainActionTextStyle,
    WaveTextStyle? assistActionsTextStyle,
    Color? mainActionBackgroundColor,
    Color? assistActionsBackgroundColor,
    double? bottomHeight,
    Color? backgroundColor,
    String configId = GLOBAL_CONFIG_ID,
  })  : _dialogWidth = dialogWidth,
        _radius = radius,
        _iconPadding = iconPadding,
        _titlePaddingSm = titlePaddingSm,
        _titlePaddingLg = titlePaddingLg,
        _titleTextStyle = titleTextStyle,
        _titleTextAlign = titleTextAlign,
        _contentPaddingSm = contentPaddingSm,
        _contentPaddingLg = contentPaddingLg,
        _contentTextStyle = contentTextStyle,
        _contentTextAlign = contentTextAlign,
        _warningPaddingSm = warningPaddingSm,
        _warningPaddingLg = warningPaddingLg,
        _warningTextStyle = warningTextStyle,
        _warningTextAlign = warningTextAlign,
        _dividerPadding = dividerPadding,
        _mainActionTextStyle = mainActionTextStyle,
        _assistActionsTextStyle = assistActionsTextStyle,
        _mainActionBackgroundColor = mainActionBackgroundColor,
        _assistActionsBackgroundColor = assistActionsBackgroundColor,
        _bottomHeight = bottomHeight,
        _backgroundColor = backgroundColor,
        super(configId: configId);

  /// Dialog 宽度
  /// 默认为 300
  double? _dialogWidth;

  double get dialogWidth =>
      _dialogWidth ?? WaveDefaultConfigUtils.defaultDialogConfig.dialogWidth;

  /// Dialog 四周圆角
  /// 默认为 [WaveCommonConfig.radiusLg]
  double? _radius;

  double get radius =>
      _radius ?? WaveDefaultConfigUtils.defaultDialogConfig.radius;

  /// Dialog icon 距离顶部的边距
  ///
  /// EdgeInsets.only(top: [WaveCommonConfig.vSpacingXxl])
  EdgeInsets? _iconPadding;

  EdgeInsets get iconPadding =>
      _iconPadding ?? WaveDefaultConfigUtils.defaultDialogConfig.iconPadding;

  /// title 在顶部有 icon 时的边距
  ///
  /// EdgeInsets.only(
  ///   top: 12,
  ///   left: [WaveCommonConfig.hSpacingXxl],
  ///   right: [WaveCommonConfig.hSpacingXxl],
  /// )
  EdgeInsets? _titlePaddingSm;

  EdgeInsets get titlePaddingSm =>
      _titlePaddingSm ??
      WaveDefaultConfigUtils.defaultDialogConfig.titlePaddingSm;

  /// title 当顶部无 icon 时的边距
  ///
  /// EdgeInsets.only(
  ///   top: 28,
  ///   left: [WaveCommonConfig.hSpacingXxl],
  ///   right: [WaveCommonConfig.hSpacingXxl],
  /// )
  EdgeInsets? _titlePaddingLg;

  EdgeInsets get titlePaddingLg =>
      _titlePaddingLg ??
      WaveDefaultConfigUtils.defaultDialogConfig.titlePaddingLg;

  /// title 标题样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextBase],
  ///   fontSize: [WaveCommonConfig.fontSizeHead],
  ///   fontWeight: FontWeight.w600,
  /// )
  WaveTextStyle? _titleTextStyle;

  WaveTextStyle get titleTextStyle =>
      _titleTextStyle ??
      WaveDefaultConfigUtils.defaultDialogConfig.titleTextStyle;

  /// 标题的文字对齐
  /// 默认为 [TextAlign.center]
  TextAlign? _titleTextAlign;

  TextAlign get titleTextAlign =>
      _titleTextAlign ??
      WaveDefaultConfigUtils.defaultDialogConfig.titleTextAlign;

  /// content 当顶部有 title 或者 icon 时的边距
  ///
  /// EdgeInsets.only(
  ///   top: 8,
  ///   left: [WaveCommonConfig.hSpacingXl],
  ///   right: [WaveCommonConfig.hSpacingXl],
  /// )
  EdgeInsets? _contentPaddingSm;

  EdgeInsets get contentPaddingSm =>
      _contentPaddingSm ??
      WaveDefaultConfigUtils.defaultDialogConfig.contentPaddingSm;

  /// content 当顶部无 title 或者 icon 时的边距
  ///
  /// EdgeInsets.only(
  ///   top: 28,
  ///   left: [WaveCommonConfig.hSpacingXl],
  ///   right: [WaveCommonConfig.hSpacingXl],
  /// )
  final EdgeInsets? _contentPaddingLg;

  EdgeInsets get contentPaddingLg =>
      _contentPaddingLg ??
      WaveDefaultConfigUtils.defaultDialogConfig.contentPaddingLg;

  /// message 内容样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextImportant],
  ///   fontSize: [WaveCommonConfig.fontSizeBase],
  /// )
  WaveTextStyle? _contentTextStyle;

  WaveTextStyle get contentTextStyle =>
      _contentTextStyle ??
      WaveDefaultConfigUtils.defaultDialogConfig.contentTextStyle;

  /// 内容文字的对齐
  /// 默认为 [TextAlign.center]
  TextAlign? _contentTextAlign;

  TextAlign get contentTextAlign =>
      _contentTextAlign ??
      WaveDefaultConfigUtils.defaultDialogConfig.contentTextAlign;

  /// warning 当顶部有 title/icon/content 时的边距
  ///
  /// EdgeInsets.only(
  ///   top: 6,
  ///   left: [WaveCommonConfig.hSpacingXl],
  ///   right: [WaveCommonConfig.hSpacingXl],
  /// )
  EdgeInsets? _warningPaddingSm;

  EdgeInsets get warningPaddingSm =>
      _warningPaddingSm ??
      WaveDefaultConfigUtils.defaultDialogConfig.warningPaddingSm;

  /// warning 当顶部无 title/icon/content 时的边距
  ///
  /// EdgeInsets.only(
  ///   top: 28,
  ///   left: [WaveCommonConfig.hSpacingXl],
  ///   right: [WaveCommonConfig.hSpacingXl],
  /// )
  EdgeInsets? _warningPaddingLg;

  EdgeInsets get warningPaddingLg =>
      _warningPaddingLg ??
      WaveDefaultConfigUtils.defaultDialogConfig.warningPaddingLg;

  /// 警告样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.brandError],
  ///   fontSize: [WaveCommonConfig.fontSizeBase],
  /// )
  WaveTextStyle? _warningTextStyle;

  WaveTextStyle get warningTextStyle =>
      _warningTextStyle ??
      WaveDefaultConfigUtils.defaultDialogConfig.warningTextStyle;

  /// 警示文案文字的对齐
  /// 默认为 [TextAlign.center]
  TextAlign? _warningTextAlign;

  TextAlign get warningTextAlign =>
      _warningTextAlign ??
      WaveDefaultConfigUtils.defaultDialogConfig.warningTextAlign;

  /// action 顶部 divider 的上方边距
  ///
  /// EdgeInsets.only(top: 28)
  EdgeInsets? _dividerPadding;

  EdgeInsets get dividerPadding =>
      _dividerPadding ??
      WaveDefaultConfigUtils.defaultDialogConfig.dividerPadding;

  /// 主色调按钮样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveGet.theme.colorScheme.primary],
  ///   fontSize: [WaveCommonConfig.fontSizeSubHead],
  ///   fontWeight: FontWeight.w600,
  /// )
  WaveTextStyle? _mainActionTextStyle;

  WaveTextStyle get mainActionTextStyle =>
      _mainActionTextStyle ??
      WaveDefaultConfigUtils.defaultDialogConfig.mainActionTextStyle;

  /// 主色调按钮的背景
  /// 默认为 [WaveCommonConfig.fillBase]
  Color? _mainActionBackgroundColor;

  Color get mainActionBackgroundColor =>
      _mainActionBackgroundColor ??
      WaveDefaultConfigUtils.defaultDialogConfig.mainActionBackgroundColor;

  /// 其他按钮的样式(超2个时按钮样式)
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextBase],
  ///   fontSize: [WaveCommonConfig.fontSizeSubHead],
  ///   fontWeight: FontWeight.w600,
  /// )
  WaveTextStyle? _assistActionsTextStyle;

  WaveTextStyle get assistActionsTextStyle =>
      _assistActionsTextStyle ??
      WaveDefaultConfigUtils.defaultDialogConfig.assistActionsTextStyle;

  /// 其他按钮的背景
  /// 默认为 [WaveCommonConfig.fillBase]
  Color? _assistActionsBackgroundColor;

  Color get assistActionsBackgroundColor =>
      _assistActionsBackgroundColor ??
      WaveDefaultConfigUtils.defaultDialogConfig.assistActionsBackgroundColor;

  /// 底部按钮高度
  /// 默认为 44.0
  double? _bottomHeight;

  double get bottomHeight =>
      _bottomHeight ?? WaveDefaultConfigUtils.defaultDialogConfig.bottomHeight;

  /// Dialog背景
  /// 默认为 [WaveCommonConfig.fillBase]
  Color? _backgroundColor;

  Color get backgroundColor =>
      _backgroundColor ??
      WaveDefaultConfigUtils.defaultDialogConfig.backgroundColor;

  /// 按优先级，打平 【WaveUI 内置配置】 < 【用户全局的默认配置】 < 【用户特殊配置】 < 【临时组件配置】
  ///
  /// 举例：
  /// ① 尝试获取最近的配置 [topRadius] 若配不为 null，直接使用该配置.
  /// ② [topRadius] 若为 null，尝试使用 全局配置中的配置 dialogConfig.
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

    /// 用户全局组件配置
    WaveDialogConfig dialogConfig = WaveThemeConfigurator.instance
        .getConfig(configId: configId)
        .dialogConfig;

    _dialogWidth ??= dialogConfig.dialogWidth;
    _radius ??= commonConfig.radiusLg;
    _titlePaddingSm ??= EdgeInsets.only(
      left: commonConfig.hSpacingXxl,
      right: commonConfig.hSpacingXxl,
      top: dialogConfig.titlePaddingSm.top,
      bottom: dialogConfig.titlePaddingSm.bottom,
    );
    _titlePaddingLg ??= EdgeInsets.only(
      left: commonConfig.hSpacingXxl,
      right: commonConfig.hSpacingXxl,
      top: dialogConfig.titlePaddingLg.top,
      bottom: dialogConfig.titlePaddingLg.bottom,
    );
    _iconPadding ??= EdgeInsets.only(
      left: dialogConfig.iconPadding.left,
      top: commonConfig.vSpacingXxl,
      right: dialogConfig.iconPadding.right,
      bottom: dialogConfig.iconPadding.bottom,
    );
    _titleTextStyle = dialogConfig.titleTextStyle.merge(
      WaveTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeHead,
      ).merge(_titleTextStyle),
    );
    _contentTextStyle = dialogConfig.contentTextStyle.merge(
      WaveTextStyle(
        color: commonConfig.colorTextImportant,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_contentTextStyle),
    );
    _warningTextStyle = dialogConfig.warningTextStyle.merge(
      WaveTextStyle(
        color: commonConfig.brandError,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_warningTextStyle),
    );
    _mainActionTextStyle = dialogConfig.mainActionTextStyle.merge(
      WaveTextStyle(
        color: Get.theme.colorScheme.primary,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_mainActionTextStyle),
    );
    _assistActionsTextStyle = dialogConfig.assistActionsTextStyle.merge(
      WaveTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_assistActionsTextStyle),
    );
    _contentPaddingSm ??= EdgeInsets.only(
      left: commonConfig.hSpacingXl,
      right: commonConfig.hSpacingXl,
      top: dialogConfig.contentPaddingSm.top,
      bottom: dialogConfig.contentPaddingSm.bottom,
    );
    _contentPaddingSm ??= EdgeInsets.only(
      left: commonConfig.hSpacingXl,
      right: commonConfig.hSpacingXl,
      top: dialogConfig.contentPaddingLg.top,
      bottom: dialogConfig.contentPaddingLg.bottom,
    );
    _warningPaddingSm ??= EdgeInsets.only(
      left: commonConfig.hSpacingXl,
      right: commonConfig.hSpacingXl,
      top: dialogConfig.warningPaddingSm.top,
      bottom: dialogConfig.warningPaddingSm.bottom,
    );
    _warningPaddingLg ??= EdgeInsets.only(
      left: commonConfig.hSpacingXl,
      right: commonConfig.hSpacingXl,
      top: dialogConfig.warningPaddingLg.top,
      bottom: dialogConfig.warningPaddingLg.bottom,
    );
    _titleTextAlign ??= dialogConfig.titleTextAlign;
    _contentTextAlign ??= dialogConfig.contentTextAlign;
    _warningTextAlign ??= dialogConfig.warningTextAlign;
    _mainActionBackgroundColor ??= commonConfig.fillBase;
    _assistActionsBackgroundColor ??= commonConfig.fillBase;
    _bottomHeight ??= dialogConfig.bottomHeight;
    _dividerPadding ??= dialogConfig.dividerPadding;
    _backgroundColor ??= commonConfig.fillBase;
  }

  WaveDialogConfig copyWith({
    double? dialogWidth,
    double? radius,
    EdgeInsets? iconPadding,
    EdgeInsets? titlePaddingSm,
    EdgeInsets? titlePaddingLg,
    WaveTextStyle? titleTextStyle,
    TextAlign? titleTextAlign,
    EdgeInsets? contentPaddingSm,
    EdgeInsets? contentPaddingLg,
    WaveTextStyle? contentTextStyle,
    TextAlign? contentTextAlign,
    EdgeInsets? warningPaddingSm,
    EdgeInsets? warningPaddingLg,
    WaveTextStyle? warningTextStyle,
    TextAlign? warningTextAlign,
    EdgeInsets? dividerPadding,
    WaveTextStyle? mainActionTextStyle,
    WaveTextStyle? assistActionsTextStyle,
    Color? mainActionBackgroundColor,
    Color? assistActionsBackgroundColor,
    double? bottomHeight,
    Color? backgroundColor,
  }) {
    return WaveDialogConfig(
      dialogWidth: dialogWidth ?? _dialogWidth,
      radius: radius ?? _radius,
      iconPadding: iconPadding ?? _iconPadding,
      titlePaddingSm: titlePaddingSm ?? _titlePaddingSm,
      titlePaddingLg: titlePaddingLg ?? _titlePaddingLg,
      titleTextStyle: titleTextStyle ?? _titleTextStyle,
      titleTextAlign: titleTextAlign ?? _titleTextAlign,
      contentPaddingSm: contentPaddingSm ?? _contentPaddingSm,
      contentPaddingLg: contentPaddingLg ?? _contentPaddingLg,
      contentTextStyle: contentTextStyle ?? _contentTextStyle,
      contentTextAlign: contentTextAlign ?? _contentTextAlign,
      warningPaddingSm: warningPaddingSm ?? _warningPaddingSm,
      warningPaddingLg: warningPaddingLg ?? _warningPaddingLg,
      warningTextStyle: warningTextStyle ?? _warningTextStyle,
      warningTextAlign: warningTextAlign ?? _warningTextAlign,
      dividerPadding: dividerPadding ?? _dividerPadding,
      mainActionTextStyle: mainActionTextStyle ?? _mainActionTextStyle,
      assistActionsTextStyle: assistActionsTextStyle ?? _assistActionsTextStyle,
      mainActionBackgroundColor:
          mainActionBackgroundColor ?? _mainActionBackgroundColor,
      assistActionsBackgroundColor:
          assistActionsBackgroundColor ?? _assistActionsBackgroundColor,
      bottomHeight: bottomHeight ?? _bottomHeight,
      backgroundColor: backgroundColor ?? _backgroundColor,
    );
  }

  WaveDialogConfig merge(WaveDialogConfig? other) {
    if (other == null) return this;
    return copyWith(
      dialogWidth: other._dialogWidth,
      radius: other._radius,
      iconPadding: other._iconPadding,
      titlePaddingSm: other._titlePaddingSm,
      titlePaddingLg: other._titlePaddingLg,
      titleTextStyle: titleTextStyle.merge(other._titleTextStyle),
      titleTextAlign: other._titleTextAlign,
      contentPaddingSm: other._contentPaddingSm,
      contentPaddingLg: other._contentPaddingLg,
      contentTextStyle: contentTextStyle.merge(other._contentTextStyle),
      contentTextAlign: other._contentTextAlign,
      warningPaddingSm: other._warningPaddingSm,
      warningPaddingLg: other._warningPaddingLg,
      warningTextStyle: warningTextStyle.merge(other._warningTextStyle),
      warningTextAlign: other._warningTextAlign,
      dividerPadding: other._dividerPadding,
      mainActionTextStyle:
          mainActionTextStyle.merge(other._mainActionTextStyle),
      assistActionsTextStyle:
          assistActionsTextStyle.merge(other._assistActionsTextStyle),
      mainActionBackgroundColor: other._mainActionBackgroundColor,
      assistActionsBackgroundColor: other._assistActionsBackgroundColor,
      bottomHeight: other._bottomHeight,
      backgroundColor: other._backgroundColor,
    );
  }
}
