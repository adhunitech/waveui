import 'package:waveui/src/theme/base/wave_default_config_utils.dart';
import 'package:waveui/src/theme/configs/wave_all_config.dart';

const String WAVEUI_CONFIG_ID = 'WAVEUI_CONFIG_ID';
const String GLOBAL_CONFIG_ID = 'GLOBAL_CONFIG_ID';

class WaveThemeConfigurator {
  WaveThemeConfigurator._() {
    _checkAndInitWaveUIConfig();
  }

  static final WaveThemeConfigurator _instance = WaveThemeConfigurator._();

  static WaveThemeConfigurator get instance {
    return _instance;
  }

  Map<String, WaveAllThemeConfig> globalConfig = <String, WaveAllThemeConfig>{};

  ///When manually registering, the default registration channel is GLOBAL_CONFIG_ID
  void register(
    WaveAllThemeConfig? allThemeConfig, {
    String configId = GLOBAL_CONFIG_ID,
  }) {
    //flatten the inner field
    if (allThemeConfig != null) {
      //assign the incoming configuration
      globalConfig[configId] = allThemeConfig..initThemeConfig(configId);
    }
  }

  ///Get the appropriate configuration
  ///1. Obtain the global theme configuration corresponding to configId,
  ///2. If the obtained value is null, the default global configuration will be used.
  ///3. If GLOBAL_CONFIG_ID is not configured, use the configuration of WAVEUI.
  WaveAllThemeConfig getConfig({String configId = GLOBAL_CONFIG_ID}) {
    WaveAllThemeConfig? allThemeConfig = globalConfig[configId] ??
        globalConfig[GLOBAL_CONFIG_ID] ??
        globalConfig[WAVEUI_CONFIG_ID];
    assert(allThemeConfig != null, 'No suitable config found.');
    return allThemeConfig!;
  }

  ///Check if there is a default configuration
  bool isWaveUIConfig() => globalConfig[WAVEUI_CONFIG_ID] != null;

  ///No default configuration Configure default configuration
  void _checkAndInitWaveUIConfig() {
    if (!isWaveUIConfig()) {
      globalConfig[WAVEUI_CONFIG_ID] = WaveDefaultConfigUtils.defaultAllConfig;
    }
  }
}
