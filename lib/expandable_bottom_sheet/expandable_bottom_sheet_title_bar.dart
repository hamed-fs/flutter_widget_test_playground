part of 'expandable_bottom_sheet.dart';

class _ExpandableBottomSheetTitleBar extends StatelessWidget {
  const _ExpandableBottomSheetTitleBar({
    @required this.onVerticalDragUpdate,
    @required this.onVerticalDragEnd,
    this.onTogglerTap,
    Key key,
  }) : super(key: key);

  final GestureDragUpdateCallback onVerticalDragUpdate;
  final GestureDragEndCallback onVerticalDragEnd;

  final VoidCallback onTogglerTap;

  @override
  Widget build(BuildContext context) {
    final _ExpandableBottomSheetController controller =
        _ExpandableBottomSheetProvider.of(context).controller;

    return StreamBuilder<bool>(
      stream: controller.hintStateStream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) => Column(
        children: <Widget>[
          _ExpandableBottomSheetToggler(
            onVerticalDragUpdate: onVerticalDragUpdate,
            onVerticalDragEnd: onVerticalDragEnd,
            onTap: onTogglerTap,
          ),
          Container(
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              overflow: Overflow.visible,
              children: <Widget>[
                _ExpandableBottomSheetTitle(
                  onVerticalDragUpdate: onVerticalDragUpdate,
                  onVerticalDragEnd: onVerticalDragEnd,
                  onTap: onTogglerTap,
                ),
                Positioned(
                  child: _ExpandableBottomSheetHintButton(
                    onTap: () => controller.isHintOpen = !controller.isHintOpen,
                  ),
                  right: 16,
                ),
                Positioned(
                  child: _ExpandableBottomSheetHintBubble(
                      isVisible: snapshot.data ?? false),
                  right: controller.isOpen ? 44 : 18,
                  bottom: controller.isOpen ? 0 : 42,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

