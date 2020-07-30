part of 'expandable_bottom_sheet.dart';

class _ExpandableBottomSheetTitleBar extends StatelessWidget {
  const _ExpandableBottomSheetTitleBar({
    @required this.title,
    @required this.hint,
    @required this.isVisible,
    @required this.isOpen,
    @required this.onVerticalDragUpdate,
    @required this.onVerticalDragEnd,
    this.onTogglerTap,
    this.onHintTap,
    Key key,
  }) : super(key: key);

  final String title;
  final String hint;
  final bool isVisible;
  final bool isOpen;

  final GestureDragUpdateCallback onVerticalDragUpdate;
  final GestureDragEndCallback onVerticalDragEnd;

  final VoidCallback onTogglerTap;
  final VoidCallback onHintTap;

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          _Toggler(
            onVerticalDragUpdate: onVerticalDragUpdate,
            onVerticalDragEnd: onVerticalDragEnd,
            onTap: onTogglerTap,
          ),
          if (title != null)
            Container(
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                overflow: Overflow.visible,
                children: <Widget>[
                  if (title != null)
                    _Title(
                      title: title,
                      onVerticalDragUpdate: onVerticalDragUpdate,
                      onVerticalDragEnd: onVerticalDragEnd,
                      onTap: onTogglerTap,
                    ),
                  if (title != null && hint != null)
                    Positioned(
                      child: _HintButton(
                        onTap: onHintTap,
                      ),
                      right: 18,
                    ),
                  if (title != null && hint != null)
                    Positioned(
                      child: _HintBubble(
                        isVisible: isVisible,
                        hint: hint,
                      ),
                      right: isOpen ? 44.0 : 18.0,
                      bottom: isOpen ? 0.0 : 42.0,
                    ),
                ],
              ),
            ),
        ],
      );
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
    @required this.title,
    @required this.onVerticalDragUpdate,
    @required this.onVerticalDragEnd,
    @required this.onTap,
    Key key,
  }) : super(key: key);

  final String title;

  final GestureDragUpdateCallback onVerticalDragUpdate;
  final GestureDragEndCallback onVerticalDragEnd;

  final VoidCallback onTap;

  final ThemeProvider _themeProvider = ThemeProvider();

  @override
  Widget build(BuildContext context) => GestureDetector(
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

class _HintButton extends StatelessWidget {
  _HintButton({
    @required this.onTap,
    Key key,
  }) : super(key: key);

  final VoidCallback onTap;

  final ThemeProvider _themeProvider = ThemeProvider();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: ClipOval(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              child: Icon(
                Icons.info_outline,
                size: 20,
                color: _themeProvider.base05Color,
              ),
              onTap: onTap,
            ),
          ),
        ),
      );
}

class _HintBubble extends StatelessWidget {
  _HintBubble({
    @required this.hint,
    @required this.isVisible,
    Key key,
  }) : super(key: key);

  final String hint;
  final bool isVisible;

  final ThemeProvider _themeProvider = ThemeProvider();

  @override
  Widget build(BuildContext context) => Visibility(
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
            hint,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            style: _themeProvider.textStyle(
              textStyle: TextStyles.caption,
              color: _themeProvider.base01Color,
            ),
          ),
        ),
      );

  double _getHintMessageWidth(BuildContext context) =>
      MediaQuery.of(context).size.width * 0.7;
}
