part of 'grouped_list_view.dart';

class _GroupedListViewController {
  final StreamController<int> _streamController =
      StreamController<int>.broadcast();

  int _currentHeaderIndex = 0;

  int get currentHeaderIndex => _currentHeaderIndex;

  set currentHeaderIndex(int value) => _dispatch(_currentHeaderIndex = value);

  Stream<int> get stream => _streamController.stream;

  void _dispatch(int value) => _streamController.sink.add(value);

  void dispose() => _streamController.close();
}
