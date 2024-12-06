import 'package:waveui/src/theme/base/wave_default_config_utils.dart';
import 'package:waveui/src/theme/wave_theme_configurator.dart';
import 'package:waveui/src/theme/configs/wave_abnormal_state_config.dart';
import 'package:waveui/src/theme/configs/wave_action_sheet_config.dart';
import 'package:waveui/src/theme/configs/wave_button_config.dart';
import 'package:waveui/src/theme/configs/wave_card_title_config.dart';
import 'package:waveui/src/theme/configs/wave_common_config.dart';
import 'package:waveui/src/theme/configs/wave_dialog_config.dart';
import 'package:waveui/src/theme/configs/wave_enhance_number_card_config.dart';
import 'package:waveui/src/theme/configs/wave_form_config.dart';
import 'package:waveui/src/theme/configs/wave_gallery_detail_config.dart';
import 'package:waveui/src/theme/configs/wave_pair_info_config.dart';
import 'package:waveui/src/theme/configs/wave_picker_config.dart';
import 'package:waveui/src/theme/configs/wave_selection_config.dart';
import 'package:waveui/src/theme/configs/wave_tabbar_config.dart';
import 'package:waveui/src/theme/configs/wave_tag_config.dart';

/// 描述: 全局配置
///
/// 当用户使用时对单个组件自定义配置，优先走单个组件特定配置（作用范围档次使用）
/// 当用户配置组件通用配置时如 [WaveDialogConfig] 优先使用该配置
/// 若没有配置组件通用配置，走 [WaveCommonConfig] 全局配置
/// 如果以上都没有配置走 WaveUI 默认配置，即 [WaveDefaultConfigUtils] 中的配置
/// 当没有配置组件的特定属性时使用上一级特定配置
class WaveAllThemeConfig {
  WaveAllThemeConfig({
    WaveCommonConfig? commonConfig,
    WaveButtonConfig? buttonConfig,
    WaveDialogConfig? dialogConfig,
    WaveFormItemConfig? formItemConfig,
    WaveCardTitleConfig? cardTitleConfig,
    WaveAbnormalStateConfig? abnormalStateConfig,
    WaveTagConfig? tagConfig,
    WavePairInfoTableConfig? pairInfoTableConfig,
    WavePairRichInfoGridConfig? pairRichInfoGridConfig,
    WaveActionSheetConfig? actionSheetConfig,
    WavePickerConfig? pickerConfig,
    WaveEnhanceNumberCardConfig? enhanceNumberCardConfig,
    WaveTabBarConfig? tabBarConfig,
    WaveSelectionConfig? selectionConfig,
    WaveGalleryDetailConfig? galleryDetailConfig,
    String configId = GLOBAL_CONFIG_ID,
  })  : _commonConfig = commonConfig,
        _buttonConfig = buttonConfig,
        _dialogConfig = dialogConfig,
        _formItemConfig = formItemConfig,
        _cardTitleConfig = cardTitleConfig,
        _abnormalStateConfig = abnormalStateConfig,
        _tagConfig = tagConfig,
        _pairInfoTableConfig = pairInfoTableConfig,
        _pairRichInfoGridConfig = pairRichInfoGridConfig,
        _actionSheetConfig = actionSheetConfig,
        _pickerConfig = pickerConfig,
        _enhanceNumberCardConfig = enhanceNumberCardConfig,
        _tabBarConfig = tabBarConfig,
        _selectionConfig = selectionConfig,
        _galleryDetailConfig = galleryDetailConfig;

  WaveCommonConfig? _commonConfig;

  WaveCommonConfig get commonConfig =>
      _commonConfig ?? WaveDefaultConfigUtils.defaultCommonConfig;

  WaveButtonConfig? _buttonConfig;

  WaveButtonConfig get buttonConfig =>
      _buttonConfig ?? WaveDefaultConfigUtils.defaultButtonConfig;

  WaveDialogConfig? _dialogConfig;

  WaveDialogConfig get dialogConfig =>
      _dialogConfig ?? WaveDefaultConfigUtils.defaultDialogConfig;

  WaveCardTitleConfig? _cardTitleConfig;

  WaveCardTitleConfig get cardTitleConfig =>
      _cardTitleConfig ?? WaveDefaultConfigUtils.defaultCardTitleConfig;

  WaveAbnormalStateConfig? _abnormalStateConfig;

  WaveAbnormalStateConfig get abnormalStateConfig =>
      _abnormalStateConfig ?? WaveDefaultConfigUtils.defaultAbnormalStateConfig;

  WaveTagConfig? _tagConfig;

  WaveTagConfig get tagConfig =>
      _tagConfig ?? WaveDefaultConfigUtils.defaultTagConfig;

  WavePairInfoTableConfig? _pairInfoTableConfig;

