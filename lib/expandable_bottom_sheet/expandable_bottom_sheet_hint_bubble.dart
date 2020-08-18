part of 'expandable_bottom_sheet.dart';

class _ExpandableBottomSheetHintBubble extends StatelessWidget {
  _ExpandableBottomSheetHintBubble({
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
        ? const SizedBox.shrink()
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
