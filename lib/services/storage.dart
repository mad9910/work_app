import 'dart:convert';
import 'package:shared_preferences.dart';
import '../models/reminder.dart';

class ReminderStorage {
  static const String _key = 'reminders';
  final SharedPreferences _prefs;

  ReminderStorage(this._prefs);

  Future<List<Reminder>> loadReminders() async {
    final String? data = _prefs.getString(_key);
    if (data == null) return [];

    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((json) => _reminderFromJson(json)).toList();
  }

  Future<void> saveReminders(List<Reminder> reminders) async {
    final List<Map<String, dynamic>> jsonList = 
        reminders.map((r) => _reminderToJson(r)).toList();
    await _prefs.setString(_key, json.encode(jsonList));
  }

  Map<String, dynamic> _reminderToJson(Reminder reminder) {
    return {
      'id': reminder.id,
      'titolo': reminder.titolo,
      'descrizione': reminder.descrizione,
      'data': reminder.data.toIso8601String(),
      'ora': {'hour': reminder.ora.hour, 'minute': reminder.ora.minute},
      'isUrgent': reminder.isUrgent,
      'isCompleted': reminder.isCompleted,
    };
  }

  Reminder _reminderFromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'],
      titolo: json['titolo'],
      descrizione: json['descrizione'],
      data: DateTime.parse(json['data']),
      ora: TimeOfDay(
        hour: json['ora']['hour'],
        minute: json['ora']['minute'],
      ),
      isUrgent: json['isUrgent'],
      isCompleted: json['isCompleted'],
    );
  }
} 