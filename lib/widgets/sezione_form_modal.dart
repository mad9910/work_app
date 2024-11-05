import 'package:flutter/material.dart';
import '../models/sezione.dart';

class SezioneFormModal extends StatefulWidget {
  final Function(Sezione) onSubmit;

  const SezioneFormModal({
    Key? key,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<SezioneFormModal> createState() => _SezioneFormModalState();
}

class _SezioneFormModalState extends State<SezioneFormModal> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _descrizioneController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _descrizioneController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final sezione = Sezione(
        id: DateTime.now().toString(),
        nome: _nomeController.text,
        descrizione: _descrizioneController.text.isEmpty 
            ? null 
            : _descrizioneController.text,
      );
      widget.onSubmit(sezione);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nuova Sezione'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome',
                hintText: 'Inserisci il nome della sezione',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Inserisci un nome';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descrizioneController,
              decoration: const InputDecoration(
                labelText: 'Descrizione (opzionale)',
                hintText: 'Inserisci una descrizione',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annulla'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Salva'),
        ),
      ],
    );
  }
}