import 'package:example/sample/widgets.dart';
import 'package:waveui/waveui.dart';

class NavBarPage extends StatefulWidget {
  final int index;

  const NavBarPage(this.index, {super.key});

  @override
  _NavBarPageState createState() => _NavBarPageState();
}

class _NavBarPageState extends State<NavBarPage> with TickerProviderStateMixin {
  TextEditingController? textEditingController;

  TextStyle? selectedHeiStyle;
  TextStyle? unSelectedHeiStyle;
  TextStyle? commonHeiStyle;

  TextStyle? selectedBaiStyle;
  TextStyle? unSelectedBaiStyle;
  TextStyle? commonBaiStyle;
  int currentIndex = 0;

  late ValueNotifier<bool> valueNotifier;
  FocusNode? focusNode;

  TabController? tabController;

  GlobalKey keyLeading = GlobalKey();

  GlobalKey actionKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    valueNotifier = ValueNotifier(false);

    selectedHeiStyle = const TextStyle(fontSize: 18, color: Color(0xFFFFFFFF), fontWeight: FontWeight.w600);
    selectedBaiStyle = const TextStyle(fontSize: 18, color: Color(0xFF222222), fontWeight: FontWeight.w600);

    unSelectedHeiStyle = const TextStyle(fontSize: 18, color: Color(0xFF999999), fontWeight: FontWeight.w600);
    unSelectedBaiStyle = const TextStyle(fontSize: 18, color: Color(0xFF999999), fontWeight: FontWeight.w600);

