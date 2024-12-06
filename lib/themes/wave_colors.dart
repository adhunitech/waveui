import 'package:flutter/widgets.dart';
import 'package:waveui/waveui.dart';

class WaveColors {
  static Color background({darkMode = false}) {
    return darkMode ? const Color(0xFF0A0A0A) : const Color(0xFFF1F3F5);
  }

  static Color content({darkMode = false}) {
    return darkMode ? const Color(0xff121212) : const Color(0xFFFFFFFF);
  }

  static Color textColor({darkMode = false}) {
    return darkMode ? const Color(0xDDFFFFFF) : const Color(0xDD000000);
  }

  static Color subtitleColor({darkMode = false}) {
    return darkMode ? const Color(0x88FFFFFF) : const Color(0x89000000);
  }

  static Color dividerColor = const Color(0x4B9E9E9E);
}
