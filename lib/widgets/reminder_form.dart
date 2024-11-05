import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/reminder.dart';
import 'custom_form_field.dart';
import 'custom_date_picker.dart';
import 'custom_dialog.dart';

class ReminderForm extends StatefulWidget {
  final Function(Reminder) onSubmit;
  final Reminder? reminder;

  const ReminderForm({
    Key? key,
    required this.onSubmit,
    this.reminder,
  }) : super(key: key);

  @override
  State<ReminderForm> createState() => _ReminderFormState();
}

class _ReminderFormState extends State<ReminderForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titoloController;
  late final TextEditingController _descrizioneController;
  late final TextEditingController _dataController;
  late final TextEditingController _oraController;
  bool _isUrgent = false;

  @override
  void initState() {
    super.initState();
    _titoloController = TextEditingController(text: widget.reminder?.titolo);
    _descrizioneController = TextEditingController(text: widget.reminder?.descrizione);
    _dataController = TextEditingController(
      text: widget.reminder?.data != null 
          ? DateFormat('dd/MM/yyyy').format(widget.reminder!.data)
          : '',
    );
    _oraController = TextEditingController(
      text: widget.reminder?.ora != null 
          ? widget.reminder!.ora.format(context)
          : '',
    );
    _isUrgent = widget.reminder?.isUrgent ?? false;
  }

  @override
  void dispose() {
    _titoloController.dispose();
    _descrizioneController.dispose();
    _dataController.dispose();
    _oraController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      try {
        final data = DateFormat('dd/MM/yyyy').parse(_dataController.text);
        final ora = TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(_oraController.text));
        
        widget.onSubmit(
          Reminder(
            id: widget.reminder?.id ?? DateTime.now().toString(),
            titolo: _titoloController.text,
            descrizione: _descrizioneController.text,
            data: data,
            ora: ora,
            isUrgent: _isUrgent,
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Errore nel formato della data o dell\'ora'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: widget.reminder == null ? 'Nuovo Promemoria' : 'Modifica Promemoria',
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomFormField(
              controller: _titoloController,
              label: 'Titolo',
              icon: Icons.title,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            CustomFormField(
              controller: _descrizioneController,
              label: 'Descrizione',
              icon: Icons.description_outlined,
              maxLines: 3,
              isRequired: false,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomDatePicker(
                    controller: _dataController,
                    label: 'Data',
                    icon: Icons.calendar_today,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomDatePicker(
                    controller: _oraController,
                    label: 'Ora',
                    icon: Icons.access_time,
                    isTimePicker: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('Urgente'),
              value: _isUrgent,
              onChanged: (value) {
                setState(() {
                  _isUrgent = value ?? false;
                });
              },
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annulla'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(widget.reminder == null ? 'Aggiungi' : 'Modifica'),
        ),
      ],
    );
  }
}