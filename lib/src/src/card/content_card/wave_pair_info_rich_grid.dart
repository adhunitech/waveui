import 'dart:ui' as ui;

import 'package:waveui/src/constants/wave_asset_constants.dart';
import 'package:waveui/src/theme/base/wave_text_style.dart';
import 'package:waveui/src/theme/wave_theme_configurator.dart';
import 'package:waveui/src/theme/configs/wave_pair_info_config.dart';
import 'package:waveui/src/utils/wave_tools.dart';
import 'package:flutter/material.dart';

/// 两列key-value 展示信息的集合,需要配合[WaveRichGridInfo]使用
///
/// 组件内部是通过GridView来实现的，GridView是通过宽高比来实现子节点的布局
/// 并且组件内部处理了字体大小，高度变化的情况。
///
/// 和[WavePairInfoTable]组件不同，该组件的每个组件都是单行展示
///
/// 除了基本的信息展示外，使用WaveRichGridInfo还可以实现富文本、复杂Widget的功能。
/// 样式：
///    支持文本、富文本和自定义的widget
///    常用的情况可以通过类中的静态函数构造
///    富文本和Icon的情况推荐使用 [WaveRichTextGenerator] 构造
///
/// WaveRichInfoGridWidget(
///     pairInfoList: <WaveRichGridInfo>[
///       WaveRichGridInfo.valueLastClickInfo('名称名称名称名称名称名称名称', '内容内容',
///           keyQuestionCallback: (value) {
///         showSnackBar(context,
//  msg:value, context);
///       }),
///       WaveRichGridInfo("名称：", '内容内容内容'),
///       WaveRichGridInfo("名称：", '内容内容'),
///       WaveRichGridInfo("名称：", '内容'),
///      ],
/// ),
///
/// 其他信息展示组件
///  * [WaveEnhanceNumberCard], 强化数字信息展示组件
///  * [WavePairInfoTable], 单列key-value信息集合组件
///
class WaveRichInfoGrid extends StatelessWidget {
  final List<WaveRichGridInfo>? pairInfoList;

  ///行间距 纵向
  final double? rowSpace;

  ///gridView 为children包裹的padding，默认是从media中获取，支持修改
  ///同gridView的padding
  final EdgeInsetsGeometry? padding;

  ///元素间距 横向
  final double? space;

  final double? itemHeight;

  /// 一共多少列 默认2列
  final int crossAxisCount;

  final WavePairRichInfoGridConfig? themeData;

  const WaveRichInfoGrid({
    Key? key,
    this.pairInfoList,
    this.padding,
    this.rowSpace,
    this.space,
    this.itemHeight,
    this.crossAxisCount = 2,
    this.themeData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (pairInfoList == null || pairInfoList!.isEmpty) {
      return const SizedBox.shrink();
    }

    return _buildGridView(context);
  }

  Widget _buildGridView(context) {
    WavePairRichInfoGridConfig defaultConfig = themeData ?? WavePairRichInfoGridConfig();

    defaultConfig = defaultConfig
        .merge(WavePairRichInfoGridConfig(itemSpacing: space, rowSpacing: rowSpace, itemHeight: itemHeight));
    defaultConfig = WaveThemeConfigurator.instance
        .getConfig(configId: defaultConfig.configId)
        .pairRichInfoGridConfig
        .merge(defaultConfig);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double gridWidth = constraints.maxWidth;
        if (gridWidth == double.infinity) {
          gridWidth = MediaQuery.of(context).size.width;
        }
        double itemHeight = defaultConfig.itemHeight * (MediaQuery.textScaleFactorOf(context));
        double itemWidth = (gridWidth - defaultConfig.itemSpacing) / 2;

        var gridView = GridView.builder(
          shrinkWrap: true,
          padding: padding,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: defaultConfig.rowSpacing,
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: defaultConfig.itemSpacing,
            childAspectRatio: itemWidth / itemHeight,
          ),
          itemBuilder: (context, index) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _getKeyWidget(
                  pairInfoList![index],
                  gridWidth,
                  context,
                  defaultConfig,
                ),
                _getValueWidget(pairInfoList![index], defaultConfig)
              ],
            );
          },
          itemCount: (null != pairInfoList) ? pairInfoList!.length : 0,
        );
        return gridView;
      },
    );
  }

  Widget _getKeyWidget(WaveRichGridInfo info, double width, BuildContext context, WavePairRichInfoGridConfig config) {
    if (info.keyPart == null) {
      return const SizedBox.shrink();
    }

    if (info.keyPart is String) {
      return Container(
        constraints: BoxConstraints(maxWidth: width / 4),
        child: Text(info.keyPart, maxLines: 1, overflow: TextOverflow.ellipsis, style: _getKeyStyle(themeData: config)),
      );
    }
    if (info.keyPart is Widget) {
      return info.keyPart;
    }

    return const SizedBox.shrink();
  }

  Widget _getValueWidget(WaveRichGridInfo info, WavePairRichInfoGridConfig config) {
    if (info.valuePart == null) {
      return Text('--', style: _getValueStyle('--', themeData: config));
    }
    if (info.valuePart is String) {
      String value = info.valuePart.isEmpty ? '--' : info.valuePart;
      return Expanded(
        child: Text(value,
            maxLines: 1, overflow: TextOverflow.ellipsis, style: _getValueStyle(info.valuePart, themeData: config)),
      );
    }
    if (info.valuePart is Widget) {
      return info.valuePart;
    }

    return const SizedBox.shrink();
  }
}

