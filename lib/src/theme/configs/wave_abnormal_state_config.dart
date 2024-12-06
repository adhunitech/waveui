import 'package:get/get.dart';
import 'package:waveui/src/theme/base/wave_base_config.dart';
import 'package:waveui/src/theme/base/wave_default_config_utils.dart';
import 'package:waveui/src/theme/base/wave_text_style.dart';
import 'package:waveui/src/theme/wave_theme_configurator.dart';
import 'package:waveui/src/theme/configs/wave_common_config.dart';

/// 描述: 空页面配置类
class WaveAbnormalStateConfig extends WaveBaseConfig {
  WaveAbnormalStateConfig({
    WaveTextStyle? titleTextStyle,
    WaveTextStyle? contentTextStyle,
    WaveTextStyle? operateTextStyle,
    double? btnRadius,
    WaveTextStyle? singleTextStyle,
    WaveTextStyle? doubleTextStyle,
    double? singleMinWidth,
    double? doubleMinWidth,
    String configId = GLOBAL_CONFIG_ID,
  })  : _titleTextStyle = titleTextStyle,
        _contentTextStyle = contentTextStyle,
        _operateTextStyle = operateTextStyle,
        _btnRadius = btnRadius,
        _singleTextStyle = singleTextStyle,
        _doubleTextStyle = doubleTextStyle,
        _singleMinWidth = singleMinWidth,
        _doubleMinWidth = doubleMinWidth,
        super(configId: configId);

  /// 文案区域标题
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextBase],
  ///   fontSize: [WaveCommonConfig.fontSizeSubHead],
  ///   fontWeight: FontWeight.w600,
  /// )
  WaveTextStyle? _titleTextStyle;

  /// 文案区域内容
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextHint],
  ///   fontSize: [WaveCommonConfig.fontSizeBase],
  /// )
  WaveTextStyle? _contentTextStyle;

  /// 操作区域文本样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveGet.theme.colorScheme.primary],
  ///   fontSize: [WaveCommonConfig.fontSizeBase],
  /// )
  WaveTextStyle? _operateTextStyle;

  /// 圆角
  /// default value is [WaveCommonConfig.radiusSm]
  double? _btnRadius;

  /// 单按钮文本样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveCommonConfig.colorTextBaseInverse],
  ///   fontSize: [WaveCommonConfig.fontSizeSubHead],
  /// )
  WaveTextStyle? _singleTextStyle;

  /// 双按钮文本样式
  ///
  /// WaveTextStyle(
  ///   color: [WaveGet.theme.colorScheme.primary],
  ///   fontSize: [WaveCommonConfig.fontSizeSubHead],
  /// )
  WaveTextStyle? _doubleTextStyle;

  /// 单按钮的按钮最小宽度
  /// 默认值为 160
  double? _singleMinWidth;

  /// 多按钮的按钮最小宽度
  /// 默认值为 120
  double? _doubleMinWidth;

  WaveTextStyle get titleTextStyle =>
      _titleTextStyle ??
      WaveDefaultConfigUtils.defaultAbnormalStateConfig.titleTextStyle;

  WaveTextStyle get contentTextStyle =>
      _contentTextStyle ??
      WaveDefaultConfigUtils.defaultAbnormalStateConfig.contentTextStyle;

  WaveTextStyle get operateTextStyle =>
      _operateTextStyle ??
      WaveDefaultConfigUtils.defaultAbnormalStateConfig.operateTextStyle;

  double get btnRadius =>
      _btnRadius ?? WaveDefaultConfigUtils.defaultAbnormalStateConfig.btnRadius;

  WaveTextStyle get singleTextStyle =>
      _singleTextStyle ??
      WaveDefaultConfigUtils.defaultAbnormalStateConfig.singleTextStyle;

  WaveTextStyle get doubleTextStyle =>
      _doubleTextStyle ??
      WaveDefaultConfigUtils.defaultAbnormalStateConfig.doubleTextStyle;

  double get singleMinWidth =>
      _singleMinWidth ??
      WaveDefaultConfigUtils.defaultAbnormalStateConfig.singleMinWidth;

  double get doubleMinWidth =>
      _doubleMinWidth ??
      WaveDefaultConfigUtils.defaultAbnormalStateConfig.doubleMinWidth;

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
    WaveAbnormalStateConfig abnormalStateConfig = WaveThemeConfigurator.instance
        .getConfig(configId: configId)
        .abnormalStateConfig;

    _titleTextStyle = abnormalStateConfig.titleTextStyle.merge(
      WaveTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_titleTextStyle),
    );
    _contentTextStyle = abnormalStateConfig.contentTextStyle.merge(
      WaveTextStyle(
        color: commonConfig.colorTextHint,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_contentTextStyle),
    );
    _operateTextStyle = abnormalStateConfig.operateTextStyle.merge(
      WaveTextStyle(
        color: Get.theme.colorScheme.primary,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_operateTextStyle),
    );
    _singleTextStyle = abnormalStateConfig.singleTextStyle.merge(
      WaveTextStyle(
        color: commonConfig.colorTextBaseInverse,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_singleTextStyle),
    );
    _doubleTextStyle = abnormalStateConfig.doubleTextStyle.merge(
      WaveTextStyle(
        color: Get.theme.colorScheme.primary,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_doubleTextStyle),
    );
    _btnRadius ??= abnormalStateConfig._btnRadius;
    _singleMinWidth ??= abnormalStateConfig._singleMinWidth;
    _doubleMinWidth ??= abnormalStateConfig._doubleMinWidth;
  }

  WaveAbnormalStateConfig copyWith({
    WaveTextStyle? titleTextStyle,
    WaveTextStyle? contentTextStyle,
    WaveTextStyle? operateTextStyle,
    double? btnRadius,
    WaveTextStyle? singleTextStyle,
    WaveTextStyle? doubleTextStyle,
    double? singleMinWidth,
    double? doubleMinWidth,
  }) {
    return WaveAbnormalStateConfig(
      titleTextStyle: titleTextStyle ?? _titleTextStyle,
      contentTextStyle: contentTextStyle ?? _contentTextStyle,
      operateTextStyle: operateTextStyle ?? _operateTextStyle,
      btnRadius: btnRadius ?? _btnRadius,
      singleTextStyle: singleTextStyle ?? _singleTextStyle,
      doubleTextStyle: doubleTextStyle ?? _doubleTextStyle,
      singleMinWidth: singleMinWidth ?? _singleMinWidth,
      doubleMinWidth: doubleMinWidth ?? _doubleMinWidth,
    );
  }

  WaveAbnormalStateConfig merge(WaveAbnormalStateConfig? other) {
    if (other == null) return this;
    return copyWith(
      titleTextStyle: titleTextStyle.merge(other._titleTextStyle),
      contentTextStyle: contentTextStyle.merge(other._contentTextStyle),
      operateTextStyle: operateTextStyle.merge(other._operateTextStyle),
      btnRadius: other._btnRadius,
      singleTextStyle: singleTextStyle.merge(other._singleTextStyle),
      doubleTextStyle: doubleTextStyle.merge(other._doubleTextStyle),
      singleMinWidth: other._singleMinWidth,
      doubleMinWidth: other._doubleMinWidth,
    );
  }
}
