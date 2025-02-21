import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:waveui/material/arc.dart';
import 'package:waveui/material/colors.dart';
import 'package:waveui/material/floating_action_button.dart';
import 'package:waveui/material/icon_button.dart';
import 'package:waveui/material/icons.dart';
import 'package:waveui/material/material_localizations.dart';
import 'package:waveui/material/page.dart';
import 'package:waveui/material/scaffold.dart' show ScaffoldMessenger, ScaffoldMessengerState;
import 'package:waveui/material/scrollbar.dart';
import 'package:waveui/material/theme.dart';
import 'package:waveui/material/tooltip.dart';

// Examples can assume:
// typedef GlobalWidgetsLocalizations = DefaultWidgetsLocalizations;
// typedef GlobalMaterialLocalizations = DefaultMaterialLocalizations;

const TextStyle _errorTextStyle = TextStyle(
  color: Color(0xD0FF0000),
  fontFamily: 'monospace',
  fontSize: 48.0,
  fontWeight: FontWeight.w900,
  decoration: TextDecoration.underline,
  decorationColor: Color(0xFFFFFF00),
  decorationStyle: TextDecorationStyle.double,
  debugLabel: 'fallback style; consider putting your text in a Material',
);

enum ThemeMode { system, light, dark }

class MaterialApp extends StatefulWidget {
  const MaterialApp({
    super.key,
    this.navigatorKey,
    this.scaffoldMessengerKey,
    this.home,
    Map<String, WidgetBuilder> this.routes = const <String, WidgetBuilder>{},
    this.initialRoute,
    this.onGenerateRoute,
    this.onGenerateInitialRoutes,
    this.onUnknownRoute,
    this.onNavigationNotification,
    List<NavigatorObserver> this.navigatorObservers = const <NavigatorObserver>[],
    this.builder,
    this.title = '',
    this.onGenerateTitle,
    this.color,
    this.theme,
    this.darkTheme,
    this.highContrastTheme,
    this.highContrastDarkTheme,
    this.themeMode = ThemeMode.system,
    this.themeAnimationDuration = kThemeAnimationDuration,
    this.themeAnimationCurve = Curves.linear,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.debugShowMaterialGrid = false,
    this.showPerformanceOverlay = false,
    this.checkerboardRasterCacheImages = false,
    this.checkerboardOffscreenLayers = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = true,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
    this.scrollBehavior,
    this.themeAnimationStyle,
  }) : routeInformationProvider = null,
       routeInformationParser = null,
       routerDelegate = null,
       backButtonDispatcher = null,
       routerConfig = null;

  const MaterialApp.router({
    super.key,
    this.scaffoldMessengerKey,
    this.routeInformationProvider,
    this.routeInformationParser,
    this.routerDelegate,
    this.routerConfig,
    this.backButtonDispatcher,
    this.builder,
    this.title,
    this.onGenerateTitle,
    this.onNavigationNotification,
    this.color,
    this.theme,
    this.darkTheme,
    this.highContrastTheme,
    this.highContrastDarkTheme,
    this.themeMode = ThemeMode.system,
    this.themeAnimationDuration = kThemeAnimationDuration,
    this.themeAnimationCurve = Curves.linear,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.debugShowMaterialGrid = false,
    this.showPerformanceOverlay = false,
    this.checkerboardRasterCacheImages = false,
    this.checkerboardOffscreenLayers = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = true,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
    this.scrollBehavior,
    this.themeAnimationStyle,
  }) : assert(routerDelegate != null || routerConfig != null),
       navigatorObservers = null,
       navigatorKey = null,
       onGenerateRoute = null,
       home = null,
       onGenerateInitialRoutes = null,
       onUnknownRoute = null,
       routes = null,
       initialRoute = null;

  final GlobalKey<NavigatorState>? navigatorKey;

  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;

  final Widget? home;

  final Map<String, WidgetBuilder>? routes;

  final String? initialRoute;

  final RouteFactory? onGenerateRoute;

  final InitialRouteListFactory? onGenerateInitialRoutes;

  final RouteFactory? onUnknownRoute;

  final NotificationListenerCallback<NavigationNotification>? onNavigationNotification;

  final List<NavigatorObserver>? navigatorObservers;

  final RouteInformationProvider? routeInformationProvider;

  final RouteInformationParser<Object>? routeInformationParser;

  final RouterDelegate<Object>? routerDelegate;

