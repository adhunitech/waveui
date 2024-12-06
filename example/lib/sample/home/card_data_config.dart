import 'package:example/sample/src/drawer/drawer_example_page.dart';
import 'package:example/sample/src/snackbar.dart';
import 'package:example/sample/src/text/typography_page.dart';
import 'package:waveui/waveui.dart';
import 'package:example/sample/src/actionsheet/actionsheet_entry_page.dart';
import 'package:example/sample/src/appraise/appraise_example.dart';
import 'package:example/sample/src/bottom_tabbar/bottom_tabbar_example.dart';
import 'package:example/sample/src/calendar/calendarview_example.dart';
import 'package:example/sample/src/card/wave_shadow_example.dart';
import 'package:example/sample/src/card/bubble/bubble_entry_page.dart';
import 'package:example/sample/src/card/content/text_content_entry_page.dart';
import 'package:example/sample/src/card_title/title_example.dart';
import 'package:example/sample/src/dialog/dialog_entry_page.dart';
import 'package:example/sample/src/empty/abnormal_entry_page.dart';
import 'package:example/sample/src/gallery/gallery_example.dart';
import 'package:example/sample/src/guide/guide_entry_page.dart';
import 'package:example/sample/src/text_form_field.dart';
import 'package:example/sample/src/line/dashed_line_example.dart';
import 'package:example/sample/src/navbar/appbar_entry_page.dart';
import 'package:example/sample/src/noticebar/wave_notice_bar_example.dart';
import 'package:example/sample/src/picker/picker_entry_page.dart';
import 'package:example/sample/src/popup/popwindow_example.dart';
import 'package:example/sample/src/rating/rating_example.dart';
import 'package:example/sample/src/scroll_anchor/scroll_actor_tab_example.dart';
import 'package:example/sample/src/selection/selection_entry_page.dart';
import 'package:example/sample/src/step/step_example.dart';
import 'package:example/sample/src/sugsearch/search_text_example.dart';
import 'package:example/sample/src/switch/wave_switch_example.dart';
import 'package:example/sample/src/switch/checkbox_example.dart';
import 'package:example/sample/src/switch/radio_example.dart';
import 'package:example/sample/src/tabbar/wave_tab_example.dart';
import 'package:example/sample/src/tag/tag_example.dart';

///Card information
class GroupInfo {
  ///Unique ID
  int? groupId;

  ///Group name
  String groupName;

  ///describe
  String desc;

  ///Whether to expand
  bool isExpand;

  ///Child Widget
  List<GroupInfo>? children;

  ///Jump to the next page
  Widget? navigatorPage;

  GroupInfo(
      {this.groupId, this.groupName = "", this.desc = "", this.isExpand = false, this.navigatorPage, this.children});
}

///Data configuration class
class CardDataConfig {
  ///全部
  static List<GroupInfo> getAllGroup() {
    List<GroupInfo> list = [];
    list.add(_getDataInputGroup());
    list.add(_getOperateGroup());
    list.add(_getNavigatorGroup());
    list.add(_getButtonGroup());
    list.add(_getContentGroup());
    return list;
  }

  ///Data Entry
  static GroupInfo _getDataInputGroup() {
    List<GroupInfo> children = [];
    children
        .add(GroupInfo(groupName: "Picker", desc: "Select popup", navigatorPage: PickerEntryPage("Picker example")));
    children.add(GroupInfo(
        groupName: "Appraise Evaluation",
        desc: "Emoji and star evaluation components",
        navigatorPage: const AppraiseExample()));
    children.add(GroupInfo(
        groupName: "Text Form Field",
        desc: "Flutter default TextFormField",
        navigatorPage: const TextFormFieldExample()));
    return GroupInfo(groupName: "Data Entry", children: children, isExpand: false);
  }

  ///Operation feedback class
  static GroupInfo _getOperateGroup() {
    List<GroupInfo> children = [];
    children.add(GroupInfo(
        groupName: "Dialog Popup",
        desc: "Dialog display of various types",
        navigatorPage: const DialogEntryPage("Dialog type example")));
    children.add(GroupInfo(
        groupName: "ActionSheet bottom menu",
        desc: "Bottom Action Popup",
        navigatorPage: const ActionSheetEntryPage("ActionSheet example")));
    children.add(GroupInfo(
        groupName: "Tips",
        desc: "A prompt pops up at the specified position",
        navigatorPage: const PopWindowExamplePage("Tips example")));
    children.add(GroupInfo(groupName: "Snackbar", desc: "Styled snackbar", navigatorPage: const SnackbarExample()));

    return GroupInfo(groupName: "Operation Feedback", children: children, isExpand: false);
  }

