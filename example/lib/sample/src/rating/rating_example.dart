import 'package:example/sample/widgets.dart';
import 'package:waveui/waveui.dart';

/// 星级评分条
class RatingExample extends StatefulWidget {
  const RatingExample({super.key});

  @override
  _RatingExampleState createState() => _RatingExampleState();
}

class _RatingExampleState extends State<RatingExample> {
  var num = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WaveAppBar(
        title: 'Star Rating Control Example',
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            //Only integers are accepted, outside
            const Text("Support half grain"),
            const WaveRatingStar(),
            const WaveRatingStar(
              selectedCount: 0.5,
            ),
            const WaveRatingStar(
              selectedCount: 3.1,
            ),
            const WaveRatingStar(
              selectedCount: 3.6,
              count: 10,
            ),
            const SizedBox(height: 20),
            GestureDetector(
              child: const Text("Support click to select, the first one supports inverse selection"),
              onTap: () {
                showSnackBar(
                  context,
                  msg: "haha",
                );
                setState(() {
                  num = 4;
                });
              },
            ),
            WaveRatingStar(
              selectedCount: num.toDouble(),
              space: 5,
              canRatingZero: true,
              onSelected: (count) {
                showSnackBar(
                  context,
                  msg: "Selected $count",
                );
              },
            ),
            const SizedBox(height: 20),
            const Text("custom picture, color, size"),
            WaveRatingStar(
              selectedCount: 3,
              space: 1,
              canRatingZero: true,
              onSelected: (count) {
                showSnackBar(
                  context,
                  msg: "Selected $count",
                );
              },
              starBuilder: _buildRating,
            )
          ],
        ),
      ),
    );
  }

  //custom image, size, color
  Widget _buildRating(RatingState state) {
    switch (state) {
      case RatingState.select:
        return WaveUITools.getAssetSizeImage(WaveAsset.iconStar, 16, 16, color: const Color(0xFF3571DC));
      case RatingState.half:
        return WaveUITools.getAssetSizeImage(WaveAsset.iconStarHalf, 16, 16);
      case RatingState.unselect:
      default:
        return WaveUITools.getAssetSizeImage(WaveAsset.iconStar, 16, 16, color: const Color(0xFFF0F0F0));
    }
  }
}
