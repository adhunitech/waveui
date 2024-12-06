import 'package:waveui/src/src/dialog/wave_dialog_utils.dart';
import 'package:waveui/waveui.dart';

///The click listener callback of the bottom button
typedef DialogIndexedActionClickCallback = void Function(int index);

///Icon spacing
const EdgeInsetsGeometry cIconPadding = EdgeInsets.only(top: 28.0);

///The text style of the title
const TextStyle cTitleTextStyle =
    TextStyle(fontWeight: FontWeight.w600, inherit: true, fontSize: 18.0, color: Color(0xFF222222));

///Alignment of title text
const int cTitleMaxLines = 3;

///Alignment of title text
const TextAlign cTitleTextAlign = TextAlign.center;

///Alignment of the text in the content part
const TextAlign cContentTextAlign = TextAlign.center;

///The text style of the content part
const TextStyle cContentTextStyle =
    TextStyle(inherit: true, fontSize: 14.0, color: Color(0xFF666666), decoration: TextDecoration.none);

///Warning text style
const TextStyle cWarningTextStyle =
    TextStyle(inherit: true, fontSize: 14.0, color: Color(0xFFFA3F3F), decoration: TextDecoration.none);

///Text alignment of warning text
const TextAlign cWarningTextAlign = TextAlign.center;

///The background of the dialog ---"Default white
const Color cBackgroundColor = Colors.white;

///The border of the dialog box ----"Default rounded corner 5
const ShapeBorder cShape = RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)));

///The background color of the theme button---"white
const Color cMainBackgroundColor = Colors.white;

///The text style of the theme button---"main color
const TextStyle cMainTextStyle = TextStyle(color: Color(0xFF00AE66), fontWeight: FontWeight.w600, fontSize: 16);

///The background color of the gray button---"white
const Color cGreyBackgroundColor = Colors.white;

///Non-button text style---"gray
const TextStyle cGreyActionsTextStyle = TextStyle(color: Color(0xFF222222), fontWeight: FontWeight.w600, fontSize: 16);

///The height of the bottom button
const double cBottomHeight = 44.0;

///Horizontal split line content and button
const VerticalDivider cVerticalDivider = VerticalDivider(width: 1.0, color: Color(0xF0F0F0F0));

///vertical split line button split
const Divider cDividerLine = Divider(
  height: 1.0,
  color: Color(0xF0F0F0F0),
);

enum _ButtonType {
  ///Single button
  single,

  ///Multi button
  multi,

  ///left button
  left,

  ///Right button
  right,
}

///Highly flexible and general-purpose pop-up window component
///
///Layout rules:
///The pop-up window consists of five parts: Icon, title, content, warning, and button operation area.
///Each part can be displayed or not displayed.
///
///
///There are two ways to use:
///1: system showDialog
///Untitled, single button
///showDialog<void>(
///context: context,
///barrierDismissible: true,
///builder: (BuildContext dialogContext) {
///return WaveDialog(
///messageText: "Auxiliary content information Auxiliary content information Auxiliary content information Auxiliary content information Auxiliary content information",
///actionsText: [],
///);
///},
///);
///
///2: Use the dialog manager
///Untitled, single button
///void _showStyle1Dialog(BuildContext context) {
///WaveDialogManager.showSingleButtonDialog(context,
///label: "Got it", message: "Auxiliary content information, auxiliary content information, auxiliary content information, auxiliary content information", onTap: () {
///showSnackBar(context,
//  msg:'Got it', context);
///});
///}
///
class WaveDialog extends AlertDialog {
  ///Title control
  final Widget? titleWidget;

  ///Content control
  final Widget? contentWidget;

  ///Controls in the warning text section
  final Widget? warningWidget;

  ///Button part control
  final List<Widget>? actionsWidget;

  ///-----If the above properties are set, the corresponding parts in the dialog box will be based on them

  ///title text
  final String? titleText;

  ///content text
  final String? messageText;

  ///warning text
  final String? warningText;

  ///Bottom button copy
  final List<String>? actionsText;

  ///Generate the corresponding text control according to the above properties

  ///Vertical dividing line
  final VerticalDivider verticalDivider;

