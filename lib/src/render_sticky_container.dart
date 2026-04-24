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
  double? _pixelsCache;
  bool _isRefreshScheduled = false;

  int _index;
  bool _visible;
  double? _pixels;
  bool _performancePriority;
  int? _parentIndex;
  bool _overlapParent;
  Widget _widget;

  RenderStickyContainer({
    required StickyHeaderController? controller,
    required int index,
    required bool visible,
    double? pixels,
    required bool performancePriority,
    int? parentIndex,
    required bool overlapParent,
    required Widget widget,
  }) : _controller = controller,
        _index = index,
        _visible = visible,
        _pixels = pixels,
        _performancePriority = performancePriority,
        _parentIndex = parentIndex,
        _overlapParent = overlapParent,
        _widget = widget;

  set controller(StickyHeaderController? newController) {
    if (newController != null && _controller != newController) {
      StickyHeaderController? oldController = _controller;
      _controller = newController;
      oldController?.removeCallback(_callback);
      newController.addCallback(_callback);
      _scheduleRefresh();
    }
  }

  set index(int newValue) {
    if (_index != newValue) {
      _index = newValue;
      _pixelsCache = null;
      _scheduleRefresh();
    }
  }

  int get index => _index;

  set visible(bool newValue) {
    if (_visible != newValue) {
      _visible = newValue;
      _scheduleRefresh();
    }
  }

  bool get visible => _visible;

  set pixels(double? newValue) {
    if (_pixels != newValue) {
      _pixels = newValue;
      _pixelsCache = null;
      _scheduleRefresh();
    }
  }

  double? get pixels => _pixels;

  set performancePriority(bool newValue) {
    if (_performancePriority != newValue) {
      _performancePriority = newValue;
      _pixelsCache = null;
      _scheduleRefresh();
    }
  }

  bool get performancePriority => _performancePriority;

  set parentIndex(int? newValue) {
    if (_parentIndex != newValue) {
      _parentIndex = newValue;
      _scheduleRefresh();
    }
  }

  int? get parentIndex => _parentIndex;

  set overlapParent(bool newValue) {
    if (_overlapParent != newValue) {
      _overlapParent = newValue;
      _scheduleRefresh();
    }
  }

  bool get overlapParent => _overlapParent;

  set widget(Widget newValue) {
    if (_widget != newValue) {
      _widget = newValue;
      _scheduleRefresh();
    }
  }

  Widget get widget => _widget;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _controller?.addCallback(_callback);
    _scheduleRefresh();
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
    final oldSize = hasSize ? size : null;
    size = child?.size ?? Size.zero;
    if (oldSize != size) {
      _pixelsCache = null;
      _scheduleRefresh();
    }
  }

  double get _pixels {
    if (pixels != null) {
      return pixels ?? 0.0;
    } else {
      if (_pixelsCache == null || !performancePriority) {
        _pixelsCache =
            RenderAbstractViewport.of(this).getOffsetToReveal(this, 0.0).offset;
      }
      return _pixelsCache ?? 0.0;
    }
  }

  Offset get _offset {
    var controller = _controller;
    if (controller != null) {
      var d = _pixels - controller.currentPixels;
      return controller.isHorizontalAxis ? Offset(d, 0.0) : Offset(0.0, d);
    }
    return Offset.zero;
  }

  int? get _parentIndex =>
      (parentIndex != null && (parentIndex ?? 0) < index) ? parentIndex : null;

  StickyHeaderInfo _callback() => StickyHeaderInfo(
        index: index,
        visible: visible,
        size: size,
        pixels: _pixels,
        offset: _offset,
        parentIndex: _parentIndex,
        overlapParent: overlapParent,
        widget: widget,
      );

  void _scheduleRefresh() {
    if (_isRefreshScheduled) {
      return;
    }
    _isRefreshScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _isRefreshScheduled = false;
      _controller?.refresh();
    });
  }
}
