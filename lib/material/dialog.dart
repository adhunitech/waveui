// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' show SemanticsRole, clampDouble, lerpDouble;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:waveui/material/color_scheme.dart';
import 'package:waveui/material/colors.dart';
import 'package:waveui/material/debug.dart';
import 'package:waveui/material/dialog_theme.dart';
import 'package:waveui/material/ink_well.dart';
import 'package:waveui/material/material.dart';
import 'package:waveui/material/material_localizations.dart';
import 'package:waveui/src/theme/text_theme.dart';
import 'package:waveui/material/theme.dart';

// Examples can assume:
// enum Department { treasury, state }
// late BuildContext context;

const EdgeInsets _defaultInsetPadding = EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0);

class Dialog extends StatelessWidget {
  const Dialog({
    super.key,
    this.backgroundColor,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.insetAnimationDuration = const Duration(milliseconds: 100),
    this.insetAnimationCurve = Curves.decelerate,
    this.insetPadding,
    this.clipBehavior,
    this.shape,
    this.alignment,
    this.child,
    this.semanticsRole = SemanticsRole.dialog,
  }) : assert(elevation == null || elevation >= 0.0),
       _fullscreen = false;

  const Dialog.fullscreen({
    super.key,
    this.backgroundColor,
    this.insetAnimationDuration = Duration.zero,
    this.insetAnimationCurve = Curves.decelerate,
    this.child,
    this.semanticsRole = SemanticsRole.dialog,
  }) : elevation = 0,
       shadowColor = null,
       surfaceTintColor = null,
       insetPadding = EdgeInsets.zero,
       clipBehavior = Clip.none,
       shape = null,
       alignment = null,
       _fullscreen = true;

  final Color? backgroundColor;

  final double? elevation;

  final Color? shadowColor;

  final Color? surfaceTintColor;

  final Duration insetAnimationDuration;

  final Curve insetAnimationCurve;

  final EdgeInsets? insetPadding;

  final Clip? clipBehavior;

  final ShapeBorder? shape;

  final AlignmentGeometry? alignment;

  final Widget? child;

  final bool _fullscreen;

  final SemanticsRole semanticsRole;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final DialogThemeData dialogTheme = DialogTheme.of(context);
    final EdgeInsets effectivePadding =
        MediaQuery.viewInsetsOf(context) + (insetPadding ?? dialogTheme.insetPadding ?? _defaultInsetPadding);
    final DialogThemeData defaults = (_fullscreen ? _DialogFullscreenDefaultsM3(context) : _DialogDefaultsM3(context));

    Widget dialogChild;

