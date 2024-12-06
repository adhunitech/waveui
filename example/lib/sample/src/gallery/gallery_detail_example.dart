import 'package:example/sample/widgets.dart';
import 'package:waveui/waveui.dart';

enum PhotoGalleryTheme { dark, light }

class GalleryDetailExamplePage extends StatefulWidget {
  final String? title;
  final PhotoGalleryTheme photoGalleryTheme;

  const GalleryDetailExamplePage({super.key, this.title, this.photoGalleryTheme = PhotoGalleryTheme.dark});

  @override
  State<StatefulWidget> createState() {
    return GalleryDetailExamplePageState();
  }
}

class GalleryDetailExamplePageState extends State<GalleryDetailExamplePage> {
  late List<WavePhotoGroupConfig> allConfig;
  late WaveGalleryController controller;

  @override
  void initState() {
    super.initState();
    controller = WaveGalleryController();
    allConfig = [
      WavePhotoGroupConfig.url(
          themeData: PhotoGalleryTheme.dark == widget.photoGalleryTheme
              ? WaveGalleryDetailConfig.dark()
              : WaveGalleryDetailConfig.light(),
          title: 'First item',
          urls: <String>[
            "https://img1.baidu.com/it/u=1035835481,2764635772&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=750",
            "https://img2.baidu.com/it/u=987135572,1298604833&fm=253&fmt=auto&app=138&f=JPEG?w=587&h=445",
            "https://img1.baidu.com/it/u=2029510411,2926361415&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=889",
            "https://img2.baidu.com/it/u=3489452515,1789465937&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=333",
            "https://img2.baidu.com/it/u=2011041083,1329194196&fm=253&fmt=auto&app=138&f=JPEG?w=333&h=500",
            "https://img2.baidu.com/it/u=3412982025,1011812299&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500",
          ]),
      WavePhotoGroupConfig(title: "information", configList: [
        WavePhotoItemConfig(
            themeData: PhotoGalleryTheme.dark == widget.photoGalleryTheme
                ? WaveGalleryDetailConfig.dark()
                : WaveGalleryDetailConfig.light(),
            url: "https://img2.baidu.com/it/u=3489452515,1789465937&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=333",
            showBottom: true,
            bottomCardModel: PhotoBottomCardState.cantFold,
            name: "a cat",
            des:
                "image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is Image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description image description here image description here image description here image description here image description here image description here image description here image description here image description here image description here image description here image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image Image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description Image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is Image description here is image description here is image description here is image description here is image description here is image description here is image Description Here is the picture description"),
        WavePhotoItemConfig(
            themeData: PhotoGalleryTheme.dark == widget.photoGalleryTheme
                ? WaveGalleryDetailConfig.dark()
                : WaveGalleryDetailConfig.light(),
            url: "https://img2.baidu.com/it/u=2011041083,1329194196&fm=253&fmt=auto&app=138&f=JPEG?w=333&h=500",
            showBottom: true,
            bottomCardModel: PhotoBottomCardState.fold,
            name: "two cats",
            des:
                "image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is Image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description image description here image description here image description here image description here image description here image description here image description here image description here image description here image description here image description here image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image Image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description Image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is Image description here is image description here is image description here is image description here is image description here is image description here is image Description Here is the picture description"),
        WavePhotoItemConfig(
            themeData: PhotoGalleryTheme.dark == widget.photoGalleryTheme
                ? WaveGalleryDetailConfig.dark()
                : WaveGalleryDetailConfig.light(),
            url: "https://img0.baidu.com/it/u=3926156041,1190073021&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=889",
            showBottom: true,
            bottomCardModel: PhotoBottomCardState.unFold,
            name: "three cats",
            des:
                "image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is Image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description image description here image description here image description here image description here image description here image description here image description here image description here image description here image description here image description here image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image Image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description Image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is Image description here is image description here is image description here is image description here is image description here is image description here is image Description Here is the picture description"),
        WavePhotoItemConfig(
            themeData: PhotoGalleryTheme.dark == widget.photoGalleryTheme
                ? WaveGalleryDetailConfig.dark()
                : WaveGalleryDetailConfig.light(),
            url: "https://img1.baidu.com/it/u=456300708,413059805&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500",
            showBottom: false,
            name: "a picture",
            des:
                "image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is Image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description image description here image description here image description here image description here image description here image description here image description here image description here image description here image description here image description here image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image Image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description Image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is Image description here Image description here Image description here Image description here Image description here Image description here Image description here Image description here")
      ]),
      WavePhotoGroupConfig.url(
          title: '第二项',
          themeData: PhotoGalleryTheme.dark == widget.photoGalleryTheme
              ? WaveGalleryDetailConfig.dark()
              : WaveGalleryDetailConfig.light(),
          urls: <String>[
            "https://img1.baidu.com/it/u=2029510411,2926361415&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=889",
            "https://img2.baidu.com/it/u=3412982025,1011812299&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500",
          ]),
      WavePhotoGroupConfig.url(
          themeData: PhotoGalleryTheme.dark == widget.photoGalleryTheme
              ? WaveGalleryDetailConfig.dark()
              : WaveGalleryDetailConfig.light(),
          title: '第三项',
          urls: <String>[
            "https://img2.baidu.com/it/u=987135572,1298604833&fm=253&fmt=auto&app=138&f=JPEG?w=587&h=445",
            "https://img2.baidu.com/it/u=3412982025,1011812299&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500",
          ]),
      WavePhotoGroupConfig.url(
          themeData: PhotoGalleryTheme.dark == widget.photoGalleryTheme
              ? WaveGalleryDetailConfig.dark()
              : WaveGalleryDetailConfig.light(),
          title: '第四项',
          urls: <String>[
            "https://img2.baidu.com/it/u=3489452515,1789465937&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=333",
            "https://img2.baidu.com/it/u=3412982025,1011812299&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500",
          ]),
      WavePhotoGroupConfig(
          themeData: PhotoGalleryTheme.dark == widget.photoGalleryTheme
              ? WaveGalleryDetailConfig.dark()
              : WaveGalleryDetailConfig.light(),
          title: "带展示信息的模块",
          configList: [
            WavePhotoItemConfig(
                themeData: PhotoGalleryTheme.dark == widget.photoGalleryTheme
                    ? WaveGalleryDetailConfig.dark()
                    : WaveGalleryDetailConfig.light(),
                url: "https://img2.baidu.com/it/u=3489452515,1789465937&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=333",
                showBottom: true,
                bottomCardModel: PhotoBottomCardState.fold,
                name: "a picture",
                des:
                    "image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is Image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description image description here image description here image description here image description here image description here image description here image description here image description here image description here image description here image description here image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image Image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description Image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is Image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description Image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is Image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description Image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is Image description here is image description here is image description here is image description here is image description here is image description")
          ]),
      WavePhotoGroupConfig(title: "带展示信息的模块", configList: [
        WavePhotoItemConfig(
            themeData: PhotoGalleryTheme.dark == widget.photoGalleryTheme
                ? WaveGalleryDetailConfig.dark()
                : WaveGalleryDetailConfig.light(),
            url: "https://img2.baidu.com/it/u=987135572,1298604833&fm=253&fmt=auto&app=138&f=JPEG?w=587&h=445",
            showBottom: true,
            bottomCardModel: PhotoBottomCardState.fold,
            name: "a picture",
            des:
                "image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description")
      ]),
      WavePhotoGroupConfig(title: "带展示信息的模块", configList: [
        WavePhotoItemConfig(
          themeData: PhotoGalleryTheme.dark == widget.photoGalleryTheme
              ? WaveGalleryDetailConfig.dark()
              : WaveGalleryDetailConfig.light(),
          url: "https://img2.baidu.com/it/u=3489452515,1789465937&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=333",
          showBottom: true,
          bottomCardModel: PhotoBottomCardState.fold,
          name: "a picture",
          des:
              "image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description here is image description",
        )
      ])
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WaveGalleryDetailPage(
      themeData: PhotoGalleryTheme.dark == widget.photoGalleryTheme
          ? WaveGalleryDetailConfig.dark()
          : WaveGalleryDetailConfig.light(),
      allConfig: allConfig,
      initGroupId: 0,
      initIndexId: 4,
      controller: controller,
      detailRightAction: (i, j) => TextButton(
        child: const Text('编辑'),
        onPressed: () {
          showSnackBar(
            context,
            msg: "点击了$i $j",
          );
          // 移除第二组的最后一个配置，跳转到 第二组的第一张图
          if (allConfig.length > 1) {
            if (allConfig[1].configList!.isNotEmpty) {
              allConfig[1].configList!.removeLast();
              controller.refresh(1, 0);
            } else {
              allConfig.removeAt(1);
            }
          }
        },
      ),
    );
  }
}
