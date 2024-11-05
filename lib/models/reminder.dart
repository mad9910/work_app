import 'package:flutter/material.dart';

class Reminder {
  final String id;
  final String titolo;
  final String descrizione;
  final DateTime data;
  final TimeOfDay ora;
  final bool isUrgent;
  bool isCompleted;

  Reminder({
    required this.id,
    required this.titolo,
    required this.descrizione,
    required this.data,
    required this.ora,
    this.isUrgent = false,
    this.isCompleted = false,
  });

  factory Reminder.fromJson(Map<String, dynamic> json) {
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titolo': titolo,
      'descrizione': descrizione,
      'data': data.toIso8601String(),
      'ora': {
        'hour': ora.hour,
        'minute': ora.minute,
      },
      'isUrgent': isUrgent,
      'isCompleted': isCompleted,
    };
  }

  bool get isToday {
    final now = DateTime.now();
    return data.year == now.year && 
           data.month == now.month && 
           data.day == now.day;
  }

  bool get isExpired {
    final now = DateTime.now();
    final reminderDateTime = DateTime(
      data.year, data.month, data.day,
      ora.hour, ora.minute,
    );
    return reminderDateTime.isBefore(now) && !isToday;
  }

  ReminderStatus get status {
    if (isUrgent) return ReminderStatus.urgent;
    if (isToday) return ReminderStatus.today;
    if (isExpired) return ReminderStatus.expired;
    return ReminderStatus.todo;
  }
}

enum ReminderStatus {
  urgent,
  today,
  expired,
  todo,
}