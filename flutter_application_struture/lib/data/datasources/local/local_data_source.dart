import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDataSource {
  Future<void> setString(String key, String value);
  Future<String?> getString(String key);
  Future<void> setInt(String key, int value);
  Future<int?> getInt(String key);
  Future<void> setBool(String key, bool value);
  Future<bool?> getBool(String key);
  Future<void> setDouble(String key, double value);
  Future<double?> getDouble(String key);
  Future<void> setStringList(String key, List<String> value);
  Future<List<String>?> getStringList(String key);
  Future<void> remove(String key);
  Future<void> clear();
  Future<Map<String, dynamic>> getAll();
}

class LocalDataSourceImpl implements LocalDataSource {
  static LocalDataSourceImpl? _instance;
  static SharedPreferences? _prefs;

  LocalDataSourceImpl._();

  static Future<LocalDataSourceImpl> getInstance() async {
    if (_instance == null) {
      _instance = LocalDataSourceImpl._();
      _prefs = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  @override
  Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  @override
  Future<String?> getString(String key) async {
    return _prefs?.getString(key);
  }

  @override
  Future<void> setInt(String key, int value) async {
    await _prefs?.setInt(key, value);
  }

  @override
  Future<int?> getInt(String key) async {
    return _prefs?.getInt(key);
  }

  @override
  Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  @override
  Future<bool?> getBool(String key) async {
    return _prefs?.getBool(key);
  }

  @override
  Future<void> setDouble(String key, double value) async {
    await _prefs?.setDouble(key, value);
  }

  @override
  Future<double?> getDouble(String key) async {
    return _prefs?.getDouble(key);
  }

  @override
  Future<void> setStringList(String key, List<String> value) async {
    await _prefs?.setStringList(key, value);
  }

  @override
  Future<List<String>?> getStringList(String key) async {
    return _prefs?.getStringList(key);
  }

  @override
  Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }

  @override
  Future<void> clear() async {
    await _prefs?.clear();
  }

  @override
  Future<Map<String, dynamic>> getAll() async {
    final keys = _prefs?.getKeys() ?? <String>{};
    final Map<String, dynamic> result = {};
    
    for (final key in keys) {
      final value = _prefs?.get(key);
      result[key] = value;
    }
    
    return result;
  }
}