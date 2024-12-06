import 'package:waveui/waveui.dart';
import 'package:example/sample/home/list_item.dart';
import 'package:example/sample/src/navbar/nav_bar_example_page.dart';

class AppbarEntryPage extends StatelessWidget {
  const AppbarEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const WaveAppBar(
          title: 'NavBar Example',
        ),
        body: ListView(
          children: <Widget>[
            ListItem(
              title: "NavBar Example",
              describe: 'Navbar/black/2 text module switching + left and right 2icons',
              isShowLine: false,
              onPressed: () {
                _openNavBarPage(context, 0);
              },
            ),
            ListItem(
              title: "NavBar Example",
              describe: 'Navbar/black/text title+left 2icon+right text+floating window',
              onPressed: () {
                _openNavBarPage(context, 4);
              },
            ),
            ListItem(
              title: "NavBar Example",
              describe: 'Navbar/black/text title+drop-down selection',
              onPressed: () {
                _openNavBarPage(context, 5);
              },
            ),
            ListItem(
              title: "Navbar example",
              describe: 'Navbar/white/text title+left icon',
              onPressed: () {
                _openNavBarPage(context, 8);
              },
            ),
            ListItem(
              title: "Navbar Example",
              describe: 'Navbar/white/text title+text label+left icon',
              onPressed: () {
                _openNavBarPage(context, 9);
              },
            ),
            ListItem(
              title: "Navbar White Search End Example",
              onPressed: () {
                _openNavBarPage(context, 19);
              },
            ),
            ListItem(
              title: "Navbar Example",
              describe: 'Navbar/white/text title+left 2icon+right text+floating window',
              onPressed: () {
                _openNavBarPage(context, 10);
              },
            ),
            ListItem(
              title: "Navbar example",
              describe: 'Navbar/Black',
              onPressed: () {
                _openNavBarPage(context, 11);
              },
            ),
            ListItem(
              title: "Navbar example",
              describe: 'Navbar/white',
              onPressed: () {
                _openNavBarPage(context, 12);
              },
            ),
            ListItem(
              title: "SearchBar Example",
              describe: 'SearchBar/Black/Type does not switch + text prompt + cancel',
              onPressed: () {
                _openNavBarPage(context, 13);
              },
            ),
            ListItem(
              title: "SearchBar example-white",
              describe: 'SearchBar/white/type does not switch + text prompt + cancel',
              onPressed: () {
                _openNavBarPage(context, 16);
              },
            ),
            ListItem(
              title: "Navbar Example",
              describe: 'Multiple text switching',
              onPressed: () {
                _openNavBarPage(context, 14);
              },
            ),
            ListItem(
              title: "Search Example",
              describe: 'Multiple text switching',
              onPressed: () {
                _openNavBarPage(context, 15);
              },
            ),
            ListItem(
              title: "Search Example",
              describe: 'Search without leading',
              onPressed: () {
                _openNavBarPage(context, 17);
              },
            ),
          ],
        ));
  }

  _openNavBarPage(BuildContext context, int index) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return NavBarPage(index);
    }));
  }
}
