import 'package:flutter/material.dart';
import '../models/numero.dart';
import '../models/sezione.dart';
import 'custom_form_field.dart';
import 'custom_dropdown.dart';
import 'custom_dialog.dart';

class NumeroFormModal extends StatefulWidget {
  final Function(Numero) onSubmit;
  final List<Sezione> sezioni;
  final Numero? numero;

  const NumeroFormModal({
    Key? key,
    required this.onSubmit,
    required this.sezioni,
    this.numero,
  }) : super(key: key);

  @override
  State<NumeroFormModal> createState() => _NumeroFormModalState();
}

class _NumeroFormModalState extends State<NumeroFormModal> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomeController;
  late final TextEditingController _telefonoController;
  String? _selectedSezioneId;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.numero?.nome);
    _telefonoController = TextEditingController(text: widget.numero?.telefono);
    _selectedSezioneId = widget.numero?.sezioneId;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedSezioneId != null) {
      widget.onSubmit(
        Numero(
          id: widget.numero?.id ?? DateTime.now().toString(),
          nome: _nomeController.text,
          telefono: _telefonoController.text,
          sezioneId: _selectedSezioneId!,
        ),
      );
      Navigator.pop(context);
    } else if (_selectedSezioneId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Seleziona una sezione'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: widget.numero == null ? 'Nuovo Contatto' : 'Modifica Contatto',
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomFormField(
              controller: _nomeController,
              label: 'Nome',
              icon: Icons.person_outline,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            CustomFormField(
              controller: _telefonoController,
              label: 'Telefono',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            CustomDropdown(
              value: _selectedSezioneId,
              label: 'Sezione',
              icon: Icons.folder_outlined,
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('Nessuna sezione'),
                ),
                ...widget.sezioni.map((sezione) => DropdownMenuItem(
                      value: sezione.id,
                      child: Text(sezione.nome),
                    )),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedSezioneId = value;
                });
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
          onPressed: _submitForm,
          child: Text(widget.numero == null ? 'Aggiungi' : 'Salva'),
        ),
      ],
    );
  }
}