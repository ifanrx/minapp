import 'package:shared_preferences/shared_preferences.dart';

class _StorageAsync {
  SharedPreferences _sp;
  Future<bool> set(String key, String value) async {
    if (_sp == null) {
      _sp = await SharedPreferences.getInstance();
    }
    return _sp.setString(key, value);
  }

  Future<String> get(String key) async {
    if (_sp == null) {
      _sp = await SharedPreferences.getInstance();
    }
    return _sp.getString(key);
  }
}

class _Storage {
  void set(String key, String value) {
    throw UnimplementedError();
  }
  String get(String key) {
    throw UnimplementedError();
  }
}

final _StorageAsync storageAsync = _StorageAsync();
final _Storage storage = _Storage();