  final BackButtonDispatcher? backButtonDispatcher;

  final RouterConfig<Object>? routerConfig;

  final TransitionBuilder? builder;

  final String? title;

  final GenerateAppTitle? onGenerateTitle;

  final ThemeData? theme;

  final ThemeData? darkTheme;

  final ThemeData? highContrastTheme;

  final ThemeData? highContrastDarkTheme;

  final ThemeMode? themeMode;

  final Duration themeAnimationDuration;

  final Curve themeAnimationCurve;

  final Color? color;

  final Locale? locale;

  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  final LocaleListResolutionCallback? localeListResolutionCallback;

  final LocaleResolutionCallback? localeResolutionCallback;

  final Iterable<Locale> supportedLocales;

  final bool showPerformanceOverlay;

  final bool checkerboardRasterCacheImages;

  final bool checkerboardOffscreenLayers;

  final bool showSemanticsDebugger;

  final bool debugShowCheckedModeBanner;

  final Map<ShortcutActivator, Intent>? shortcuts;

  final Map<Type, Action<Intent>>? actions;

  final String? restorationScopeId;

  final ScrollBehavior? scrollBehavior;

  final bool debugShowMaterialGrid;

  final AnimationStyle? themeAnimationStyle;

  @override
  State<MaterialApp> createState() => _MaterialAppState();

  static HeroController createMaterialHeroController() =>
      HeroController(createRectTween: (begin, end) => MaterialRectArcTween(begin: begin, end: end));

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<GlobalKey<NavigatorState>?>('navigatorKey', navigatorKey))
      ..add(DiagnosticsProperty<GlobalKey<ScaffoldMessengerState>?>('scaffoldMessengerKey', scaffoldMessengerKey))
      ..add(DiagnosticsProperty<Map<String, WidgetBuilder>?>('routes', routes))
      ..add(StringProperty('initialRoute', initialRoute))
      ..add(ObjectFlagProperty<RouteFactory?>.has('onGenerateRoute', onGenerateRoute))
      ..add(ObjectFlagProperty<InitialRouteListFactory?>.has('onGenerateInitialRoutes', onGenerateInitialRoutes))
      ..add(ObjectFlagProperty<RouteFactory?>.has('onUnknownRoute', onUnknownRoute))
      ..add(
        ObjectFlagProperty<NotificationListenerCallback<NavigationNotification>?>.has(
          'onNavigationNotification',
          onNavigationNotification,
        ),
      )
      ..add(IterableProperty<NavigatorObserver>('navigatorObservers', navigatorObservers))
      ..add(DiagnosticsProperty<RouteInformationProvider?>('routeInformationProvider', routeInformationProvider))
      ..add(DiagnosticsProperty<RouteInformationParser<Object>?>('routeInformationParser', routeInformationParser))
      ..add(DiagnosticsProperty<RouterDelegate<Object>?>('routerDelegate', routerDelegate))
      ..add(DiagnosticsProperty<BackButtonDispatcher?>('backButtonDispatcher', backButtonDispatcher))
      ..add(DiagnosticsProperty<RouterConfig<Object>?>('routerConfig', routerConfig))
      ..add(ObjectFlagProperty<TransitionBuilder?>.has('builder', builder))
      ..add(StringProperty('title', title))
      ..add(ObjectFlagProperty<GenerateAppTitle?>.has('onGenerateTitle', onGenerateTitle))
      ..add(DiagnosticsProperty<ThemeData?>('theme', theme))
      ..add(DiagnosticsProperty<ThemeData?>('darkTheme', darkTheme))
      ..add(DiagnosticsProperty<ThemeData?>('highContrastTheme', highContrastTheme))
      ..add(DiagnosticsProperty<ThemeData?>('highContrastDarkTheme', highContrastDarkTheme))
      ..add(EnumProperty<ThemeMode?>('themeMode', themeMode))
      ..add(DiagnosticsProperty<Duration>('themeAnimationDuration', themeAnimationDuration))
      ..add(DiagnosticsProperty<Curve>('themeAnimationCurve', themeAnimationCurve))
      ..add(ColorProperty('color', color))
      ..add(DiagnosticsProperty<ui.Locale?>('locale', locale))
      ..add(IterableProperty<LocalizationsDelegate>('localizationsDelegates', localizationsDelegates))
      ..add(
        ObjectFlagProperty<LocaleListResolutionCallback?>.has(
          'localeListResolutionCallback',
          localeListResolutionCallback,
        ),
      )
      ..add(ObjectFlagProperty<LocaleResolutionCallback?>.has('localeResolutionCallback', localeResolutionCallback))
      ..add(IterableProperty<ui.Locale>('supportedLocales', supportedLocales))
      ..add(DiagnosticsProperty<bool>('showPerformanceOverlay', showPerformanceOverlay))
      ..add(DiagnosticsProperty<bool>('checkerboardRasterCacheImages', checkerboardRasterCacheImages))
      ..add(DiagnosticsProperty<bool>('checkerboardOffscreenLayers', checkerboardOffscreenLayers))
      ..add(DiagnosticsProperty<bool>('showSemanticsDebugger', showSemanticsDebugger))
      ..add(DiagnosticsProperty<bool>('debugShowCheckedModeBanner', debugShowCheckedModeBanner))
      ..add(DiagnosticsProperty<Map<ShortcutActivator, Intent>?>('shortcuts', shortcuts))
      ..add(DiagnosticsProperty<Map<Type, Action<Intent>>?>('actions', actions))
      ..add(StringProperty('restorationScopeId', restorationScopeId))
      ..add(DiagnosticsProperty<ScrollBehavior?>('scrollBehavior', scrollBehavior))
      ..add(DiagnosticsProperty<bool>('debugShowMaterialGrid', debugShowMaterialGrid))
      ..add(DiagnosticsProperty<AnimationStyle?>('themeAnimationStyle', themeAnimationStyle));
  }
}

