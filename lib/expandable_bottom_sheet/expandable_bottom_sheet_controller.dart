part of 'expandable_bottom_sheet.dart';

/// Expandable bottom sheet controller
class ExpandableBottomSheetController extends ValueNotifier<bool> {
  /// Initializes
  ExpandableBottomSheetController() : super(false);

  final StreamController<double> _heightController =
      StreamController<double>.broadcast();

  final StreamController<bool> _visibilityController =
      StreamController<bool>.broadcast();

  double _height;

  /// Expandable bottom sheet height
  double get height => _height;

  set height(double value) => dispatch(_height = value);

  /// Shows expandable bottom sheet is open or close
  bool get isOpen => value;

  set isOpen(bool value) => this.value = value;

  /// Gets height stream
  Stream<double> get heightStream => _heightController.stream;

  /// Gets open or close state stream
  Stream<bool> get isOpenStream => _visibilityController.stream;

  /// Closes bottom sheet
  void close() => value = false;

  /// Opens bottom sheet
  void open() => value = true;

  /// Adds values to controller
  void dispatch(double value) {
    _heightController.sink.add(value);
    _visibilityController.sink.add(value > 0);
  }

  @override
  void dispose() {
    _heightController.close();
    _visibilityController.close();

    super.dispose();
  }
}
