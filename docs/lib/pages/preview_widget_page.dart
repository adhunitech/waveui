import 'dart:ui';

import 'package:flutter/material.dart' show CircularProgressIndicator;
import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:http/http.dart' as http;
import 'package:syntax_highlight/syntax_highlight.dart';

class PreviewWidgetPage extends StatefulWidget {
  final String exampleName;
  final String path;
  final Widget widget;

  const PreviewWidgetPage({required this.widget, required this.path, required this.exampleName, super.key});

  @override
  _PreviewWidgetPageState createState() => _PreviewWidgetPageState();
}

class _PreviewWidgetPageState extends State<PreviewWidgetPage> {
  String _code = '';
  bool _isCodeLoaded = false;
  Highlighter? _highlighter;

  @override
  void initState() {
    super.initState();
    final githubUrl = 'https://raw.githubusercontent.com/adhunitech/waveui/main/${widget.path}';
    fetchBuildMethodText(githubUrl);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeHighlighter();
  }

  Future<void> initializeHighlighter() async {
    final brightness = FTheme.of(context).colorScheme.brightness;
    final theme =
        brightness == Brightness.light
            ? await HighlighterTheme.loadLightTheme()
            : await HighlighterTheme.loadDarkTheme();
    await Highlighter.initialize(['dart']);

    setState(() {
      _highlighter = Highlighter(language: 'dart', theme: theme);
    });
  }

  Future<void> fetchBuildMethodText(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final code = response.body;
      final buildRegex = RegExp(
        r'Widget\s+build\s*\(.*?\)\s*=>\s*(.*?);|Widget\s+build\s*\(.*?\)\s*{([\s\S]*?)}',
        dotAll: true,
      );
      final match = buildRegex.firstMatch(code);

      setState(() {
        if (match != null) {
          _code = formatCode(match.group(1) ?? match.group(2) ?? 'No build method found');
        } else {
          _code = 'No build method found';
        }
        _isCodeLoaded = true;
      });
    } else {
      setState(() {
        _code = 'Failed to load code. Status code: ${response.statusCode}';
        _isCodeLoaded = true;
      });
    }
  }

  String formatCode(String code) {
    if (code.contains('=>')) {
      return '${code.replaceFirstMapped(RegExp(r'=>\s*'), (match) => '{\n  return ')}\n}';
    }
    return code.trim();
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(widget.exampleName, style: FTheme.of(context).typography.h3),
      const SizedBox(height: 16),
      FTabs(
        tabs: [
          FTabEntry(label: const Text('Preview'), content: _buildDataContainer(context, widget.widget)),
          FTabEntry(
            label: const Text('Code'),
            content: _buildDataContainer(
              context,
              _isCodeLoaded
                  ? (_highlighter != null
                      ? Text.rich(_highlighter!.highlight(_code))
                      : const Text('Initializing highlighter...'))
                  : const CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    ],
  );
  Widget _buildDataContainer(BuildContext context, Widget child) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: FTheme.of(context).colorScheme.secondary),
    child: ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 200, minWidth: double.infinity),
      child: Center(child: child),
    ),
  );
}
