import 'package:waveui/waveui.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          'Scrollable AppBar with a very long title to test the scroll behavior. '
          'Test the scrolling effect and check the behavior of material widgets!',
          style: TextStyle(fontSize: 18),
        ),
      ),
      bottom: TabBar(
        controller: _tabController,
        tabs: const [Tab(text: 'Tab 1'), Tab(text: 'Tab 2'), Tab(text: 'Tab 3')],
      ),
    ),
    body: TabBarView(controller: _tabController, children: [TabContent1(), TabContent2(), TabContent3()]),
    bottomNavigationBar: BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              // Add functionality if needed
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Add functionality if needed
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // Add functionality if needed
            },
          ),
        ],
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        // Add functionality if needed
      },
      child: const Icon(Icons.add),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
  );
}

class TabContent1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      const Card(
        elevation: 5,
        child: ListTile(
          leading: Icon(Icons.home),
          title: Text('List Tile Example'),
          subtitle: Text('This is an example of a ListTile inside a Card widget.'),
        ),
      ),
      const SizedBox(height: 20),
      Container(
        height: 150,
        color: Colors.blueGrey,
        child: const Center(child: Text('Container with a background color')),
      ),
    ],
  );
}

class TabContent2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      const Card(
        elevation: 5,
        child: ListTile(
          leading: Icon(Icons.camera),
          title: Text('Camera Tile'),
          subtitle: Text('An example ListTile with a Camera icon.'),
        ),
      ),
      const SizedBox(height: 20),
      Container(height: 150, color: Colors.amber, child: const Center(child: Text('Another container with color'))),
    ],
  );
}

class TabContent3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      const Card(
        elevation: 5,
        child: ListTile(
          leading: Icon(Icons.notifications),
          title: Text('Notification Tile'),
          subtitle: Text('A ListTile widget with a notification icon.'),
        ),
      ),
      const SizedBox(height: 20),
      Container(height: 150, color: Colors.green, child: const Center(child: Text('A third container with color'))),
    ],
  );
}
