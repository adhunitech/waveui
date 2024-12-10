import 'package:flutter/material.dart';

class TypographyPage extends StatelessWidget {
  const TypographyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Typography Article"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: RichText(
            text: TextSpan(
              children: [
                // Title Large Text
                TextSpan(
                  text: 'Exploring Typography in Flutter\n\n',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                // Body Large Text with descriptive content
                TextSpan(
                  text: 'Typography plays a crucial role in enhancing the readability and aesthetics of an app. '
                      'In this article, we explore various types of typography styles in Flutter and how you can leverage them for better UI design.\n\n',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                // Title Medium Text as a subheading
                TextSpan(
                  text: '1. Title and Heading Styles\n\n',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                // Body Medium Text with description
                TextSpan(
                  text:
                      'Flutter offers several title and heading text styles, ranging from large titles to small titles. '
                      'These are ideal for emphasizing headings or creating a visual hierarchy in your UI.\n\n',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                // Title Small Text example
                TextSpan(
                  text: 'Example of Title Small Style:\n',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                TextSpan(
                  text: 'The `titleSmall` style can be used for secondary titles or minor headings, '
                      'helping to create a clear structure in your app content. Here’s an example:\n\n',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                TextSpan(
                  text: 'This is a titleSmall. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\n',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                // Body Small Text example
                TextSpan(
                  text: '2. Body Text Styles\n\n',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                // Body Large Text explanation
                TextSpan(
                  text: 'The body text styles are typically used for paragraphs or general text content. '
                      'Flutter provides multiple body text styles such as `bodyLarge`, `bodyMedium`, and `bodySmall` '
                      'to cater to different text needs. Here’s an example of a bodyLarge style used in long-form text:\n\n',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextSpan(
                  text:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n\n',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                // Display Large example
                TextSpan(
                  text: 'Display Styles for Large Text\n\n',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextSpan(
                  text: 'Display styles like `displayLarge` are designed for very large headings or titles '
                      'that need to grab the user’s attention. These are useful for banners, splash screens, or large hero sections in your UI.\n\n',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text: 'Display Large Example:\n',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text:
                      'Here is a `displayLarge` style example that could be used as a large header on your homepage.\n\n',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                TextSpan(
                  text: 'This is a displayLarge heading\n\n',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                // Conclusion with Body Medium
                TextSpan(
                  text: 'Conclusion\n\n',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextSpan(
                  text:
                      'In conclusion, Flutter provides a wide range of typography styles that you can use to create visually appealing and well-structured text. By leveraging these text styles, you can enhance the overall user experience of your app.\n\n',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text:
                      'Understanding when and where to use each style will help you create an engaging and accessible user interface.\n\n',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
