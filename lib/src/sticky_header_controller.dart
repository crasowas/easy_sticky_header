// Copyright (c) 2022, crasowas.
//
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:math' show min, max;

import 'package:flutter/material.dart';

import 'sticky_header_info.dart';

/// When the page is scrolled, information such as the position of the sticky
/// header widget will be obtained through this callback.
typedef StickyHeaderInfoCallback = StickyHeaderInfo Function();

/// Sticky Header Controller.
///
/// [StickyHeaderController] is the core of the library, its main feature is to
/// monitor the scroll changes and calculate the sticky header. In addition to
/// this, it also supports jumping the header widget of the specified index,
/// see also [jumpTo].
class StickyHeaderController extends ChangeNotifier {
  ScrollPosition? _scrollPosition;
  bool useDefaultScrollPosition = true;

  /// If [StickyContainerBuilder] is not used, the sticky amount
  /// is not calculated by default.
  bool useStickyAmount = false;

  /// Cache of sticky headers information.
  ///
  /// With the help of the existing sticky header information, you can
  /// jump to the header widget of the specified index.
  final Map<int, StickyHeaderInfo> _stickyHeaderInfoMap =
      <int, StickyHeaderInfo>{};

  /// Cache of sticky header information callbacks.
  final List<StickyHeaderInfoCallback> _stickyHeaderCallbackList =
      <StickyHeaderInfoCallback>[];

  double currentPixels = 0.0;

  /// Current sticky header information.
  ///
  /// See also:
  ///
  /// * [StickyHeaderWidget], which use this build widget.
  StickyHeaderInfo? currentStickyHeaderInfo;

  /// Current sticky header offset.
  ///
  /// See also:
  ///
  /// * [StickyHeaderWidget], which use this to determine the widget position.
  Offset currentOffset = Offset.zero;

  set scrollPosition(ScrollPosition? newScrollPosition) {
    if (newScrollPosition != null && _scrollPosition != newScrollPosition) {
      ScrollPosition? oldScrollPosition = _scrollPosition;
      _scrollPosition = newScrollPosition;
      oldScrollPosition?.removeListener(scrollListener);
      newScrollPosition.addListener(scrollListener);
    }
  }

  ScrollPosition? get scrollPosition => _scrollPosition;

  bool get isReverse =>
      _scrollPosition?.axisDirection == AxisDirection.up ||
      _scrollPosition?.axisDirection == AxisDirection.left;

  bool get isHorizontalAxis => _scrollPosition?.axis == Axis.horizontal;

  double get getViewportDimension => _scrollPosition?.viewportDimension ?? 0.0;

  @override
  void dispose() {
    _scrollPosition?.removeListener(scrollListener);
    super.dispose();
  }

  /// Monitor scroll changes and control the position and visibility of
  /// the sticky header widget based on the scroll position.
  void scrollListener() {
    currentPixels = _scrollPosition?.pixels ?? 0.0;
    for (var callback in _stickyHeaderCallbackList) {
      var stickyHeaderInfo = callback();
      _correctOffset(stickyHeaderInfo);
      _stickyHeaderInfoMap[stickyHeaderInfo.index] = stickyHeaderInfo;
    }
    var stickyHeaderInfoList = _stickyHeaderInfoMap.values.toList();
    // Sort by index.
    stickyHeaderInfoList.sort((a, b) => a.index.compareTo(b.index));
    // Clear cache.
    currentStickyHeaderInfo = null;
    currentOffset = Offset.zero;
    // Find current sticky header and calculate offset.
    if (stickyHeaderInfoList.isNotEmpty &&
        _isNeedStickyHeader(stickyHeaderInfoList)) {
      for (var i = 0; i < stickyHeaderInfoList.length; i++) {
        var stickyHeaderInfo = stickyHeaderInfoList[i];
        if (_isValidStickyHeader(stickyHeaderInfo)) {
          if (i == stickyHeaderInfoList.length - 1) {
            currentStickyHeaderInfo = stickyHeaderInfo;
            break;
          } else {
            if (!_isValidStickyHeader(stickyHeaderInfoList[i + 1])) {
              currentStickyHeaderInfo = stickyHeaderInfo;
              currentOffset = _calculateOffset(
                  stickyHeaderInfo, stickyHeaderInfoList[i + 1]);
              break;
            }
          }
        }
      }
    }
    _handleReverse();
    if (useStickyAmount) {
      _calculateStickyAmount(stickyHeaderInfoList);
    }
    // Update sticky header.
    notifyListeners();
  }

  /// Correct the deviation of offset.
  ///
  /// If left untreated, the sticky header widget and the header widget
  /// will not fit together, and there will be gaps between the two, especially
  /// when scrolling quickly and repeatedly.
  void _correctOffset(StickyHeaderInfo stickyHeaderInfo) {
    double deviation = 0.0;
    if (isReverse) {
      deviation =
          (stickyHeaderInfo.pixels + getDimension(stickyHeaderInfo.size)) +
              getComponent(stickyHeaderInfo.offset) -
              currentPixels -
              getViewportDimension;
    } else {
      deviation = currentPixels +
          getComponent(stickyHeaderInfo.offset) -
          stickyHeaderInfo.pixels;
    }
    stickyHeaderInfo.offset -=
        isHorizontalAxis ? Offset(deviation, 0.0) : Offset(0.0, deviation);
  }

  /// In some cases sticky header is not required,
  /// e.g. scroll events triggered by [BouncingScrollPhysics].
  bool _isNeedStickyHeader(List<StickyHeaderInfo> stickyHeaderInfoList) =>
      isReverse
          ? currentPixels > 0
          : getComponent(stickyHeaderInfoList.first.offset) < 0;

