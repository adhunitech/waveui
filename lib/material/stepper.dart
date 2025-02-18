// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/button_style.dart';
import 'package:waveui/material/color_scheme.dart';
import 'package:waveui/material/colors.dart';
import 'package:waveui/material/debug.dart';
import 'package:waveui/material/icons.dart';
import 'package:waveui/material/ink_well.dart';
import 'package:waveui/material/material.dart';
import 'package:waveui/material/material_localizations.dart';
import 'package:waveui/material/text_button.dart';
import 'package:waveui/material/text_theme.dart';
import 'package:waveui/material/theme.dart';

// TODO(dragostis): Missing functionality:
//   * mobile horizontal mode with adding/removing steps
//   * alternative labeling
//   * stepper feedback in the case of high-latency interactions

enum StepState { indexed, editing, complete, disabled, error }

enum StepperType { vertical, horizontal }

@immutable
class ControlsDetails {
  const ControlsDetails({required this.currentStep, required this.stepIndex, this.onStepCancel, this.onStepContinue});

  final int currentStep;

  final int stepIndex;

  final VoidCallback? onStepContinue;

  final VoidCallback? onStepCancel;

  bool get isActive => currentStep == stepIndex;
}

typedef ControlsWidgetBuilder = Widget Function(BuildContext context, ControlsDetails details);

typedef StepIconBuilder = Widget? Function(int stepIndex, StepState stepState);

const TextStyle _kStepStyle = TextStyle(fontSize: 12.0, color: Colors.white);
const Color _kErrorLight = Colors.red;
final Color _kErrorDark = Colors.red.shade400;
const Color _kCircleActiveLight = Colors.white;
const Color _kCircleActiveDark = Colors.black87;
const Color _kDisabledLight = Colors.black38;
const Color _kDisabledDark = Colors.white38;
const double _kStepSize = 24.0;
const double _kTriangleSqrt = 0.866025; // sqrt(3.0) / 2.0
const double _kTriangleHeight = _kStepSize * _kTriangleSqrt;
const double _kMaxStepSize = 80.0;

@immutable
class Step {
  const Step({
    required this.title,
    required this.content,
    this.subtitle,
    this.state = StepState.indexed,
    this.isActive = false,
    this.label,
    this.stepStyle,
  });

  final Widget title;

  final Widget? subtitle;

  final Widget content;

  final StepState state;

  final bool isActive;

  final Widget? label;

  final StepStyle? stepStyle;
}

class Stepper extends StatefulWidget {
  const Stepper({
    required this.steps,
    super.key,
    this.controller,
    this.physics,
    this.type = StepperType.vertical,
    this.currentStep = 0,
    this.onStepTapped,
    this.onStepContinue,
    this.onStepCancel,
    this.controlsBuilder,
    this.elevation,
    this.margin,
    this.connectorColor,
    this.connectorThickness,
    this.stepIconBuilder,
    this.stepIconHeight,
    this.stepIconWidth,
    this.stepIconMargin,
    this.clipBehavior = Clip.none,
  }) : assert(0 <= currentStep && currentStep < steps.length),
       assert(
         stepIconHeight == null || (stepIconHeight >= _kStepSize && stepIconHeight <= _kMaxStepSize),
         'stepIconHeight must be greater than $_kStepSize and less or equal to $_kMaxStepSize',
       ),
       assert(
         stepIconWidth == null || (stepIconWidth >= _kStepSize && stepIconWidth <= _kMaxStepSize),
         'stepIconWidth must be greater than $_kStepSize and less or equal to $_kMaxStepSize',
       ),
       assert(
         stepIconHeight == null || stepIconWidth == null || stepIconHeight == stepIconWidth,
         'If either stepIconHeight or stepIconWidth is specified, both must be specified and '
         'the values must be equal.',
       );

  final List<Step> steps;

  final ScrollPhysics? physics;

  final ScrollController? controller;

  final StepperType type;

  final int currentStep;

  final ValueChanged<int>? onStepTapped;

  final VoidCallback? onStepContinue;

  final VoidCallback? onStepCancel;

  final ControlsWidgetBuilder? controlsBuilder;

  final double? elevation;

  final EdgeInsetsGeometry? margin;

  final WidgetStateProperty<Color>? connectorColor;

  final double? connectorThickness;

  final StepIconBuilder? stepIconBuilder;

  final double? stepIconHeight;