    if (_fullscreen) {
      dialogChild = Material(
        color: backgroundColor ?? dialogTheme.backgroundColor ?? defaults.backgroundColor,
        child: child,
      );
    } else {
      dialogChild = Align(
        alignment: alignment ?? dialogTheme.alignment ?? defaults.alignment!,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 280.0),
          child: Material(
            color: backgroundColor ?? dialogTheme.backgroundColor ?? defaults.backgroundColor,
            elevation: elevation ?? dialogTheme.elevation ?? defaults.elevation!,
            shadowColor: shadowColor ?? dialogTheme.shadowColor ?? defaults.shadowColor,
            surfaceTintColor: surfaceTintColor ?? dialogTheme.surfaceTintColor ?? defaults.surfaceTintColor,
            shape: shape ?? dialogTheme.shape ?? defaults.shape!,
            type: MaterialType.card,
            clipBehavior: clipBehavior ?? dialogTheme.clipBehavior ?? defaults.clipBehavior!,
            child: child,
          ),
        ),
      );
    }

    return Semantics(
      role: semanticsRole,
      child: AnimatedPadding(
        padding: effectivePadding,
        duration: insetAnimationDuration,
        curve: insetAnimationCurve,
        child: MediaQuery.removeViewInsets(
          removeLeft: true,
          removeTop: true,
          removeRight: true,
          removeBottom: true,
          context: context,
          child: dialogChild,
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(DoubleProperty('elevation', elevation));
    properties.add(ColorProperty('shadowColor', shadowColor));
    properties.add(ColorProperty('surfaceTintColor', surfaceTintColor));
    properties.add(DiagnosticsProperty<Duration>('insetAnimationDuration', insetAnimationDuration));
    properties.add(DiagnosticsProperty<Curve>('insetAnimationCurve', insetAnimationCurve));
    properties.add(DiagnosticsProperty<EdgeInsets?>('insetPadding', insetPadding));
    properties.add(EnumProperty<Clip?>('clipBehavior', clipBehavior));
    properties.add(DiagnosticsProperty<ShapeBorder?>('shape', shape));
    properties.add(DiagnosticsProperty<AlignmentGeometry?>('alignment', alignment));
    properties.add(EnumProperty<SemanticsRole>('semanticsRole', semanticsRole));
  }
}

class AlertDialog extends StatelessWidget {
  const AlertDialog({
    super.key,
    this.icon,
    this.iconPadding,
    this.iconColor,
    this.title,
    this.titlePadding,
    this.titleTextStyle,
    this.content,
    this.contentPadding,
    this.contentTextStyle,
    this.actions,
    this.actionsPadding,
    this.actionsAlignment,
    this.actionsOverflowAlignment,
    this.actionsOverflowDirection,
    this.actionsOverflowButtonSpacing,
    this.buttonPadding,
    this.backgroundColor,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.semanticLabel,
    this.insetPadding,
    this.clipBehavior,
    this.shape,
    this.alignment,
    this.scrollable = false,
  });

  const factory AlertDialog.adaptive({
    Key? key,
    Widget? icon,
    EdgeInsetsGeometry? iconPadding,
    Color? iconColor,
    Widget? title,
    EdgeInsetsGeometry? titlePadding,
    TextStyle? titleTextStyle,
    Widget? content,
    EdgeInsetsGeometry? contentPadding,
    TextStyle? contentTextStyle,
    List<Widget>? actions,
    EdgeInsetsGeometry? actionsPadding,
    MainAxisAlignment? actionsAlignment,
    OverflowBarAlignment? actionsOverflowAlignment,
    VerticalDirection? actionsOverflowDirection,
    double? actionsOverflowButtonSpacing,
    EdgeInsetsGeometry? buttonPadding,
    Color? backgroundColor,
    double? elevation,
    Color? shadowColor,
    Color? surfaceTintColor,
    String? semanticLabel,
    EdgeInsets insetPadding,
    Clip? clipBehavior,
    ShapeBorder? shape,
    AlignmentGeometry? alignment,
    bool scrollable,
    ScrollController? scrollController,
    ScrollController? actionScrollController,
    Duration insetAnimationDuration,
    Curve insetAnimationCurve,
  }) = _AdaptiveAlertDialog;

  final Widget? icon;

  final Color? iconColor;

  final EdgeInsetsGeometry? iconPadding;

  final Widget? title;

  final EdgeInsetsGeometry? titlePadding;

  final TextStyle? titleTextStyle;

  final Widget? content;

  final EdgeInsetsGeometry? contentPadding;

  final TextStyle? contentTextStyle;

  final List<Widget>? actions;

  final EdgeInsetsGeometry? actionsPadding;

  final MainAxisAlignment? actionsAlignment;

  final OverflowBarAlignment? actionsOverflowAlignment;

  final VerticalDirection? actionsOverflowDirection;

  final double? actionsOverflowButtonSpacing;

  final EdgeInsetsGeometry? buttonPadding;

  final Color? backgroundColor;

  final double? elevation;

  final Color? shadowColor;

  final Color? surfaceTintColor;

  final String? semanticLabel;

  final EdgeInsets? insetPadding;

  final Clip? clipBehavior;

  final ShapeBorder? shape;

  final AlignmentGeometry? alignment;

  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final ThemeData theme = Theme.of(context);

    final DialogThemeData dialogTheme = DialogTheme.of(context);
    final DialogThemeData defaults = _DialogDefaultsM3(context);

    String? label = semanticLabel;
    switch (theme.platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        break;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        label ??= MaterialLocalizations.of(context).alertDialogLabel;
    }

    // The paddingScaleFactor is used to adjust the padding of Dialog's
    // children.
    const double fontSizeToScale = 14.0;
    final double effectiveTextScale = MediaQuery.textScalerOf(context).scale(fontSizeToScale) / fontSizeToScale;
    final double paddingScaleFactor = _scalePadding(effectiveTextScale);
    final TextDirection? textDirection = Directionality.maybeOf(context);

    Widget? iconWidget;
    Widget? titleWidget;
    Widget? contentWidget;
    Widget? actionsWidget;

    if (icon != null) {
      final bool belowIsTitle = title != null;
      final bool belowIsContent = !belowIsTitle && content != null;
      final EdgeInsets defaultIconPadding = EdgeInsets.only(
        left: 24.0,
        top: 24.0,
        right: 24.0,
        bottom:
            belowIsTitle
                ? 16.0
                : belowIsContent
                ? 0.0
                : 24.0,
      );
      final EdgeInsets effectiveIconPadding = iconPadding?.resolve(textDirection) ?? defaultIconPadding;
      iconWidget = Padding(
        padding: EdgeInsets.only(
          left: effectiveIconPadding.left * paddingScaleFactor,
          right: effectiveIconPadding.right * paddingScaleFactor,
          top: effectiveIconPadding.top * paddingScaleFactor,
          bottom: effectiveIconPadding.bottom,
        ),
        child: IconTheme(
          data: IconThemeData(color: iconColor ?? dialogTheme.iconColor ?? defaults.iconColor),
          child: icon!,
        ),
      );
    }

    if (title != null) {
      final EdgeInsets defaultTitlePadding = EdgeInsets.only(
        left: 24.0,
        top: icon == null ? 24.0 : 0.0,
        right: 24.0,
        bottom: content == null ? 20.0 : 0.0,
      );
      final EdgeInsets effectiveTitlePadding = titlePadding?.resolve(textDirection) ?? defaultTitlePadding;
      titleWidget = Padding(
        padding: EdgeInsets.only(
          left: effectiveTitlePadding.left * paddingScaleFactor,
          right: effectiveTitlePadding.right * paddingScaleFactor,
          top: icon == null ? effectiveTitlePadding.top * paddingScaleFactor : effectiveTitlePadding.top,
          bottom: effectiveTitlePadding.bottom,
        ),
        child: DefaultTextStyle(
          style: titleTextStyle ?? dialogTheme.titleTextStyle ?? defaults.titleTextStyle!,
          textAlign: icon == null ? TextAlign.start : TextAlign.center,
          child: Semantics(
            // For iOS platform, the focus always lands on the title.
            // Set nameRoute to false to avoid title being announce twice.
            namesRoute: label == null && theme.platform != TargetPlatform.iOS,
            container: true,
            child: title,
          ),
        ),
      );
    }

    if (content != null) {
      const EdgeInsets defaultContentPadding = EdgeInsets.only(left: 24.0, top: 16.0, right: 24.0, bottom: 24.0);
      final EdgeInsets effectiveContentPadding = contentPadding?.resolve(textDirection) ?? defaultContentPadding;
      contentWidget = Padding(
        padding: EdgeInsets.only(
          left: effectiveContentPadding.left * paddingScaleFactor,
          right: effectiveContentPadding.right * paddingScaleFactor,
          top:
              title == null && icon == null
                  ? effectiveContentPadding.top * paddingScaleFactor
                  : effectiveContentPadding.top,
          bottom: effectiveContentPadding.bottom,
        ),
        child: DefaultTextStyle(
          style: contentTextStyle ?? dialogTheme.contentTextStyle ?? defaults.contentTextStyle!,
          child: Semantics(container: true, explicitChildNodes: true, child: content),
        ),
      );
    }

    if (actions != null) {
      final double spacing = (buttonPadding?.horizontal ?? 16) / 2;
      actionsWidget = Padding(
        padding: actionsPadding ?? dialogTheme.actionsPadding ?? defaults.actionsPadding!,
        child: OverflowBar(
          alignment: actionsAlignment ?? MainAxisAlignment.end,
          spacing: spacing,
          overflowAlignment: actionsOverflowAlignment ?? OverflowBarAlignment.end,
          overflowDirection: actionsOverflowDirection ?? VerticalDirection.down,
          overflowSpacing: actionsOverflowButtonSpacing ?? 0,
          children: actions!,
        ),
      );
    }

    List<Widget> columnChildren;
    if (scrollable) {
      columnChildren = <Widget>[
        if (title != null || content != null)
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  if (icon != null) iconWidget!,
                  if (title != null) titleWidget!,
                  if (content != null) contentWidget!,
                ],
              ),
            ),
          ),
        if (actions != null) actionsWidget!,
      ];
    } else {
      columnChildren = <Widget>[
        if (icon != null) iconWidget!,
        if (title != null) titleWidget!,
        if (content != null) Flexible(child: contentWidget!),
        if (actions != null) actionsWidget!,
      ];
    }

    Widget dialogChild = IntrinsicWidth(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: columnChildren,
      ),
    );

    if (label != null) {
      dialogChild = Semantics(
        scopesRoute: true,
        explicitChildNodes: true,
        namesRoute: true,
        label: label,
        child: dialogChild,
      );
    }

    return Dialog(
      backgroundColor: backgroundColor,
      elevation: elevation,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      insetPadding: insetPadding,
      clipBehavior: clipBehavior,
      shape: shape,
      alignment: alignment,
      semanticsRole: SemanticsRole.alertDialog,
      child: dialogChild,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('iconColor', iconColor));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('iconPadding', iconPadding));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('titlePadding', titlePadding));
    properties.add(DiagnosticsProperty<TextStyle?>('titleTextStyle', titleTextStyle));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('contentPadding', contentPadding));
    properties.add(DiagnosticsProperty<TextStyle?>('contentTextStyle', contentTextStyle));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('actionsPadding', actionsPadding));
    properties.add(EnumProperty<MainAxisAlignment?>('actionsAlignment', actionsAlignment));
    properties.add(EnumProperty<OverflowBarAlignment?>('actionsOverflowAlignment', actionsOverflowAlignment));
    properties.add(EnumProperty<VerticalDirection?>('actionsOverflowDirection', actionsOverflowDirection));
    properties.add(DoubleProperty('actionsOverflowButtonSpacing', actionsOverflowButtonSpacing));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('buttonPadding', buttonPadding));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(DoubleProperty('elevation', elevation));
    properties.add(ColorProperty('shadowColor', shadowColor));
    properties.add(ColorProperty('surfaceTintColor', surfaceTintColor));
    properties.add(StringProperty('semanticLabel', semanticLabel));
    properties.add(DiagnosticsProperty<EdgeInsets?>('insetPadding', insetPadding));
    properties.add(EnumProperty<Clip?>('clipBehavior', clipBehavior));
    properties.add(DiagnosticsProperty<ShapeBorder?>('shape', shape));
    properties.add(DiagnosticsProperty<AlignmentGeometry?>('alignment', alignment));
    properties.add(DiagnosticsProperty<bool>('scrollable', scrollable));
  }
}

