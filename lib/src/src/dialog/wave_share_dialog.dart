import 'package:waveui/src/src/dialog/wave_dialog.dart';
import 'package:waveui/src/src/dialog/wave_dialog_utils.dart';
import 'package:waveui/src/constants/wave_asset_constants.dart';
import 'package:waveui/src/constants/wave_constants.dart';
import 'package:waveui/src/l10n/wave_intl.dart';
import 'package:waveui/src/theme/wave_theme_configurator.dart';
import 'package:waveui/src/theme/configs/wave_dialog_config.dart';
import 'package:waveui/src/utils/wave_tools.dart';
import 'package:flutter/material.dart';

/// 点击item回调
/// shareChannel 是分享渠道一般传入 [WaveShareItemConstants] 下的值
typedef WaveShareDialogItemClickCallBack = void Function(int shareChannel, int customIndex);

/// 获取自定义分享item标题
/// index为自定义分享item索引
typedef WaveShareDialogGetCustomShareItemTitle = String? Function(int index);

/// 获取自定义分享item图标
/// index为自定义分享item索引
typedef WaveShareDialogGetCustomShareItemIcon = Widget? Function(int index);

// ignore: must_be_immutable
class WaveShareDialog extends StatelessWidget {
  final BuildContext context;

  /// 标题文本
  final String titleText;

  /// 弹框辅助信息文案，为空则不显示辅助信息
  final String? descText;

  /// 文案与分享渠道图标间的分割线内嵌文案
  final String? separatorText;

  /// 分享渠道列表
  final List<int> shareChannels;

  /// 标题颜色，默认值 Color(0xff222222)
  final Color titleColor;

  /// 分享渠道文案颜色，默认值 Color(0xff666666)
  final Color descColor;

  /// 分享文本颜色，Color(0xff999999)
  final Color shareTextColor;

  /// 分割线颜色，默认值 Color(0xffEEEEEE)
  final Color separatorLineColor;

  /// 点击事件
  final WaveShareDialogItemClickCallBack? clickCallBack;

  /// 回调获取名称
  final WaveShareDialogGetCustomShareItemTitle? getCustomChannelTitle;

  /// 回调获取图片(Widget)
  final WaveShareDialogGetCustomShareItemIcon? getCustomChannelWidget;

  /// dialog配置
  WaveDialogConfig? themeData;

  WaveShareDialog({
    super.key,
    required this.context,
    required this.titleText,
    this.descText,
    this.separatorText,
    required this.shareChannels,
    this.clickCallBack,
    this.getCustomChannelTitle,
    this.getCustomChannelWidget,
    this.titleColor = const Color(0xff222222),
    this.descColor = const Color(0xff666666),
    this.shareTextColor = const Color(0xff999999),
    this.separatorLineColor = const Color(0xfff0f0f0),
    this.themeData,
  }) {
    themeData ??= WaveDialogConfig();
    themeData = WaveThemeConfigurator.instance.getConfig(configId: themeData!.configId).dialogConfig.merge(themeData);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: WaveDialog(
        titleWidget: _configDialogTitle(),
        messageText: descText,
        divider: const Divider(
          color: Colors.transparent,
          height: 0,
          thickness: 0,
        ),
        actionsWidget: <Widget>[
          Container(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _configDialogWidgets(),
            ),
          ),
        ],
      ),
    );
  }

  /// dialog弹出
  show() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return this;
        }).then((value) {
      if (value != null) {
        List info = value;
        if (info.length >= 2) {
          if (clickCallBack != null) {
            clickCallBack!(info[0], info[1]);
          }
        }
      }
    });
  }

  /// 构建widgets框架
  List<Widget> _configDialogWidgets() {
    List<Widget> widgets = [];
    widgets.add(_configDialogseparator());
    //分割
    widgets.add(const Padding(
      padding: EdgeInsets.only(top: 12),
    ));
    widgets.add(_configDialogShareItems());
    return widgets;
  }

  /// 构建头部部分
  Widget _configDialogTitle() {
    return Stack(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(top: 28),
          child: Text(
            titleText,
            style: WaveDialogUtils.getDialogTitleStyle(themeData!),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: GestureDetector(
            child: SizedBox(
              width: 30,
              height: 30,
              child: WaveUITools.getAssetImage(WaveAsset.iconPickerClose),
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        )
      ],
    );
  }

  /// 构建中间分割部分
  Widget _configDialogseparator() {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            color: separatorLineColor,
            height: 1,
          ),
          Container(
            color: const Color(0xffffffff),
            padding: const EdgeInsets.only(left: 6, right: 6),
            child: Text(
              separatorText ?? WaveIntl.of(context).localizedResource.shareWayTip,
              style: TextStyle(fontSize: 12, color: shareTextColor),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建分享途径部分
  Widget _configDialogShareItems() {
    List<Widget> shareItems = [];
    String? title; // 标题
    Widget? image; // 图片路径
    for (int index = 0; index < shareChannels.length; index++) {
      title = null;
      image = null;
      if (shareChannels[index] == WaveShareItemConstants.shareCustom) {
        // 获取自定义channel信息
        if (getCustomChannelTitle != null) {
          title = getCustomChannelTitle!(index);
        }
        if (getCustomChannelTitle != null) {
          image = getCustomChannelWidget!(index);
        }
      } else {
        // 获取自预设channel信息
        title = WaveIntl.of(context).localizedResource.shareChannels[shareChannels[index]];
        image = WaveUITools.getAssetImage(WaveShareItemConstants.shareItemImagePathList[shareChannels[index]]);
      }
      //如果没图或没文字则不显示
      if (title == null || image == null) {
        continue;
      }
      // “分享”按钮容器
      shareItems.add(SizedBox(
        width: 39,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            GestureDetector(
              child: SizedBox(
                width: 39,
                height: 39,
                child: image,
              ),
              onTap: () {
                Navigator.of(context).pop([shareChannels[index], index]);
              },
            ),
            const Divider(
              height: 5,
              color: Colors.transparent,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: shareTextColor),
            )
          ],
        ),
      ));
    }
    double space = (shareItems.length >= 5) ? 14 : (300 - 39 * shareItems.length) / (shareItems.length + 1);
    return Container(
      padding: const EdgeInsets.only(bottom: 28),
      alignment: Alignment.center,
      child: Wrap(
        spacing: space,
        runSpacing: 31,
        children: shareItems,
      ),
    );
  }
}
