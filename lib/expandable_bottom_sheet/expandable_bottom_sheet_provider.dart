part of 'expandable_bottom_sheet.dart';

/// Expandable bottom sheet provider
class _ExpandableBottomSheetProvider extends InheritedWidget {
  /// Initializes
  const _ExpandableBottomSheetProvider({
    @required Widget child,
    @required this.controller,
    this.upperContent,
    this.lowerContent,
    this.title,
    this.hint,
    this.changeStateDuration,
  }) : super(child: child);

  final _ExpandableBottomSheetController controller;

  final Widget upperContent;
  final Widget lowerContent;

  final String title;
  final String hint;

  final Duration changeStateDuration;

  static _ExpandableBottomSheetProvider of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<_ExpandableBottomSheetProvider>();

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
