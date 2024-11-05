import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/riconciliazione.dart';

class BolliniStorage {
  static const String _key = 'bollini_storico';

  Future<void> saveStorico(List<Riconciliazione> storico) async {
    final prefs = await SharedPreferences.getInstance();
    final storicoJson = storico.map((item) => item.toJson()).toList();
    await prefs.setString(_key, jsonEncode(storicoJson));
  }

  Future<List<Riconciliazione>> loadStorico() async {
    final prefs = await SharedPreferences.getInstance();
    final storicoJson = prefs.getString(_key);
    if (storicoJson == null) return [];
    
    final List<dynamic> decoded = jsonDecode(storicoJson);
    return decoded.map((item) => Riconciliazione.fromJson(item)).toList();
  }
}
