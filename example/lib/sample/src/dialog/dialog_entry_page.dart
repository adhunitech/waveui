import 'package:example/sample/widgets.dart';
import 'package:waveui/waveui.dart';
import 'package:example/sample/home/list_item.dart';
import 'package:flutter/services.dart';

class DialogEntryPage extends StatelessWidget {
  final String _title;

  const DialogEntryPage(this._title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: WaveAppBar(
          title: _title,
        ),
        body: ListView(
          children: <Widget>[
            ListItem(
              title: "Rich Text Popup",
              isShowLine: false,
              describe: 'Rich text popup',
              onPressed: () {
                _showRichTextDialog(context);
              },
            ),
            ListItem(
              title: "No Title + No Button",
              describe: 'No title, no button',
              onPressed: () {
                _showStyle0Dialog(context);
              },
            ),
            ListItem(
              title: "Untitled + single button",
              describe: 'No title, auxiliary information, single button',
              onPressed: () {
                _showStyle1Dialog(context);
              },
            ),
            ListItem(
              title: "Untitled + single button, single line content",
              describe: 'No title, auxiliary information, single button',
              onPressed: () {
                _showStyle1Dialog0(context);
              },
            ),
            ListItem(
              title: "title+information+double button",
              describe: 'There are titles, double bottom buttons, and auxiliary information as copywriting',
              onPressed: () {
                _showStyle4Dialog(context);
              },
            ),
            ListItem(
              title: "title+information+single button",
              describe: 'Title, single button, auxiliary copywriting',
              onPressed: () {
                _showStyle2Dialog(context);
              },
            ),
            ListItem(
              title: "title+information+single button",
              describe: 'There are titles, single buttons, and [multi-line] auxiliary copywriting',
              onPressed: () {
                _showStyle2_1Dialog(context);
              },
            ),
            ListItem(
              title: "Title+Information+Warning",
              describe: 'Title, single button, auxiliary copywriting',
              onPressed: () {
                _showStyle9Dialog(context);
              },
            ),
            ListItem(
              title: "Title + Information + Custom Alert UI",
              describe: 'Title, single button, auxiliary copywriting',
              onPressed: () {
                _showStyle9_1Dialog(context);
              },
            ),
            ListItem(
              title: "Title+Button",
              describe: 'Double buttons, wrap title',
              onPressed: () {
                _showStyle8Dialog(context);
              },
            ),
            ListItem(
              title: "Icon+title+information+double button",
              describe: 'Double buttons, with header Icon, auxiliary information',
              onPressed: () {
                _showStyle71Dialog(context);
              },
            ),
            ListItem(
              title: "Icon+Title+Single Button",
              describe: 'Single button, with a head Icon',
              onPressed: () {
                _showStyle7Dialog(context);
              },
            ),
            ListItem(
              title: "Multiple buttons + title + information",
              describe: 'There are titles, multi-buttons, and auxiliary information as copywriting',
              onPressed: () {
                _showStyle6Dialog(context);
              },
            ),
            ListItem(
              title: "Multi-button + title",
              describe: 'title, multi-button',
              onPressed: () {
                _showStyle5_1Dialog(context);
              },
            ),
            ListItem(
              title: "Multiple buttons + information",
              describe: 'Untitled, multi-button, auxiliary information is copy',
              onPressed: () {
                _showStyle5Dialog(context);
              },
            ),
            ListItem(
              title: "title+information+input+button",
              describe: 'There is an input box in the middle',
              onPressed: () {
                _showMiddleInputDialog(context);
              },
            ),
            ListItem(
              title: "title+input+button",
              describe: 'There is an input box in the middle',
              onPressed: () {
                _showMiddleInputDialog2(context);
              },
            ),
            ListItem(
              title: "title+input+button",
              describe: 'There is an input box in the middle, set the maximum height',
              onPressed: () {
                _showMiddleInputDialog3(context);
              },
            ),
            ListItem(
              title: "title+radio option+button",
              describe: 'Middle radio box (SingleSelectDialogWidget)',
              onPressed: () {
                _showMiddleSingleSelectPicker(context);
              },
            ),
            ListItem(
              title: "Title+Multi-choice option+Button",
              describe: 'MultiSelectDialog in the middle (MultiSelectDialog)',
              onPressed: () {
                _showMiddleMultiSelectDialog(context);
              },
            ),
            ListItem(
              title: "Title + Prompt Text + Multiple Choice Options + Button",
              describe: 'MultiSelectDialog in the middle (MultiSelectDialog)',
              onPressed: () {
                _showMiddleMultiSelectWithMessageDialog(context);
              },
            ),
            ListItem(
              title: "Title+Prompt Information Widget+Multi-choice option+Button",
              describe: 'MultiSelectDialog in the middle (MultiSelectDialog)',
              onPressed: () {
                _showMiddleMultiSelectWithMessageWidgetDialog(context);
              },
            ),
            ListItem(
              title: "Loading Dialog",
              describe: 'LoadingDialog Example',
              onPressed: () {
                _showWaveLoadingDialog(context);
              },
            ),
            ListItem(
              title: "Safe Dialog",
              describe: 'You can safely pop the Dialog to prevent the page from being closed by mistake',
              onPressed: () {
                _showSafeDialog(context);
              },
            ),
            ListItem(
              title: "Share Dialog",
              describe: 'Share Dialog (five icons)',
              onPressed: () {
                _showWaveShareDialog5(context);
              },
            ),
            ListItem(
              title: "Share Dialog",
              describe: 'Share Dialog (3 icons)',
              onPressed: () {
                _showWaveShareDialog3(context);
              },
            ),
            ListItem(
              title: "Two Vertical Button Dialog (single button)",
              describe: 'Primary and secondary buttons Dialog',
              onPressed: () {
                _showWaveOneVerticalButtonDialogDialog(context);
              },
            ),
            ListItem(
              title: "Two Vertical Button Dialog",
              describe: 'Primary and secondary buttons Dialog',
              onPressed: () {
                _showWaveTwoVerticalButtonDialogDialog(context);
              },
            ),
            ListItem(
              title: "Plain text bullet box",
              describe: 'title+plain text content+button',
              onPressed: () {
                _showStyle81Dialog(context);
              },
            ),
            ListItem(
              title: "Plain text box contains rich text",
              describe: 'Title + plain text content with rich text + button',
              onPressed: () {
                _showStyle82Dialog(context);
              },
            ),
            ListItem(
              title: "Plain text pop-up box has no title",
              describe: 'plain content + button',
              onPressed: () {
                _showStyle83Dialog(context);
              },
            ),
            ListItem(
              title: "Plain text box without action button",
              describe: 'Title + pure text content',
              onPressed: () {
                _showStyle84Dialog(context);
              },
            ),
          ],
        ));
  }

  void _showMiddleSingleSelectPicker(BuildContext context) {
    String hintText = "Interested to follow up";
    int selectedIndex = 0;
    var conditions = [
      "Interested to follow up",
      "Interested but not interested in this business district",
      "not connected",
      "connected",
      "Number error",
      "dasdasda",
      "asdasfdg",
      "dadsadvq",
      "vzxczxc"
    ];
    showDialog(
        context: context,
        builder: (_) => StatefulBuilder(
              builder: (context, state) {
                return WaveSingleSelectDialog(
                    isClose: true,
                    title: 'Please select the reason for invalid customer source',
                    messageText:
                        'Please rate this thread Please rate this thread Please rate this thread Please rate this thread Please rate this thread',
                    conditions: conditions,
                    checkedItem: conditions[selectedIndex],
                    submitText: 'Submit',
                    isCustomFollowScroll: true,
                    customWidget: TextField(
                      //cursor color
                      maxLines: 2,
                      cursorColor: const Color(0xFF0984F9),
                      //Cursor rounded radian
                      cursorRadius: const Radius.circular(2.0),
                      style: const TextStyle(fontSize: 14, color: Color(0xFF222222)),
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      onChanged: (value) {},
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(8.0),
                        hintText: hintText,
                        hintStyle: const TextStyle(fontSize: 14, color: Color(0xFFCCCCCC)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2.0),
                            borderSide: const BorderSide(
                              width: 0.5,
                              color: Color(0xFFCCCCCC),
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2.0),
                            borderSide: const BorderSide(
                              width: 0.5,
                              color: Color(0xFFCCCCCC),
                            )),
                      ),
                    ),
                    onItemClick: (BuildContext context, int index) {
                      hintText = conditions[index];
                      selectedIndex = index;
                      state(() {});
                    },
                    onSubmitClick: (data) {
                      showSnackBar(context, msg: data!);
                    });
              },
            ));
  }

  ///Multiple selection popup
  void _showMiddleMultiSelectDialog(BuildContext context) {
    List<MultiSelectItem> data = [];
    data.add(MultiSelectItem("100", "interested to follow up"));
    data.add(MultiSelectItem("101", "interested but not interested in this business district", isChecked: true));
    data.add(MultiSelectItem("102", "Hang up/not interested after connected", isChecked: true));
    data.add(MultiSelectItem("103", "not connected"));
    data.add(MultiSelectItem("104", "Complaint threat"));
    data.add(MultiSelectItem("104", "Number error"));
    data.add(MultiSelectItem("104", "Number error"));
    data.add(MultiSelectItem("104", "Number error"));
    showDialog(
        context: context,
        builder: (_) => WaveMultiSelectDialog(
            title: "Please rate this thread",
            isClose: true,
            conditions: data,
            onSubmitClick: (List<MultiSelectItem> data) {
              var str = "";
              for (var item in data) {
                str = "$str${item.content} ";
              }
              showSnackBar(
                context,
                msg: str,
              );
              return true;
            }));
  }

  void _showMiddleMultiSelectWithMessageWidgetDialog(BuildContext context) {
    String hintText = "Interested to follow up";
    List<MultiSelectItem> data = [];
    data.add(MultiSelectItem("100", "interested to follow up"));
    data.add(MultiSelectItem("101", "interested but not interested in this business district", isChecked: true));
    data.add(MultiSelectItem("102", "Hang up/not interested after connected", isChecked: true));
    data.add(MultiSelectItem("102", "Hang up/not interested after connected", isChecked: true));
    data.add(MultiSelectItem("103", "not connected"));
    data.add(MultiSelectItem("103", "not connected"));
    data.add(MultiSelectItem("104", "Others"));
    showDialog(
        context: context,
        builder: (_) => StatefulBuilder(builder: (context, state) {
              return WaveMultiSelectDialog(
                  title: "Please rate this clue Widget",
                  messageWidget: const Row(
                    children: <Widget>[
                      Text(
                        "Choose the reason for giving up (multiple choice)",
                        style: cContentTextStyle,
                      ),
                    ],
                  ),
                  isClose: true,
                  conditions: data,
                  isCustomFollowScroll: false,
                  customWidget: TextField(
                    //cursor color
                    maxLines: 2,
                    cursorColor: const Color(0xFF0984F9),
                    //Cursor rounded radian
                    cursorRadius: const Radius.circular(2.0),
                    style: const TextStyle(fontSize: 14, color: Color(0xFF222222)),
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    onChanged: (value) {},
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(8.0),
                      hintText: hintText,
                      hintStyle: const TextStyle(fontSize: 14, color: Color(0xFFCCCCCC)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2.0),
                          borderSide: const BorderSide(
                            width: 0.5,
                            color: Color(0xFFCCCCCC),
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2.0),
                          borderSide: const BorderSide(
                            width: 0.5,
                            color: Color(0xFFCCCCCC),
                          )),
                    ),
                  ),
                  onItemClick: (BuildContext context, int index) {
                    hintText = data[index].content;
                    state(() {});
                  },
                  onSubmitClick: (List<MultiSelectItem> data) {
                    var str = "";
                    for (var item in data) {
                      str = "$str${item.content}  ";
                    }
                    showSnackBar(
                      context,
                      msg: str,
                    );
                    return true;
                  });
            }));
  }

  ///Multiple selection popup
  void _showMiddleMultiSelectWithMessageDialog(BuildContext context) {
    List<MultiSelectItem> data = [];
    data.add(MultiSelectItem("100", "interested to follow up"));
    data.add(MultiSelectItem("101", "interested but not interested in this business district", isChecked: true));
    data.add(MultiSelectItem("102", "Hang up/not interested after connected", isChecked: true));
    data.add(MultiSelectItem("103", "not connected"));
    data.add(MultiSelectItem("104", "Complaint threat"));
    data.add(MultiSelectItem("104", "Number error"));
    data.add(MultiSelectItem("104", "Number error"));
    data.add(MultiSelectItem("104", "Number error"));
    showDialog(
        context: context,
        builder: (_) => WaveMultiSelectDialog(
            title: "Please rate this thread",
            messageText:
                'Please rate this thread Please rate this thread Please rate this thread Please rate this thread Please rate this thread',
            isClose: true,
            conditions: data,
            onSubmitClick: (List<MultiSelectItem> data) {
              var str = "";
              for (var item in data) {
                str = "$str${item.content} ";
              }
              showSnackBar(
                context,
                msg: str,
              );
              return true;
            }));
  }

  ///Universal bullet box
  void _showRichTextDialog(BuildContext context) {
    WaveDialogManager.showConfirmDialog(context,
        cancel: "Cancel",
        confirm: "OK",
        title: "Title",
        message:
            "Auxiliary content information Auxiliary content information Auxiliary content information Auxiliary content information Auxiliary content information",
        messageWidget: Padding(
          padding: const EdgeInsets.only(top: 6, left: 24, right: 24),
          child: WaveCSS2Text.toTextView(
              "This is an example that uses tags to modify the text color<font color = '#8ac6d1'>I am a colored text</font>,"
              "This is the text behind the color label", linksCallback: (String? text, String? linkUrl) {
            showSnackBar(
              context,
              msg: '$text clicked! Url is $linkUrl',
            );
          }),
        ),
        showIcon: true, onConfirm: () {
      showSnackBar(
        context,
        msg: "OK",
      );
    }, onCancel: () {
      Navigator.pop(context);
    });
  }

  ///There is an input box in the middle
  void _showMiddleInputDialog(BuildContext context) {
    WaveMiddleInputDialog(
        title: 'Refuse reason dismissOnActionsTap Click Action does not disappear',
        message:
            "Only numbers can be entered. Secondary content Secondary content Secondary content Secondary content Secondary content Secondary content Secondary content Secondary content Secondary content Secondary content ",
        hintText: 'hint information',
        cancelText: 'Cancel',
        confirmText: 'OK',
        autoFocus: true,
        maxLength: 1000,
        maxLines: 2,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        textInputAction: TextInputAction.done,
        dismissOnActionsTap: false,
        barrierDismissible: true,
        onConfirm: (value) {
          showSnackBar(context, msg: value);
        },
        onCancel: () {
          showSnackBar(
            context,
            msg: "Cancel",
          );
          Navigator.pop(context);
        }).show(context);
  }

  ///There is an input box in the middle
  void _showMiddleInputDialog2(BuildContext context) {
    WaveMiddleInputDialog(
        title: 'Reason for rejection',
        hintText: 'hint information',
        cancelText: 'Cancel',
        confirmText: 'OK',
        maxLength: 1000,
        maxLines: 2,
        barrierDismissible: false,
        inputEditingController: TextEditingController()..text = 'bbb',
        textInputAction: TextInputAction.done,
        onConfirm: (value) {
          showSnackBar(context, msg: value);
        },
        onCancel: () {
          showSnackBar(
            context,
            msg: "取消",
          );
          Navigator.pop(context);
        }).show(context);
  }

  ///中间有输入框弹框
  void _showMiddleInputDialog3(BuildContext context) {
    WaveMiddleInputDialog(
        title: 'Reason for refusal -test limit input up to 10 characters',
        hintText: 'hint information',
        cancelText: 'Cancel',
        confirmText: 'OK',
        maxLength: 10,
        barrierDismissible: false,
        textInputAction: TextInputAction.done,
        onConfirm: (value) {
          showSnackBar(context, msg: value);
        },
        onCancel: () {
          showSnackBar(
            context,
            msg: "Cancel",
          );
          Navigator.pop(context);
        }).show(context);
  }

  ///Dialog box style 1: no title, single button
  void _showStyle1Dialog0(BuildContext context) {
    WaveDialogManager.showSingleButtonDialog(context, label: "Got it", message: "Auxiliary content information",
        onTap: () {
      showSnackBar(context, msg: 'Got it');
      Navigator.pop(context);
    });
  }

  ///Dialog box style 1: no title, single button
  void _showStyle0Dialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return const WaveDialog(
          messageText:
              "Auxiliary content information Auxiliary content information Auxiliary content information Auxiliary content information Auxiliary content information",
          actionsText: [],
        );
      },
    );
  }

  ///Dialog box style 1: no title, single button
  void _showStyle1Dialog(BuildContext context) {
    WaveDialogManager.showSingleButtonDialog(context,
        label: "Got it",
        message:
            "Supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information",
        onTap: () {
      showSnackBar(context, msg: 'Got it');
      Navigator.pop(context);
    });
  }

  ///Dialog box style 2: with title, single button, and auxiliary copy
  void _showStyle2Dialog(BuildContext context) {
    WaveDialogManager.showSingleButtonDialog(context,
        title: "Title Content",
        label: "Got it",
        message:
            "Auxiliary content information Auxiliary content information Auxiliary content information Auxiliary content information Auxiliary content information",
        onTap: () {
      showSnackBar(context, msg: 'Got it');
      Navigator.pop(context);
    });
  }

  ///Dialog box style 2: There are titles, single buttons, and too many auxiliary texts, slide up and down to display
  void _showStyle2_1Dialog(BuildContext context) {
    WaveDialogManager.showSingleButtonDialog(context,
        title: "Title Content",
        label: "Got it",
        messageWidget: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 300),
            child: const SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: 8, left: 24, right: 24),
                child: Center(
                  child: Text(
                    'Auxiliary content information auxiliary content information auxiliary content information auxiliary content information auxiliary content information auxiliary content information auxiliary content information auxiliary content information auxiliary content information auxiliary content information auxiliary content information auxiliary content information auxiliary content information auxiliary content information auxiliary content information auxiliary content information auxiliary content information auxiliary content information auxiliary content information auxiliary content information auxiliary content information auxiliary content information auxiliary content information auxiliary content information auxiliary content information auxiliary content information auxiliary content information auxiliary content information auxiliary content information auxiliary content information content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information Content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information Content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information supplement content information Content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information supplementary content information Content Information Assistance Content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Supplementary content information Information auxiliary content information auxiliary content information auxiliary content information auxiliary content information auxiliary content information auxiliary content information auxiliary content information auxiliary content information auxiliary content information auxiliary content information auxiliary content information AAA',
                    style: cContentTextStyle,
                    textAlign: cContentTextAlign,
                  ),
                ),
              ),
            )), onTap: () {
      showSnackBar(context, msg: 'Got it');
      Navigator.pop(context);
    });
  }

  ///Dialog box style 4: There are titles, two buttons at the bottom, and auxiliary information is copywriting
  void _showStyle4Dialog(BuildContext context) {
    WaveDialogManager.showConfirmDialog(context,
        title: "Are you sure to follow me?",
        cancel: 'Cancel',
        confirm: 'OK',
        message:
            "Auxiliary content information auxiliary content information auxiliary content information auxiliary content information auxiliary content information",
        onConfirm: () {
      showSnackBar(
        context,
        msg: "OK",
      );
    }, onCancel: () {
      showSnackBar(
        context,
        msg: "Cancel",
      );
      Navigator.pop(context);
    });
  }

  ///Dialog box style five: Multi-button auxiliary information is copywriting Untitled
  void _showStyle5_1Dialog(BuildContext context) {
    WaveDialogManager.showMoreButtonDialog(context,
        actions: [
          'Option one',
          'Option two',
          'Option three',
        ],
        title:
            "title title title title title title title title title title title title title title title title title title title title title",
        indexedActionClickCallback: (index) {
      showSnackBar(
        context,
        msg: "$index",
      );
    });
  }

  ///Dialog box style five: Multi-button auxiliary information is copywriting Untitled
  void _showStyle5Dialog(BuildContext context) {
    WaveDialogManager.showMoreButtonDialog(context,
        actions: [
          'Option one',
          'Option two',
          'Option three',
        ],
        message:
            "Auxiliary content information Auxiliary content information Auxiliary content information Auxiliary content information Auxiliary content information",
        indexedActionClickCallback: (index) {
      showSnackBar(
        context,
        msg: "$index",
      );
    });
  }

  ///Dialog box style six: multiple buttons with titles and auxiliary information as copywriting
  void _showStyle6Dialog(BuildContext context) {
    WaveDialogManager.showMoreButtonDialog(context,
        title: "Are you sure to follow me?",
        actions: [
          'Option one',
          'Option two',
          'Option three',
        ],
        message:
            "Auxiliary content information Auxiliary content information Auxiliary content information Auxiliary content information Auxiliary content information",
        indexedActionClickCallback: (index) {
      showSnackBar(
        context,
        msg: "$index",
      );
    });
  }

  ///Dialog box style 7.1: single button with header icon, auxiliary information as copy
  void _showStyle71Dialog(BuildContext context) {
    WaveDialogManager.showConfirmDialog(context,
        showIcon: true,
        iconWidget: WaveUITools.getAssetImage("icons/icon_warning.png"),
        title: "This is a custom icon display",
        confirm: "OK",
        cancel: "Cancel",
        message:
            "Auxiliary content information auxiliary content information auxiliary content information auxiliary content information auxiliary content information",
        onConfirm: () {
      showSnackBar(
        context,
        msg: "OK",
      );
    }, onCancel: () {
      showSnackBar(
        context,
        msg: "Cancel",
      );
      Navigator.pop(context);
    });
  }

  ///Dialog box style seven: single button with header icon, auxiliary information as copy
  void _showStyle7Dialog(BuildContext context) {
    WaveDialogManager.showSingleButtonDialog(context,
        showIcon: true, title: "Congratulations, you have completed the filling", label: "OK", onTap: () {
      showSnackBar(
        context,
        msg: "OK",
      );
      Navigator.pop(context);
    });
  }

  ///Dialog box style eight: two buttons, wrap title
  void _showStyle8Dialog(BuildContext context) {
    WaveDialogManager.showConfirmDialog(context,
        title: "title content, title content, title content title content, title content title content, title content",
        cancel: 'Cancel',
        confirm: 'OK', onConfirm: () {
      showSnackBar(
        context,
        msg: "OK",
      );
    }, onCancel: () {
      showSnackBar(
        context,
        msg: "Cancel",
      );
      Navigator.pop(context);
    });
  }

  ///Dialog box style nine: Standard dialog box: with title, double buttons, warning text and auxiliary information
  void _showStyle9Dialog(BuildContext context) {
    WaveDialogManager.showConfirmDialog(context,
        title: "Title content?",
        cancel: 'Cancel',
        confirm: 'OK',
        warning: 'Warning text',
        message:
            "Auxiliary content information auxiliary content information auxiliary content information auxiliary content information auxiliary content information",
        onConfirm: () {
      showSnackBar(
        context,
        msg: "OK",
      );
    }, onCancel: () {
      showSnackBar(
        context,
        msg: "Cancel",
      );
      Navigator.pop(context);
    });
  }

  ///Dialog box style nine: Standard dialog box: with title, double buttons, warning text and auxiliary information
  void _showStyle9_1Dialog(BuildContext context) {
    bool? status = false;
    WaveDialogManager.showConfirmDialog(context,
        title: "Title content?",
        cancel: 'Cancel',
        confirm: 'OK',
        warningWidget: StatefulBuilder(builder: (context, setState) {
          return Row(children: <Widget>[
            Checkbox(
              value: status,
              onChanged: (bool? aaa) {
                status = aaa;
                setState(() {});
              },
            ),
            const Expanded(
                child: Text(
                    'This is a test protocol, la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la'))
          ]);
        }),
        message:
            "Auxiliary content information Auxiliary content information Auxiliary content information Auxiliary content information Auxiliary content information",
        onConfirm: () {
          showSnackBar(
            context,
            msg: "OK",
          );
        },
        onCancel: () {
          showSnackBar(
            context,
            msg: "Cancel",
          );
          Navigator.pop(context);
        });
  }

  ///There is an input box at the bottom
  void _showWaveLoadingDialog(BuildContext context) {
    Future.delayed(const Duration(seconds: 5)).then((_) {
      const Center(
        child: CircularProgressIndicator(),
      );
    });
  }

  ///Safely closed pop-up box
  void _showSafeDialog(BuildContext context) {
    WaveSafeDialog.show(
        context: context,
        tag: "AA",
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }).then((result) {
      showSnackBar(context, msg: 'result: $result ');
    });

    WaveSafeDialog.show(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }).then((result) {
      showSnackBar(context, msg: 'result: $result ');
    });

    Future.delayed(const Duration(seconds: 5)).then((_) {
      WaveSafeDialog.dismiss(context: context, tag: "AA", result: 'delete dialog AA by tag AA');
    });

    Future.delayed(const Duration(seconds: 10)).then((_) {
      WaveSafeDialog.dismiss(context: context, result: 'delete dialog BB by default tag');
    });
  }

  void _showWaveShareDialog3(BuildContext context) {
    WaveShareDialog waveShareDialog = WaveShareDialog(
      context: context,
      shareChannels: const [
        WaveShareItemConstants.shareWeiXin,
        WaveShareItemConstants.shareLink,
        WaveShareItemConstants.shareCustom
      ],
      titleText: "Test Title",
      descText:
          "Test Auxiliary Information Test Auxiliary Information Test Auxiliary Information Test Auxiliary Information Test Auxiliary Information",
      clickCallBack: (int channel, int index) {
        showSnackBar(
          context,
          msg: "channel: $channel, index: $index",
        );
      },
      getCustomChannelWidget: (int index) {
        if (index == 2) {
          return WaveUITools.getAssetImage("images/icon_custom_share.png");
        } else {
          return null;
        }
      },
      //custom icon
      getCustomChannelTitle: (int index) {
        if (index == 2) {
          return "custom";
        } else {
          return null;
        }
      }, //custom name
    );
    waveShareDialog.show();
  }

  void _showWaveShareDialog5(BuildContext context) {
    WaveShareDialog waveShareDialog = WaveShareDialog(
      context: context,
      shareChannels: const [
        WaveShareItemConstants.shareWeiXin,
        WaveShareItemConstants.shareCustom,
        WaveShareItemConstants.shareCustom,
        WaveShareItemConstants.shareLink,
        WaveShareItemConstants.shareCustom
      ],
      titleText: "Test Title",
      descText:
          "Test Auxiliary Information Test Auxiliary Information Test Auxiliary Information Test Auxiliary Information Test Auxiliary Information",
      clickCallBack: (int channel, int index) {
        showSnackBar(
          context,
          msg: "channel: $channel, index: $index",
        );
      },
      getCustomChannelWidget: (int index) {
        if (index == 1) {
          return WaveUITools.getAssetImage("images/icon_custom_share.png");
        } else if (index == 2)
          return WaveUITools.getAssetImage("images/icon_custom_share.png");
        else if (index == 4)
          return WaveUITools.getAssetImage("images/icon_custom_share.png");
        else
          return null;
      },
      //自定义图标
      getCustomChannelTitle: (int index) {
        if (index == 1) {
          return "custom";
        } else if (index == 2)
          return "custom";
        else if (index == 4)
          return "custom";
        else
          return null;
      }, //custom name
    );
    waveShareDialog.show();
  }

  void _showWaveTwoVerticalButtonDialogDialog(BuildContext context) {
    WaveEnhanceOperationDialog waveShareDialog = WaveEnhanceOperationDialog(
      context: context,
      iconType: WaveDialogConstants.iconAlert,
      titleText: "Strong Prompt Text",
      descText:
          "Here is the copy here is the copy here is the copy here is the copy here is the copy here is the copy here is the copy here is the copy",
      mainButtonText: "Main button",
      secondaryButtonText: "Secondary information can be clicked",
      onMainButtonClick: () {
        print("Primary button");
      },
      onSecondaryButtonClick: () {
        print("Secondary button");
      },
    );
    waveShareDialog.show();
  }

  void _showWaveOneVerticalButtonDialogDialog(BuildContext context) {
    WaveEnhanceOperationDialog waveShareDialog = WaveEnhanceOperationDialog(
      iconType: WaveDialogConstants.iconWarning,
      context: context,
      titleText: "Strong Prompt Text",
      descText:
          "Here is the copy here is the copy here is the copy here is the copy here is the copy here is the copy here is the copy here is the copy",
      mainButtonText: "I know",
      onMainButtonClick: () {
        print("Primary button");
      },
    );
    waveShareDialog.show();
  }

  void _showStyle82Dialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => WaveScrollableTextDialog(
            title: "plain text title",
            contentText:
                "Pure text means pure text<font color = '#008886'>Pure text means pure</font>This text means pure text<a href= 'www.baidu.com'>XXXXX</a>Pure text means pure text means pure text means pure text means pure text"
                "It means pure text? It means pure text? It means pure text? It means pure text? It means pure text? It means pure text?"
                "This text means pure text? This text means pure text? This text means pure text? This text means pure text?"
                "Show pure text? Table pure text? Table pure text? Table pure text? Table pure text? Table pure text? Table pure text? Table pure text?"
                "Pure text means pure text? represents pure text? represents pure text? represents pure text? represents pure text? represents pure text? represents pure text? represents pure text? represents pure text."
                "It's pure text? It's pure text? It's pure text?"
                "It means pure text? It means pure text? It means pure text? It means pure text? It means pure text. It means pure text. It means pure text. It means pure text."
                "Wen means pure text? represents pure text? represents pure text? represents pure text? represents pure text? represents pure text? represents pure text? represents pure text? represents pure text?"
                "It means pure text? It means pure text. It means pure text. It means pure text. It means pure text. "
                "Wen means pure text, pure text, pure text, pure text, pure text, pure text, pure text, pure text "
                "This table is pure text? table pure text? table pure text? table pure text? table pure text? table pure text? table pure text? table pure text? table pure text? table",
            submitText: "Submit",
            linksCallback: (String? text, String? url) {
              showSnackBar(context, msg: text!);
            },
            onSubmitClick: () {
              showSnackBar(
                context,
                msg: "Clicked the plain text box",
              );
            }));
  }

  void _showStyle81Dialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => WaveScrollableTextDialog(
            title:
                "Title in plain text Title in plain text Title in plain text Title in plain text Title in plain text Title in plain text",
            contentText: "pure text means pure text means pure text means pure text means pure text means pure text"
                "Show pure text? table pure text? table pure text? table pure text? table pure text? table pure text? table"
                "Pure text means pure text? represents pure text? represents pure text? represents pure text? represents pure text? represents pure text"
                "Wen means pure text? represents pure text? represents pure text? represents pure text? represents pure text?"
                "It's pure text? It's pure text. It's pure text. It's pure text. It's pure text. It's pure text. It's pure text."
                "Wen it means pure text? It means pure text. It means pure text. It means pure text. It means pure text. It means pure text."
                "It's pure text? It's pure text. It's pure text. It's pure text. It's pure text. It's pure text. It's pure."
                "This text represents pure text? represents pure text? represents pure text? represents pure text? represents pure text? represents pure text",
            submitText: "Submit",
            onSubmitClick: () {
              showSnackBar(
                context,
                msg: "Clicked the plain text box",
              );
            }));
  }

  void _showStyle83Dialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => WaveScrollableTextDialog(
            title: "plain text title plain text",
            isClose: false,
            contentText: "pure text means pure text means pure text means pure text means pure text means pure text"
                "Show pure text? table pure text? table pure text? table pure text? table pure text? table pure text? table"
                "Pure text means pure text? represents pure text? represents pure text? represents pure text? represents pure text? represents pure text"
                "Wen means pure text? represents pure text? represents pure text? represents pure text? represents pure text?"
                "It's pure text? It's pure text. It's pure text. It's pure text. It's pure text. It's pure text. It's pure text."
                "Wen it means pure text? It means pure text. It means pure text. It means pure text. It means pure text. It means pure text."
                "It's pure text? It's pure text. It's pure text. It's pure text. It's pure text. It's pure text. It's pure."
                "This text represents pure text? represents pure text? represents pure text? represents pure text? represents pure text? represents pure text",
            submitText: "Submit",
            onSubmitClick: () {
              showSnackBar(
                context,
                msg: "Clicked the plain text box",
              );
              Navigator.of(context).pop();
            }));
  }

  void _showStyle84Dialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => const WaveScrollableTextDialog(
              title: "plain text title plain text",
              contentText: "pure text means pure text means pure text means pure text means pure text means pure text"
                  "Show pure text? table pure text? table pure text? table pure text? table pure text? table pure text? table"
                  "Pure text means pure text? represents pure text? represents pure text? represents pure text? represents pure text? represents pure text"
                  "Wen means pure text? represents pure text? represents pure text? represents pure text? represents pure text?"
                  "It's pure text? It's pure text. It's pure text. It's pure text. It's pure text. It's pure text. It's pure text."
                  "Wen it means pure text? It means pure text. It means pure text. It means pure text. It means pure text. It means pure text."
                  "It's pure text? It's pure text. It's pure text. It's pure text. It's pure text. It's pure text. It's pure."
                  "This text represents pure text? represents pure text? represents pure text? represents pure text? represents pure text? represents pure text",
              isShowOperateWidget: false,
            ));
  }
}
