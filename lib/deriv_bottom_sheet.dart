import 'package:flutter/material.dart';
import 'package:flutter_widget_test_playground/deriv_bottom_sheet_controller.dart';

class DerivBottomSheet extends StatefulWidget {
  // This controls the minimum height of the body. Must be greater or equal of
  // 0. By default is 0
  final double minHeight;

  // This controls the minimum height of the body. By default is 500
  double _maxHeight;

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
  DerivBottomSheetController controller;

  // This method will be executed when the solid bottom sheet is completely
  // opened.
  final Function onShow;

  // This method will be executed when the solid bottom sheet is completely
  // closed.
  final Function onHide;

  final BuildContext context;

  DerivBottomSheet({
    Key key,
    @required this.context,
    @required this.lowerBody,
    @required this.upperBody,
    @required this.toggler,
    this.controller,
    this.minHeight = 0,
    this.autoSwiped = true,
    this.canUserSwipe = true,
    this.elevation = 0.0,
    this.maximizedAtStart = false,
    this.onShow,
    this.onHide,
  })  : assert(elevation >= 0.0),
        assert(minHeight >= 0.0),
        super(key: key) {
    if (controller == null) {
      this.controller = DerivBottomSheetController();
    }

    _maxHeight = MediaQuery.of(context).size.height -
        (Scaffold.of(context).hasAppBar
            ? Scaffold.of(context).appBarMaxHeight
            : 0) -
        24.0 -
        100.0;

    this.controller.height =
        this.maximizedAtStart ? this._maxHeight : this.minHeight;
  }

  @override
  _DerivBottomSheetState createState() => _DerivBottomSheetState();
}

class _DerivBottomSheetState extends State<DerivBottomSheet> {
  bool isDragDirectionUp;

  void _onVerticalDragUpdate(data) {
    if (((widget.controller.height - data.delta.dy) > widget.minHeight) &&
        ((widget.controller.height - data.delta.dy) < widget._maxHeight)) {
      isDragDirectionUp = data.delta.dy <= 0;
      widget.controller.height -= data.delta.dy;
    }
  }

  void _onVerticalDragEnd(data) {
    if (isDragDirectionUp && (widget.controller?.value ?? false))
      _show();
    else if (!isDragDirectionUp && !widget.controller.value)
      _hide();
    else
      widget.controller.value = isDragDirectionUp;
  }

  void _onTap() {
    final bool isOpened = widget.controller.height == widget._maxHeight;
    widget.controller.value = !isOpened;
  }

  Function _controllerListener;

  @override
  void initState() {
    super.initState();
    widget.controller.value = widget.maximizedAtStart;
    _controllerListener = () {
      widget.controller.value ? _show() : _hide();
    };
    widget.controller.addListener(_controllerListener);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
          stream: widget.controller.heightStream,
          initialData: widget.controller.height,
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
  }

  void _hide() {
    if (widget.onHide != null) widget.onHide();
    widget.controller.height = widget.minHeight;
  }

  void _show() {
    if (widget.onShow != null) widget.onShow();
    widget.controller.height = widget._maxHeight;
  }

  @override
  void dispose() {
    widget.controller.removeListener(_controllerListener);
    super.dispose();
  }
}
