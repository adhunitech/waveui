// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/colors.dart';
import 'package:waveui/material/debug.dart';
import 'package:waveui/material/drawer_header.dart';
import 'package:waveui/material/icons.dart';
import 'package:waveui/material/ink_well.dart';
import 'package:waveui/material/material_localizations.dart';
import 'package:waveui/material/theme.dart';

class _AccountPictures extends StatelessWidget {
  const _AccountPictures({
    this.currentAccountPicture,
    this.otherAccountsPictures,
    this.currentAccountPictureSize,
    this.otherAccountsPicturesSize,
  });

  final Widget? currentAccountPicture;
  final List<Widget>? otherAccountsPictures;
  final Size? currentAccountPictureSize;
  final Size? otherAccountsPicturesSize;

  @override
  Widget build(BuildContext context) => Stack(
    children: <Widget>[
      PositionedDirectional(
        top: 0.0,
        end: 0.0,
        child: Row(
          children:
              (otherAccountsPictures ?? <Widget>[])
                  .take(3)
                  .map<Widget>(
                    (picture) => Padding(
                      padding: const EdgeInsetsDirectional.only(start: 8.0),
                      child: Semantics(
                        container: true,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                          child: SizedBox.fromSize(size: otherAccountsPicturesSize, child: picture),
                        ),
                      ),
                    ),
                  )
                  .toList(),
        ),
      ),
      Positioned(
        top: 0.0,
        child: Semantics(
          explicitChildNodes: true,
          child: SizedBox.fromSize(size: currentAccountPictureSize, child: currentAccountPicture),
        ),
      ),
    ],
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Size?>('currentAccountPictureSize', currentAccountPictureSize));
    properties.add(DiagnosticsProperty<Size?>('otherAccountsPicturesSize', otherAccountsPicturesSize));
  }
}

class _AccountDetails extends StatefulWidget {
  const _AccountDetails({
    required this.accountName,
    required this.accountEmail,
    required this.isOpen,
    this.onTap,
    this.arrowColor,
  });

  final Widget? accountName;
  final Widget? accountEmail;
  final VoidCallback? onTap;
  final bool isOpen;
  final Color? arrowColor;

  @override
  _AccountDetailsState createState() => _AccountDetailsState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap));
    properties.add(DiagnosticsProperty<bool>('isOpen', isOpen));
    properties.add(ColorProperty('arrowColor', arrowColor));
  }
}

