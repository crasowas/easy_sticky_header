// Copyright (c) 2022, crasowas.
//
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'sticky_header_controller.dart';
import 'sticky_header_info.dart';

/// RenderObject for StickyContainer widget.
///
/// When the page is scrolled, the [StickyHeaderController] will get the header
/// widget information through callback.
class RenderStickyContainer extends RenderProxyBox {
  StickyHeaderController? _controller;
  int index;
  bool visible;
  double? pixels;
  bool performancePriority;
  Widget widget;

  double? _pixelsCache;

  RenderStickyContainer({
    required StickyHeaderController? controller,
    required this.index,
    required this.visible,
    this.pixels,
    required this.performancePriority,
    required this.widget,
  }) : _controller = controller;

  set controller(StickyHeaderController? newController) {
    if (newController != null && _controller != newController) {
      StickyHeaderController? oldController = _controller;
      _controller = newController;
      oldController?.removeCallback(_callback);
      newController.addCallback(_callback);
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _controller?.addCallback(_callback);
  }

  @override
  void detach() {
    _controller?.removeCallback(_callback);
    super.detach();
  }

  @override
  void performLayout() {
    // Layout header widget.
    final childConstraints = constraints.loosen();
    child?.layout(childConstraints, parentUsesSize: true);
    size = child?.size ?? Size.zero;
  }

  double get _pixels {
    if (pixels != null) {
      return pixels ?? 0.0;
    } else {
      if (_pixelsCache == null || !performancePriority) {
        _pixelsCache = RenderAbstractViewport.of(this)
            ?.getOffsetToReveal(this, 0.0)
            .offset;
      }
      return _pixelsCache ?? 0.0;
    }
  }

  Offset get _offset {
    var renderObject = _controller?.scrollPosition?.context.notificationContext
        ?.findRenderObject();
    var offset = Offset.zero;
    if (renderObject?.attached ?? false) {
      offset = localToGlobal(Offset.zero, ancestor: renderObject);
    }
    return offset;
  }

  StickyHeaderInfo _callback() => StickyHeaderInfo(
        index: index,
        visible: visible,
        size: size,
        pixels: _pixels,
        offset: _offset,
        widget: widget,
      );
}