  ///Horizontal dividing line
  final Divider divider;

  ///The click listener callback of the bottom button
  final DialogIndexedActionClickCallback? indexedActionCallback;

  ///Whether to display the header icon
  final bool showIcon;

  ///The icon of the head
  final Image? iconImage;

  ///dialog configuration
  final WaveDialogConfig? themeData;

  ///The maximum number of lines for the title
  final int titleMaxLines;

  const WaveDialog({
    Key? key,
    this.showIcon = false,
    this.iconImage,
    this.titleText,
    this.messageText,
    this.titleWidget,
    this.contentWidget,
    this.warningText,
    this.warningWidget,
    this.actionsWidget,
    this.divider = cDividerLine,
    this.verticalDivider = cVerticalDivider,
    this.actionsText,
    this.indexedActionCallback,
    this.themeData,
    this.titleMaxLines = cTitleMaxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WaveDialogConfig? defaultConfig = themeData ?? WaveDialogConfig();

    defaultConfig =
        WaveThemeConfigurator.instance.getConfig(configId: defaultConfig.configId).dialogConfig.merge(defaultConfig);

    final List<Widget> children = <Widget>[];

    if (_isShowIcon()) {
      Widget generateIconWidget = _generateIconWidget(context, defaultConfig);
      children.add(generateIconWidget);
    }

    if (_isShowTitle()) {
      Widget generateTitleWidget = _generateTitleWidget(context, defaultConfig);
      children.add(generateTitleWidget);
    }

    if (_isShowContent()) {
      Widget generateContentWidget = _generateContentWidget(context, defaultConfig);
      children.add(generateContentWidget);
    }

    if (_isShowWarning()) {
      Widget generateWarningWidget = _generateWarningWidget(context, defaultConfig);
      children.add(generateWarningWidget);
    }

    children.add(Padding(
      padding: defaultConfig.dividerPadding,
      child: const SizedBox.shrink(),
    ));

    if (!_isEmptyAction()) {
      children.add(divider);
      children.add(_generateActionsWidget(context, defaultConfig));
    }

    Widget dialogChild = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );

    return UnconstrainedBox(
        child: SizedBox(
            width: defaultConfig.dialogWidth,
            child: Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(WaveDialogUtils.getDialogRadius(defaultConfig)))),
              color: defaultConfig.backgroundColor,
              child: dialogChild,
            )));
  }

  Widget _generateIconWidget(BuildContext context, WaveDialogConfig dialogConfig) {
    Widget createWidget(Widget widget) {
      return Center(
        child: Padding(
          padding: dialogConfig.iconPadding,
          child: SizedBox(
            width: 36,
            height: 36,
            child: widget,
          ),
        ),
      );
    }

    if (iconImage != null) {
      return createWidget(iconImage!);
    }
    if (showIcon) {
      return createWidget(WaveUITools.getAssetImageWithBandColor("icons/icon_alter.png"));
    }

    return const SizedBox.shrink();
  }

  ///Title widget: subject to titleWidget, supplemented by the Text generated by title.
  Widget _generateTitleWidget(BuildContext context, WaveDialogConfig dialogConfig) {
    if (titleWidget != null) {
      return DefaultTextStyle(
        textAlign: dialogConfig.titleTextAlign,
        style: WaveDialogUtils.getDialogTitleStyle(dialogConfig),
        child: titleWidget!,
      );
    }

    return Padding(
      padding: _configTitlePadding(dialogConfig),
      child: Text(
        titleText!,
        maxLines: titleMaxLines,
        overflow: TextOverflow.ellipsis,
        style: Get.textTheme.titleLarge,
        textAlign: dialogConfig.titleTextAlign,
      ),
    );
  }

  ///Content widget: based on contentWidget, supplemented by Text generated by message
  Widget _generateContentWidget(BuildContext context, WaveDialogConfig dialogConfig) {
    if (contentWidget != null) {
      return Flexible(
        child: DefaultTextStyle(
          style: dialogConfig.contentTextStyle.generateTextStyle(),
          child: contentWidget!,
        ),
      );
    }

    return Padding(
      padding: _configContentPadding(dialogConfig),
      child: Center(
        child: Text(
          messageText ?? "",
          style: Get.textTheme.bodyMedium,
          textAlign: dialogConfig.contentTextAlign,
        ),
      ),
    );
  }

  ///Warning widget: based on warningWidget, supplemented by Text generated by warning
  Widget _generateWarningWidget(BuildContext context, WaveDialogConfig dialogConfig) {
    if (warningWidget != null) {
      return Flexible(
        child: DefaultTextStyle(
          style: dialogConfig.warningTextStyle.generateTextStyle(),
          child: warningWidget!,
        ),
      );
    }

    return Padding(
      padding: _configWarningPadding(dialogConfig),
      child: Text(
        warningText!,
        style: dialogConfig.warningTextStyle.generateTextStyle(),
        textAlign: dialogConfig.warningTextAlign,
      ),
    );
  }

  ///Generate the main button
  ///A single button has rounded corners on the left and right
  ///Two buttons, the left button has left rounded corners & right right angles, the right button has right rounded corners & left right corners
  ///Multiple buttons, the last left and right rounded corners, the others are all right angles
  Widget _generateMainWidget(
      Widget widget, Color background, _ButtonType type, int index, WaveDialogConfig dialogConfig) {
    return Container(
      decoration: ShapeDecoration(
          color: background,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(type == _ButtonType.single ||
                          type == _ButtonType.left ||
                          (type == _ButtonType.multi && actionsText != null && index == actionsText!.length - 1)
                      ? WaveDialogUtils.getDialogRadius(dialogConfig)
                      : 0),
                  bottomRight: Radius.circular(type == _ButtonType.single ||
                          type == _ButtonType.right ||
                          (type == _ButtonType.multi && actionsText != null && index == actionsText!.length - 1)
                      ? WaveDialogUtils.getDialogRadius(dialogConfig)
                      : 0)))),
      constraints: const BoxConstraints.tightFor(height: cBottomHeight),
      child: DefaultTextStyle(
        style: dialogConfig.mainActionTextStyle.generateTextStyle(),
        child: Center(
          child: widget,
        ),
      ),
    );
  }

  ///Generate a button with a gray tone according to the parameters
  ///A single button has rounded corners on the left and right
  ///Two buttons, the left button has left rounded corners & right right angles, the right button has right rounded corners & left right corners
  ///Multiple buttons, the last left and right rounded corners, the others are all right angles
  Widget _generateGreyWidget(
      Widget widget, Color background, _ButtonType type, int index, WaveDialogConfig dialogConfig) {
    return Container(
      constraints: const BoxConstraints.tightFor(height: cBottomHeight),
      decoration: ShapeDecoration(
          color: background,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(type == _ButtonType.single ||
                          type == _ButtonType.left ||
                          (type == _ButtonType.multi && actionsText != null && index == actionsText!.length - 1)
                      ? WaveDialogUtils.getDialogRadius(dialogConfig)
                      : 0),
                  bottomRight: Radius.circular(type == _ButtonType.single ||
                          type == _ButtonType.right ||
                          (type == _ButtonType.multi && actionsText != null && index == actionsText!.length - 1)
                      ? WaveDialogUtils.getDialogRadius(dialogConfig)
                      : 0)))),
      child: DefaultTextStyle(
        style: dialogConfig.assistActionsTextStyle.generateTextStyle(),
        child: Center(
          child: widget,
        ),
      ),
    );
  }

  Widget _generateActionsWidget(BuildContext context, WaveDialogConfig defaultConfig) {
    bool showTextActions = _isEmptyActionsWidget();
    int length = showTextActions ? actionsText!.length : actionsWidget!.length;
    if (length == 1) {
      return showTextActions
          ? _mapTextToGesWidget(
              context,
              actionsText![0],
              0,
              true,
              defaultConfig,
              type: _ButtonType.single,
            )
          : actionsWidget![0];
    } else if (length == 2) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: showTextActions
                ? _mapTextToGesWidget(context, actionsText![0], 0, false, defaultConfig, type: _ButtonType.left)
                : actionsWidget![0],
          ),
          SizedBox(
            height: defaultConfig.bottomHeight,
            child: verticalDivider,
          ),
          Expanded(
            child: showTextActions
                ? _mapTextToGesWidget(context, actionsText![1], 1, true, defaultConfig, type: _ButtonType.right)
                : actionsWidget![1],
          )
        ],
      );
    } else {
      return SizedBox(
        height: 3 * (defaultConfig.bottomHeight + 1),
        width: double.maxFinite,
        child: ListView.separated(
            shrinkWrap: true,
            physics: length > 3 ? null : const NeverScrollableScrollPhysics(),
            itemBuilder: (context, i) {
              return showTextActions
                  ? _mapTextToGesWidget(context, actionsText![i], i, true, defaultConfig, type: _ButtonType.multi)
                  : actionsWidget![i];
            },
            separatorBuilder: (context, i) {
              return divider;
            },
            itemCount: length),
      );
    }
  }

  Widget _mapTextToGesWidget(BuildContext context, String label, int index, bool main, WaveDialogConfig dialogConfig,
      {_ButtonType type = _ButtonType.single}) {
    Text text = Text(label);
    Widget ges = GestureDetector(
      child: main
          ? _generateMainWidget(text, dialogConfig.mainActionBackgroundColor, type, index, dialogConfig)
          : _generateGreyWidget(text, dialogConfig.assistActionsBackgroundColor, type, index, dialogConfig),
      onTap: () {
        if (indexedActionCallback != null) {
          //click listener
          indexedActionCallback!(index);
        } else {
          Navigator.pop(context);
        }
      },
    );
    return ges;
  }

  bool _isEmptyAction() {
    return _isEmptyActionsText() && _isEmptyActionsWidget();
  }

  bool _isShowIcon() {
    return (showIcon || iconImage != null);
  }

  bool _isShowTitle() {
    return (titleText != null || titleWidget != null);
  }

  bool _isShowContent() {
    return contentWidget != null || messageText != null;
  }

  bool _isShowWarning() {
    return warningWidget != null || warningText != null;
  }

  bool _isEmptyActionsText() {
    return actionsText == null || actionsText!.isEmpty;
  }

  bool _isEmptyActionsWidget() {
    return actionsWidget == null || actionsWidget!.isEmpty;
  }

  ///Title spacing for theme configuration
  EdgeInsetsGeometry _configTitlePadding(WaveDialogConfig dialogConfig) {
    return _isShowIcon() ? dialogConfig.titlePaddingSm : dialogConfig.titlePaddingLg;
  }

  ///The content spacing of the theme configuration
  EdgeInsetsGeometry _configContentPadding(WaveDialogConfig dialogConfig) {
    return (_isShowIcon() || _isShowTitle()) ? dialogConfig.contentPaddingSm : dialogConfig.contentPaddingLg;
  }

  ///Warning spacing for theme configuration
  EdgeInsetsGeometry _configWarningPadding(WaveDialogConfig dialogConfig) {
    return (_isShowIcon() || _isShowTitle() || _isShowContent())
        ? dialogConfig.warningPaddingSm
        : dialogConfig.warningPaddingLg;
  }
}

