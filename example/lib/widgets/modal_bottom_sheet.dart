/*
 Copyright 2018 Square Inc.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
*/
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const Duration _kBottomSheetDuration = Duration(milliseconds: 200);
const double _kMinFlingVelocity = 700.0;
const double _kCloseProgressThreshold = 0.5;

class BottomSheet extends StatefulWidget {
  const BottomSheet({
    Key? key,
    this.animationController,
    this.enableDrag = true,
    required this.onClosing,
    required this.builder,
  }) : super(key: key);

  final AnimationController? animationController;
  final VoidCallback onClosing;
  final WidgetBuilder builder;
  final bool enableDrag;

  @override
  _BottomSheetState createState() => _BottomSheetState();

  static AnimationController createAnimationController(TickerProvider vsync) =>
      AnimationController(
        duration: _kBottomSheetDuration,
        debugLabel: 'BottomSheet',
        vsync: vsync,
      );
}

class _BottomSheetState extends State<BottomSheet> {
  final GlobalKey _childKey = GlobalKey(debugLabel: 'BottomSheet child');

  double get _childHeight {
    final renderBox = _childKey.currentContext!.findRenderObject() as RenderBox;
    return renderBox.size.height;
  }

  bool get _dismissUnderway =>
      widget.animationController!.status == AnimationStatus.reverse;

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_dismissUnderway) return;
    widget.animationController!.value -= details.primaryDelta! / (_childHeight);
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_dismissUnderway) return;
    if (details.velocity.pixelsPerSecond.dy > _kMinFlingVelocity) {
      final flingVelocity = -details.velocity.pixelsPerSecond.dy / _childHeight;
      if (widget.animationController!.value > 0.0) {
        widget.animationController!.fling(velocity: flingVelocity);
      }
      if (flingVelocity < 0.0) widget.onClosing();
    } else if (widget.animationController!.value < _kCloseProgressThreshold) {
      if (widget.animationController!.value > 0.0) {
        widget.animationController!.fling(velocity: -1.0);
      }
      widget.onClosing();
    } else {
      widget.animationController!.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget bottomSheet = Material(
      key: _childKey,
      child: widget.builder(context),
    );
    return !widget.enableDrag
        ? bottomSheet
        : GestureDetector(
            onVerticalDragUpdate: _handleDragUpdate,
            onVerticalDragEnd: _handleDragEnd,
            child: bottomSheet,
            excludeFromSemantics: true,
          );
  }
}

class _ModalBottomSheetLayout extends SingleChildLayoutDelegate {
  _ModalBottomSheetLayout(this.progress);

  final double progress;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      BoxConstraints(
        minWidth: constraints.maxWidth,
        maxWidth: constraints.maxWidth,
        minHeight: 0.0,
      );

  @override
  Offset getPositionForChild(Size size, Size childSize) =>
      Offset(0.0, size.height - childSize.height * progress);

  @override
  bool shouldRelayout(_ModalBottomSheetLayout oldDelegate) =>
      progress != oldDelegate.progress;
}

class _ModalBottomSheet<T> extends StatefulWidget {
  const _ModalBottomSheet({Key? key, this.route}) : super(key: key);

  final _ModalBottomSheetRoute<T>? route;

  @override
  _ModalBottomSheetState<T> createState() => _ModalBottomSheetState<T>();
}

class _ModalBottomSheetState<T> extends State<_ModalBottomSheet<T>> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final localizations = MaterialLocalizations.of(context);
    String? routeLabel;
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        routeLabel = '';
        break;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        routeLabel = localizations.dialogLabel;
        break;
      case TargetPlatform.linux:
        throw UnimplementedError();
      case TargetPlatform.macOS:
        throw UnimplementedError();
      case TargetPlatform.windows:
        throw UnimplementedError();
    }

    return GestureDetector(
      excludeFromSemantics: true,
      onTap: () => Navigator.pop(context),
      child: AnimatedBuilder(
        animation: widget.route!.animation!,
        builder: (context, child) {
          final animationValue = mediaQuery.accessibleNavigation
              ? 1.0
              : widget.route!.animation!.value;
          return Semantics(
            scopesRoute: true,
            namesRoute: true,
            label: routeLabel,
            explicitChildNodes: true,
            child: ClipRect(
              child: CustomSingleChildLayout(
                delegate: _ModalBottomSheetLayout(animationValue),
                child: BottomSheet(
                  animationController: widget.route!._animationController,
                  onClosing: () => Navigator.pop(context),
                  builder: widget.route!.builder!,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ModalBottomSheetRoute<T> extends PopupRoute<T> {
  _ModalBottomSheetRoute({
    this.builder,
    this.theme,
    this.barrierLabel,
    RouteSettings? settings,
  }) : super(settings: settings);

  final WidgetBuilder? builder;
  final ThemeData? theme;

  @override
  Duration get transitionDuration => _kBottomSheetDuration;

  @override
  bool get barrierDismissible => true;

  @override
  final String? barrierLabel;

  @override
  Color get barrierColor => Colors.black54;

  AnimationController? _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController = BottomSheet.createAnimationController(
      navigator!.overlay!,
    );
    return _animationController!;
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    // By definition, the bottom sheet is aligned to the bottom of the page
    // and isn't exposed to the top padding of the MediaQuery.
    Widget bottomSheet = MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: _ModalBottomSheet<T>(route: this),
    );
    if (theme != null) bottomSheet = Theme(data: theme!, child: bottomSheet);
    return bottomSheet;
  }
}

Future<T?> showModalBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  assert(debugCheckHasMaterialLocalizations(context));
  return Navigator.push(
    context,
    _ModalBottomSheetRoute<T>(
      builder: builder,
      theme: Theme.of(context), //, shadowThemeOnly: true),
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    ),
  );
}

PersistentBottomSheetController showMyBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) => Scaffold.of(context).showBottomSheet(builder);
