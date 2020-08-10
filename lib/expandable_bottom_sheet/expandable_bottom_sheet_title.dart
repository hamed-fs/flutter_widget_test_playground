part of 'expandable_bottom_sheet.dart';

class _ExpandableBottomSheetTitle extends StatelessWidget {
  _ExpandableBottomSheetTitle({
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
