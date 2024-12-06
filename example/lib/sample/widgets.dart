import 'package:flutter/material.dart';

showSnackBar(BuildContext context, {required String msg}) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
