import 'package:waveui/src/src/selectcity/wave_az_common.dart';

class WaveSelectCityModel extends ISuspensionBean {
  /// 城市名称
  @override
  String name = "";

  /// 城市名称前这是的标记符号
  String tagIndex = "";

  /// 拼音
  String? namePinyin;

  @override
  String tag = "";

  /// 城市编码
  String cityCode = "";

  WaveSelectCityModel({
    required this.name,
    this.tagIndex = "",
    this.namePinyin,
    this.tag = "",
    this.cityCode = "",
  });

  WaveSelectCityModel.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson() => {
        'name': name,
        'tagIndex': tagIndex,
        'namePinyin': namePinyin,
        'isShowSuspension': isShowSuspension,
        'cityCode': cityCode
      };

  String getSuspensionTag() => tagIndex;

  @override
  String toString() => "CityBean {" " \"name\":\"" + name + "\"" + '}';
}
