import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/modulo.dart';
import '../widgets/modulo_form_modal.dart';
import '../services/storage_service.dart';

class ModuliSection extends StatefulWidget {
  const ModuliSection({Key? key}) : super(key: key);

  @override
  State<ModuliSection> createState() => _ModuliSectionState();
}

class _ModuliSectionState extends State<ModuliSection> {
  final List<Modulo> _moduli = [];
  late final StorageService _storage;

  @override
  void initState() {
    super.initState();
    _initStorage();
  }

  Future<void> _initStorage() async {
    final prefs = await SharedPreferences.getInstance();
    _storage = StorageService(prefs);
    final moduli = await _storage.getModuli();
    setState(() {
      _moduli.addAll(moduli);
    });
  }

  Future<void> _addModulo(Modulo modulo) async {
    setState(() {
      _moduli.add(modulo);
      _moduli.sort((a, b) => a.codice.compareTo(b.codice));
    });
    await _storage.saveModuli(_moduli);
  }

  Future<void> _deleteModulo(int index) async {
    setState(() {
      _moduli.removeAt(index);
    });
    await _storage.saveModuli(_moduli);
  }

  void _showAddModuloDialog() {
    showDialog(
      context: context,
      builder: (context) => ModuloFormModal(
        onSubmit: _addModulo,
      ),
    );
  }

  void _showDeleteConfirmation(int index, Modulo modulo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Conferma Eliminazione'),
        content: Text('Vuoi davvero eliminare il modulo "${modulo.nome}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annulla'),
          ),
          ElevatedButton(
            onPressed: () {
              _deleteModulo(index);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
            ),
            child: const Text('Elimina'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moduli'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _moduli.isEmpty
          ? const Center(
              child: Text('Nessun modulo aggiunto'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _moduli.length,
              itemBuilder: (context, index) {
                final modulo = _moduli[index];
                return Card(
                  child: ListTile(
                    title: Text(modulo.nome),
                    subtitle: Text('Codice: ${modulo.codice}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _showDeleteConfirmation(index, modulo),
                      color: Colors.red,
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddModuloDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}