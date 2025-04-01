import 'dart:convert';

import 'package:logger/logger.dart';

/// Create a new instance of Logger.
Logger logger = Logger();

extension JsonPretty on Map<String, dynamic> {
  Map<String, dynamic> get prettyJson {
    try {
      final formattedJson = const JsonEncoder.withIndent('  ').convert(this);
      return jsonDecode(formattedJson);
    } catch (e) {
      logger.e('Invalid JSON. Returning current object as it.', error: e, time: DateTime.now());
      return this;
    }
  }
}
