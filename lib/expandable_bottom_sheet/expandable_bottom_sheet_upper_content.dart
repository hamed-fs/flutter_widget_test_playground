part of 'expandable_bottom_sheet.dart';

typedef OnHeightCalculatedCallback = void Function(double);

class _ExpandableBottomSheetUpperContent extends StatelessWidget {
  const _ExpandableBottomSheetUpperContent({
    @required this.content,
    @required this.onHeightCalculated,
    Key key,
  }) : super(key: key);

  final Widget content;

  final OnHeightCalculatedCallback onHeightCalculated;

  @override
  Widget build(BuildContext context) => Builder(
        builder: (BuildContext context) {
          SchedulerBinding.instance.addPostFrameCallback(
            (_) => onHeightCalculated(context.size.height),
          );

          return content ?? Container();
        },
      );
}
