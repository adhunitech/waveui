import 'package:waveui/src/src/picker/multi_range_picker/bean/wave_multi_column_picker_entity.dart';

/// WaveMultiColumnPicker相关工具类
class WaveMultiColumnPickerUtil {
  /// 筛选项最多不超过三层,故直接写代码判断,本质为深度优先搜索。
  static int getTotalColumnCount(WavePickerEntity? entity) {
    int count = 0;
    WavePickerEntity? rootEntity = entity;
    while (rootEntity?.parent != null) {
      rootEntity = rootEntity?.parent!;
    }

    if (rootEntity != null && rootEntity.children.isNotEmpty) {
      count = count > 1 ? count : 1;
      for (WavePickerEntity firstLevelEntity in rootEntity.children) {
        if (firstLevelEntity.children.isNotEmpty) {
          count = count > 2 ? count : 2;
          for (WavePickerEntity secondLevelEntity in firstLevelEntity.children) {
            if (secondLevelEntity.children.isNotEmpty) {
              count = 3;
              break;
            }
          }
        }
      }
    }
    return count;
  }

  /// 确定当前 Item 在第几层级
  static int getCurrentColumnIndex(WavePickerEntity? currentItem) {
    int listIndex = -1;
    if (currentItem != null) {
      listIndex = 0;
      var parent = currentItem.parent;
      while (parent != null) {
        listIndex++;
        parent = parent.parent;
      }
    }
    return listIndex;
  }

  ///
  /// [entity] 传入当前点击的 Item
  /// !!! 在设置 isSelected = true之前进行 check。
  /// 返回 true 符合条件，false 不符合条件
  static bool isSelectedCountExceed(WavePickerEntity? entity) {
    if (entity == null || entity.parent == null) return false;
    return entity.parent!.getSelectedChildCount() < entity.parent!.maxSelectedCount;
  }
}
