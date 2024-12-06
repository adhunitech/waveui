import 'package:get/get.dart';
import 'package:waveui/src/theme/base/wave_base_config.dart';
import 'package:waveui/src/theme/base/wave_default_config_utils.dart';
import 'package:waveui/src/theme/base/wave_text_style.dart';
import 'package:waveui/src/theme/wave_theme_configurator.dart';
import 'package:waveui/src/theme/configs/wave_common_config.dart';
import 'package:flutter/material.dart';

/// 查看大图配置
class WaveGalleryDetailConfig extends WaveBaseConfig {
  /// 遵循全局配置
  /// 默认为 [WaveDefaultConfigUtils.defaultGalleryDetailConfig]
  WaveGalleryDetailConfig({
    WaveTextStyle? appbarTitleStyle,
    WaveTextStyle? appbarActionStyle,
    Color? appbarBackgroundColor,
    Brightness? appbarBrightness,
    WaveTextStyle? tabBarUnSelectedLabelStyle,
    WaveTextStyle? tabBarLabelStyle,
    Color? tabBarBackgroundColor,
    Color? pageBackgroundColor,
    Color? bottomBackgroundColor,
    WaveTextStyle? titleStyle,
    WaveTextStyle? contentStyle,
    WaveTextStyle? actionStyle,
    Color? iconColor,
    String configId = GLOBAL_CONFIG_ID,
  })  : _appbarTitleStyle = appbarTitleStyle,
        _appbarActionStyle = appbarActionStyle,
        _appbarBackgroundColor = appbarBackgroundColor,
        _appbarBrightness = appbarBrightness,
        _tabBarUnSelectedLabelStyle = tabBarUnSelectedLabelStyle,
        _tabBarLabelStyle = tabBarLabelStyle,
        _tabBarBackgroundColor = tabBarBackgroundColor,
        _pageBackgroundColor = pageBackgroundColor,
        _bottomBackgroundColor = bottomBackgroundColor,
        _titleStyle = titleStyle,
        _contentStyle = contentStyle,
        _actionStyle = actionStyle,
        _iconColor = iconColor,
        super(configId: configId);

  /// 黑色主题
  WaveGalleryDetailConfig.dark({
    String configId = GLOBAL_CONFIG_ID,
  }) : super(configId: configId) {
    _appbarTitleStyle = WaveTextStyle(color: commonConfig.colorTextBaseInverse);
    _appbarBackgroundColor = Colors.black;
    _appbarBrightness = Brightness.dark;
    _tabBarUnSelectedLabelStyle = WaveTextStyle(color: const Color(0XFFCCCCCC));
    _tabBarLabelStyle = WaveTextStyle(color: commonConfig.colorTextBaseInverse);
    _tabBarBackgroundColor = Colors.black;
    _pageBackgroundColor = Colors.black;
    _bottomBackgroundColor = const Color(0X88000000);
    _titleStyle = WaveTextStyle(color: commonConfig.colorTextBaseInverse);
    _contentStyle = WaveTextStyle(color: const Color(0xFFCCCCCC));
    _actionStyle = WaveTextStyle(color: commonConfig.colorTextBaseInverse);
    _iconColor = Colors.white;
  }

  /// 白色主题
  WaveGalleryDetailConfig.light({
    String configId = GLOBAL_CONFIG_ID,
  }) : super(configId: configId) {
    _appbarTitleStyle = WaveTextStyle(color: commonConfig.colorTextBase);
    _appbarActionStyle = WaveTextStyle(color: commonConfig.colorTextBase);
    _appbarBackgroundColor = commonConfig.fillBody;
    _appbarBrightness = Brightness.light;
    _tabBarUnSelectedLabelStyle = WaveTextStyle(
      color: commonConfig.colorTextBase,
    );
    _tabBarLabelStyle = WaveTextStyle(color: Get.theme.colorScheme.primary);
    _tabBarBackgroundColor = commonConfig.fillBody;
    _pageBackgroundColor = commonConfig.fillBody;
    _bottomBackgroundColor = commonConfig.fillBody.withOpacity(.85);
    _titleStyle = WaveTextStyle(color: commonConfig.colorTextBase);
    _contentStyle = WaveTextStyle(color: commonConfig.colorTextBase);
    _actionStyle = WaveTextStyle(color: commonConfig.colorTextSecondary);
    _iconColor = commonConfig.colorTextSecondary;
  }

  /// appbar   brightness待定

  /// appbar 标题样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextBaseInverse],
  ///   fontSize: [WaveCommonConfig.fontSizeHead],
  ///   fontWeight: FontWeight.w600,
  /// )
  WaveTextStyle? _appbarTitleStyle;

