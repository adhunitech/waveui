import 'package:flutter/services.dart';
import 'package:waveui/waveui.dart';

///Search box content change callback
typedef WaveOnSearchTextChange = void Function(String content);

///Callback when the content of the search box is submitted
typedef WaveOnCommit = void Function(String content);

///Callback when the right clear button X is clicked
typedef WaveOnTextClear = bool Function();

///Basic IOS style search box, provide input callback
class WaveSearchText extends StatefulWidget {
  ///hint
  final String? hintText;

  ///Prompt style
  final TextStyle? hintStyle;

  ///input box style
  final TextStyle? textStyle;

  ///Icon used to set the front end of the search box
  final Widget? prefixIcon;

  ///The color inside the search box
  final Color? innerColor;

  ///The maximum number of display rows
  final int maxLines;

  ///Maximum input length
  final int? maxLength;

  ///The maximum height of the input box, the default is 60
  final double maxHeight;

  ///Padding outside the inner search box. Setting this field causes the display area to be smaller.
  final EdgeInsets innerPadding;

  ///border in normal state
  final BoxBorder? normalBorder;

  ///The border in the active state, the default is consistent with the border
  final BoxBorder? activeBorder;

  ///Input box rounded corners
  final BorderRadius borderRadius;

  ///Right side operation widget
  final Widget? action;

  ///Whether to automatically get the focus
  final bool autoFocus;

  ///Used to control keyboard actions
  final TextInputAction? textInputAction;

  final TextInputType? textInputType;

  final List<TextInputFormatter>? inputFormatters;

  final TextEditingController? controller;
  final FocusNode? focusNode;

  ///Text change callback
  final WaveOnSearchTextChange? onTextChange;

  ///Callback when text is submitted
  final WaveOnCommit? onTextCommit;

  ///Callback for clicking on the action area on the right
  final VoidCallback? onActionTap;

  ///The callback of the clear button if the user sets this property
  ///If the return value is true, indicating that the user wants to intercept, the default clearing behavior will not be taken
  ///If the return value is false, it indicates that the user does not want to intercept, and after executing the user's behavior, the default behavior will be taken
  final WaveOnTextClear? onTextClear;

  ///Used to control the display and hiding of the clear Icon and the Action on the right. and other complex operations.
  final WaveSearchTextController? searchController;

  const WaveSearchText({
    Key? key,
    this.searchController,
    this.controller,
    this.maxLines = 1,
    this.maxLength,
    this.hintText,
    this.hintStyle,
    this.textStyle,
    this.prefixIcon,
    this.onTextChange,
    this.onTextCommit,
    this.onTextClear,
    this.onActionTap,
    this.action,
    this.maxHeight = 40,
    this.innerPadding =
        const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
    this.innerColor,
    this.normalBorder,
    this.activeBorder,
    this.borderRadius =
        const BorderRadius.all(Radius.circular(WaveConstants.radius)),
    this.focusNode,
    this.autoFocus = false,
    this.textInputAction,
    this.inputFormatters,
    this.textInputType,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SearchTextState();
  }
}

class _SearchTextState extends State<WaveSearchText> {
  FocusNode? focusNode;
  TextEditingController? textEditingController;
  BoxBorder? border;
  WaveSearchTextController? searchTextController;

  WaveSearchTextController? tmpController;

  @override
  void initState() {
    super.initState();

    if (widget.searchController == null) {
      tmpController = WaveSearchTextController();
    }
    searchTextController = widget.searchController ?? tmpController;
    searchTextController!.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    focusNode = widget.focusNode ?? FocusNode();
    textEditingController = widget.controller ?? TextEditingController();
    border = widget.normalBorder ??
        Border.all(
          width: 1.0,
          color: Get.theme.dividerColor,
        );

    focusNode!.addListener(_handleFocusNodeChangeListenerTick);
  }

  @override
  void dispose() {
    super.dispose();
    tmpController?.dispose();
    focusNode!.removeListener(_handleFocusNodeChangeListenerTick);
  }

  ///The focus state returns to refresh the current UI
  void _handleFocusNodeChangeListenerTick() {
    if (focusNode!.hasFocus) {
      border = widget.activeBorder ?? border;
    } else {
      border = widget.normalBorder ?? border;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Container(
            height: widget.maxHeight,
            decoration: BoxDecoration(
              color: widget.innerColor ?? Colors.transparent,
              border:
                  border, //The border radius (`borderRadius`) property that rounds the corners of this container box.
              borderRadius: widget.borderRadius,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                widget.prefixIcon ??
                    const Padding(
                      padding: EdgeInsets.only(left: 14),
                      child: Center(
                        child: Icon(
                          FluentIcons.search_16_regular,
                          size: 20,
                        ),
                      ),
                    ),
                Expanded(
                  child: TextField(
                      maxLength: widget.maxLength,
                      autofocus: widget.autoFocus,
                      textInputAction: widget.textInputAction,
                      focusNode: focusNode,
                      controller: textEditingController,
                      keyboardType: widget.textInputType,
                      inputFormatters: widget.inputFormatters,
                      style: widget.textStyle ?? Get.textTheme.bodyMedium,
                      decoration: InputDecoration(
                        fillColor: Colors.transparent,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.only(
                            left: 8, right: 6, top: 8, bottom: 8),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        //Fill color property, fill the color of the decoration container.
                        //is the dense property, whether the input child is part of a dense form (i.e. uses less vertical space).
                        isDense: true,
                        filled: true,
                        hintStyle: widget.hintStyle,
                        hintText: widget.hintText ?? "Search...",
                        counterText: '',
                      ),
                      //On change property, called when the text being edited changes.
                      onChanged: (content) {
                        if (widget.onTextChange != null) {
                          widget.onTextChange!(content);
                        }
                        setState(() {});
                      },
                      onSubmitted: (content) {
                        if (widget.onTextCommit != null) {
                          widget.onTextCommit!(content);
                        }
                      }),
                ),
                Visibility(
                  visible: searchTextController!.isClearShow,
                  child: GestureDetector(
                    onTap: () {
                      if (widget.onTextClear != null) {
                        bool isIntercept = widget.onTextClear!();
                        if (isIntercept) return;
                      }
                      textEditingController!.clear();
                      if (widget.onTextChange != null) {
                        widget.onTextChange!(textEditingController!.value.text);
                      }
                      setState(() {});
                    },
                    child: Visibility(
                      visible: textEditingController!.text.isNotEmpty,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Icon(
                          FluentIcons.dismiss_16_regular,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Visibility(
          visible: searchTextController!.isActionShow,
          child: widget.action ??
              GestureDetector(
                onTap: () {
                  if (widget.onActionTap != null) {
                    widget.onActionTap!();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text(
                    "Cancel",
                    style: Get.textTheme.bodyMedium,
                  ),
                ),
              ),
        )
      ],
    );
  }
}

///Search box control class, used to control the display of clear icon (x) and cancel button Hide
class WaveSearchTextController extends ChangeNotifier {
  bool _isClearShow = true;
  bool _isActionShow = false;

  bool get isClearShow => _isClearShow;

  bool get isActionShow => _isActionShow;

  ///Set the display and hide of the clear icon
  set isClearShow(bool value) {
    _isClearShow = value;
    notifyListeners();
  }

  ///Set the display and hide of the cancel button
  set isActionShow(bool value) {
    _isActionShow = value;
    notifyListeners();
  }
}
