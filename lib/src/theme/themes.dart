import 'package:flutter/material.dart';
import 'package:waveui/src/theme/colors.dart';
import 'package:waveui/src/theme/theme.dart';
import 'package:waveui/waveui.dart';

class WaveTheme {
  static WaveThemeData of(BuildContext context) {
    final waveThemeData = Theme.of(context).extension<WaveThemeData>();
    if (waveThemeData == null) {
      throw Exception('No WaveThemeData found in the current theme.');
    }
    return waveThemeData;
  }

  static ThemeData dynamicTheme({Color themeColor = const Color(0xFF1869DF), bool darkMode = false}) {
    var colorScheme = darkMode ? WaveColorScheme.dark() : WaveColorScheme.light();

    return _getDefaultThemeData(darkMode: darkMode).copyWith(
      extensions: [WaveThemeData(colorScheme: colorScheme.copyWith(primary: themeColor))],
      colorScheme: _colorScheme(darkMode: darkMode, themeColor: themeColor),
      dividerColor: WaveColors.dividerColor,
      cardColor: WaveColors.content(darkMode: darkMode),
      scaffoldBackgroundColor: WaveColors.background(darkMode: darkMode),
      appBarTheme: _appBarTheme(darkMode: darkMode),
      bottomNavigationBarTheme: _bottomNavigationBarTheme(),
      navigationBarTheme: _navigationBarTheme(darkMode: darkMode, themeColor: themeColor),
      dropdownMenuTheme: const DropdownMenuThemeData(),
      dividerTheme: _dividerTheme(),
      snackBarTheme: _snackBarThemeData(),
      outlinedButtonTheme: _outlinedButtonTheme(themeColor),
      timePickerTheme: _timePickerTheme(darkMode),
      datePickerTheme: _datePickerTheme(darkMode),
      floatingActionButtonTheme: _floatingActionButtonThemeData(),
      drawerTheme: _drawerTheme(darkMode),
      progressIndicatorTheme: _progressIndicatorTheme(themeColor),
      chipTheme: _chipTheme(),
      cardTheme: _cardTheme(darkMode),
      dialogTheme: _dialogTheme(darkMode),
      popupMenuTheme: _popupMenuThemeData(),
      inputDecorationTheme: _inputDecorationTheme(themeColor, darkMode),
      textTheme: WaveTextTheme(isDarkMode: darkMode),
      listTileTheme: _listTileThemeData(darkMode: darkMode),
      actionIconTheme: ActionIconThemeData(
        backButtonIconBuilder:
            (context) => IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(WaveIcons.chevron_left_24_filled),
            ),
      ),
    );
  }
}

/// ************ THEME CONFIGS ***************

ColorScheme _colorScheme({Color themeColor = Colors.deepPurple, bool darkMode = false}) =>
    darkMode
        ? ColorScheme.dark(primary: themeColor, brightness: Brightness.dark)
        : ColorScheme.light(primary: themeColor, brightness: Brightness.light);

AppBarTheme _appBarTheme({bool darkMode = false}) => AppBarTheme(
  centerTitle: true,
  toolbarHeight: 65,
  surfaceTintColor: Colors.transparent,
  backgroundColor: WaveColors.content(darkMode: darkMode),
  titleTextStyle: WaveTextTheme(isDarkMode: darkMode).titleMedium,
);

DividerThemeData _dividerTheme() => DividerThemeData(thickness: 1, space: 0, color: WaveColors.dividerColor);

OutlinedButtonThemeData _outlinedButtonTheme(Color accentColor) => const OutlinedButtonThemeData();

TimePickerThemeData _timePickerTheme(bool darkMode) => TimePickerThemeData(
  elevation: 0,
  backgroundColor: WaveColors.background(darkMode: darkMode),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    side: BorderSide(color: WaveColors.dividerColor, width: 1),
  ),
  dayPeriodBorderSide: BorderSide(color: WaveColors.dividerColor),
  hourMinuteTextStyle: const TextStyle(fontSize: 60),
  dialBackgroundColor: WaveColors.background(darkMode: darkMode),
);

DatePickerThemeData _datePickerTheme(bool darkMode) => DatePickerThemeData(
  elevation: 0,
  backgroundColor: WaveColors.background(darkMode: darkMode),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    side: BorderSide(color: WaveColors.dividerColor, width: 1),
  ),
);

