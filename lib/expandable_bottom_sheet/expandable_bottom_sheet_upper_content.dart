part of 'expandable_bottom_sheet.dart';

typedef OnHeightCalculatedCallback = void Function(double);

class _ExpandableBottomSheetUpperContent extends StatelessWidget {
  const _ExpandableBottomSheetUpperContent({
    @required this.onHeightCalculated,
    Key key,
  }) : super(key: key);

  final OnHeightCalculatedCallback onHeightCalculated;

  @override
  Widget build(BuildContext context) {
    final _ExpandableBottomSheetProvider provider =
        _ExpandableBottomSheetProvider.of(context);

    return Builder(
      builder: (BuildContext context) {
        SchedulerBinding.instance.addPostFrameCallback(
          (_) => onHeightCalculated(context.size.height),
        );

        return provider.upperContent ?? Container();
      },
    );
  }
}
