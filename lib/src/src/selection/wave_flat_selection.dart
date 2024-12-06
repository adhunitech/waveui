import 'dart:async';

import 'package:waveui/src/src/popup/wave_measure_size.dart';
import 'package:waveui/src/src/selection/bean/wave_selection_common_entity.dart';
import 'package:waveui/src/src/selection/wave_selection_util.dart';
import 'package:waveui/src/src/selection/wave_selection_view.dart';
import 'package:waveui/src/src/selection/controller/wave_flat_selection_controller.dart';
import 'package:waveui/src/src/selection/converter/wave_selection_converter.dart';
import 'package:waveui/src/src/selection/widget/wave_flat_selection_item.dart';
import 'package:waveui/src/l10n/wave_intl.dart';
import 'package:waveui/src/theme/wave_theme_configurator.dart';
import 'package:waveui/src/theme/configs/wave_selection_config.dart';
import 'package:flutter/material.dart';

/// 支持tag 、输入 、range、选择等类型混合一级筛选
/// 也可支持点击选项跳转二级页面

// ignore: must_be_immutable
class WaveFlatSelection extends StatefulWidget {
  /// 筛选原始数据
  final List<WaveSelectionEntity> entityDataList;

  /// 点击确定回调
  final Function(Map<String, String>)? confirmCallback;

  /// 每行展示tag数量  默认真是3个
  final int preLineTagSize;

  /// 当[WaveSelectionEntity.filterType]为[WaveSelectionFilterType.layer] or[WaveSelectionFilterType.customLayer]时
  /// 跳转到二级页面的自定义操作
  final WaveOnCustomFloatingLayerClick? onCustomFloatingLayerClick;

  /// controller.dispose() 操作交由外部处理
  final WaveFlatSelectionController? controller;

  /// 是否需要配置子选项
  final bool isNeedConfigChild;

  /// 主题配置
  /// 如有对文本样式、圆角、间距等[WaveSelectionConfig]有特定要求可以配置该属性
  WaveSelectionConfig? themeData;

  WaveFlatSelection(
      {Key? key,
      required this.entityDataList,
      this.confirmCallback,
      this.onCustomFloatingLayerClick,
      this.preLineTagSize = 3,
      this.isNeedConfigChild = true,
      this.controller,
      this.themeData})
      : super(key: key) {
    themeData ??= WaveSelectionConfig();
    themeData =
        WaveThemeConfigurator.instance.getConfig(configId: themeData!.configId).selectionConfig.merge(themeData!);
  }

  @override
  _WaveFlatSelectionState createState() => _WaveFlatSelectionState();
}

class _WaveFlatSelectionState extends State<WaveFlatSelection> with SingleTickerProviderStateMixin {
  final List<WaveSelectionEntity> _originalSelectedItemsList = [];

  StreamController<FlatClearEvent> clearController = StreamController.broadcast();
  bool isValid = true;

  double _lineWidth = 0.0;

  @override
  void initState() {
    super.initState();

    if (widget.isNeedConfigChild) {
      for (var f in widget.entityDataList) {
        f.configRelationshipAndDefaultValue();
      }
    }
    widget.controller?.addListener(_handleFlatControllerTick);

    List<WaveSelectionEntity> firstColumn = [];
    if (widget.entityDataList.isNotEmpty) {
      for (WaveSelectionEntity entity in widget.entityDataList) {
        if (entity.isSelected) {
          firstColumn.add(entity);
        }
      }
    }
    _originalSelectedItemsList.addAll(firstColumn);
    if (firstColumn.isNotEmpty) {
      for (WaveSelectionEntity firstEntity in firstColumn) {
        List<WaveSelectionEntity> secondColumn = WaveSelectionUtil.currentSelectListForEntity(firstEntity);
        _originalSelectedItemsList.addAll(secondColumn);
        if (secondColumn.isNotEmpty) {
          for (WaveSelectionEntity secondEntity in secondColumn) {
            List<WaveSelectionEntity> thirdColumn = WaveSelectionUtil.currentSelectListForEntity(secondEntity);
            _originalSelectedItemsList.addAll(thirdColumn);
          }
        }
      }
    }

    for (WaveSelectionEntity entity in _originalSelectedItemsList) {
      entity.isSelected = true;
      if (entity.customMap != null) {
        // originalCustomMap 是用来存临时状态数据, customMap 用来展示 ui
        entity.originalCustomMap = Map.from(entity.customMap!);
      }
    }
  }

  void _handleFlatControllerTick() {
    if (widget.controller?.isResetSelectedOptions ?? false) {
      if (mounted) {
        setState(() {
          _resetSelectedOptions();
        });
      }
      widget.controller?.isResetSelectedOptions = false;
    } else if (widget.controller?.isCancelSelectedOptions ?? false) {
      // 外部关闭调用无UI更新操作
      _cancelSelectedOptions();
      widget.controller?.isCancelSelectedOptions = false;
    } else if (widget.controller?.isConfirmSelectedOptions ?? false) {
      _confirmSelectedOptions();
      widget.controller?.isConfirmSelectedOptions = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MeasureSize(
        onChange: (size) {
          setState(() {
            _lineWidth = size.width;
          });
        },
        child: _buildSelectionListView());
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleFlatControllerTick);
    super.dispose();
  }

  /// 取消
  _cancelSelectedOptions() {
    if (widget.entityDataList.isEmpty) {
      return;
    }
    for (WaveSelectionEntity entity in widget.entityDataList) {
      WaveSelectionUtil.resetSelectionDatas(entity);
    }
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
  }

  /// 重置
  _resetSelectedOptions() {
    clearController.add(FlatClearEvent());
    if (widget.entityDataList.isNotEmpty) {
      for (WaveSelectionEntity entity in widget.entityDataList) {
        _clearUIData(entity);
      }
    }
  }

  /// 确定
  void _confirmSelectedOptions() {
    _clearSelectedEntity();
    if (!isValid) {
      isValid = true;
      return;
    }

    for (var data in widget.entityDataList) {
      if (data.selectedList().isNotEmpty) {
        data.isSelected = true;
      } else {
        data.isSelected = false;
      }
    }
    if (widget.confirmCallback != null) {
      widget.confirmCallback!(const DefaultSelectionConverter().convertSelectedData(widget.entityDataList));
    }
  }

  /// 标题+筛选条件的 列表
  Widget _buildSelectionListView() {
    var contentWidget = Material(
        color: Colors.transparent,
        child: SizedBox(
          width: double.infinity,
          child: ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return WaveFlatMoreSelection(
                clearController: clearController,
                selectionEntity: widget.entityDataList[index],
                onCustomFloatingLayerClick: widget.onCustomFloatingLayerClick,
                preLineTagSize: widget.preLineTagSize,
                parentWidth: _lineWidth,
                themeData: widget.themeData!,
              );
            },
            itemCount: widget.entityDataList.length,
          ),
        ));

    return contentWidget;
  }

  /// 清空UI效果
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

  void _clearSelectedEntity() {
    List<WaveSelectionEntity> tmp = [];
    WaveSelectionEntity node;
    tmp.addAll(widget.entityDataList);
    while (tmp.isNotEmpty) {
      node = tmp.removeLast();
      if (!node.isValidRange()) {
        isValid = false;

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(WaveIntl.of(context).localizedResource.enterRangeError)));
        return;
      }
      for (var data in node.children) {
        tmp.add(data);
      }
    }
  }
}
