import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/numero.dart';
import '../models/sezione.dart';

class NumeriStorage {
  static const String _numeriKey = 'numeri_rubrica';
  static const String _sezioniKey = 'sezioni_rubrica';

  Future<void> saveNumeri(List<Numero> numeri) async {
    final prefs = await SharedPreferences.getInstance();
    final numeriJson = numeri.map((numero) => numero.toJson()).toList();
    await prefs.setString(_numeriKey, jsonEncode(numeriJson));
  }

  Future<List<Numero>> loadNumeri() async {
    final prefs = await SharedPreferences.getInstance();
    final numeriJson = prefs.getString(_numeriKey);
    if (numeriJson == null) return [];
    
    final List<dynamic> decoded = jsonDecode(numeriJson);
    return decoded.map((item) => Numero.fromJson(item)).toList();
  }

  Future<void> saveSezioni(List<Sezione> sezioni) async {
    final prefs = await SharedPreferences.getInstance();
    final sezioniJson = sezioni.map((sezione) => sezione.toJson()).toList();
    await prefs.setString(_sezioniKey, jsonEncode(sezioniJson));
  }

  Future<List<Sezione>> loadSezioni() async {
    final prefs = await SharedPreferences.getInstance();
    final sezioniJson = prefs.getString(_sezioniKey);
    if (sezioniJson == null) return [];
    
    final List<dynamic> decoded = jsonDecode(sezioniJson);
    return decoded.map((item) => Sezione.fromJson(item)).toList();
  }
}
