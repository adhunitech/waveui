// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:flutter/widgets.dart';

class GridTile extends StatelessWidget {
  const GridTile({required this.child, super.key, this.header, this.footer});

  final Widget? header;

  final Widget? footer;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (header == null && footer == null) {
      return child;
    }

    return Stack(
      children: <Widget>[
        Positioned.fill(child: child),
        if (header != null) Positioned(top: 0.0, left: 0.0, right: 0.0, child: header!),
        if (footer != null) Positioned(left: 0.0, bottom: 0.0, right: 0.0, child: footer!),
      ],
    );
  }
}
