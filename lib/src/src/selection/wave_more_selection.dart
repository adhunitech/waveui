import 'dart:async';

import 'package:waveui/src/src/selection/wave_selection_util.dart';
import 'package:waveui/src/src/selection/widget/wave_selection_more_item_widget.dart';
import 'package:waveui/waveui.dart';

/// 更多的多选页面
/// 展示的内容：
///         1：以纯标签的形式展示筛选条件 比如：朝向
///         2：以可点击的layout 展示跳转至列表页面 比如：商圈
///         3：以标签和自定义的输入展示筛选条件 比如：面积
///
/// 筛选条件的单选多选判定规则是：父节点的 type 决定子节点的单选多选类型
///                          子节点的 type 决定了自己的展示UI
/// 比如 楼层，楼层节点的type是radio，那么 一层、二层都是 只能选中一个
///                               如果他的某个子节点是range type， 该子节点的展示是自定义输入
///
///
/// 参考[WaveSelectionEntity]和[WaveSelectionView]
class WaveMoreSelectionPage extends StatefulWidget {
  final WaveSelectionEntity entityData;
  final Function(WaveSelectionEntity)? confirmCallback;
  final WaveOnCustomFloatingLayerClick? onCustomFloatingLayerClick;
  final WaveSelectionConfig themeData;

  const WaveMoreSelectionPage(
      {Key? key,
      required this.entityData,
      this.confirmCallback,
      this.onCustomFloatingLayerClick,
      required this.themeData})
      : super(key: key);

  @override
  _WaveMoreSelectionPageState createState() => _WaveMoreSelectionPageState();
}

class _WaveMoreSelectionPageState extends State<WaveMoreSelectionPage> with SingleTickerProviderStateMixin {
  final List<WaveSelectionEntity> _originalSelectedItemsList = [];
  late AnimationController _controller;
  late Animation<Offset> _animation;
  final StreamController<ClearEvent> _clearController = StreamController.broadcast();
  bool isValid = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween(end: Offset.zero, begin: const Offset(1.0, 0.0)).animate(_controller);
    _controller.forward();

