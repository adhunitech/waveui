import 'dart:convert';

import 'package:waveui/waveui.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:flutter/services.dart';

class CitySelectRoute extends StatefulWidget {
  const CitySelectRoute({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CitySelectRouteState();
  }
}

class _CitySelectRouteState extends State<CitySelectRoute> {
  final List<WaveSelectCityModel> _cityList = [];
  final List<WaveSelectCityModel> _hotCityList = [];

  final int _suspensionHeight = 40;
  final int _itemHeight = 50;
  String _suspensionTag = "";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    _hotCityList.add(WaveSelectCityModel(name: "Beijing", tagIndex: "★"));
    //load city list
    rootBundle.loadString('assets/china.json').then((value) {
      Map countyMap = json.decode(value);
      List list = countyMap['china'];
      for (var value in list) {
        _cityList.add(WaveSelectCityModel(name: value['name']));
      }
      _handleList(_cityList);
      _cityList.insertAll(0, _hotCityList);
      setState(() {
        _suspensionTag = _cityList[0].getSuspensionTag();
      });
    });
  }

  void _handleList(List<WaveSelectCityModel> list) {
    if (list.isEmpty) return;
    for (int i = 0, length = list.length; i < length; i++) {
      String pinyin = PinyinHelper.getPinyinE(list[i].name);
      String tag = pinyin.substring(0, 1).toUpperCase();
      list[i].namePinyin = pinyin;
      if (RegExp("[A-Z]").hasMatch(tag)) {
        list[i].tagIndex = tag;
      } else {
        list[i].tagIndex = "#";
      }
    }
    //Sort according to A-Z
    SuspensionUtil.sortListBySuspensionTag(_cityList);
  }

  //floating city tag
  void _onSusTagChanged(String tag) {
    setState(() {
      _suspensionTag = tag;
    });
  }

  Widget _buildSusWidget(String susTag) {
    susTag = (susTag == "★" ? "Default City" : susTag);
    return Container(
      height: _suspensionHeight.toDouble(),
      padding: const EdgeInsets.only(left: 20.0),
      color: const Color(0xfff3f4f5),
      alignment: Alignment.centerLeft,
      child: Text(
        susTag,
        softWrap: false,
        style: const TextStyle(
          fontSize: 13.0,
          color: Color(0xff9399A5),
        ),
      ),
    );
  }

  Widget _buildListItem(WaveSelectCityModel model) {
    String susTag = model.getSuspensionTag();
    susTag = (susTag == "★" ? "Default City" : susTag);
    return Column(
      children: <Widget>[
        //When offstage is true, the current control will not be drawn on the screen
        //If the item is not suspended (Beijing), it will not be displayed
        Offstage(
          offstage: !model.isShowSuspension,
          child: _buildSusWidget(susTag),
        ),

        Container(
          height: (_itemHeight - 0.5).toDouble(),
          padding: const EdgeInsets.only(left: 20.0),
          color: Colors.white,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              model.name,
              style: const TextStyle(color: Color(0xff101D37), fontSize: 16),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Container(
            height: 0.5,
            color: const Color(0xffE4E6F0),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WaveAppBar(
        title: 'Select City Example',
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: AzListView(
                data: _cityList,
                itemBuilder: (context, model) =>
                    _buildListItem(model as WaveSelectCityModel),
                suspensionWidget: _buildSusWidget(_suspensionTag),
                isUseRealIndex: true,
                itemHeight: _itemHeight,
                suspensionHeight: _suspensionHeight,
                onSusTagChanged: _onSusTagChanged,
              )),
        ],
      ),
    );
  }
}
