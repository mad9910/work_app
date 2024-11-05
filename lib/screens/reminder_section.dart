import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/reminder.dart';
import '../widgets/reminder_form.dart';
import '../widgets/reminder_card.dart';
import '../widgets/today_reminders_dialog.dart';
import '../services/reminder_storage.dart';
import '../widgets/grouped_reminders_list.dart';

class ReminderSection extends StatefulWidget {
  const ReminderSection({Key? key}) : super(key: key);

  @override
  State<ReminderSection> createState() => _ReminderSectionState();
}

class _ReminderSectionState extends State<ReminderSection> {
  final List<Reminder> _items = [];
  late final ReminderStorage _storage;

  @override
  void initState() {
    super.initState();
    _storage = ReminderStorage();
    _initStorage();
  }

  Future<void> _initStorage() async {
    final reminders = await _storage.loadReminders();
    setState(() {
      _items.addAll(reminders);
      _sortItems();
    });
  }

  void _sortItems() {
    _items.sort((a, b) {
      final statusComparison = a.status.index.compareTo(b.status.index);
      if (statusComparison != 0) return statusComparison;

      final dateComparison = b.data.compareTo(a.data);
      if (dateComparison != 0) return dateComparison;

      final aTime = a.ora.hour * 60 + a.ora.minute;
      final bTime = b.ora.hour * 60 + b.ora.minute;
      return bTime.compareTo(aTime);
    });
  }

  void _showEditDialog(Reminder reminder) {
    showDialog(
      context: context,
      builder: (context) => ReminderForm(
        reminder: reminder,
        onSubmit: (updatedReminder) {
          setState(() {
            final index = _items.indexWhere((item) => item.id == reminder.id);
            if (index != -1) {
              _items[index] = updatedReminder;
              _sortItems();
            }
          });
          _storage.saveReminders(_items);
        },
      ),
    );
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => ReminderForm(
        onSubmit: (reminder) {
          setState(() {
            _items.add(reminder);
            _sortItems();
          });
          _storage.saveReminders(_items);
        },
      ),
    );
  }

  void _showClearCompletedConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Conferma Rimozione'),
        content: const Text('Vuoi davvero rimuovere tutti i promemoria completati?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annulla'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _items.removeWhere((item) => item.isCompleted);
                _storage.saveReminders(_items);
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
            ),
            child: const Text('Rimuovi'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Promemoria'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => TodayRemindersDialog(reminders: _items),
              );
            },
            tooltip: 'Promemoria di oggi',
          ),
          IconButton(
            icon: const Icon(Icons.cleaning_services),
            onPressed: _showClearCompletedConfirmation,
            tooltip: 'Rimuovi completati',
          ),
        ],
      ),
      body: _items.isEmpty
          ? const Center(
              child: Text('Nessun promemoria'),
            )
          : GroupedRemindersList(
              reminders: _items,
              onToggle: (reminder) {
                setState(() {
                  reminder.isCompleted = !reminder.isCompleted;
                  _storage.saveReminders(_items);
                  _sortItems();
                });
              },
              onDelete: (reminder) {
                setState(() {
                  _items.remove(reminder);
                  _storage.saveReminders(_items);
                });
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDialog,
        icon: const Icon(Icons.add),
        label: const Text('Nuovo'),
      ),
    );
  }
}