class _AccountDetailsState extends State<_AccountDetails> with SingleTickerProviderStateMixin {
  late final CurvedAnimation _animation;
  late final AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      value: widget.isOpen ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.fastOutSlowIn.flipped,
    )..addListener(
      () => setState(() {
        // [animation]'s value has changed here.
      }),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _animation.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_AccountDetails oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the state of the arrow did not change, there is no need to trigger the animation
    if (oldWidget.isOpen == widget.isOpen) {
      return;
    }

    if (widget.isOpen) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));
    assert(debugCheckHasMaterialLocalizations(context));
    assert(debugCheckHasMaterialLocalizations(context));

    final ThemeData theme = Theme.of(context);
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);

    Widget accountDetails = CustomMultiChildLayout(
      delegate: _AccountDetailsLayout(textDirection: Directionality.of(context)),
      children: <Widget>[
        if (widget.accountName != null)
          LayoutId(
            id: _AccountDetailsLayout.accountName,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: DefaultTextStyle(
                style: theme.primaryTextTheme.bodyLarge!,
                overflow: TextOverflow.ellipsis,
                child: widget.accountName!,
              ),
            ),
          ),
        if (widget.accountEmail != null)
          LayoutId(
            id: _AccountDetailsLayout.accountEmail,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: DefaultTextStyle(
                style: theme.primaryTextTheme.bodyMedium!,
                overflow: TextOverflow.ellipsis,
                child: widget.accountEmail!,
              ),
            ),
          ),
        if (widget.onTap != null)
          LayoutId(
            id: _AccountDetailsLayout.dropdownIcon,
            child: Semantics(
              container: true,
              button: true,
              onTap: widget.onTap,
              child: SizedBox(
                height: _kAccountDetailsHeight,
                width: _kAccountDetailsHeight,
                child: Center(
                  child: Transform.rotate(
                    angle: _animation.value * math.pi,
                    child: Icon(
                      Icons.arrow_drop_down,
                      color: widget.arrowColor,
                      semanticLabel: widget.isOpen ? localizations.hideAccountsLabel : localizations.showAccountsLabel,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );

    if (widget.onTap != null) {
      accountDetails = InkWell(onTap: widget.onTap, excludeFromSemantics: true, child: accountDetails);
    }

    return SizedBox(height: _kAccountDetailsHeight, child: accountDetails);
  }
}

const double _kAccountDetailsHeight = 56.0;

class _AccountDetailsLayout extends MultiChildLayoutDelegate {
  _AccountDetailsLayout({required this.textDirection});

  static const String accountName = 'accountName';
  static const String accountEmail = 'accountEmail';
  static const String dropdownIcon = 'dropdownIcon';

  final TextDirection textDirection;

  @override
  void performLayout(Size size) {
    Size? iconSize;
    if (hasChild(dropdownIcon)) {
      // place the dropdown icon in bottom right (LTR) or bottom left (RTL)
      iconSize = layoutChild(dropdownIcon, BoxConstraints.loose(size));
      positionChild(dropdownIcon, _offsetForIcon(size, iconSize));
    }

    final String? bottomLine = hasChild(accountEmail) ? accountEmail : (hasChild(accountName) ? accountName : null);

    if (bottomLine != null) {
      final Size constraintSize = iconSize == null ? size : Size(size.width - iconSize.width, size.height);
      iconSize ??= const Size(_kAccountDetailsHeight, _kAccountDetailsHeight);

      // place bottom line center at same height as icon center
      final Size bottomLineSize = layoutChild(bottomLine, BoxConstraints.loose(constraintSize));
      final Offset bottomLineOffset = _offsetForBottomLine(size, iconSize, bottomLineSize);
      positionChild(bottomLine, bottomLineOffset);

      // place account name above account email
      if (bottomLine == accountEmail && hasChild(accountName)) {
        final Size nameSize = layoutChild(accountName, BoxConstraints.loose(constraintSize));
        positionChild(accountName, _offsetForName(size, nameSize, bottomLineOffset));
      }
    }
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) => true;

  Offset _offsetForIcon(Size size, Size iconSize) => switch (textDirection) {
    TextDirection.ltr => Offset(size.width - iconSize.width, size.height - iconSize.height),
    TextDirection.rtl => Offset(0.0, size.height - iconSize.height),
  };

  Offset _offsetForBottomLine(Size size, Size iconSize, Size bottomLineSize) {
    final double y = size.height - 0.5 * iconSize.height - 0.5 * bottomLineSize.height;
    return switch (textDirection) {
      TextDirection.ltr => Offset(0.0, y),
      TextDirection.rtl => Offset(size.width - bottomLineSize.width, y),
    };
  }

  Offset _offsetForName(Size size, Size nameSize, Offset bottomLineOffset) {
    final double y = bottomLineOffset.dy - nameSize.height;
    return switch (textDirection) {
      TextDirection.ltr => Offset(0.0, y),
      TextDirection.rtl => Offset(size.width - nameSize.width, y),
    };
  }
}

class UserAccountsDrawerHeader extends StatefulWidget {
  const UserAccountsDrawerHeader({
    required this.accountName,
    required this.accountEmail,
    super.key,
    this.decoration,
    this.margin = const EdgeInsets.only(bottom: 8.0),
    this.currentAccountPicture,
    this.otherAccountsPictures,
    this.currentAccountPictureSize = const Size.square(72.0),
    this.otherAccountsPicturesSize = const Size.square(40.0),
    this.onDetailsPressed,
    this.arrowColor = Colors.white,
  });

  final Decoration? decoration;

  final EdgeInsetsGeometry? margin;

  final Widget? currentAccountPicture;

  final List<Widget>? otherAccountsPictures;

  final Size currentAccountPictureSize;

  final Size otherAccountsPicturesSize;

  final Widget? accountName;

  final Widget? accountEmail;

  final VoidCallback? onDetailsPressed;

  final Color arrowColor;

  @override
  State<UserAccountsDrawerHeader> createState() => _UserAccountsDrawerHeaderState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Decoration?>('decoration', decoration));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('margin', margin));
    properties.add(DiagnosticsProperty<Size>('currentAccountPictureSize', currentAccountPictureSize));
    properties.add(DiagnosticsProperty<Size>('otherAccountsPicturesSize', otherAccountsPicturesSize));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onDetailsPressed', onDetailsPressed));
    properties.add(ColorProperty('arrowColor', arrowColor));
  }
}

class _UserAccountsDrawerHeaderState extends State<UserAccountsDrawerHeader> {
  bool _isOpen = false;

  void _handleDetailsPressed() {
    setState(() {
      _isOpen = !_isOpen;
    });
    widget.onDetailsPressed!();
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMaterialLocalizations(context));
    return Semantics(
      container: true,
      label: MaterialLocalizations.of(context).signedInLabel,
      child: DrawerHeader(
        decoration: widget.decoration ?? BoxDecoration(color: Theme.of(context).colorScheme.primary),
        margin: widget.margin,
        padding: const EdgeInsetsDirectional.only(top: 16.0, start: 16.0),
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(end: 16.0),
                  child: _AccountPictures(
                    currentAccountPicture: widget.currentAccountPicture,
                    otherAccountsPictures: widget.otherAccountsPictures,
                    currentAccountPictureSize: widget.currentAccountPictureSize,
                    otherAccountsPicturesSize: widget.otherAccountsPicturesSize,
                  ),
                ),
              ),
              _AccountDetails(
                accountName: widget.accountName,
                accountEmail: widget.accountEmail,
                isOpen: _isOpen,
                onTap: widget.onDetailsPressed == null ? null : _handleDetailsPressed,
                arrowColor: widget.arrowColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
