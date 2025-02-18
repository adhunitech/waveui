// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:waveui/material/colors.dart';
import 'package:waveui/material/constants.dart';
import 'package:waveui/material/text_button.dart';
import 'package:waveui/material/theme.dart';

const TextStyle _kToolbarButtonFontStyle = TextStyle(
  inherit: false,
  fontSize: 14.0,
  letterSpacing: -0.15,
  fontWeight: FontWeight.w400,
);

const EdgeInsets _kToolbarButtonPadding = EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 3.0);

class DesktopTextSelectionToolbarButton extends StatelessWidget {
  const DesktopTextSelectionToolbarButton({required this.onPressed, required this.child, super.key});

  DesktopTextSelectionToolbarButton.text({
    required BuildContext context,
    required this.onPressed,
    required String text,
    super.key,
  }) : child = Text(
         text,
         overflow: TextOverflow.ellipsis,
         style: _kToolbarButtonFontStyle.copyWith(
           color: Theme.of(context).colorScheme.brightness == Brightness.dark ? Colors.white : Colors.black87,
         ),
       );

  final VoidCallback? onPressed;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // TODO(hansmuller): Should be colorScheme.onSurface
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.colorScheme.brightness == Brightness.dark;
    final Color foregroundColor = isDark ? Colors.white : Colors.black87;

    return SizedBox(
      width: double.infinity,
      child: TextButton(
        style: TextButton.styleFrom(
          alignment: Alignment.centerLeft,
          enabledMouseCursor: SystemMouseCursors.basic,
          disabledMouseCursor: SystemMouseCursors.basic,
          foregroundColor: foregroundColor,
          shape: const RoundedRectangleBorder(),
          minimumSize: const Size(kMinInteractiveDimension, 36.0),
          padding: _kToolbarButtonPadding,
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onPressed', onPressed));
  }
}
