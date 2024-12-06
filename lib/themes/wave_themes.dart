import 'package:waveui/waveui.dart';

// ignore: non_constant_identifier_names
ThemeData WaveTheme({
  Color themeColor = Colors.blue,
  bool darkMode = false,
}) {
  return _getDefaultThemeData(darkMode: darkMode).copyWith(
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
  );
}

/// ************ THEME CONFIGS ***************

ColorScheme _colorScheme({Color themeColor = Colors.deepPurple, bool darkMode = false}) {
  return darkMode
      ? ColorScheme.dark(primary: themeColor, brightness: Brightness.dark)
      : ColorScheme.light(primary: themeColor, brightness: Brightness.light);
}

AppBarTheme _appBarTheme({bool darkMode = false}) {
  return AppBarTheme(
    centerTitle: true,
    toolbarHeight: 65,
    surfaceTintColor: Colors.transparent,
    backgroundColor: WaveColors.content(darkMode: darkMode),
    titleTextStyle: WaveTextTheme(isDarkMode: darkMode).titleMedium,
  );
}

DividerThemeData _dividerTheme() {
  return DividerThemeData(
    thickness: WaveConstants.contentBorder,
    space: 0,
    color: WaveColors.dividerColor,
  );
}

OutlinedButtonThemeData _outlinedButtonTheme(Color accentColor) {
  return OutlinedButtonThemeData(
    style: ButtonStyle(
      side: MaterialStatePropertyAll(
        BorderSide(
          color: accentColor,
        ),
      ),
    ),
  );
}

TimePickerThemeData _timePickerTheme(bool darkMode) {
  return TimePickerThemeData(
    elevation: 0,
    backgroundColor: WaveColors.background(darkMode: darkMode),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(WaveConstants.radius),
      side: BorderSide(
        color: WaveColors.dividerColor,
        width: WaveConstants.contentBorder,
      ),
    ),
    dayPeriodBorderSide: BorderSide(
      color: WaveColors.dividerColor,
    ),
    hourMinuteTextStyle: const TextStyle(fontSize: 60),
    dialBackgroundColor: WaveColors.background(darkMode: darkMode),
  );
}

DatePickerThemeData _datePickerTheme(bool darkMode) {
  return DatePickerThemeData(
    elevation: 0,
    backgroundColor: WaveColors.background(darkMode: darkMode),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(WaveConstants.radius),
      side: BorderSide(
        color: WaveColors.dividerColor,
        width: WaveConstants.contentBorder,
      ),
    ),
  );
}

DrawerThemeData _drawerTheme(bool darkMode) {
  return DrawerThemeData(
    surfaceTintColor: Colors.transparent,
    backgroundColor: WaveColors.background(darkMode: darkMode),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.zero,
    ),
  );
}

ProgressIndicatorThemeData _progressIndicatorTheme(Color themeColor) {
  return ProgressIndicatorThemeData(
    refreshBackgroundColor: themeColor.withOpacity(0.1),
    linearTrackColor: themeColor.withOpacity(0.1),
    circularTrackColor: themeColor.withOpacity(0.1),
  );
}

ChipThemeData _chipTheme() {
  return ChipThemeData(
    side: BorderSide(color: WaveColors.dividerColor),
    elevation: 0,
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(WaveConstants.radius),
    ),
  );
}

CardTheme _cardTheme(bool darkMode) {
  return CardTheme(
    elevation: WaveConstants.elevation,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(WaveConstants.radius),
    ),
    color: WaveColors.content(darkMode: darkMode),
  );
}

BottomNavigationBarThemeData _bottomNavigationBarTheme() {
  return const BottomNavigationBarThemeData(
    showSelectedLabels: false,
    showUnselectedLabels: false,
    type: BottomNavigationBarType.fixed,
    selectedIconTheme: IconThemeData(size: 28),
    unselectedIconTheme: IconThemeData(size: 28),
    elevation: 0,
  );
}

NavigationBarThemeData _navigationBarTheme({required bool darkMode, required Color themeColor}) {
  return NavigationBarThemeData(
    backgroundColor: WaveColors.content(darkMode: darkMode),
    surfaceTintColor: Colors.transparent,
    indicatorColor: themeColor.withOpacity(0.15),
    labelTextStyle: MaterialStatePropertyAll(WaveTextTheme(isDarkMode: darkMode).labelMedium),
    elevation: 0,
  );
}

DialogTheme _dialogTheme(bool darkMode) {
  return DialogTheme(
    surfaceTintColor: Colors.transparent,
    titleTextStyle: WaveTextTheme(isDarkMode: darkMode).titleLarge,
    contentTextStyle: WaveTextTheme(isDarkMode: darkMode).bodyMedium,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(WaveConstants.radius),
    ),
  );
}

InputDecorationTheme _inputDecorationTheme(Color themeColor, bool darkMode) => InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      labelStyle: WaveTextTheme(isDarkMode: darkMode).bodyMedium,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: WaveColors.dividerColor),
        borderRadius: BorderRadius.circular(WaveConstants.radius),
      ),
      filled: true,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: themeColor, width: 2),
        borderRadius: BorderRadius.circular(WaveConstants.radius),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(WaveConstants.radius),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(WaveConstants.radius),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: WaveColors.dividerColor),
        borderRadius: BorderRadius.circular(WaveConstants.radius),
      ),
      hintStyle: WaveTextTheme(isDarkMode: darkMode).bodySmall?.copyWith(fontSize: 16),
    );
PopupMenuThemeData _popupMenuThemeData() => PopupMenuThemeData(
      color: Get.theme.cardColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(WaveConstants.radius),
      ),
    );

ListTileThemeData _listTileThemeData({bool darkMode = false}) {
  return ListTileThemeData(
    titleTextStyle: WaveTextTheme(isDarkMode: darkMode).bodyMedium,
    subtitleTextStyle: WaveTextTheme(isDarkMode: darkMode).bodySmall,
    leadingAndTrailingTextStyle: WaveTextTheme(isDarkMode: darkMode).labelLarge,
  );
}

FloatingActionButtonThemeData _floatingActionButtonThemeData() {
  return FloatingActionButtonThemeData(
    elevation: 3,
    shape: RoundedRectangleBorder(
      side: BorderSide(
        color: WaveColors.dividerColor,
        width: WaveConstants.contentBorder,
      ),
      borderRadius: BorderRadius.circular(WaveConstants.radius),
    ),
  );
}

SnackBarThemeData _snackBarThemeData() => const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      showCloseIcon: true,
    );

/// ************ Functions ***************

ThemeData _getDefaultThemeData({bool darkMode = false}) {
  return darkMode ? ThemeData.dark() : ThemeData.light();
}
