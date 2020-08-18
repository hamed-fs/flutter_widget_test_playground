part of 'expandable_bottom_sheet.dart';

class _ExpandableBottomSheetTitle extends StatelessWidget {
  _ExpandableBottomSheetTitle({Key key}) : super(key: key);

  final ThemeProvider _themeProvider = ThemeProvider();

  @override
  Widget build(BuildContext context) {
    final _ExpandableBottomSheetProvider provider =
        _ExpandableBottomSheetProvider.of(context);

    return provider.title == null
        ? const SizedBox.shrink()
        : GestureDetector(
            behavior: HitTestBehavior.translucent,
            onVerticalDragUpdate: provider.onVerticalDragUpdate,
            onVerticalDragEnd: provider.onVerticalDragEnd,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Text(
                provider.title,
                style: _themeProvider.textStyle(
                  textStyle: TextStyles.subheading,
                  color: _themeProvider.base01Color,
                ),
              ),
            ),
            onTap: provider.onTogglerTap,
          );
  }
}
