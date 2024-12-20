import 'package:waveui/src/src/picker/multi_range_picker/wave_multi_column_picker_util.dart';
import 'package:waveui/src/src/picker/multi_range_picker/btn_multi_column_picker_item.dart';
import 'package:waveui/waveui.dart';

/// 单个 item 点击的回调
/// [listIndex] 点击位置处于第几列
/// [index] 点击位置处于当前列的位置
/// [entity] 被点击位置的数据
typedef WaveOnSelectEntityInterceptor = bool Function(int? listIndex, int index, WavePickerEntity entity);

// ignore: must_be_immutable
class WaveMultiColumnListWidget extends StatefulWidget {
  List<WavePickerEntity>? _selectedItems;
  int? focusedIndex = -1;
  List<WavePickerEntity>? items;
  Color normalColor;
  Color selectedColor;
  Color? backgroundColor;
  Color? selectedBackgroundColor;
  int flex;
  WaveOnEntityTap? singleListItemPick;
  int? currentListIndex;
  double maxHeight;
  WaveOnSelectEntityInterceptor? onSelectEntityInterceptor;

  WaveMultiColumnListWidget({
    super.key,
    required this.items,
    this.normalColor = const Color(0Xff4a4e59),
    this.selectedColor = const Color(0xff41bc6a),
    this.maxHeight = 0,
    this.backgroundColor,
    this.selectedBackgroundColor,
    required this.flex,
    this.focusedIndex,
    this.singleListItemPick,
    this.onSelectEntityInterceptor,
  }) {
    items ??= [];
    for (var element in items!) {
      element.configRelationship();
    }

    currentListIndex = WaveMultiColumnPickerUtil.getCurrentColumnIndex(items!.isNotEmpty ? items![0] : null);

    _selectedItems = items?.where((f) => f.isSelected).toList();
    _selectedItems ??= [];
  }

  @override
  _WaveMultiColumnListWidgetState createState() => _WaveMultiColumnListWidgetState();

  List<WavePickerEntity>? getSelectedItems() {
    return _selectedItems;
  }
}