///It is the management class displayed by the dialog box.
///According to the number of buttons at the bottom, it is divided into: single button dialog box, two button dialog box and indeterminate button dialog box
///
///General attributes:
///showIcon Whether to display the head Icon, and the default checkmark image will be displayed
///iconWidget The picture of the icon in the header, if this property is set, the set picture will be displayed even if showIcon is false
///
///title is the title copy of the display
///titleWidget The title widget displayed, if the widget is set, the widget will prevail
///
///Auxiliary information copy in the middle of message
///messageWidget A widget that displays intermediate auxiliary information
///
///warning warning text
///warningWidget The widget that displays the warning text
///
///dismiss Whether to disappear the pop-up window after clicking the button
///
///barrierDismissible Click on the black mask around to close the pop-up window
///
///titleMaxLines The maximum number of lines for the title
///
class WaveDialogManager {
  ///Display a dialog box with only one button at the bottom. The click callback of the dialog box is onTap
  ///label The text of the button at the bottom
  ///labelWidget Customize the display of the bottom button
  static void showSingleButtonDialog(
    BuildContext context, {
    required String label,
    bool showIcon = false,
    Image? iconWidget,
    String? title,
    Widget? titleWidget,
    String? message,
    Widget? messageWidget,
    String? warning,
    Widget? warningWidget,
    Widget? labelWidget,
    GestureTapCallback? onTap,
    bool barrierDismissible = true,
    int titleMaxLines = cTitleMaxLines,
    WaveDialogConfig? themeData,
  }) {
    List<Widget> actionsWidget = [];

    if (labelWidget != null) {
      actionsWidget.add(labelWidget);
    }
    showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext dialogContext) {
        return WaveDialog(
          iconImage: iconWidget,
          showIcon: showIcon,
          titleText: title,
          titleWidget: titleWidget,
          messageText: message,
          contentWidget: messageWidget,
          warningText: warning,
          warningWidget: warningWidget,
          actionsText: [label],
          actionsWidget: actionsWidget,
          titleMaxLines: titleMaxLines,
          themeData: themeData,
          indexedActionCallback: (index) {
            if (index == 0) {
              if (onTap != null) {
                onTap();
              }
            }
          },
        );
      },
    );
  }

  ///Show a popup window with two buttons at the bottom, cancel on the left and confirm on the right
  ///cancel the text displayed on the left
  ///The text displayed on the right side of confirm
  ///cancelWidget customizes the left side of the display
  ///conformWidget customizes the right side of the display
  static void showConfirmDialog(
    BuildContext context, {
    required String cancel,
    required String confirm,
    bool showIcon = false,
    Image? iconWidget,
    String? title,
    Widget? titleWidget,
    String? message,
    Widget? messageWidget,
    String? warning,
    Widget? warningWidget,
    Widget? cancelWidget,
    Widget? conformWidget,
    GestureTapCallback? onCancel,
    GestureTapCallback? onConfirm,
    bool barrierDismissible = true,
    int titleMaxLines = cTitleMaxLines,
    WaveDialogConfig? themeData,
  }) {
    List<Widget> actionsWidget = [];

    if (cancelWidget != null) {
      actionsWidget.add(cancelWidget);
    }
    if (conformWidget != null) {
      actionsWidget.add(conformWidget);
    }
    showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext dialogContext) {
        return WaveDialog(
          iconImage: iconWidget,
          showIcon: showIcon,
          titleText: title,
          titleWidget: titleWidget,
          messageText: message,
          contentWidget: messageWidget,
          warningWidget: warningWidget,
          warningText: warning,
          themeData: themeData,
          titleMaxLines: titleMaxLines,
          actionsText: [cancel, confirm],
          actionsWidget: actionsWidget,
          indexedActionCallback: (index) {
            if (index == 0) {
              if (onCancel != null) {
                onCancel();
              }
            }
            if (index == 1) {
              if (onConfirm != null) {
                onConfirm();
              }
            }
          },
        );
      },
    );
  }

  ///Display a dialog with multiple buttons at the bottom If you set a text button, the click of each button is processed by indexedActionClickCallback
  ///If the number of bottom buttons is less than or equal to 2, it will be displayed in a horizontal row, otherwise the meeting will be displayed in a vertical row
  ///If the number exceeds three, it will slide to display
  static void showMoreButtonDialog(
    BuildContext context, {
    required List<String> actions,
    bool showIcon = false,
    Image? iconWidget,
    String? title,
    Widget? titleWidget,
    String? message,
    Widget? messageWidget,
    String? warning,
    Widget? warningWidget,
    List<Widget>? actionsWidget,
    bool barrierDismissible = true,
    int titleMaxLines = cTitleMaxLines,
    WaveDialogConfig? themeData,
    DialogIndexedActionClickCallback? indexedActionClickCallback,
  }) {
    showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext dialogContext) {
        return WaveDialog(
            iconImage: iconWidget,
            showIcon: showIcon,
            titleText: title,
            titleWidget: titleWidget,
            messageText: message,
            contentWidget: messageWidget,
            warningWidget: warningWidget,
            warningText: warning,
            actionsText: actions,
            actionsWidget: actionsWidget,
            themeData: themeData,
            titleMaxLines: titleMaxLines,
            indexedActionCallback: indexedActionClickCallback);
      },
    );
  }
}
