import 'package:shared_preferences/shared_preferences.dart';
import 'package:optional/optional.dart';
import './provider.dart';
import 'package:logging/logging.dart';
//import 'package:flutter/foundation.dart' show debugPrint;

class SaveData {
  static SaveData _instance;
  Logger _logger;
  Map<String, Provider> _map;
  Map<String, Object> _storage;

  static SaveData get instance {
    if (_instance == null) {
      _instance = SaveData._internal();
    }
    return _instance;
  }

  SaveData._internal() {
    this._logger = Logger('SaveData');
    this._map = Map<String, Provider>();
    this._storage = Map<String, Object>();
  }

  void register<T extends Provider>(String name, Provider provider) {
    _map[name] = provider;
  }

  Optional<T> cache<T>(String name) {
    if (_storage.containsKey(name)) {
      return Optional.of(_storage[name] as T);
    }
    return Optional.empty();
  }

  void discard(String name) {
    if (_storage.containsKey(name)) {
      _storage.remove(name);
    }
  }

  Future<T> load<T>(String name) async {
    var prefs = await SharedPreferences.getInstance();
    if (_storage.containsKey(name)) {
      return _storage[name] as T;
    }
    if (!_map.containsKey(name)) {
      throw new ArgumentError();
    }
    var provider = _map[name];
    if (prefs.containsKey(name)) {
      var str = prefs.getString(name);
      provider.fromJson(str);
      _logger.info('SaveData: $name is loaded.');
      _logger.info('SaveData: $str');
    } else {
      provider.clear();
      _logger.info('SaveData: $name is initialized.');
    }
    _storage[name] = provider.cache.value;
    return _storage[name];
  }

  Future<void> save(String name) async {
    var prefs = await SharedPreferences.getInstance();
    await load(name);
    var provider = _map[name];
    var str = provider.toJson();
    _logger.info('SaveData: $name is saved.');
    _logger.info('SaveData: $str');
    prefs.setString(name, str);
  }

  Future<void> clear() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.clear();
    _map.clear();
    _storage.clear();
  }
}
