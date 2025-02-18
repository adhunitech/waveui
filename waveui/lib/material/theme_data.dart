// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'dart:ui' show Color, lerpDouble;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:waveui/material/action_icons_theme.dart';
import 'package:waveui/material/app_bar_theme.dart';
import 'package:waveui/material/badge_theme.dart';
import 'package:waveui/material/banner_theme.dart';
import 'package:waveui/material/bottom_app_bar_theme.dart';
import 'package:waveui/material/bottom_navigation_bar_theme.dart';
import 'package:waveui/material/bottom_sheet_theme.dart';
import 'package:waveui/material/button_bar_theme.dart';
import 'package:waveui/material/button_theme.dart';
import 'package:waveui/material/card_theme.dart';
import 'package:waveui/material/checkbox_theme.dart';
import 'package:waveui/material/chip_theme.dart';
import 'package:waveui/material/color_scheme.dart';
import 'package:waveui/material/colors.dart';
import 'package:waveui/material/constants.dart';
import 'package:waveui/material/data_table_theme.dart';
import 'package:waveui/material/date_picker_theme.dart';
import 'package:waveui/material/dialog_theme.dart';
import 'package:waveui/material/divider_theme.dart';
import 'package:waveui/material/drawer_theme.dart';
import 'package:waveui/material/dropdown_menu_theme.dart';
import 'package:waveui/material/elevated_button_theme.dart';
import 'package:waveui/material/expansion_tile_theme.dart';
import 'package:waveui/material/filled_button_theme.dart';
import 'package:waveui/material/floating_action_button_theme.dart';
import 'package:waveui/material/icon_button_theme.dart';
import 'package:waveui/material/ink_ripple.dart';
import 'package:waveui/material/ink_sparkle.dart';
import 'package:waveui/material/ink_splash.dart';
import 'package:waveui/material/ink_well.dart' show InteractiveInkFeatureFactory;
import 'package:waveui/material/input_decorator.dart';
import 'package:waveui/material/list_tile_theme.dart';
import 'package:waveui/material/menu_bar_theme.dart';
import 'package:waveui/material/menu_button_theme.dart';
import 'package:waveui/material/menu_theme.dart';
import 'package:waveui/material/navigation_bar_theme.dart';
import 'package:waveui/material/navigation_drawer_theme.dart';
import 'package:waveui/material/navigation_rail_theme.dart';
import 'package:waveui/material/outlined_button_theme.dart';
import 'package:waveui/material/page_transitions_theme.dart';
import 'package:waveui/material/popup_menu_theme.dart';
import 'package:waveui/material/progress_indicator_theme.dart';
import 'package:waveui/material/radio_theme.dart';
import 'package:waveui/material/scrollbar_theme.dart';
import 'package:waveui/material/search_bar_theme.dart';
import 'package:waveui/material/search_view_theme.dart';
import 'package:waveui/material/segmented_button_theme.dart';
import 'package:waveui/material/slider_theme.dart';
import 'package:waveui/material/snack_bar_theme.dart';
import 'package:waveui/material/switch_theme.dart';
import 'package:waveui/material/tab_bar_theme.dart';
import 'package:waveui/material/text_button_theme.dart';
import 'package:waveui/material/text_selection_theme.dart';
import 'package:waveui/src/theme/text_theme.dart';
import 'package:waveui/material/time_picker_theme.dart';
import 'package:waveui/material/toggle_buttons_theme.dart';
import 'package:waveui/material/tooltip_theme.dart';
import 'package:waveui/material/typography.dart';

export 'package:flutter/services.dart' show Brightness;

// Examples can assume:
// late BuildContext context;

class Adaptation<T> {
  const Adaptation();

  Type get type => T;

  T adapt(ThemeData theme, T defaultValue) => defaultValue;
}

abstract class ThemeExtension<T extends ThemeExtension<T>> {
  const ThemeExtension();

  Object get type => T;

  ThemeExtension<T> copyWith();

  ThemeExtension<T> lerp(covariant ThemeExtension<T>? other, double t);
}

enum MaterialTapTargetSize { padded, shrinkWrap }

@immutable
class ThemeData with Diagnosticable {
  factory ThemeData({
    // For the sanity of the reader, make sure these properties are in the same
    // order in every place that they are separated by section comments (e.g.
    // GENERAL CONFIGURATION). Each section except for deprecations should be
    // alphabetical by symbol name.

    // GENERAL CONFIGURATION
    Iterable<Adaptation<Object>>? adaptations,
    bool? applyElevationOverlayColor,
    NoDefaultCupertinoThemeData? cupertinoOverrideTheme,
    Iterable<ThemeExtension<dynamic>>? extensions,
    InputDecorationTheme? inputDecorationTheme,
    MaterialTapTargetSize? materialTapTargetSize,
    PageTransitionsTheme? pageTransitionsTheme,
    TargetPlatform? platform,
    ScrollbarThemeData? scrollbarTheme,
    InteractiveInkFeatureFactory? splashFactory,
    bool? useMaterial3,
    VisualDensity? visualDensity,
    // COLOR
    ColorScheme? colorScheme,
    Brightness? brightness,
    Color? colorSchemeSeed,
    // [colorScheme] is the preferred way to configure colors. The [Color] properties
    // listed below (as well as primarySwatch) will gradually be phased out, see
    // https://github.com/flutter/flutter/issues/91772.
    Color? canvasColor,
    Color? cardColor,
    Color? disabledColor,
    Color? dividerColor,
    Color? focusColor,
    Color? highlightColor,
    Color? hintColor,
    Color? hoverColor,
    Color? primaryColor,
    Color? primaryColorDark,
    Color? primaryColorLight,
    MaterialColor? primarySwatch,
    Color? scaffoldBackgroundColor,
    Color? secondaryHeaderColor,
    Color? shadowColor,
    Color? splashColor,
    Color? unselectedWidgetColor,
    // TYPOGRAPHY & ICONOGRAPHY
    String? fontFamily,
    List<String>? fontFamilyFallback,
    String? package,
    IconThemeData? iconTheme,
    IconThemeData? primaryIconTheme,
    TextTheme? primaryTextTheme,
    TextTheme? textTheme,
    Typography? typography,
    // COMPONENT THEMES
    ActionIconThemeData? actionIconTheme,
    AppBarTheme? appBarTheme,
    BadgeThemeData? badgeTheme,
    MaterialBannerThemeData? bannerTheme,
    BottomAppBarTheme? bottomAppBarTheme,
    BottomNavigationBarThemeData? bottomNavigationBarTheme,
    BottomSheetThemeData? bottomSheetTheme,
    ButtonThemeData? buttonTheme,
    // TODO(QuncCccccc): Change the parameter type to CardThemeData
    Object? cardTheme,
    CheckboxThemeData? checkboxTheme,
    ChipThemeData? chipTheme,
    DataTableThemeData? dataTableTheme,
    DatePickerThemeData? datePickerTheme,
    // TODO(QuncCccccc): Change the parameter type to DialogThemeData
    Object? dialogTheme,
    DividerThemeData? dividerTheme,
    DrawerThemeData? drawerTheme,
    DropdownMenuThemeData? dropdownMenuTheme,
    ElevatedButtonThemeData? elevatedButtonTheme,
    ExpansionTileThemeData? expansionTileTheme,
    FilledButtonThemeData? filledButtonTheme,
    FloatingActionButtonThemeData? floatingActionButtonTheme,
    IconButtonThemeData? iconButtonTheme,
    ListTileThemeData? listTileTheme,
    MenuBarThemeData? menuBarTheme,
    MenuButtonThemeData? menuButtonTheme,
    MenuThemeData? menuTheme,
    NavigationBarThemeData? navigationBarTheme,
    NavigationDrawerThemeData? navigationDrawerTheme,
    NavigationRailThemeData? navigationRailTheme,
    OutlinedButtonThemeData? outlinedButtonTheme,
    PopupMenuThemeData? popupMenuTheme,
    ProgressIndicatorThemeData? progressIndicatorTheme,
    RadioThemeData? radioTheme,
    SearchBarThemeData? searchBarTheme,
    SearchViewThemeData? searchViewTheme,
    SegmentedButtonThemeData? segmentedButtonTheme,
    SliderThemeData? sliderTheme,
    SnackBarThemeData? snackBarTheme,
    SwitchThemeData? switchTheme,
    // TODO(QuncCccccc): Change the parameter type to TabBarThemeData
    Object? tabBarTheme,
    TextButtonThemeData? textButtonTheme,
    TextSelectionThemeData? textSelectionTheme,
    TimePickerThemeData? timePickerTheme,
    ToggleButtonsThemeData? toggleButtonsTheme,
    TooltipThemeData? tooltipTheme,
    // DEPRECATED (newest deprecations at the bottom)
    @Deprecated(
      'Use OverflowBar instead. '
      'This feature was deprecated after v3.21.0-10.0.pre.',
    )
    ButtonBarThemeData? buttonBarTheme,
    @Deprecated(
      'Use DialogThemeData.backgroundColor instead. '
      'This feature was deprecated after v3.27.0-0.1.pre.',
    )
    Color? dialogBackgroundColor,
    @Deprecated(
      'Use TabBarThemeData.indicatorColor instead. '
      'This feature was deprecated after v3.28.0-1.0.pre.',
    )
    Color? indicatorColor,
  }) {
    // GENERAL CONFIGURATION
    cupertinoOverrideTheme = cupertinoOverrideTheme?.noDefault();
    extensions ??= <ThemeExtension<dynamic>>[];
    adaptations ??= <Adaptation<Object>>[];
    inputDecorationTheme ??= const InputDecorationTheme();
    platform ??= defaultTargetPlatform;
    switch (platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.iOS:
        materialTapTargetSize ??= MaterialTapTargetSize.padded;
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        materialTapTargetSize ??= MaterialTapTargetSize.shrinkWrap;
    }
    pageTransitionsTheme ??= const PageTransitionsTheme();
    scrollbarTheme ??= const ScrollbarThemeData();
    visualDensity ??= VisualDensity.defaultDensityForPlatform(platform);
    useMaterial3 ??= true;
    final bool useInkSparkle = platform == TargetPlatform.android && !kIsWeb;
    splashFactory ??=
        useMaterial3
            ? useInkSparkle
                ? InkSparkle.splashFactory
                : InkRipple.splashFactory
            : InkSplash.splashFactory;

    // COLOR
    assert(
      colorScheme?.brightness == null || brightness == null || colorScheme!.brightness == brightness,
      'ThemeData.brightness does not match ColorScheme.brightness. '
      'Either override ColorScheme.brightness or ThemeData.brightness to '
      'match the other.',
    );
    assert(colorSchemeSeed == null || colorScheme == null);
    assert(colorSchemeSeed == null || primarySwatch == null);
    assert(colorSchemeSeed == null || primaryColor == null);
    final Brightness effectiveBrightness = brightness ?? colorScheme?.brightness ?? Brightness.light;
    final bool isDark = effectiveBrightness == Brightness.dark;
    if (colorSchemeSeed != null || useMaterial3) {
      if (colorSchemeSeed != null) {
        colorScheme = ColorScheme.fromSeed(seedColor: colorSchemeSeed, brightness: effectiveBrightness);
      }
      colorScheme ??= isDark ? _colorSchemeDarkM3 : _colorSchemeLightM3;

      // For surfaces that use primary color in light themes and surface color in dark
      final Color primarySurfaceColor = isDark ? colorScheme.surface : colorScheme.primary;
      final Color onPrimarySurfaceColor = isDark ? colorScheme.onSurface : colorScheme.onPrimary;

      // Default some of the color settings to values from the color scheme
      primaryColor ??= primarySurfaceColor;
      canvasColor ??= colorScheme.surface;
      scaffoldBackgroundColor ??= colorScheme.surface;
      cardColor ??= colorScheme.surface;
      dividerColor ??= colorScheme.outline;
      dialogBackgroundColor ??= colorScheme.surface;
      indicatorColor ??= onPrimarySurfaceColor;
      applyElevationOverlayColor ??= brightness == Brightness.dark;
    }
    applyElevationOverlayColor ??= false;
    primarySwatch ??= Colors.blue;
    primaryColor ??= isDark ? Colors.grey[900]! : primarySwatch;
    final Brightness estimatedPrimaryColorBrightness = estimateBrightnessForColor(primaryColor);
    primaryColorLight ??= isDark ? Colors.grey[500]! : primarySwatch[100]!;
    primaryColorDark ??= isDark ? Colors.black : primarySwatch[700]!;
    final bool primaryIsDark = estimatedPrimaryColorBrightness == Brightness.dark;
    focusColor ??= isDark ? Colors.white.withOpacity(0.12) : Colors.black.withOpacity(0.12);
    hoverColor ??= isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.04);
    shadowColor ??= Colors.black;
    canvasColor ??= isDark ? Colors.grey[850]! : Colors.grey[50]!;
    scaffoldBackgroundColor ??= canvasColor;
    cardColor ??= isDark ? Colors.grey[800]! : Colors.white;
    dividerColor ??= isDark ? const Color(0x1FFFFFFF) : const Color(0x1F000000);
    // Create a ColorScheme that is backwards compatible as possible
    // with the existing default ThemeData color values.
    colorScheme ??= ColorScheme.fromSwatch(
      primarySwatch: primarySwatch,
      accentColor: isDark ? Colors.tealAccent[200]! : primarySwatch[500]!,
      cardColor: cardColor,
      backgroundColor: isDark ? Colors.grey[700]! : primarySwatch[200]!,
      errorColor: Colors.red[700],
      brightness: effectiveBrightness,
    );
    unselectedWidgetColor ??= isDark ? Colors.white70 : Colors.black54;
    // Spec doesn't specify a dark theme secondaryHeaderColor, this is a guess.
    secondaryHeaderColor ??= isDark ? Colors.grey[700]! : primarySwatch[50]!;
    hintColor ??= isDark ? Colors.white60 : Colors.black.withOpacity(0.6);
    // The default [buttonTheme] is here because it doesn't use the defaults for
    // [disabledColor], [highlightColor], and [splashColor].
    buttonTheme ??= ButtonThemeData(
      colorScheme: colorScheme,
      buttonColor: isDark ? primarySwatch[600]! : Colors.grey[300]!,
      disabledColor: disabledColor,
      focusColor: focusColor,
      hoverColor: hoverColor,
      highlightColor: highlightColor,
      splashColor: splashColor,
      materialTapTargetSize: materialTapTargetSize,
    );
    disabledColor ??= isDark ? Colors.white38 : Colors.black38;
    highlightColor ??= isDark ? const Color(0x40CCCCCC) : const Color(0x66BCBCBC);
    splashColor ??= isDark ? const Color(0x40CCCCCC) : const Color(0x66C8C8C8);

