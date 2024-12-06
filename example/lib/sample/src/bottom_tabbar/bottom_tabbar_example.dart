import 'package:waveui/waveui.dart';

///Bottom navigation bar example
class BottomTabbarExample extends StatefulWidget {
  const BottomTabbarExample({super.key});

  @override
  State<StatefulWidget> createState() {
    return BottomTabbarExampleState();
  }
}

class BottomTabbarExampleState extends State<BottomTabbarExample> with SingleTickerProviderStateMixin {
  ///selected index
  int _selectedIndex = 0;

  ///Number of unread messages
  String badgeNo1 = '100';

  ///title array
  var titles = ['One', 'Two', 'Three', 'Four', 'Five', 'Six'];

  ///icon array
  var icons = [Icons.home, Icons.play_arrow, Icons.child_friendly, Icons.fiber_new, Icons.mic_none, Icons.star];

  ///State setting when the state is selected
  void _onItemSelected(int index) {
    setState(() {
      ///Set as the index value of the currently selected item
      _selectedIndex = index;

      ///The number of unread messages after selection
      badgeNo1 = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WaveAppBar(title: 'BottomTabBar'),

      ///First define a BottomTabBar container
      bottomNavigationBar: WaveBottomNavigationBar(
        currentIndex: _selectedIndex,
        //item click event
        onTap: _onItemSelected,
        //Background color of unread messages
        //define itemLists
        items: <BottomNavigationBarItem>[
          //Define each BottomTabBarItem, see the source code for sub-properties
          BottomNavigationBarItem(
            icon: const Image(image: AssetImage("assets/icons/navbar_house.png")),
            activeIcon: const Image(
              image: AssetImage("assets/icons/navbar_house.png"),
              color: Colors.blue,
            ),
            label: titles[0],
          ),
          BottomNavigationBarItem(
            icon: const Image(image: AssetImage("assets/icons/navbar_house.png")),
            activeIcon: const Image(
              image: AssetImage("assets/icons/navbar_house.png"),
              color: Colors.blue,
            ),
            label: titles[1],
          ),
          BottomNavigationBarItem(
            icon: const Image(image: AssetImage("assets/icons/navbar_house.png")),
            activeIcon: const Image(
              image: AssetImage("assets/icons/navbar_house.png"),
              color: Colors.blue,
            ),
            label: titles[2],
          ),
          BottomNavigationBarItem(
            icon: const Image(image: AssetImage("assets/icons/navbar_house.png")),
            activeIcon: const Image(
              image: AssetImage("assets/icons/navbar_house.png"),
              color: Colors.blue,
            ),
            label: titles[3],
          ),
          BottomNavigationBarItem(
            icon: const Image(image: AssetImage("assets/icons/navbar_house.png")),
            activeIcon: const Image(
              image: AssetImage("assets/icons/navbar_house.png"),
              color: Colors.blue,
            ),
            label: titles[4],
          ),
          BottomNavigationBarItem(
            icon: const Image(image: AssetImage("assets/icons/navbar_house.png")),
            activeIcon: const Image(
              image: AssetImage("assets/icons/navbar_house.png"),
              color: Colors.blue,
            ),
            label: titles[5],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return const Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris pulvinar sagittis mollis. Aenean est sapien, sodales in vestibulum in, consectetur sit amet orci. Aenean scelerisque, nulla quis accumsan elementum, augue sem pretium leo, quis laoreet diam velit sed magna. Integer maximus lorem dolor, a elementum nisl tincidunt at. Pellentesque pretium tellus sit amet nisi suscipit fermentum. In hac habitasse platea dictumst. Cras pellentesque posuere ex, ut elementum est pellentesque et. Nullam non convallis neque, sed aliquam massa.",
          );
        },
      ),
    );
  }
}
