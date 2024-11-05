import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';  // Corretto
import '../models/reminder.dart';

class ReminderStorage {
  static const String _key = 'reminders';

  ReminderStorage();

  Future<List<Reminder>> loadReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final String? remindersJson = prefs.getString(_key);
    
    if (remindersJson == null) return [];

    final List<dynamic> decodedList = json.decode(remindersJson);
    return decodedList.map((item) => Reminder.fromJson(item)).toList();
  }

  Future<void> saveReminders(List<Reminder> reminders) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedList = json.encode(
      reminders.map((reminder) => reminder.toJson()).toList(),
    );
    await prefs.setString(_key, encodedList);
  }
}