part of 'expandable_bottom_sheet.dart';

class _ExpandableBottomSheetTitleBar extends StatelessWidget {
  const _ExpandableBottomSheetTitleBar({
    @required this.isVisible,
    @required this.onVerticalDragUpdate,
    @required this.onVerticalDragEnd,
    this.onTogglerTap,
    this.onHintTap,
    Key key,
  }) : super(key: key);

  final bool isVisible;

  final GestureDragUpdateCallback onVerticalDragUpdate;
  final GestureDragEndCallback onVerticalDragEnd;

  final VoidCallback onTogglerTap;
  final VoidCallback onHintTap;

  @override
  Widget build(BuildContext context) {
    final ExpandableBottomSheetController controller =
        _ExpandableBottomSheetProvider.of(context).controller;

    return Column(
      children: <Widget>[
        _Toggler(
          onVerticalDragUpdate: onVerticalDragUpdate,
          onVerticalDragEnd: onVerticalDragEnd,
          onTap: onTogglerTap,
        ),
        Container(
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            overflow: Overflow.visible,
            children: <Widget>[
              _Title(
                onVerticalDragUpdate: onVerticalDragUpdate,
                onVerticalDragEnd: onVerticalDragEnd,
                onTap: onTogglerTap,
              ),
              Positioned(
                child: _HintButton(
                  onTap: onHintTap,
                ),
                right: 16,
              ),
              Positioned(
                child: _HintBubble(isVisible: isVisible),
                right: controller.isOpen() ? 44 : 18,
                bottom: controller.isOpen() ? 0 : 42,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Toggler extends StatelessWidget {
  _Toggler({
    @required this.onVerticalDragUpdate,
    @required this.onVerticalDragEnd,
    @required this.onTap,
    Key key,
  }) : super(key: key);

  final GestureDragUpdateCallback onVerticalDragUpdate;
  final GestureDragEndCallback onVerticalDragEnd;

  final VoidCallback onTap;

  final ThemeProvider _themeProvider = ThemeProvider();

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onVerticalDragUpdate: onVerticalDragUpdate,
        onVerticalDragEnd: onVerticalDragEnd,
        child: Container(
          margin: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 32,
          ),
          height: 4,
          width: 40,
          decoration: BoxDecoration(
            color: _themeProvider.base05Color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        onTap: onTap,
      );
}

class _Title extends StatelessWidget {
  _Title({
    @required this.onVerticalDragUpdate,
    @required this.onVerticalDragEnd,
    @required this.onTap,
    Key key,
  }) : super(key: key);

  final GestureDragUpdateCallback onVerticalDragUpdate;
  final GestureDragEndCallback onVerticalDragEnd;

  final VoidCallback onTap;

  final ThemeProvider _themeProvider = ThemeProvider();

  @override
  Widget build(BuildContext context) {
    final String title = _ExpandableBottomSheetProvider.of(context).title;

    return title == null
        ? Container()
        : GestureDetector(
            behavior: HitTestBehavior.translucent,
            onVerticalDragUpdate: onVerticalDragUpdate,
            onVerticalDragEnd: onVerticalDragEnd,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
              child: Text(
                title,
                style: _themeProvider.textStyle(
                  textStyle: TextStyles.subheading,
                  color: _themeProvider.base01Color,
                ),
              ),
            ),
            onTap: onTap,
          );
  }
}

class _HintButton extends StatelessWidget {
  _HintButton({
    @required this.onTap,
    Key key,
  }) : super(key: key);

  final VoidCallback onTap;

  final ThemeProvider _themeProvider = ThemeProvider();

  @override
  Widget build(BuildContext context) {
    final _ExpandableBottomSheetProvider provider =
        _ExpandableBottomSheetProvider.of(context);

    return provider.title == null || provider.hint == null
        ? Container()
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: ClipOval(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Icon(
                      Icons.info_outline,
                      size: 20,
                      color: _themeProvider.base05Color,
                    ),
                  ),
                  onTap: onTap,
                ),
              ),
            ),
          );
  }
}

class _HintBubble extends StatelessWidget {
  _HintBubble({
    @required this.isVisible,
    Key key,
  }) : super(key: key);

  final bool isVisible;

  final ThemeProvider _themeProvider = ThemeProvider();

  @override
  Widget build(BuildContext context) {
    final _ExpandableBottomSheetProvider provider =
        _ExpandableBottomSheetProvider.of(context);

    return provider.hint == null
        ? Container()
        : Visibility(
            visible: isVisible,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: _getHintMessageWidth(context),
              ),
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: _themeProvider.base06Color,
              ),
              child: Text(
                provider.hint,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
                style: _themeProvider.textStyle(
                  textStyle: TextStyles.caption,
                  color: _themeProvider.base01Color,
                ),
              ),
            ),
          );
  }

  double _getHintMessageWidth(BuildContext context) =>
      MediaQuery.of(context).size.width * 0.7;
}
