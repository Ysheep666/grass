// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

const Duration _bottomSheetDuration = Duration(milliseconds: 150);
const double _minFlingVelocity = 500.0;
const double _closeProgressThreshold = 0.5;
const double _willPopThreshold = 0.8;

typedef ScrollWidgetBuilder = Widget Function(BuildContext context, ScrollController controller);

typedef WidgetWithChildBuilder = Widget Function(BuildContext context, Animation<double> animation, Widget child);

/// A custom bottom sheet.
///
/// The [ModalBottomSheet] widget itself is rarely used directly. Instead, prefer to
/// create a modal bottom sheet with [showMaterialModalBottomSheet].
///
/// See also:
///
///  * [showMaterialModalBottomSheet] which can be used to display a modal bottom
///    sheet with Material appareance.
///  * [showCupertinoModalBottomSheet] which can be used to display a modal bottom
///    sheet with Cupertino appareance.
class ModalBottomSheet extends StatefulWidget {
  /// Creates a bottom sheet.
  const ModalBottomSheet({
    Key key,
    this.animationController,
    this.enableDrag = true,
    this.containerBuilder,
    this.bounce = true,
    this.shouldClose,
    this.scrollController,
    this.expanded,
    @required this.onClosing,
    @required this.builder,
  })  : assert(enableDrag != null),
        assert(onClosing != null),
        assert(builder != null),
        super(key: key);

  /// The animation controller that controls the bottom sheet's entrance and
  /// exit animations.
  ///
  /// The BottomSheet widget will manipulate the position of this animation, it
  /// is not just a passive observer.
  final AnimationController animationController;

  /// Allows the bottom sheet to  go beyond the top bound of the content,
  /// but then bounce the content back to the edge of
  /// the top bound.
  final bool bounce;

  final bool expanded;

  final WidgetWithChildBuilder containerBuilder;

  /// Called when the bottom sheet begins to close.
  ///
  /// A bottom sheet might be prevented from closing (e.g., by user
  /// interaction) even after this callback is called. For this reason, this
  /// callback might be call multiple times for a given bottom sheet.
  final Function() onClosing;

  // If shouldClose is null is ignored.
  // If returns true => The dialog closes
  // If returns false => The dialog cancels close
  // Notice that if shouldClose is not null, the dialog will go back to the
  // previous position until the function is solved
  final Future<bool> Function() shouldClose;

  /// A builder for the contents of the sheet.
  ///
  final ScrollWidgetBuilder builder;

  /// If true, the bottom sheet can be dragged up and down and dismissed by
  /// swiping downwards.
  ///
  /// Default is true.
  final bool enableDrag;

  final ScrollController scrollController;

  @override
  _ModalBottomSheetState createState() => _ModalBottomSheetState();

  /// Creates an [AnimationController] suitable for a
  /// [ModalBottomSheet.animationController].
  ///
  /// This API available as a convenience for a Material compliant bottom sheet
  /// animation. If alternative animation durations are required, a different
  /// animation controller could be provided.
  static AnimationController createAnimationController(TickerProvider vsync) {
    return AnimationController(
      duration: _bottomSheetDuration,
      debugLabel: 'BottomSheet',
      vsync: vsync,
    );
  }
}

class _ModalBottomSheetState extends State<ModalBottomSheet> with TickerProviderStateMixin {
  final GlobalKey _childKey = GlobalKey(debugLabel: 'BottomSheet child');

  ScrollController _scrollController;

  AnimationController _bounceDragController;

  double get _childHeight {
    final renderBox = _childKey.currentContext.findRenderObject() as RenderBox;
    return renderBox.size.height;
  }

  bool get _dismissUnderway =>
      widget.animationController.status == AnimationStatus.reverse;

  // Detect if user is dragging.
  // Used on NotificationListener to detect if ScrollNotifications are
  // before or after the user stop dragging
  bool isDragging = false;

  bool get hasReachedWillPopThreshold =>
      widget.animationController.value < _willPopThreshold;

  bool get hasReachedCloseThreshold =>
      widget.animationController.value < _closeProgressThreshold;

  void _close() {
    isDragging = false;
    widget.onClosing();
  }

