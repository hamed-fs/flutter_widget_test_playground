import 'package:flutter/material.dart';

class AnimatedMessage extends StatefulWidget {
  final Widget child;
  final Duration animationDuration;

  const AnimatedMessage(
      {Key key,
      this.child,
      this.animationDuration = const Duration(milliseconds: 400)})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => AnimatedMessageState();
}

class AnimatedMessageState extends State<AnimatedMessage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _scaleAnimation;

  Tween<double> _tween = Tween(begin: 0.75, end: 1);

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: widget.animationDuration);
    _scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.bounceOut);

    _scaleAnimation = _tween.animate(_scaleAnimation);

    _controller.addListener(() {
      setState(() {});
    });

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}