  final double? stepIconWidth;

  final EdgeInsets? stepIconMargin;

  final Clip clipBehavior;

  @override
  State<Stepper> createState() => _StepperState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<Step>('steps', steps));
    properties.add(DiagnosticsProperty<ScrollPhysics?>('physics', physics));
    properties.add(DiagnosticsProperty<ScrollController?>('controller', controller));
    properties.add(EnumProperty<StepperType>('type', type));
    properties.add(IntProperty('currentStep', currentStep));
    properties.add(ObjectFlagProperty<ValueChanged<int>?>.has('onStepTapped', onStepTapped));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onStepContinue', onStepContinue));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onStepCancel', onStepCancel));
    properties.add(ObjectFlagProperty<ControlsWidgetBuilder?>.has('controlsBuilder', controlsBuilder));
    properties.add(DoubleProperty('elevation', elevation));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('margin', margin));
    properties.add(DiagnosticsProperty<WidgetStateProperty<Color>?>('connectorColor', connectorColor));
    properties.add(DoubleProperty('connectorThickness', connectorThickness));
    properties.add(ObjectFlagProperty<StepIconBuilder?>.has('stepIconBuilder', stepIconBuilder));
    properties.add(DoubleProperty('stepIconHeight', stepIconHeight));
    properties.add(DoubleProperty('stepIconWidth', stepIconWidth));
    properties.add(DiagnosticsProperty<EdgeInsets?>('stepIconMargin', stepIconMargin));
    properties.add(EnumProperty<Clip>('clipBehavior', clipBehavior));
  }
}

class _StepperState extends State<Stepper> with TickerProviderStateMixin {
  late List<GlobalKey> _keys;
  final Map<int, StepState> _oldStates = <int, StepState>{};

  @override
  void initState() {
    super.initState();
    _keys = List<GlobalKey>.generate(widget.steps.length, (i) => GlobalKey());

    for (int i = 0; i < widget.steps.length; i += 1) {
      _oldStates[i] = widget.steps[i].state;
    }
  }

  @override
  void didUpdateWidget(Stepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    assert(widget.steps.length == oldWidget.steps.length);

    for (int i = 0; i < oldWidget.steps.length; i += 1) {
      _oldStates[i] = oldWidget.steps[i].state;
    }
  }

  EdgeInsetsGeometry? get _stepIconMargin => widget.stepIconMargin;

  double? get _stepIconHeight => widget.stepIconHeight;

  double? get _stepIconWidth => widget.stepIconWidth;

  double get _heightFactor => (_isLabel() && _stepIconHeight != null) ? 2.5 : 2.0;

  bool _isFirst(int index) => index == 0;

  bool _isLast(int index) => widget.steps.length - 1 == index;

  bool _isCurrent(int index) => widget.currentStep == index;

  bool _isDark() => Theme.of(context).brightness == Brightness.dark;

  bool _isLabel() {
    for (final Step step in widget.steps) {
      if (step.label != null) {
        return true;
      }
    }
    return false;
  }

  StepStyle? _stepStyle(int index) => widget.steps[index].stepStyle;

  Color _connectorColor(bool isActive) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Set<WidgetState> states = <WidgetState>{if (isActive) WidgetState.selected else WidgetState.disabled};
    final Color? resolvedConnectorColor = widget.connectorColor?.resolve(states);

