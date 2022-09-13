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
///
/// * [StickyHeaderController], which handles the [StickyHeaderInfo] list.
class StickyHeaderInfo {
  int index;

  bool visible;

  Size size;

  double pixels;

  Offset offset;

  double stickyAmount;

  int? parentIndex;

  bool overlapParent;

  Widget widget;

  StickyHeaderInfo({
    required this.index,
    required this.visible,
    required this.size,
    required this.pixels,
    required this.offset,
    this.stickyAmount = 0.0,
    this.parentIndex,
    this.overlapParent = false,
    required this.widget,
  });

  @override
  String toString() {
    final List<String> description = <String>[
      'index: $index',
      'visible: $visible',
      'size: $size',
      'pixels: $pixels',
      'offset: $offset',
      'stickyAmount: $stickyAmount',
      if (parentIndex != null) 'parentIndex: $parentIndex',
      if (parentIndex != null) 'overlapParent: $overlapParent',
    ];
    return 'StickyHeaderInfo(${description.join(', ')})';
  }
}
