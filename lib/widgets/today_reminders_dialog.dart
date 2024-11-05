import 'package:flutter/material.dart';
import '../models/reminder.dart';
import 'package:intl/intl.dart';

class TodayRemindersDialog extends StatelessWidget {
  final List<Reminder> reminders;

  const TodayRemindersDialog({
    Key? key,
    required this.reminders,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reminder di Oggi'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: reminders.map((reminder) {
            return ListTile(
              title: Text(reminder.titolo),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(reminder.descrizione),
                  Text(
                    'Ora: ${reminder.ora.format(context)}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              leading: Icon(
                Icons.circle,
                color: reminder.isUrgent ? Colors.red : Colors.blue,
                size: 12,
              ),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Chiudi'),
        ),
      ],
    );
  }
}