// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/banner_theme.dart';
import 'package:waveui/material/color_scheme.dart';
import 'package:waveui/material/colors.dart';
import 'package:waveui/material/divider.dart';
import 'package:waveui/material/material.dart';
import 'package:waveui/material/scaffold.dart';
import 'package:waveui/src/theme/text_theme.dart';
import 'package:waveui/material/theme.dart';

// Examples can assume:
// late BuildContext context;

const Duration _materialBannerTransitionDuration = Duration(milliseconds: 250);
const Curve _materialBannerHeightCurve = Curves.fastOutSlowIn;
const double _kMaxContentTextScaleFactor = 1.5;

enum MaterialBannerClosedReason { dismiss, swipe, hide, remove }

class MaterialBanner extends StatefulWidget {
  const MaterialBanner({
    required this.content,
    required this.actions,
    super.key,
    this.contentTextStyle,
    this.elevation,
    this.leading,
    this.backgroundColor,
    this.surfaceTintColor,
    this.shadowColor,
    this.dividerColor,
    this.padding,
    this.margin,
    this.leadingPadding,
    this.forceActionsBelow = false,
    this.overflowAlignment = OverflowBarAlignment.end,
    this.animation,
    this.onVisible,
    this.minActionBarHeight = 52.0,
  }) : assert(elevation == null || elevation >= 0.0);

  final Widget content;

  final TextStyle? contentTextStyle;

  final List<Widget> actions;

  final double? elevation;

  final Widget? leading;

  final double minActionBarHeight;

  final Color? backgroundColor;

  final Color? surfaceTintColor;

  final Color? shadowColor;

  final Color? dividerColor;

  final EdgeInsetsGeometry? padding;

  final EdgeInsetsGeometry? margin;

  final EdgeInsetsGeometry? leadingPadding;

  final bool forceActionsBelow;

  final OverflowBarAlignment overflowAlignment;

  final Animation<double>? animation;

  final VoidCallback? onVisible;

  // API for ScaffoldMessengerState.showMaterialBanner():

  static AnimationController createAnimationController({required TickerProvider vsync}) =>
      AnimationController(duration: _materialBannerTransitionDuration, debugLabel: 'MaterialBanner', vsync: vsync);

  MaterialBanner withAnimation(Animation<double> newAnimation, {Key? fallbackKey}) => MaterialBanner(
    key: key ?? fallbackKey,
    content: content,
    contentTextStyle: contentTextStyle,
    actions: actions,
    elevation: elevation,
    leading: leading,
    minActionBarHeight: minActionBarHeight,
    backgroundColor: backgroundColor,
    surfaceTintColor: surfaceTintColor,
    shadowColor: shadowColor,
    dividerColor: dividerColor,
    padding: padding,
    margin: margin,
    leadingPadding: leadingPadding,
    forceActionsBelow: forceActionsBelow,
    overflowAlignment: overflowAlignment,
    animation: newAnimation,
    onVisible: onVisible,
  );

  @override
  State<MaterialBanner> createState() => _MaterialBannerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextStyle?>('contentTextStyle', contentTextStyle));
    properties.add(DoubleProperty('elevation', elevation));
    properties.add(DoubleProperty('minActionBarHeight', minActionBarHeight));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(ColorProperty('surfaceTintColor', surfaceTintColor));
    properties.add(ColorProperty('shadowColor', shadowColor));
    properties.add(ColorProperty('dividerColor', dividerColor));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('padding', padding));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('margin', margin));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('leadingPadding', leadingPadding));
    properties.add(DiagnosticsProperty<bool>('forceActionsBelow', forceActionsBelow));
    properties.add(EnumProperty<OverflowBarAlignment>('overflowAlignment', overflowAlignment));
    properties.add(DiagnosticsProperty<Animation<double>?>('animation', animation));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onVisible', onVisible));
  }
}

class _MaterialBannerState extends State<MaterialBanner> {
  bool _wasVisible = false;
  CurvedAnimation? _heightAnimation;
  CurvedAnimation? _slideOutCurvedAnimation;

  @override
  void initState() {
    super.initState();
    widget.animation?.addStatusListener(_onAnimationStatusChanged);
    _setCurvedAnimations();
  }

