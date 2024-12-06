import 'package:waveui/src/theme/wave_theme_configurator.dart';
import 'package:waveui/src/theme/configs/wave_all_config.dart';

/// WaveUI initialization
class WaveInitializer {
  /// When manually registering, the default registration channel is GLOBAL_CONFIG_ID
  static register({
    WaveAllThemeConfig? allThemeConfig,
    String configId = GLOBAL_CONFIG_ID,
  }) {
    /// Configure theme customization
    WaveThemeConfigurator.instance.register(allThemeConfig, configId: configId);
  }
}
