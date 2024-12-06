import 'package:waveui/waveui.dart';
import 'package:example/sample/src/gallery/gallery_detail_example.dart';
import 'package:example/sample/home/list_item.dart';

class GalleryDetailPageThemeExample extends StatelessWidget {
  const GalleryDetailPageThemeExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const WaveAppBar(
          title: "View image details",
        ),
        body: CustomScrollView(slivers: [
          SliverList(
              delegate: SliverChildListDelegate([
            ListItem(
              title: "Picture Details-White Theme",
              describe: "Picture details with white theme",
              isShowLine: false,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const GalleryDetailExamplePage(
                      title: "Picture Details-White Theme",
                      photoGalleryTheme: PhotoGalleryTheme.light,
                    );
                  },
                ));
              },
            ),
            ListItem(
              title: "Picture Details-Black Theme",
              describe: "Picture details have a black theme, the default is black",
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const GalleryDetailExamplePage(
                      title: "Picture Details-Black Theme",
                      photoGalleryTheme: PhotoGalleryTheme.dark,
                    );
                  },
                ));
              },
            ),
          ]))
        ]));
  }
}
