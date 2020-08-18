part of 'expandable_bottom_sheet.dart';

class _ExpandableBottomSheetHintButton extends StatelessWidget {
  _ExpandableBottomSheetHintButton({
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
        ? const SizedBox.shrink()
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
