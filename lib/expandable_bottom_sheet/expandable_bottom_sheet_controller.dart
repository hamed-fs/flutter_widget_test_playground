part of 'expandable_bottom_sheet.dart';

/// Expandable bottom sheet controller
class ExpandableBottomSheetController extends ValueNotifier<bool> {
  /// Initializes
  ExpandableBottomSheetController() : super(false);

  final ExpandableBottomSheetBloc _expandableBottomSheetBloc =
      ExpandableBottomSheetBloc();

  double _height;

  /// Gets height
  double get height => _height;

  /// Sets height
  set height(double value) =>
      _expandableBottomSheetBloc.dispatch(_height = value);

  /// Gets height stream
  Stream<double> get heightStream => _expandableBottomSheetBloc.height;

  /// Gets open or close state stream
  Stream<bool> get isOpenStream => _expandableBottomSheetBloc.isOpen;

  /// Gets open or close state
  bool get isOpened => value;

  /// Closes bottom sheet
  void close() => value = false;

  /// Opens bottom sheet
  void open() => value = true;

  @override
  void dispose() {
    _expandableBottomSheetBloc.dispose();

    super.dispose();
  }
}

/// Expandable bottom sheet bloc
class ExpandableBottomSheetBloc {
  final StreamController<double> _heightController =
      StreamController<double>.broadcast();
  final StreamController<bool> _visibilityController =
      StreamController<bool>.broadcast();

  /// Gets height
  Stream<double> get height => _heightController.stream;

  /// Gets open or close state
  Stream<bool> get isOpen => _visibilityController.stream;

  /// Adds values to controller
  void dispatch(double value) {
    _heightController.sink.add(value);
    _visibilityController.sink.add(value > 0);
  }

  /// Dispose controllers
  void dispose() {
    _heightController.close();
    _visibilityController.close();
  }
}