class _AdaptiveAlertDialog extends AlertDialog {
  const _AdaptiveAlertDialog({
    super.key,
    super.icon,
    super.iconPadding,
    super.iconColor,
    super.title,
    super.titlePadding,
    super.titleTextStyle,
    super.content,
    super.contentPadding,
    super.contentTextStyle,
    super.actions,
    super.actionsPadding,
    super.actionsAlignment,
    super.actionsOverflowAlignment,
    super.actionsOverflowDirection,
    super.actionsOverflowButtonSpacing,
    super.buttonPadding,
    super.backgroundColor,
    super.elevation,
    super.shadowColor,
    super.surfaceTintColor,
    super.semanticLabel,
    super.insetPadding,
    super.clipBehavior,
    super.shape,
    super.alignment,
    super.scrollable = false,
    this.scrollController,
    this.actionScrollController,
    this.insetAnimationDuration = const Duration(milliseconds: 100),
    this.insetAnimationCurve = Curves.decelerate,
  });

  final ScrollController? scrollController;
  final ScrollController? actionScrollController;
  final Duration insetAnimationDuration;
  final Curve insetAnimationCurve;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        break;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return CupertinoAlertDialog(
          title: title,
          content: content,
          actions: actions ?? <Widget>[],
          scrollController: scrollController,
          actionScrollController: actionScrollController,
          insetAnimationDuration: insetAnimationDuration,
          insetAnimationCurve: insetAnimationCurve,
        );
    }
    return super.build(context);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ScrollController?>('scrollController', scrollController));
    properties.add(DiagnosticsProperty<ScrollController?>('actionScrollController', actionScrollController));
    properties.add(DiagnosticsProperty<Duration>('insetAnimationDuration', insetAnimationDuration));
    properties.add(DiagnosticsProperty<Curve>('insetAnimationCurve', insetAnimationCurve));
  }
}

