import 'package:waveui/waveui.dart';

class WaveError extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  const WaveError({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 30,
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 100,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: Get.textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          Text(
            description,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
