import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'wave_resources.dart';

///
///WaveUI multilingual support
///
class WaveIntl {
  ///Built-in Supported Languages ​​​​and Resources
  final Map<String, WaveBaseResource> _defaultResourceMap = {
    'en': WaveResourceEn(),
  };

  ///Cache the resources corresponding to the current language, for the case of no context
  static WaveIntl? _current;
  static WaveBaseResource get currentResource {
    assert(
        _current != null,
        'No instance of WaveIntl was loaded. \n'
        'Try to initialize the WaveLocalizationDelegate before accessing WaveIntl. currentResource.');

    ///If the application is not localized, the zh-CN resource will be used by default
    _current ??= WaveIntl(WaveResourceEn.locale);
    return _current!.localizedResource;
  }

  final Locale locale;

  WaveIntl(this.locale);

  ///Get the resource corresponding to the current language, if it is null, return [WaveResourceZh]
  WaveBaseResource get localizedResource {
    //support dynamic resource files
    WaveBaseResource? resource =
        _WaveIntlHelper.findIntlResourceOfType<WaveBaseResource>(locale);
    if (resource != null) return resource;
    //Regular multilingual resource loading
    return _defaultResourceMap[locale.languageCode] ??
        _defaultResourceMap['zh']!;
  }

  ///Get [WaveIntl] instance
  static WaveIntl of(BuildContext context) {
    return Localizations.of(context, WaveIntl) ??
        WaveIntl(WaveResourceEn.locale);
  }

  ///Get the [WaveBaseResource] resource in the current language
  static WaveBaseResource i10n(BuildContext context) {
    return WaveIntl.of(context).localizedResource;
  }

  ///The application loads localized resources
  static Future<WaveIntl> _load(Locale locale) {
    _current = WaveIntl(locale);
    return SynchronousFuture<WaveIntl>(_current!);
  }

  ///Support non-built-in localization capabilities
  static void add(Locale locale, WaveBaseResource resource) {
    _WaveIntlHelper.add(locale, resource);
  }

  ///Support non-built-in localization capabilities
  static void addAll(Locale locale, List<WaveBaseResource> resources) {
    _WaveIntlHelper.addAll(locale, resources);
  }
}

///
///Component multilingual adaptation proxy
///
class WaveLocalizationDelegate extends LocalizationsDelegate<WaveIntl> {
  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<WaveIntl> load(Locale locale) {
    debugPrint('$runtimeType load: locale = $locale, ${locale.countryCode}, ${locale.languageCode}');
    return WaveIntl._load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<WaveIntl> old) => false;

  ///需在app入口注册
  static WaveLocalizationDelegate delegate = WaveLocalizationDelegate();
}

///
///Support the localization of external dynamic addition of other language branches
///
final Map<Locale, Map<Type, dynamic>> _additionalIntls = {};

class _WaveIntlHelper {
  ///
  ///Find resources whose value type is [T] according to locale
  ///
  static T? findIntlResourceOfType<T>(Locale locale) {
    Map<Type, dynamic>? res = _additionalIntls[locale];
    if (res != null && res.isNotEmpty) {
      for (var entry in res.entries) {
        if (entry.value is T) {
          return entry.value;
        }
      }
    }
    return null;
  }

  ///
  ///Find resources with Type [T] according to locale
  ///
  static T? findIntlResourceOfExactType<T>(Locale locale) {
    Map<Type, dynamic>? res = _additionalIntls[locale];
    if (res != null && res.isNotEmpty) {
      for (var entry in res.entries) {
        if (entry.key == T) {
          return entry.value;
        }
      }
    }
    return null;
  }

  ///
  ///Find a series of resources whose value type is T according to locale
  ///
  static Iterable<T>? findIntlResourcesOfType<T>(Locale locale) {
    final res = _additionalIntls[locale];
    if (res != null && res.isNotEmpty) {
      List<T> resources = [];
      for (var entry in res.entries) {
        if (entry.value is T) {
          resources.add(entry.value);
        }
      }
      return resources;
    }
    return null;
  }

  ///
  ///设置自定义 locale 的资源
  ///
  static void addAll(Locale locale, List<WaveBaseResource> resources) {
    var res = _additionalIntls[locale];
    if (res == null) {
      res = {};
      _additionalIntls[locale] = res;
    }
    for (WaveBaseResource resource in resources) {
      res[resource.runtimeType] = resource;
    }
  }

  ///
  ///设置自定义 locale 的资源
  ///
  static void add(Locale locale, WaveBaseResource resource) {
    var res = _additionalIntls[locale];
    if (res == null) {
      res = {};
      _additionalIntls[locale] = res;
    }
    res[resource.runtimeType] = resource;
  }
}
