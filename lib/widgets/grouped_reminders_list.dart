import 'package:flutter/material.dart';
import '../models/reminder.dart';
import 'reminder_card.dart';

class GroupedRemindersList extends StatelessWidget {
  final List<Reminder> reminders;
  final Function(Reminder) onToggle;
  final Function(Reminder) onDelete;

  const GroupedRemindersList({
    Key? key,
    required this.reminders,
    required this.onToggle,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reminders.length,
      itemBuilder: (context, index) {
        final reminder = reminders[index];
        final showHeader = index == 0 || 
            reminder.status != reminders[index - 1].status;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showHeader)
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: _buildHeader(context, reminder.status),
              ),
            ReminderCard(
              reminder: reminder,
              onToggle: () => onToggle(reminder),
              onDelete: () => onDelete(reminder),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, ReminderStatus status) {
    Color color;
    String text;

    switch (status) {
      case ReminderStatus.urgent:
        color = Colors.orange;
        text = 'Urgenti';
        break;
      case ReminderStatus.today:
        color = Colors.green;
        text = 'Oggi';
        break;
      case ReminderStatus.expired:
        color = Colors.red;
        text = 'Scaduti';
        break;
      case ReminderStatus.todo:
        color = Colors.grey;
        text = 'Da Fare';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
