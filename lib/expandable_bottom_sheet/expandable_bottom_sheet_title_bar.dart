part of 'expandable_bottom_sheet.dart';

class _ExpandableBottomSheetTitleBar extends StatelessWidget {
  const _ExpandableBottomSheetTitleBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _ExpandableBottomSheetProvider provider =
        _ExpandableBottomSheetProvider.of(context);

    final _ExpandableBottomSheetController controller = provider.controller;

    return StreamBuilder<bool>(
      stream: controller.hintStateStream,
      initialData: false,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) => Column(
        children: <Widget>[
          if (provider.showToggler) _ExpandableBottomSheetToggler(),
          Container(
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              overflow: Overflow.visible,
              children: <Widget>[
                _ExpandableBottomSheetTitle(),
                if (provider.leftAction != null)
                  Positioned(
                    child: provider.leftAction,
                    left: 16,
                  ),
                if (provider.hint == null && provider.rightAction != null)
                  Positioned(
                    child: provider.rightAction,
                    right: 16,
                  ),
                Positioned(
                  child: _ExpandableBottomSheetHintButton(
                    onTap: () => controller.isHintOpen = !controller.isHintOpen,
                  ),
                  right: 16,
                ),
                Positioned(
                  child: _ExpandableBottomSheetHintBubble(
                    isVisible: snapshot.data,
                  ),
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
