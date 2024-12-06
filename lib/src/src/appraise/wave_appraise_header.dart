import 'package:waveui/waveui.dart';

/// 描述: 评价组件title
class WaveAppraiseHeader extends StatelessWidget {
  /// 是否显示标题，默认为 true，显示
  final bool showHeader;

  /// 标题文字，默认 ''
  final String title;

  /// 标题最大行数，默认为 1
  final int maxLines;

  /// 标题类型，默认 [WaveAppraiseHeaderType.spaceBetween]
  final WaveAppraiseHeaderType headerType;

  /// 标题的 padding，为 null 时为默认 padding。
  /// headerType 为 spaceBetween 时默认为 EdgeInsets.only(left: 20, top: 16, right: 16, bottom: 20)
  /// headerType 为 center 时默认为 EdgeInsets.only(top: 20, bottom: 20)
  final EdgeInsets? headPadding;

  /// 点击关闭的回掉
  final WaveAppraiseCloseClickCallBack? cancelCallBack;

  const WaveAppraiseHeader(
      {Key? key,
      this.showHeader = true,
      this.title = '',
      this.maxLines = 1,
      this.headerType = WaveAppraiseHeaderType.spaceBetween,
      this.headPadding,
      this.cancelCallBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (showHeader) {
      if (headerType == WaveAppraiseHeaderType.spaceBetween) {
        return _spaceHeader(context);
      } else if (headerType == WaveAppraiseHeaderType.center) {
        return _centerHeader();
      }
    }
    return const SizedBox.shrink();
  }

  Widget _centerHeader() {
    return Padding(
      padding: headPadding ?? const EdgeInsets.only(top: 20, bottom: 20),
      child: Text(
        title,
        maxLines: maxLines,
        style: Get.textTheme.headlineSmall,
      ),
    );
  }

  Widget _spaceHeader(BuildContext context) {
    return SizedBox(
      height: 38 + maxLines * 22.0,
      child: Padding(
        padding: headPadding ??
            const EdgeInsets.only(left: 20, top: 16, right: 16, bottom: 20),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4, right: 12),
                child: Text(
                  title,
                  maxLines: maxLines,
                  style: TextStyle(
                    color: WaveThemeConfigurator.instance
                        .getConfig()
                        .commonConfig
                        .colorTextBase,
                    fontSize: 18.0,
                    height: 1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (cancelCallBack != null) {
                  cancelCallBack!(context);
                }
                Navigator.of(context).pop();
              },
              child: WaveUITools.getAssetImage(WaveAsset.iconPickerClose),
            ),
          ],
        ),
      ),
    );
  }
}

/// title类型
enum WaveAppraiseHeaderType {
  /// 居中
  center,

  /// 两边
  spaceBetween,
}
