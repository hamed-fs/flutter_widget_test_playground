part of 'expandable_bottom_sheet.dart';

class _ExpandableBottomSheetToggler extends StatelessWidget {
  _ExpandableBottomSheetToggler({
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
