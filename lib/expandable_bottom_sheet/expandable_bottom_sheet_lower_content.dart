part of 'expandable_bottom_sheet.dart';

class _ExpandableBottomSheetLowerContent extends StatelessWidget {
  const _ExpandableBottomSheetLowerContent({
    @required this.content,
    @required this.controller,
    Key key,
    this.changeStateDuration = const Duration(milliseconds: 150),
  }) : super(key: key);

  final Widget content;
  final Duration changeStateDuration;

  final ExpandableBottomSheetController controller;

  @override
  Widget build(BuildContext context) => StreamBuilder<double>(
        stream: controller.heightStream,
        initialData: controller.height,
        builder: (BuildContext context, AsyncSnapshot<double> snapshot) =>
            AnimatedContainer(
          curve: Curves.ease,
          duration: changeStateDuration,
          height: snapshot.data,
          child: content,
        ),
      );
}