    // TYPOGRAPHY & ICONOGRAPHY
    typography ??=
        useMaterial3
            ? Typography.material2021(platform: platform, colorScheme: colorScheme)
            : Typography.material2014(platform: platform);
    TextTheme defaultTextTheme = isDark ? typography.white : typography.black;
    TextTheme defaultPrimaryTextTheme = primaryIsDark ? typography.white : typography.black;
    if (fontFamily != null) {
      defaultTextTheme = defaultTextTheme.apply(fontFamily: fontFamily);
      defaultPrimaryTextTheme = defaultPrimaryTextTheme.apply(fontFamily: fontFamily);
    }
    if (fontFamilyFallback != null) {
      defaultTextTheme = defaultTextTheme.apply(fontFamilyFallback: fontFamilyFallback);
      defaultPrimaryTextTheme = defaultPrimaryTextTheme.apply(fontFamilyFallback: fontFamilyFallback);
    }
    if (package != null) {
      defaultTextTheme = defaultTextTheme.apply(package: package);
      defaultPrimaryTextTheme = defaultPrimaryTextTheme.apply(package: package);
    }
    textTheme = defaultTextTheme.merge(textTheme);
    primaryTextTheme = defaultPrimaryTextTheme.merge(primaryTextTheme);
    iconTheme ??= isDark ? IconThemeData(color: kDefaultIconLightColor) : IconThemeData(color: kDefaultIconDarkColor);
    primaryIconTheme ??=
        primaryIsDark ? const IconThemeData(color: Colors.white) : const IconThemeData(color: Colors.black);

