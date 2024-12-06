import 'package:waveui/waveui.dart';

///Custom constructor for star view
///state, [RatingState] star status
typedef WaveRatingStarBuilder = Widget Function(RatingState state);

enum RatingState {
  ///Half
  half,

  ///unselected
  unselect,

  ///selected
  select,
}

///Star rating control, support:
///
///*Customizable picture, color, size, spacing
///*Support click to select
///*Support whether to limit the score to at least one star, that is, whether the first star support can be reversed
///*Support half star (only support display, not support selection)
class WaveRatingStar extends StatefulWidget {
  static const DEFAULT_COUNT = 5;
  static const DEFAULT_SPACE = 1.0;

  ///The total number of stars, the default is 5
  final int count;

  ///The number of initial selections
  final double selectedCount;

  final double iconSize;
  final Color iconColor;

  ///The horizontal spacing between stars, the default is 1.0
  final double space;

  ///Whether 0 stars can be rated, that is, whether the first star supports reverse selection, and 0 stars cannot be rated by default
  final bool canRatingZero;

  ///Custom constructor for single star view
  final WaveRatingStarBuilder? starBuilder;

  ///If set, it supports editing
  final ValueChanged<int>? onSelected;

  const WaveRatingStar({
    Key? key,
    this.count = DEFAULT_COUNT,
    this.selectedCount = 0,
    this.space = DEFAULT_SPACE,
    this.starBuilder,
    this.iconSize = 28,
    this.onSelected,
    this.iconColor = Colors.amber,
    this.canRatingZero = false,
  }) : super(key: key);

  @override
  _WaveRatingStarState createState() => _WaveRatingStarState();
}

class _WaveRatingStarState extends State<WaveRatingStar> {
  late double currSelected;

  @override
  void initState() {
    super.initState();
    currSelected = widget.selectedCount;
  }

  @override
  void didUpdateWidget(WaveRatingStar oldWidget) {
    currSelected = widget.selectedCount;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _getContent(),
    );
  }

  List<Widget> _getContent() {
    List<Widget> list = [];
    for (var i = 0; i < widget.count; i++) {
      RatingState state;
      if (i < currSelected.floor()) {
        state = RatingState.select;
      } else if (i == currSelected.floor() && i < currSelected.ceil()) {
        state = RatingState.half;
      } else {
        state = RatingState.unselect;
      }
      var rating = widget.starBuilder != null
          ? widget.starBuilder!(state)
          : _buildRating(state);

      if (widget.onSelected != null) {
        list.add(GestureDetector(
          onTap: () {
            //unselect the first
            if (i == 0 && currSelected == 1 && widget.canRatingZero) {
              currSelected = 0;
            } else {
              currSelected = (i + 1).toDouble();
            }
            widget.onSelected!(currSelected.toInt());
            setState(() {});
          },
          behavior: HitTestBehavior.opaque,
          child: rating,
        ));
      } else {
        list.add(rating);
      }

      if (i != widget.count - 1) {
        list.add(SizedBox(
          width: widget.space,
          height: 1,
        ));
      }
    }
    return list;
  }

  Widget _buildRating(RatingState state) {
    switch (state) {
      case RatingState.select:
        return Icon(
          FluentIcons.star_28_filled,
          size: widget.iconSize,
          color: widget.iconColor,
        );
      case RatingState.half:
        return Icon(
          FluentIcons.star_half_28_filled,
          size: widget.iconSize,
          color: widget.iconColor,
        );
      case RatingState.unselect:
      default:
        return Icon(
          FluentIcons.star_28_regular,
          size: widget.iconSize,
          color: Colors.grey,
        );
    }
  }
}
