part of 'expandable_bottom_sheet.dart';

/// Expandable bottom sheet controller
class ExpandableBottomSheetController {
  final StreamController<double> _streamController =
      StreamController<double>.broadcast();

  double _height = 0;

  /// Expandable bottom sheet height
  double get height => _height;

  set height(double value) => _dispatch(_height = value);

  /// Closes bottom sheet
  void close() => _dispatch(0);

  /// Shows expandable bottom sheet is open or close
  bool isOpen() => _height > 0;

  /// Gets height stream
  Stream<double> get heightStream => _streamController.stream;

  void _dispatch(double value) => _streamController.sink.add(value);

  /// Disposes stream controller
  void dispose() {
    _streamController.close();
  }
}
