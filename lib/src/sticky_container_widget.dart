// Copyright (c) 2022, crasowas.
//
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'render_sticky_container.dart';
import 'sticky_header.dart';
import 'sticky_header_controller.dart';

/// Building header widget by sticky amount.
///
/// [stickyAmount] value in the range of 0.0 to 1.0.
///
/// When the value of [stickyAmount] grows from 0.0 to 1.0, the header widget
/// is about to become a sticky header. When the value of [stickyAmount] value
/// is reduced from 1.0 to 0.0, the header widget is about to stop being a
/// sticky header. In other cases, the value of [stickyAmount] is 0.0.
typedef HeaderWidgetBuilder = Widget Function(
    BuildContext context, double stickyAmount);

/// Sticky Container widget.
///
/// Wrap a header widget with this widget to make the sticky effect take effect.
class StickyContainerWidget extends SingleChildRenderObjectWidget {
  /// Index of the header widget, require unique index
  final int index;

  /// If visible is false, the header widget will not be visible
  /// when it is the current sticky header widget.
  ///
  /// The use of this property is that non-sticky header widgets
  /// can be inserted between header widgets.
  final bool visible;

  const StickyContainerWidget({
    Key? key,
    required this.index,
    this.visible = true,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  RenderStickyContainer createRenderObject(BuildContext context) {
    return RenderStickyContainer(
      controller: _getController(context),
      index: index,
      visible: visible,
      widget: child ?? Container(),
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderStickyContainer renderObject) {
    renderObject
      ..controller = _getController(context)
      ..index = index
      ..visible = visible
      ..widget = child ?? Container();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<int>('index', index, defaultValue: 0));
    properties
        .add(DiagnosticsProperty<bool>('visible', visible, defaultValue: true));
  }

  StickyHeaderController? _getController(BuildContext context) {
    var controller = StickyHeader.of(context);
    assert(
        controller != null,
        'Sticky header controller instance must not be null, '
        'confirm whether to use [StickyHeader] to wrap the widget.');
    if (controller?.useDefaultScrollPosition == true) {
      var scrollPosition = Scrollable.of(context)?.position;
      assert(
          scrollPosition != null, 'Scroll position instance must not be null.');
      if (scrollPosition != null &&
          controller?.scrollPosition != scrollPosition) {
        controller?.scrollPosition = scrollPosition;
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          controller?.scrollListener();
        });
      }
    }
    return controller;
  }
}

/// Sticky Container Builder.
///
/// An extension of [StickyContainerWidget] that supports building
/// header widget through a [builder].
class StickyContainerBuilder extends StatefulWidget {
  final int index;

  final bool visible;

  final HeaderWidgetBuilder builder;

  const StickyContainerBuilder({
    Key? key,
    required this.index,
    this.visible = true,
    required this.builder,
  }) : super(key: key);

  @override
  State<StickyContainerBuilder> createState() => _StickyContainerBuilderState();
}

class _StickyContainerBuilderState extends State<StickyContainerBuilder> {
  StickyHeaderController? _controller;
  double _stickyAmount = 0.0;

  @override
  void dispose() {
    _controller?.removeListener(_update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var controller = StickyHeader.of(context);
    assert(
        controller != null,
        'Sticky header controller instance must not be null, '
        'confirm whether to use [StickyHeader] to wrap the widget.');
    if (controller != null && _controller != controller) {
      controller.useStickyAmount = true;
      _controller?.removeListener(_update);
      _controller = controller;
      _controller?.addListener(_update);
    }
    return StickyContainerWidget(
      index: widget.index,
      visible: widget.visible,
      child: widget.builder(context, _stickyAmount),
    );
  }

  void _update() {
    var stickyAmount =
        _controller?.getStickyHeaderInfo(widget.index)?.stickyAmount ?? 0.0;
    if (stickyAmount != _stickyAmount) {
      _stickyAmount = stickyAmount;
      setState(() {});
    }
  }
}
