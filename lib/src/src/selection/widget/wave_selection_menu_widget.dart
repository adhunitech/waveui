import 'dart:async';

import 'package:waveui/src/src/selection/wave_selection_util.dart';
import 'package:waveui/src/src/selection/widget/wave_selection_list_widget.dart';
import 'package:waveui/src/src/selection/widget/wave_selection_menu_item_widget.dart';
import 'package:waveui/src/src/selection/widget/wave_selection_range_widget.dart';
import 'package:waveui/src/utils/wave_event_bus.dart';
import 'package:waveui/waveui.dart';

typedef WaveOnMenuItemClick = bool Function(int index);

typedef WaveOnRangeSelectionConfirm = void Function(
    WaveSelectionEntity results, int firstIndex, int secondIndex, int thirdIndex);

class WaveSelectionMenuWidget extends StatefulWidget {
  final List<WaveSelectionEntity> data;
  final BuildContext context;
  final double height;
  final double? width;
  final WaveOnRangeSelectionConfirm? onConfirm;
  final WaveOnMenuItemClick? onMenuItemClick;
  final WaveConfigTagCountPerRow? configRowCount;

  ///筛选所在列表的外部列表滚动需要收起筛选，此处为最外层列表，有点恶心，但是暂时只想到这个方法，有更好方式的一定要告诉我
  final ScrollController? extraScrollController;

  ///指定筛选固定的相对于屏幕的顶部距离，默认null不指定
  final double? constantTop;

  final WaveSelectionConfig themeData;

  const WaveSelectionMenuWidget(
      {Key? key,
      required this.context,
      required this.data,
      this.height = 50.0,
      this.width,
      this.onMenuItemClick,
      this.onConfirm,
      this.configRowCount,
      this.extraScrollController,
      this.constantTop,
      required this.themeData})
      : super(key: key);

  @override
  _WaveSelectionMenuWidgetState createState() => _WaveSelectionMenuWidgetState();
}

class _WaveSelectionMenuWidgetState extends State<WaveSelectionMenuWidget> {
  bool _needRefreshTitle = true;
  List<WaveSelectionEntity> result = [];
  List<String> titles = [];
  List<bool> menuItemActiveState = [];
  List<bool> menuItemHighlightState = [];
  WaveSelectionListViewController listViewController = WaveSelectionListViewController();
  ScrollController? _scrollController;

  late StreamSubscription _refreshTitleSubscription;

  late StreamSubscription _closeSelectionPopupWindowSubscription;

  @override
  void initState() {
    super.initState();
    _refreshTitleSubscription = EventBus.instance.on<RefreshMenuTitleEvent>().listen((RefreshMenuTitleEvent event) {
      _needRefreshTitle = true;
      setState(() {});
    });

    _closeSelectionPopupWindowSubscription =
        EventBus.instance.on<CloseSelectionViewEvent>().listen((CloseSelectionViewEvent event) {
      _closeSelectionPopupWindow();
    });

    if (widget.extraScrollController != null) {
      _scrollController = widget.extraScrollController!;
      _scrollController!.addListener(_closeSelectionPopupWindow);
    }

    for (WaveSelectionEntity parentEntity in widget.data) {
      titles.add(parentEntity.title);
      menuItemActiveState.add(false);
      menuItemHighlightState.add(false);
    }
  }

  void _closeSelectionPopupWindow() {
    if (listViewController.isShow) {
      listViewController.hide();
      setState(() {
        for (int i = 0; i < menuItemActiveState.length; i++) {
          if (i != listViewController.menuIndex) {
            menuItemActiveState[i] = false;
          } else {
            menuItemActiveState[i] = !menuItemActiveState[i];
          }
          if (widget.data[listViewController.menuIndex].type == 'more') {
            menuItemActiveState[i] = false;
          }
        }
      });
    }
  }

  @override
  dispose() {
    _scrollController?.removeListener(_closeSelectionPopupWindow);
    _refreshTitleSubscription.cancel();
    _closeSelectionPopupWindowSubscription.cancel();
    listViewController.hide();
    super.dispose();
  }

