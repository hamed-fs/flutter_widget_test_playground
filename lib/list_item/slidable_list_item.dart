import 'package:flutter/material.dart';

/// Slidable list item widget
class SlidableListItem extends StatefulWidget {
  /// Slidable list item widget
  ///
  /// This widget enables actions in swipe [child]
  /// [actions] is a list of widgets that will be shown on swipe left.
  const SlidableListItem({
    @required this.child,
    Key key,
    this.actions,
  }) : super(key: key);

  /// List item widget
  final Widget child;

  /// Actions list
  ///
  ///  Default value is an empty widget list
  final List<Widget> actions;

  @override
  _SlidableListItemState createState() => _SlidableListItemState();
}

class _SlidableListItemState extends State<SlidableListItem>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Animation<Offset> animation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: Offset(-0.2 * (widget?.actions?.length ?? 0), 0),
    ).animate(
      CurveTween(curve: Curves.decelerate).animate(_animationController),
    );

    return widget.actions == null
        ? widget.child
        : GestureDetector(
            onHorizontalDragUpdate: (DragUpdateDetails data) {
              _onHorizontalDragUpdate(data, context);
            },
            onHorizontalDragEnd: (DragEndDetails data) {
              _onHorizontalDragEnd(data);
            },
            child: Stack(
              children: <Widget>[
                SlideTransition(position: animation, child: widget.child),
                Positioned.fill(
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraint) =>
                            AnimatedBuilder(
                      animation: _animationController,
                      builder: (BuildContext context, Widget child) => Stack(
                        children: <Widget>[
                          Positioned(
                            right: 0,
                            top: 0,
                            bottom: 0,
                            width:
                                constraint.maxWidth * animation.value.dx * -1,
                            child: Row(
                              children: widget.actions
                                  .map((Widget child) => Expanded(child: child))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
  }

  void _onHorizontalDragUpdate(DragUpdateDetails data, BuildContext context) =>
      setState(() =>
          _animationController.value -= data.primaryDelta / context.size.width);

  void _onHorizontalDragEnd(DragEndDetails data) {
    if (data.primaryVelocity > 250) {
      //close menu on fast swipe in the right direction
      _animationController.animateTo(0);
    } else if (_animationController.value >= 0.5 ||
        data.primaryVelocity < -250) {
      // fully open if dragged a lot to left or on fast swipe to left
      _animationController.animateTo(1);
    } else {
      // close if none of above
      _animationController.animateTo(0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }
}
