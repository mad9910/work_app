import 'package:flutter/material.dart';
import '../models/numero.dart' show Numero;
import '../models/sezione.dart' show Sezione;
import '../widgets/numero_form_modal.dart';
import '../widgets/sezione_form_modal.dart';
import '../services/numeri_storage.dart';

class NumeriSection extends StatefulWidget {
  final List<Numero> numeri;
  final Function(Numero) onAdd;
  final Function(String) onDelete;

  const NumeriSection({
    Key? key,
    required this.numeri,
    required this.onAdd,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<NumeriSection> createState() => _NumeriSectionState();
}

class _NumeriSectionState extends State<NumeriSection> {
  final List<Sezione> _sezioni = [];
  String? _selectedSezioneId;
  late List<Numero> _numeriLocali;
  final _storage = NumeriStorage();

  @override
  void initState() {
    super.initState();
    _loadSavedState();
  }

  Future<void> _loadSavedState() async {
    final numeri = await _storage.loadNumeri();
    final sezioni = await _storage.loadSezioni();
    setState(() {
      _numeriLocali = numeri;
      _sezioni.clear();
      _sezioni.addAll(sezioni);
    });
  }

  @override
  void didUpdateWidget(NumeriSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.numeri != widget.numeri) {
      setState(() {
        _numeriLocali = List.from(widget.numeri);
      });
    }
  }

  void _showAddNumeroDialog() {
    showDialog(
      context: context,
      builder: (context) => NumeroFormModal(
        onSubmit: (numero) async {
          widget.onAdd(numero);
          setState(() {
            _numeriLocali.add(numero);
          });
          await _storage.saveNumeri(_numeriLocali);
        },
        sezioni: _sezioni,
      ),
    );
  }

  void _showAddSezioneDialog() {
    showDialog(
      context: context,
      builder: (context) => SezioneFormModal(
        onSubmit: (sezione) async {
          setState(() {
            _sezioni.add(sezione);
          });
          await _storage.saveSezioni(_sezioni);
        },
      ),
    );
  }

  List<Numero> _getFilteredNumeri() {
    if (_selectedSezioneId == null) {
      return List.from(_numeriLocali)..sort((a, b) => a.nome.compareTo(b.nome));
    }
    return _numeriLocali
        .where((n) => n.sezioneId == _selectedSezioneId)
        .toList()
      ..sort((a, b) => a.nome.compareTo(b.nome));
  }

  void _showDeleteConfirmation(Numero numero) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Conferma eliminazione'),
        content: Text('Sei sicuro di voler eliminare il contatto ${numero.nome}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annulla'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              widget.onDelete(numero.id);
              setState(() {
                _numeriLocali.removeWhere((n) => n.id == numero.id);
              });
              await _storage.saveNumeri(_numeriLocali);
              if (context.mounted) Navigator.of(context).pop();
            },
            child: const Text('Elimina'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredNumeri = _getFilteredNumeri();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rubrica'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.create_new_folder),
            onPressed: _showAddSezioneDialog,
            tooltip: 'Nuova Sezione',
          ),
        ],
      ),
      body: Column(
        children: [
          if (_sezioni.isNotEmpty)
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FilterChip(
                      label: const Text('Tutti'),
                      selected: _selectedSezioneId == null,
                      onSelected: (selected) {
                        setState(() {
                          _selectedSezioneId = null;
                        });
                      },
                    ),
                  ),
                  ..._sezioni.map((sezione) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FilterChip(
                          label: Text(sezione.nome),
                          selected: _selectedSezioneId == sezione.id,
                          onSelected: (selected) {
                            setState(() {
                              _selectedSezioneId = selected ? sezione.id : null;
                            });
                          },
                        ),
                      )),
                ],
              ),
            ),
          Expanded(
            child: filteredNumeri.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.contacts_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Nessun contatto',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredNumeri.length,
                    itemBuilder: (context, index) {
                      final numero = filteredNumeri[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            child: Text(
                              numero.nome[0].toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(numero.nome),
                          subtitle: Text(numero.telefono),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () => _showDeleteConfirmation(numero),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddNumeroDialog,
        icon: const Icon(Icons.add),
        label: const Text('Nuovo Contatto'),
      ),
    );
  }
}