  /// 右侧操作区域文案样式
  ///
  /// WaveTextStyle(
  ///   color: AppBarBrightness(brightness).textColor,
  ///   fontSize: WaveAppBarTheme.actionFontSize,
  ///   fontWeight: FontWeight.w600,
  /// )
  WaveTextStyle? _appbarActionStyle;

  /// appBar 背景色
  /// 默认为 Colors.black
  Color? _appbarBackgroundColor;

  /// appbar brightness
  /// 默认为 [Brightness.dark]
  Brightness? _appbarBrightness;

  /// tabBar 标题普通样式
  ///
  /// WaveTextStyle(
  ///   color: Colors.red,
  ///   fontSize: [WaveCommonConfig.fontSizeSubHead],
  /// )
  WaveTextStyle? _tabBarUnSelectedLabelStyle;

  /// tabBar 标题选中样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextBaseInverse],
  ///   fontSize: [WaveCommonConfig.fontSizeSubHead],
  ///   fontWeight: FontWeight.w600,
  /// )
  WaveTextStyle? _tabBarLabelStyle;

  /// tabBar 背景色
  /// 默认为 Colors.black
  Color? _tabBarBackgroundColor;

  /// 页面 背景色
  /// 默认为 Colors.black
  Color? _pageBackgroundColor;

  /// 底部内容区域的背景色
  /// 默认为 Color(0x88000000)
  Color? _bottomBackgroundColor;

  /// 标题文案样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextBaseInverse],
  ///   fontSize: [WaveCommonConfig.fontSizeHead],
  ///   fontWeight: FontWeight.w600,
  /// )
  WaveTextStyle? _titleStyle;

  /// 内容文案样式
  ///
  /// WaveTextStyle(
  ///   color: Color(0xFFCCCCCC),
  ///   fontSize: [WaveCommonConfig.fontSizeBase],
  /// )
  WaveTextStyle? _contentStyle;

  /// 右侧展开收起样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextBaseInverse],
  ///   fontSize: [WaveCommonConfig.fontSizeBase],
  /// )
  WaveTextStyle? _actionStyle;

  /// icon 颜色
  /// 默认为 Colors.white
  Color? _iconColor;

  WaveTextStyle get appbarTitleStyle =>
      _appbarTitleStyle ??
      WaveDefaultConfigUtils.defaultGalleryDetailConfig.appbarTitleStyle;

  Color get appbarBackgroundColor =>
      _appbarBackgroundColor ??
      WaveDefaultConfigUtils.defaultGalleryDetailConfig.appbarBackgroundColor;

  Brightness get appbarBrightness =>
      _appbarBrightness ??
      WaveDefaultConfigUtils.defaultGalleryDetailConfig.appbarBrightness;

  WaveTextStyle get tabBarUnSelectedLabelStyle =>
      _tabBarUnSelectedLabelStyle ??
      WaveDefaultConfigUtils
          .defaultGalleryDetailConfig.tabBarUnSelectedLabelStyle;

  WaveTextStyle get tabBarLabelStyle =>
      _tabBarLabelStyle ??
      WaveDefaultConfigUtils.defaultGalleryDetailConfig.tabBarLabelStyle;

  Color get tabBarBackgroundColor =>
      _tabBarBackgroundColor ??
      WaveDefaultConfigUtils.defaultGalleryDetailConfig.tabBarBackgroundColor;

  Color get pageBackgroundColor =>
      _pageBackgroundColor ??
      WaveDefaultConfigUtils.defaultGalleryDetailConfig.pageBackgroundColor;

  Color get bottomBackgroundColor =>
      _bottomBackgroundColor ??
      WaveDefaultConfigUtils.defaultGalleryDetailConfig.bottomBackgroundColor;

  WaveTextStyle get titleStyle =>
      _titleStyle ??
      WaveDefaultConfigUtils.defaultGalleryDetailConfig.titleStyle;

  WaveTextStyle get contentStyle =>
      _contentStyle ??
      WaveDefaultConfigUtils.defaultGalleryDetailConfig.contentStyle;

  WaveTextStyle get actionStyle =>
      _actionStyle ??
      WaveDefaultConfigUtils.defaultGalleryDetailConfig.actionStyle;

  Color get iconColor =>
      _iconColor ?? WaveDefaultConfigUtils.defaultGalleryDetailConfig.iconColor;

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
    WaveGalleryDetailConfig galleryDetailConfig = WaveThemeConfigurator.instance
        .getConfig(configId: configId)
        .galleryDetailConfig;

    _appbarTitleStyle = galleryDetailConfig.appbarTitleStyle.merge(
      WaveTextStyle(
        color: commonConfig.colorTextBaseInverse,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_appbarTitleStyle),
    );

