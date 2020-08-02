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
    this.maxHeight,
    this.openMaximized = false,
    this.changeStateDuration,
    this.onOpen,
    this.onClose,
    this.onToggle,
    this.onDismiss,
  }) : super(child: child);

  /// Expandable bottom sheet controller
  final ExpandableBottomSheetController controller;

  /// Upper content widget
  /// This part will be shown in close and open state
  final Widget upperContent;

  /// Lower content widget
  /// This part will be shown in open state
  final Widget lowerContent;

  /// Expandable bottom sheet title
  /// Title part will be invisible if [title] not set
  final String title;

  /// Expandable bottom sheet hint
  /// Hint button will be invisible if [hint] or [title] not set
  final String hint;

  /// Sets maximum height for expandable bottom sheet
  /// Expandable bottom sheet will be full screen if [maxHeight] not set
  final double maxHeight;

  /// Opens expandable bottom sheet in maximized state
  final bool openMaximized;

  /// Change state animation duration
  final Duration changeStateDuration;

  /// [onOpen] callback
  /// This callback will be called when expandable bottom sheet is open
  final VoidCallback onOpen;

  /// [onClose] callback
  /// This callback will be called when expandable bottom sheet is close
  final VoidCallback onClose;

  /// [onToggle] callback
  /// This callback will be called when toggle expandable bottom sheet
  final VoidCallback onToggle;

  /// [onDismiss] callback
  /// This callback will be called on expandable bottom sheet dismiss
  final VoidCallback onDismiss;

  /// Gets expandable bottom sheet provider
  static _ExpandableBottomSheetProvider of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<_ExpandableBottomSheetProvider>();

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
