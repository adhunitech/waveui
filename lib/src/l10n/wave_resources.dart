import 'dart:core';
import 'dart:ui';

/// resource abstract class
abstract class WaveBaseResource {
  String get ok;

  String get cancel;

  String get confirm;

  String get loading;

  String get pleaseEnter;

  String get enterRangeError;

  String get pleaseChoose;

  String get selectRangeError;

  String get reset;

  String get confirmClearSelectedList;

  String get selectedList;

  String get clear;

  String get shareTo;

  List<String> get appriseLevel;

  String get dateFormate_yyyy_MM;

  String get dateFormate_yyyy_MM_dd;

  String get dateFormate_yyyy_MMMM_dd;

  String get expand;

  String get collapse;

  String get more;

  String get allPics;

  String get submit;

  String get noTagDataTip;

  List<String> get months;

  List<String> get weekFullName;

  List<String> get weekShortName;

  List<String> get weekMinName;

  String get skip;

  String get known;

  String get next;

  String get inputSearchTip;

  String get done;

  String get noDataTip;

  String get selectAll;

  String get selected;

  String get shareWayTip;

  String get max;

  String get min;

  String get selectCountLimitTip;

  String get to;

  String get recommandCity;

  String get selectCity;

  String get filterConditionCountLimited;

  String get minValue;

  String get maxValue;

  String selectTitle(String selected);

  String get customRange;

  String get startDate;

  String get endDate;

  String get selectStartDate;

  String get selectEndDate;

  List<String> get shareChannels;

  String get fetchErrorAndRetry;

  String get netErrorAndRetryLater;

  String get noSearchData;

  String get clickPageAndRetry;
}

///
/// en resources
///
class WaveResourceEn extends WaveBaseResource {
  static Locale locale = const Locale('en', 'US');

  @override
  String get ok => 'Ok';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get loading => 'Loading ...';

  @override
  String get pleaseEnter => 'Please Enter';

  @override
  String get enterRangeError => 'The range you entered is incorrect';

  @override
  String get pleaseChoose => 'Please choose';

  @override
  String get selectRangeError => 'You have selected the wrong range';

  @override
  String get reset => 'Reset';

  @override
  String get confirmClearSelectedList =>
      'Are you sure you want to clear the selected list?';

  @override
  String get selectedList => 'Selected list';

  @override
  String get clear => 'Clear';

  @override
  String get shareTo => 'Share to';

  @override
  List<String> get appriseLevel => [
        'not good',
        'good',
        'satisfy',
        'great',
        'surprise',
      ];

  @override
  String get dateFormate_yyyy_MM => 'MM/yyyy';

  @override
  String get dateFormate_yyyy_MM_dd => 'dd/MM/yyyy';

  @override
  String get dateFormate_yyyy_MMMM_dd => 'dd/MMMM/yyyy';

  @override
  String get expand => 'Expand';

  @override
  String get collapse => 'Collapse';

  @override
  String get more => 'More';

  @override
  String get allPics => 'All pictures';

  @override
  String get submit => 'Submit';

  @override
  String get noTagDataTip => 'Tag data not configured yet';

  @override
  List<String> get months => [
        '01',
        '02',
        '03',
        '04',
        '05',
        '06',
        '07',
        '08',
        '09',
        '10',
        '11',
        '12',
      ];

  @override
  List<String> get weekFullName => [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
      ];

  @override
  List<String> get weekShortName => [
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat',
        'Sun',
      ];

  @override
  List<String> get weekMinName => [
        'U',
        'M',
        'T',
        'W',
        'R',
        'F',
        'S',
      ];

  @override
  String get skip => 'Skip';

  @override
  String get known => 'I see';

  @override
  String get next => 'Next';

  @override
  String get inputSearchTip => 'Please enter search content';

  @override
  String get done => 'Done';

  @override
  String get noDataTip => 'No data';

  @override
  String get selectAll => 'Select all';

  @override
  String get selected => 'Selected';

  @override
  String get shareWayTip =>
      'You can share with customers in the following ways';

  @override
  String get max => 'Min';

  @override
  String get min => 'Max';

  @override
  String get selectCountLimitTip =>
      'You have already selected the maximum number';

  @override
  String get to => 'to';

  @override
  String get recommandCity => 'Here are the recommended cities';

  @override
  String get selectCity => 'Select city';

  @override
  String get filterConditionCountLimited =>
      'You have selected the maximum number of filters';

  @override
  String get minValue => 'Min';

  @override
  String get maxValue => 'Max';

  @override
  String selectTitle(String selected) => 'Select $selected';

  @override
  String get customRange => 'Custom range';

  @override
  String get startDate => 'Start date';

  @override
  String get endDate => 'End date';

  @override
  String get selectStartDate => 'Please select a start time';

  @override
  String get selectEndDate => 'Please select a end time';

  @override
  List<String> get shareChannels => [
        'Wechat',
        'Friends',
        'QQ',
        'QQ Zone',
        'Weibo',
        'Link',
        'Message',
        'Clipboard',
        'Browser',
        'Photo Album',
      ];

  @override
  String get fetchErrorAndRetry => 'Fetch data fail, please try again';

  @override
  String get netErrorAndRetryLater =>
      'Network connection failed, check and try again';

  @override
  String get noSearchData => 'No search results';

  @override
  String get clickPageAndRetry => 'Please click the page to try again';
}
