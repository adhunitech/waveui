import 'package:waveui/waveui.dart';

class WaveFilterEntity {
  String? key;
  late String name;
  String? defaultValue;
  late List<ItemEntity> children;

  WaveFilterEntity.fromJson(Map<String, dynamic> map) {
    key = map['key'] ?? '';
    name = map['title'] ?? '';
    defaultValue = map['defaultValue'] ?? '';
    children = [...(map['children'] as List? ?? []).map((o) => ItemEntity.fromJson(o))];
  }
}