class SimpleDialogOption extends StatelessWidget {
  const SimpleDialogOption({super.key, this.onPressed, this.padding, this.child});

  final VoidCallback? onPressed;

  final Widget? child;

  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onPressed,
    child: Padding(padding: padding ?? const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0), child: child),
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onPressed', onPressed));
    properties.add(DiagnosticsProperty<EdgeInsets?>('padding', padding));
  }
}

class SimpleDialog extends StatelessWidget {
  const SimpleDialog({
    super.key,
    this.title,
    this.titlePadding = const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
    this.titleTextStyle,
    this.children,
    this.contentPadding = const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 16.0),
    this.backgroundColor,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.semanticLabel,
    this.insetPadding,
    this.clipBehavior,
    this.shape,
    this.alignment,
  });

  final Widget? title;

  final EdgeInsetsGeometry titlePadding;

  final TextStyle? titleTextStyle;

  final List<Widget>? children;

  final EdgeInsetsGeometry contentPadding;

  final Color? backgroundColor;

  final double? elevation;

  final Color? shadowColor;

  final Color? surfaceTintColor;

  final String? semanticLabel;

  final EdgeInsets? insetPadding;

  final Clip? clipBehavior;

  final ShapeBorder? shape;

  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final ThemeData theme = Theme.of(context);

    String? label = semanticLabel;
    switch (theme.platform) {
      case TargetPlatform.macOS:
      case TargetPlatform.iOS:
        break;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        label ??= MaterialLocalizations.of(context).dialogLabel;
    }

    // The paddingScaleFactor is used to adjust the padding of Dialog
    // children.
    final TextStyle defaultTextStyle =
        titleTextStyle ?? DialogTheme.of(context).titleTextStyle ?? theme.textTheme.titleLarge!;
    final double fontSize = defaultTextStyle.fontSize ?? kDefaultFontSize;
    final double fontSizeToScale = fontSize == 0.0 ? kDefaultFontSize : fontSize;
    final double effectiveTextScale = MediaQuery.textScalerOf(context).scale(fontSizeToScale) / fontSizeToScale;
    final double paddingScaleFactor = _scalePadding(effectiveTextScale);
    final TextDirection? textDirection = Directionality.maybeOf(context);

    Widget? titleWidget;
    if (title != null) {
      final EdgeInsets effectiveTitlePadding = titlePadding.resolve(textDirection);
      titleWidget = Padding(
        padding: EdgeInsets.only(
          left: effectiveTitlePadding.left * paddingScaleFactor,
          right: effectiveTitlePadding.right * paddingScaleFactor,
          top: effectiveTitlePadding.top * paddingScaleFactor,
          bottom: children == null ? effectiveTitlePadding.bottom * paddingScaleFactor : effectiveTitlePadding.bottom,
        ),
        child: DefaultTextStyle(
          style: defaultTextStyle,
          child: Semantics(
            // For iOS platform, the focus always lands on the title.
            // Set nameRoute to false to avoid title being announce twice.
            namesRoute: label == null && theme.platform != TargetPlatform.iOS,
            container: true,
            child: title,
          ),
        ),
      );
    }

    Widget? contentWidget;
    if (children != null) {
      final EdgeInsets effectiveContentPadding = contentPadding.resolve(textDirection);
      contentWidget = Flexible(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: effectiveContentPadding.left * paddingScaleFactor,
            right: effectiveContentPadding.right * paddingScaleFactor,
            top: title == null ? effectiveContentPadding.top * paddingScaleFactor : effectiveContentPadding.top,
            bottom: effectiveContentPadding.bottom * paddingScaleFactor,
          ),
          child: ListBody(children: children!),
        ),
      );
    }

    Widget dialogChild = IntrinsicWidth(
      stepWidth: 56.0,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 280.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[if (title != null) titleWidget!, if (children != null) contentWidget!],
        ),
      ),
    );

    if (label != null) {
      dialogChild = Semantics(
        scopesRoute: true,
        explicitChildNodes: true,
        namesRoute: true,
        label: label,
        child: dialogChild,
      );
    }
    return Dialog(
      backgroundColor: backgroundColor,
      elevation: elevation,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      insetPadding: insetPadding,
      clipBehavior: clipBehavior,
      shape: shape,
      alignment: alignment,
      child: dialogChild,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('titlePadding', titlePadding));
    properties.add(DiagnosticsProperty<TextStyle?>('titleTextStyle', titleTextStyle));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('contentPadding', contentPadding));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(DoubleProperty('elevation', elevation));
    properties.add(ColorProperty('shadowColor', shadowColor));
    properties.add(ColorProperty('surfaceTintColor', surfaceTintColor));
    properties.add(StringProperty('semanticLabel', semanticLabel));
    properties.add(DiagnosticsProperty<EdgeInsets?>('insetPadding', insetPadding));
    properties.add(EnumProperty<Clip?>('clipBehavior', clipBehavior));
    properties.add(DiagnosticsProperty<ShapeBorder?>('shape', shape));
    properties.add(DiagnosticsProperty<AlignmentGeometry?>('alignment', alignment));
  }
}