  void _cancelClose() {
    widget.animationController.forward().then((value) {
      // When using WillPop, animation doesn't end at 1.
      // Check more in detail the problem
      if (!widget.animationController.isCompleted) {
        widget.animationController.value = 1;
      }
    });
    _bounceDragController.reverse();
  }

  bool _isCheckingShouldClose = false;

  FutureOr<bool> shouldClose() async {
    if (_isCheckingShouldClose) return false;
    if (widget.shouldClose == null) return null;
    _isCheckingShouldClose = true;
    final result = await widget.shouldClose();
    _isCheckingShouldClose = false;
    return result;
  }

  void _handleDragUpdate(double primaryDelta) async {
    assert(widget.enableDrag, 'Dragging is disabled');

    if (_dismissUnderway) return;
    isDragging = true;

    final progress = primaryDelta / (_childHeight ?? primaryDelta);

    if (widget.shouldClose != null && hasReachedWillPopThreshold) {
      _cancelClose();
      final canClose = await shouldClose();
      if (canClose) {
        _close();
        return;
      } else {
        _cancelClose();
      }
    }

    // Bounce top
    final bounce = widget.bounce == true;
    final shouldBounce = _bounceDragController.value > 0;
    final isBouncing = (widget.animationController.value - progress) > 1;
    if (bounce && (shouldBounce || isBouncing)) {
      _bounceDragController.value -= progress * 10;
      return;
    }

    widget.animationController.value -= progress;
  }

  void _handleDragEnd(double velocity) async {
    assert(widget.enableDrag, 'Dragging is disabled');

    if (_dismissUnderway || !isDragging) return;
    isDragging = false;
    _bounceDragController.reverse();

    var canClose = true;
    if (widget.shouldClose != null && hasReachedWillPopThreshold) {
      _cancelClose();
      canClose = await shouldClose();
    }
    if (canClose) {
      // If speed is bigger than _minFlingVelocity try to close it
      if (velocity > _minFlingVelocity) {
        _close();
      } else if (hasReachedCloseThreshold) {
        if (widget.animationController.value > 0.0) {
          widget.animationController.fling(velocity: -1.0);
        }
        _close();
      } else {
        _cancelClose();
      }
    } else {
      _cancelClose();
    }
  }


  // As we cannot access the dragGesture detector of the scroll view
  // we can not know the DragDownDetails and therefore the end velocity.
  // VelocityTracker it is used to calculate the end velocity  of the scroll
  // when user is trying to close the modal by dragging
  VelocityTracker _velocityTracker;
  DateTime _startTime;

  void _handleScrollUpdate(ScrollNotification notification) {
    if (notification.metrics.pixels <= notification.metrics.minScrollExtent) {
      //Check if listener is same from scrollController
      if (!_scrollController.hasClients) return;

      if (_scrollController.position.pixels != notification.metrics.pixels) {
        return;
      }
      DragUpdateDetails dragDetails;
      if (notification is ScrollStartNotification) {
        _velocityTracker = VelocityTracker();
        _startTime = DateTime.now();
      }
      if (notification is ScrollUpdateNotification) {
        dragDetails = notification.dragDetails;
      }
      if (notification is OverscrollNotification) {
        dragDetails = notification.dragDetails;
      }
      if (dragDetails != null) {
        final duration = _startTime.difference(DateTime.now());
        final offset = Offset(0, _scrollController.offset);
        _velocityTracker.addPosition(duration, offset);
        _handleDragUpdate(dragDetails.primaryDelta);
      }
      else if (isDragging) {
        final velocity = _velocityTracker.getVelocity().pixelsPerSecond.dy;
        _handleDragEnd(velocity);
      }
    }
  }

