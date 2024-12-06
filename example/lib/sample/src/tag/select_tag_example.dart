import 'package:example/sample/widgets.dart';
import 'package:waveui/waveui.dart';

///Tab selection view
class SelectTagExamplePage extends StatefulWidget {
  const SelectTagExamplePage({super.key});

  @override
  State<StatefulWidget> createState() => SelectTagExamplePageState();
}

class SelectTagExamplePageState extends State<SelectTagExamplePage> {
  List<String> tagList = [
    'This is a long long long long long long long long long long long long tag',
    'Label Information',
    'Tag information label information',
    'Label Information',
    'Tag InfoTag InfoTag InfoTag Info'
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WaveAppBar(
        title: 'WaveSelectTag',
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[_selectButtonExampleWidget(context)],
        ),
      ),
    );
  }

  Widget _selectButtonExampleWidget(context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'WaveSelectTag',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const Text(
            'radio function',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          WaveSelectTag(
              tags: tagList,
              spacing: 12,
              tagWidth: _getTagWidth(context),
              initTagState: const [true],
              onSelect: (selectedIndexes) {
                showSnackBar(
                  context,
                  msg: selectedIndexes.toString(),
                );
              }),
          const Text(
            'Multiple selection function',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          WaveSelectTag(
              isSingleSelect: false,
              tags: tagList,
              spacing: 12,
              tagWidth: _getTagWidth(context),
              initTagState: const [true, false, true],
              onSelect: (selectedIndexes) {
                showSnackBar(
                  context,
                  msg: selectedIndexes.toString(),
                );
              }),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Adaptive label for fluid layout',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          WaveSelectTag(
              tags: const [
                'Label',
                'Select label',
                'Unchecked label',
                'Label rounded corners, font size, color value, height can be theme configuration',
                'The component can be set to a fixed width or a fluid layout',
                'Theme customization can configure the minimum width, the minimum width is now limited to 110'
              ],
              isSingleSelect: false,
              fixWidthMode: false,
              spacing: 12,
              onSelect: (selectedIndexes) {
                showSnackBar(
                  context,
                  msg: selectedIndexes.toString(),
                );
              }),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Horizontal slide, equal width label',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          WaveSelectTag(
              tags: tagList,
              tagWidth: _getTagWidth(context),
              softWrap: false,
              onSelect: (index) {
                showSnackBar(
                  context,
                  msg: "$index is selected",
                );
              }),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Adaptive width label for horizontal sliding (minimum width 75)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          WaveSelectTag(
              tags: tagList,
              tagWidth: _getTagWidth(context),
              softWrap: false,
              fixWidthMode: false,
              onSelect: (index) {
                showSnackBar(
                  context,
                  msg: "$index is selected",
                );
              }),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  double _getTagWidth(context, {int rowCount = 4}) {
    double leftRightPadding = 40;
    double rowSpace = 12;
    return (MediaQuery.of(context).size.width - leftRightPadding - rowSpace * (rowCount - 1)) / rowCount;
  }
}