Widget _buildMaterialDialogTransitions(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) => child;

Future<T?> showDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  Color? barrierColor,
  String? barrierLabel,
  bool useSafeArea = true,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
  TraversalEdgeBehavior? traversalEdgeBehavior,
  bool? requestFocus,
}) {
  assert(_debugIsActive(context));
  assert(debugCheckHasMaterialLocalizations(context));

  final CapturedThemes themes = InheritedTheme.capture(
    from: context,
    to: Navigator.of(context, rootNavigator: useRootNavigator).context,
  );

  return Navigator.of(context, rootNavigator: useRootNavigator).push<T>(
    DialogRoute<T>(
      context: context,
      builder: builder,
      barrierColor:
          barrierColor ??
          DialogTheme.of(context).barrierColor ??
          Theme.of(context).dialogTheme.barrierColor ??
          Colors.black54,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      settings: routeSettings,
      themes: themes,
      anchorPoint: anchorPoint,
      traversalEdgeBehavior: traversalEdgeBehavior ?? TraversalEdgeBehavior.closedLoop,
      requestFocus: requestFocus,
    ),
  );
}

Future<T?> showAdaptiveDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool? barrierDismissible,
  Color? barrierColor,
  String? barrierLabel,
  bool useSafeArea = true,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
  TraversalEdgeBehavior? traversalEdgeBehavior,
  bool? requestFocus,
}) {
  final ThemeData theme = Theme.of(context);
  switch (theme.platform) {
    case TargetPlatform.android:
    case TargetPlatform.fuchsia:
    case TargetPlatform.linux:
    case TargetPlatform.windows:
      return showDialog<T>(
        context: context,
        builder: builder,
        barrierDismissible: barrierDismissible ?? true,
        barrierColor: barrierColor,
        barrierLabel: barrierLabel,
        useSafeArea: useSafeArea,
        useRootNavigator: useRootNavigator,
        routeSettings: routeSettings,
        anchorPoint: anchorPoint,
        traversalEdgeBehavior: traversalEdgeBehavior,
        requestFocus: requestFocus,
      );
    case TargetPlatform.iOS:
    case TargetPlatform.macOS:
      return showCupertinoDialog<T>(
        context: context,
        builder: builder,
        barrierDismissible: barrierDismissible ?? false,
        barrierLabel: barrierLabel,
        useRootNavigator: useRootNavigator,
        anchorPoint: anchorPoint,
        routeSettings: routeSettings,
        requestFocus: requestFocus,
      );
  }
}