    // COMPONENT THEMES
    appBarTheme ??= const AppBarTheme();
    badgeTheme ??= const BadgeThemeData();
    bannerTheme ??= const MaterialBannerThemeData();
    bottomAppBarTheme ??= const BottomAppBarTheme();
    bottomNavigationBarTheme ??= const BottomNavigationBarThemeData();
    bottomSheetTheme ??= const BottomSheetThemeData();
    // TODO(QuncCccccc): Clean it up once the type of `cardTheme` is changed to `CardThemeData`
    if (cardTheme != null) {
      if (cardTheme is CardTheme) {
        cardTheme = cardTheme.data;
      } else if (cardTheme is! CardThemeData) {
        throw ArgumentError('cardTheme must be either a CardThemeData or a CardTheme');
      }
    }
    cardTheme ??= const CardThemeData();
    checkboxTheme ??= const CheckboxThemeData();
    chipTheme ??= const ChipThemeData();
    dataTableTheme ??= const DataTableThemeData();
    datePickerTheme ??= const DatePickerThemeData();
    // TODO(QuncCccccc): Clean this up once the type of `dialogTheme` is changed to `DialogThemeData`
    if (dialogTheme != null) {
      if (dialogTheme is DialogTheme) {
        dialogTheme = dialogTheme.data;
      } else if (dialogTheme is! DialogThemeData) {
        throw ArgumentError('dialogTheme must be either a DialogThemeData or a DialogTheme');
      }
    }
    dialogTheme ??= const DialogThemeData();
    dividerTheme ??= const DividerThemeData();
    drawerTheme ??= const DrawerThemeData();
    dropdownMenuTheme ??= const DropdownMenuThemeData();
    elevatedButtonTheme ??= const ElevatedButtonThemeData();
    expansionTileTheme ??= const ExpansionTileThemeData();
    filledButtonTheme ??= const FilledButtonThemeData();
    floatingActionButtonTheme ??= const FloatingActionButtonThemeData();
    iconButtonTheme ??= const IconButtonThemeData();
    listTileTheme ??= const ListTileThemeData();
    menuBarTheme ??= const MenuBarThemeData();
    menuButtonTheme ??= const MenuButtonThemeData();
    menuTheme ??= const MenuThemeData();
    navigationBarTheme ??= const NavigationBarThemeData();
    navigationDrawerTheme ??= const NavigationDrawerThemeData();
    navigationRailTheme ??= const NavigationRailThemeData();
    outlinedButtonTheme ??= const OutlinedButtonThemeData();
    popupMenuTheme ??= const PopupMenuThemeData();
    progressIndicatorTheme ??= const ProgressIndicatorThemeData();
    radioTheme ??= const RadioThemeData();
    searchBarTheme ??= const SearchBarThemeData();
    searchViewTheme ??= const SearchViewThemeData();
    segmentedButtonTheme ??= const SegmentedButtonThemeData();
    sliderTheme ??= const SliderThemeData();
    snackBarTheme ??= const SnackBarThemeData();
    switchTheme ??= const SwitchThemeData();
    // TODO(QuncCccccc): Clean this up once the type of `tabBarTheme` is changed to `TabBarThemeData`
    if (tabBarTheme != null) {
      if (tabBarTheme is TabBarTheme) {
        tabBarTheme = tabBarTheme.data;
      } else if (tabBarTheme is! TabBarThemeData) {
        throw ArgumentError('tabBarTheme must be either a TabBarThemeData or a TabBarTheme');
      }
    }
    tabBarTheme ??= const TabBarThemeData();
    textButtonTheme ??= const TextButtonThemeData();
    textSelectionTheme ??= const TextSelectionThemeData();
    timePickerTheme ??= const TimePickerThemeData();
    toggleButtonsTheme ??= const ToggleButtonsThemeData();
    tooltipTheme ??= const TooltipThemeData();
    // DEPRECATED (newest deprecations at the bottom)
    buttonBarTheme ??= const ButtonBarThemeData();
    dialogBackgroundColor ??= isDark ? Colors.grey[800]! : Colors.white;
    indicatorColor ??= colorScheme.secondary == primaryColor ? Colors.white : colorScheme.secondary;
    return ThemeData.raw(
      // For the sanity of the reader, make sure these properties are in the same
      // order in every place that they are separated by section comments (e.g.
      // GENERAL CONFIGURATION). Each section except for deprecations should be
      // alphabetical by symbol name.

      // GENERAL CONFIGURATION
      adaptationMap: _createAdaptationMap(adaptations),
      applyElevationOverlayColor: applyElevationOverlayColor,
      cupertinoOverrideTheme: cupertinoOverrideTheme,
      extensions: _themeExtensionIterableToMap(extensions),
      inputDecorationTheme: inputDecorationTheme,
      materialTapTargetSize: materialTapTargetSize,
      pageTransitionsTheme: pageTransitionsTheme,
      platform: platform,
      scrollbarTheme: scrollbarTheme,
      splashFactory: splashFactory,
      visualDensity: visualDensity,
      // COLOR
      canvasColor: canvasColor,
      cardColor: cardColor,
      colorScheme: colorScheme,
      disabledColor: disabledColor,
      dividerColor: dividerColor,
      focusColor: focusColor,
      highlightColor: highlightColor,
      hintColor: hintColor,
      hoverColor: hoverColor,
      primaryColor: primaryColor,
      primaryColorDark: primaryColorDark,
      primaryColorLight: primaryColorLight,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      secondaryHeaderColor: secondaryHeaderColor,
      shadowColor: shadowColor,
      splashColor: splashColor,
      unselectedWidgetColor: unselectedWidgetColor,
      // TYPOGRAPHY & ICONOGRAPHY
      iconTheme: iconTheme,
      primaryTextTheme: primaryTextTheme,
      textTheme: textTheme,
      typography: typography,
      primaryIconTheme: primaryIconTheme,
      // COMPONENT THEMES
      actionIconTheme: actionIconTheme,
      appBarTheme: appBarTheme,
      badgeTheme: badgeTheme,
      bannerTheme: bannerTheme,
      bottomAppBarTheme: bottomAppBarTheme,
      bottomNavigationBarTheme: bottomNavigationBarTheme,
      bottomSheetTheme: bottomSheetTheme,
      buttonTheme: buttonTheme,
      cardTheme: cardTheme as CardThemeData,
      checkboxTheme: checkboxTheme,
      chipTheme: chipTheme,
      dataTableTheme: dataTableTheme,
      datePickerTheme: datePickerTheme,
      dialogTheme: dialogTheme as DialogThemeData,
      dividerTheme: dividerTheme,
      drawerTheme: drawerTheme,
      dropdownMenuTheme: dropdownMenuTheme,
      elevatedButtonTheme: elevatedButtonTheme,
      expansionTileTheme: expansionTileTheme,
      filledButtonTheme: filledButtonTheme,
      floatingActionButtonTheme: floatingActionButtonTheme,
      iconButtonTheme: iconButtonTheme,
      listTileTheme: listTileTheme,
      menuBarTheme: menuBarTheme,
      menuButtonTheme: menuButtonTheme,
      menuTheme: menuTheme,
      navigationBarTheme: navigationBarTheme,
      navigationDrawerTheme: navigationDrawerTheme,
      navigationRailTheme: navigationRailTheme,
      outlinedButtonTheme: outlinedButtonTheme,
      popupMenuTheme: popupMenuTheme,
      progressIndicatorTheme: progressIndicatorTheme,
      radioTheme: radioTheme,
      searchBarTheme: searchBarTheme,
      searchViewTheme: searchViewTheme,
      segmentedButtonTheme: segmentedButtonTheme,
      sliderTheme: sliderTheme,
      snackBarTheme: snackBarTheme,
      switchTheme: switchTheme,
      tabBarTheme: tabBarTheme as TabBarThemeData,
      textButtonTheme: textButtonTheme,
      textSelectionTheme: textSelectionTheme,
      timePickerTheme: timePickerTheme,
      toggleButtonsTheme: toggleButtonsTheme,
      tooltipTheme: tooltipTheme,
      // DEPRECATED (newest deprecations at the bottom)
      buttonBarTheme: buttonBarTheme,
      dialogBackgroundColor: dialogBackgroundColor,
      indicatorColor: indicatorColor,
    );
  }

  const ThemeData.raw({
    // For the sanity of the reader, make sure these properties are in the same
    // order in every place that they are separated by section comments (e.g.
    // GENERAL CONFIGURATION). Each section except for deprecations should be
    // alphabetical by symbol name.

    // GENERAL CONFIGURATION
    required this.adaptationMap,
    required this.applyElevationOverlayColor,
    required this.cupertinoOverrideTheme,
    required this.extensions,
    required this.inputDecorationTheme,
    required this.materialTapTargetSize,
    required this.pageTransitionsTheme,
    required this.platform,
    required this.scrollbarTheme,
    required this.splashFactory,
    required this.visualDensity,
    // COLOR
    required this.colorScheme,
    // [colorScheme] is the preferred way to configure colors. The [Color] properties
    // listed below (as well as primarySwatch) will gradually be phased out, see
    // https://github.com/flutter/flutter/issues/91772.
    required this.canvasColor,
    required this.cardColor,
    required this.disabledColor,
    required this.dividerColor,
    required this.focusColor,
    required this.highlightColor,
    required this.hintColor,
    required this.hoverColor,
    required this.primaryColor,
    required this.primaryColorDark,
    required this.primaryColorLight,
    required this.scaffoldBackgroundColor,
    required this.secondaryHeaderColor,
    required this.shadowColor,
    required this.splashColor,
    required this.unselectedWidgetColor,
    // TYPOGRAPHY & ICONOGRAPHY
    required this.iconTheme,
    required this.primaryIconTheme,
    required this.primaryTextTheme,
    required this.textTheme,
    required this.typography,
    // COMPONENT THEMES
    required this.actionIconTheme,
    required this.appBarTheme,
    required this.badgeTheme,
    required this.bannerTheme,
    required this.bottomAppBarTheme,
    required this.bottomNavigationBarTheme,
    required this.bottomSheetTheme,
    required this.buttonTheme,
    required this.cardTheme,
    required this.checkboxTheme,
    required this.chipTheme,
    required this.dataTableTheme,
    required this.datePickerTheme,
    required this.dialogTheme,
    required this.dividerTheme,
    required this.drawerTheme,
    required this.dropdownMenuTheme,
    required this.elevatedButtonTheme,
    required this.expansionTileTheme,
    required this.filledButtonTheme,
    required this.floatingActionButtonTheme,
    required this.iconButtonTheme,
    required this.listTileTheme,
    required this.menuBarTheme,
    required this.menuButtonTheme,
    required this.menuTheme,
    required this.navigationBarTheme,
    required this.navigationDrawerTheme,
    required this.navigationRailTheme,
    required this.outlinedButtonTheme,
    required this.popupMenuTheme,
    required this.progressIndicatorTheme,
    required this.radioTheme,
    required this.searchBarTheme,
    required this.searchViewTheme,
    required this.segmentedButtonTheme,
    required this.sliderTheme,
    required this.snackBarTheme,
    required this.switchTheme,
    required this.tabBarTheme,
    required this.textButtonTheme,
    required this.textSelectionTheme,
    required this.timePickerTheme,
    required this.toggleButtonsTheme,
    required this.tooltipTheme,
    @Deprecated(
      'Use DialogThemeData.backgroundColor instead. '
      'This feature was deprecated after v3.27.0-0.1.pre.',
    )
    required this.dialogBackgroundColor,
    @Deprecated(
      'Use TabBarThemeData.indicatorColor instead. '
      'This feature was deprecated after v3.28.0-1.0.pre.',
    )
    required this.indicatorColor, // DEPRECATED (newest deprecations at the bottom)
    @Deprecated(
      'Use OverflowBar instead. '
      'This feature was deprecated after v3.21.0-10.0.pre.',
    )
    ButtonBarThemeData? buttonBarTheme,
  }) : // DEPRECATED (newest deprecations at the bottom)
       // should not be `required`, use getter pattern to avoid breakages.
       _buttonBarTheme = buttonBarTheme,
       assert(buttonBarTheme != null);

  factory ThemeData.from({required ColorScheme colorScheme, TextTheme? textTheme, bool? useMaterial3}) {
    final bool isDark = colorScheme.brightness == Brightness.dark;

    // For surfaces that use primary color in light themes and surface color in dark
    final Color primarySurfaceColor = isDark ? colorScheme.surface : colorScheme.primary;
    final Color onPrimarySurfaceColor = isDark ? colorScheme.onSurface : colorScheme.onPrimary;

    return ThemeData(
      colorScheme: colorScheme,
      brightness: colorScheme.brightness,
      primaryColor: primarySurfaceColor,
      canvasColor: colorScheme.surface,
      scaffoldBackgroundColor: colorScheme.surface,
      cardColor: colorScheme.surface,
      dividerColor: colorScheme.onSurface.withOpacity(0.12),
      dialogBackgroundColor: colorScheme.surface,
      indicatorColor: onPrimarySurfaceColor,
      textTheme: textTheme,
      applyElevationOverlayColor: isDark,
      useMaterial3: useMaterial3,
    );
  }

  factory ThemeData.light({bool? useMaterial3}) => ThemeData(brightness: Brightness.light, useMaterial3: useMaterial3);

  factory ThemeData.dark({bool? useMaterial3}) => ThemeData(brightness: Brightness.dark, useMaterial3: useMaterial3);

  factory ThemeData.fallback({bool? useMaterial3}) => ThemeData.light(useMaterial3: useMaterial3);

  Adaptation<T>? getAdaptation<T>() => adaptationMap[T] as Adaptation<T>?;

  static Map<Type, Adaptation<Object>> _createAdaptationMap(Iterable<Adaptation<Object>> adaptations) {
    final Map<Type, Adaptation<Object>> adaptationMap = <Type, Adaptation<Object>>{
      for (final Adaptation<Object> adaptation in adaptations) adaptation.type: adaptation,
    };
    return adaptationMap;
  }

  Brightness get brightness => colorScheme.brightness;

  // For the sanity of the reader, make sure these properties are in the same
  // order in every place that they are separated by section comments (e.g.
  // GENERAL CONFIGURATION). Each section except for deprecations should be
  // alphabetical by symbol name.

  // GENERAL CONFIGURATION

  final bool applyElevationOverlayColor;

  final NoDefaultCupertinoThemeData? cupertinoOverrideTheme;

  final Map<Object, ThemeExtension<dynamic>> extensions;

  T? extension<T>() => extensions[T] as T?;

  final Map<Type, Adaptation<Object>> adaptationMap;

  final InputDecorationTheme inputDecorationTheme;

  final MaterialTapTargetSize materialTapTargetSize;

  final PageTransitionsTheme pageTransitionsTheme;

  final TargetPlatform platform;

  final ScrollbarThemeData scrollbarTheme;

  final InteractiveInkFeatureFactory splashFactory;

  final VisualDensity visualDensity;

  // COLOR

  final Color canvasColor;

  final Color cardColor;

  final ColorScheme colorScheme;

  final Color disabledColor;

  final Color dividerColor;

  final Color focusColor;

  final Color highlightColor;

  final Color hintColor;

  final Color hoverColor;

  final Color primaryColor;

  final Color primaryColorDark;

  final Color primaryColorLight;

  final Color scaffoldBackgroundColor;

  // According to the spec for data tables:
  // https://material.io/archive/guidelines/components/data-tables.html#data-tables-tables-within-cards
  // ...this should be the "50-value of secondary app color".
  final Color secondaryHeaderColor;

  final Color shadowColor;

  final Color splashColor;

  final Color unselectedWidgetColor;

  // TYPOGRAPHY & ICONOGRAPHY

  final IconThemeData iconTheme;

  final IconThemeData primaryIconTheme;

  final TextTheme primaryTextTheme;

  final TextTheme textTheme;

  final Typography typography;

  // COMPONENT THEMES

  final ActionIconThemeData? actionIconTheme;

  final AppBarTheme appBarTheme;

  final BadgeThemeData badgeTheme;

  final MaterialBannerThemeData bannerTheme;

  final BottomAppBarTheme bottomAppBarTheme;

  final BottomNavigationBarThemeData bottomNavigationBarTheme;

  final BottomSheetThemeData bottomSheetTheme;

  final ButtonThemeData buttonTheme;

  final CardThemeData cardTheme;

  final CheckboxThemeData checkboxTheme;

  final ChipThemeData chipTheme;

  final DataTableThemeData dataTableTheme;

  final DatePickerThemeData datePickerTheme;

  final DialogThemeData dialogTheme;

  final DividerThemeData dividerTheme;

  final DrawerThemeData drawerTheme;

  final DropdownMenuThemeData dropdownMenuTheme;

  final ElevatedButtonThemeData elevatedButtonTheme;

  final ExpansionTileThemeData expansionTileTheme;

  final FilledButtonThemeData filledButtonTheme;

  final FloatingActionButtonThemeData floatingActionButtonTheme;

  final IconButtonThemeData iconButtonTheme;

  final ListTileThemeData listTileTheme;

  final MenuBarThemeData menuBarTheme;

  final MenuButtonThemeData menuButtonTheme;

  final MenuThemeData menuTheme;

  final NavigationBarThemeData navigationBarTheme;

  final NavigationDrawerThemeData navigationDrawerTheme;

  final NavigationRailThemeData navigationRailTheme;

  final OutlinedButtonThemeData outlinedButtonTheme;

  final PopupMenuThemeData popupMenuTheme;

  final ProgressIndicatorThemeData progressIndicatorTheme;

  final RadioThemeData radioTheme;

  final SearchBarThemeData searchBarTheme;

  final SearchViewThemeData searchViewTheme;

  final SegmentedButtonThemeData segmentedButtonTheme;

  final SliderThemeData sliderTheme;

  final SnackBarThemeData snackBarTheme;

  final SwitchThemeData switchTheme;

  final TabBarThemeData tabBarTheme;

  final TextButtonThemeData textButtonTheme;

  final TextSelectionThemeData textSelectionTheme;

  final TimePickerThemeData timePickerTheme;

  final ToggleButtonsThemeData toggleButtonsTheme;

  final TooltipThemeData tooltipTheme;

  @Deprecated(
    'Use OverflowBar instead. '
    'This feature was deprecated after v3.21.0-10.0.pre.',
  )
  ButtonBarThemeData get buttonBarTheme => _buttonBarTheme!;
  final ButtonBarThemeData? _buttonBarTheme;

  @Deprecated(
    'Use DialogThemeData.backgroundColor instead. '
    'This feature was deprecated after v3.27.0-0.1.pre.',
  )
  final Color dialogBackgroundColor;

  @Deprecated(
    'Use TabBarThemeData.indicatorColor instead. '
    'This feature was deprecated after v3.28.0-1.0.pre.',
  )
  final Color indicatorColor;

  ThemeData copyWith({
    // For the sanity of the reader, make sure these properties are in the same
    // order in every place that they are separated by section comments (e.g.
    // GENERAL CONFIGURATION). Each section except for deprecations should be
    // alphabetical by symbol name.

    // GENERAL CONFIGURATION
    Iterable<Adaptation<Object>>? adaptations,
    bool? applyElevationOverlayColor,
    NoDefaultCupertinoThemeData? cupertinoOverrideTheme,
    Iterable<ThemeExtension<dynamic>>? extensions,
    InputDecorationTheme? inputDecorationTheme,
    MaterialTapTargetSize? materialTapTargetSize,
    PageTransitionsTheme? pageTransitionsTheme,
    TargetPlatform? platform,
    ScrollbarThemeData? scrollbarTheme,
    InteractiveInkFeatureFactory? splashFactory,
    VisualDensity? visualDensity,
    // COLOR
    ColorScheme? colorScheme,
    Brightness? brightness,
    // [colorScheme] is the preferred way to configure colors. The [Color] properties
    // listed below (as well as primarySwatch) will gradually be phased out, see
    // https://github.com/flutter/flutter/issues/91772.
    Color? canvasColor,
    Color? cardColor,
    Color? disabledColor,
    Color? dividerColor,
    Color? focusColor,
    Color? highlightColor,
    Color? hintColor,
    Color? hoverColor,
    Color? primaryColor,
    Color? primaryColorDark,
    Color? primaryColorLight,
    Color? scaffoldBackgroundColor,
    Color? secondaryHeaderColor,
    Color? shadowColor,
    Color? splashColor,
    Color? unselectedWidgetColor,
    // TYPOGRAPHY & ICONOGRAPHY
    IconThemeData? iconTheme,
    IconThemeData? primaryIconTheme,
    TextTheme? primaryTextTheme,
    TextTheme? textTheme,
    Typography? typography,
    // COMPONENT THEMES
    ActionIconThemeData? actionIconTheme,
    AppBarTheme? appBarTheme,
    BadgeThemeData? badgeTheme,
    MaterialBannerThemeData? bannerTheme,
    BottomAppBarTheme? bottomAppBarTheme,
    BottomNavigationBarThemeData? bottomNavigationBarTheme,
    BottomSheetThemeData? bottomSheetTheme,
    ButtonThemeData? buttonTheme,
    Object? cardTheme,
    CheckboxThemeData? checkboxTheme,
    ChipThemeData? chipTheme,
    DataTableThemeData? dataTableTheme,
    DatePickerThemeData? datePickerTheme,
    // TODO(QuncCccccc): Change the parameter type to DialogThemeData
    Object? dialogTheme,
    DividerThemeData? dividerTheme,
    DrawerThemeData? drawerTheme,
    DropdownMenuThemeData? dropdownMenuTheme,
    ElevatedButtonThemeData? elevatedButtonTheme,
    ExpansionTileThemeData? expansionTileTheme,
    FilledButtonThemeData? filledButtonTheme,
    FloatingActionButtonThemeData? floatingActionButtonTheme,
    IconButtonThemeData? iconButtonTheme,
    ListTileThemeData? listTileTheme,
    MenuBarThemeData? menuBarTheme,
    MenuButtonThemeData? menuButtonTheme,
    MenuThemeData? menuTheme,
    NavigationBarThemeData? navigationBarTheme,
    NavigationDrawerThemeData? navigationDrawerTheme,
    NavigationRailThemeData? navigationRailTheme,
    OutlinedButtonThemeData? outlinedButtonTheme,
    PopupMenuThemeData? popupMenuTheme,
    ProgressIndicatorThemeData? progressIndicatorTheme,
    RadioThemeData? radioTheme,
    SearchBarThemeData? searchBarTheme,
    SearchViewThemeData? searchViewTheme,
    SegmentedButtonThemeData? segmentedButtonTheme,
    SliderThemeData? sliderTheme,
    SnackBarThemeData? snackBarTheme,
    SwitchThemeData? switchTheme,
    // TODO(QuncCccccc): Change the parameter type to TabBarThemeData
    Object? tabBarTheme,
    TextButtonThemeData? textButtonTheme,
    TextSelectionThemeData? textSelectionTheme,
    TimePickerThemeData? timePickerTheme,
    ToggleButtonsThemeData? toggleButtonsTheme,
    TooltipThemeData? tooltipTheme,
    // DEPRECATED (newest deprecations at the bottom)
    @Deprecated(
      'Use a ThemeData constructor (.from, .light, or .dark) instead. '
      'These constructors all have a useMaterial3 argument, '
      'and they set appropriate default values based on its value. '
      'See the useMaterial3 API documentation for full details. '
      'This feature was deprecated after v3.13.0-0.2.pre.',
    )
    bool? useMaterial3,
    @Deprecated(
      'Use OverflowBar instead. '
      'This feature was deprecated after v3.21.0-10.0.pre.',
    )
    ButtonBarThemeData? buttonBarTheme,
    @Deprecated(
      'Use DialogThemeData.backgroundColor instead. '
      'This feature was deprecated after v3.27.0-0.1.pre.',
    )
    Color? dialogBackgroundColor,
    @Deprecated(
      'Use TabBarThemeData.indicatorColor instead. '
      'This feature was deprecated after v3.28.0-1.0.pre.',
    )
    Color? indicatorColor,
  }) {
    cupertinoOverrideTheme = cupertinoOverrideTheme?.noDefault();

    // TODO(QuncCccccc): Clean it up once the type of `cardTheme` is changed to `CardThemeData`
    if (cardTheme != null) {
      if (cardTheme is CardTheme) {
        cardTheme = cardTheme.data;
      } else if (cardTheme is! CardThemeData) {
        throw ArgumentError('cardTheme must be either a CardThemeData or a CardTheme');
      }
    }

    // TODO(QuncCccccc): Clean this up once the type of `dialogTheme` is changed to `DialogThemeData`
    if (dialogTheme != null) {
      if (dialogTheme is DialogTheme) {
        dialogTheme = dialogTheme.data;
      } else if (dialogTheme is! DialogThemeData) {
        throw ArgumentError('dialogTheme must be either a DialogThemeData or a DialogTheme');
      }
    }

    // TODO(QuncCccccc): Clean this up once the type of `tabBarTheme` is changed to `TabBarThemeData`
    if (tabBarTheme != null) {
      if (tabBarTheme is TabBarTheme) {
        tabBarTheme = tabBarTheme.data;
      } else if (tabBarTheme is! TabBarThemeData) {
        throw ArgumentError('tabBarTheme must be either a TabBarThemeData or a TabBarTheme');
      }
    }
    return ThemeData.raw(
      // For the sanity of the reader, make sure these properties are in the same
      // order in every place that they are separated by section comments (e.g.
      // GENERAL CONFIGURATION). Each section except for deprecations should be
      // alphabetical by symbol name.

      // GENERAL CONFIGURATION
      adaptationMap: adaptations != null ? _createAdaptationMap(adaptations) : adaptationMap,
      applyElevationOverlayColor: applyElevationOverlayColor ?? this.applyElevationOverlayColor,
      cupertinoOverrideTheme: cupertinoOverrideTheme ?? this.cupertinoOverrideTheme,
      extensions: (extensions != null) ? _themeExtensionIterableToMap(extensions) : this.extensions,
      inputDecorationTheme: inputDecorationTheme ?? this.inputDecorationTheme,
      materialTapTargetSize: materialTapTargetSize ?? this.materialTapTargetSize,
      pageTransitionsTheme: pageTransitionsTheme ?? this.pageTransitionsTheme,
      platform: platform ?? this.platform,
      scrollbarTheme: scrollbarTheme ?? this.scrollbarTheme,
      splashFactory: splashFactory ?? this.splashFactory,
      // When deprecated useMaterial3 removed, maintain `this.useMaterial3` here
      // for == evaluation.
      visualDensity: visualDensity ?? this.visualDensity,
      // COLOR
      canvasColor: canvasColor ?? this.canvasColor,
      cardColor: cardColor ?? this.cardColor,
      colorScheme: (colorScheme ?? this.colorScheme).copyWith(brightness: brightness),
      disabledColor: disabledColor ?? this.disabledColor,
      dividerColor: dividerColor ?? this.dividerColor,
      focusColor: focusColor ?? this.focusColor,
      highlightColor: highlightColor ?? this.highlightColor,
      hintColor: hintColor ?? this.hintColor,
      hoverColor: hoverColor ?? this.hoverColor,
      primaryColor: primaryColor ?? this.primaryColor,
      primaryColorDark: primaryColorDark ?? this.primaryColorDark,
      primaryColorLight: primaryColorLight ?? this.primaryColorLight,
      scaffoldBackgroundColor: scaffoldBackgroundColor ?? this.scaffoldBackgroundColor,
      secondaryHeaderColor: secondaryHeaderColor ?? this.secondaryHeaderColor,
      shadowColor: shadowColor ?? this.shadowColor,
      splashColor: splashColor ?? this.splashColor,
      unselectedWidgetColor: unselectedWidgetColor ?? this.unselectedWidgetColor,
      // TYPOGRAPHY & ICONOGRAPHY
      iconTheme: iconTheme ?? this.iconTheme,
      primaryIconTheme: primaryIconTheme ?? this.primaryIconTheme,
      primaryTextTheme: primaryTextTheme ?? this.primaryTextTheme,
      textTheme: textTheme ?? this.textTheme,
      typography: typography ?? this.typography,
      // COMPONENT THEMES
      actionIconTheme: actionIconTheme ?? this.actionIconTheme,
      appBarTheme: appBarTheme ?? this.appBarTheme,
      badgeTheme: badgeTheme ?? this.badgeTheme,
      bannerTheme: bannerTheme ?? this.bannerTheme,
      bottomAppBarTheme: bottomAppBarTheme ?? this.bottomAppBarTheme,
      bottomNavigationBarTheme: bottomNavigationBarTheme ?? this.bottomNavigationBarTheme,
      bottomSheetTheme: bottomSheetTheme ?? this.bottomSheetTheme,
      buttonTheme: buttonTheme ?? this.buttonTheme,
      cardTheme: cardTheme as CardThemeData? ?? this.cardTheme,
      checkboxTheme: checkboxTheme ?? this.checkboxTheme,
      chipTheme: chipTheme ?? this.chipTheme,
      dataTableTheme: dataTableTheme ?? this.dataTableTheme,
      datePickerTheme: datePickerTheme ?? this.datePickerTheme,
      dialogTheme: dialogTheme as DialogThemeData? ?? this.dialogTheme,
      dividerTheme: dividerTheme ?? this.dividerTheme,
      drawerTheme: drawerTheme ?? this.drawerTheme,
      dropdownMenuTheme: dropdownMenuTheme ?? this.dropdownMenuTheme,
      elevatedButtonTheme: elevatedButtonTheme ?? this.elevatedButtonTheme,
      expansionTileTheme: expansionTileTheme ?? this.expansionTileTheme,
      filledButtonTheme: filledButtonTheme ?? this.filledButtonTheme,
      floatingActionButtonTheme: floatingActionButtonTheme ?? this.floatingActionButtonTheme,
      iconButtonTheme: iconButtonTheme ?? this.iconButtonTheme,
      listTileTheme: listTileTheme ?? this.listTileTheme,
      menuBarTheme: menuBarTheme ?? this.menuBarTheme,
      menuButtonTheme: menuButtonTheme ?? this.menuButtonTheme,
      menuTheme: menuTheme ?? this.menuTheme,
      navigationBarTheme: navigationBarTheme ?? this.navigationBarTheme,
      navigationDrawerTheme: navigationDrawerTheme ?? this.navigationDrawerTheme,
      navigationRailTheme: navigationRailTheme ?? this.navigationRailTheme,
      outlinedButtonTheme: outlinedButtonTheme ?? this.outlinedButtonTheme,
      popupMenuTheme: popupMenuTheme ?? this.popupMenuTheme,
      progressIndicatorTheme: progressIndicatorTheme ?? this.progressIndicatorTheme,
      radioTheme: radioTheme ?? this.radioTheme,
      searchBarTheme: searchBarTheme ?? this.searchBarTheme,
      searchViewTheme: searchViewTheme ?? this.searchViewTheme,
      segmentedButtonTheme: segmentedButtonTheme ?? this.segmentedButtonTheme,
      sliderTheme: sliderTheme ?? this.sliderTheme,
      snackBarTheme: snackBarTheme ?? this.snackBarTheme,
      switchTheme: switchTheme ?? this.switchTheme,
      tabBarTheme: tabBarTheme as TabBarThemeData? ?? this.tabBarTheme,
      textButtonTheme: textButtonTheme ?? this.textButtonTheme,
      textSelectionTheme: textSelectionTheme ?? this.textSelectionTheme,
      timePickerTheme: timePickerTheme ?? this.timePickerTheme,
      toggleButtonsTheme: toggleButtonsTheme ?? this.toggleButtonsTheme,
      tooltipTheme: tooltipTheme ?? this.tooltipTheme,
      // DEPRECATED (newest deprecations at the bottom)
      buttonBarTheme: buttonBarTheme ?? _buttonBarTheme,
      dialogBackgroundColor: dialogBackgroundColor ?? this.dialogBackgroundColor,
      indicatorColor: indicatorColor ?? this.indicatorColor,
    );
  }

  // The number 5 was chosen without any real science or research behind it. It
  // just seemed like a number that's not too big (we should be able to fit 5
  // copies of ThemeData in memory comfortably) and not too small (most apps
  // shouldn't have more than 5 theme/localization pairs).
  static const int _localizedThemeDataCacheSize = 5;

  static final _FifoCache<_IdentityThemeDataCacheKey, ThemeData> _localizedThemeDataCache =
      _FifoCache<_IdentityThemeDataCacheKey, ThemeData>(_localizedThemeDataCacheSize);

  static ThemeData localize(ThemeData baseTheme, TextTheme localTextGeometry) {
    // WARNING: this method memoizes the result in a cache based on the
    // previously seen baseTheme and localTextGeometry. Memoization is safe
    // because all inputs and outputs of this function are deeply immutable, and
    // the computations are referentially transparent. It only short-circuits
    // the computation if the new inputs are identical() to the previous ones.
    // It does not use the == operator, which performs a costly deep comparison.
    //
    // When changing this method, make sure the memoization logic is correct.
    // Remember:
    //
    // There are only two hard things in Computer Science: cache invalidation
    // and naming things. -- Phil Karlton

    return _localizedThemeDataCache.putIfAbsent(
      _IdentityThemeDataCacheKey(baseTheme, localTextGeometry),
      () => baseTheme.copyWith(
        primaryTextTheme: localTextGeometry.merge(baseTheme.primaryTextTheme),
        textTheme: localTextGeometry.merge(baseTheme.textTheme),
      ),
    );
  }

  static Brightness estimateBrightnessForColor(Color color) {
    final double relativeLuminance = color.computeLuminance();

    // See <https://www.w3.org/TR/WCAG20/#contrast-ratiodef>
    // The spec says to use kThreshold=0.0525, but Material Design appears to bias
    // more towards using light text than WCAG20 recommends. Material Design spec
    // doesn't say what value to use, but 0.15 seemed close to what the Material
    // Design spec shows for its color palette on
    // <https://material.io/go/design-theming#color-color-palette>.
    const double kThreshold = 0.15;
    if ((relativeLuminance + 0.05) * (relativeLuminance + 0.05) > kThreshold) {
      return Brightness.light;
    }
    return Brightness.dark;
  }

  static Map<Object, ThemeExtension<dynamic>> _lerpThemeExtensions(ThemeData a, ThemeData b, double t) {
    // Lerp [a].
    final Map<Object, ThemeExtension<dynamic>> newExtensions = a.extensions.map((id, extensionA) {
      final ThemeExtension<dynamic>? extensionB = b.extensions[id];
      return MapEntry<Object, ThemeExtension<dynamic>>(id, extensionA.lerp(extensionB, t));
    });
    // Add [b]-only extensions.
    newExtensions.addEntries(b.extensions.entries.where((entry) => !a.extensions.containsKey(entry.key)));

    return newExtensions;
  }

  static Map<Object, ThemeExtension<dynamic>> _themeExtensionIterableToMap(
    Iterable<ThemeExtension<dynamic>> extensionsIterable,
  ) => Map<Object, ThemeExtension<dynamic>>.unmodifiable(<Object, ThemeExtension<dynamic>>{
    // Strangely, the cast is necessary for tests to run.
    for (final ThemeExtension<dynamic> extension in extensionsIterable)
      extension.type: extension as ThemeExtension<ThemeExtension<dynamic>>,
  });

  static ThemeData lerp(ThemeData a, ThemeData b, double t) {
    if (identical(a, b)) {
      return a;
    }
    return ThemeData.raw(
      // For the sanity of the reader, make sure these properties are in the same
      // order in every place that they are separated by section comments (e.g.
      // GENERAL CONFIGURATION). Each section except for deprecations should be
      // alphabetical by symbol name.

      // GENERAL CONFIGURATION
      adaptationMap: t < 0.5 ? a.adaptationMap : b.adaptationMap,
      applyElevationOverlayColor: t < 0.5 ? a.applyElevationOverlayColor : b.applyElevationOverlayColor,
      cupertinoOverrideTheme: t < 0.5 ? a.cupertinoOverrideTheme : b.cupertinoOverrideTheme,
      extensions: _lerpThemeExtensions(a, b, t),
      inputDecorationTheme: t < 0.5 ? a.inputDecorationTheme : b.inputDecorationTheme,
      materialTapTargetSize: t < 0.5 ? a.materialTapTargetSize : b.materialTapTargetSize,
      pageTransitionsTheme: t < 0.5 ? a.pageTransitionsTheme : b.pageTransitionsTheme,
      platform: t < 0.5 ? a.platform : b.platform,
      scrollbarTheme: ScrollbarThemeData.lerp(a.scrollbarTheme, b.scrollbarTheme, t),
      splashFactory: t < 0.5 ? a.splashFactory : b.splashFactory,
      visualDensity: VisualDensity.lerp(a.visualDensity, b.visualDensity, t),
      // COLOR
      canvasColor: Color.lerp(a.canvasColor, b.canvasColor, t)!,
      cardColor: Color.lerp(a.cardColor, b.cardColor, t)!,
      colorScheme: ColorScheme.lerp(a.colorScheme, b.colorScheme, t),
      disabledColor: Color.lerp(a.disabledColor, b.disabledColor, t)!,
      dividerColor: Color.lerp(a.dividerColor, b.dividerColor, t)!,
      focusColor: Color.lerp(a.focusColor, b.focusColor, t)!,
      highlightColor: Color.lerp(a.highlightColor, b.highlightColor, t)!,
      hintColor: Color.lerp(a.hintColor, b.hintColor, t)!,
      hoverColor: Color.lerp(a.hoverColor, b.hoverColor, t)!,
      primaryColor: Color.lerp(a.primaryColor, b.primaryColor, t)!,
      primaryColorDark: Color.lerp(a.primaryColorDark, b.primaryColorDark, t)!,
      primaryColorLight: Color.lerp(a.primaryColorLight, b.primaryColorLight, t)!,
      scaffoldBackgroundColor: Color.lerp(a.scaffoldBackgroundColor, b.scaffoldBackgroundColor, t)!,
      secondaryHeaderColor: Color.lerp(a.secondaryHeaderColor, b.secondaryHeaderColor, t)!,
      shadowColor: Color.lerp(a.shadowColor, b.shadowColor, t)!,
      splashColor: Color.lerp(a.splashColor, b.splashColor, t)!,
      unselectedWidgetColor: Color.lerp(a.unselectedWidgetColor, b.unselectedWidgetColor, t)!,
      // TYPOGRAPHY & ICONOGRAPHY
      iconTheme: IconThemeData.lerp(a.iconTheme, b.iconTheme, t),
      primaryIconTheme: IconThemeData.lerp(a.primaryIconTheme, b.primaryIconTheme, t),
      primaryTextTheme: TextTheme.lerp(a.primaryTextTheme, b.primaryTextTheme, t),
      textTheme: TextTheme.lerp(a.textTheme, b.textTheme, t),
      typography: Typography.lerp(a.typography, b.typography, t),
      // COMPONENT THEMES
      actionIconTheme: ActionIconThemeData.lerp(a.actionIconTheme, b.actionIconTheme, t),
      appBarTheme: AppBarTheme.lerp(a.appBarTheme, b.appBarTheme, t),
      badgeTheme: BadgeThemeData.lerp(a.badgeTheme, b.badgeTheme, t),
      bannerTheme: MaterialBannerThemeData.lerp(a.bannerTheme, b.bannerTheme, t),
      bottomAppBarTheme: BottomAppBarTheme.lerp(a.bottomAppBarTheme, b.bottomAppBarTheme, t),
      bottomNavigationBarTheme: BottomNavigationBarThemeData.lerp(
        a.bottomNavigationBarTheme,
        b.bottomNavigationBarTheme,
        t,
      ),
      bottomSheetTheme: BottomSheetThemeData.lerp(a.bottomSheetTheme, b.bottomSheetTheme, t)!,
      buttonTheme: t < 0.5 ? a.buttonTheme : b.buttonTheme,
      cardTheme: CardThemeData.lerp(a.cardTheme, b.cardTheme, t),
      checkboxTheme: CheckboxThemeData.lerp(a.checkboxTheme, b.checkboxTheme, t),
      chipTheme: ChipThemeData.lerp(a.chipTheme, b.chipTheme, t)!,
      dataTableTheme: DataTableThemeData.lerp(a.dataTableTheme, b.dataTableTheme, t),
      datePickerTheme: DatePickerThemeData.lerp(a.datePickerTheme, b.datePickerTheme, t),
      dialogTheme: DialogThemeData.lerp(a.dialogTheme, b.dialogTheme, t),
      dividerTheme: DividerThemeData.lerp(a.dividerTheme, b.dividerTheme, t),
      drawerTheme: DrawerThemeData.lerp(a.drawerTheme, b.drawerTheme, t)!,
      dropdownMenuTheme: DropdownMenuThemeData.lerp(a.dropdownMenuTheme, b.dropdownMenuTheme, t),
      elevatedButtonTheme: ElevatedButtonThemeData.lerp(a.elevatedButtonTheme, b.elevatedButtonTheme, t)!,
      expansionTileTheme: ExpansionTileThemeData.lerp(a.expansionTileTheme, b.expansionTileTheme, t)!,
      filledButtonTheme: FilledButtonThemeData.lerp(a.filledButtonTheme, b.filledButtonTheme, t)!,
      floatingActionButtonTheme:
          FloatingActionButtonThemeData.lerp(a.floatingActionButtonTheme, b.floatingActionButtonTheme, t)!,
      iconButtonTheme: IconButtonThemeData.lerp(a.iconButtonTheme, b.iconButtonTheme, t)!,
      listTileTheme: ListTileThemeData.lerp(a.listTileTheme, b.listTileTheme, t)!,
      menuBarTheme: MenuBarThemeData.lerp(a.menuBarTheme, b.menuBarTheme, t)!,
      menuButtonTheme: MenuButtonThemeData.lerp(a.menuButtonTheme, b.menuButtonTheme, t)!,
      menuTheme: MenuThemeData.lerp(a.menuTheme, b.menuTheme, t)!,
      navigationBarTheme: NavigationBarThemeData.lerp(a.navigationBarTheme, b.navigationBarTheme, t)!,
      navigationDrawerTheme: NavigationDrawerThemeData.lerp(a.navigationDrawerTheme, b.navigationDrawerTheme, t)!,
      navigationRailTheme: NavigationRailThemeData.lerp(a.navigationRailTheme, b.navigationRailTheme, t)!,
      outlinedButtonTheme: OutlinedButtonThemeData.lerp(a.outlinedButtonTheme, b.outlinedButtonTheme, t)!,
      popupMenuTheme: PopupMenuThemeData.lerp(a.popupMenuTheme, b.popupMenuTheme, t)!,
      progressIndicatorTheme: ProgressIndicatorThemeData.lerp(a.progressIndicatorTheme, b.progressIndicatorTheme, t)!,
      radioTheme: RadioThemeData.lerp(a.radioTheme, b.radioTheme, t),
      searchBarTheme: SearchBarThemeData.lerp(a.searchBarTheme, b.searchBarTheme, t)!,
      searchViewTheme: SearchViewThemeData.lerp(a.searchViewTheme, b.searchViewTheme, t)!,
      segmentedButtonTheme: SegmentedButtonThemeData.lerp(a.segmentedButtonTheme, b.segmentedButtonTheme, t),
      sliderTheme: SliderThemeData.lerp(a.sliderTheme, b.sliderTheme, t),
      snackBarTheme: SnackBarThemeData.lerp(a.snackBarTheme, b.snackBarTheme, t),
      switchTheme: SwitchThemeData.lerp(a.switchTheme, b.switchTheme, t),
      tabBarTheme: TabBarThemeData.lerp(a.tabBarTheme, b.tabBarTheme, t),
      textButtonTheme: TextButtonThemeData.lerp(a.textButtonTheme, b.textButtonTheme, t)!,
      textSelectionTheme: TextSelectionThemeData.lerp(a.textSelectionTheme, b.textSelectionTheme, t)!,
      timePickerTheme: TimePickerThemeData.lerp(a.timePickerTheme, b.timePickerTheme, t),
      toggleButtonsTheme: ToggleButtonsThemeData.lerp(a.toggleButtonsTheme, b.toggleButtonsTheme, t)!,
      tooltipTheme: TooltipThemeData.lerp(a.tooltipTheme, b.tooltipTheme, t)!,
      // DEPRECATED (newest deprecations at the bottom)
      buttonBarTheme: ButtonBarThemeData.lerp(a.buttonBarTheme, b.buttonBarTheme, t),
      dialogBackgroundColor: Color.lerp(a.dialogBackgroundColor, b.dialogBackgroundColor, t)!,
      indicatorColor: Color.lerp(a.indicatorColor, b.indicatorColor, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is ThemeData &&
        // For the sanity of the reader, make sure these properties are in the same
        // order in every place that they are separated by section comments (e.g.
        // GENERAL CONFIGURATION). Each section except for deprecations should be
        // alphabetical by symbol name.
        // GENERAL CONFIGURATION
        mapEquals(other.adaptationMap, adaptationMap) &&
        other.applyElevationOverlayColor == applyElevationOverlayColor &&
        other.cupertinoOverrideTheme == cupertinoOverrideTheme &&
        mapEquals(other.extensions, extensions) &&
        other.inputDecorationTheme == inputDecorationTheme &&
        other.materialTapTargetSize == materialTapTargetSize &&
        other.pageTransitionsTheme == pageTransitionsTheme &&
        other.platform == platform &&
        other.scrollbarTheme == scrollbarTheme &&
        other.splashFactory == splashFactory &&
        other.visualDensity == visualDensity &&
        // COLOR
        other.canvasColor == canvasColor &&
        other.cardColor == cardColor &&
        other.colorScheme == colorScheme &&
        other.disabledColor == disabledColor &&
        other.dividerColor == dividerColor &&
        other.focusColor == focusColor &&
        other.highlightColor == highlightColor &&
        other.hintColor == hintColor &&
        other.hoverColor == hoverColor &&
        other.primaryColor == primaryColor &&
        other.primaryColorDark == primaryColorDark &&
        other.primaryColorLight == primaryColorLight &&
        other.scaffoldBackgroundColor == scaffoldBackgroundColor &&
        other.secondaryHeaderColor == secondaryHeaderColor &&
        other.shadowColor == shadowColor &&
        other.splashColor == splashColor &&
        other.unselectedWidgetColor == unselectedWidgetColor &&
        // TYPOGRAPHY & ICONOGRAPHY
        other.iconTheme == iconTheme &&
        other.primaryIconTheme == primaryIconTheme &&
        other.primaryTextTheme == primaryTextTheme &&
        other.textTheme == textTheme &&
        other.typography == typography &&
        // COMPONENT THEMES
        other.actionIconTheme == actionIconTheme &&
        other.appBarTheme == appBarTheme &&
        other.badgeTheme == badgeTheme &&
        other.bannerTheme == bannerTheme &&
        other.bottomAppBarTheme == bottomAppBarTheme &&
        other.bottomNavigationBarTheme == bottomNavigationBarTheme &&
        other.bottomSheetTheme == bottomSheetTheme &&
        other.buttonTheme == buttonTheme &&
        other.cardTheme == cardTheme &&
        other.checkboxTheme == checkboxTheme &&
        other.chipTheme == chipTheme &&
        other.dataTableTheme == dataTableTheme &&
        other.datePickerTheme == datePickerTheme &&
        other.dialogTheme == dialogTheme &&
        other.dividerTheme == dividerTheme &&
        other.drawerTheme == drawerTheme &&
        other.dropdownMenuTheme == dropdownMenuTheme &&
        other.elevatedButtonTheme == elevatedButtonTheme &&
        other.expansionTileTheme == expansionTileTheme &&
        other.filledButtonTheme == filledButtonTheme &&
        other.floatingActionButtonTheme == floatingActionButtonTheme &&
        other.iconButtonTheme == iconButtonTheme &&
        other.listTileTheme == listTileTheme &&
        other.menuBarTheme == menuBarTheme &&
        other.menuButtonTheme == menuButtonTheme &&
        other.menuTheme == menuTheme &&
        other.navigationBarTheme == navigationBarTheme &&
        other.navigationDrawerTheme == navigationDrawerTheme &&
        other.navigationRailTheme == navigationRailTheme &&
        other.outlinedButtonTheme == outlinedButtonTheme &&
        other.popupMenuTheme == popupMenuTheme &&
        other.progressIndicatorTheme == progressIndicatorTheme &&
        other.radioTheme == radioTheme &&
        other.searchBarTheme == searchBarTheme &&
        other.searchViewTheme == searchViewTheme &&
        other.segmentedButtonTheme == segmentedButtonTheme &&
        other.sliderTheme == sliderTheme &&
        other.snackBarTheme == snackBarTheme &&
        other.switchTheme == switchTheme &&
        other.tabBarTheme == tabBarTheme &&
        other.textButtonTheme == textButtonTheme &&
        other.textSelectionTheme == textSelectionTheme &&
        other.timePickerTheme == timePickerTheme &&
        other.toggleButtonsTheme == toggleButtonsTheme &&
        other.tooltipTheme == tooltipTheme &&
        // DEPRECATED (newest deprecations at the bottom)
        other.buttonBarTheme == buttonBarTheme &&
        other.dialogBackgroundColor == dialogBackgroundColor &&
        other.indicatorColor == indicatorColor;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      // For the sanity of the reader, make sure these properties are in the same
      // order in every place that they are separated by section comments (e.g.
      // GENERAL CONFIGURATION). Each section except for deprecations should be
      // alphabetical by symbol name.

      // GENERAL CONFIGURATION
      ...adaptationMap.keys,
      ...adaptationMap.values,
      applyElevationOverlayColor,
      cupertinoOverrideTheme,
      ...extensions.keys,
      ...extensions.values,
      inputDecorationTheme,
      materialTapTargetSize,
      pageTransitionsTheme,
      platform,
      scrollbarTheme,
      splashFactory,
      visualDensity,
      // COLOR
      canvasColor,
      cardColor,
      colorScheme,
      disabledColor,
      dividerColor,
      focusColor,
      highlightColor,
      hintColor,
      hoverColor,
      primaryColor,
      primaryColorDark,
      primaryColorLight,
      scaffoldBackgroundColor,
      secondaryHeaderColor,
      shadowColor,
      splashColor,
      unselectedWidgetColor,
      // TYPOGRAPHY & ICONOGRAPHY
      iconTheme,
      primaryIconTheme,
      primaryTextTheme,
      textTheme,
      typography,
      // COMPONENT THEMES
      actionIconTheme,
      appBarTheme,
      badgeTheme,
      bannerTheme,
      bottomAppBarTheme,
      bottomNavigationBarTheme,
      bottomSheetTheme,
      buttonTheme,
      cardTheme,
      checkboxTheme,
      chipTheme,
      dataTableTheme,
      datePickerTheme,
      dialogTheme,
      dividerTheme,
      drawerTheme,
      dropdownMenuTheme,
      elevatedButtonTheme,
      expansionTileTheme,
      filledButtonTheme,
      floatingActionButtonTheme,
      iconButtonTheme,
      listTileTheme,
      menuBarTheme,
      menuButtonTheme,
      menuTheme,
      navigationBarTheme,
      navigationDrawerTheme,
      navigationRailTheme,
      outlinedButtonTheme,
      popupMenuTheme,
      progressIndicatorTheme,
      radioTheme,
      searchBarTheme,
      searchViewTheme,
      segmentedButtonTheme,
      sliderTheme,
      snackBarTheme,
      switchTheme,
      tabBarTheme,
      textButtonTheme,
      textSelectionTheme,
      timePickerTheme,
      toggleButtonsTheme,
      tooltipTheme,
      // DEPRECATED (newest deprecations at the bottom)
      buttonBarTheme,
      dialogBackgroundColor,
      indicatorColor,
    ];
    return Object.hashAll(values);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    final ThemeData defaultData = ThemeData.fallback();
    // For the sanity of the reader, make sure these properties are in the same
    // order in every place that they are separated by section comments (e.g.
    // GENERAL CONFIGURATION). Each section except for deprecations should be
    // alphabetical by symbol name.

    // GENERAL CONFIGURATION
    properties
      ..add(
        IterableProperty<Adaptation<dynamic>>(
          'adaptations',
          adaptationMap.values,
          defaultValue: defaultData.adaptationMap.values,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        DiagnosticsProperty<bool>(
          'applyElevationOverlayColor',
          applyElevationOverlayColor,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        DiagnosticsProperty<NoDefaultCupertinoThemeData>(
          'cupertinoOverrideTheme',
          cupertinoOverrideTheme,
          defaultValue: defaultData.cupertinoOverrideTheme,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        IterableProperty<ThemeExtension<dynamic>>(
          'extensions',
          extensions.values,
          defaultValue: defaultData.extensions.values,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        DiagnosticsProperty<InputDecorationTheme>(
          'inputDecorationTheme',
          inputDecorationTheme,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        DiagnosticsProperty<MaterialTapTargetSize>(
          'materialTapTargetSize',
          materialTapTargetSize,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        DiagnosticsProperty<PageTransitionsTheme>(
          'pageTransitionsTheme',
          pageTransitionsTheme,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        EnumProperty<TargetPlatform>(
          'platform',
          platform,
          defaultValue: defaultTargetPlatform,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        DiagnosticsProperty<ScrollbarThemeData>(
          'scrollbarTheme',
          scrollbarTheme,
          defaultValue: defaultData.scrollbarTheme,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        DiagnosticsProperty<InteractiveInkFeatureFactory>(
          'splashFactory',
          splashFactory,
          defaultValue: defaultData.splashFactory,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        DiagnosticsProperty<VisualDensity>(
          'visualDensity',
          visualDensity,
          defaultValue: defaultData.visualDensity,
          level: DiagnosticLevel.debug,
        ),
      )
      // COLORS
      ..add(
        ColorProperty('canvasColor', canvasColor, defaultValue: defaultData.canvasColor, level: DiagnosticLevel.debug),
      )
      ..add(ColorProperty('cardColor', cardColor, defaultValue: defaultData.cardColor, level: DiagnosticLevel.debug))
      ..add(
        DiagnosticsProperty<ColorScheme>(
          'colorScheme',
          colorScheme,
          defaultValue: defaultData.colorScheme,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        ColorProperty(
          'disabledColor',
          disabledColor,
          defaultValue: defaultData.disabledColor,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        ColorProperty(
          'dividerColor',
          dividerColor,
          defaultValue: defaultData.dividerColor,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(ColorProperty('focusColor', focusColor, defaultValue: defaultData.focusColor, level: DiagnosticLevel.debug))
      ..add(
        ColorProperty(
          'highlightColor',
          highlightColor,
          defaultValue: defaultData.highlightColor,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(ColorProperty('hintColor', hintColor, defaultValue: defaultData.hintColor, level: DiagnosticLevel.debug))
      ..add(ColorProperty('hoverColor', hoverColor, defaultValue: defaultData.hoverColor, level: DiagnosticLevel.debug))
      ..add(
        ColorProperty(
          'primaryColorDark',
          primaryColorDark,
          defaultValue: defaultData.primaryColorDark,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        ColorProperty(
          'primaryColorLight',
          primaryColorLight,
          defaultValue: defaultData.primaryColorLight,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        ColorProperty(
          'primaryColor',
          primaryColor,
          defaultValue: defaultData.primaryColor,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        ColorProperty(
          'scaffoldBackgroundColor',
          scaffoldBackgroundColor,
          defaultValue: defaultData.scaffoldBackgroundColor,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        ColorProperty(
          'secondaryHeaderColor',
          secondaryHeaderColor,
          defaultValue: defaultData.secondaryHeaderColor,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        ColorProperty('shadowColor', shadowColor, defaultValue: defaultData.shadowColor, level: DiagnosticLevel.debug),
      )
      ..add(
        ColorProperty('splashColor', splashColor, defaultValue: defaultData.splashColor, level: DiagnosticLevel.debug),
      )
      ..add(
        ColorProperty(
          'unselectedWidgetColor',
          unselectedWidgetColor,
          defaultValue: defaultData.unselectedWidgetColor,
          level: DiagnosticLevel.debug,
        ),
      )
      // TYPOGRAPHY & ICONOGRAPHY
      ..add(DiagnosticsProperty<IconThemeData>('iconTheme', iconTheme, level: DiagnosticLevel.debug))
      ..add(DiagnosticsProperty<IconThemeData>('primaryIconTheme', primaryIconTheme, level: DiagnosticLevel.debug))
      ..add(DiagnosticsProperty<TextTheme>('primaryTextTheme', primaryTextTheme, level: DiagnosticLevel.debug))
      ..add(DiagnosticsProperty<TextTheme>('textTheme', textTheme, level: DiagnosticLevel.debug))
      ..add(
        DiagnosticsProperty<Typography>(
          'typography',
          typography,
          defaultValue: defaultData.typography,
          level: DiagnosticLevel.debug,
        ),
      )
      // COMPONENT THEMES
      ..add(DiagnosticsProperty<ActionIconThemeData>('actionIconTheme', actionIconTheme, level: DiagnosticLevel.debug))
      ..add(
        DiagnosticsProperty<AppBarTheme>(
          'appBarTheme',
          appBarTheme,
          defaultValue: defaultData.appBarTheme,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        DiagnosticsProperty<BadgeThemeData>(
          'badgeTheme',
          badgeTheme,
          defaultValue: defaultData.badgeTheme,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        DiagnosticsProperty<MaterialBannerThemeData>(
          'bannerTheme',
          bannerTheme,
          defaultValue: defaultData.bannerTheme,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        DiagnosticsProperty<BottomAppBarTheme>(
          'bottomAppBarTheme',
          bottomAppBarTheme,
          defaultValue: defaultData.bottomAppBarTheme,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        DiagnosticsProperty<BottomNavigationBarThemeData>(
          'bottomNavigationBarTheme',
          bottomNavigationBarTheme,
          defaultValue: defaultData.bottomNavigationBarTheme,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        DiagnosticsProperty<BottomSheetThemeData>(
          'bottomSheetTheme',
          bottomSheetTheme,
          defaultValue: defaultData.bottomSheetTheme,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(DiagnosticsProperty<ButtonThemeData>('buttonTheme', buttonTheme, level: DiagnosticLevel.debug))
      ..add(DiagnosticsProperty<CardThemeData>('cardTheme', cardTheme, level: DiagnosticLevel.debug))
      ..add(
        DiagnosticsProperty<CheckboxThemeData>(
          'checkboxTheme',
          checkboxTheme,
          defaultValue: defaultData.checkboxTheme,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(DiagnosticsProperty<ChipThemeData>('chipTheme', chipTheme, level: DiagnosticLevel.debug))
      ..add(
        DiagnosticsProperty<DataTableThemeData>(
          'dataTableTheme',
          dataTableTheme,
          defaultValue: defaultData.dataTableTheme,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        DiagnosticsProperty<DatePickerThemeData>(
          'datePickerTheme',
          datePickerTheme,
          defaultValue: defaultData.datePickerTheme,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        DiagnosticsProperty<DialogThemeData>(
          'dialogTheme',
          dialogTheme,
          defaultValue: defaultData.dialogTheme,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        DiagnosticsProperty<DividerThemeData>(
          'dividerTheme',
          dividerTheme,
          defaultValue: defaultData.dividerTheme,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        DiagnosticsProperty<DrawerThemeData>(
          'drawerTheme',
          drawerTheme,
          defaultValue: defaultData.drawerTheme,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        DiagnosticsProperty<DropdownMenuThemeData>(
          'dropdownMenuTheme',
          dropdownMenuTheme,
          defaultValue: defaultData.dropdownMenuTheme,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        DiagnosticsProperty<ElevatedButtonThemeData>(
          'elevatedButtonTheme',
          elevatedButtonTheme,
          defaultValue: defaultData.elevatedButtonTheme,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        DiagnosticsProperty<ExpansionTileThemeData>(
          'expansionTileTheme',
          expansionTileTheme,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        DiagnosticsProperty<FilledButtonThemeData>(
          'filledButtonTheme',
          filledButtonTheme,
          defaultValue: defaultData.filledButtonTheme,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        DiagnosticsProperty<FloatingActionButtonThemeData>(
          'floatingActionButtonTheme',
          floatingActionButtonTheme,
          defaultValue: defaultData.floatingActionButtonTheme,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        DiagnosticsProperty<IconButtonThemeData>(
          'iconButtonTheme',
          iconButtonTheme,
          defaultValue: defaultData.iconButtonTheme,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        DiagnosticsProperty<ListTileThemeData>(
          'listTileTheme',
          listTileTheme,
          defaultValue: defaultData.listTileTheme,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        DiagnosticsProperty<MenuBarThemeData>(
          'menuBarTheme',
          menuBarTheme,
          defaultValue: defaultData.menuBarTheme,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        DiagnosticsProperty<MenuButtonThemeData>(
          'menuButtonTheme',
          menuButtonTheme,
          defaultValue: defaultData.menuButtonTheme,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        DiagnosticsProperty<MenuThemeData>(
          'menuTheme',
          menuTheme,
          defaultValue: defaultData.menuTheme,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        DiagnosticsProperty<NavigationBarThemeData>(
          'navigationBarTheme',
          navigationBarTheme,
          defaultValue: defaultData.navigationBarTheme,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        DiagnosticsProperty<NavigationDrawerThemeData>(
          'navigationDrawerTheme',
          navigationDrawerTheme,
          defaultValue: defaultData.navigationDrawerTheme,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        DiagnosticsProperty<NavigationRailThemeData>(
          'navigationRailTheme',
          navigationRailTheme,
          defaultValue: defaultData.navigationRailTheme,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        DiagnosticsProperty<OutlinedButtonThemeData>(
          'outlinedButtonTheme',
          outlinedButtonTheme,
          defaultValue: defaultData.outlinedButtonTheme,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        DiagnosticsProperty<PopupMenuThemeData>(
          'popupMenuTheme',
          popupMenuTheme,
          defaultValue: defaultData.popupMenuTheme,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        DiagnosticsProperty<ProgressIndicatorThemeData>(
          'progressIndicatorTheme',
          progressIndicatorTheme,
          defaultValue: defaultData.progressIndicatorTheme,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        DiagnosticsProperty<RadioThemeData>(
          'radioTheme',
          radioTheme,
          defaultValue: defaultData.radioTheme,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        DiagnosticsProperty<SearchBarThemeData>(
          'searchBarTheme',
          searchBarTheme,
          defaultValue: defaultData.searchBarTheme,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        DiagnosticsProperty<SearchViewThemeData>(
          'searchViewTheme',
          searchViewTheme,
          defaultValue: defaultData.searchViewTheme,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        DiagnosticsProperty<SegmentedButtonThemeData>(
          'segmentedButtonTheme',
          segmentedButtonTheme,
          defaultValue: defaultData.segmentedButtonTheme,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(DiagnosticsProperty<SliderThemeData>('sliderTheme', sliderTheme, level: DiagnosticLevel.debug))
      ..add(
        DiagnosticsProperty<SnackBarThemeData>(
          'snackBarTheme',
          snackBarTheme,
          defaultValue: defaultData.snackBarTheme,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        DiagnosticsProperty<SwitchThemeData>(
          'switchTheme',
          switchTheme,
          defaultValue: defaultData.switchTheme,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(DiagnosticsProperty<TabBarThemeData>('tabBarTheme', tabBarTheme, level: DiagnosticLevel.debug))
      ..add(
        DiagnosticsProperty<TextButtonThemeData>(
          'textButtonTheme',
          textButtonTheme,
          defaultValue: defaultData.textButtonTheme,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        DiagnosticsProperty<TextSelectionThemeData>(
          'textSelectionTheme',
          textSelectionTheme,
          defaultValue: defaultData.textSelectionTheme,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        DiagnosticsProperty<TimePickerThemeData>(
          'timePickerTheme',
          timePickerTheme,
          defaultValue: defaultData.timePickerTheme,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        DiagnosticsProperty<ToggleButtonsThemeData>(
          'toggleButtonsTheme',
          toggleButtonsTheme,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(DiagnosticsProperty<TooltipThemeData>('tooltipTheme', tooltipTheme, level: DiagnosticLevel.debug))
      // DEPRECATED (newest deprecations at the bottom)
      ..add(
        DiagnosticsProperty<ButtonBarThemeData>(
          'buttonBarTheme',
          buttonBarTheme,
          defaultValue: defaultData.buttonBarTheme,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        ColorProperty(
          'dialogBackgroundColor',
          dialogBackgroundColor,
          defaultValue: defaultData.dialogBackgroundColor,
          level: DiagnosticLevel.debug,
        ),
      )
      ..add(
        ColorProperty(
          'indicatorColor',
          indicatorColor,
          defaultValue: defaultData.indicatorColor,
          level: DiagnosticLevel.debug,
        ),
      );
    properties.add(EnumProperty<Brightness>('brightness', brightness));
  }
}

// This class subclasses CupertinoThemeData rather than composes one because it
// _is_ a CupertinoThemeData with partially altered behavior. e.g. its textTheme
// is from the superclass and based on the primaryColor but the primaryColor
// comes from the Material theme unless overridden.
class MaterialBasedCupertinoThemeData extends CupertinoThemeData {
  MaterialBasedCupertinoThemeData({required ThemeData materialTheme})
    : this._(materialTheme, (materialTheme.cupertinoOverrideTheme ?? const CupertinoThemeData()).noDefault());

  MaterialBasedCupertinoThemeData._(this._materialTheme, this._cupertinoOverrideTheme)
    : // Pass all values to the superclass so Material-agnostic properties
      // like barBackgroundColor can still behave like a normal
      // CupertinoThemeData.
      super.raw(
        _cupertinoOverrideTheme.brightness,
        _cupertinoOverrideTheme.primaryColor,
        _cupertinoOverrideTheme.primaryContrastingColor,
        _cupertinoOverrideTheme.textTheme,
        _cupertinoOverrideTheme.barBackgroundColor,
        _cupertinoOverrideTheme.scaffoldBackgroundColor,
        _cupertinoOverrideTheme.applyThemeToAll,
      );

  final ThemeData _materialTheme;
  final NoDefaultCupertinoThemeData _cupertinoOverrideTheme;

  @override
  Brightness get brightness => _cupertinoOverrideTheme.brightness ?? _materialTheme.brightness;

  @override
  Color get primaryColor => _cupertinoOverrideTheme.primaryColor ?? _materialTheme.colorScheme.primary;

  @override
  Color get primaryContrastingColor =>
      _cupertinoOverrideTheme.primaryContrastingColor ?? _materialTheme.colorScheme.onPrimary;

  @override
  Color get scaffoldBackgroundColor =>
      _cupertinoOverrideTheme.scaffoldBackgroundColor ?? _materialTheme.scaffoldBackgroundColor;

  @override
  MaterialBasedCupertinoThemeData copyWith({
    Brightness? brightness,
    Color? primaryColor,
    Color? primaryContrastingColor,
    CupertinoTextThemeData? textTheme,
    Color? barBackgroundColor,
    Color? scaffoldBackgroundColor,
    bool? applyThemeToAll,
  }) => MaterialBasedCupertinoThemeData._(
    _materialTheme,
    _cupertinoOverrideTheme.copyWith(
      brightness: brightness,
      primaryColor: primaryColor,
      primaryContrastingColor: primaryContrastingColor,
      textTheme: textTheme,
      barBackgroundColor: barBackgroundColor,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      applyThemeToAll: applyThemeToAll,
    ),
  );

  @override
  CupertinoThemeData resolveFrom(BuildContext context) {
    // Only the cupertino override theme part will be resolved.
    // If the color comes from the material theme it's not resolved.
    return MaterialBasedCupertinoThemeData._(_materialTheme, _cupertinoOverrideTheme.resolveFrom(context));
  }
}

class CupertinoBasedMaterialThemeData {
  CupertinoBasedMaterialThemeData({required CupertinoThemeData themeData})
    : materialTheme = ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: themeData.primaryColor,
          brightness: themeData.brightness ?? Brightness.light,
          primary: themeData.primaryColor,
          onPrimary: themeData.primaryContrastingColor,
        ),
      );

  final ThemeData materialTheme;
}

@immutable
class _IdentityThemeDataCacheKey {
  const _IdentityThemeDataCacheKey(this.baseTheme, this.localTextGeometry);

  final ThemeData baseTheme;
  final TextTheme localTextGeometry;

  // Using XOR to make the hash function as fast as possible (e.g. Jenkins is
  // noticeably slower).
  @override
  int get hashCode => identityHashCode(baseTheme) ^ identityHashCode(localTextGeometry);

  @override
  bool operator ==(Object other) {
    // We are explicitly ignoring the possibility that the types might not
    // match in the interests of speed.
    return other is _IdentityThemeDataCacheKey &&
        identical(other.baseTheme, baseTheme) &&
        identical(other.localTextGeometry, localTextGeometry);
  }
}

class _FifoCache<K, V> {
  _FifoCache(this._maximumSize) : assert(_maximumSize > 0);

  final Map<K, V> _cache = <K, V>{};

  final int _maximumSize;

  V putIfAbsent(K key, V Function() loader) {
    assert(key != null);
    final V? result = _cache[key];
    if (result != null) {
      return result;
    }
    if (_cache.length == _maximumSize) {
      _cache.remove(_cache.keys.first);
    }
    return _cache[key] = loader();
  }
}

@immutable
class VisualDensity with Diagnosticable {
  const VisualDensity({this.horizontal = 0.0, this.vertical = 0.0})
    : assert(vertical <= maximumDensity),
      assert(vertical >= minimumDensity),
      assert(horizontal <= maximumDensity),
      assert(horizontal >= minimumDensity);

  static const double minimumDensity = -4.0;

  static const double maximumDensity = 4.0;

  static const VisualDensity standard = VisualDensity();

  static const VisualDensity comfortable = VisualDensity(horizontal: -1.0, vertical: -1.0);

  static const VisualDensity compact = VisualDensity(horizontal: -2.0, vertical: -2.0);

  static VisualDensity get adaptivePlatformDensity => defaultDensityForPlatform(defaultTargetPlatform);

  static VisualDensity defaultDensityForPlatform(TargetPlatform platform) => switch (platform) {
    TargetPlatform.android || TargetPlatform.iOS || TargetPlatform.fuchsia => standard,
    TargetPlatform.linux || TargetPlatform.macOS || TargetPlatform.windows => compact,
  };

  VisualDensity copyWith({double? horizontal, double? vertical}) =>
      VisualDensity(horizontal: horizontal ?? this.horizontal, vertical: vertical ?? this.vertical);

  final double horizontal;

  final double vertical;

  Offset get baseSizeAdjustment {
    // The number of logical pixels represented by an increase or decrease in
    // density by one. The Material Design guidelines say to increment/decrement
    // sizes in terms of four pixel increments.
    const double interval = 4.0;

    return Offset(horizontal, vertical) * interval;
  }

  static VisualDensity lerp(VisualDensity a, VisualDensity b, double t) {
    if (identical(a, b)) {
      return a;
    }
    return VisualDensity(
      horizontal: lerpDouble(a.horizontal, b.horizontal, t)!,
      vertical: lerpDouble(a.vertical, b.vertical, t)!,
    );
  }

  BoxConstraints effectiveConstraints(BoxConstraints constraints) {
    assert(constraints.debugAssertIsValid());
    return constraints.copyWith(
      minWidth: clampDouble(constraints.minWidth + baseSizeAdjustment.dx, 0.0, constraints.maxWidth),
      minHeight: clampDouble(constraints.minHeight + baseSizeAdjustment.dy, 0.0, constraints.maxHeight),
    );
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is VisualDensity && other.horizontal == horizontal && other.vertical == vertical;
  }

  @override
  int get hashCode => Object.hash(horizontal, vertical);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('horizontal', horizontal, defaultValue: 0.0));
    properties.add(DoubleProperty('vertical', vertical, defaultValue: 0.0));
    properties.add(DiagnosticsProperty<Offset>('baseSizeAdjustment', baseSizeAdjustment));
  }

  @override
  String toStringShort() =>
      '${super.toStringShort()}(h: ${debugFormatDouble(horizontal)}, v: ${debugFormatDouble(vertical)})';
}

// BEGIN GENERATED TOKEN PROPERTIES - ColorScheme

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// dart format off
const ColorScheme _colorSchemeLightM3 = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF6750A4),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFEADDFF),
  onPrimaryContainer: Color(0xFF4F378B),
  primaryFixed: Color(0xFFEADDFF),
  primaryFixedDim: Color(0xFFD0BCFF),
  onPrimaryFixed: Color(0xFF21005D),
  onPrimaryFixedVariant: Color(0xFF4F378B),
  secondary: Color(0xFF625B71),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFE8DEF8),
  onSecondaryContainer: Color(0xFF4A4458),
  secondaryFixed: Color(0xFFE8DEF8),
  secondaryFixedDim: Color(0xFFCCC2DC),
  onSecondaryFixed: Color(0xFF1D192B),
  onSecondaryFixedVariant: Color(0xFF4A4458),
  tertiary: Color(0xFF7D5260),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFFFD8E4),
  onTertiaryContainer: Color(0xFF633B48),
  tertiaryFixed: Color(0xFFFFD8E4),
  tertiaryFixedDim: Color(0xFFEFB8C8),
  onTertiaryFixed: Color(0xFF31111D),
  onTertiaryFixedVariant: Color(0xFF633B48),
  error: Color(0xFFB3261E),
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFF9DEDC),
  onErrorContainer: Color(0xFF8C1D18),
  background: Color(0xFFFEF7FF),
  onBackground: Color(0xFF1D1B20),
  surface: Color(0xFFFEF7FF),
  surfaceBright: Color(0xFFFEF7FF),
  surfaceContainerLowest: Color(0xFFFFFFFF),
  surfaceContainerLow: Color(0xFFF7F2FA),
  surfaceContainer: Color(0xFFF3EDF7),
  surfaceContainerHigh: Color(0xFFECE6F0),
  surfaceContainerHighest: Color(0xFFE6E0E9),
  surfaceDim: Color(0xFFDED8E1),
  onSurface: Color(0xFF1D1B20),
  surfaceVariant: Color(0xFFE7E0EC),
  onSurfaceVariant: Color(0xFF49454F),
  outline: Color(0xFF79747E),
  outlineVariant: Color(0xFFCAC4D0),
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFF322F35),
  onInverseSurface: Color(0xFFF5EFF7),
  inversePrimary: Color(0xFFD0BCFF),
  // The surfaceTint color is set to the same color as the primary.
  surfaceTint: Color(0xFF6750A4),
);

const ColorScheme _colorSchemeDarkM3 = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFD0BCFF),
  onPrimary: Color(0xFF381E72),
  primaryContainer: Color(0xFF4F378B),
  onPrimaryContainer: Color(0xFFEADDFF),
  primaryFixed: Color(0xFFEADDFF),
  primaryFixedDim: Color(0xFFD0BCFF),
  onPrimaryFixed: Color(0xFF21005D),
  onPrimaryFixedVariant: Color(0xFF4F378B),
  secondary: Color(0xFFCCC2DC),
  onSecondary: Color(0xFF332D41),
  secondaryContainer: Color(0xFF4A4458),
  onSecondaryContainer: Color(0xFFE8DEF8),
  secondaryFixed: Color(0xFFE8DEF8),
  secondaryFixedDim: Color(0xFFCCC2DC),
  onSecondaryFixed: Color(0xFF1D192B),
  onSecondaryFixedVariant: Color(0xFF4A4458),
  tertiary: Color(0xFFEFB8C8),
  onTertiary: Color(0xFF492532),
  tertiaryContainer: Color(0xFF633B48),
  onTertiaryContainer: Color(0xFFFFD8E4),
  tertiaryFixed: Color(0xFFFFD8E4),
  tertiaryFixedDim: Color(0xFFEFB8C8),
  onTertiaryFixed: Color(0xFF31111D),
  onTertiaryFixedVariant: Color(0xFF633B48),
  error: Color(0xFFF2B8B5),
  onError: Color(0xFF601410),
  errorContainer: Color(0xFF8C1D18),
  onErrorContainer: Color(0xFFF9DEDC),
  background: Color(0xFF141218),
  onBackground: Color(0xFFE6E0E9),
  surface: Color(0xFF141218),
  surfaceBright: Color(0xFF3B383E),
  surfaceContainerLowest: Color(0xFF0F0D13),
  surfaceContainerLow: Color(0xFF1D1B20),
  surfaceContainer: Color(0xFF211F26),
  surfaceContainerHigh: Color(0xFF2B2930),
  surfaceContainerHighest: Color(0xFF36343B),
  surfaceDim: Color(0xFF141218),
  onSurface: Color(0xFFE6E0E9),
  surfaceVariant: Color(0xFF49454F),
  onSurfaceVariant: Color(0xFFCAC4D0),
  outline: Color(0xFF938F99),
  outlineVariant: Color(0xFF49454F),
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFFE6E0E9),
  onInverseSurface: Color(0xFF322F35),
  inversePrimary: Color(0xFF6750A4),
  // The surfaceTint color is set to the same color as the primary.
  surfaceTint: Color(0xFFD0BCFF),
);
// dart format on

// END GENERATED TOKEN PROPERTIES - ColorScheme
