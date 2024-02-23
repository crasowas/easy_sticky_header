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
/// see also [animateTo].
class StickyHeaderController extends ChangeNotifier {
  ScrollPosition? _scrollPosition;
  bool _isJumping = false;
  _FindingTargetInfo? _findingTargetInfo;

  /// Cache of sticky headers information.
  ///
  /// With the help of the existing sticky header information, you can
  /// jump to the header widget of the specified index.
  final Map<int, StickyHeaderInfo> _stickyHeaderInfoMap =
      <int, StickyHeaderInfo>{};

  /// Cache of sticky header information callbacks.
  final List<StickyHeaderInfoCallback> _stickyHeaderInfoCallbackList =
      <StickyHeaderInfoCallback>[];

  /// When the value of the [useStickyAmount] property is set to true, the
  /// sticky amount of the header widget will be automatically calculated.
  ///
  /// This property is automatically set to true if [StickyContainerBuilder] is
  /// used.
  bool useStickyAmount = false;

  /// Cache of pixel values for the current scroll position
  double currentPixels = 0.0;

  /// Current sticky header information.
  ///
  /// See also:
  ///
  /// * [StickyHeaderWidget], which uses this build sticky header.
  StickyHeaderInfo? currentStickyHeaderInfo;

  /// Current child sticky header information.
  ///
  /// See also:
  ///
  /// * [StickyContainerGroupBuilder], which uses this to build parent header
  ///   widget.
  StickyHeaderInfo? currentChildStickyHeaderInfo;

  /// Current sticky header offset.
  ///
  /// See also:
  ///
  /// * [StickyHeaderWidget], which uses this to determine the sticky header
  ///   position.
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

  set isJumping(bool newValue) {
    _isJumping = newValue;
    if (!newValue) {
      _findingTargetInfo = null;
    }
  }

  bool get isJumping => _isJumping;

  bool get isReverse =>
      _scrollPosition?.axisDirection == AxisDirection.up ||
      _scrollPosition?.axisDirection == AxisDirection.left;

  bool get isHorizontalAxis => _scrollPosition?.axis == Axis.horizontal;

  double get getViewportDimension => _scrollPosition?.viewportDimension ?? 0.0;

  double get getMaxScrollExtent => _scrollPosition?.maxScrollExtent ?? 0.0;

  double get getMinScrollExtent => _scrollPosition?.minScrollExtent ?? 0.0;

  @override
  void dispose() {
    _scrollPosition?.removeListener(scrollListener);
    super.dispose();
  }

