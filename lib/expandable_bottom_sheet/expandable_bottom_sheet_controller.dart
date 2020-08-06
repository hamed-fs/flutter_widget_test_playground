part of 'expandable_bottom_sheet.dart';

/// Expandable bottom sheet controller
class _ExpandableBottomSheetController {
  final StreamController<bool> _hintStateStreamController =
      StreamController<bool>.broadcast();
  final StreamController<double> _heightStreamController =
      StreamController<double>.broadcast();

  bool _isHintOpen = false;
  double _height = 0;

  /// Expandable bottom sheet hint visibility
  bool get isHintOpen => _isHintOpen;

  set isHintOpen(bool value) => _dispatchHintState(_isHintOpen = value);

  /// Expandable bottom sheet height
  double get height => _height;

  set height(double value) => _dispatchHeight(_height = value);

  /// Closes bottom sheet
  void close() => _dispatchHeight(0);

  /// Shows expandable bottom sheet is open or close
  bool isOpen() => _height > 0;

  /// Gets hint state stream
  Stream<bool> get hintStateStream => _hintStateStreamController.stream;

  /// Gets height stream
  Stream<double> get heightStream => _heightStreamController.stream;

  void _dispatchHintState(bool value) =>
      _hintStateStreamController.sink.add(value);

  void _dispatchHeight(double value) => _heightStreamController.sink.add(value);

  /// Disposes stream controller
  void dispose() {
    _hintStateStreamController.close();
    _heightStreamController.close();
  }
}
