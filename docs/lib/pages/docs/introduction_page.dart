import 'package:docs/pages/docs_page.dart';
import 'package:waveui/waveui.dart';
import 'package:url_launcher/url_launcher_string.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({super.key});

  @override
  createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  final OnThisPage featuresKey = OnThisPage();
  final OnThisPage faqKey = OnThisPage();
  final OnThisPage notesKey = OnThisPage();
  final OnThisPage linksKey = OnThisPage();

  @override
  Widget build(BuildContext context) => DocsPage(
    name: 'introduction',
    onThisPage: {'Features': featuresKey, 'Notes': notesKey, 'Frequently Asked Questions': faqKey, 'Links': linksKey},
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Introduction').h1(),
        const Text(
          '🌊 A production grade flutter components library built for scale, speed, and cross platform precision.',
        ).lead(),
        const Text(
          'Waveui is a modern ui toolkit built for flutter developers '
          'who want to create beautiful, responsive apps for mobile, '
          "desktop, and web. It's designed to work seamlessly on all "
          'screen sizes and input types.',
          textAlign: TextAlign.justify,
        ).p(),
        const Text(
          '\tIt offers a wide range of customizable, responsive components '
          "built for modern desktop, mobile and web design. Whether you're creating a "
          'dashboard, business app, or productivity tool, our components help you '
          'build polished, professional uis — fast and efficiently.',
          textAlign: TextAlign.justify,
        ).p(),
        const Text('Features').h2().anchored(featuresKey),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('100+ modern ui components.').li(),
            const Text('Instant, ready-to-use themes.').li(),
            const Text('Optimized for web, mobile & desktop.').li(),
            const Text('Elegant, readable typography.').li(),
            const Text('Designed for speed and efficiency.').li(),
          ],
        ).p(),
        const Text('Notes').h2().anchored(notesKey),
        const Text('This package is an initial fork of ')
            .thenButton(
              onPressed: () => launchUrlString('https://github.com/sunarya-thito/shadcn_flutter'),
              child: const Text('@sunarya-thito/shadcn_flutter'),
            )
            .thenText('. Special thanks to ')
            .thenButton(
              onPressed: () => launchUrlString('https://github.com/sunarya-thito'),
              child: const Text('@sunarya-thito'),
            )
            .thenText(
              ' for the original project. '
              'We are actively developing it to deliver a modern experience. '
              'If you like the shadcn/ui, check out the original package.'
              '\n\nNote: This package is under heavy development and may introduce breaking changes. '
              'Use with caution in production environments.',
            )
            .p(),

        const Text('Frequently Asked Questions').h2().anchored(faqKey),
        const Accordion(
          items: [
            AccordionItem(
              trigger: AccordionTrigger(child: Text('Does this support GoRouter?')),
              content: Text('Yes, it does. You can use GoRouter with waveui. '),
            ),
            AccordionItem(
              trigger: AccordionTrigger(child: Text('Can I use this in my project?')),
              content: Text('Yes! Free to use for personal and commercial projects. No attribution required.'),
            ),
          ],
        ),
        const Text('Links').h2().anchored(linksKey),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Github: ')
                .thenButton(
                  onPressed: () {
                    launchUrlString('https://github.com/adhunitech/waveui');
                  },
                  child: const Text('https://github.com/adhunitech/waveui'),
                )
                .li(),
            const Text('pub.dev: ')
                .thenButton(
                  onPressed: () {
                    launchUrlString('https://pub.dev/packages/waveui');
                  },
                  child: const Text('https://pub.dev/packages/waveui'),
                )
                .li(),
          ],
        ).p(),
      ],
    ),
  );
}
