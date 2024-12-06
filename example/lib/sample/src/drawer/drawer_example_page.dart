import 'package:waveui/waveui.dart';

class DrawerExamplePage extends StatefulWidget {
  const DrawerExamplePage({super.key});

  @override
  State<DrawerExamplePage> createState() => _DrawerExamplePageState();
}

class _DrawerExamplePageState extends State<DrawerExamplePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            children: [
              WaveDrawerItem(
                active: FluentIcons.home_28_filled,
                inActive: FluentIcons.home_28_regular,
                title: "Home",
                index: 0,
                selectedIndex: _selectedIndex,
                onTap: (p0) {
                  setState(() {
                    _selectedIndex = p0;
                  });
                },
              ),
              WaveDrawerItem(
                active: FluentIcons.person_28_filled,
                inActive: FluentIcons.person_28_regular,
                title: "Friends",
                index: 1,
                selectedIndex: _selectedIndex,
                onTap: (p0) {
                  setState(() {
                    _selectedIndex = p0;
                  });
                },
              ),
              WaveDrawerItem(
                active: FluentIcons.chat_28_filled,
                inActive: FluentIcons.chat_28_regular,
                title: "Messages",
                index: 2,
                selectedIndex: _selectedIndex,
                onTap: (p0) {
                  setState(() {
                    _selectedIndex = p0;
                  });
                },
              ),
              WaveDrawerItem(
                active: FluentIcons.alert_28_filled,
                inActive: FluentIcons.alert_28_regular,
                title: "Notifications",
                index: 3,
                selectedIndex: _selectedIndex,
                onTap: (p0) {
                  setState(() {
                    _selectedIndex = p0;
                  });
                },
              ),
              WaveDrawerItem(
                active: FluentIcons.settings_28_filled,
                inActive: FluentIcons.settings_28_regular,
                title: "Settings",
                index: 4,
                selectedIndex: _selectedIndex,
                onTap: (p0) {
                  setState(() {
                    _selectedIndex = p0;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      appBar: WaveAppBar(
        title: "Drawer Example",
        leading: IconButton(
          onPressed: () {
            _key.currentState!.openDrawer();
          },
          icon: const Icon(FluentIcons.navigation_24_regular),
        ),
      ),
    );
  }
}