class _WaveMultiColumnListWidgetState extends State<WaveMultiColumnListWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: widget.flex,
      child: Container(
        constraints:
            (widget.maxHeight == 0) ? const BoxConstraints.expand() : BoxConstraints(maxHeight: widget.maxHeight),
        color: widget.backgroundColor,
        child: ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.only(top: 0),
          scrollDirection: Axis.vertical,
          itemCount: widget.items!.length,
          separatorBuilder: (BuildContext context, int index) => Container(),
          itemBuilder: (BuildContext context, int index) {
            WavePickerEntity item = widget.items![index];

            /// 点击筛选，展开弹窗时，默认展示上次选中的筛选项。
            bool isCurrentFocused = _isItemFocused(index, item);

            return WaveMultiRangePickerCommonItem(
              item: item,
              normalColor: widget.normalColor,
              selectColor: widget.selectedColor,
              backgroundColor: widget.backgroundColor,
              selectedBackgroundColor: widget.selectedBackgroundColor,
              isCurrentFocused: isCurrentFocused,
              isMoreSelectionListType: false,
              isFirstLevel: (1 == widget.currentListIndex) ? true : false,
              itemSelectFunction: (WavePickerEntity entity) {
                if (widget.onSelectEntityInterceptor != null &&
                    widget.onSelectEntityInterceptor!(widget.currentListIndex, index, entity) == false) {
                  return;
                }
                _processFilterData(entity);
                if (widget.singleListItemPick != null) {
                  widget.singleListItemPick!(widget.currentListIndex ?? 0, index, entity);
                }
              },
            );
          },
        ),
      ),
    );
  }

  bool _isItemFocused(int itemIndex, WavePickerEntity item) {
    bool isFocused = widget.focusedIndex == itemIndex;
    if (!isFocused && widget.focusedIndex == -1 && item.isSelected) {
      isFocused = true;
    }
    return isFocused;
  }

  /// Item 点击之后的数据处理
  void _processFilterData(WavePickerEntity? selectedEntity) {
    if (null == selectedEntity) {
      return;
    }

    if (selectedEntity.filterType == PickerFilterType.checkbox && !selectedEntity.isSelected) {
      if (!WaveMultiColumnPickerUtil.isSelectedCountExceed(selectedEntity)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(WaveIntl.of(context).localizedResource.selectCountLimitTip)));
   
        return;
      }
    }

    int totalLevel = WaveMultiColumnPickerUtil.getTotalColumnCount(selectedEntity);
    if (selectedEntity.isUnLimit() && selectedEntity.parent != null) {
      selectedEntity.parent!.clearChildSelection();
    }

    /// 设置选中数据。
    /// 当选中的数据不是最后一列时，相当于不选中数据
    /// 当选中为不限类型时，不再设置选中状态。
    if (totalLevel == 1) {
      _configFirstList(selectedEntity);
    } else if (totalLevel == 2) {
      _configSecondList(selectedEntity, widget.currentListIndex);
    } else if (totalLevel == 3) {
      _configThirdList(selectedEntity, widget.currentListIndex);
    }

    /// Warning !!!
    /// （两列、三列时）第一列节点是否被选中取决于它的子节点是否被选中，
    /// 只有当它子节点被选中时才会认为第一列的节点相应被选中。
    if (widget.items != null && widget.items!.isNotEmpty && widget.items![0].parent != null) {
      widget.items![0].parent?.isSelected =
          widget.items![0].parent!.children.where((WavePickerEntity f) => f.isSelected).isNotEmpty;
    }

    for (WavePickerEntity item in widget.items!) {
      if (item.isSelected) {
        if (!widget._selectedItems!.contains(item)) {
          widget._selectedItems!.add(item);
        }
      } else {
        if (widget._selectedItems!.contains(item)) {
          widget._selectedItems!.remove(item);
        }
      }
    }
  }

  void _configFirstList(WavePickerEntity selectedEntity) {
    if (PickerFilterType.radio == selectedEntity.filterType) {
      /// 单选，清除同一级别选中的状态，则其他的设置为未选中。
      selectedEntity.parent!.clearChildSelection();
      selectedEntity.isSelected = true;
    } else if (PickerFilterType.checkbox == selectedEntity.filterType) {
      /// 选中【不限】清除同一级别其他的状态
      if (selectedEntity.isUnLimit()) {
        selectedEntity.parent!.clearChildSelection();
        selectedEntity.isSelected = true;
      } else {
        ///清除【不限】类型。
        List<WavePickerEntity> brotherItems;
        if (selectedEntity.parent == null) {
          brotherItems = widget.items ?? [];
        } else {
          brotherItems = selectedEntity.parent!.children;
        }
        for (WavePickerEntity entity in brotherItems) {
          if (entity.isUnLimit()) {
            entity.isSelected = false;
          }
        }
        selectedEntity.isSelected = !selectedEntity.isSelected;
      }
    }
  }

  void _configSecondList(WavePickerEntity selectedEntity, int? currentListIndex) {
    if (currentListIndex == 1) {
      if (PickerFilterType.checkbox != selectedEntity.filterType) {
        selectedEntity.parent!.clearChildSelection();
      }
    } else {
      /// 单选，清除同一级别选中的状态，则其他的设置为未选中。
      if (PickerFilterType.radio == selectedEntity.filterType) {
        selectedEntity.parent!.clearChildSelection();
        selectedEntity.isSelected = true;
      } else if (PickerFilterType.checkbox == selectedEntity.filterType) {
        /// 选中【不限】清除同一级别其他的状态
        if (selectedEntity.isUnLimit()) {
          selectedEntity.parent!.clearChildSelection();
          selectedEntity.isSelected = true;
        } else {
          ///清除【不限】类型。
          List<WavePickerEntity> brotherItems;
          if (selectedEntity.parent == null) {
            brotherItems = widget.items ?? [];
          } else {
            brotherItems = selectedEntity.parent!.children;
          }
          for (WavePickerEntity entity in brotherItems) {
            if (entity.isUnLimit()) {
              entity.isSelected = false;
            }
          }
          selectedEntity.isSelected = !selectedEntity.isSelected;
        }
      }
    }
  }

  void _configThirdList(WavePickerEntity selectedEntity, int? currentListIndex) {
    if (currentListIndex == 1) {
      if (PickerFilterType.checkbox != selectedEntity.filterType) {
        selectedEntity.parent!.clearChildSelection();
      }
    } else {
      /// 单选，清除同一级别选中的状态，则其他的设置为未选中。
      if (PickerFilterType.radio == selectedEntity.filterType) {
        selectedEntity.parent!.clearChildSelection();
        selectedEntity.isSelected = true;
      } else if (PickerFilterType.checkbox == selectedEntity.filterType) {
        /// 选中【不限】清除同一级别其他的状态
        if (selectedEntity.isUnLimit()) {
          selectedEntity.parent!.clearChildSelection();
          selectedEntity.isSelected = true;
        } else {
          ///清除【不限】类型。
          List<WavePickerEntity> brotherItems;
          if (selectedEntity.parent == null) {
            brotherItems = widget.items ?? [];
          } else {
            brotherItems = selectedEntity.parent!.children;
          }
          for (WavePickerEntity entity in brotherItems) {
            if (entity.isUnLimit()) {
              entity.isSelected = false;
            }
          }
          selectedEntity.isSelected = !selectedEntity.isSelected;
        }
      }
    }
  }
}