class MaterialScrollBehavior extends ScrollBehavior {
  const MaterialScrollBehavior();

  @override
  TargetPlatform getPlatform(BuildContext context) => Theme.of(context).platform;

  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) {
    // When modifying this function, consider modifying the implementation in
    // the base class ScrollBehavior as well.
    switch (axisDirectionToAxis(details.direction)) {
      case Axis.horizontal:
        return child;
      case Axis.vertical:
        switch (getPlatform(context)) {
          case TargetPlatform.linux:
          case TargetPlatform.macOS:
          case TargetPlatform.windows:
            assert(details.controller != null);
            return Scrollbar(controller: details.controller, child: child);
          case TargetPlatform.android:
          case TargetPlatform.fuchsia:
          case TargetPlatform.iOS:
            return child;
        }
    }
  }

  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    // When modifying this function, consider modifying the implementation in
    // the base class ScrollBehavior as well.
    const indicator = AndroidOverscrollIndicator.stretch;
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return child;
      case TargetPlatform.android:
        switch (indicator) {
          case AndroidOverscrollIndicator.stretch:
            return StretchingOverscrollIndicator(
              axisDirection: details.direction,
              clipBehavior: details.decorationClipBehavior ?? Clip.hardEdge,
              child: child,
            );
          case AndroidOverscrollIndicator.glow:
            break;
        }
      case TargetPlatform.fuchsia:
        break;
    }
    return GlowingOverscrollIndicator(
      axisDirection: details.direction,
      color: Theme.of(context).colorScheme.secondary,
      child: child,
    );
  }
}

class _MaterialAppState extends State<MaterialApp> {
  static const double _moveExitWidgetSelectionIconSize = 32;
  static const double _moveExitWidgetSelectionTargetSize = 40;

  late HeroController _heroController;

  bool get _usesRouter => widget.routerDelegate != null || widget.routerConfig != null;

  @override
  void initState() {
    super.initState();
    _heroController = MaterialApp.createMaterialHeroController();
  }

  @override
  void dispose() {
    _heroController.dispose();
    super.dispose();
  }

  // Combine the Localizations for Material with the ones contributed
  // by the localizationsDelegates parameter, if any. Only the first delegate
  // of a particular LocalizationsDelegate.type is loaded so the
  // localizationsDelegate parameter can be used to override
  // _MaterialLocalizationsDelegate.
  Iterable<LocalizationsDelegate<dynamic>> get _localizationsDelegates => <LocalizationsDelegate<dynamic>>[
    if (widget.localizationsDelegates != null) ...widget.localizationsDelegates!,
    DefaultMaterialLocalizations.delegate,
    DefaultCupertinoLocalizations.delegate,
  ];

