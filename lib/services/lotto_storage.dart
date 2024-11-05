import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LottoStorage {
  static const String _key = 'lotto_sections';

  Future<void> saveSections(List<Map<String, dynamic>> sections) async {
    final prefs = await SharedPreferences.getInstance();
    final data = sections.map((section) {
      return {
        'title': section['title'],
        'tasks': section['tasks'],
        'completed': section['completed'] ?? List<bool>.filled((section['tasks'] as List).length, false),
      };
    }).toList();
    await prefs.setString(_key, jsonEncode(data));
  }

  Future<List<Map<String, dynamic>>> loadSections() async {
    final prefs = await SharedPreferences.getInstance();
    final String? sectionsJson = prefs.getString(_key);
    
    if (sectionsJson == null) return [];
    
    final List<dynamic> decoded = jsonDecode(sectionsJson);
    return decoded.map<Map<String, dynamic>>((item) => {
      'title': item['title'],
      'tasks': List<String>.from(item['tasks']),
      'completed': List<bool>.from(item['completed']),
    }).toList();
  }
}