    return resolvedConnectorColor ?? (isActive ? colorScheme.primary : Colors.grey.shade400);
  }

  Widget _buildLine(bool visible, bool isActive) => ColoredBox(
    color: _connectorColor(isActive),
    child: SizedBox(width: visible ? widget.connectorThickness ?? 1.0 : 0.0, height: 16.0),
  );

  Widget _buildCircleChild(int index, bool oldState) {
    final StepState state = oldState ? _oldStates[index]! : widget.steps[index].state;
    if (widget.stepIconBuilder?.call(index, state) case final Widget icon) {
      return icon;
    }
    TextStyle? textStyle = _stepStyle(index)?.indexStyle;
    final bool isDarkActive = _isDark() && widget.steps[index].isActive;
    final Color iconColor = isDarkActive ? _kCircleActiveDark : _kCircleActiveLight;
    textStyle ??= isDarkActive ? _kStepStyle.copyWith(color: Colors.black87) : _kStepStyle;

    return switch (state) {
      StepState.indexed || StepState.disabled => Text('${index + 1}', style: textStyle),
      StepState.editing => Icon(Icons.edit, color: iconColor, size: 18.0),
      StepState.complete => Icon(Icons.check, color: iconColor, size: 18.0),
      StepState.error => const Center(child: Text('!', style: _kStepStyle)),
    };
  }

  Color _circleColor(int index) {
    final bool isActive = widget.steps[index].isActive;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Set<WidgetState> states = <WidgetState>{if (isActive) WidgetState.selected else WidgetState.disabled};
    final Color? resolvedConnectorColor = widget.connectorColor?.resolve(states);
    if (resolvedConnectorColor != null) {
      return resolvedConnectorColor;
    }
    if (!_isDark()) {
      return isActive ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.38);
    } else {
      return isActive ? colorScheme.secondary : colorScheme.background;
    }
  }

  Widget _buildCircle(int index, bool oldState) => Padding(
    padding: _stepIconMargin ?? const EdgeInsets.symmetric(vertical: 8.0),
    child: SizedBox(
      width: _stepIconWidth ?? _kStepSize,
      height: _stepIconHeight ?? _kStepSize,
      child: AnimatedContainer(
        curve: Curves.fastOutSlowIn,
        duration: kThemeAnimationDuration,
        decoration: BoxDecoration(
          color: _stepStyle(index)?.color ?? _circleColor(index),
          shape: BoxShape.circle,
          border: _stepStyle(index)?.border,
          boxShadow: _stepStyle(index)?.boxShadow != null ? <BoxShadow>[_stepStyle(index)!.boxShadow!] : null,
          gradient: _stepStyle(index)?.gradient,
        ),
        child: Center(child: _buildCircleChild(index, oldState && widget.steps[index].state == StepState.error)),
      ),
    ),
  );

  Widget _buildTriangle(int index, bool oldState) {
    Color? color = _stepStyle(index)?.errorColor;
    color ??= _isDark() ? _kErrorDark : _kErrorLight;

    return Padding(
      padding: _stepIconMargin ?? const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: _stepIconWidth ?? _kStepSize,
        height: _stepIconHeight ?? _kStepSize,
        child: Center(
          child: SizedBox(
            width: _stepIconWidth ?? _kStepSize,
            height: _stepIconHeight != null ? _stepIconHeight! * _kTriangleSqrt : _kTriangleHeight,
            child: CustomPaint(
              painter: _TrianglePainter(color: color),
              child: Align(
                alignment: const Alignment(0.0, 0.8), // 0.8 looks better than the geometrical 0.33.
                child: _buildCircleChild(index, oldState && widget.steps[index].state != StepState.error),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(int index) {
    if (widget.steps[index].state != _oldStates[index]) {
      return AnimatedCrossFade(
        firstChild: _buildCircle(index, true),
        secondChild: _buildTriangle(index, true),
        firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
        secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
        sizeCurve: Curves.fastOutSlowIn,
        crossFadeState:
            widget.steps[index].state == StepState.error ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: kThemeAnimationDuration,
      );
    } else {
      if (widget.steps[index].state != StepState.error) {
        return _buildCircle(index, false);
      } else {
        return _buildTriangle(index, false);
      }
    }
  }

  Widget _buildVerticalControls(int stepIndex) {
    if (widget.controlsBuilder != null) {
      return widget.controlsBuilder!(
        context,
        ControlsDetails(
          currentStep: widget.currentStep,
          onStepContinue: widget.onStepContinue,
          onStepCancel: widget.onStepCancel,
          stepIndex: stepIndex,
        ),
      );
    }

    final Color cancelColor = switch (Theme.of(context).brightness) {
      Brightness.light => Colors.black54,
      Brightness.dark => Colors.white70,
    };

    final ThemeData themeData = Theme.of(context);
    final ColorScheme colorScheme = themeData.colorScheme;
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);

    const OutlinedBorder buttonShape = RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2)));
    const EdgeInsets buttonPadding = EdgeInsets.symmetric(horizontal: 16.0);

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: SizedBox(
        height: 48.0,
        child: Row(
          // The Material spec no longer includes a Stepper widget. The continue
          // and cancel button styles have been configured to match the original
          // version of this widget.
          children: <Widget>[
            TextButton(
              onPressed: widget.onStepContinue,
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.resolveWith<Color?>(
                  (states) =>
                      states.contains(WidgetState.disabled)
                          ? null
                          : (_isDark() ? colorScheme.onSurface : colorScheme.onPrimary),
                ),
                backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                  (states) => _isDark() || states.contains(WidgetState.disabled) ? null : colorScheme.primary,
                ),
                padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(buttonPadding),
                shape: const WidgetStatePropertyAll<OutlinedBorder>(buttonShape),
              ),
              child: Text(localizations.continueButtonLabel),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 8.0),
              child: TextButton(
                onPressed: widget.onStepCancel,
                style: TextButton.styleFrom(foregroundColor: cancelColor, padding: buttonPadding, shape: buttonShape),
                child: Text(localizations.cancelButtonLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _titleStyle(int index) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    switch (widget.steps[index].state) {
      case StepState.indexed:
      case StepState.editing:
      case StepState.complete:
        return textTheme.bodyLarge!;
      case StepState.disabled:
        return textTheme.bodyLarge!.copyWith(color: _isDark() ? _kDisabledDark : _kDisabledLight);
      case StepState.error:
        return textTheme.bodyLarge!.copyWith(color: _isDark() ? _kErrorDark : _kErrorLight);
    }
  }

  TextStyle _subtitleStyle(int index) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    switch (widget.steps[index].state) {
      case StepState.indexed:
      case StepState.editing:
      case StepState.complete:
        return textTheme.bodySmall!;
      case StepState.disabled:
        return textTheme.bodySmall!.copyWith(color: _isDark() ? _kDisabledDark : _kDisabledLight);
      case StepState.error:
        return textTheme.bodySmall!.copyWith(color: _isDark() ? _kErrorDark : _kErrorLight);
    }
  }

  TextStyle _labelStyle(int index) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    switch (widget.steps[index].state) {
      case StepState.indexed:
      case StepState.editing:
      case StepState.complete:
        return textTheme.bodyLarge!;
      case StepState.disabled:
        return textTheme.bodyLarge!.copyWith(color: _isDark() ? _kDisabledDark : _kDisabledLight);
      case StepState.error:
        return textTheme.bodyLarge!.copyWith(color: _isDark() ? _kErrorDark : _kErrorLight);
    }
  }

  Widget _buildHeaderText(int index) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      AnimatedDefaultTextStyle(
        style: _titleStyle(index),
        duration: kThemeAnimationDuration,
        curve: Curves.fastOutSlowIn,
        child: widget.steps[index].title,
      ),
      if (widget.steps[index].subtitle != null)
        Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: AnimatedDefaultTextStyle(
            style: _subtitleStyle(index),
            duration: kThemeAnimationDuration,
            curve: Curves.fastOutSlowIn,
            child: widget.steps[index].subtitle!,
          ),
        ),
    ],
  );

  Widget _buildLabelText(int index) {
    if (widget.steps[index].label != null) {
      return AnimatedDefaultTextStyle(
        style: _labelStyle(index),
        duration: kThemeAnimationDuration,
        child: widget.steps[index].label!,
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildVerticalHeader(int index) {
    final bool isActive = widget.steps[index].isActive;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              // Line parts are always added in order for the ink splash to
              // flood the tips of the connector lines.
              _buildLine(!_isFirst(index), isActive),
              _buildIcon(index),
              _buildLine(!_isLast(index), isActive),
            ],
          ),
          Expanded(
            child: Padding(padding: const EdgeInsetsDirectional.only(start: 12.0), child: _buildHeaderText(index)),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalBody(int index) {
    final double? marginLeft = _stepIconMargin?.resolve(TextDirection.ltr).left;
    final double? marginRight = _stepIconMargin?.resolve(TextDirection.ltr).right;
    final double? additionalMarginLeft = marginLeft != null ? marginLeft / 2.0 : null;
    final double? additionalMarginRight = marginRight != null ? marginRight / 2.0 : null;

    return Stack(
      children: <Widget>[
        PositionedDirectional(
          // When use margin affects the left or right side of the child, we
          // need to add half of the margin to the start or end of the child
          // respectively to get the correct positioning.
          start: 24.0 + (additionalMarginLeft ?? 0.0) + (additionalMarginRight ?? 0.0),
          top: 0.0,
          bottom: 0.0,
          width: _stepIconWidth ?? _kStepSize,
          child: Center(
            // The line is drawn from the center of the circle vertically until
            // it reaches the bottom and then horizontally to the edge of the
            // stepper.
            child: SizedBox(
              width: !_isLast(index) ? (widget.connectorThickness ?? 1.0) : 0.0,
              height: double.infinity,
              child: ColoredBox(color: _connectorColor(widget.steps[index].isActive)),
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity, height: 0),
          secondChild: Padding(
            padding: EdgeInsetsDirectional.only(
              // Adjust [controlsBuilder] padding so that the content is
              // centered vertically.
              start: 60.0 + (marginLeft ?? 0.0),
              end: 24.0,
              bottom: 24.0,
            ),
            child: Column(
              children: <Widget>[
                ClipRect(clipBehavior: widget.clipBehavior, child: widget.steps[index].content),
                _buildVerticalControls(index),
              ],
            ),
          ),
          firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
          secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
          sizeCurve: Curves.fastOutSlowIn,
          crossFadeState: _isCurrent(index) ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: kThemeAnimationDuration,
        ),
      ],
    );
  }

  Widget _buildVertical() => ListView(
    controller: widget.controller,
    shrinkWrap: true,
    physics: widget.physics,
    children: <Widget>[
      for (int i = 0; i < widget.steps.length; i += 1)
        Column(
          key: _keys[i],
          children: <Widget>[
            InkWell(
              onTap:
                  widget.steps[i].state != StepState.disabled
                      ? () {
                        // In the vertical case we need to scroll to the newly tapped
                        // step.
                        Scrollable.ensureVisible(
                          _keys[i].currentContext!,
                          curve: Curves.fastOutSlowIn,
                          duration: kThemeAnimationDuration,
                        );

                        widget.onStepTapped?.call(i);
                      }
                      : null,
              canRequestFocus: widget.steps[i].state != StepState.disabled,
              child: _buildVerticalHeader(i),
            ),
            _buildVerticalBody(i),
          ],
        ),
    ],
  );

  Widget _buildHorizontal() {
    final List<Widget> children = <Widget>[
      for (int i = 0; i < widget.steps.length; i += 1) ...<Widget>[
        InkResponse(
          onTap:
              widget.steps[i].state != StepState.disabled
                  ? () {
                    widget.onStepTapped?.call(i);
                  }
                  : null,
          canRequestFocus: widget.steps[i].state != StepState.disabled,
          child: Row(
            children: <Widget>[
              SizedBox(
                height: _isLabel() ? 104.0 : 72.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (widget.steps[i].label != null) const SizedBox(height: 24.0),
                    Center(child: _buildIcon(i)),
                    if (widget.steps[i].label != null) SizedBox(height: 24.0, child: _buildLabelText(i)),
                  ],
                ),
              ),
              Padding(
                padding: _stepIconMargin ?? const EdgeInsetsDirectional.only(start: 12.0),
                child: _buildHeaderText(i),
              ),
            ],
          ),
        ),
        if (!_isLast(i))
          Expanded(
            child: Padding(
              key: Key('line$i'),
              padding: _stepIconMargin ?? const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                height: widget.steps[i].stepStyle?.connectorThickness ?? widget.connectorThickness ?? 1.0,
                child: ColoredBox(
                  color: widget.steps[i].stepStyle?.connectorColor ?? _connectorColor(widget.steps[i].isActive),
                ),
              ),
            ),
          ),
      ],
    ];

    final List<Widget> stepPanels = <Widget>[];
    for (int i = 0; i < widget.steps.length; i += 1) {
      stepPanels.add(
        Visibility(
          maintainState: true,
          visible: i == widget.currentStep,
          child: ClipRect(clipBehavior: widget.clipBehavior, child: widget.steps[i].content),
        ),
      );
    }

    return Column(
      children: <Widget>[
        Material(
          elevation: widget.elevation ?? 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SizedBox(
              height: _stepIconHeight != null ? _stepIconHeight! * _heightFactor : null,
              child: Row(children: children),
            ),
          ),
        ),
        Expanded(
          child: ListView(
            controller: widget.controller,
            physics: widget.physics,
            padding: const EdgeInsets.all(24.0),
            children: <Widget>[
              AnimatedSize(
                curve: Curves.fastOutSlowIn,
                duration: kThemeAnimationDuration,
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: stepPanels),
              ),
              _buildVerticalControls(widget.currentStep),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMaterialLocalizations(context));
    assert(() {
      if (context.findAncestorWidgetOfExactType<Stepper>() != null) {
        throw FlutterError(
          'Steppers must not be nested.\n'
          'The material specification advises that one should avoid embedding '
          'steppers within steppers. '
          'https://material.io/archive/guidelines/components/steppers.html#steppers-usage',
        );
      }
      return true;
    }());
    return switch (widget.type) {
      StepperType.vertical => _buildVertical(),
      StepperType.horizontal => _buildHorizontal(),
    };
  }
}

// Paints a triangle whose base is the bottom of the bounding rectangle and its
// top vertex the middle of its top.
class _TrianglePainter extends CustomPainter {
  _TrianglePainter({required this.color});

  final Color color;

  @override
  bool hitTest(Offset point) => true; // Hitting the rectangle is fine enough.

  @override
  bool shouldRepaint(_TrianglePainter oldPainter) => oldPainter.color != color;

  @override
  void paint(Canvas canvas, Size size) {
    final double base = size.width;
    final double halfBase = size.width / 2.0;
    final double height = size.height;
    final List<Offset> points = <Offset>[Offset(0.0, height), Offset(base, height), Offset(halfBase, 0.0)];

    canvas.drawPath(Path()..addPolygon(points, true), Paint()..color = color);
  }
}

@immutable
class StepStyle with Diagnosticable {
  const StepStyle({
    this.color,
    this.errorColor,
    this.connectorColor,
    this.connectorThickness,
    this.border,
    this.boxShadow,
    this.gradient,
    this.indexStyle,
  });

  final Color? color;

  final Color? errorColor;

  final Color? connectorColor;

  final double? connectorThickness;

  final BoxBorder? border;

  final BoxShadow? boxShadow;

  final Gradient? gradient;

  final TextStyle? indexStyle;

  StepStyle copyWith({
    Color? color,
    Color? errorColor,
    Color? connectorColor,
    double? connectorThickness,
    BoxBorder? border,
    BoxShadow? boxShadow,
    Gradient? gradient,
    TextStyle? indexStyle,
  }) => StepStyle(
    color: color ?? this.color,
    errorColor: errorColor ?? this.errorColor,
    connectorColor: connectorColor ?? this.connectorColor,
    connectorThickness: connectorThickness ?? this.connectorThickness,
    border: border ?? this.border,
    boxShadow: boxShadow ?? this.boxShadow,
    gradient: gradient ?? this.gradient,
    indexStyle: indexStyle ?? this.indexStyle,
  );

  StepStyle merge(StepStyle? stepStyle) {
    if (stepStyle == null) {
      return this;
    }
    return copyWith(
      color: stepStyle.color,
      errorColor: stepStyle.errorColor,
      connectorColor: stepStyle.connectorColor,
      connectorThickness: stepStyle.connectorThickness,
      border: stepStyle.border,
      boxShadow: stepStyle.boxShadow,
      gradient: stepStyle.gradient,
      indexStyle: stepStyle.indexStyle,
    );
  }

  @override
  int get hashCode =>
      Object.hash(color, errorColor, connectorColor, connectorThickness, border, boxShadow, gradient, indexStyle);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is StepStyle &&
        other.color == color &&
        other.errorColor == errorColor &&
        other.connectorColor == connectorColor &&
        other.connectorThickness == connectorThickness &&
        other.border == border &&
        other.boxShadow == boxShadow &&
        other.gradient == gradient &&
        other.indexStyle == indexStyle;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    final ThemeData theme = ThemeData.fallback();
    final TextTheme defaultTextTheme = theme.textTheme;
    properties.add(ColorProperty('color', color, defaultValue: null));
    properties.add(ColorProperty('errorColor', errorColor, defaultValue: null));
    properties.add(ColorProperty('connectorColor', connectorColor, defaultValue: null));
    properties.add(DoubleProperty('connectorThickness', connectorThickness, defaultValue: null));
    properties.add(DiagnosticsProperty<BoxBorder>('border', border, defaultValue: null));
    properties.add(DiagnosticsProperty<BoxShadow>('boxShadow', boxShadow, defaultValue: null));
    properties.add(DiagnosticsProperty<Gradient>('gradient', gradient, defaultValue: null));
    properties.add(DiagnosticsProperty<TextStyle>('indexStyle', indexStyle, defaultValue: defaultTextTheme.bodyLarge));
  }
}
