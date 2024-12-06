import 'dart:convert';

import 'package:waveui/waveui.dart';
import 'package:example/sample/src/selection/flat_selection_five_tags_example.dart';
import 'package:example/sample/src/selection/flat_selection_four_tags_example.dart';
import 'package:example/sample/src/selection/flat_selection_three_tags_example.dart';
import 'package:example/sample/home/list_item.dart';
import 'package:flutter/services.dart';

class FlatSelectionEntryPage extends StatelessWidget {
  const FlatSelectionEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const WaveAppBar(
          title: 'Selection 示例',
        ),
        body: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: const Text(
                "WaveSelectionView 组件：",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.purple),
              ),
            ),
            const Divider(indent: 15),
            ListItem(
              title: "新筛选示例(更多里面抽出平级筛选+一行3个tag)",
              onPressed: () {
                rootBundle.loadString('assets/flat_selection_filter.json').then((data) {
                  var datas = WaveSelectionEntityListBean.fromJson(const JsonDecoder().convert(data)["data"])!.list!;
                  void configMaxSelectedCount(WaveSelectionEntity entity, int maxCount) {
                    entity.maxSelectedCount = maxCount;
                    if (entity.children.isNotEmpty) {
                      for (WaveSelectionEntity child in entity.children) {
                        configMaxSelectedCount(child, maxCount);
                      }
                    }
                  }

                  configMaxSelectedCount(datas[0].children[1], 5);
                  var page = FlatSelectionThreeTagsExample("新筛选示例(更多里面抽出平级筛选+一行3个tag)", datas);
                  Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) {
                      return page;
                    },
                  ));
                });
              },
            ),
            ListItem(
              title: "新筛选示例(更多里面抽出平级筛选+一行4个tag)",
              onPressed: () {
                rootBundle.loadString('assets/flat_selection_filter.json').then((data) {
                  var datas = WaveSelectionEntityListBean.fromJson(const JsonDecoder().convert(data)["data"])!.list!;
                  void configMaxSelectedCount(WaveSelectionEntity entity, int maxCount) {
                    entity.maxSelectedCount = maxCount;
                    if (entity.children.isNotEmpty) {
                      for (WaveSelectionEntity child in entity.children) {
                        configMaxSelectedCount(child, maxCount);
                      }
                    }
                  }

                  configMaxSelectedCount(datas[0].children[1], 5);
                  var page = FlatSelectionFourTagsExample("新筛选示例(更多里面抽出平级筛选+一行4个tag)", datas);
                  Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) {
                      return page;
                    },
                  ));
                });
              },
            ),
            ListItem(
              title: "新筛选示例(更多里面抽出平级筛选+一行5个tag)",
              onPressed: () {
                rootBundle.loadString('assets/flat_selection_filter.json').then((data) {
                  var datas = WaveSelectionEntityListBean.fromJson(const JsonDecoder().convert(data)["data"])!.list!;
                  void configMaxSelectedCount(WaveSelectionEntity entity, int maxCount) {
                    entity.maxSelectedCount = maxCount;
                    if (entity.children.isNotEmpty) {
                      for (WaveSelectionEntity child in entity.children) {
                        configMaxSelectedCount(child, maxCount);
                      }
                    }
                  }

                  configMaxSelectedCount(datas[0].children[1], 5);
                  var page = NewSelectionViewExamplePage23("新筛选示例(更多里面抽出平级筛选+一行5个tag)", datas);
                  Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) {
                      return page;
                    },
                  ));
                });
              },
            ),
          ],
        ));
  }
}
