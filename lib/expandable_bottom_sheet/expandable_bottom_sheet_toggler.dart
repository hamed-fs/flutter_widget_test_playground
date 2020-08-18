part of 'expandable_bottom_sheet.dart';

class _ExpandableBottomSheetToggler extends StatelessWidget {
  _ExpandableBottomSheetToggler({Key key}) : super(key: key);

  final ThemeProvider _themeProvider = ThemeProvider();

  @override
  Widget build(BuildContext context) {
    final _ExpandableBottomSheetProvider provider =
        _ExpandableBottomSheetProvider.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onVerticalDragUpdate: provider.onVerticalDragUpdate,
      onVerticalDragEnd: provider.onVerticalDragEnd,
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
      onTap: provider.onTogglerTap,
    );
  }
}
