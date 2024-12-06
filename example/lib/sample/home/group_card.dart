import 'package:get/get.dart';
import 'package:example/sample/home/list_item.dart';
import 'package:example/sample/home/card_data_config.dart';
import 'package:flutter/material.dart';

class GroupCard extends StatelessWidget {
  final GroupInfo? groupInfo;

  const GroupCard({
    super.key,
    this.groupInfo,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    groupInfo?.children?.forEach((element) {
      list.add(
        ListItem(
          title: element.groupName,
          describe: element.desc,
          onPressed: () {
            Get.to(element.navigatorPage);
          },
        ),
      );
    });
    return ExpansionTile(
      title: Text("${groupInfo?.groupName}"),
      children: list,
    );
  }
}
