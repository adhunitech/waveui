library;

import 'dart:ui' show clampDouble, lerpDouble;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:waveui/waveui.dart';

class WaveDialog extends StatelessWidget {
  const WaveDialog({
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
    label ??= MaterialLocalizations.of(context).alertDialogLabel;

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
      titleWidget = Center(
        child: Padding(
          padding: EdgeInsets.only(
            left: effectiveTitlePadding.left * paddingScaleFactor,
            right: effectiveTitlePadding.right * paddingScaleFactor,
            top: icon == null ? effectiveTitlePadding.top * paddingScaleFactor : effectiveTitlePadding.top,
            bottom: effectiveTitlePadding.bottom,
          ),
          child: DefaultTextStyle(
            style: titleTextStyle ?? dialogTheme.titleTextStyle ?? defaults.titleTextStyle!,
            textAlign: icon == null ? TextAlign.start : TextAlign.center,
            child: Semantics(namesRoute: theme.platform != TargetPlatform.iOS, container: true, child: title),
          ),
        ),
      );
    }

    if (content != null) {
      final EdgeInsets defaultContentPadding = EdgeInsets.only(
        left: 24.0,
        top: theme.useMaterial3 ? 16.0 : 20.0,
        right: 24.0,
        bottom: 24.0,
      );
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
      if (actions!.length == 1) {
        actionsWidget = Column(children: [const Divider(), actions!.first]);
      } else if (actions!.length == 2) {
        actionsWidget = Column(
          children: [
            const Divider(),
            Row(
              children: [
                Expanded(child: actions!.first),
                Container(height: 48, width: 1, color: WaveTheme.of(context).colorScheme.separator),
                Expanded(child: actions!.last),
              ],
            ),
          ],
        );
      } else if (actions!.length > 2) {
        actionsWidget = Column(children: actions!.map((e) => Column(children: [const Divider(), e])).toList());
      }
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

    dialogChild = Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      namesRoute: true,
      label: label,
      child: dialogChild,
    );

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
}

double _scalePadding(double textScaleFactor) {
  final double clampedTextScaleFactor = clampDouble(textScaleFactor, 1.0, 2.0);

  return lerpDouble(1.0, 1.0 / 3.0, clampedTextScaleFactor - 1.0)!;
}

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
}
