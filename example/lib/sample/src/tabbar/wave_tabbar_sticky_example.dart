import 'package:waveui/waveui.dart';

class WaveTabbarStickyExample extends StatefulWidget {
  const WaveTabbarStickyExample({super.key});

  @override
  _WaveTabbarStickyExampleState createState() =>
      _WaveTabbarStickyExampleState();
}

class _WaveTabbarStickyExampleState extends State<WaveTabbarStickyExample>
    with SingleTickerProviderStateMixin {
  TabController? tabController;

  GlobalKey globalKey = GlobalKey();

  ScrollController scrollController = ScrollController();

  WaveCloseWindowController? closeWindowController;
  List<BadgeTab> tabs = <BadgeTab>[];

  @override
  void initState() {
    super.initState();
    tabs.add(BadgeTab(text: "Business 1", badgeNum: 23));
    tabs.add(BadgeTab(text: "Business 2"));
    tabs.add(BadgeTab(text: "Business 3"));
    tabs.add(BadgeTab(text: "Business 4"));
    tabs.add(BadgeTab(text: "Business five"));
    tabs.add(BadgeTab(text: "Business 6"));
    tabController = TabController(length: tabs.length, vsync: this);
    closeWindowController = WaveCloseWindowController();
    scrollController.addListener(() {
      closeWindowController!.closeMoreWindow();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: const WaveAppBar(
            title: 'TabBar Sticky Effect',
          ),
          body: NestedScrollView(
            controller: scrollController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                buildHeaderWidget(),
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverPersistentHeader(
                    pinned: true,
                    delegate: StickyTabBarDelegate(
                        child: WaveTabBar(
                      controller: tabController,
                      tabs: tabs,
                      showMore: true,
                      moreWindowText: "Tab description",
                      onTap: (state, index) {
                        state.refreshBadgeState(index);
                        scrollController.animateTo(
                            globalKey.currentContext!.size!.height,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.linear);
                      },
                      onMorePop: () {},
                      closeController: closeWindowController,
                    )),
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: tabController,
              children: const <Widget>[
                Center(child: Text('business one')),
                Center(child: Text('Business 2')),
                Center(child: Text('business three')),
                Center(child: Text('business four')),
                Center(child: Text('business five')),
                Center(child: Text('business six')),
              ],
            ),
          ),
        ),
        onWillPop: () {
          if (closeWindowController!.isShow) {
            closeWindowController!.closeMoreWindow();
            return Future.value(false);
          }
          return Future.value(true);
        });
  }

  Widget buildHeaderWidget() {
    return SliverToBoxAdapter(
      child: Container(
        key: globalKey,
        child: const Image(
          image: AssetImage("assets/image/image_sticky_bg.jpg"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final WaveTabBar child;

  StickyTabBarDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => child.tabHeight ?? 50;

  @override
  double get minExtent => child.tabHeight ?? 50;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