class WaveRichGridInfo {
  final dynamic keyPart;
  final dynamic valuePart;

  WaveRichGridInfo(this.keyPart, this.valuePart);

  ///-----------以下静态方法为常见显示的快捷构造-----------
  /// value的最后一部分带有可点击的超链接
  ///
  /// keyTitle 显示的key文案
  /// valueTitle 显示的value文案
  /// clickValue 显示的可点击文案
  /// fontSize 文案的大小
  /// clickCallback 可点击文案点击的回调
  /// isArrow 是否最右侧存在箭头
  static WaveRichGridInfo valueLastClickInfo(
    String keyTitle,
    String valueTitle, {
    Function(String key)? keyQuestionCallback,
    Function(String value)? valueQuestionCallback,
    String clickTitle = '',
    Color? clickColor,
    Function(String clickValue)? clickCallback,
    WavePairRichInfoGridConfig? themeData,
  }) {
    themeData ??= WavePairRichInfoGridConfig();
    themeData =
        WaveThemeConfigurator.instance.getConfig(configId: themeData.configId).pairRichInfoGridConfig.merge(themeData);
    themeData = themeData.merge(WavePairRichInfoGridConfig(linkTextStyle: WaveTextStyle(color: clickColor)));

    Widget getQuestionImage(bool isKey) {
      return GestureDetector(
          onTap: () {
            if (isKey) {
              keyQuestionCallback!(keyTitle);
            } else {
              valueQuestionCallback!(valueTitle);
            }
          },
          child: Padding(
            padding: EdgeInsets.only(left: isKey ? 0 : 4),
            child: WaveUITools.getAssetSizeImage(WaveAsset.iconPairInfoQuestion, 14, 14),
          ));
    }

    Widget getClickValue({required WavePairRichInfoGridConfig themeData}) {
      return GestureDetector(
        onTap: () {
          if (clickCallback != null) {
            clickCallback(clickTitle);
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 56),
            child: Text(clickTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: _getClickStyle(clickTitle, clickColor, themeData: themeData)),
          ),
        ),
      );
    }

    bool isShowKeyQuestion = keyQuestionCallback != null;
    bool isShowValueQuestion = valueQuestionCallback != null;
    bool isShowValueClick = clickTitle.isNotEmpty;

    MediaQueryData mediaQuery = MediaQueryData.fromView(ui.window);
    double screen = mediaQuery.size.width;

    Widget key = Container(
      constraints: BoxConstraints(
        maxWidth: screen / 4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Text(
              keyTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _getKeyStyle(themeData: themeData),
            ),
          ),
          isShowKeyQuestion ? getQuestionImage(true) : const SizedBox.shrink(),
          Text(
            '：',
            style: _getKeyStyle(themeData: themeData),
          ),
        ],
      ),
    );

    Widget value = Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Text(
              valueTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _getValueStyle(valueTitle, themeData: themeData),
            ),
          ),
          isShowValueClick ? getClickValue(themeData: themeData) : const SizedBox.shrink(),
          isShowValueQuestion ? getQuestionImage(false) : const SizedBox.shrink(),
        ],
      ),
    );

    return WaveRichGridInfo(key, value);
  }
}

TextStyle? _getKeyStyle({WavePairRichInfoGridConfig? themeData}) => themeData?.keyTextStyle.generateTextStyle();

TextStyle? _getClickStyle(String? content, Color? clickColor, {WavePairRichInfoGridConfig? themeData}) =>
    themeData?.linkTextStyle.generateTextStyle();

TextStyle? _getValueStyle(String content, {WavePairRichInfoGridConfig? themeData}) =>
    themeData?.valueTextStyle.generateTextStyle();
