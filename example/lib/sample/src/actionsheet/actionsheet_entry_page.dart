import 'dart:async';

import 'package:example/sample/widgets.dart';
import 'package:waveui/waveui.dart';
import 'package:example/sample/home/list_item.dart';

class ActionSheetEntryPage extends StatefulWidget {
  final title;

  const ActionSheetEntryPage(this.title, {super.key});

  @override
  _ActionSheetEntryPageState createState() => _ActionSheetEntryPageState();
}

class _ActionSheetEntryPageState extends State<ActionSheetEntryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: WaveAppBar(
          title: widget.title,
        ),
        body: ListView(
          children: <Widget>[
            ListItem(
              title: "CommonActionSheet",
              isShowLine: false,
              describe: 'General style ActionSheet, no independent auxiliary information',
              onPressed: () {
                _showCommonStylex();
              },
            ),
            ListItem(
              title: "Common Action Sheet",
              isShowLine: false,
              describe: 'General style ActionSheet, including description information',
              onPressed: () {
                _showCommonStyle(context);
              },
            ),
            ListItem(
              title: "Common Action Sheet",
              describe: 'General style action sheet, does not contain description information',
              onPressed: () {
                _showCommonStyle1(context);
              },
            ),
            ListItem(
              title: "Common Action Sheet",
              describe: 'Blue style ActionSheet, does not contain description information',
              onPressed: () {
                _showCommonStyle2(context);
              },
            ),
            ListItem(
              title: "Common Action Sheet",
              describe: 'General style ActionSheet, custom textstyle',
              onPressed: () {
                _showCommonCustomStyle(context);
              },
            ),
            ListItem(
              title: "Common Action Sheet",
              describe: 'General style ActionSheet, the option name changes dynamically',
              onPressed: () {
                _showChangeableStyle(context);
              },
            ),
            ListItem(
              title: "Share ActionSheet (7 items)",
              describe: 'Share style ActionSheet',
              onPressed: () {
                _showShareSevenStyle(context);
              },
            ),
            ListItem(
              title: "Share ActionSheet (double line 8 items)",
              describe: 'Share style ActionSheet',
              onPressed: () {
                _showShareFourStyle(context);
              },
            ),
            ListItem(
              title: "Share ActionSheet (double line 3 items)",
              describe: 'Share style ActionSheet',
              onPressed: () {
                _showShareThreeStyle(context);
              },
            ),
            ListItem(
              title: "Share ActionSheet (2 items)",
              describe: 'Share style ActionSheet',
              onPressed: () {
                _showShareTwoStyle(context);
              },
            ),
          ],
        ));
  }

  void _showCommonStyle(BuildContext context) {
    List<WaveCommonActionSheetItem> actions = [];
    actions.add(WaveCommonActionSheetItem(
      'Option 1 (warning item)',
      desc: 'Auxiliary information Auxiliary information Auxiliary information',
      actionStyle: WaveCommonActionSheetItemStyle.alert,
    ));
    actions.add(WaveCommonActionSheetItem(
      'Option two',
      desc: 'Auxiliary information Auxiliary information Auxiliary information',
      actionStyle: WaveCommonActionSheetItemStyle.normal,
    ));
    actions.add(WaveCommonActionSheetItem(
      'Option three',
      desc: 'Auxiliary information Auxiliary information Auxiliary information',
      actionStyle: WaveCommonActionSheetItemStyle.normal,
    ));

    //display actionSheet
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return WaveCommonActionSheet(
            title:
                "Auxiliary content auxiliary content auxiliary content auxiliary content auxiliary content auxiliary content auxiliary content auxiliary content auxiliary content auxiliary content auxiliary content auxiliary content auxiliary content",
            actions: actions,
            cancelTitle: "Custom Cancel Title",
            clickCallBack: (int index, WaveCommonActionSheetItem actionEle) {
              String? title = actionEle.title;
              showSnackBar(
                context,
                msg: "title: , index: ",
              );
            },
          );
        });
  }

  void _showCommonStylex() {
    List<WaveCommonActionSheetItem> actions = [];
    //Build a common item of title + auxiliary information
    actions.add(WaveCommonActionSheetItem(
      'Option 1 (warning item)',
      desc: 'Auxiliary informationAuxiliary informationAuxiliary informationAuxiliary information',
      actionStyle: WaveCommonActionSheetItemStyle.alert,
    ));
    //Build a common item of title + auxiliary information
    actions.add(WaveCommonActionSheetItem(
      'Option two',
      desc: 'Auxiliary information Auxiliary information Auxiliary information',
      actionStyle: WaveCommonActionSheetItemStyle.normal,
    ));
    //Build a normal item with only a title
    actions.add(WaveCommonActionSheetItem(
      'Option three',
      actionStyle: WaveCommonActionSheetItemStyle.normal,
    ));
    //Build actionSheet without title bar
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return WaveCommonActionSheet(
            actions: actions,
            clickCallBack: (int index, WaveCommonActionSheetItem actionEle) {
              String? title = actionEle.title;
              showSnackBar(
                context,
                msg: "title: $title, index: $index",
              );
            },
          );
        });
  }

  void _showCommonStyle1(BuildContext context) {
    List<WaveCommonActionSheetItem> actions = [];
    actions.add(WaveCommonActionSheetItem(
      'Option 1 (warning item)',
      actionStyle: WaveCommonActionSheetItemStyle.alert,
    ));
    actions.add(WaveCommonActionSheetItem(
      'Option two',
      actionStyle: WaveCommonActionSheetItemStyle.normal,
    ));
    actions.add(WaveCommonActionSheetItem(
      'Option three',
      actionStyle: WaveCommonActionSheetItemStyle.normal,
    ));

    //展示actionSheet
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return WaveCommonActionSheet(
            actions: actions,
            clickCallBack: (
              int index,
              WaveCommonActionSheetItem actionEle,
            ) {
              String? title = actionEle.title;
              showSnackBar(
                context,
                msg: "title: $title, index: $index",
              );
            },
          );
        });
  }

  void _showCommonStyle2(BuildContext context) {
    List<WaveCommonActionSheetItem> actions = [];
    actions.add(WaveCommonActionSheetItem(
      'Option 1: (010) 1234567',
      actionStyle: WaveCommonActionSheetItemStyle.link,
    ));
    actions.add(WaveCommonActionSheetItem(
      'Option 2: (010) 1234567',
      actionStyle: WaveCommonActionSheetItemStyle.link,
    ));
    actions.add(WaveCommonActionSheetItem(
      'Option three',
      actionStyle: WaveCommonActionSheetItemStyle.link,
    )); //show actionSheet
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return WaveCommonActionSheet(
            title: "Requirements for blue styles such as telephones",
            actions: actions,
            clickCallBack: (
              int index,
              WaveCommonActionSheetItem actionEle,
            ) {
              String? title = actionEle.title;
              showSnackBar(
                context,
                msg: "title: $title, index: $index",
              );
            },
          );
        });
  }

  void _showCommonCustomStyle(BuildContext context) {
    List<WaveCommonActionSheetItem> actions = [];
    actions.add(
      WaveCommonActionSheetItem(
        'Option 1: Customize the main title style',
        desc: 'Auxiliary information default style',
        titleStyle: const TextStyle(
          fontSize: 18,
          color: Color(0xFF123984),
        ),
      ),
    );
    actions.add(
      WaveCommonActionSheetItem(
        'Option 2: Customize auxiliary information style',
        desc: 'Custom auxiliary information style',
        descStyle: const TextStyle(
          fontSize: 14,
          color: Color(0xFF129834),
        ),
      ),
    );
    actions.add(
      WaveCommonActionSheetItem(
        'Option 3: Custom intercept click event, click is invalid',
        desc: 'Auxiliary information',
        titleStyle: const TextStyle(
          fontSize: 16,
          color: Color(0xFF999999),
        ),
        descStyle: const TextStyle(
          fontSize: 14,
          color: Color(0xFF999999),
        ),
      ),
    );
//display actionSheet
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return WaveCommonActionSheet(
            title:
                "Custom click interception event, option 3 click does not return, click event of other options is normal, and the maximum number of lines of custom title is 3 lines, it will be truncated if it is exceeded",
            actions: actions,
            maxTitleLines: 3,
            clickCallBack: (
              int index,
              WaveCommonActionSheetItem actionEle,
            ) {
              String? title = actionEle.title;
              showSnackBar(
                context,
                msg: "title: $title, index: $index",
              );
            },
            onItemClickInterceptor: (
              int index,
              WaveCommonActionSheetItem actionEle,
            ) {
              //Option 3 The click event is intercepted and not processed
              if (index == 2) {
                showSnackBar(
                  context,
                  msg: "Intercepted",
                );
                return true;
              }
              //Other options are normal
              return false;
            },
          );
        });
  }

  void _showChangeableStyle(BuildContext context) {
    //Countdown times
    var countdown = 10;
    //Used to control the timer to load only once
    var started = false;
    //timer
    late Timer periodTimer;
    List<WaveCommonActionSheetItem> actions = [];
    actions.add(WaveCommonActionSheetItem(
      'Countdown: $countdown',
      actionStyle: WaveCommonActionSheetItemStyle.alert,
    ));
    actions.add(WaveCommonActionSheetItem(
      'Option two',
      actionStyle: WaveCommonActionSheetItemStyle.normal,
    ));
    actions.add(WaveCommonActionSheetItem(
      'Option three',
      actionStyle: WaveCommonActionSheetItemStyle.normal,
    ));
    //display actionSheet
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          //Through statefulBuilder, you can dynamically change the option copy (this example is only for reference, please choose the method according to the specific situation)
          return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
            if (!started) {
              started = true;
              //Set timer, loop every 1 second
              periodTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
                if (countdown > 0) {
                  countdown = countdown - 1;
                  setState(() {
                    //Cycle to refresh the current time and change the title
                    actions[0].title = 'Countdown: $countdown';
                    //Change specific auxiliary information
                    var times = 10 - countdown;
                    actions[0].desc = 'Countdown: $times';
                  });
                } else if (countdown == 0) {
                  periodTimer.cancel();
                }
              });
            }
            return WaveCommonActionSheet(
              actions: actions,
              clickCallBack: (
                int index,
                WaveCommonActionSheetItem actionEle,
              ) {
                //stop timing immediately after click
                periodTimer.cancel();
                var title = actionEle.title;
                showSnackBar(
                  context,
                  msg: "title: $title, index: $index",
                );
              },
            );
          });
          //then is used to stop the timer after the pop, if you don't need to operate after the pop, you don't need to use then
        }).then((value) {
      periodTimer.cancel();
    });
  }

  void _showShareSevenStyle(BuildContext context) {
    List<WaveShareItem> firstRowList = [];
    firstRowList.add(WaveShareItem(
      WaveShareItemConstants.shareWeiXin,
      canClick: true,
    ));
    firstRowList.add(WaveShareItem(
      WaveShareItemConstants.shareBrowser,
      canClick: true,
    ));
    firstRowList.add(WaveShareItem(
      WaveShareItemConstants.shareCopyLink,
      canClick: true,
    ));
    firstRowList.add(WaveShareItem(
      WaveShareItemConstants.shareFriend,
      canClick: true,
    ));
    firstRowList.add(WaveShareItem(
      WaveShareItemConstants.shareLink,
      canClick: true,
    ));
    firstRowList.add(WaveShareItem(
      WaveShareItemConstants.shareQQ,
      canClick: true,
    ));
    firstRowList.add(WaveShareItem(
      WaveShareItemConstants.shareCustom,
      customImage: WaveUITools.getAssetImage("images/icon_custom_share.png"),
      customTitle: "customize",
      canClick: true,
    ));
    WaveShareActionSheet actionSheet = WaveShareActionSheet(
      firstShareChannels: firstRowList,
      clickCallBack: (int section, int index, WaveShareItem shareItem) {
        int channel = shareItem.shareType;
        showSnackBar(
          context,
          msg: "channel: $channel, section: $section, index: $index",
        );
      },
      cancelTitle: "CustomCancel Name", //The title of the cancel button can be customized
    );
    actionSheet.show(context);
  }

  void _showShareFourStyle(BuildContext context) {
    List<WaveShareItem> firstRowList = [];
    List<WaveShareItem> secondRowList = [];
    firstRowList.add(WaveShareItem(
      WaveShareItemConstants.shareQZone,
      canClick: true,
    ));
    firstRowList.add(WaveShareItem(
      WaveShareItemConstants.shareSaveImage,
      canClick: true,
    ));
    firstRowList.add(WaveShareItem(
      WaveShareItemConstants.shareSms,
      canClick: true,
    ));
    firstRowList.add(WaveShareItem(
      WaveShareItemConstants.shareWeiBo,
      canClick: true,
    ));
    secondRowList.add(WaveShareItem(
      WaveShareItemConstants.shareQZone,
      canClick: false,
    ));
    secondRowList.add(WaveShareItem(
      WaveShareItemConstants.shareSaveImage,
      canClick: false,
    ));
    secondRowList.add(WaveShareItem(
      WaveShareItemConstants.shareSms,
      canClick: false,
    ));
    secondRowList.add(WaveShareItem(
      WaveShareItemConstants.shareWeiBo,
      canClick: false,
    ));
    WaveShareActionSheet actionSheet = WaveShareActionSheet(
      firstShareChannels: firstRowList,
      secondShareChannels: secondRowList,
      clickCallBack: (int section, int index, WaveShareItem shareItem) {
        int channel = shareItem.shareType;
        showSnackBar(
          context,
          msg: "channel: $channel, section: $section, index: $index",
        );
      },
      clickInterceptor: (int section, int index, WaveShareItem shareItem) {
        if (shareItem.canClick) {
          return false;
        } else {
          showSnackBar(
            context,
            msg: "Not clickable, blocked",
          );
          return true;
        }
      },
    );
    actionSheet.show(context);
  }

  void _showShareThreeStyle(BuildContext context) {
    List<WaveShareItem> firstRowList = [];
    List<WaveShareItem> secondRowList = [];
    firstRowList.add(WaveShareItem(
      WaveShareItemConstants.shareWeiXin,
      canClick: true,
    ));
    firstRowList.add(WaveShareItem(
      WaveShareItemConstants.shareFriend,
      canClick: true,
    ));
    secondRowList.add(WaveShareItem(
      WaveShareItemConstants.shareCustom,
      customImage: WaveUITools.getAssetImage("images/icon_custom_share.png"),
      customTitle: "自定义",
      canClick: true,
    ));
    WaveShareActionSheet actionSheet = WaveShareActionSheet(
      firstShareChannels: firstRowList,
      secondShareChannels: secondRowList,
      clickCallBack: (int section, int index, WaveShareItem shareItem) {
        int channel = shareItem.shareType;
        showSnackBar(
          context,
          msg: "channel: $channel, section: $section, index: $index",
        );
      },
    );
    actionSheet.show(context);
  }

  void _showShareTwoStyle(BuildContext context) {
    List<WaveShareItem> firstRowList = [];
    firstRowList.add(WaveShareItem(
      WaveShareItemConstants.shareWeiXin,
      canClick: true,
    ));
    firstRowList.add(WaveShareItem(
      WaveShareItemConstants.shareFriend,
      canClick: true,
    ));
    WaveShareActionSheet actionSheet = WaveShareActionSheet(
      firstShareChannels: firstRowList,
      clickCallBack: (int section, int index, WaveShareItem shareItem) {
        int channel = shareItem.shareType;
        showSnackBar(
          context,
          msg: "channel: $channel, section: $section, index: $index",
        );
      },
    );
    actionSheet.show(context);
  }
}