    commonHeiStyle = const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white);
    commonBaiStyle = const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF222222));

    focusNode = FocusNode();
    focusNode!.addListener(() {
      if (focusNode!.hasFocus) {
        valueNotifier.value = true;
      }
    });

    tabController = TabController(vsync: this, length: 10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildBarByIndex(context),
      body: buildContentByIndex(context),
    );
  }

  PreferredSizeWidget? buildBarByIndex(BuildContext context) {
    PreferredSizeWidget? appBar;
    switch (widget.index) {
      case 0:
        //2 text modules switch, left and right icon hei
        appBar = _getBlackBar1();
        break;

      case 5:
        //Text title drop-down box
        appBar = _getBlackBar6();
        break;

      case 8:
        ////Text title left 1 icon right text
        appBar = _getBlackBar9();
        break;

      case 9:
        ////Text title with label
        appBar = _getBlackBar10();
        break;

      case 11:
        appBar = _getBlackBar12();
        break;

      case 12:
        appBar = _getBlackBar13();
        break;

      case 13:
        appBar = _getBlackBar14();
        break;

      case 14:
        //Multiple switching text
        appBar = _getBlackBar15();
        break;

      case 15:
        //Multiple switching text
        appBar = _getBlackBar16();
        break;

      case 16:
        //Multiple switching text
        appBar = _getWhiteSearchBar();
        break;
      case 17:
        //Search alone
        appBar = _getBlackBar17();
        break;

      default:
    }
    return appBar;
  }

  Widget? buildContentByIndex(BuildContext context) {
    Widget? widget;
    switch (this.widget.index) {
      case 0:
        widget = const Center(
            child: Text(
                '1. The back button icon in the upper left corner supports customization. In this example, it has been changed to a search icon\n2. The navigation bar of the switching type\n3. The top module switching is not limited to two, but multiple'));
        break;
      case 4:
        widget = const Center(child: Text('Multiple Actions'));
        break;
      case 13:
        widget = const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
          ],
        );
        break;
      default:
    }

    return widget;
  }

  //2 text modules switch, left and right icon hei
  WaveAppBar _getBlackBar1() {
    return WaveAppBar(
      leading: IconButton(
        icon: Image.asset(
          'assets/image/icon_navbar_sousuo_bai.png',
          scale: 3.0,
          height: 20,
          width: 20,
        ),
        onPressed: () {},
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              currentIndex = 0;
              setState(() {});
            },
            child: Text(
              '二手',
              style: currentIndex == 0 ? selectedHeiStyle : unSelectedHeiStyle,
            ),
          ),
          const SizedBox(
            width: 24,
          ),
          GestureDetector(
            onTap: () {
              currentIndex = 1;
              setState(() {});
            },
            child: Text(
              '新房',
              style: currentIndex == 1 ? selectedHeiStyle : unSelectedHeiStyle,
            ),
          )
        ],
      ),
      actions: [
        IconButton(
          icon: Image.asset(
            'assets/image/icon_navbar_add_bai.png',
            scale: 3.0,
            width: 20,
            height: 20,
          ),
          onPressed: () {
            showSnackBar(
              context,
              msg: 'Clicked the + sign in the upper right corner',
            );
          },
        ),
      ],
    );
  }

  //文字标题 下拉框
  WaveAppBar _getBlackBar6() {
    return WaveAppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "标题名称",
            style: commonHeiStyle,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Image.asset(
              'assets/image/icon_navbar_xiala_bai.png',
              scale: 3.0,
              width: 20,
              height: 20,
            ),
          )
        ],
      ),
    );
  }

  //Text title left 1 icon right text bai
  WaveAppBar _getBlackBar9() {
    return WaveAppBar(
      leading: Image.asset(
        'assets/image/icon_navbar_sousuo_hei.png',
        scale: 3.0,
        width: 20,
        height: 20,
      ),
      title: 'title name',
    );
  }

  //文字标题 带标签
  WaveAppBar _getBlackBar10() {
    return WaveAppBar(
      leading: Image.asset(
        'assets/image/icon_navbar_sousuo_hei.png',
        scale: 3.0,
        width: 20,
        height: 20,
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Text(
            '标题名称',
            style: TextStyle(fontSize: 18, height: 1, fontWeight: FontWeight.w600, color: Color(0xFF222222)),
          ),
          Container(
              height: 17,
              padding: const EdgeInsets.only(left: 3, right: 3),
              margin: const EdgeInsets.only(left: 6),
              decoration: BoxDecoration(color: const Color(0xff8E8E8E).withOpacity(0.15)),
              child: const Center(
                child: Text(
                  'Residential',
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: 1,
                  style: TextStyle(
                    fontSize: 11,
                    height: 1,
                    color: Color(0xFF222222),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  //Multi-icon bar hei
  WaveAppBar _getBlackBar12() {
    return WaveAppBar(
      title:
          "TiantongyuanTiantongyuanTiantongyuanTiantongyuanTiantongyuanTiantongyuanTiantongyuanTiantongyuanTiantongyuan",
      actions: <Widget>[
        IconButton(
          onPressed: () {},
          icon: Image.asset(
            'assets/image/icon_navbar_share_bai.png',
            scale: 3.0,
            height: 20,
            width: 20,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Image.asset(
            'assets/image/icon_navbar_pin_bai.png',
            scale: 3.0,
            height: 20,
            width: 20,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Image.asset(
            'assets/image/icon_navbar_focus_bai.png',
            scale: 3.0,
            height: 20,
            width: 20,
          ),
        ),
      ],
    );
  }

//Multi-icon bar bai
  WaveAppBar _getBlackBar13() {
    return WaveAppBar(
      title: "",
      actions: <Widget>[
        IconButton(
          onPressed: () {},
          icon: Image.asset(
            'assets/image/icon_navbar_im_hei.png',
            scale: 3.0,
            height: 20,
            width: 20,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Image.asset(
            'assets/image/icon_navbar_share_hei.png',
            scale: 3.0,
            height: 20,
            width: 20,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Image.asset(
            'assets/image/icon_navbar_pin_hei.png',
            scale: 3.0,
            height: 20,
            width: 20,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Image.asset(
            'assets/image/icon_navbar_focus_hei.png',
            scale: 3.0,
            height: 20,
            width: 20,
          ),
        ),
      ],
    );
  }

  PreferredSize _getBlackBar14() {
    return WaveSearchAppbar(
      //leading: 'New house',
      showDivider: false,
      //Click the callback of leading
      leadClickCallback: (controller, update) {
        //controller is a text controller, you can get the input content and change the input content through the controller
        //update is the method command of the setState method, update() can refresh the input box
        showSnackBar(context, msg: controller.text);
      },
      //Input box text content change monitoring
      searchBarInputChangeCallback: (input) {
        showSnackBar(context, msg: input);
      },
      //Input box keyboard to determine the monitoring
      searchBarInputSubmitCallback: (input) {
        showSnackBar(context, msg: input);
      },
      //Add a text controller for the input box, if not passed, use the default
      controller: textEditingController,
      //Add a focus controller for the input box, if not passed, use the default
      focusNode: focusNode,
      //Click callback to cancel action on the right
      //The parameters are the same as leadClickCallback
      dismissClickCallback: (controller, update) {
        Navigator.of(context).pop();
      },
    );
  }

  PreferredSize _getWhiteSearchBar() {
    return WaveSearchAppbar(
      brightness: Brightness.light,
      showDivider: true,
      //自定义的leading显示
      leading: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Row(
          key: keyLeading,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              '类型1',
              style: TextStyle(color: Color(0xFF222222), height: 1, fontSize: 16),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Image.asset(
                'assets/image/icon_triangle.png',
                color: Colors.grey,
                scale: 3.0,
                height: 7,
                width: 7,
              ),
            )
          ],
        ),
      ),
      //点击 leading的回调
      leadClickCallback: (controller, update) {
        //controller is a text controller, you can get the input content and change the input content through the controller
        //update is the method command of the setState method, update() can refresh the input box
        WavePopupListWindow.showPopListWindow(
          context,
          keyLeading,
          data: ["aaaa", "bbbbb"],
          onItemClick: (index, data) {
            WaveDialogManager.showConfirmDialog(context, cancel: 'cancel', confirm: 'confirm', message: 'message');
            return true;
          },
          onDismiss: () {
            showSnackBar(context, msg: 'onDismiss');
          },
        );
      },
      //Input box text content change monitoring
      searchBarInputChangeCallback: (input) {
        showSnackBar(context, msg: input);
      },
      //Input box keyboard to determine the monitoring
      searchBarInputSubmitCallback: (input) {
        showSnackBar(context, msg: input);
      },
      //Add a text controller for the input box, if not passed, use the default
      controller: textEditingController,
      //Add a focus controller for the input box, if not passed, use the default
      focusNode: focusNode,
      //Click callback to cancel action on the right
//The parameters are the same as leadClickCallback
      dismissClickCallback: (controller, update) {
        Navigator.of(context).pop();
      },
    );
  }

  PreferredSize _getBlackBar16() {
    return WaveSearchAppbar(
      //自定义的leading显示
      leading: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Row(
          key: keyLeading,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              '类型1',
              style: TextStyle(color: Colors.white, height: 1, fontSize: 16),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Image.asset(
                'assets/image/icon_triangle.png',
                scale: 3.0,
                height: 7,
                width: 7,
              ),
            )
          ],
        ),
      ),
      //Click the callback of leading
      leadClickCallback: (controller, update) {
        //controller is a text controller, you can get the input content and change the input content through the controller
        //update is the method command of the setState method, update() can refresh the input box
        WavePopupListWindow.showPopListWindow(context, keyLeading, data: ["aaaa", "bbbbb"], offset: 10);
      },
      //Input box text content change monitoring
      searchBarInputChangeCallback: (input) {
        showSnackBar(context, msg: input);
      },
      //Input box keyboard to determine the monitoring
      searchBarInputSubmitCallback: (input) {
        showSnackBar(context, msg: input);
      },
      //Add a text controller for the input box, if not passed, use the default
      controller: textEditingController,
      //Add a focus controller for the input box, if not passed, use the default
      focusNode: focusNode,
      //Click callback to cancel action on the right
      //The parameters are the same as leadClickCallback
      dismissClickCallback: (controller, update) {
        Navigator.of(context).pop();
      },
    );
  }

  WaveAppBar _getBlackBar15() {
    Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            currentIndex = 0;
            setState(() {});
          },
          child: Text(
            '二手',
            style: currentIndex == 0 ? selectedHeiStyle : unSelectedHeiStyle,
          ),
        ),
        const SizedBox(
          width: 24,
        ),
        GestureDetector(
          onTap: () {
            currentIndex = 1;
            setState(() {});
          },
          child: Text(
            '新房',
            style: currentIndex == 1 ? selectedHeiStyle : unSelectedHeiStyle,
          ),
        ),
        const SizedBox(
          width: 24,
        ),
        GestureDetector(
          onTap: () {
            currentIndex = 2;
            setState(() {});
          },
          child: Text(
            '类型',
            style: currentIndex == 2 ? selectedHeiStyle : unSelectedHeiStyle,
          ),
        )
      ],
    );
    return WaveAppBar(
      title: Container(
        height: 44,
        padding: const EdgeInsets.only(left: 24, right: 12),
        child: ListView.separated(
          itemCount: 10,
          //横滑
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  currentIndex = index;
                });
              },
              child: Center(
                child: Text(
                  '标题',
                  style: index == currentIndex ? selectedHeiStyle : unSelectedHeiStyle,
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              width: 24,
            );
          },
        ),
      ),
      actions: [
        IconButton(
          icon: Image.asset(
            'assets/image/icon_navbar_add_bai.png',
            scale: 3.0,
            height: 20,
            width: 20,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  PreferredSize _getBlackBar17() {
    return WaveSearchAppbar(
      autoFocus: true,
      showDivider: false,
      //Input box text content change monitoring
      searchBarInputChangeCallback: (input) {
        showSnackBar(context, msg: input);
      },
      //Input box keyboard to determine the monitoring
      searchBarInputSubmitCallback: (input) {
        showSnackBar(context, msg: input);
      },
      //Add a text controller for the input box, if not passed, use the default
      controller: textEditingController,
      //Add a focus controller for the input box, if not passed, use the default
      focusNode: focusNode,
      //Click callback to cancel action on the right
      //The parameters are the same as leadClickCallback
      dismissClickCallback: (controller, update) {
        Navigator.of(context).pop();
      },
    );
  }
}
