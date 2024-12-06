import 'package:waveui/src/src/selection/bean/wave_selection_common_entity.dart';
import 'package:waveui/src/src/selection/wave_more_selection.dart';
import 'package:waveui/src/src/selection/controller/wave_selection_view_controller.dart';
import 'package:waveui/src/src/selection/converter/wave_selection_converter.dart';
import 'package:waveui/src/src/selection/widget/wave_selection_menu_widget.dart';
import 'package:waveui/src/theme/wave_theme_configurator.dart';
import 'package:waveui/src/theme/configs/wave_selection_config.dart';
import 'package:waveui/src/utils/wave_event_bus.dart';
import 'package:flutter/material.dart';

/// 配置 类型为 Range 展示时，每行 tag 的数量
/// [index] 第几个 menu
/// [entity] index 对应的 筛选对象
typedef WaveConfigTagCountPerRow = Function(int index, WaveSelectionEntity entity);

/// [menuTitle] 设置自定义 menu 的Title文案
/// [isMenuTitleHighLight] 设置自定义 menu 的 title 是否高亮
typedef WaveSetCustomSelectionMenuTitle = void Function({String menuTitle, bool isMenuTitleHighLight});

typedef WaveOnSelectionChanged = void Function(int menuIndex, Map<String, String> selectedParams,
    Map<String, String> customParams, WaveSetCustomSelectionMenuTitle setCustomMenuTitle);

/// menu 点击拦截回调
/// [index] menu 的索引位置
/// 返回 true 拦截点击方法，false 不拦截
typedef WaveOnMenuItemInterceptor = bool Function(int index);

/// 筛选弹窗打开前的回调方法。
typedef WaveOnSelectionPreShow = WaveSelectionWindowType Function(int index, WaveSelectionEntity entity);

/// 点击【更多】筛选项时的回调，
/// [index] 为点击的位置，
/// [openMorePage] 为让用户触发的回调用于展开更多筛选页面
typedef WaveOnMoreSelectionMenuClick = void Function(int index, WaveOpenMorePage openMorePage);

/// 打开更多筛选页面，
/// [updateData] 是否要更新更多筛选的数据，
/// [moreSelections] 最新的更多筛选数据，是否更新取决于 [updateData]
typedef WaveOpenMorePage = void Function({bool updateData, List<WaveSelectionEntity> moreSelections});

/// 自定义类型的 Menu 被点击时 让外部设置选中的 value 进来统一更新 UI，并将 function 传给外部设置筛选值。
typedef WaveSetCustomSelectionParams = void Function(Map<String, String> customParams);

/// 自定义类型的 menu 被点击的回调，
/// [index] 点击位置，
/// [customMenuItem] 自定义筛选 menu 原始数据，
/// [customSelectionParams] 开放给外部回调给函数，用于更新自定义筛选参数，触发[WaveOnSelectionChanged]。
typedef WaveOnCustomSelectionMenuClick = Function(
    int index, WaveSelectionEntity customMenuItem, WaveSetCustomSelectionParams customSelectionParams);

/// 当更多筛选页面中，类型为 CustomLayer 被回调时，该函数用于回传参数进 WaveSelectionView 中，
/// [customParams] 用户自定义参数。
typedef WaveSetCustomFloatingLayerSelectionParams = void Function(List<WaveSelectionEntity> customParams);

/// 类型为 CustomLayer 被点击的回调
/// [index] 被点击的位置
/// [customFloatingLayerEntity] 被点击 index 位置的筛选数据
/// [setCustomFloatingLayerSelectionParams] 外部自定义参数回传函数
typedef WaveOnCustomFloatingLayerClick = Function(int index, WaveSelectionEntity customFloatingLayerEntity,
    WaveSetCustomFloatingLayerSelectionParams setCustomFloatingLayerSelectionParams);

typedef OnDefaultParamsPrepared = void Function(Map<String, String> selectedParams);

/// 默认筛选参数转换器，对传入的筛选数据做处理，返回 Map 参数对象。
const WaveSelectionConverterDelegate _defaultConverter = DefaultSelectionConverter();

// ignore: must_be_immutable
class WaveSelectionView extends StatefulWidget {
  final WaveSelectionConverterDelegate selectionConverterDelegate;
  final WaveOnCustomSelectionMenuClick? onCustomSelectionMenuClick;
  final WaveOnCustomFloatingLayerClick? onCustomFloatingLayerClick;
  final WaveOnMoreSelectionMenuClick? onMoreSelectionMenuClick;
  final WaveOnSelectionChanged onSelectionChanged;
  final List<WaveSelectionEntity> originalSelectionData;
  final WaveOnMenuItemInterceptor? onMenuClickInterceptor;
  final WaveOnSelectionPreShow? onSelectionPreShow;

  ///筛选所在列表的外部列表滚动需要收起筛选，此处为最外层列表，有点恶心，但是暂时只想到这个方法，有更好方式的一定要告诉我
  final ScrollController? extraScrollController;

  ///指定筛选固定的相对于屏幕的顶部距离，默认null不指定
  final double? constantTop;

  /// 处理完默认选中的参数后给外部回调
  final OnDefaultParamsPrepared? onDefaultParamsPrepared;

  /// 用于对 SelectionWindowType.Range 类型的列数做配置的回调。
  final WaveConfigTagCountPerRow? configRowCount;

  WaveSelectionViewController? selectionViewController;

  WaveSelectionConfig? themeData;

