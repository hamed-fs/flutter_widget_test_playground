import 'dart:async';

/// Expandable bottom sheet controller
class ListController {
  final StreamController<List<Map<String, String>>> streamController =
      StreamController<List<Map<String, String>>>.broadcast();

  final List<Map<String, String>> _list = <Map<String, String>>[];

  set list(List<Map<String, String>> value) =>
      _dispatchHeight(_list..addAll(value));

  List<Map<String, String>> get list => _list;

  void _dispatchHeight(List<Map<String, String>> value) =>
      streamController.sink.add(value);

  /// Disposes stream controller
  void dispose() {
    streamController.close();
  }
}