  /// Returns true if the header widget is partially or completely invisible
  /// on the screen, false otherwise.
  ///
  /// * For scrolling widget in the normal scrolling direction,
  ///   determine whether the horizontal or vertical component of
  ///   the offset of the header widget is less than 0.0.
  ///
  /// * For scrolling widget that reverse the scrolling direction,
  ///   determine whether the header widget is partially or completely
  ///   outside the [viewportDimension] range.
  bool _isValidStickyHeader(StickyHeaderInfo stickyHeaderInfo) {
    if (isReverse) {
      return (getViewportDimension -
              getDimension(stickyHeaderInfo.size) -
              getComponent(stickyHeaderInfo.offset)) <
          0.0;
    } else {
      return getComponent(stickyHeaderInfo.offset) < 0.0;
    }
  }

  /// Calculate the offset at which the header widget should stuck to
  /// the starting position.
  Offset _calculateOffset(StickyHeaderInfo stickyHeaderInfo,
      StickyHeaderInfo nextStickyHeaderInfo) {
    var d = 0.0;
    // ±0.1: Which to reduce fluctuations and optimize the scrolling experience.
    if (isReverse) {
      d = getComponent(nextStickyHeaderInfo.offset) +
          getDimension(nextStickyHeaderInfo.size);
      d = d - 0.1;
      d = max(getViewportDimension - getDimension(stickyHeaderInfo.size), d);
    } else {
      d = getComponent(nextStickyHeaderInfo.offset) -
          getDimension(stickyHeaderInfo.size);
      d = d + 0.1;
      d = min(0.0, d);
    }
    return isHorizontalAxis ? Offset(d, 0.0) : Offset(0.0, d);
  }

  /// When the scroll direction is reversed, the default offset cannot be zero,
  /// and additional processing is required.
  void _handleReverse() {
    if (isReverse &&
        currentStickyHeaderInfo != null &&
        currentOffset == Offset.zero) {
      var d = getViewportDimension -
          getDimension(currentStickyHeaderInfo?.size ?? Size.zero);
      currentOffset = isHorizontalAxis ? Offset(d, 0.0) : Offset(0.0, d);
    }
  }

  /// [stickyAmount] is used to create header widget with varying styles.
  void _calculateStickyAmount(List<StickyHeaderInfo> stickyHeaderInfoList) {
    int? nextStickyHeaderIndex;
    for (var i = 0; i < stickyHeaderInfoList.length; i++) {
      var stickyHeaderInfo = stickyHeaderInfoList[i];
      var stickyAmount = 0.0;
      if (!_isValidStickyHeader(stickyHeaderInfo)) {
        if (isReverse) {
          stickyAmount = (getViewportDimension -
                  getComponent(stickyHeaderInfo.offset) -
                  getDimension(stickyHeaderInfo.size)) /
              getDimension(stickyHeaderInfo.size);
        } else {
          stickyAmount = getComponent(stickyHeaderInfo.offset) /
              getDimension(stickyHeaderInfo.size);
        }
        stickyAmount = (1.0 - stickyAmount).clamp(0.0, 1.0);
      } else if (stickyHeaderInfo == currentStickyHeaderInfo) {
        nextStickyHeaderIndex =
            i < stickyHeaderInfoList.length - 1 ? i + 1 : null;
        stickyAmount = 1.0;
      }
      stickyHeaderInfo.stickyAmount = stickyAmount;
    }
    if (nextStickyHeaderIndex != null) {
      currentStickyHeaderInfo?.stickyAmount -=
          stickyHeaderInfoList[nextStickyHeaderIndex].stickyAmount;
    }
  }

  /// Gets the horizontal or vertical component based on the scroll view's
  /// scroll axis.
  double getComponent(Offset offset) =>
      _scrollPosition?.axis == Axis.horizontal ? offset.dx : offset.dy;

  /// Gets the width or height based on scroll view's scroll axis.
  double getDimension(Size size) =>
      _scrollPosition?.axis == Axis.horizontal ? size.width : size.height;

  /// When the header widget is attached to the widget tree, which will execute
  /// this method to add its own callback to the list. When the page is
  /// scrolled, a callback will be executed to get [StickyHeaderInfo] to
  /// determine the position of [StickyHeaderWidget].
  ///
  /// See also:
  ///
  /// * [RenderStickyContainer], which automatically add and remove callback
  ///   based on lifecycle.
  void addCallback(StickyHeaderInfoCallback callback) {
    _stickyHeaderCallbackList.add(callback);
  }

  /// When the header widget is detached from the widget tree, which will
  /// execute this method to remove its own callback to the list.
  void removeCallback(StickyHeaderInfoCallback callback) {
    _stickyHeaderCallbackList.remove(callback);
  }

  /// Gets sticky header information from cache.
  StickyHeaderInfo? getStickyHeaderInfo(int index) =>
      _stickyHeaderInfoMap[index];

  /// Usually no need to call, this is called to avoid problems in some cases.
  void clearStickyHeaderInfo() => _stickyHeaderInfoMap.clear();

  /// Jump to the header widget of the specified index.
  ///
  /// Note that this jump operation is based on the [_stickyHeaderInfoMap]
  /// cache. If the header widget information of the specified index is not
  /// in the cache, no operation will be performed and false will be returned.
  bool jumpTo(int index) {
    var stickyHeaderInfo = _stickyHeaderInfoMap[index];
    if (stickyHeaderInfo != null) {
      _scrollPosition?.jumpTo(stickyHeaderInfo.pixels);
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        scrollListener();
      });
      return true;
    }
    return false;
  }
}
