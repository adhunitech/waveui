import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/action_icons_theme.dart';
import 'package:waveui/material/debug.dart';
import 'package:waveui/material/icon_button.dart';
import 'package:waveui/material/icons.dart';
import 'package:waveui/material/material_localizations.dart';
import 'package:waveui/material/scaffold.dart';
import 'package:waveui/material/theme.dart';

abstract class _ActionButton extends IconButton {
  const _ActionButton({
    required super.icon,
    super.key,
    super.color,
    super.style,
    super.onPressed,
    this.standardComponent,
  });

  final StandardComponentType? standardComponent;

  String _getTooltip(BuildContext context);

  void _onPressedCallback(BuildContext context);

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    return IconButton(
      key: standardComponent?.key,
      icon: icon,
      style: style,
      color: color,
      tooltip: _getTooltip(context),
      onPressed: () {
        if (onPressed != null) {
          onPressed!();
        } else {
          _onPressedCallback(context);
        }
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<StandardComponentType?>('standardComponent', standardComponent));
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({required this.iconBuilderCallback, required this.getIcon, required this.getAndroidSemanticsLabel});

  final WidgetBuilder? Function(ActionIconThemeData?) iconBuilderCallback;
  final IconData Function(BuildContext) getIcon;
  final String Function(MaterialLocalizations) getAndroidSemanticsLabel;

  @override
  Widget build(BuildContext context) {
    final ActionIconThemeData? actionIconTheme = ActionIconTheme.of(context);
    final WidgetBuilder? iconBuilder = iconBuilderCallback(actionIconTheme);
    if (iconBuilder != null) {
      return iconBuilder(context);
    }

    final IconData data = getIcon(context);
    final String? semanticsLabel;
    // This can't use the platform from Theme because it is the Android OS that
    // expects the duplicated tooltip and label.
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        semanticsLabel = getAndroidSemanticsLabel(MaterialLocalizations.of(context));
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        semanticsLabel = null;
    }

    return Icon(data, semanticLabel: semanticsLabel);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      ObjectFlagProperty<WidgetBuilder? Function(ActionIconThemeData? p1)>.has(
        'iconBuilderCallback',
        iconBuilderCallback,
      ),
    );
    properties.add(ObjectFlagProperty<IconData Function(BuildContext p1)>.has('getIcon', getIcon));
    properties.add(
      ObjectFlagProperty<String Function(MaterialLocalizations p1)>.has(
        'getAndroidSemanticsLabel',
        getAndroidSemanticsLabel,
      ),
    );
  }
}

class BackButtonIcon extends StatelessWidget {
  const BackButtonIcon({super.key});

  @override
  Widget build(BuildContext context) => _ActionIcon(
    iconBuilderCallback: (actionIconTheme) => actionIconTheme?.backButtonIconBuilder,
    getIcon: (context) {
      if (kIsWeb) {
        // Always use 'Icons.arrow_back' as a back_button icon in web.
        return Icons.arrow_back;
      }
      switch (Theme.of(context).platform) {
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
          return Icons.arrow_back;
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
          return Icons.arrow_back_ios_new_rounded;
      }
    },
    getAndroidSemanticsLabel: (materialLocalization) => materialLocalization.backButtonTooltip,
  );
}

class BackButton extends _ActionButton {
  const BackButton({super.key, super.color, super.style, super.onPressed})
    : super(icon: const BackButtonIcon(), standardComponent: StandardComponentType.backButton);

  @override
  void _onPressedCallback(BuildContext context) => Navigator.maybePop(context);

  @override
  String _getTooltip(BuildContext context) => MaterialLocalizations.of(context).backButtonTooltip;
}

class CloseButtonIcon extends StatelessWidget {
  const CloseButtonIcon({super.key});

  @override
  Widget build(BuildContext context) => _ActionIcon(
    iconBuilderCallback: (actionIconTheme) => actionIconTheme?.closeButtonIconBuilder,
    getIcon: (context) => Icons.close,
    getAndroidSemanticsLabel: (materialLocalization) => materialLocalization.closeButtonTooltip,
  );
}

class CloseButton extends _ActionButton {
  const CloseButton({super.key, super.color, super.onPressed, super.style})
    : super(icon: const CloseButtonIcon(), standardComponent: StandardComponentType.closeButton);

  @override
  void _onPressedCallback(BuildContext context) => Navigator.maybePop(context);

  @override
  String _getTooltip(BuildContext context) => MaterialLocalizations.of(context).closeButtonTooltip;
}

class DrawerButtonIcon extends StatelessWidget {
  const DrawerButtonIcon({super.key});

  @override
  Widget build(BuildContext context) => _ActionIcon(
    iconBuilderCallback: (actionIconTheme) => actionIconTheme?.drawerButtonIconBuilder,
    getIcon: (context) => Icons.menu,
    getAndroidSemanticsLabel: (materialLocalization) => materialLocalization.openAppDrawerTooltip,
  );
}

class DrawerButton extends _ActionButton {
  const DrawerButton({super.key, super.color, super.style, super.onPressed})
    : super(icon: const DrawerButtonIcon(), standardComponent: StandardComponentType.drawerButton);

  @override
  void _onPressedCallback(BuildContext context) => Scaffold.of(context).openDrawer();

  @override
  String _getTooltip(BuildContext context) => MaterialLocalizations.of(context).openAppDrawerTooltip;
}

class EndDrawerButtonIcon extends StatelessWidget {
  const EndDrawerButtonIcon({super.key});

  @override
  Widget build(BuildContext context) => _ActionIcon(
    iconBuilderCallback: (actionIconTheme) => actionIconTheme?.endDrawerButtonIconBuilder,
    getIcon: (context) => Icons.menu,
    getAndroidSemanticsLabel: (materialLocalization) => materialLocalization.openAppDrawerTooltip,
  );
}

class EndDrawerButton extends _ActionButton {
  const EndDrawerButton({super.key, super.color, super.style, super.onPressed})
    : super(icon: const EndDrawerButtonIcon());

  @override
  void _onPressedCallback(BuildContext context) => Scaffold.of(context).openEndDrawer();

  @override
  String _getTooltip(BuildContext context) => MaterialLocalizations.of(context).openAppDrawerTooltip;
}
