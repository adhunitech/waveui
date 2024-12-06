import 'package:waveui/src/src/selection/bean/wave_selection_common_entity.dart';
import 'package:waveui/src/src/selection/wave_selection_util.dart';
import 'package:waveui/src/utils/wave_tools.dart';

abstract class WaveSelectionConverterDelegate {
  /// 统一的数据结构 转换为 用户需要的数据结构，并通过 [WaveSelectionOnSelectionChanged] 回传给用户使用。
  Map<String, String> convertSelectedData(List<WaveSelectionEntity> selectedResults);
}

class DefaultSelectionConverter implements WaveSelectionConverterDelegate {
  const DefaultSelectionConverter();

  @override
  Map<String, String> convertSelectedData(List<WaveSelectionEntity> selectedResults) {
    return getSelectionParams(selectedResults);
  }
}

class DefaultMoreSelectionConverter implements WaveSelectionConverterDelegate {
  const DefaultMoreSelectionConverter();

  @override
  Map<String, String> convertSelectedData(List<WaveSelectionEntity> selectedResults) {
    return getSelectionParams(selectedResults);
  }
}

class DefaultSelectionQuickFilterConverter implements WaveSelectionConverterDelegate {
  const DefaultSelectionQuickFilterConverter();

  @override
  Map<String, String> convertSelectedData(List<WaveSelectionEntity> selectedResults) {
    return getSelectionParams(selectedResults);
  }
}

/// 注意，此方法仅在初始化筛选项之前调用。如果再筛选之后使用会影响筛选View 的展示以及筛选结果。
Map<String, String> getSelectionParamsWithConfigChild(List<WaveSelectionEntity>? selectedResults) {
  Map<String, String> params = {};
  if (selectedResults == null) return params;
  for (var f in selectedResults) {
    f.configRelationshipAndDefaultValue();
  }
  return getSelectionParams(selectedResults);
}

Map<String, String> getSelectionParams(List<WaveSelectionEntity>? selectedResults) {
  Map<String, String> params = {};
  if (selectedResults == null) return params;
  for (WaveSelectionEntity menuItemEntity in selectedResults) {
    if (menuItemEntity.filterType == WaveSelectionFilterType.more) {
      params.addAll(getSelectionParams(menuItemEntity.children));
    } else {
      /// 1、首先找出 自定义范围的筛选项参数。
      WaveSelectionEntity? selectedCustomInputItem =
          WaveSelectionUtil.getFilledCustomInputItem(menuItemEntity.children);
      if (selectedCustomInputItem != null && !WaveUITools.isEmpty(selectedCustomInputItem.customMap)) {
        String? key = selectedCustomInputItem.parent?.key;
        if (!WaveUITools.isEmpty(key)) {
          params[key!] =
              '${selectedCustomInputItem.customMap!["min"] ?? ''}:${selectedCustomInputItem.customMap!["max"] ?? ''}';
        }
      }

      /// 2、一次找出层级为 1、2、3 的选中项的参数，递归不好阅读，直接写成 for 嵌套遍历。
      int levelCount = WaveSelectionUtil.getTotalLevel(menuItemEntity);
      if (levelCount == 1) {
        params.addAll(getCurrentSelectionEntityParams(menuItemEntity));
      } else if (levelCount == 2) {
        params.addAll(getCurrentSelectionEntityParams(menuItemEntity));
        for (var firstLevelItem in menuItemEntity.children) {
          params.addAll(getCurrentSelectionEntityParams(firstLevelItem));
        }
      } else if (levelCount == 3) {
        params.addAll(getCurrentSelectionEntityParams(menuItemEntity));
        for (var firstLevelItem in menuItemEntity.children) {
          params.addAll(getCurrentSelectionEntityParams(firstLevelItem));
          for (var secondLevelItem in firstLevelItem.children) {
            params.addAll(getCurrentSelectionEntityParams(secondLevelItem));
          }
        }
      }
    }
  }
  return params;
}

Map<String, String> getCurrentSelectionEntityParams(WaveSelectionEntity selectionEntity) {
  Map<String, String> params = {};
  String? parentKey = selectionEntity.key;
  List<String?> selectedEntity = selectionEntity.children
      .where((WaveSelectionEntity f) => f.isSelected)
      .where((WaveSelectionEntity f) => !WaveUITools.isEmpty(f.value))
      .map((WaveSelectionEntity f) => f.value)
      .toList();
  String selectedParams = selectedEntity.isEmpty ? '' : selectedEntity.join(',');
  if (!WaveUITools.isEmpty(selectedParams) && !WaveUITools.isEmpty(parentKey)) {
    params[parentKey!] = selectedParams;
  }
  return params;
}
