import 'package:example/sample/widgets.dart';
import 'package:waveui/waveui.dart';
import 'package:example/sample/home/list_item.dart';

class CustomPickerExamplePage extends StatelessWidget {
  const CustomPickerExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const WaveAppBar(
          title: '自定义底部弹窗',
        ),
        body: ListView(
          children: <Widget>[
            ListItem(
              title: "底部弹窗的内容为输入框",
              describe: '被键盘抬起',
              isShowLine: false,
              onPressed: () {
                WaveBottomPicker.show(context, onCancel: () {
                  Navigator.of(context).pop();
                },
                    onConfirm: () {},
                    contentWidget: Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '键盘抬起，不遮挡picker',
                            style: TextStyle(
                              color: Color(0xFF222222),
                              fontSize: 20,
                            ),
                          ),
                          TextField(
                            autofocus: true,
                            decoration: InputDecoration(hintText: '请输入'),
                          )
                        ],
                      ),
                    ));
              },
            ),
            ListItem(
              title: "底部弹窗确定取消事件",
              describe: '支持底部弹窗确定取消事件并不关闭弹窗',
              onPressed: () {
                WaveBottomPicker.show(context, onConfirm: () {
                  showSnackBar(context, msg: '不关闭');
                }, onCancel: () {
                  showSnackBar(context, msg: '不关闭');
                },
                    contentWidget: const Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '通过属性支持确定和取消不关闭弹窗',
                          style: TextStyle(
                            color: Color(0xFF222222),
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ));
              },
            ),
            ListItem(
              title: "底部弹窗不显示title",
              describe: '支持底部弹窗不显示title',
              onPressed: () {
                WaveBottomPicker.show(context,
                    showTitle: false,
                    contentWidget: Container(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'showTitle 属性设置为 false，不显示顶部title区域，',
                            style: TextStyle(
                              color: Color(0xFF222222),
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            '其他区域可以完全自定义',
                            style: TextStyle(
                              color: Color(0xFF222222),
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ));
              },
            ),
            ListItem(
              title: "点击遮罩不关闭",
              describe: '支持点击遮罩不关闭',
              onPressed: () {
                WaveBottomPicker.show(context,
                    barrierDismissible: false,
                    contentWidget: Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '键盘抬起，不遮挡picker',
                            style: TextStyle(
                              color: Color(0xFF222222),
                              fontSize: 20,
                            ),
                          ),
                          TextField(
                            autofocus: true,
                            decoration: InputDecoration(hintText: '请输入'),
                          )
                        ],
                      ),
                    ));
              },
            ),
          ],
        ));
  }
}
