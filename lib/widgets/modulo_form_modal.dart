import 'package:flutter/material.dart';
import '../models/modulo.dart';

class ModuloFormModal extends StatefulWidget {
  final Function(Modulo) onSubmit;
  
  const ModuloFormModal({
    Key? key,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<ModuloFormModal> createState() => _ModuloFormModalState();
}

class _ModuloFormModalState extends State<ModuloFormModal> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _codiceController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _codiceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nuovo Modulo'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Inserire un nome';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _codiceController,
              decoration: const InputDecoration(
                labelText: 'Codice',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Inserire un codice';
                }
                return null;
              },
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
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSubmit(
                Modulo(
                  id: DateTime.now().toString(),
                  nome: _nomeController.text,
                  codice: _codiceController.text,
                ),
              );
              Navigator.pop(context);
            }
          },
          child: const Text('Salva'),
        ),
      ],
    );
  }
} 