bool _debugIsActive(BuildContext context) {
  if (context is Element && !context.debugIsActive) {
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary('This BuildContext is no longer valid.'),
      ErrorDescription('The showDialog function context parameter is a BuildContext that is no longer valid.'),
      ErrorHint(
        'This can commonly occur when the showDialog function is called after awaiting a Future. '
        'In this situation the BuildContext might refer to a widget that has already been disposed during the await. '
        'Consider using a parent context instead.',
      ),
    ]);
  }
  return true;
}

class DialogRoute<T> extends RawDialogRoute<T> {
  DialogRoute({
    required BuildContext context,
    required WidgetBuilder builder,
    CapturedThemes? themes,
    super.barrierColor = Colors.black54,
    super.barrierDismissible,
    String? barrierLabel,
    bool useSafeArea = true,
    super.settings,
    super.requestFocus,
    super.anchorPoint,
    super.traversalEdgeBehavior,
  }) : super(
         pageBuilder: (buildContext, animation, secondaryAnimation) {
           final Widget pageChild = Builder(builder: builder);
           Widget dialog = themes?.wrap(pageChild) ?? pageChild;
           if (useSafeArea) {
             dialog = SafeArea(child: dialog);
           }
           return dialog;
         },
         barrierLabel: barrierLabel ?? MaterialLocalizations.of(context).modalBarrierDismissLabel,
         transitionDuration: const Duration(milliseconds: 150),
         transitionBuilder: _buildMaterialDialogTransitions,
       );

