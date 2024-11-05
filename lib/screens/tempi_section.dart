import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/custom_form_field.dart';
import '../widgets/custom_date_picker.dart';
import '../widgets/custom_time_picker.dart';

class TempiSection extends StatefulWidget {
  const TempiSection({Key? key}) : super(key: key);

  @override
  State<TempiSection> createState() => _TempiSectionState();
}

class _TempiSectionState extends State<TempiSection> {
  final _formKey = GlobalKey<FormState>();
  final _inizioDataController = TextEditingController();
  final _inizioOraController = TextEditingController();
  final _fineDataController = TextEditingController();
  final _fineOraController = TextEditingController();
  String _risultatoFillingTime = '';

  final _puliziaDataController = TextEditingController();
  final _puliziaOraController = TextEditingController();
  String _risultatoScadenza = '';

  @override
  void dispose() {
    _inizioDataController.dispose();
    _inizioOraController.dispose();
    _fineDataController.dispose();
    _fineOraController.dispose();
    _puliziaDataController.dispose();
    _puliziaOraController.dispose();
    super.dispose();
  }

  void _calcolaFillingTime() {
    try {
      final inizioData = DateFormat('dd/MM/yyyy').parse(_inizioDataController.text);
      final inizioOra = TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(_inizioOraController.text));
      final fineData = DateFormat('dd/MM/yyyy').parse(_fineDataController.text);
      final fineOra = TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(_fineOraController.text));

      final inizio = DateTime(
        inizioData.year,
        inizioData.month,
        inizioData.day,
        inizioOra.hour,
        inizioOra.minute,
      );

      final fine = DateTime(
        fineData.year,
        fineData.month,
        fineData.day,
        fineOra.hour,
        fineOra.minute,
      );

      final differenza = fine.difference(inizio);
      final ore = differenza.inHours;
      final minuti = differenza.inMinutes.remainder(60);

      setState(() {
        _risultatoFillingTime = '$ore ore e $minuti minuti';
      });
    } catch (e) {
      setState(() {
        _risultatoFillingTime = 'Errore nel calcolo';
      });
    }
  }

  void _calcolaScadenzaPulizia() {
    try {
      final puliziaData = DateFormat('dd/MM/yyyy').parse(_puliziaDataController.text);
      final puliziaOra = TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(_puliziaOraController.text));

      final inizioPulizia = DateTime(
        puliziaData.year,
        puliziaData.month,
        puliziaData.day,
        puliziaOra.hour,
        puliziaOra.minute,
      );

      final scadenza = inizioPulizia.add(const Duration(hours: 87));

      setState(() {
        _risultatoScadenza = 'Scadenza: ${DateFormat('dd/MM/yyyy HH:mm').format(scadenza)}';
      });
    } catch (e) {
      setState(() {
        _risultatoScadenza = 'Errore nel calcolo';
      });
    }
  }

  Widget _buildDateTimeFields({
    required String dateLabel,
    required String timeLabel,
    required TextEditingController dateController,
    required TextEditingController timeController,
  }) {
    return Row(
      children: [
        Expanded(
          child: CustomDatePicker(
            controller: dateController,
            label: dateLabel,
            icon: Icons.calendar_today,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CustomTimePicker(
            controller: timeController,
            label: timeLabel,
            icon: Icons.access_time,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Calcolo Tempi'),
          elevation: 0,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Filling Time'),
              Tab(text: 'Scadenza Pulizia'),
            ],
          ),
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
                    _buildDateTimeFields(
                      dateLabel: 'Data Inizio',
                      timeLabel: 'Orario Inizio',
                      dateController: _inizioDataController,
                      timeController: _inizioOraController,
                    ),
                    const SizedBox(height: 24),
                    _buildDateTimeFields(
                      dateLabel: 'Data Fine',
                      timeLabel: 'Orario Fine',
                      dateController: _fineDataController,
                      timeController: _fineOraController,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _calcolaFillingTime,
                      icon: const Icon(Icons.calculate),
                      label: const Text('Calcola Filling Time'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    if (_risultatoFillingTime.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            _risultatoFillingTime,
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildDateTimeFields(
                      dateLabel: 'Data Pulizia',
                      timeLabel: 'Orario Pulizia',
                      dateController: _puliziaDataController,
                      timeController: _puliziaOraController,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _calcolaScadenzaPulizia,
                      icon: const Icon(Icons.calculate),
                      label: const Text('Calcola Scadenza'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    if (_risultatoScadenza.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            _risultatoScadenza,
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}