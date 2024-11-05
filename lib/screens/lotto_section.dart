import 'package:flutter/material.dart';
import '../services/lotto_storage.dart';

class LottoSection extends StatefulWidget {
  const LottoSection({Key? key}) : super(key: key);

  @override
  State<LottoSection> createState() => _LottoSectionState();
}

class _LottoSectionState extends State<LottoSection> with SingleTickerProviderStateMixin {
  final LottoStorage _storage = LottoStorage();
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> sections = [
    {
      'title': 'Autorizzazione alla partenza filling',
      'tasks': [
        'Controllo ODP',
        'Compilazione sezione filtri',
        'Controllo lavaggi ima e compilazione sezione BR',
        'Controllo tronchetto e compilazione sezione BR',
        'Controllo e applicazione sul BR delle etichette del pulito',
        'Verifica foglio preparazione',
        'Compilazione moduli conte',
        'Compilazione foglietto lavorazione',
        'Impostazione lotto sulla bilancia e compilazione sezione BR',
        'Compilazione logbook primario',
        'Compilazione i test di sicurezza',
        'Controllo conte',
        'Dare autorizzazione e compilare B.R. e ODP',
      ],
      'completed': <bool>[],
    },
    {
      'title': 'Autorizzazione alla partenza pack',
      'tasks': [
        'Controllo ODP',
        'Controllo materiali',
        'Controllo foglio acqua',
        'Compilazione checklist lineclearance e sezione BR',
        'Lancio ordine da GTS e compilazione sezione foglio meccanico',
        'Assegnazione ordine alla linea',
        'Compilazione checklist meccanico',
        'Fare esemplari',
        'Allegare esemplari a BR e foglio meccanico',
      ],
      'completed': <bool>[],
    },
    {
      'title': 'Partenza filling',
      'tasks': [
        'Prendere campioni e compilazione sezione BR',
        'Compilare messa in billa bilancia',
        'Compilare logbook test tenuta',
        'Compilazione test di sfida',
        'Stampa graffico pressioni e compilazione sezione BR + verifica',
      ],
      'completed': <bool>[],
    },
    {
      'title': 'Partenza pack',
      'tasks': [
        'Prendere campioni e compilazione sezione BR',
        'Controllo prima scatola',
      ],
      'completed': <bool>[],
    },
    {
      'title': 'Fine filling',
      'tasks': [
        'Prendere i campioni e compilazione sezione BR',
        'Eseguire ultima pesata',
        'Compilazione messa in bolla fine ripartizione + verifica',
        'Chiusura lotto su bilancia e compilazione sezione BR',
        'Stampa report pesate',
        'Compilazione modulo scarti tenuta',
        'Compilazione orario fine su BR logbook e ODP + pezzi prodotti',
        'Chiusura ordine da antares',
        'Ritirare foglietti lavorazione',
        'Compilazione modulo resi',
        'Verifica campioni su BR e compilazione logbook',
        'Eseguire lineclearance e compilare logbook',
        'Eseguire pulizia e compilare logbook ed etichette del pulito',
        'Effettuare controllo lineclearance e compilazione logbook',
      ],
      'completed': <bool>[],
    },
    {
      'title': 'Fine pack',
      'tasks': [
        'Compilazione orario fine su BR logbook e ODP + pezzi prodotti',
        'Chiusura ordine da antares',
        'Ritirare foglietti lavorazione',
        'Compilazione modulo resi',
        'Verifica campioni su BR e compilazione logbook',
        'Eseguire lineclearance e compilare logbook',
        'Eseguire pulizia e compilare logbook ed etichette del pulito',
        'Effettuare controllo lineclearance e compilazione logbook',
      ],
      'completed': <bool>[],
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attività Lotto'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showInfoDialog,
            tooltip: 'Informazioni',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _showResetConfirmation,
            tooltip: 'Reset Campi',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                itemCount: sections.length,
                itemBuilder: (context, index) {
                  final section = sections[index];
                  final progress = _calculateProgress(section['completed'] as List<bool>);
                  final isComplete = progress == 1.0;
                  
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      child: Card(
                        elevation: _selectedIndex == index ? 8 : 2,
                        color: isComplete 
                            ? Colors.green 
                            : _selectedIndex == index 
                                ? Colors.blue 
                                : Colors.white,
                        child: Container(
                          width: 160,
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                section['title'] as String,
                                style: TextStyle(
                                  color: (isComplete || _selectedIndex == index) ? Colors.white : Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: progress,
                                backgroundColor: Colors.white24,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  isComplete ? Colors.white : Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${(progress * 100).toInt()}%',
                                style: TextStyle(
                                  color: (isComplete || _selectedIndex == index) ? Colors.white : Colors.black87,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: _buildTaskList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList() {
    final section = sections[_selectedIndex];
    final tasks = section['tasks'] as List<String>;
    final completed = section['completed'] as List<bool>;
    
    if (completed.length != tasks.length) {
      completed.addAll(List.filled(tasks.length - completed.length, false));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final isCompleted = completed[index];
          
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 4),
            color: isCompleted ? Colors.green : Colors.blue,
            child: ListTile(
              title: Text(
                tasks[index],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              trailing: Checkbox(
                value: completed[index],
                onChanged: (value) {
                  setState(() {
                    completed[index] = value!;
                    _saveState();
                  });
                },
                checkColor: Colors.white,
                fillColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return Colors.white24;
                    }
                    return Colors.white38;
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  double _calculateProgress(List<bool> completed) {
    if (completed.isEmpty) return 0.0;
    int completedCount = completed.where((item) => item).length;
    return completedCount / completed.length;
  }

  Future<void> _loadSavedState() async {
    final savedSections = await _storage.loadSections();
    if (savedSections.isNotEmpty) {
      setState(() {
        for (var i = 0; i < sections.length; i++) {
          if (i < savedSections.length) {
            sections[i]['completed'] = savedSections[i]['completed'];
          }
        }
      });
    }
  }

  void _saveState() {
    _storage.saveSections(sections);
  }

  void _showResetConfirmation() {
    final currentIndex = _selectedIndex;
    final currentSection = sections[currentIndex];
    
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Conferma Reset'),
        content: Text('Vuoi davvero resettare la sezione "${currentSection['title']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annulla'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final tasks = currentSection['tasks'] as List<String>;
                currentSection['completed'] = List<bool>.filled(tasks.length, false);
                _saveState();
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
        title: const Text('Informazioni'),
        content: const Text('Seleziona le attività completate per tenere traccia del progresso.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Chiudi'),
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
        content: const Text('Vuoi davvero resettare tutte le selezioni della sezione corrente?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annulla'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final currentSection = sections[_selectedIndex];
                currentSection['completed'] = List<bool>.filled(
                  (currentSection['tasks'] as List<String>).length,
                  false,
                );
                _storage.saveSections(sections);
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
            ),
            child: const Text('Reset'),
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
        content: const Text('Vuoi davvero resettare tutte le selezioni di tutte le sezioni?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annulla'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                for (var section in sections) {
                  section['completed'] = List<bool>.filled(
                    (section['tasks'] as List<String>).length,
                    false,
                  );
                }
                _storage.saveSections(sections);
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}