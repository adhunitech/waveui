import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:waveui/material/material_localizations.dart';
import 'package:waveui/material/theme_data.dart';
import 'package:waveui/material/typography.dart';

export 'theme_data.dart' show Brightness, ThemeData;

const Duration kThemeAnimationDuration = Duration(milliseconds: 200);

class Theme extends StatelessWidget {
  const Theme({required this.data, required this.child, super.key});

  final ThemeData data;
  final Widget child;

  static final ThemeData _kFallbackTheme = ThemeData.fallback();

  static ThemeData of(BuildContext context) {
    final _InheritedTheme? inheritedTheme = context.dependOnInheritedWidgetOfExactType<_InheritedTheme>();
    final localizations = Localizations.of<MaterialLocalizations>(context, MaterialLocalizations);
    final category = localizations?.scriptCategory ?? ScriptCategory.englishLike;
    final inheritedCupertinoTheme = context.dependOnInheritedWidgetOfExactType<InheritedCupertinoTheme>();
    final theme =
        inheritedTheme?.theme.data ??
        (inheritedCupertinoTheme != null
            ? CupertinoBasedMaterialThemeData(themeData: inheritedCupertinoTheme.theme.data).materialTheme
            : _kFallbackTheme);
    return ThemeData.localize(theme, theme.typography.geometryThemeFor(category));
  }

  Widget _wrapsWidgetThemes(BuildContext context, Widget child) {
    final selectionStyle = DefaultSelectionStyle.of(context);
    return IconTheme(
      data: data.iconTheme,
      child: DefaultSelectionStyle(
        selectionColor: data.textSelectionTheme.selectionColor ?? selectionStyle.selectionColor,
        cursorColor: data.textSelectionTheme.cursorColor ?? selectionStyle.cursorColor,
        child: child,
      ),
    );
  }

  CupertinoThemeData _inheritedCupertinoThemeData(BuildContext context) {
    final inheritedTheme = context.dependOnInheritedWidgetOfExactType<InheritedCupertinoTheme>();
    return (inheritedTheme?.theme.data ?? MaterialBasedCupertinoThemeData(materialTheme: data)).resolveFrom(context);
  }

  @override
  Widget build(BuildContext context) => _InheritedTheme(
    theme: this,
    child: CupertinoTheme(data: _inheritedCupertinoThemeData(context), child: _wrapsWidgetThemes(context, child)),
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ThemeData>('data', data, showName: false));
  }
}

class _InheritedTheme extends InheritedTheme {
  const _InheritedTheme({required this.theme, required super.child});

  final Theme theme;

  @override
  Widget wrap(BuildContext context, Widget child) => Theme(data: theme.data, child: child);

  @override
  bool updateShouldNotify(_InheritedTheme old) => theme.data != old.theme.data;
}

class ThemeDataTween extends Tween<ThemeData> {
  ThemeDataTween({super.begin, super.end});

  @override
  ThemeData lerp(double t) => ThemeData.lerp(begin!, end!, t);
}

class AnimatedTheme extends ImplicitlyAnimatedWidget {
  const AnimatedTheme({
    required this.data,
    required this.child,
    super.key,
    super.curve,
    super.duration = kThemeAnimationDuration,
    super.onEnd,
  });

  final ThemeData data;
  final Widget child;

  @override
  AnimatedWidgetBaseState<AnimatedTheme> createState() => _AnimatedThemeState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ThemeData>('data', data));
  }
}

class _AnimatedThemeState extends AnimatedWidgetBaseState<AnimatedTheme> {
  ThemeDataTween? _data;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _data =
        visitor(_data, widget.data, (dynamic value) => ThemeDataTween(begin: value as ThemeData))! as ThemeDataTween;
  }

  @override
  Widget build(BuildContext context) => Theme(data: _data!.evaluate(animation), child: widget.child);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description.add(DiagnosticsProperty<ThemeDataTween>('data', _data, showName: false, defaultValue: null));
  }
}
