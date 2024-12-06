import 'package:waveui/src/src/selection/bean/wave_selection_common_entity.dart';

class WaveSelectionEntityListBean {
  List<WaveSelectionEntity>? list;

  WaveSelectionEntityListBean(this.list);

  static WaveSelectionEntityListBean? fromJson(Map<String, dynamic>? map) {
    if (map == null || map['list'] == null) return null;
    WaveSelectionEntityListBean bean = WaveSelectionEntityListBean(null);
    bean.list = (map['list'] as List).map((o) => WaveSelectionEntity.fromMap(o)).toList();
    return bean;
  }
}
