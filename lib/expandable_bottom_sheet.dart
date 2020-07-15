import 'dart:async';

import 'package:flutter/material.dart';

class ExpandableBottomSheet extends StatefulWidget {
  // This controls the minimum height of the body. Must be greater or equal of
  // 0. By default is 0
  final double minHeight;

  // This controls the minimum height of the body. By default is 500

  // This is the content that will be hided of your bottomSheet. You can fit any
  // widget. This parameter is required
  final Widget lowerBody;

  // This is the header of your bottomSheet. This widget is the swipeable area
  // where user will interact. This parameter is required
  final Widget upperBody;

  final Widget toggler;

  // This flag is used to enable the automatic swipe of the bar. If it's true
  // the bottomSheet will automatically appear or disappear when user stops
  // swiping, but if it's false, it will stay at the last user finger position.
  // By default is true
  final bool autoSwiped;

  // This flag enable that users can swipe the header and hide or show the
  // solid bottom sheet. Turn on false if you don't want to let the user
  // interact with the solid bottom sheet. By default is true.
  final bool canUserSwipe; // TODO: Change to draggableHeader

  // This property is the elevation of the bottomSheet. Must be greater or equal
  // to 0. By default is 0.
  final double elevation;

  // This flag controls if the body is shown to the user by default. If it's
  // true, the body will be shown. If it's false the body will be hided. By
  // default it's false.
  final bool maximizedAtStart; // TODO: change to openedByDefault

  // This object used to control behavior internally
  // from the app and don't depend of user's interaction.
  // can hide and show  methods plus have isOpened variable
  // to check widget visibility on a screen

  // This method will be executed when the solid bottom sheet is completely
  // opened.
  final Function onShow;

  // This method will be executed when the solid bottom sheet is completely
  // closed.
  final Function onHide;

  // final BuildContext context;

  ExpandableBottomSheet({
    Key key,
    // @required this.context,
    @required this.lowerBody,
    @required this.upperBody,
    @required this.toggler,
    this.minHeight = 0,
    this.autoSwiped = true,
    this.canUserSwipe = true,
    this.elevation = 0.0,
    this.maximizedAtStart = false,
    this.onShow,
    this.onHide,
  })  : assert(elevation >= 0.0),
        assert(minHeight >= 0.0),
        super(key: key);

  @override
  _ExpandableBottomSheetState createState() => _ExpandableBottomSheetState();
}

class _ExpandableBottomSheetState extends State<ExpandableBottomSheet> {
  double _maxHeight;
  bool _isDragDirectionUp;
  _ExpandableBottomSheetController _controller;

  @override
  void initState() {
    super.initState();

    if (_controller == null) {
      _controller = _ExpandableBottomSheetController();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _maxHeight =
        MediaQuery.of(context).size.height - 124.0 - _getAppBarHeight();

    _controller.height =
        widget.maximizedAtStart ? _maxHeight : widget.minHeight;

    _controller.value = widget.maximizedAtStart;

    _controller.addListener(() => _controller.value ? _show() : _hide());
  }

  double _getAppBarHeight() =>
      Scaffold.of(context).hasAppBar ? Scaffold.of(context).appBarMaxHeight : 0;

  void _onVerticalDragUpdate(data) {
    if (((_controller.height - data.delta.dy) > widget.minHeight) &&
        ((_controller.height - data.delta.dy) < _maxHeight)) {
      _isDragDirectionUp = data.delta.dy <= 0;
      _controller.height -= data.delta.dy;
    }
  }

  void _onVerticalDragEnd(data) {
    if (_isDragDirectionUp && (_controller?.value ?? false)) {
      _show();
    } else if (!(_isDragDirectionUp || _controller.value)) {
      _hide();
    } else {
      _controller.value = _isDragDirectionUp;
    }
  }

  void _onTap() {
    final bool isOpened = _controller.height == _maxHeight;

    _controller.value = !isOpened;
  }

  Function _controllerListener;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            decoration: widget.elevation > 0
                ? BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: widget.elevation,
                    ),
                  ])
                : null,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onVerticalDragUpdate:
                      widget.canUserSwipe ? _onVerticalDragUpdate : null,
                  onVerticalDragEnd:
                      widget.autoSwiped ? _onVerticalDragEnd : null,
                  child: widget.toggler,
                  onTap: _onTap,
                ),
                widget.upperBody,
              ],
            ),
          ),
          StreamBuilder<double>(
            stream: _controller.heightStream,
            initialData: _controller.height,
            builder: (_, snapshot) {
              return AnimatedContainer(
                curve: Curves.ease,
                duration: Duration(milliseconds: 256),
                height: snapshot.data,
                child: widget.lowerBody,
              );
            },
          ),
        ],
      );

  void _hide() {
    if (widget.onHide != null) {
      widget.onHide();
    }

    _controller.height = widget.minHeight;
  }

  void _show() {
    if (widget.onShow != null) {
      widget.onShow();
    }

    _controller.height = _maxHeight;
  }

  @override
  void dispose() {
    _controller.removeListener(_controllerListener);

    super.dispose();
  }
}

class _ExpandableBottomSheetBloc {
  StreamController<double> _heightController =
      StreamController<double>.broadcast();
  Stream<double> get height => _heightController.stream;
  Sink<double> get _heightSink => _heightController.sink;

  StreamController<bool> _visibilityController =
      StreamController<bool>.broadcast();
  Stream<bool> get isOpen => _visibilityController.stream;
  Sink<bool> get _visibilitySink => _visibilityController.sink;

  // Adds new values to streams
  void dispatch(double value) {
    _heightSink.add(value);
    _visibilitySink.add(value > 0);
  }

  // Closes streams
  void dispose() {
    _heightController.close();
    _visibilityController.close();
  }
}

class _ExpandableBottomSheetController extends ValueNotifier<bool> {
  _ExpandableBottomSheetBloc _bloc = _ExpandableBottomSheetBloc();

  _ExpandableBottomSheetController() : super(false);

  double _height;

  double get height => _height;

  set height(double value) => _bloc.dispatch(_height = value);

  Stream<double> get heightStream => _bloc.height;

  Stream<bool> get isOpenStream => _bloc.isOpen;

  bool get isOpened => value;

  void hide() => value = false;

  void show() => value = true;

  @override
  void dispose() {
    _bloc.dispose();

    super.dispose();
  }
}
