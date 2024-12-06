import 'package:waveui/waveui.dart';

class TypographyPage extends StatelessWidget {
  const TypographyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WaveAppBar(
        title: Text("Typography"),
      ),
      body: ListView(
        children: [
          WaveCard(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "This is a titleLarge. Lorem ipsum dolor sit amet. In accusamus sint aut minima optio quo officiis iure aut modi nemo.",
                    style: Get.textTheme.titleLarge),
                const SizedBox(height: 16),
                Text(
                    "This is a titleMedium. Lorem ipsum dolor sit amet. In accusamus sint aut minima optio quo officiis iure aut modi nemo.",
                    style: Get.textTheme.titleMedium),
                const SizedBox(height: 16),
                Text(
                    "This is a titleSmall. Lorem ipsum dolor sit amet. In accusamus sint aut minima optio quo officiis iure aut modi nemo.",
                    style: Get.textTheme.titleSmall),
                const SizedBox(height: 36),
                Text("This is a labelLarge", style: Get.textTheme.labelLarge),
                const SizedBox(height: 16),
                Text("This is a labelMedium", style: Get.textTheme.labelMedium),
                const SizedBox(height: 16),
                Text("This is a labelSmall", style: Get.textTheme.labelSmall),
                const SizedBox(height: 36),
                Text("This is a headlineLarge", style: Get.textTheme.headlineLarge),
                const SizedBox(height: 16),
                Text("This is a headlineMedium", style: Get.textTheme.headlineMedium),
                const SizedBox(height: 16),
                Text("This is a headlineSmall", style: Get.textTheme.headlineSmall),
                const SizedBox(height: 36),
                Text("Display Large", style: Get.textTheme.displayLarge),
                const SizedBox(height: 16),
                Text("Display Medium", style: Get.textTheme.displayMedium),
                const SizedBox(height: 16),
                Text("This is a displaySmall", style: Get.textTheme.displaySmall),
                const SizedBox(height: 36),
                Text(
                    "This is a bodyLarge. Lorem ipsum dolor sit amet. In accusamus sint aut minima optio quo officiis iure aut modi nemo. Et earum fuga vel molestias corporis eum distinctio maiores ut aspernatur modi eum omnis soluta.",
                    style: Get.textTheme.bodyLarge),
                const SizedBox(height: 16),
                Text(
                    "This is a bodyMedium. Lorem ipsum dolor sit amet. In accusamus sint aut minima optio quo officiis iure aut modi nemo. Et earum fuga vel molestias corporis eum distinctio maiores ut aspernatur modi eum omnis soluta.",
                    style: Get.textTheme.bodyMedium),
                const SizedBox(height: 16),
                Text(
                    "This is a bodySmall. Lorem ipsum dolor sit amet. In accusamus sint aut minima optio quo officiis iure aut modi nemo. Et earum fuga vel molestias corporis eum distinctio maiores ut aspernatur modi eum omnis soluta.",
                    style: Get.textTheme.bodySmall),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
