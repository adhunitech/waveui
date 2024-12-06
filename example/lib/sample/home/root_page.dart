import 'package:example/sample/home/card_data_config.dart';
import 'package:waveui/waveui.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<GroupInfo> list = CardDataConfig.getAllGroup();

    return Scaffold(
      appBar: WaveAppBar(
        title: 'WaveUI',
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(FluentIcons.navigation_24_regular),
        ),
      ),
      body: SingleChildScrollView(
        child: ListView.builder(
          itemCount: list.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            var group = list[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text(
                    group.groupName,
                    style: Get.textTheme.titleMedium,
                  ),
                ),
                Column(
                  children: (group.children ?? [])
                      .map(
                        (e) => ListTile(
                          tileColor: Theme.of(context).cardColor,
                          onTap: () {
                            Get.to(e.navigatorPage);
                          },
                          title: Text(e.groupName),
                          subtitle: Text(e.desc),
                        ),
                      )
                      .toList(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
