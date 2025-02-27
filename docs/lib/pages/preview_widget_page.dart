import 'package:flutter/material.dart' show CircularProgressIndicator, SelectableText;
import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:http/http.dart' as http;

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

  @override
  void initState() {
    super.initState();
    final githubUrl =
        'https://raw.githubusercontent.com/adhunitech/waveui/refs/heads/main/'
        '${widget.path}';
    fetchBuildMethodText(githubUrl);
  }

  Future<void> fetchBuildMethodText(String url) async {
    try {
      // Make an HTTP GET request to fetch the raw file from GitHub
      final response = await http.get(Uri.parse(url));

      // If the response is successful (status code 200)
      if (response.statusCode == 200) {
        final code = response.body;

        // Use regex to extract the build method content
        final buildRegex = RegExp(r'build\s*\(\s*\)\s*({.*?}|=>.*?);', dotAll: true);
        final matches = buildRegex.allMatches(code);

        // If the build method is found, format the code
        if (matches.isNotEmpty) {
          setState(() {
            _code = formatCode(matches.first.group(0) ?? 'No build method found');
            _isCodeLoaded = true; // Mark the code as loaded
          });
        } else {
          setState(() {
            _code = 'No build method found';
            _isCodeLoaded = true;
          });
        }
      } else {
        setState(() {
          _code = 'Failed to load code. Status code: ${response.statusCode}';
          _isCodeLoaded = true;
        });
      }
    } catch (e) {
      setState(() {
        _code = 'Error while fetching or extracting code: $e';
        _isCodeLoaded = true;
      });
    }
  }

  // Function to format the extracted code for better readability
  String formatCode(String code) {
    // If the code uses the fat arrow (=>), convert it to block form with {}
    if (code.contains('=>')) {
      final formattedCode = code
          .replaceFirstMapped(r'(\s*=>\s*)', (match) => ' {\n${match.group(0)}')
          .replaceFirst(';', '\n}');

      return formattedCode;
    }

    // If code uses block form ({}), just ensure it's properly indented
    return _indentCode(code);
  }

  // Function to ensure indentation for the block form code
  String _indentCode(String code) {
    final lines = code.split('\n');
    final indentedLines =
        lines.map((line) {
          if (line.trim().startsWith('return') || line.contains('Scaffold')) {
            return '    $line';
          }
          return line;
        }).toList();

    return indentedLines.join('\n');
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
            label: Text('Code'),
            content: _buildDataContainer(
              context,
              _isCodeLoaded ? SelectableText(_code) : const CircularProgressIndicator(),
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