  Widget _exitWidgetSelectionButtonBuilder(
    BuildContext context, {
    required VoidCallback onPressed,
    required GlobalKey key,
  }) => FloatingActionButton(
    key: key,
    onPressed: onPressed,
    mini: true,
    backgroundColor: _widgetSelectionButtonsBackgroundColor(context),
    foregroundColor: _widgetSelectionButtonsForegroundColor(context),
    child: const Icon(Icons.close, semanticLabel: 'Exit Select Widget mode.'),
  );

  Widget _moveExitWidgetSelectionButtonBuilder(
    BuildContext context, {
    required VoidCallback onPressed,
    bool isLeftAligned = true,
  }) => IconButton(
    color: _widgetSelectionButtonsBackgroundColor(context),
    padding: EdgeInsets.zero,
    iconSize: _moveExitWidgetSelectionIconSize,
    onPressed: onPressed,
    constraints: const BoxConstraints(
      minWidth: _moveExitWidgetSelectionTargetSize,
      minHeight: _moveExitWidgetSelectionTargetSize,
    ),
    icon: Icon(
      isLeftAligned ? Icons.arrow_right : Icons.arrow_left,
      semanticLabel: 'Move "Exit Select Widget mode" button to the ${isLeftAligned ? 'right' : 'left'}.',
    ),
  );

  Color _widgetSelectionButtonsForegroundColor(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return _isDarkTheme(context) ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.primaryContainer;
  }

  Color _widgetSelectionButtonsBackgroundColor(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return _isDarkTheme(context) ? theme.colorScheme.primaryContainer : theme.colorScheme.onPrimaryContainer;
  }

  bool _isDarkTheme(BuildContext context) =>
      widget.themeMode == ThemeMode.dark ||
      widget.themeMode == ThemeMode.system && MediaQuery.platformBrightnessOf(context) == Brightness.dark;

  ThemeData _themeBuilder(BuildContext context) {
    ThemeData? theme;
    // Resolve which theme to use based on brightness and high contrast.
    final ThemeMode mode = widget.themeMode ?? ThemeMode.system;
    final Brightness platformBrightness = MediaQuery.platformBrightnessOf(context);
    final bool useDarkTheme =
        mode == ThemeMode.dark || (mode == ThemeMode.system && platformBrightness == ui.Brightness.dark);
    final bool highContrast = MediaQuery.highContrastOf(context);
    if (useDarkTheme && highContrast && widget.highContrastDarkTheme != null) {
      theme = widget.highContrastDarkTheme;
    } else if (useDarkTheme && widget.darkTheme != null) {
      theme = widget.darkTheme;
    } else if (highContrast && widget.highContrastTheme != null) {
      theme = widget.highContrastTheme;
    }
    theme ??= widget.theme ?? ThemeData.light();
    SystemChrome.setSystemUIOverlayStyle(
      theme.brightness == Brightness.dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
    );

    return theme;
  }

  Widget _materialBuilder(BuildContext context, Widget? child) {
    final ThemeData theme = _themeBuilder(context);
    final Color effectiveSelectionColor =
        theme.textSelectionTheme.selectionColor ?? theme.colorScheme.primary.withOpacity(0.40);
    final Color effectiveCursorColor = theme.textSelectionTheme.cursorColor ?? theme.colorScheme.primary;

    Widget childWidget = child ?? const SizedBox.shrink();

    if (widget.builder != null) {
      childWidget = Builder(
        builder: (context) {
          // Why are we surrounding a builder with a builder?
          //
          // The widget.builder may contain code that invokes
          // Theme.of(), which should return the theme we selected
          // above in AnimatedTheme. However, if we invoke
          // widget.builder() directly as the child of AnimatedTheme
          // then there is no BuildContext separating them, the
          // widget.builder() will not find the theme. Therefore, we
          // surround widget.builder with yet another builder so that
          // a context separates them and Theme.of() correctly
          // resolves to the theme we passed to AnimatedTheme.
          return widget.builder!(context, child);
        },
      );
    }

    childWidget = ScaffoldMessenger(
      key: widget.scaffoldMessengerKey,
      child: DefaultSelectionStyle(
        selectionColor: effectiveSelectionColor,
        cursorColor: effectiveCursorColor,
        child: childWidget,
      ),
    );

    if (widget.themeAnimationStyle != AnimationStyle.noAnimation) {
      childWidget = AnimatedTheme(
        data: theme,
        duration: widget.themeAnimationStyle?.duration ?? widget.themeAnimationDuration,
        curve: widget.themeAnimationStyle?.curve ?? widget.themeAnimationCurve,
        child: childWidget,
      );
    } else {
      childWidget = Theme(data: theme, child: childWidget);
    }

    return childWidget;
  }