  WavePairInfoTableConfig get pairInfoTableConfig =>
      _pairInfoTableConfig ?? WaveDefaultConfigUtils.defaultPairInfoTableConfig;

  WavePairRichInfoGridConfig? _pairRichInfoGridConfig;

  WavePairRichInfoGridConfig get pairRichInfoGridConfig =>
      _pairRichInfoGridConfig ??
      WaveDefaultConfigUtils.defaultPairRichInfoGridConfig;

  WaveActionSheetConfig? _actionSheetConfig;

  WaveActionSheetConfig get actionSheetConfig =>
      _actionSheetConfig ?? WaveDefaultConfigUtils.defaultActionSheetConfig;

  WavePickerConfig? _pickerConfig;

  WavePickerConfig get pickerConfig =>
      _pickerConfig ?? WaveDefaultConfigUtils.defaultPickerConfig;

  WaveEnhanceNumberCardConfig? _enhanceNumberCardConfig;

  WaveEnhanceNumberCardConfig get enhanceNumberCardConfig =>
      _enhanceNumberCardConfig ??
      WaveDefaultConfigUtils.defaultEnhanceNumberInfoConfig;

  WaveTabBarConfig? _tabBarConfig;

  WaveTabBarConfig get tabBarConfig =>
      _tabBarConfig ?? WaveDefaultConfigUtils.defaultTabBarConfig;

  WaveFormItemConfig? _formItemConfig;

  WaveFormItemConfig get formItemConfig =>
      _formItemConfig ?? WaveDefaultConfigUtils.defaultFormItemConfig;

  WaveSelectionConfig? _selectionConfig;

  WaveSelectionConfig get selectionConfig =>
      _selectionConfig ?? WaveDefaultConfigUtils.defaultSelectionConfig;

  WaveGalleryDetailConfig? _galleryDetailConfig;

  WaveGalleryDetailConfig get galleryDetailConfig =>
      _galleryDetailConfig ?? WaveDefaultConfigUtils.defaultGalleryDetailConfig;

  void initThemeConfig(String configId) {
    _commonConfig ??= WaveCommonConfig();
    _buttonConfig ??= WaveButtonConfig();
    _dialogConfig ??= WaveDialogConfig();
    _formItemConfig ??= WaveFormItemConfig();
    _cardTitleConfig ??= WaveCardTitleConfig();
    _abnormalStateConfig ??= WaveAbnormalStateConfig();
    _tagConfig ??= WaveTagConfig();
    _pairInfoTableConfig ??= WavePairInfoTableConfig();
    _pairRichInfoGridConfig ??= WavePairRichInfoGridConfig();
    _actionSheetConfig ??= WaveActionSheetConfig();
    _pickerConfig ??= WavePickerConfig();
    _enhanceNumberCardConfig ??= WaveEnhanceNumberCardConfig();
    _tabBarConfig ??= WaveTabBarConfig();
    _selectionConfig ??= WaveSelectionConfig();
    _galleryDetailConfig ??= WaveGalleryDetailConfig();

    commonConfig.initThemeConfig(configId);

    buttonConfig.initThemeConfig(
      configId,
      currentLevelCommonConfig: commonConfig,
    );
    dialogConfig.initThemeConfig(
      configId,
      currentLevelCommonConfig: commonConfig,
    );
    formItemConfig.initThemeConfig(
      configId,
      currentLevelCommonConfig: commonConfig,
    );
    cardTitleConfig.initThemeConfig(
      configId,
      currentLevelCommonConfig: commonConfig,
    );
    abnormalStateConfig.initThemeConfig(
      configId,
      currentLevelCommonConfig: commonConfig,
    );
    tagConfig.initThemeConfig(
      configId,
      currentLevelCommonConfig: commonConfig,
    );
    pairInfoTableConfig.initThemeConfig(
      configId,
      currentLevelCommonConfig: commonConfig,
    );
    pairRichInfoGridConfig.initThemeConfig(
      configId,
      currentLevelCommonConfig: commonConfig,
    );
    selectionConfig.initThemeConfig(
      configId,
      currentLevelCommonConfig: commonConfig,
    );
    actionSheetConfig.initThemeConfig(
      configId,
      currentLevelCommonConfig: commonConfig,
    );
    pickerConfig.initThemeConfig(
      configId,
      currentLevelCommonConfig: commonConfig,
    );
    enhanceNumberCardConfig.initThemeConfig(
      configId,
      currentLevelCommonConfig: commonConfig,
    );
    tabBarConfig.initThemeConfig(
      configId,
      currentLevelCommonConfig: commonConfig,
    );
    galleryDetailConfig.initThemeConfig(
      configId,
      currentLevelCommonConfig: commonConfig,
    );
  }
}
