part of 'expandable_bottom_sheet.dart';

class _ExpandableBottomSheetTitleBar extends StatelessWidget {
  _ExpandableBottomSheetTitleBar({
    @required this.title,
    @required this.hint,
    @required this.isVisible,
    @required this.isOpen,
    @required this.onVerticalDragUpdate,
    @required this.onVerticalDragEnd,
    this.toggler,
    this.onTogglerTap,
    this.onHintTap,
    Key key,
  }) : super(key: key);

  final String title;
  final String hint;
  final bool isVisible;
  final bool isOpen;

  final Widget toggler;

  final GestureDragUpdateCallback onVerticalDragUpdate;
  final GestureDragEndCallback onVerticalDragEnd;

  final VoidCallback onTogglerTap;
  final VoidCallback onHintTap;

  final ThemeProvider _themeProvider = ThemeProvider();

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          _Toggler(
            toggler: toggler,
            onVerticalDragUpdate: onVerticalDragUpdate,
            onVerticalDragEnd: onVerticalDragEnd,
            onTogglerTap: onTogglerTap,
          ),
          if (title != null)
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onVerticalDragUpdate: onVerticalDragUpdate,
              onVerticalDragEnd: onVerticalDragEnd,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  overflow: Overflow.visible,
                  children: <Widget>[
                    if (title != null)
                      Text(
                        title,
                        style: _themeProvider.textStyle(
                          textStyle: TextStyles.subheading,
                          color: _themeProvider.base01Color,
                        ),
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
                        right: isOpen ? -8.0 : 28.0,
                        bottom: isOpen ? 44.0 : 18.0,
                      ),
                  ],
                ),
              ),
            ),
        ],
      );
}

class _Toggler extends StatelessWidget {
  _Toggler({
    @required this.onVerticalDragUpdate,
    @required this.onVerticalDragEnd,
    @required this.onTogglerTap,
    this.toggler,
    Key key,
  }) : super(key: key);

  final Widget toggler;

  final GestureDragUpdateCallback onVerticalDragUpdate;
  final GestureDragEndCallback onVerticalDragEnd;

  final VoidCallback onTogglerTap;

  final ThemeProvider _themeProvider = ThemeProvider();

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onVerticalDragUpdate: onVerticalDragUpdate,
        onVerticalDragEnd: onVerticalDragEnd,
        child: toggler ??
            Container(
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
        onTap: onTogglerTap,
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
  Widget build(BuildContext context) => ClipOval(
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
  Widget build(BuildContext context) => AnimatedOpacity(
        opacity: isVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 250),
        child: Container(
          constraints: BoxConstraints(maxWidth: _getHintMessageWidth(context)),
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