  Widget _buildWidgetApp(BuildContext context) {
    // The color property is always pulled from the light theme, even if dark
    // mode is activated. This was done to simplify the technical details
    // of switching themes and it was deemed acceptable because this color
    // property is only used on old Android OSes to color the app bar in
    // Android's switcher UI.
    //
    // blue is the primary color of the default theme.
    final Color materialColor = widget.color ?? widget.theme?.primaryColor ?? Colors.blue;
    if (_usesRouter) {
      return WidgetsApp.router(
        key: GlobalObjectKey(this),
        routeInformationProvider: widget.routeInformationProvider,
        routeInformationParser: widget.routeInformationParser,
        routerDelegate: widget.routerDelegate,
        routerConfig: widget.routerConfig,
        backButtonDispatcher: widget.backButtonDispatcher,
        onNavigationNotification: widget.onNavigationNotification,
        builder: _materialBuilder,
        title: widget.title,
        onGenerateTitle: widget.onGenerateTitle,
        textStyle: _errorTextStyle,
        color: materialColor,
        locale: widget.locale,
        localizationsDelegates: _localizationsDelegates,
        localeResolutionCallback: widget.localeResolutionCallback,
        localeListResolutionCallback: widget.localeListResolutionCallback,
        supportedLocales: widget.supportedLocales,
        showPerformanceOverlay: widget.showPerformanceOverlay,
        showSemanticsDebugger: widget.showSemanticsDebugger,
        debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
        exitWidgetSelectionButtonBuilder: _exitWidgetSelectionButtonBuilder,
        moveExitWidgetSelectionButtonBuilder: _moveExitWidgetSelectionButtonBuilder,
        shortcuts: widget.shortcuts,
        actions: widget.actions,
        restorationScopeId: widget.restorationScopeId,
      );
    }

    return WidgetsApp(
      key: GlobalObjectKey(this),
      navigatorKey: widget.navigatorKey,
      navigatorObservers: widget.navigatorObservers!,
      pageRouteBuilder: <T>(settings, builder) => MaterialPageRoute<T>(settings: settings, builder: builder),
      home: widget.home,
      routes: widget.routes!,
      initialRoute: widget.initialRoute,
      onGenerateRoute: widget.onGenerateRoute,
      onGenerateInitialRoutes: widget.onGenerateInitialRoutes,
      onUnknownRoute: widget.onUnknownRoute,
      onNavigationNotification: widget.onNavigationNotification,
      builder: _materialBuilder,
      title: widget.title,
      onGenerateTitle: widget.onGenerateTitle,
      textStyle: _errorTextStyle,
      color: materialColor,
      locale: widget.locale,
      localizationsDelegates: _localizationsDelegates,
      localeResolutionCallback: widget.localeResolutionCallback,
      localeListResolutionCallback: widget.localeListResolutionCallback,
      supportedLocales: widget.supportedLocales,
      showPerformanceOverlay: widget.showPerformanceOverlay,
      showSemanticsDebugger: widget.showSemanticsDebugger,
      debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
      exitWidgetSelectionButtonBuilder: _exitWidgetSelectionButtonBuilder,
      moveExitWidgetSelectionButtonBuilder: _moveExitWidgetSelectionButtonBuilder,
      shortcuts: widget.shortcuts,
      actions: widget.actions,
      restorationScopeId: widget.restorationScopeId,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget result = _buildWidgetApp(context);
    result = Focus(
      canRequestFocus: false,
      onKeyEvent: (node, event) {
        if ((event is! KeyDownEvent && event is! KeyRepeatEvent) || event.logicalKey != LogicalKeyboardKey.escape) {
          return KeyEventResult.ignored;
        }
        return Tooltip.dismissAllToolTips() ? KeyEventResult.handled : KeyEventResult.ignored;
      },
      child: result,
    );
    assert(() {
      if (widget.debugShowMaterialGrid) {
        result = GridPaper(color: const Color(0xE0F9BBE0), interval: 8.0, subdivisions: 1, child: result);
      }
      return true;
    }());

    return ScrollConfiguration(
      behavior: widget.scrollBehavior ?? const MaterialScrollBehavior(),
      child: HeroControllerScope(controller: _heroController, child: result),
    );
  }
}
