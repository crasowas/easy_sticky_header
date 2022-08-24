// Copyright (c) 2022, crasowas.
//
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';

/// Sticky Header Info.
///
/// See also:
///
/// * [RenderStickyContainer], which creates a [StickyHeaderInfo] in callback.
/// * [StickyHeaderController], which handles the [StickyHeaderInfo] list.
class StickyHeaderInfo {
  int index;

  bool visible;

  Size size;

  double pixels;

  Offset offset;

  double stickyAmount;

  Widget widget;

  StickyHeaderInfo({
    required this.index,
    required this.visible,
    required this.size,
    required this.pixels,
    required this.offset,
    this.stickyAmount = 0.0,
    required this.widget,
  });
}
