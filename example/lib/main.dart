import 'package:waveui/waveui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Material 3 Widgets Demo',
    theme: ThemeData.light(),
    darkTheme: ThemeData.dark(),
    themeMode: _themeMode,
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Material 3 Widgets Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.lightbulb),
            onPressed: () {
              _toggleTheme(_themeMode == ThemeMode.light);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSectionTitle('App Bars'),
            _buildAppBarSection(),
            const SizedBox(height: 16),
            _buildSectionTitle('Buttons'),
            _buildButtonSection(),
            const SizedBox(height: 16),
            _buildSectionTitle('Cards'),
            _buildCardSection(),
            const SizedBox(height: 16),
            _buildSectionTitle('Text Fields'),
            _buildTextFieldSection(),
            const SizedBox(height: 16),
            _buildSectionTitle('Switches'),
            _buildSwitchSection(),
            const SizedBox(height: 16),
            _buildSectionTitle('Sliders'),
            _buildSliderSection(),
            const SizedBox(height: 16),
            _buildSectionTitle('Chips'),
            _buildChipSection(),
            const SizedBox(height: 16),
            _buildSectionTitle('Progress Indicators'),
            _buildProgressIndicatorSection(),
            const SizedBox(height: 16),
            _buildSectionTitle('Dialogs'),
            _buildDialogSection(),
            const SizedBox(height: 16),
            _buildSectionTitle('Containers'),
            _buildContainerSection(),
            const SizedBox(height: 16),
            _buildSectionTitle('Lists'),
            _buildListSection(),
            const SizedBox(height: 16),
            _buildSectionTitle('Navigation'),
            _buildNavigationSection(),
            const SizedBox(height: 16),
            _buildSectionTitle('Animations'),
            _buildAnimationSection(),
            const SizedBox(height: 16),
            _buildSectionTitle('Images'),
            _buildImageSection(),
            const SizedBox(height: 16),
            _buildSectionTitle('Layouts'),
            _buildLayoutSection(),
            const SizedBox(height: 16),
            _buildSectionTitle('Miscellaneous'),
            _buildMiscellaneousSection(),
          ],
        ),
      ),
    ),
  );

  Widget _buildSectionTitle(String title) =>
      Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold));

  Widget _buildAppBarSection() => Column(
    children: [
      AppBar(
        title: const Text('AppBar Example'),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      const SizedBox(height: 8),
      const BottomAppBar(child: Center(child: Text('BottomAppBar Example'))),
    ],
  );

  Widget _buildButtonSection() => Wrap(
    spacing: 8,
    children: [
      ElevatedButton(onPressed: () {}, child: const Text('Elevated Button')),
      FilledButton(onPressed: () {}, child: const Text('Filled Button')),
      OutlinedButton(onPressed: () {}, child: const Text('Outlined Button')),
      TextButton(onPressed: () {}, child: const Text('Text Button')),
      IconButton(icon: const Icon(Icons.favorite), onPressed: () {}),
      FloatingActionButton(onPressed: () {}, child: const Icon(Icons.add)),
    ],
  );

  Widget _buildCardSection() => Card(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text('This is a Material 3 Card'),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: () {}, child: const Text('Action')),
        ],
      ),
    ),
  );

  Widget _buildTextFieldSection() => const Column(
    children: [
      TextField(decoration: InputDecoration(labelText: 'Text Field', border: OutlineInputBorder())),
      SizedBox(height: 8),
      TextField(
        decoration: InputDecoration(labelText: 'Filled Text Field', filled: true, border: OutlineInputBorder()),
      ),
    ],
  );

  Widget _buildSwitchSection() => Row(children: [Switch(value: true, onChanged: (value) {}), const Text('Switch')]);

  Widget _buildSliderSection() => Slider(value: 0.5, onChanged: (value) {});

  Widget _buildChipSection() => Wrap(
    spacing: 8,
    children: [
      Chip(label: const Text('Chip'), onDeleted: () {}),
      InputChip(label: const Text('Input Chip'), onPressed: () {}),
      FilterChip(label: const Text('Filter Chip'), onSelected: (value) {}),
      ActionChip(label: const Text('Action Chip'), onPressed: () {}),
    ],
  );

  Widget _buildProgressIndicatorSection() =>
      const Column(children: [LinearProgressIndicator(), SizedBox(height: 8), CircularProgressIndicator()]);

  Widget _buildDialogSection() => ElevatedButton(
    onPressed: () {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('AlertDialog'),
              content: const Text('This is an AlertDialog.'),
              actions: [TextButton(onPressed: () {}, child: const Text('OK'))],
            ),
      );
    },
    child: const Text('Show AlertDialog'),
  );

  Widget _buildContainerSection() =>
      Container(width: 100, height: 100, color: Colors.blue, child: const Center(child: Text('Container')));

  Widget _buildListSection() => ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: 5,
    itemBuilder: (context, index) {
      return ListTile(title: Text('Item $index'));
    },
  );

  Widget _buildNavigationSection() => Column(
    children: [
      const Text('Navigation Drawer'),
      SizedBox(
        width: 200,
        height: 600,
        child: Drawer(
          child: ListView(
            children: const [
              DrawerHeader(child: Text('Drawer Header')),
              ListTile(title: Text('Item 1')),
              ListTile(title: Text('Item 2')),
            ],
          ),
        ),
      ),
    ],
  );

  Widget _buildAnimationSection() => Column(
    children: [
      AnimatedContainer(duration: const Duration(seconds: 1), width: 100, height: 100, color: Colors.red),
      const SizedBox(height: 8),
      AnimatedCrossFade(
        duration: const Duration(seconds: 1),
        firstChild: const Text('First Child'),
        secondChild: const Text('Second Child'),
        crossFadeState: CrossFadeState.showFirst,
      ),
    ],
  );

  Widget _buildImageSection() => Column(
    children: [
      Image.network('https://via.placeholder.com/150'),
      const SizedBox(height: 8),
      const Icon(Icons.image, size: 50),
    ],
  );

  Widget _buildLayoutSection() => Column(
    children: [
      const Text('Row and Column'),
      Row(children: const [Text('Row Item 1'), Text('Row Item 2')]),
      Column(children: const [Text('Column Item 1'), Text('Column Item 2')]),
    ],
  );

  Widget _buildMiscellaneousSection() => Column(
    children: [
      const Text('Miscellaneous Widgets'),
      const Divider(),
      const Tooltip(message: 'Tooltip', child: Text('Hover over me')),
      const SizedBox(height: 8),
      Transform.scale(scale: 1.5, child: const Text('Scaled Text')),
    ],
  );
}
