import 'dart:async';

import 'package:flutter/material.dart';

///***********
///*Description: The Dialog tool class that can be dismissed at ease,
///*Secondary packaging can be performed based on this class, similar to the show and dismiss methods of [WaveLoadingDialog]
///*
///*Note: If you want to delete the specified Dialog, you must pass the tag in the show and dismiss methods,
///***********

class WaveSafeDialog {
  static const String _safeDialogDefaultTag = '_safeDialogDefaultTag';

  ///According to the tag to distinguish the queue status of a certain type of Dialog
  static final Map<String, List<_SafeDialogRoute>> _dialogStates = {};

  ///Used to close a Dialog, only remove the last Dialog in the corresponding tag list
  ///[tag]: Dialog used to remove the corresponding tag
  ///
  ///Notice,
  ///1. Direct remove will not call the then callback of push future, and use Completer to forward;
  ///2. When the router is not in the queue, an exception will be thrown, catch and print the exception log.
  static void dismiss<T extends Object?>({
    required BuildContext context,
    String tag = _safeDialogDefaultTag,
    T? result,
  }) {
    List<_SafeDialogRoute> typeStates = (_dialogStates[tag] ??= []);
    if (typeStates.isNotEmpty) {
      try {
        _SafeDialogRoute safeDialogRoute = typeStates.removeLast();
        Navigator.removeRoute(context, safeDialogRoute);
        if (!safeDialogRoute.completer.isCompleted) {
          safeDialogRoute.completer.complete(result);
        }
      } catch (e) {
        ///TODO may throw an exception, directly print to the log area
        print(e);
      }
    }
  }

  ///Display the Dialog
  ///[tag] : used to mark the Dialog type
  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    String tag = _safeDialogDefaultTag,
    bool barrierDismissible = true,
    Color? barrierColor = Colors.black54,
    String? barrierLabel,
    bool useSafeArea = true,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
  }) {
    assert(debugCheckHasMaterialLocalizations(context));
    final CapturedThemes themes = InheritedTheme.capture(
      from: context,
      to: Navigator.of(
        context,
        rootNavigator: useRootNavigator,
      ).context,
    );
    _SafeDialogRoute<T> safeDialogRoute = _SafeDialogRoute<T>(
      context: context,
      builder: builder,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      settings: routeSettings,
      themes: themes,
    );

    //Notice:
    //Key point, manually manage Router
    //forward the result through Completer
    _dialogStates[tag] ??= [];
    _dialogStates[tag]?.add(safeDialogRoute);
    Future<T?> future = Navigator.of(context, rootNavigator: useRootNavigator)
        .push<T>(safeDialogRoute);
    future.then((result) {
      _dialogStates[tag]?.remove(safeDialogRoute);
      if (!safeDialogRoute.completer.isCompleted) {
        safeDialogRoute.completer.complete(result);
      }
    });
    return safeDialogRoute.completer.future;
  }
}

///Simple encapsulation of Completer based on DialogRoute for forwarding of Route results
class _SafeDialogRoute<T> extends DialogRoute<T> {
  ///Forward Route result
  final Completer<T?> completer = Completer<T?>();

  _SafeDialogRoute({
    required BuildContext context,
    required WidgetBuilder builder,
    CapturedThemes? themes,
    Color? barrierColor = Colors.black54,
    bool barrierDismissible = true,
    String? barrierLabel,
    bool useSafeArea = true,
    RouteSettings? settings,
  }) : super(
          context: context,
          builder: builder,
          themes: themes,
          barrierColor: barrierColor,
          barrierDismissible: barrierDismissible,
          barrierLabel: barrierLabel,
          useSafeArea: useSafeArea,
          settings: settings,
        );
}