DrawerThemeData _drawerTheme(bool darkMode) => DrawerThemeData(
  surfaceTintColor: Colors.transparent,
  backgroundColor: WaveColors.background(darkMode: darkMode),
  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
);

ProgressIndicatorThemeData _progressIndicatorTheme(Color themeColor) => ProgressIndicatorThemeData(
  refreshBackgroundColor: themeColor.withOpacity(0.1),
  linearTrackColor: themeColor.withOpacity(0.1),
  circularTrackColor: themeColor.withOpacity(0.1),
);

ChipThemeData _chipTheme() => ChipThemeData(
  side: BorderSide(color: WaveColors.dividerColor),
  elevation: 0,
  backgroundColor: Colors.transparent,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
);

CardTheme _cardTheme(bool darkMode) => CardTheme(
  elevation: 2,
  surfaceTintColor: Colors.transparent,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  color: WaveColors.content(darkMode: darkMode),
);

BottomNavigationBarThemeData _bottomNavigationBarTheme() => const BottomNavigationBarThemeData(
  showSelectedLabels: false,
  showUnselectedLabels: false,
  type: BottomNavigationBarType.fixed,
  selectedIconTheme: IconThemeData(size: 28),
  unselectedIconTheme: IconThemeData(size: 28),
  elevation: 0,
);

NavigationBarThemeData _navigationBarTheme({required bool darkMode, required Color themeColor}) =>
    NavigationBarThemeData(
      backgroundColor: WaveColors.content(darkMode: darkMode),
      surfaceTintColor: Colors.transparent,
      indicatorColor: themeColor.withOpacity(0.15),
      labelTextStyle: MaterialStatePropertyAll(WaveTextTheme(isDarkMode: darkMode).labelMedium),
      elevation: 0,
    );

DialogTheme _dialogTheme(bool darkMode) => DialogTheme(
  surfaceTintColor: Colors.transparent,
  titleTextStyle: WaveTextTheme(isDarkMode: darkMode).titleLarge,
  contentTextStyle: WaveTextTheme(isDarkMode: darkMode).bodyMedium,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
);

InputDecorationTheme _inputDecorationTheme(Color themeColor, bool darkMode) => InputDecorationTheme(
  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  labelStyle: WaveTextTheme(isDarkMode: darkMode).bodyMedium,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: WaveColors.dividerColor),
    borderRadius: BorderRadius.circular(8),
  ),
  filled: true,
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: themeColor, width: 2),
    borderRadius: BorderRadius.circular(8),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.red, width: 2),
    borderRadius: BorderRadius.circular(8),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.red),
    borderRadius: BorderRadius.circular(8),
  ),
  disabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: WaveColors.dividerColor),
    borderRadius: BorderRadius.circular(8),
  ),
  hintStyle: WaveTextTheme(isDarkMode: darkMode).bodySmall?.copyWith(fontSize: 16),
);
PopupMenuThemeData _popupMenuThemeData({bool darkMode = false}) => PopupMenuThemeData(
  color: WaveColors.content(darkMode: darkMode),
  surfaceTintColor: Colors.transparent,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
);

ListTileThemeData _listTileThemeData({bool darkMode = false}) => ListTileThemeData(
  titleTextStyle: WaveTextTheme(isDarkMode: darkMode).bodyMedium,
  subtitleTextStyle: WaveTextTheme(isDarkMode: darkMode).bodySmall,
  leadingAndTrailingTextStyle: WaveTextTheme(isDarkMode: darkMode).labelLarge,
);

FloatingActionButtonThemeData _floatingActionButtonThemeData() => FloatingActionButtonThemeData(
  elevation: 3,
  shape: RoundedRectangleBorder(
    side: BorderSide(color: WaveColors.dividerColor, width: 1),
    borderRadius: BorderRadius.circular(12),
  ),
);

SnackBarThemeData _snackBarThemeData() =>
    const SnackBarThemeData(behavior: SnackBarBehavior.floating, showCloseIcon: true);

/// ************ Functions ***************

ThemeData _getDefaultThemeData({bool darkMode = false}) => darkMode ? ThemeData.dark() : ThemeData.light();