  CurvedAnimation? _curvedAnimation;

  void _setAnimation(Animation<double> animation) {
    if (_curvedAnimation?.parent != animation) {
      _curvedAnimation?.dispose();
      _curvedAnimation = CurvedAnimation(parent: animation, curve: Curves.easeOut);
    }
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    _setAnimation(animation);
    return FadeTransition(
      opacity: _curvedAnimation!,
      child: super.buildTransitions(context, animation, secondaryAnimation, child),
    );
  }

  @override
  void dispose() {
    _curvedAnimation?.dispose();
    super.dispose();
  }
}

double _scalePadding(double textScaleFactor) {
  final double clampedTextScaleFactor = clampDouble(textScaleFactor, 1.0, 2.0);
  // The final padding scale factor is clamped between 1/3 and 1. For example,
  // a non-scaled padding of 24 will produce a padding between 24 and 8.
  return lerpDouble(1.0, 1.0 / 3.0, clampedTextScaleFactor - 1.0)!;
}

// BEGIN GENERATED TOKEN PROPERTIES - Dialog

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// dart format off
class _DialogDefaultsM3 extends DialogThemeData {
  _DialogDefaultsM3(this.context)
    : super(
        alignment: Alignment.center,
        elevation: 6.0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(28.0))),
        clipBehavior: Clip.none,
      );

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;
  late final TextTheme _textTheme = Theme.of(context).textTheme;

  @override
  Color? get iconColor => _colors.secondary;

  @override
  Color? get backgroundColor => _colors.surfaceContainerHigh;

  @override
  Color? get shadowColor => Colors.transparent;

  @override
  Color? get surfaceTintColor => Colors.transparent;

  @override
  TextStyle? get titleTextStyle => _textTheme.headlineSmall;

  @override
  TextStyle? get contentTextStyle => _textTheme.bodyMedium;

  @override
  EdgeInsetsGeometry? get actionsPadding => const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BuildContext>('context', context));
  }
}
// dart format on

// END GENERATED TOKEN PROPERTIES - Dialog

// BEGIN GENERATED TOKEN PROPERTIES - DialogFullscreen

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// dart format off
class _DialogFullscreenDefaultsM3 extends DialogThemeData {
  const _DialogFullscreenDefaultsM3(this.context): super(clipBehavior: Clip.none);

  final BuildContext context;

  @override
  Color? get backgroundColor => Theme.of(context).colorScheme.surface;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BuildContext>('context', context));
  }

}
// dart format on

// END GENERATED TOKEN PROPERTIES - DialogFullscreen