  /// 导航类
  static GroupInfo _getNavigatorGroup() {
    List<GroupInfo> children = [];
    children.add(
        GroupInfo(groupName: "Navigation Bar", desc: "Appbar Navigation Bar", navigatorPage: const AppbarEntryPage()));
    children.add(GroupInfo(groupName: "Drawer", desc: "Customized Drawer", navigatorPage: const DrawerExamplePage()));
    children
        .add(GroupInfo(groupName: "Search Search", desc: "For search only", navigatorPage: const SearchTextExample()));
    children.add(GroupInfo(groupName: "Tabs to switch", desc: "tab", navigatorPage: const WaveTabExample()));
    children.add(
        GroupInfo(groupName: "BottomTabBar", desc: "Bottom Navigation", navigatorPage: const BottomTabbarExample()));
    children.add(GroupInfo(
        groupName: "Selection filter", desc: "Filter Item + Filter Drawer", navigatorPage: const SelectionEntryPage()));
    children.add(
        GroupInfo(groupName: "City Selection", desc: "city ​​selection", navigatorPage: _buildSingleSelectCityPage()));
    children.add(GroupInfo(
        groupName: "Anchor", desc: "Anchor Tab sliding instance", navigatorPage: const ScrollActorTabExample()));
    children
        .add(GroupInfo(groupName: "Guide", desc: "Strong Guide & Weak Guide", navigatorPage: const GuideEntryPage()));
    return GroupInfo(groupName: "Navigation", children: children);
  }

  ///button
  static GroupInfo _getButtonGroup() {
    List<GroupInfo> children = [];
    children.add(GroupInfo(groupName: "Radio", desc: "single button", navigatorPage: const RadioExample()));
    children.add(GroupInfo(
        groupName: "Checkbox multiple choice button",
        desc: "Multiple Choice Button",
        navigatorPage: const CheckboxExample()));
    children.add(GroupInfo(
        groupName: "SwitchButton normal button", desc: "Switch button", navigatorPage: const WaveSwitchExample()));
    return GroupInfo(groupName: "Button", children: children, isExpand: false);
  }

  ///content
  static GroupInfo _getContentGroup() {
    List<GroupInfo> children = [];
    children
        .add(GroupInfo(groupName: "Tag label", desc: "Various styles of labels", navigatorPage: const TagExample()));
    children.add(GroupInfo(groupName: "RatingBar", desc: "star rating bar", navigatorPage: const RatingExample()));
    children
        .add(GroupInfo(groupName: "DashedLine", desc: "Custom dashed line", navigatorPage: const DashedLineExample()));
    children.add(GroupInfo(groupName: "ShadowCard", desc: "WaveShadowCard", navigatorPage: const WaveShadowExample()));
    children.add(
        GroupInfo(groupName: "Title Title", desc: "Examples of various titles", navigatorPage: const TitleExample()));
    children.add(GroupInfo(
        groupName: "AbnormalCard",
        desc: "Multiple abnormal page display",
        navigatorPage: const AbnormalStatesEntryPage("Example of abnormal page")));
    children.add(GroupInfo(
        groupName: "Bubble", desc: "Normal Bubbles & Expandable Bubbles", navigatorPage: const BubbleEntryPage()));
    children.add(
        GroupInfo(groupName: "StepBar", desc: "horizontal & vertical step bar", navigatorPage: const StepExample()));
    children.add(GroupInfo(
        groupName: "Notification",
        desc: "Various notification styles, support setting icons and colors",
        navigatorPage: const WaveNoticeBarExample()));
    children.add(
        GroupInfo(groupName: "Text", desc: "Multi-style text content", navigatorPage: const TextContentEntryPage()));
    children.add(
        GroupInfo(groupName: "Typography", desc: "Multi-style text styles", navigatorPage: const TypographyPage()));
    children.add(GroupInfo(
        groupName: "Calendar",
        desc: "Calendar Component",
        navigatorPage: const CalendarViewExample("Calendar Component")));
    children.add(GroupInfo(
        groupName: "Gallery Pictures", desc: "Picture Selection & Picture View", navigatorPage: GalleryExample()));
    return GroupInfo(groupName: "Content", children: children);
  }

  ///city selection
  static Widget _buildSingleSelectCityPage() {
    List<WaveSelectCityModel> hotCityList = [];
    hotCityList.addAll([
      WaveSelectCityModel(name: "Beijing"),
      WaveSelectCityModel(name: "Guangzhou City"),
      WaveSelectCityModel(name: "Chengdu"),
      WaveSelectCityModel(name: "Shenzhen"),
      WaveSelectCityModel(name: "Hangzhou City"),
      WaveSelectCityModel(name: "Wuhan City"),
    ]);
    return WaveSingleSelectCityPage(
      appBarTitle: 'City Radio',
      hotCityTitle: 'Here is the recommended city',
      hotCityList: hotCityList,
    );
  }
}