    _originalSelectedItemsList.addAll(widget.entityData.allSelectedList());
    for (WaveSelectionEntity entity in _originalSelectedItemsList) {
      entity.isSelected = true;
      if (entity.customMap != null) {
        // originalCustomMap 是用来存临时状态数据, customMap 用来展示 ui
        entity.originalCustomMap = Map.from(entity.customMap!);
      }
    }
  }

  /// 页面结构：左侧的透明黑 + 右侧宽为300的内容区域
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x660c0c0c),
      body: Row(
        children: <Widget>[
          _buildLeftSlide(context),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return SlideTransition(
                position: _animation,
                child: child,
              );
            },
            child: _buildRightSlide(context),
          )
        ],
      ),
      //为了解决 键盘抬起按钮的问题 将按钮移动到 此区域
      bottomNavigationBar: SizedBox(
        height: 80 + _getBottomAreaHeight(),
        child: Row(
          children: <Widget>[
            _buildLeftSlide(context),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return SlideTransition(
                  position: _animation,
                  child: child,
                );
              },
              child: Container(
                width: 300,
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    const WaveLine(),
                    Padding(
                      padding: const EdgeInsets.only(top: 14),
                      child: _buildBottomButtons(),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _clearController.close();
  }

  /// 左侧为透明黑，点击直接退出页面
  Widget _buildLeftSlide(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          WaveSelectionUtil.resetSelectionDatas(widget.entityData);
          //把数据还原
          for (var data in _originalSelectedItemsList) {
            data.isSelected = true;
            if (data.customMap != null) {
              // originalCustomMap 是用来存临时状态数据, customMap 用来展示 ui
              data.customMap = <String, String>{};
              data.originalCustomMap.forEach((key, value) {
                data.customMap![key.toString()] = value.toString();
              });
            }
          }
          Navigator.maybePop(context);
        },
        child: Container(
          color: Colors.transparent,
        ),
      ),
    );
  }

  /// 右侧为内容区域：标题+更多+筛选项的列表 + 底部按钮区域
  Widget _buildRightSlide(BuildContext context) {
    return Container(
      width: 300,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: _buildSelectionListView(),
      ),
    );
  }

  /// 标题+筛选条件的 列表
  Widget _buildSelectionListView() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return WaveMoreSelectionWidget(
            clearController: _clearController,
            selectionEntity: widget.entityData.children[index],
            onCustomFloatingLayerClick: widget.onCustomFloatingLayerClick,
            themeData: widget.themeData);
      },
      itemCount: widget.entityData.children.length,
    );
  }

  /// 清空筛选项 + 确定按钮
  Widget _buildBottomButtons() {
    return MoreBottomSelectionWidget(
      entity: widget.entityData,
      themeData: widget.themeData,
      clearCallback: () {
        setState(() {
          _clearController.add(ClearEvent());
          _clearUIData(widget.entityData);
        });
      },
      conformCallback: (data) {
        checkValue(data);
        if (!isValid) {
          isValid = true;
          return;
        }

        for (var data in widget.entityData.children) {
          if (data.selectedList().isNotEmpty) {
            data.isSelected = true;
          } else {
            data.isSelected = false;
          }
        }
        if (widget.confirmCallback != null) {
          widget.confirmCallback!(data);
        }
        Navigator.of(context).pop();
      },
    );
  }

  //清空UI效果
  void _clearUIData(WaveSelectionEntity entity) {
    entity.isSelected = false;
    entity.customMap = <String, String>{};
    if (WaveSelectionFilterType.range == entity.filterType) {
      entity.title = '';
    }
    for (WaveSelectionEntity subEntity in entity.children) {
      _clearUIData(subEntity);
    }
  }

  void checkValue(WaveSelectionEntity entity) {
    clearSelectedEntity();
  }

  void clearSelectedEntity() {
    List<WaveSelectionEntity> tmp = [];
    WaveSelectionEntity node = widget.entityData;
    tmp.add(node);
    while (tmp.isNotEmpty) {
      node = tmp.removeLast();
      if (node.isSelected &&
          (node.filterType == WaveSelectionFilterType.range ||
              node.filterType == WaveSelectionFilterType.dateRange ||
              node.filterType == WaveSelectionFilterType.dateRangeCalendar)) {
        if (node.customMap != null &&
            !WaveUITools.isEmpty(node.customMap!['min']) &&
            !WaveUITools.isEmpty(node.customMap!['max'])) {
          if (!node.isValidRange()) {
            isValid = false;
            if (node.filterType == WaveSelectionFilterType.range) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(WaveIntl.of(context).localizedResource.enterRangeError)));
            } else if (node.filterType == WaveSelectionFilterType.dateRange ||
                node.filterType == WaveSelectionFilterType.dateRangeCalendar) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(WaveIntl.of(context).localizedResource.enterRangeError)));
            }
            return;
          }
        } else {
          node.isSelected = false;
        }
      }
      for (var data in node.children) {
        tmp.add(data);
      }
    }
  }

  double _getBottomAreaHeight() {
    return MediaQuery.of(context).padding.bottom;
  }
}

/// 底部的重置+确定
class MoreBottomSelectionWidget extends StatelessWidget {
  final WaveSelectionEntity entity;
  final VoidCallback? clearCallback;
  final Function(WaveSelectionEntity)? conformCallback;
  final WaveSelectionConfig themeData;

  const MoreBottomSelectionWidget({
    Key? key,
    required this.entity,
    this.clearCallback,
    this.conformCallback,
    required this.themeData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if (clearCallback != null) {
              clearCallback!();
            }
          },
          child: Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 24,
                  width: 24,
                  child: WaveUITools.getAssetImage(WaveAsset.iconSelectionReset),
                ),
                Text(
                  WaveIntl.of(context).localizedResource.reset,
                  style: themeData.resetTextStyle.generateTextStyle(),
                )
              ],
            ),
          ),
        ),
        Expanded(
            child: FilledButton(
          child: Text(WaveIntl.of(context).localizedResource.ok),
          onPressed: () {
            if (conformCallback != null) {
              conformCallback!(entity);
            }
          },
        )),
      ],
    );
  }
}

//用于处理 重置事件
class ClearEvent {}
