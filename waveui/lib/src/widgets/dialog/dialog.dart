import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Theme;
import 'package:waveui/waveui.dart';

double _scalePadding(double textScaleFactor) {
  final double clampedTextScaleFactor = clampDouble(textScaleFactor, 1.0, 2.0);
  // The final padding scale factor is clamped between 1/3 and 1. For example,
  // a non-scaled padding of 24 will produce a padding between 24 and 8.
  return lerpDouble(1.0, 1.0 / 3.0, clampedTextScaleFactor - 1.0)!;
}

class WaveDialog extends StatelessWidget {
  const WaveDialog({
    super.key,
    this.icon,
    this.iconPadding,
    this.iconColor,
    this.title,
    this.titlePadding,
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
    this.shadowColor,
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

  final Color? shadowColor;

  final String? semanticLabel;

  final EdgeInsets? insetPadding;

  final Clip? clipBehavior;

  final ShapeBorder? shape;

  final AlignmentGeometry? alignment;

  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final waveTheme = Theme.of(context);
    final DialogThemeData dialogTheme = DialogThemeData(
      titleTextStyle: waveTheme.textTheme.h4.copyWith(fontWeight: FontWeight.w700),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shadowColor: Colors.transparent,
      actionsPadding: const EdgeInsets.only(bottom: 16, top: 16),
      alignment: Alignment.center,
      backgroundColor: waveTheme.colorScheme.surfacePrimary,
      barrierColor: Colors.green,
      contentTextStyle: waveTheme.textTheme.body,
      iconColor: Colors.black,
      insetPadding: const EdgeInsets.all(33),
    );

    final String label = semanticLabel ?? MaterialLocalizations.of(context).alertDialogLabel;

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
        child: IconTheme(data: IconThemeData(color: iconColor ?? dialogTheme.iconColor), child: icon!),
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
          style: dialogTheme.titleTextStyle!,
          textAlign: icon == null ? TextAlign.start : TextAlign.center,
          child: Semantics(namesRoute: false, container: true, child: title),
        ),
      );
    }

    if (content != null) {
      const EdgeInsets defaultContentPadding = EdgeInsets.all(24);
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
          style: contentTextStyle ?? dialogTheme.contentTextStyle!,
          child: Semantics(container: true, explicitChildNodes: true, child: content),
        ),
      );
    }

    if (actions != null) {
      final List<Widget> actionWidgets = actions!.map((e) => Expanded(child: e)).toList();

      final List<Widget> spacedWidgets = [];
      for (int i = 0; i < actionWidgets.length; i++) {
        spacedWidgets.add(actionWidgets[i]);
        if (i != actionWidgets.length - 1) {
          spacedWidgets.add(const SizedBox(width: 16));
        }
      }

      actionsWidget = Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Row(children: spacedWidgets),
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

    dialogChild = Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      namesRoute: true,
      label: label,
      child: dialogChild,
    );

    return Dialog(
      backgroundColor: dialogTheme.backgroundColor,
      elevation: dialogTheme.elevation,
      shadowColor: dialogTheme.shadowColor,
      surfaceTintColor: dialogTheme.surfaceTintColor,
      insetPadding: dialogTheme.insetPadding,
      clipBehavior: dialogTheme.clipBehavior,
      shape: dialogTheme.shape,
      alignment: dialogTheme.alignment,
      child: dialogChild,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('iconColor', iconColor))
      ..add(DiagnosticsProperty<EdgeInsetsGeometry?>('iconPadding', iconPadding))
      ..add(DiagnosticsProperty<EdgeInsetsGeometry?>('titlePadding', titlePadding))
      ..add(DiagnosticsProperty<EdgeInsetsGeometry?>('contentPadding', contentPadding))
      ..add(DiagnosticsProperty<TextStyle?>('contentTextStyle', contentTextStyle))
      ..add(DiagnosticsProperty<EdgeInsetsGeometry?>('actionsPadding', actionsPadding))
      ..add(EnumProperty<MainAxisAlignment?>('actionsAlignment', actionsAlignment))
      ..add(EnumProperty<OverflowBarAlignment?>('actionsOverflowAlignment', actionsOverflowAlignment))
      ..add(EnumProperty<VerticalDirection?>('actionsOverflowDirection', actionsOverflowDirection))
      ..add(DoubleProperty('actionsOverflowButtonSpacing', actionsOverflowButtonSpacing))
      ..add(DiagnosticsProperty<EdgeInsetsGeometry?>('buttonPadding', buttonPadding))
      ..add(ColorProperty('shadowColor', shadowColor))
      ..add(StringProperty('semanticLabel', semanticLabel))
      ..add(DiagnosticsProperty<EdgeInsets?>('insetPadding', insetPadding))
      ..add(EnumProperty<Clip?>('clipBehavior', clipBehavior))
      ..add(DiagnosticsProperty<ShapeBorder?>('shape', shape))
      ..add(DiagnosticsProperty<AlignmentGeometry?>('alignment', alignment))
      ..add(DiagnosticsProperty<bool>('scrollable', scrollable));
  }
}
