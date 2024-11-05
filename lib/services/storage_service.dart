import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/modulo.dart';

class StorageService {
  static const String _moduliKey = 'moduli';
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  Future<List<Modulo>> getModuli() async {
    final String? moduliJson = _prefs.getString(_moduliKey);
    if (moduliJson == null) return [];

    final List<dynamic> decodedList = json.decode(moduliJson);
    return decodedList.map((item) => Modulo.fromJson(item)).toList();
  }

  Future<void> saveModuli(List<Modulo> moduli) async {
    final List<Map<String, dynamic>> encodedList = 
        moduli.map((m) => m.toJson()).toList();
    await _prefs.setString(_moduliKey, json.encode(encodedList));
  }
} 