  /// 根据【Filter组】 创建 widget。
  OverlayEntry _createEntry(WaveSelectionEntity entity) {
    var content = _isRange(entity) ? _createRangeView(entity) : _createSelectionListView(entity);
    return OverlayEntry(builder: (context) {
      return GestureDetector(
        onTap: () {
          _closeSelectionPopupWindow();
        },
        child: Container(
          padding: EdgeInsets.only(
            top: listViewController.listViewTop ?? 0,
          ),
          child: Stack(
            children: <Widget>[WaveSelectionAnimationWidget(controller: listViewController, view: content)],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: (widget.width != null) ? widget.width : MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 990,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _configMenuItems(),
            ),
          ),
          Expanded(
            flex: 10,
            child: Container(
              height: 0.5,
              color: Get.theme.dividerColor,
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _configMenuItems() {
    List<Widget> itemViewList = [];
    itemViewList.add(const Padding(
      padding: EdgeInsets.only(left: 14),
    ));
    for (int index = 0; index < titles.length; index++) {
      if (_needRefreshTitle) {
        _refreshSelectionMenuTitle(index, widget.data[index]);
        if (index == titles.length - 1) {
          _needRefreshTitle = false;
        }
      }
      itemViewList.add(const Padding(
        padding: EdgeInsets.only(left: 6),
      ));
      itemViewList.add(WaveSelectionMenuItemWidget(
        title: titles[index],
        themeData: widget.themeData,
        active: menuItemActiveState[index],
        isHighLight: menuItemActiveState[index] || menuItemHighlightState[index],
        itemClickFunction: () {
          if (widget.onMenuItemClick != null) {
            /// 拦截 menuItem 点击。
            if (widget.onMenuItemClick!(index)) {
              return;
            }
          }
          RenderBox? dropDownItemRenderBox;
          if (context.findRenderObject() != null && context.findRenderObject() is RenderBox) {
            dropDownItemRenderBox = context.findRenderObject() as RenderBox;
          }
          Offset? position = dropDownItemRenderBox?.localToGlobal(Offset.zero, ancestor: null);
          Size? size = dropDownItemRenderBox?.size;
          listViewController.listViewTop = (size?.height ?? 0) + (widget.constantTop ?? position?.dy ?? 0);
          if (listViewController.isShow && listViewController.menuIndex != index) {
            listViewController.hide();
          }

          if (listViewController.isShow) {
            listViewController.hide();
          } else {
            /// 点击不是 More、自定义类型，则直接展开。
            if (widget.data[index].filterType != WaveSelectionFilterType.more &&
                widget.data[index].filterType != WaveSelectionFilterType.customHandle) {
              /// 创建 筛选组件的的入口
              OverlayEntry entry = _createEntry(widget.data[index]);
              Overlay.of(widget.context).insert(entry);

              listViewController.entry = entry;
              listViewController.show(index);
            } else if (widget.data[index].filterType == WaveSelectionFilterType.customHandle) {
              /// 记录自定义筛选 menu 的点击状态，当点击自定义的 menu 时，menu 文案默认高亮。
              listViewController.show(index);
              _refreshSelectionMenuTitle(index, widget.data[index]);
            } else {
              _refreshSelectionMenuTitle(index, widget.data[index]);
            }
          }

          setState(() {
            for (int i = 0; i < menuItemActiveState.length; i++) {
              if (i != index) {
                menuItemActiveState[i] = false;
              } else {
                menuItemActiveState[i] = !menuItemActiveState[i];
              }
              if (widget.data[index].type == 'more') {
                menuItemActiveState[i] = false;
              }
            }
          });
        },
      ));
      itemViewList.add(const Padding(
        padding: EdgeInsets.only(left: 6),
      ));
    }
    itemViewList.add(const Padding(
      padding: EdgeInsets.only(left: 14),
    ));
    return itemViewList;
  }

  /// 1、子筛选项包含自定义范围的时候，使用 Tag 模式展示。
  /// 2、被指定为 Tag 模式展示。
  /// 3、只有一列筛选数据，且为多选时，使用 Tag 模式展示
  bool _isRange(WaveSelectionEntity entity) {
    if (WaveSelectionUtil.hasRangeItem(entity.children) || entity.filterShowType == WaveSelectionWindowType.range) {
      return true;
    }
    var totalLevel = WaveSelectionUtil.getTotalLevel(entity);
    if (totalLevel == 1 && entity.filterType == WaveSelectionFilterType.checkbox) {
      return true;
    }
    return false;
  }

  Widget _createRangeView(WaveSelectionEntity entity) {
    int? rowCount;
    if (widget.configRowCount != null) {
      rowCount = widget.configRowCount!(widget.data.indexOf(entity), entity) ?? rowCount;
    }
    return WaveRangeSelectionGroupWidget(
      entity: entity,
      marginTop: listViewController.listViewTop ?? 0,
      maxContentHeight: DESIGN_SELECTION_HEIGHT / DESIGN_SCREEN_HEIGHT * MediaQuery.of(context).size.height,
      // UI 给出的内容高度比例 248:812
      themeData: widget.themeData,
      rowCount: rowCount,
      bgClickFunction: () {
        setState(() {
          menuItemActiveState[listViewController.menuIndex] = false;
          if (entity.selectedListWithoutUnlimit().isNotEmpty) {
            menuItemHighlightState[listViewController.menuIndex] = true;
          }
          listViewController.hide();
        });
      },
      onSelectionConfirm: (WaveSelectionEntity result, int firstIndex, int secondIndex, int thirdIndex) {
        setState(() {
          _onConfirmSelect(entity, result, firstIndex, secondIndex, thirdIndex);
        });
      },
    );
  }

  Widget _createSelectionListView(WaveSelectionEntity entity) {
    /// 顶层筛选 Tab
    return WaveListSelectionGroupWidget(
      entity: entity,
      maxContentHeight: DESIGN_SELECTION_HEIGHT / DESIGN_SCREEN_HEIGHT * MediaQuery.of(context).size.height,
      themeData: widget.themeData,
      // UI 给出的内容高度比例 248:812
      bgClickFunction: () {
        setState(() {
          menuItemActiveState[listViewController.menuIndex] = false;
          if (entity.selectedListWithoutUnlimit().isNotEmpty) {
            menuItemHighlightState[listViewController.menuIndex] = true;
          }
          listViewController.hide();
        });
      },
      onSelectionConfirm: (WaveSelectionEntity result, int firstIndex, int secondIndex, int thirdIndex) {
        setState(() {
          _onConfirmSelect(entity, result, firstIndex, secondIndex, thirdIndex);
        });
      },
    );
  }

  void _onConfirmSelect(
      WaveSelectionEntity entity, WaveSelectionEntity result, int firstIndex, int secondIndex, int thirdIndex) {
    if (listViewController.menuIndex < titles.length) {
      if (widget.onConfirm != null) {
        widget.onConfirm!(result, firstIndex, secondIndex, thirdIndex);
      }
      menuItemActiveState[listViewController.menuIndex] = false;
      _refreshSelectionMenuTitle(listViewController.menuIndex, entity);
      listViewController.hide();
    }
  }

  /// 筛选 Title 展示规则
  String? _getSelectedResultTitle(WaveSelectionEntity entity) {
    /// 更多筛选不改变 title.故返回 null
    if (entity.filterType == WaveSelectionFilterType.more) {
      return null;
    }
    if (WaveUITools.isEmpty(entity.customTitle)) {
      return _getTitle(entity);
    } else {
      return entity.customTitle;
    }
  }

  String? _getTitle(WaveSelectionEntity entity) {
    String? title;
    List<WaveSelectionEntity> firstColumn = WaveSelectionUtil.currentSelectListForEntity(entity);
    List<WaveSelectionEntity> secondColumn = [];
    List<WaveSelectionEntity> thirdColumn = [];
    if (firstColumn.isNotEmpty) {
      for (WaveSelectionEntity firstEntity in firstColumn) {
        secondColumn.addAll(WaveSelectionUtil.currentSelectListForEntity(firstEntity));
        if (secondColumn.isNotEmpty) {
          for (WaveSelectionEntity secondEntity in secondColumn) {
            thirdColumn.addAll(WaveSelectionUtil.currentSelectListForEntity(secondEntity));
          }
        }
      }
    }

    if (firstColumn.isEmpty || firstColumn.length > 1) {
      title = entity.title;
    } else {
      /// 第一列选中了一个，为【不限】类型，使用上一级别的名字展示。
      if (firstColumn[0].isUnLimit()) {
        title = entity.title;
      } else if (firstColumn[0].filterType == WaveSelectionFilterType.range ||
          firstColumn[0].filterType == WaveSelectionFilterType.date ||
          firstColumn[0].filterType == WaveSelectionFilterType.dateRange ||
          firstColumn[0].filterType == WaveSelectionFilterType.dateRangeCalendar) {
        title = _getDateAndRangeTitle(firstColumn, entity);
      } else {
        if (secondColumn.isEmpty || secondColumn.length > 1) {
          title = firstColumn[0].title;
        } else {
          /// 第二列选中了一个，为【不限】类型，使用上一级别的名字展示。
          if (secondColumn[0].isUnLimit()) {
            title = firstColumn[0].title;
          } else if (secondColumn[0].filterType == WaveSelectionFilterType.range ||
              secondColumn[0].filterType == WaveSelectionFilterType.date ||
              secondColumn[0].filterType == WaveSelectionFilterType.dateRange ||
              secondColumn[0].filterType == WaveSelectionFilterType.dateRangeCalendar) {
            title = _getDateAndRangeTitle(secondColumn, firstColumn[0]);
          } else {
            if (thirdColumn.isEmpty || thirdColumn.length > 1) {
              title = secondColumn[0].title;
            } else {
              /// 第三列选中了一个，为【不限】类型，使用上一级别的名字展示。
              if (thirdColumn[0].isUnLimit()) {
                title = secondColumn[0].title;
              } else if (thirdColumn[0].filterType == WaveSelectionFilterType.range ||
                  thirdColumn[0].filterType == WaveSelectionFilterType.date ||
                  thirdColumn[0].filterType == WaveSelectionFilterType.dateRange ||
                  thirdColumn[0].filterType == WaveSelectionFilterType.dateRangeCalendar) {
                title = _getDateAndRangeTitle(thirdColumn, secondColumn[0]);
              } else {
                title = thirdColumn[0].title;
              }
            }
          }
        }
      }
    }
    String joinTitle = _getJoinTitle(entity, firstColumn, secondColumn, thirdColumn);
    title = WaveUITools.isEmpty(joinTitle) ? title : joinTitle;
    return title;
  }

  String? _getDateAndRangeTitle(List<WaveSelectionEntity> list, WaveSelectionEntity entity) {
    String? title = '';
    if (!WaveUITools.isEmpty(list[0].customMap)) {
      if (list[0].filterType == WaveSelectionFilterType.range) {
        title = '${list[0].customMap!['min']}-${list[0].customMap!['max']}(${list[0].extMap['unit']?.toString()})';
      } else if (list[0].filterType == WaveSelectionFilterType.dateRange ||
          list[0].filterType == WaveSelectionFilterType.dateRangeCalendar) {
        title = _getDateRangeTitle(list);
      }
    } else {
      if (list[0].filterType == WaveSelectionFilterType.date) {
        title = _getDateTimeTitle(list);
      } else {
        title = entity.title;
      }
    }
    return title;
  }

  String _getDateRangeTitle(List<WaveSelectionEntity> list) {
    String minDateTime = '';
    String maxDateTime = '';

    if (list[0].customMap != null &&
        list[0].customMap!['min'] != null &&
        int.tryParse(list[0].customMap!['min'] ?? '') != null) {
      DateTime? minDate = DateTimeFormatter.convertIntValueToDateTime(list[0].customMap!['min']);
      minDateTime =
          DateTimeFormatter.formatDate(minDate!, WaveIntl.of(context).localizedResource.dateFormate_yyyy_MM_dd);
    }
    if (list[0].customMap != null &&
        list[0].customMap!['max'] != null &&
        int.tryParse(list[0].customMap!['max'] ?? '') != null) {
      DateTime? maxDate = DateTimeFormatter.convertIntValueToDateTime(list[0].customMap!['max']);
      maxDateTime =
          DateTimeFormatter.formatDate(maxDate!, WaveIntl.of(context).localizedResource.dateFormate_yyyy_MM_dd);
    }
    return '$minDateTime-$maxDateTime';
  }

  String? _getDateTimeTitle(List<WaveSelectionEntity> list) {
    String? title = "";
    int? msDateTime = int.tryParse(list[0].value ?? '');
    title = msDateTime != null
        ? DateTimeFormatter.formatDate(DateTime.fromMillisecondsSinceEpoch(msDateTime),
            WaveIntl.of(context).localizedResource.dateFormate_yyyy_MM_dd)
        : list[0].title;
    return title;
  }

  String _getJoinTitle(WaveSelectionEntity entity, List<WaveSelectionEntity> firstColumn,
      List<WaveSelectionEntity> secondColumn, List<WaveSelectionEntity> thirdColumn) {
    String title = "";
    if (entity.canJoinTitle) {
      if (firstColumn.length == 1) {
        title = firstColumn[0].title;
      }
      if (secondColumn.length == 1) {
        title += secondColumn[0].title;
      }
      if (thirdColumn.length == 1) {
        title += thirdColumn[0].title;
      }
    }
    return title;
  }

  void _refreshSelectionMenuTitle(int index, WaveSelectionEntity entity) {
    if (entity.filterType == WaveSelectionFilterType.more) {
      if (entity.allSelectedList().isNotEmpty) {
        menuItemHighlightState[index] = true;
      } else {
        menuItemHighlightState[index] = false;
      }
      return;
    }
    String? title = _getSelectedResultTitle(entity);
    if (title != null) {
      titles[index] = title;
    }
    if (entity.selectedListWithoutUnlimit().isNotEmpty) {
      menuItemHighlightState[index] = true;
    } else if (!WaveUITools.isEmpty(entity.customTitle)) {
      menuItemHighlightState[index] = entity.isCustomTitleHighLight;
    } else {
      menuItemHighlightState[index] = false;
    }
  }
}
