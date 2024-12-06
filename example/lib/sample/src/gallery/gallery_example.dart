import 'package:waveui/waveui.dart';
import 'package:example/sample/src/gallery/gallery_detail_page_theme_example.dart';
import 'package:example/sample/home/list_item.dart';

// ignore: must_be_immutable
class GalleryExample extends StatelessWidget {
  List<WavePhotoGroupConfig> allConfig = [
    WavePhotoGroupConfig.url(title: '第一项', urls: <String>[
      'http://img1.mukewang.com/5c18cf540001ac8206000338.jpg',
      'http://img1.mukewang.com/5c18cf540001ac8206000338.jpg',
      'http://img1.mukewang.com/5c18cf540001ac8206000338.jpg',
      'http://img1.mukewang.com/5c18cf540001ac8206000338.jpg',
      'http://img1.mukewang.com/5c18cf540001ac8206000338.jpg',
      'http://img1.mukewang.com/5c18cf540001ac8206000338.jpg',
    ]),
    WavePhotoGroupConfig(title: "信息", configList: [
      WavePhotoItemConfig(
          url: 'http://img1.mukewang.com/5c18cf540001ac8206000338.jpg',
          showBottom: true,
          bottomCardModel: PhotoBottomCardState.cantFold,
          name: "a cat",
          des:
              "image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description Picture description Picture description Picture description"),
      WavePhotoItemConfig(
          url: 'http://img1.mukewang.com/5c18cf540001ac8206000338.jpg',
          showBottom: true,
          bottomCardModel: PhotoBottomCardState.fold,
          name: "two cats",
          des:
              "image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description"),
      WavePhotoItemConfig(
          url: 'http://img1.mukewang.com/5c18cf540001ac8206000338.jpg',
          showBottom: true,
          bottomCardModel: PhotoBottomCardState.unFold,
          name: "Three cats",
          des:
              "image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description "),
      WavePhotoItemConfig(
          url: 'http://img1.mukewang.com/5c18cf540001ac8206000338.jpg',
          showBottom: false,
          name: "a picture",
          des:
              "image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description describe image description")
    ]),
    WavePhotoGroupConfig.url(title: 'Second item', urls: <String>[
      'http://img1.mukewang.com/5c18cf540001ac8206000338.jpg',
      'http://img1.mukewang.com/5c18cf540001ac8206000338.jpg',
    ]),
    WavePhotoGroupConfig.url(title: 'The third item', urls: <String>[
      'http://img1.mukewang.com/5c18cf540001ac8206000338.jpg',
      'http://img1.mukewang.com/5c18cf540001ac8206000338.jpg',
    ]),
    WavePhotoGroupConfig.url(title: 'The fourth item', urls: <String>[
      'http://img1.mukewang.com/5c18cf540001ac8206000338.jpg',
      'http://img1.mukewang.com/5c18cf540001ac8206000338.jpg',
    ]),
    WavePhotoGroupConfig(title: "Module with display information", configList: [
      WavePhotoItemConfig(
          url: 'http://img1.mukewang.com/5c18cf540001ac8206000338.jpg',
          showBottom: true,
          bottomCardModel: PhotoBottomCardState.fold,
          name: "a picture",
          des:
              "image description image description image description image description image description image description image description image description image description image description image description image description image description image description")
    ]),
    WavePhotoGroupConfig(
      title: "Module with display information",
      configList: [
        WavePhotoItemConfig(
            url: 'http://img1.mukewang.com/5c18cf540001ac8206000338.jpg',
            showBottom: true,
            bottomCardModel: PhotoBottomCardState.fold,
            name: "a picture",
            des:
                "image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description"),
      ],
    ),
    WavePhotoGroupConfig(title: "Module with display information", configList: [
      WavePhotoItemConfig(
          url: 'http://img1.mukewang.com/5c18cf540001ac8206000338.jpg',
          showBottom: true,
          bottomCardModel: PhotoBottomCardState.fold,
          name: "a picture",
          des:
              "image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description picture description picture description picture description picture description picture description picture description picture description picture description picture description picture description picture description picture description picture description picture description picture description picture description picture description picture description picture description picture description picture description picture description picture description picture description picture description picture description picture description picture description picture description picture description picture description picture description picture description picture description picture description picture description picture description picture description picture description picture description picture description picture description picture description picture description picture description picture description picture description picture description picture description picture description picture description picture description picture description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description image description ")
    ])
  ];

  GalleryExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WaveAppBar(
        title: "Gallery Pictures",
      ),
      body: ListView(
        children: [
          ListItem(
            title: "Image Selection Control",
            isShowLine: false,
            describe: "View image list page",
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return WaveGallerySummaryPage(allConfig: allConfig);
                },
              ));
            },
          ),
          ListItem(
            title: "View image details",
            describe: 'Jump to the fifth picture of the first item',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return const GalleryDetailPageThemeExample();
                },
              ));
            },
          ),
        ],
      ),
    );
  }
}
