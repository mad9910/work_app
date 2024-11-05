import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/riconciliazione.dart';
import '../widgets/custom_form_field.dart';
import '../widgets/custom_dialog.dart';
import '../services/bollini_storage.dart';

class CalcoloBollini extends StatefulWidget {
  const CalcoloBollini({Key? key}) : super(key: key);

  @override
  State<CalcoloBollini> createState() => _CalcoloBolliniState();
}

class _CalcoloBolliniState extends State<CalcoloBollini> {
  final _formKey = GlobalKey<FormState>();
  final List<Riconciliazione> _storico = [];
  
  final _primoController = TextEditingController();
  final _inMacchinaController = TextEditingController();
  final _pezziProdottiController = TextEditingController();
  final _scartiController = TextEditingController();
  final _campioneController = TextEditingController();
  final _primaPartitaController = TextEditingController(text: '0');
  final _bancaleController = TextEditingController();

  String _risultato = '';
  Color _risultatoColor = Colors.black;
  int? _risultatoNumerico;

  final _storage = BolliniStorage();

  @override
  void initState() {
    super.initState();
    _loadStorico();
  }

  Future<void> _loadStorico() async {
    final storico = await _storage.loadStorico();
    setState(() {
      _storico.clear();
      _storico.addAll(storico);
    });
  }

  Future<void> _saveStorico() async {
    await _storage.saveStorico(_storico);
  }

  @override
  void dispose() {
    _primoController.dispose();
    _inMacchinaController.dispose();
    _pezziProdottiController.dispose();
    _scartiController.dispose();
    _campioneController.dispose();
    _primaPartitaController.dispose();
    _bancaleController.dispose();
    super.dispose();
  }

  void _calcolaRisultato() {
    if (_formKey.currentState!.validate()) {
      final A = int.parse(_primoController.text);
      final B = int.parse(_inMacchinaController.text);
      final C = int.parse(_pezziProdottiController.text);
      final D = int.parse(_scartiController.text);
      final E = int.parse(_campioneController.text);
      final F = int.parse(_primaPartitaController.text);
      final G = int.parse(_bancaleController.text);

      final risultato = (A - B + F) - C - D - E;
      
      setState(() {
        _risultatoNumerico = risultato;
        if (risultato == 0) {
          _risultato = "Riconciliazione OK";
        } else if (risultato > 0) {
          _risultato = "${risultato.abs()} ${risultato.abs() == 1 ? 'bollino perso' : 'bollini persi'}";
        } else {
          _risultato = "${risultato.abs()} ${risultato.abs() == 1 ? 'astuccio senza bollino' : 'astucci senza bollini'}";
        }
        _risultatoColor = risultato == 0 
            ? Colors.green 
            : risultato < 0 
                ? Colors.red 
                : Colors.orange;
                
        final riconciliazione = Riconciliazione(
          id: DateTime.now().toString(),
          data: DateTime.now(),
          primo: A,
          inMacchina: B,
          pezziProdotti: C,
          scarti: D,
          campione: E,
          primaPartita: F,
          bancale: G,
          risultato: risultato,
        );
        _storico.add(riconciliazione);
        _saveStorico();
      });
    }
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    String? hint,
    bool readOnly = false,
  }) {
    return CustomFormField(
      controller: controller,
      label: label,
      icon: Icons.calculate_outlined,
      hint: hint,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      readOnly: readOnly,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Calcolo Bollini'),
          elevation: 0,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Calcolo'),
              Tab(text: 'Storico'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: _showInfoDialog,
              tooltip: 'Informazioni',
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _showResetFieldsConfirmation,
              tooltip: 'Reset Campi',
            ),
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: _showResetStoricoConfirmation,
              tooltip: 'Reset Storico',
            ),
          ],
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildInputField(
                      label: 'Primo',
                      controller: _primoController,
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      label: 'In Macchina',
                      controller: _inMacchinaController,
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      label: 'Pezzi Prodotti',
                      controller: _pezziProdottiController,
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      label: 'Scarti',
                      controller: _scartiController,
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      label: 'Campione',
                      controller: _campioneController,
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      label: 'Prima Partita',
                      controller: _primaPartitaController,
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      label: 'Bancale',
                      controller: _bancaleController,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _calcolaRisultato,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Calcola'),
                    ),
                    if (_risultato.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Text(
                        'Risultato: $_risultato',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: _risultatoColor,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            _buildStorico(),
          ],
        ),
      ),
    );
  }

  Widget _buildStorico() {
    if (_storico.isEmpty) {
      return const Center(
        child: Text('Nessun calcolo effettuato'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _storico.length,
      itemBuilder: (context, index) {
        final item = _storico[_storico.length - 1 - index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(
              DateFormat('dd/MM/yyyy HH:mm').format(item.data),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Risultato: ${item.risultato}',
                  style: TextStyle(
                    color: item.risultato == 0 
                        ? Colors.green 
                        : item.risultato < 0 
                            ? Colors.red 
                            : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Bancale: ${item.bancale}',
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () => _showDettagliDialog(item),
            ),
          ),
        );
      },
    );
  }

  void _showDettagliDialog(Riconciliazione item) {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: 'Dettagli Calcolo',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDettaglioRow('Data', DateFormat('dd/MM/yyyy HH:mm').format(item.data)),
            _buildDettaglioRow('Primo (A)', item.primo.toString()),
            _buildDettaglioRow('In Macchina (B)', item.inMacchina.toString()),
            _buildDettaglioRow('Pezzi Prodotti (C)', item.pezziProdotti.toString()),
            _buildDettaglioRow('Scarti (D)', item.scarti.toString()),
            _buildDettaglioRow('Campione (E)', item.campione.toString()),
            _buildDettaglioRow('Prima Partita (F)', item.primaPartita.toString()),
            _buildDettaglioRow('Bancale', item.bancale.toString()),
            const Divider(),
            _buildDettaglioRow(
              'Risultato',
              item.risultato.toString(),
              color: item.risultato == 0 
                  ? Colors.green 
                  : item.risultato < 0 
                      ? Colors.red 
                      : Colors.orange,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Chiudi'),
          ),
        ],
      ),
    );
  }

  Widget _buildDettaglioRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showResetFieldsConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Conferma Reset'),
        content: const Text('Vuoi davvero cancellare tutti i campi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annulla'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _primoController.clear();
                _inMacchinaController.clear();
                _pezziProdottiController.clear();
                _scartiController.clear();
                _campioneController.clear();
                _primaPartitaController.text = '0';
                _bancaleController.clear();
                _risultato = '';
                _risultatoColor = Colors.black;
                _risultatoNumerico = null;
              });
              Navigator.pop(context);
            },
            child: const Text('Conferma'),
          ),
        ],
      ),
    );
  }

  void _showResetStoricoConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Conferma Reset Storico'),
        content: const Text('Vuoi davvero cancellare tutto lo storico?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annulla'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _storico.clear();
                _saveStorico();
              });
              Navigator.pop(context);
            },
            child: const Text('Conferma'),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Informazioni Calcolo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Formula: (A - B + F) - C - D - E'),
            SizedBox(height: 16),
            Text('Dove:'),
            Text('A = Primo bollino della partita'),
            Text('B = Bollino in macchina'),
            Text('C = Pezzi prodotti'),
            Text('D = Bollini scartati'),
            Text('E = Bollini a campione'),
            Text('F = Prima partita (default: 0)'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Chiudi'),
          ),
        ],
      ),
    );
  }
}