  /// Monitors scroll changes and control the position and visibility of
  /// the sticky header widget based on the scroll position.
  void scrollListener() {
    currentPixels = _scrollPosition?.pixels ?? 0.0;
    for (var callback in _stickyHeaderInfoCallbackList) {
      var stickyHeaderInfo = callback();
      _stickyHeaderInfoMap[stickyHeaderInfo.index] = stickyHeaderInfo;
    }
    var stickyHeaderInfoList = _stickyHeaderInfoMap.values.toList();
    // Sort by index.
    stickyHeaderInfoList.sort((a, b) => a.index.compareTo(b.index));
    // Clear cache.
    currentStickyHeaderInfo = null;
    currentChildStickyHeaderInfo = null;
    currentOffset = Offset.zero;
    // Find current sticky header and calculate offset.
    if (stickyHeaderInfoList.isNotEmpty &&
        _isNeedsStickyHeader(stickyHeaderInfoList)) {
      for (var i = 0; i < stickyHeaderInfoList.length; i++) {
        var stickyHeaderInfo = stickyHeaderInfoList[i];
        if (_isValidStickyHeader(stickyHeaderInfo)) {
          var parentIndex = stickyHeaderInfo.parentIndex;
          if (i == stickyHeaderInfoList.length - 1) {
            if (parentIndex != null) {
              currentStickyHeaderInfo = _stickyHeaderInfoMap[parentIndex];
              currentChildStickyHeaderInfo = stickyHeaderInfo;
            } else {
              currentStickyHeaderInfo = stickyHeaderInfo;
            }
            break;
          } else {
            var nextStickyHeaderInfo = stickyHeaderInfoList[i + 1];
            if (!_isValidStickyHeader(nextStickyHeaderInfo)) {
              if (parentIndex != null) {
                currentStickyHeaderInfo = _stickyHeaderInfoMap[parentIndex];
                currentChildStickyHeaderInfo = stickyHeaderInfo;
                if (stickyHeaderInfo.parentIndex !=
                    nextStickyHeaderInfo.parentIndex) {
                  currentOffset =
                      _calculateOffset(stickyHeaderInfo, nextStickyHeaderInfo);
                }
              } else {
                currentStickyHeaderInfo = stickyHeaderInfo;
                if (stickyHeaderInfo.index !=
                    nextStickyHeaderInfo.parentIndex) {
                  currentOffset =
                      _calculateOffset(stickyHeaderInfo, nextStickyHeaderInfo);
                }
              }
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
    _findHeaderWidget();
    // Update sticky header.
    notifyListeners();
  }

  /// In some cases sticky header is not required,
  /// e.g. scroll events triggered by [BouncingScrollPhysics].
  bool _isNeedsStickyHeader(List<StickyHeaderInfo> stickyHeaderInfoList) =>
      getComponent(stickyHeaderInfoList.first.offset) < 0;

  /// Returns true if the header widget is partially or completely invisible
  /// on the screen, false otherwise.
  ///
  /// For grouped header widgets, additional processing is required if the child
  /// header widget and parent header widget do not overlap.
  bool _isValidStickyHeader(StickyHeaderInfo stickyHeaderInfo) {
    var value = 0.0;
    var parentIndex = stickyHeaderInfo.parentIndex;
    if (parentIndex != null && !stickyHeaderInfo.overlapParent) {
      value = getDimension(getStickyHeaderInfo(parentIndex)?.size);
    }
    return getComponent(stickyHeaderInfo.offset) < value;
  }

  /// Calculates the offset at which the header widget should stuck to
  /// the starting position.
  Offset _calculateOffset(StickyHeaderInfo stickyHeaderInfo,
      StickyHeaderInfo nextStickyHeaderInfo) {
    var d = 0.0;
    // ±0.2: Which to reduce fluctuations and optimize the scrolling experience.
    if (isReverse) {
      d = getViewportDimension - getComponent(nextStickyHeaderInfo.offset);
      d = d - 0.2;
      d = max(getViewportDimension - getDimension(stickyHeaderInfo.size), d);
    } else {
      d = getComponent(nextStickyHeaderInfo.offset) -
          getDimension(stickyHeaderInfo.size);
      d = d + 0.2;
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
      var d =
          getViewportDimension - getDimension(currentStickyHeaderInfo?.size);
      currentOffset = isHorizontalAxis ? Offset(d, 0.0) : Offset(0.0, d);
    }
  }

  /// The `stickyAmount` is used to create header widget with varying styles.
  void _calculateStickyAmount(List<StickyHeaderInfo> stickyHeaderInfoList) {
    int? nextStickyHeaderIndex;
    for (var i = 0; i < stickyHeaderInfoList.length; i++) {
      var stickyHeaderInfo = stickyHeaderInfoList[i];
      var stickyAmount = 0.0;
      if (!_isValidStickyHeader(stickyHeaderInfo)) {
        var value = 0.0;
        if (stickyHeaderInfo.parentIndex != null &&
            !stickyHeaderInfo.overlapParent) {
          value = getDimension(currentStickyHeaderInfo?.size);
        }
        stickyAmount = (getComponent(stickyHeaderInfo.offset) - value) /
            getDimension(stickyHeaderInfo.size);
        stickyAmount = (1.0 - stickyAmount).clamp(0.0, 1.0);
      } else if ((currentChildStickyHeaderInfo == null &&
              stickyHeaderInfo == currentStickyHeaderInfo) ||
          stickyHeaderInfo == currentChildStickyHeaderInfo) {
        nextStickyHeaderIndex =
            i < stickyHeaderInfoList.length - 1 ? i + 1 : null;
        stickyAmount = 1.0;
      }
      stickyHeaderInfo.stickyAmount = stickyAmount;
    }
    if (nextStickyHeaderIndex != null) {
      var stickyAmount =
          stickyHeaderInfoList[nextStickyHeaderIndex].stickyAmount;
      if (currentChildStickyHeaderInfo != null) {
        currentChildStickyHeaderInfo?.stickyAmount -= stickyAmount;
      } else {
        currentStickyHeaderInfo?.stickyAmount -= stickyAmount;
      }
    }
  }

  /// Gets the horizontal or vertical component based on the scroll view's
  /// scroll axis.
  double getComponent(Offset offset) =>
      _scrollPosition?.axis == Axis.horizontal ? offset.dx : offset.dy;

  /// Gets the width or height based on scroll view's scroll axis.
  double getDimension(Size? size) {
    size ??= Size.zero;
    return _scrollPosition?.axis == Axis.horizontal ? size.width : size.height;
  }

  /// When the header widget is attached to the widget tree, which will execute
  /// this method to add its own callback to the list. When the page is
  /// scrolled, a callback will be executed to get [StickyHeaderInfo] to
  /// determine the position of [StickyHeaderWidget].
  ///
  /// See also:
  ///
  /// * [RenderStickyContainer], which automatically adds and removes callback
  ///   based on lifecycle.
  void addCallback(StickyHeaderInfoCallback callback) {
    _stickyHeaderInfoCallbackList.add(callback);
  }

  /// When the header widget is detached from the widget tree, which will
  /// execute this method to remove its own callback to the list.
  void removeCallback(StickyHeaderInfoCallback callback) {
    _stickyHeaderInfoCallbackList.remove(callback);
  }

  /// Gets sticky header information from cache.
  StickyHeaderInfo? getStickyHeaderInfo(int index) =>
      _stickyHeaderInfoMap[index];

  /// Clears the cache, please call when needed.
  void clearStickyHeaderInfo() => _stickyHeaderInfoMap.clear();

  /// Jumps to the header widget of the specified index. Compared with [jumpTo],
  /// a transition animation is added and it supports jumping to the header
  /// widget that has not yet appeared.
  ///
  /// The find operation will be performed when the header widget of the
  /// specified index has not yet appeared.
  ///
  /// The `velocity` parameter indicates how many pixels to scroll per
  /// millisecond and is used to calculate the default animation duration.
  /// This parameter has no effect if a duration is specified. The value of
  /// `velocity` must be greater than 0.0, else equal to 1.0.
  ///
  /// For a better user experience, it is recommended to set finding animation
  /// curves in pairs. For example [Curves.easeIn] and [Curves.easeOut] are a
  /// pair of animation curves that can be combined into a coherent animation
  /// curve.
  void animateTo(
    int index, {
    double offset = 0.0,
    double velocity = 1.0,
    Duration? duration,
    Curve? curve,
    Duration? findingStartDuration,
    Curve? findingStartCurve,
    Duration? findingEndDuration,
    Curve? findingEndCurve,
  }) {
    var stickyHeaderInfo = getStickyHeaderInfo(index);
    if (stickyHeaderInfo != null) {
      var pixels = min(getMaxScrollExtent, _calculatePixels(stickyHeaderInfo, offset));
      if (currentPixels != pixels) {
        isJumping = true;
        _scrollPosition?.animateTo(
          pixels,
          duration: duration ?? _getDefaultDuration(pixels, velocity),
          curve: curve ?? Curves.ease,
        );
      }
    } else {
      _findingTargetInfo = _FindingTargetInfo(
        index: index,
        offset: offset,
        velocity: velocity,
        duration: findingEndDuration,
        curve: findingEndCurve ?? Curves.easeOut,
      );
      var isForward = true;
      // Note that if [_stickyHeaderInfoMap] is empty, the current scrolling
      // widget is considered to be at the starting position. When the [reverse]
      // property of [StickyHeader] is updated, the [_stickyHeaderInfoMap] will
      // be cleared, which may cause the jump to fail.
      if (_stickyHeaderInfoMap.isNotEmpty) {
        var stickyHeaderInfoList = _stickyHeaderInfoMap.values.toList();
        stickyHeaderInfoList.sort((a, b) => a.index.compareTo(b.index));
        if (stickyHeaderInfoList.first.index > index) {
          isForward = false;
        }
      }
      var pixels = isForward ? getMaxScrollExtent : getMinScrollExtent;
      if (currentPixels != pixels) {
        isJumping = true;
        _scrollPosition?.animateTo(
          pixels,
          duration:
              findingStartDuration ?? _getDefaultDuration(pixels, velocity),
          curve: findingStartCurve ?? Curves.easeIn,
        );
      }
    }
  }

  /// Duration is calculated based on the number of pixels to scroll and
  /// the scroll velocity.
  Duration _getDefaultDuration(double pixels, double velocity) {
    if (velocity <= 0.0) {
      velocity = 1.0;
    }
    return Duration(
      milliseconds: ((pixels - currentPixels).abs() / velocity).floor(),
    );
  }

  /// Finds header widget.
  void _findHeaderWidget() {
    var target = _findingTargetInfo;
    if (target != null && getStickyHeaderInfo(target.index) != null) {
      animateTo(
        target.index,
        offset: target.offset,
        duration: target.duration,
        curve: target.curve,
      );
      _findingTargetInfo = null;
    }
  }

  /// Jumps to the header widget of the specified index.
  ///
  /// Note that this jump operation is based on the [_stickyHeaderInfoMap]
  /// cache. If the header widget information of the specified index is not
  /// in the cache, no operation will be performed and false will be returned.
  ///
  /// It is recommended to use [animateTo].
  bool jumpTo(
    int index, {
    double offset = 0.0,
  }) {
    var stickyHeaderInfo = getStickyHeaderInfo(index);
    if (stickyHeaderInfo != null) {
      var pixels = _calculatePixels(stickyHeaderInfo, offset);
      if (currentPixels != pixels) {
        _scrollPosition?.jumpTo(pixels);
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          scrollListener();
        });
      }
      return true;
    }
    return false;
  }

  /// Calculates the scroll position.
  double _calculatePixels(StickyHeaderInfo stickyHeaderInfo, double offset) {
    var pixels = stickyHeaderInfo.pixels + offset;
    var parentIndex = stickyHeaderInfo.parentIndex;
    if (parentIndex != null && !stickyHeaderInfo.overlapParent) {
      pixels -= getDimension(getStickyHeaderInfo(parentIndex)?.size);
    }
    return pixels;
  }
}

/// Finding Target Info.
class _FindingTargetInfo {
  int index;
  double offset;
  double velocity;
  Duration? duration;
  Curve? curve;

  _FindingTargetInfo({
    required this.index,
    required this.offset,
    required this.velocity,
    this.duration,
    this.curve,
  });
}