  @override
  void didUpdateWidget(MaterialBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animation != oldWidget.animation) {
      oldWidget.animation?.removeStatusListener(_onAnimationStatusChanged);
      widget.animation?.addStatusListener(_onAnimationStatusChanged);
      _setCurvedAnimations();
    }
  }

  void _setCurvedAnimations() {
    _heightAnimation?.dispose();
    _slideOutCurvedAnimation?.dispose();
    if (widget.animation != null) {
      _heightAnimation = CurvedAnimation(parent: widget.animation!, curve: _materialBannerHeightCurve);
      _slideOutCurvedAnimation = CurvedAnimation(parent: widget.animation!, curve: const Threshold(0.0));
    } else {
      _heightAnimation = null;
      _slideOutCurvedAnimation = null;
    }
  }

  @override
  void dispose() {
    widget.animation?.removeStatusListener(_onAnimationStatusChanged);
    _heightAnimation?.dispose();
    _slideOutCurvedAnimation?.dispose();
    super.dispose();
  }

  void _onAnimationStatusChanged(AnimationStatus status) {
    if (status.isCompleted) {
      if (widget.onVisible != null && !_wasVisible) {
        widget.onVisible!();
      }
      _wasVisible = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    final bool accessibleNavigation = MediaQuery.accessibleNavigationOf(context);

    assert(widget.actions.isNotEmpty);

    final MaterialBannerThemeData bannerTheme = MaterialBannerTheme.of(context);
    final MaterialBannerThemeData defaults = _BannerDefaultsM3(context);

    final bool isSingleRow = widget.actions.length == 1 && !widget.forceActionsBelow;
    final EdgeInsetsGeometry padding =
        widget.padding ??
        bannerTheme.padding ??
        (isSingleRow
            ? const EdgeInsetsDirectional.only(start: 16.0, top: 2.0)
            : const EdgeInsetsDirectional.only(start: 16.0, top: 24.0, end: 16.0, bottom: 4.0));
    final EdgeInsetsGeometry leadingPadding =
        widget.leadingPadding ?? bannerTheme.leadingPadding ?? const EdgeInsetsDirectional.only(end: 16.0);

    final Widget actionsBar = ConstrainedBox(
      constraints: BoxConstraints(minHeight: widget.minActionBarHeight),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Align(
          alignment: AlignmentDirectional.centerEnd,
          child: OverflowBar(overflowAlignment: widget.overflowAlignment, spacing: 8, children: widget.actions),
        ),
      ),
    );

    final double elevation = widget.elevation ?? bannerTheme.elevation ?? 0.0;
    final EdgeInsetsGeometry margin = widget.margin ?? EdgeInsets.only(bottom: elevation > 0 ? 10.0 : 0.0);
    final Color backgroundColor = widget.backgroundColor ?? bannerTheme.backgroundColor ?? defaults.backgroundColor!;
    final Color? surfaceTintColor =
        widget.surfaceTintColor ?? bannerTheme.surfaceTintColor ?? defaults.surfaceTintColor;
    final Color? shadowColor = widget.shadowColor ?? bannerTheme.shadowColor;
    final Color? dividerColor = widget.dividerColor ?? bannerTheme.dividerColor ?? defaults.dividerColor;
    final TextStyle? textStyle = widget.contentTextStyle ?? bannerTheme.contentTextStyle ?? defaults.contentTextStyle;

    Widget materialBanner = Padding(
      padding: margin,
      child: Material(
        elevation: elevation,
        color: backgroundColor,
        surfaceTintColor: surfaceTintColor,
        shadowColor: shadowColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: padding,
              child: Row(
                children: <Widget>[
                  if (widget.leading != null) Padding(padding: leadingPadding, child: widget.leading),
                  MediaQuery.withClampedTextScaling(
                    // Set maximum text scale factor to _kMaxContentTextScaleFactor for the
                    // content to keep the visual hierarchy the same even with larger font
                    // sizes.
                    maxScaleFactor: _kMaxContentTextScaleFactor,
                    child: Expanded(child: DefaultTextStyle(style: textStyle!, child: widget.content)),
                  ),
                  if (isSingleRow)
                    MediaQuery.withClampedTextScaling(
                      // Set maximum text scale factor to _kMaxContentTextScaleFactor for the
                      // actionsBar to keep the visual hierarchy the same even with larger font
                      // sizes.
                      maxScaleFactor: _kMaxContentTextScaleFactor,
                      child: actionsBar,
                    ),
                ],
              ),
            ),
            if (!isSingleRow) actionsBar,
            if (elevation == 0) Divider(height: 0, color: dividerColor),
          ],
        ),
      ),
    );

    // This provides a static banner for backwards compatibility.
    if (widget.animation == null) {
      return materialBanner;
    }

    materialBanner = SafeArea(child: materialBanner);

    final Animation<Offset> slideOutAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(_slideOutCurvedAnimation!);

    materialBanner = Semantics(
      container: true,
      liveRegion: true,
      onDismiss: () {
        ScaffoldMessenger.of(context).removeCurrentMaterialBanner(reason: MaterialBannerClosedReason.dismiss);
      },
      child:
          accessibleNavigation ? materialBanner : SlideTransition(position: slideOutAnimation, child: materialBanner),
    );

    final Widget materialBannerTransition;
    if (accessibleNavigation) {
      materialBannerTransition = materialBanner;
    } else {
      materialBannerTransition = AnimatedBuilder(
        animation: _heightAnimation!,
        builder:
            (context, child) =>
                Align(alignment: AlignmentDirectional.bottomStart, heightFactor: _heightAnimation!.value, child: child),
        child: materialBanner,
      );
    }

    return Hero(tag: '<MaterialBanner Hero tag - ${widget.content}>', child: ClipRect(child: materialBannerTransition));
  }
}

// BEGIN GENERATED TOKEN PROPERTIES - Banner

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// dart format off
class _BannerDefaultsM3 extends MaterialBannerThemeData {
  _BannerDefaultsM3(this.context)
    : super(elevation: 1.0);

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;
  late final TextTheme _textTheme = Theme.of(context).textTheme;

  @override
  Color? get backgroundColor => _colors.surfaceContainerLow;

  @override
  Color? get surfaceTintColor => Colors.transparent;

  @override
  Color? get dividerColor => _colors.outlineVariant;

  @override
  TextStyle? get contentTextStyle => _textTheme.bodyMedium;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BuildContext>('context', context));
  }


}