    _appbarBrightness ??= galleryDetailConfig.appbarBrightness;
    _appbarBackgroundColor ??= galleryDetailConfig.appbarBackgroundColor;
    _tabBarUnSelectedLabelStyle = galleryDetailConfig.tabBarUnSelectedLabelStyle
        .merge(WaveTextStyle(fontSize: commonConfig.fontSizeSubHead))
        .merge(_tabBarUnSelectedLabelStyle);
    _tabBarLabelStyle = galleryDetailConfig.tabBarLabelStyle
        .merge(
          WaveTextStyle(
            color: commonConfig.colorTextBaseInverse,
            fontSize: commonConfig.fontSizeSubHead,
          ),
        )
        .merge(_tabBarLabelStyle);
    _tabBarBackgroundColor ??= galleryDetailConfig._tabBarBackgroundColor;
    _pageBackgroundColor ??= galleryDetailConfig._pageBackgroundColor;
    _bottomBackgroundColor ??= galleryDetailConfig._bottomBackgroundColor;
    _titleStyle = galleryDetailConfig.titleStyle
        .merge(
          WaveTextStyle(
            color: commonConfig.colorTextBaseInverse,
            fontSize: commonConfig.fontSizeHead,
          ),
        )
        .merge(_titleStyle);
    _contentStyle = galleryDetailConfig.contentStyle
        .merge(WaveTextStyle(fontSize: commonConfig.fontSizeBase))
        .merge(_contentStyle);
    _actionStyle = galleryDetailConfig.actionStyle
        .merge(
          WaveTextStyle(
            color: commonConfig.colorTextBaseInverse,
            fontSize: commonConfig.fontSizeBase,
          ),
        )
        .merge(_actionStyle);
    _iconColor ??= galleryDetailConfig._iconColor;
  }

  WaveGalleryDetailConfig copyWith({
    WaveTextStyle? appbarTitleStyle,
    WaveTextStyle? appbarActionStyle,
    Color? appbarBackgroundColor,
    Brightness? appbarBrightness,
    WaveTextStyle? tabBarUnSelectedLabelStyle,
    Color? tabBarUnselectedLabelColor,
    WaveTextStyle? tabBarLabelStyle,
    Color? tabBarLabelColor,
    Color? tabBarBackgroundColor,
    Color? indicatorColor,
    Color? pageBackgroundColor,
    Color? bottomBackgroundColor,
    WaveTextStyle? titleStyle,
    WaveTextStyle? contentStyle,
    WaveTextStyle? actionStyle,
    Color? iconColor,
  }) {
    return WaveGalleryDetailConfig(
      appbarTitleStyle: appbarTitleStyle ?? _appbarTitleStyle,
      appbarActionStyle: appbarActionStyle ?? _appbarActionStyle,
      appbarBackgroundColor: appbarBackgroundColor ?? _appbarBackgroundColor,
      appbarBrightness: appbarBrightness ?? _appbarBrightness,
      tabBarUnSelectedLabelStyle:
          tabBarUnSelectedLabelStyle ?? _tabBarUnSelectedLabelStyle,
      tabBarLabelStyle: tabBarLabelStyle ?? _tabBarLabelStyle,
      tabBarBackgroundColor: tabBarBackgroundColor ?? _tabBarBackgroundColor,
      pageBackgroundColor: pageBackgroundColor ?? _pageBackgroundColor,
      bottomBackgroundColor: bottomBackgroundColor ?? _bottomBackgroundColor,
      titleStyle: titleStyle ?? _titleStyle,
      contentStyle: contentStyle ?? _contentStyle,
      actionStyle: actionStyle ?? _actionStyle,
      iconColor: iconColor ?? _iconColor,
    );
  }

  WaveGalleryDetailConfig merge(WaveGalleryDetailConfig? other) {
    if (other == null) return this;
    return copyWith(
      appbarTitleStyle: appbarTitleStyle.merge(other._appbarTitleStyle),
      appbarBackgroundColor: other._appbarBackgroundColor,
      appbarBrightness: other._appbarBrightness,
      tabBarUnSelectedLabelStyle:
          tabBarUnSelectedLabelStyle.merge(other._tabBarUnSelectedLabelStyle),
      tabBarLabelStyle: tabBarLabelStyle.merge(other._tabBarLabelStyle),
      tabBarBackgroundColor: other._tabBarBackgroundColor,
      pageBackgroundColor: other._pageBackgroundColor,
      bottomBackgroundColor: other._bottomBackgroundColor,
      titleStyle: titleStyle.merge(other._titleStyle),
      contentStyle: contentStyle.merge(other._contentStyle),
      actionStyle: actionStyle.merge(other._actionStyle),
      iconColor: other._iconColor,
    );
  }
}
