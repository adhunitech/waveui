import 'package:waveui/src/constants/wave_asset_constants.dart';
import 'package:waveui/src/theme/wave_theme_configurator.dart';
import 'package:waveui/src/utils/wave_tools.dart';
import 'package:flutter/material.dart';

/// 描述: 星级评价列表，默认支持5个

class WaveAppraiseStarListView extends StatefulWidget {
  /// 展示的星星的数目
  final int count;

  /// 未选中时的提示
  final String? hint;

  /// 星星下面的文案，点击对应的星星会显示相应index的文案，titles长度不能比count小
  final List<String> titles;

  /// 点击回调
  final ValueChanged<int>? onTap;

  const WaveAppraiseStarListView(
      {Key? key, this.count = 5, required this.titles, this.hint, this.onTap})
      : assert(count > 0 && count <= 5),
        assert(titles.length >= count),
        super(key: key);

  @override
  _WaveAppraiseStarListViewState createState() =>
      _WaveAppraiseStarListViewState();
}

class _WaveAppraiseStarListViewState extends State<WaveAppraiseStarListView> {
  final Image _star =
      WaveUITools.getAssetImage(WaveAsset.iconStarSize, gaplessPlayback: true);

  final Image _selectedStar = WaveUITools.getAssetImage(
      WaveAsset.iconStarSizeSelected,
      gaplessPlayback: true);

  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.titles.isEmpty) {
      return _buildStars();
    } else {
      Widget subWidget = Container();
      String? subTitle = widget.hint;
      if (_selectedIndex >= 0 && _selectedIndex < widget.titles.length) {
        subTitle = widget.titles[_selectedIndex];
      }
      if (subTitle?.isNotEmpty ?? false) {
        subWidget = Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            subTitle ?? '',
            style: TextStyle(
                fontSize: 12.0,
                color: WaveThemeConfigurator.instance
                    .getConfig()
                    .commonConfig
                    .colorTextSecondary,
                fontWeight: FontWeight.w600),
          ),
        );
      }
      return Column(
        children: <Widget>[
          _buildStars(),
          subWidget,
        ],
      );
    }
  }

  Widget _buildStars() {
    List<Widget> list = [];
    for (int i = 0; i < widget.count; i++) {
      Widget item = GestureDetector(
        child: Padding(
          padding: const EdgeInsets.only(left: 6, right: 6, top: 4),
          child: (i <= _selectedIndex) ? _selectedStar : _star,
        ),
        onTap: () {
          if (widget.onTap != null) {
            widget.onTap!(i);
          }
          _selectedIndex = i;
        },
      );
      list.add(item);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: list,
    );
  }
}