  WaveSelectionView(
      {Key? key,
      required this.originalSelectionData,
      this.selectionViewController,
      required this.onSelectionChanged,
      this.configRowCount,
      this.selectionConverterDelegate = _defaultConverter,
      this.onMenuClickInterceptor,
      this.onCustomSelectionMenuClick,
      this.onCustomFloatingLayerClick,
      this.onMoreSelectionMenuClick,
      this.onDefaultParamsPrepared,
      this.onSelectionPreShow,
      this.constantTop,
      this.extraScrollController,
      this.themeData})
      : super(key: key) {
    themeData ??= WaveSelectionConfig();
    themeData =
        WaveThemeConfigurator.instance.getConfig(configId: themeData!.configId).selectionConfig.merge(themeData!);
  }

  @override
  State<StatefulWidget> createState() => WaveSelectionViewState();
}

class WaveSelectionViewState extends State<WaveSelectionView> {
  final Map<String, String> _customParams = {};
  WaveSelectionViewController? _selectionViewController;

  @override
  void initState() {
    super.initState();
    _selectionViewController = widget.selectionViewController ?? WaveSelectionViewController();
    for (var f in widget.originalSelectionData) {
      f.configRelationshipAndDefaultValue();
    }

    if (widget.onDefaultParamsPrepared != null) {
      widget.onDefaultParamsPrepared!(
          widget.selectionConverterDelegate.convertSelectedData(widget.originalSelectionData));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.originalSelectionData.isNotEmpty) {
      for (var f in widget.originalSelectionData) {
        f.configRelationship();
      }
      return WaveSelectionMenuWidget(
        context: context,
        data: widget.originalSelectionData,
        themeData: widget.themeData!,
        extraScrollController: widget.extraScrollController,
        constantTop: widget.constantTop,
        configRowCount: widget.configRowCount,
        onMenuItemClick: (int menuIndex) {
          if (widget.onMenuClickInterceptor != null && widget.onMenuClickInterceptor!(menuIndex)) {
            return true;
          }

          if (widget.onSelectionPreShow != null) {
            widget.originalSelectionData[menuIndex].filterShowType =
                widget.onSelectionPreShow!(menuIndex, widget.originalSelectionData[menuIndex]);
          }

          /// 自定义 Menu 的时候，
          /// 1、外部设置选中的 key-value 参数。
          /// 2、触发更新 UI。
          /// 3、触发 _onSelectionChanged 统一回调给外部
          if (widget.originalSelectionData[menuIndex].filterType == WaveSelectionFilterType.customHandle &&
              widget.onCustomSelectionMenuClick != null) {
            widget.onCustomSelectionMenuClick!(menuIndex, widget.originalSelectionData[menuIndex],
                (Map<String, String> customParams) {
              _customParams.clear();
              _customParams.addAll(customParams);
              _onSelectionChanged(menuIndex);
              setState(() {});
            });
          }

          /// 自定义 Menu 的时候，让外部设置选中的 value 进来统一更新 UI。 然后触发 _onSelectionChanged 统一回调给外部
          if (widget.originalSelectionData[menuIndex].filterType == WaveSelectionFilterType.more &&
              widget.onMoreSelectionMenuClick != null) {
            widget.onMoreSelectionMenuClick!(menuIndex, (
                {bool updateData = false, List<WaveSelectionEntity>? moreSelections}) {
              if (updateData) {
                List<WaveSelectionEntity> moreSelectionEntities = moreSelections ?? [];
                widget.originalSelectionData[menuIndex].children = moreSelectionEntities;
                widget.originalSelectionData[menuIndex].configRelationshipAndDefaultValue();
              }
              setState(() {});
              _openMore(widget.originalSelectionData[menuIndex],
                  onCustomFloatingLayerClick: widget.onCustomFloatingLayerClick);
            });
          }
          return false;
        },
        onConfirm: (WaveSelectionEntity results, int firstIndex, int secondIndex, int thirdIndex) {
          _onSelectionChanged(widget.originalSelectionData.indexOf(results));
        },
      );
    }
    return Container();
  }

  void _onSelectionChanged(int menuIndex) {
    widget.onSelectionChanged(
        menuIndex, widget.selectionConverterDelegate.convertSelectedData(widget.originalSelectionData), _customParams, (
            {String? menuTitle, bool isMenuTitleHighLight = false}) {
      /// 说明没有 menu 被选中，不需要更新。
      if (menuIndex >= 0) {
        widget.originalSelectionData[menuIndex].isCustomTitleHighLight = isMenuTitleHighLight;
        widget.originalSelectionData[menuIndex].customTitle = menuTitle;
      }

      /// 当设置了自定义的参数时：
      /// 1、执行关闭筛选页面动作（会将menu 中的箭头置为朝下的非激活状态）；
      /// 2、刷新 Menu title；
      _selectionViewController?.closeSelectionView();
      _selectionViewController?.refreshSelectionTitle();
      setState(() {});
    });
    setState(() {});
  }

  void _openMore(WaveSelectionEntity entity, {WaveOnCustomFloatingLayerClick? onCustomFloatingLayerClick}) {
    if (entity.children.isNotEmpty) {
      Navigator.of(context).push(PageRouteBuilder(
          opaque: false,
          pageBuilder: (context, animation, second) {
            return WaveMoreSelectionPage(
              entityData: entity,
              themeData: widget.themeData!,
              onCustomFloatingLayerClick: onCustomFloatingLayerClick,
              confirmCallback: (_) {
                EventBus.instance.fire(RefreshMenuTitleEvent());
                _onSelectionChanged(widget.originalSelectionData.indexOf(entity));
              },
            );
          }));
    }
  }
}
