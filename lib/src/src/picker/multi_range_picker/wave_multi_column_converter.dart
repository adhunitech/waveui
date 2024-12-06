import 'package:waveui/src/src/picker/multi_range_picker/bean/wave_multi_column_picker_entity.dart';
import 'package:waveui/src/src/picker/multi_range_picker/wave_multi_column_picker_util.dart';
import 'package:waveui/src/utils/wave_tools.dart';

class WaveMultiRangeSelConverter {
  const WaveMultiRangeSelConverter();

  Map<String, List<WavePickerEntity>> convertPickedData(List<WavePickerEntity> selectedResults,
      {bool includeUnlimitSelection = false}) {
    return getSelectionParams(selectedResults, includeUnlimitSelection: includeUnlimitSelection);
  }

  Map<String, List<WavePickerEntity>> getSelectionParams(List<WavePickerEntity>? selectedResults,
      {bool includeUnlimitSelection = false}) {
    Map<String, List<WavePickerEntity>> params = {};
    if (selectedResults == null) return params;
    for (WavePickerEntity menuItemEntity in selectedResults) {
      int levelCount = WaveMultiColumnPickerUtil.getTotalColumnCount(menuItemEntity);
      if (levelCount == 1) {
        params
            .addAll(getCurrentSelectionEntityParams(menuItemEntity, includeUnlimitSelection: includeUnlimitSelection));
      } else if (levelCount == 2) {
        params
            .addAll(getCurrentSelectionEntityParams(menuItemEntity, includeUnlimitSelection: includeUnlimitSelection));
        for (var firstLevelItem in menuItemEntity.children) {
          mergeParams(params,
              getCurrentSelectionEntityParams(firstLevelItem, includeUnlimitSelection: includeUnlimitSelection));
        }
      } else if (levelCount == 3) {
        params
            .addAll(getCurrentSelectionEntityParams(menuItemEntity, includeUnlimitSelection: includeUnlimitSelection));
        for (var firstLevelItem in menuItemEntity.children) {
          mergeParams(params,
              getCurrentSelectionEntityParams(firstLevelItem, includeUnlimitSelection: includeUnlimitSelection));
          for (var secondLevelItem in firstLevelItem.children) {
            mergeParams(params,
                getCurrentSelectionEntityParams(secondLevelItem, includeUnlimitSelection: includeUnlimitSelection));
          }
        }
      }
    }
    return params;
  }

  Map<String?, List<WavePickerEntity>> mergeParams(
      Map<String?, List<WavePickerEntity>> params, Map<String?, List<WavePickerEntity>> selectedParams) {
    selectedParams.forEach((String? key, List<WavePickerEntity> value) {
      if (params.containsKey(key)) {
        params[key]?.addAll(value);
      } else {
        params.addAll(selectedParams);
      }
    });
    return params;
  }

  Map<String, List<WavePickerEntity>> getCurrentSelectionEntityParams(WavePickerEntity selectionEntity,
      {bool includeUnlimitSelection = false}) {
    Map<String, List<WavePickerEntity>> params = {};
    String parentKey = selectionEntity.key ?? '';
    var selectedEntity = selectionEntity.children
        .where((WavePickerEntity f) => f.isSelected)
        .where((WavePickerEntity f) {
          if (includeUnlimitSelection) {
            return true;
          } else {
            return !WaveUITools.isEmpty(f.value);
          }
        })
        .map((WavePickerEntity f) => f)
        .toList();
    List<WavePickerEntity> selectedParams = selectedEntity;
    if (!WaveUITools.isEmpty(selectedParams) && !WaveUITools.isEmpty(parentKey)) {
      params[parentKey] = selectedParams;
    }
    return params;
  }
}
