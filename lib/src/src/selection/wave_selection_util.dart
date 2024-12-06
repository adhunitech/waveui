import 'package:waveui/src/src/selection/bean/wave_selection_common_entity.dart';
import 'package:waveui/src/utils/wave_tools.dart';

const double DESIGN_SELECTION_HEIGHT = 268;
const double DESIGN_BOTTOM_HEIGHT = 82;
const double DESIGN_SCREEN_HEIGHT = 812;

class WaveSelectionUtil {
  /// 处理兄弟结点为未选中状态，将自己置为选中状态
  static void processBrotherItemSelectStatus(WaveSelectionEntity selectionEntity) {
    if (WaveSelectionFilterType.checkbox == selectionEntity.filterType) {
      selectionEntity.isSelected = !selectionEntity.isSelected;
      List<WaveSelectionEntity>? allBrothers = selectionEntity.parent?.children;
      if (!WaveUITools.isEmpty(allBrothers)) {
        for (WaveSelectionEntity entity in allBrothers!) {
          if (entity != selectionEntity) {
            if (entity.filterType == WaveSelectionFilterType.radio) {
              entity.isSelected = false;
            }

            if (entity.filterType == WaveSelectionFilterType.date) {
              entity.isSelected = false;
              entity.value = null;
            }
          }
        }
      }
    }
    if (WaveSelectionFilterType.radio == selectionEntity.filterType) {
      selectionEntity.parent?.clearChildSelection();
      selectionEntity.isSelected = true;
    }

    if (WaveSelectionFilterType.date == selectionEntity.filterType) {
      selectionEntity.parent?.clearChildSelection();

      /// 日期类型时在外部 Picker 点击确定时设置 选中状态
      selectionEntity.isSelected = true;
    }
  }

  /// 筛选项最多不超过三层,故直接写代码判断,本质为深度优先搜索。
  static int getTotalLevel(WaveSelectionEntity entity) {
    int level = 0;
    WaveSelectionEntity rootEntity = entity;
    while (rootEntity.parent != null) {
      rootEntity = rootEntity.parent!;
    }

    if (rootEntity.children.isNotEmpty) {
      level = level > 1 ? level : 1;
      for (WaveSelectionEntity firstLevelEntity in rootEntity.children) {
        if (firstLevelEntity.children.isNotEmpty) {
          level = level > 2 ? level : 2;
          for (WaveSelectionEntity secondLevelEntity in firstLevelEntity.children) {
            if (secondLevelEntity.children.isNotEmpty) {
              level = 3;
              break;
            }
          }
        }
      }
    }
    return level;
  }

  /// 返回状态为选中的子节点
  static List<WaveSelectionEntity> currentSelectListForEntity(WaveSelectionEntity entity) {
    List<WaveSelectionEntity> list = [];
    for (WaveSelectionEntity entity in entity.children) {
      if (entity.isSelected) {
        list.add(entity);
      }
    }
    return list;
  }

  /// 判断列表中是否有range类型
  static bool hasRangeItem(List<WaveSelectionEntity> list) {
    for (WaveSelectionEntity entity in list) {
      if (WaveSelectionFilterType.range == entity.filterType ||
          WaveSelectionFilterType.dateRange == entity.filterType ||
          WaveSelectionFilterType.dateRangeCalendar == entity.filterType ||
          WaveSelectionWindowType.range == entity.filterShowType) {
        return true;
      }
    }
    return false;
  }

  /// 判断列表中是否有range类型
  static WaveSelectionEntity? getFilledCustomInputItem(List<WaveSelectionEntity> list) {
    WaveSelectionEntity? filledCustomInputItem;
    for (WaveSelectionEntity entity in list) {
      if (entity.isSelected &&
          (WaveSelectionFilterType.range == entity.filterType ||
              WaveSelectionFilterType.dateRange == entity.filterType ||
              WaveSelectionFilterType.dateRangeCalendar == entity.filterType) &&
          entity.customMap != null) {
        filledCustomInputItem = entity;
        break;
      }
      if (entity.children.isNotEmpty) {
        filledCustomInputItem = getFilledCustomInputItem(entity.children);
      }
      if (filledCustomInputItem != null) {
        break;
      }
    }
    return filledCustomInputItem;
  }

  /// 确定当前 Item 在第几层级
  static int getCurrentListIndex(WaveSelectionEntity? currentItem) {
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
  static bool checkMaxSelectionCount(WaveSelectionEntity entity) {
    return entity.getLimitedRootSelectedChildCount() < entity.getLimitedRootMaxSelectedCount();
  }

//设置数据为未选中状态
  static void resetSelectionDatas(WaveSelectionEntity entity) {
    entity.isSelected = false;
    entity.customMap = <String, String>{};
    for (WaveSelectionEntity subEntity in entity.children) {
      resetSelectionDatas(subEntity);
    }
  }
}
