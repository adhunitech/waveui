import 'package:photo_view/photo_view.dart';
import 'package:waveui/waveui.dart';

class WavePhotoGroupConfig extends WaveBasicGroupConfig {
  final List<String>? urls;
  @override
  final String? title;
  final WaveGalleryDetailConfig? themeData;

  /// 通过 [urls] 列表生成配置
  WavePhotoGroupConfig.url({this.title, required this.urls, this.themeData, List<WaveBasicItemConfig>? configList})
      : super(
            title: title,
            configList: urls?.map((item) => WavePhotoItemConfig(url: item, themeData: themeData)).toList());

  /// 自定义配置列表
  WavePhotoGroupConfig({this.urls, this.title, List<WaveBasicItemConfig>? configList, this.themeData})
      : super(title: title, configList: configList);
}

/// 图片类的配置
class WavePhotoItemConfig extends WaveBasicItemConfig {
  /// 图片url
  final String url;

  /// 图片的展示模式
  final BoxFit fit;

  /// 占位图
  final String placeHolder;

  /// 图片名称 用于详情页展示
  final String? name;

  /// 图片描述公 用于详情页展示
  final String? des;

  /// 详情页图片点击回调
  final VoidCallback? onTap;

  /// 详情页双击回调
  final VoidCallback? onDoubleTap;

  /// 详情页长按回调
  final VoidCallback? onLongPress;

  /// 详情页是否展示底部卡片，需要提供name和des信息
  final bool showBottom;

  /// [PhotoBottomCardState] 底部展示卡片的模式
  final PhotoBottomCardState bottomCardModel;

  /// 指定展开不可收起下 content的高度
  final double bottomContentHeight;

  WaveGalleryDetailConfig? themeData;

  WavePhotoItemConfig({
    required this.url,
    this.fit = BoxFit.cover,
    this.placeHolder = "packages/${WaveStrings.flutterPackageName}/assets/icons/grey_place_holder.png",
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.name,
    this.des,
    this.showBottom = false,
    this.bottomCardModel = PhotoBottomCardState.cantFold,
    this.bottomContentHeight = 150,
    this.themeData,
  }) {
    themeData ??= WaveGalleryDetailConfig();
    themeData =
        WaveThemeConfigurator.instance.getConfig(configId: themeData!.configId).galleryDetailConfig.merge(themeData);
  }

  @override
  Widget buildSummaryWidget(BuildContext context, List<WaveBasicGroupConfig> allConfig, int groupId, int index) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(2.0)),
          border: Border.all(color: const Color(0xFFF0F0F0), width: 0.5)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: FadeInImage.assetNetwork(
          image: url,
          fit: fit,
          placeholder: placeHolder,
        ),
      ),
    );
  }

  @override
  Widget buildDetailWidget(BuildContext context, List<WaveBasicGroupConfig> allConfig, int groupId, int index) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: () {
                onTap?.call();
              },
              onDoubleTap: () {
                onDoubleTap?.call();
              },
              onLongPress: () {
                onLongPress?.call();
              },
              child: Container(
                color: Colors.white,
                child: PhotoView(
                  backgroundDecoration: BoxDecoration(color: themeData!.pageBackgroundColor),
                  loadingBuilder: (context, event) {
                    return Container(
                      color: themeData!.pageBackgroundColor,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                  imageProvider: NetworkImage(url),
                ),
              ),
            ),
          ),
          showBottom
              ? Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: SafeArea(
                    top: false,
                    child: WavePhotoBottomCard(
                      name: name,
                      des: des,
                      model: bottomCardModel,
                      contentHeight: bottomContentHeight,
                      themeData: themeData,
                    ),
                  ),
                )
              : const Row()
        ],
      ),
    );
  }
}