  @override
  void initState() {
    _bounceDragController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _scrollController = widget.scrollController ?? ScrollController();
    // Todo: Check if we can remove scroll Controller
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bounceAnimation = CurvedAnimation(
      parent: _bounceDragController,
      curve: Curves.easeOutSine,
    );

    var child = widget.builder(context, _scrollController);

    if (widget.containerBuilder != null) {
      child = widget.containerBuilder(
        context,
        widget.animationController,
        child,
      );
    }

    // Todo: Add curved Animation when push and pop without gesture
    /* final Animation<double> containerAnimation = CurvedAnimation(
      parent: widget.animationController,
      curve: Curves.easeOut,
    );*/

    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (context, _) => ClipRect(
        child: CustomSingleChildLayout(
          delegate: _ModalBottomSheetLayout(
              widget.animationController.value, widget.expanded),
          child: !widget.enableDrag
              ? child
              : KeyedSubtree(
                  key: _childKey,
                  child: AnimatedBuilder(
                    animation: bounceAnimation,
                    builder: (context, _) => CustomSingleChildLayout(
                      delegate: _CustomBottomSheetLayout(bounceAnimation.value),
                      child: GestureDetector(
                        onVerticalDragUpdate: (details) =>
                            _handleDragUpdate(details.primaryDelta),
                        onVerticalDragEnd: (details) =>
                            _handleDragEnd(details.primaryVelocity),
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification notification) {
                            _handleScrollUpdate(notification);
                            return false;
                          },
                          child: child,
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class _ModalBottomSheetLayout extends SingleChildLayoutDelegate {
  _ModalBottomSheetLayout(this.progress, this.expand);

  final double progress;
  final bool expand;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth: constraints.maxWidth,
      maxWidth: constraints.maxWidth,
      minHeight: expand ? constraints.maxHeight : 0,
      maxHeight: expand ? constraints.maxHeight : constraints.minHeight,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(0.0, size.height - childSize.height * progress);
  }

  @override
  bool shouldRelayout(_ModalBottomSheetLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}

class _CustomBottomSheetLayout extends SingleChildLayoutDelegate {
  _CustomBottomSheetLayout(this.progress);

  final double progress;
  double childHeight;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth: constraints.maxWidth,
      maxWidth: constraints.maxWidth,
      minHeight: constraints.minHeight,
      maxHeight: constraints.maxHeight + progress * 8,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    childHeight ??= childSize.height;
    return Offset(0.0, size.height - childSize.height);
  }

  @override
  bool shouldRelayout(_CustomBottomSheetLayout oldDelegate) {
    if (progress != oldDelegate.progress) {
      childHeight = oldDelegate.childHeight;
      return true;
    }
    return false;
  }
}

class _CustomModalBottomSheet<T> extends StatefulWidget {
  const _CustomModalBottomSheet({
    Key key,
    this.route,
    this.secondAnimationController,
    this.bounce = false,
    this.scrollController,
    this.expanded = false,
    this.enableDrag = true,
  })  : assert(expanded != null),
        assert(enableDrag != null),
        super(key: key);

  final ModalBottomSheetRoute<T> route;
  final bool expanded;
  final bool bounce;
  final bool enableDrag;
  final AnimationController secondAnimationController;
  final ScrollController scrollController;

  @override
  _CustomModalBottomSheetState<T> createState() => _CustomModalBottomSheetState<T>();
}

class _CustomModalBottomSheetState<T> extends State<_CustomModalBottomSheet<T>> {
  String _getRouteLabel() {
    final platform = Theme.of(context)?.platform ?? defaultTargetPlatform;
    switch (platform) {
      case TargetPlatform.iOS:
        return '';
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        if (Localizations.of(context, MaterialLocalizations) != null) {
          return MaterialLocalizations.of(context).dialogLabel;
        }
        return DefaultMaterialLocalizations().dialogLabel;
      default:
        break;
    }
    return null;
  }

  @override
  void initState() {
    widget.route.animation.addListener(updateController);
    super.initState();
  }

  @override
  void dispose() {
    widget.route.animation.removeListener(updateController);
    super.dispose();
  }

  void updateController() {
    widget.secondAnimationController?.value = widget.route.animation.value;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));

    return AnimatedBuilder(
      animation: widget.route._animationController,
      builder: (BuildContext context, Widget child) {
        // Disable the initial animation when accessible navigation is on so
        // that the semantics are added to the tree at the correct time.
        return Semantics(
          scopesRoute: true,
          namesRoute: true,
          label: _getRouteLabel(),
          explicitChildNodes: true,
          child: ModalBottomSheet(
            expanded: widget.route.expanded,
            containerBuilder: widget.route.containerBuilder,
            animationController: widget.route._animationController,
            shouldClose: widget.route._hasScopedWillPopCallback
                ? () async {
                    final willPop = await widget.route.willPop();
                    return willPop != RoutePopDisposition.doNotPop;
                  }
                : null,
            onClosing: () {
              if (widget.route.isCurrent) {
                Navigator.of(context).pop();
              }
            },
            builder: widget.route.builder,
            enableDrag: widget.enableDrag,
            bounce: widget.bounce,
          ),
        );
      },
    );
  }
}

class ModalBottomSheetRoute<T> extends PopupRoute<T> {
  ModalBottomSheetRoute({
    this.containerBuilder,
    this.builder,
    this.scrollController,
    this.barrierLabel,
    this.secondAnimationController,
    this.modalBarrierColor,
    this.isDismissible = true,
    this.enableDrag = true,
    @required this.expanded,
    this.bounce = false,
    RouteSettings settings,
  })  : assert(expanded != null),
        assert(isDismissible != null),
        assert(enableDrag != null),
        super(settings: settings);

  final WidgetWithChildBuilder containerBuilder;
  final ScrollWidgetBuilder builder;
  final bool expanded;
  final bool bounce;
  final Color modalBarrierColor;
  final bool isDismissible;
  final bool enableDrag;
  final ScrollController scrollController;

  final AnimationController secondAnimationController;

  @override
  Duration get transitionDuration => _bottomSheetDuration;

  @override
  bool get barrierDismissible => isDismissible;

  @override
  final String barrierLabel;

  @override
  Color get barrierColor => modalBarrierColor ?? Colors.black.withOpacity(0.3);

  AnimationController _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController = ModalBottomSheet.createAnimationController(navigator.overlay);
    return _animationController;
  }

  bool get _hasScopedWillPopCallback => hasScopedWillPopCallback;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    // By definition, the bottom sheet is aligned to the bottom of the page
    // and isn't exposed to the top padding of the MediaQuery.
    Widget bottomSheet = MediaQuery.removePadding(
      context: context,
      // removeTop: true,
      child: _CustomModalBottomSheet<T>(
        route: this,
        secondAnimationController: secondAnimationController,
        expanded: expanded,
        scrollController: scrollController,
        bounce: bounce,
        enableDrag: enableDrag,
      ),
    );
    return bottomSheet;
  }

  @override
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) =>
      nextRoute is ModalBottomSheetRoute;

  @override
  bool canTransitionFrom(TransitionRoute<dynamic> previousRoute) =>
      previousRoute is ModalBottomSheetRoute || previousRoute is PageRoute;

  Widget getPreviousRouteTransition(
    BuildContext context,
    Animation<double> secondAnimation,
    Widget child,
  ) {
    return child;
  }
}

/// Shows a modal material design bottom sheet.
Future<T> showCustomModalBottomSheet<T>(
    {@required BuildContext context,
    @required ScrollWidgetBuilder builder,
    @required WidgetWithChildBuilder containerWidget,
    Color backgroundColor,
    double elevation,
    ShapeBorder shape,
    Clip clipBehavior,
    Color barrierColor,
    bool bounce = false,
    bool expand = false,
    AnimationController secondAnimation,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
    ScrollController scrollController}) async {
  assert(context != null);
  assert(builder != null);
  assert(containerWidget != null);
  assert(expand != null);
  assert(useRootNavigator != null);
  assert(isDismissible != null);
  assert(enableDrag != null);
  assert(debugCheckHasMediaQuery(context));
  assert(debugCheckHasMaterialLocalizations(context));
  final result = await Navigator.of(context, rootNavigator: useRootNavigator)
      .push(ModalBottomSheetRoute<T>(
    builder: builder,
    bounce: bounce,
    containerBuilder: containerWidget,
    secondAnimationController: secondAnimation,
    expanded: expand,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    isDismissible: isDismissible,
    modalBarrierColor: barrierColor,
    enableDrag: enableDrag,
  ));
  return result;
}

