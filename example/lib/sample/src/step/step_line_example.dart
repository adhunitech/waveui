import 'dart:math';

import 'package:waveui/waveui.dart';

class StepLineExample extends StatefulWidget {
  const StepLineExample({super.key});

  @override
  _StepLineExampleState createState() => _StepLineExampleState();
}

class _StepLineExampleState extends State<StepLineExample> {
  int? count;

  @override
  void initState() {
    super.initState();
    count = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const WaveAppBar(
        title: '竖向步骤条',
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '规则',
              style: TextStyle(
                  color: WaveThemeConfigurator.instance
                      .getConfig()
                      .commonConfig
                      .colorTextBase,
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
            const WaveBubbleText(
                maxLines: 2,
                text: '头部icon需要显示主题相关的icon，线条需要时圆头\n,'
                    '线条的高度随着左侧内容变化而改变，线宽2'),
            Text(
              '第一个高亮',
              style: TextStyle(
                color: Get.theme.colorScheme.primary,
                fontSize: 16,
              ),
            ),
            ListView.builder(
              padding: const EdgeInsets.only(top: 20),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (context, index) {
                return WaveStepLine(
                  lineWidth: 1,
                  //非第一个是灰色
                  isGrey: index != 0,
                  iconTopPadding: 20,
                  //最后一个的线条为透明色 做到不显示的效果
                  lineColor:
                      index == 2 ? Colors.transparent : const Color(0xffeeeeee),
                  contentWidget: Container(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '步骤${index + 1}',
                          style: TextStyle(
                            height: 0.9,
                            color: WaveThemeConfigurator.instance
                                .getConfig()
                                .commonConfig
                                .colorTextBase,
                            fontSize: 16,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 20),
                          child: Text(
                            '辅助信息',
                            style: TextStyle(
                              color: WaveThemeConfigurator.instance
                                  .getConfig()
                                  .commonConfig
                                  .colorTextSecondary,
                              fontSize: 14,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
            Text(
              '最后一个灰色',
              style: TextStyle(
                color: Get.theme.colorScheme.primary,
                fontSize: 16,
              ),
            ),
            ListView.builder(
              padding: const EdgeInsets.only(top: 20),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (context, index) {
                return WaveStepLine(
                  lineWidth: 1,
                  //非第一个是灰色
                  isGrey: index == 2,
                  //最后一个的线条为透明色 做到不显示的效果
                  lineColor: index == 2 ? Colors.transparent : null,
                  highlightColor: Get.theme.colorScheme.primary,
                  contentWidget: Container(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '步骤${index + 1}',
                          style: TextStyle(
                            height: 0.9,
                            color: WaveThemeConfigurator.instance
                                .getConfig()
                                .commonConfig
                                .colorTextBase,
                            fontSize: 16,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 20),
                          child: Text(
                            '辅助信息',
                            style: TextStyle(
                              color: WaveThemeConfigurator.instance
                                  .getConfig()
                                  .commonConfig
                                  .colorTextSecondary,
                              fontSize: 14,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
            Text(
              '颜色线条变化',
              style: TextStyle(
                color: Get.theme.colorScheme.primary,
                fontSize: 16,
              ),
            ),
            ListView.builder(
              padding: const EdgeInsets.only(top: 20),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (context, index) {
                return WaveStepLine(
                  lineWidth: 1,
                  //最后一个的线条为透明色 做到不显示的效果
                  lineColor: index == 2
                      ? Colors.transparent
                      : (index == 1
                          ? [Get.theme.colorScheme.primary, Colors.red]
                          : null),
                  highlightColor:
                      index == 2 ? Colors.red : Get.theme.colorScheme.primary,
                  contentWidget: Container(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '步骤${index + 1}',
                          style: TextStyle(
                            height: 0.9,
                            color: WaveThemeConfigurator.instance
                                .getConfig()
                                .commonConfig
                                .colorTextBase,
                            fontSize: 16,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 20),
                          child: Text(
                            '辅助信息',
                            style: TextStyle(
                              color: WaveThemeConfigurator.instance
                                  .getConfig()
                                  .commonConfig
                                  .colorTextSecondary,
                              fontSize: 14,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
            Text(
              '全灰色',
              style: TextStyle(
                color: Get.theme.colorScheme.primary,
                fontSize: 16,
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (context, index) {
                return WaveStepLine(
                  lineWidth: 1,
                  isGrey: true,
                  contentWidget: Container(
                    height: 50,
                    color: getRandomColor(),
                  ),
                );
              },
            ),
            Text(
              '最后一条不显示',
              style: TextStyle(
                color: Get.theme.colorScheme.primary,
                fontSize: 16,
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                if (index == 4) {
                  return WaveStepLine(
                    lineWidth: 1,
                    lineColor: Colors.transparent,
                    contentWidget: Container(
                      height: 50,
                      color: getRandomColor(),
                    ),
                  );
                }
                return WaveStepLine(
                  lineWidth: 1,
                  contentWidget: Container(
                    height: 50,
                    color: getRandomColor(),
                  ),
                );
              },
            ),
            Text(
              '线条颜色有变化',
              style: TextStyle(
                color: Get.theme.colorScheme.primary,
                fontSize: 16,
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                if (index == 4) {
                  return WaveStepLine(
                    lineWidth: 1,
                    lineColor: <Color>[
                      Get.theme.colorScheme.primary,
                      Colors.red,
                    ],
                    contentWidget: Container(
                      height: 60,
                      color: getRandomColor(),
                    ),
                  );
                }
                return WaveStepLine(
                  lineWidth: 1,
                  contentWidget: Container(
                    height: 50,
                    color: getRandomColor(),
                  ),
                );
              },
            ),
            Text(
              '虚线显示',
              style: TextStyle(
                color: Get.theme.colorScheme.primary,
                fontSize: 16,
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return WaveStepLine(
                  lineWidth: 1,
                  lineColor: <Color>[
                    Get.theme.colorScheme.primary,
                    Colors.red,
                  ],
                  isDashLine: true,
                  dashLength: 11,
                  contentWidget: Container(
                    height: 150,
                    color: getRandomColor(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  dynamic getLineColor(int index) {
    return index == 1
        ? [Get.theme.colorScheme.primary, Colors.red]
        : (index == 2 ? Colors.transparent : const Color(0xffeeeeee));
  }

  Color getRandomColor() {
    return Color.fromARGB(Random().nextInt(255), Random().nextInt(255),
        Random().nextInt(255), Random().nextInt(255));
  }
}
