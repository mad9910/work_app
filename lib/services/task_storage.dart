import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_section.dart';

class TaskStorage {
  static const String _key = 'task_sections';

  Future<List<TaskSection>> loadSections() async {
    final prefs = await SharedPreferences.getInstance();
    final String? sectionsJson = prefs.getString(_key);
    
    if (sectionsJson == null) return _createDefaultSections();

    final List<dynamic> decodedList = json.decode(sectionsJson);
    return decodedList.map((item) => TaskSection.fromJson(item)).toList();
  }

  Future<void> saveSections(List<TaskSection> sections) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedList = json.encode(
      sections.map((section) => section.toJson()).toList(),
    );
    await prefs.setString(_key, encodedList);
  }

  List<TaskSection> _createDefaultSections() {
    return [
      TaskSection(
        title: 'Autorizzazione alla partenza filling',
        tasks: [
          Task(id: '1.1', description: 'Calibrazione bilancia e compilazione logbook e sezione BR'),
          Task(id: '1.2', description: 'Compilazione sezione filtri'),
          Task(id: '1.3', description: 'Controllo lavaggi ima e compilazione sezione BR'),
          Task(id: '1.4', description: 'Controllo tronchetto e compilazione sezione BR'),
          Task(id: '1.5', description: 'Controllo e applicazione sul BR delle etichette del pulito'),
          Task(id: '1.6', description: 'Verifica foglio preparazione'),
          Task(id: '1.7', description: 'Compilazione moduli conte'),
          Task(id: '1.8', description: 'Compilazione foglietto lavorazione'),
          Task(id: '1.9', description: 'Impostazione lotto sulla bilancia e compilazione sezione BR'),
          Task(id: '1.10', description: 'Compilazione logbook primario'),
          Task(id: '1.11', description: 'Compilazione i test di sicurezza'),
          Task(id: '1.12', description: 'Controllo conte'),
          Task(id: '1.13', description: 'Dare autorizzazione e compilare B.R. e ODP'),
        ],
      ),
      TaskSection(
        title: 'Autorizzazione alla partenza pack',
        tasks: [
          Task(id: '2.1', description: 'Controllo ODP'),
          Task(id: '2.2', description: 'Controllo materiali'),
          Task(id: '2.3', description: 'Controllo foglio acqua'),
          Task(id: '2.4', description: 'Compilazione checklist lineclearance e sezione BR'),
          Task(id: '2.5', description: 'Lancio ordine da GTS e compilazione sezione foglio meccanico'),
          Task(id: '2.6', description: 'Assegnazione ordine alla linea'),
          Task(id: '2.7', description: 'Compilazione checklist meccanico'),
          Task(id: '2.8', description: 'Fare esemplari'),
          Task(id: '2.9', description: 'Allegare esemplari a BR e foglio meccanico'),
          Task(id: '2.10', description: 'Controllo antares e compilazione trasmissione dati'),
          Task(id: '2.11', description: 'Compilazione logbook axicon se utilizzato'),
          Task(id: '2.12', description: 'Calibrazione bilancia e compilazione logbook'),
          Task(id: '2.13', description: 'Compilazione trasmissione dati e allegare esemplari'),
          Task(id: '2.14', description: 'Compilazione foglio bancali'),
          Task(id: '2.15', description: 'Compilazione foglio scarti'),
          Task(id: '2.16', description: 'Compilazione foglietti lavorazione'),
          Task(id: '2.17', description: 'Compilazione foglietti scarti'),
          Task(id: '2.18', description: 'Compilazione logbook secondario'),
          Task(id: '2.19', description: 'Esecuzione test di sicurezza e compilazione sezione logbook secondario/bilancia ponderale e sezione BR se presente'),
          Task(id: '2.20', description: 'Esecuzione test di sfida e compilazione logbook e sezione BR se presente'),
          Task(id: '2.21', description: 'Impostazione peso bilancia ponderale e compilazione sezione BR'),
          Task(id: '2.22', description: 'Autorizzare la partenza e compilare BR trasmissione dati e logbook secondario'),
        ],
      ),
      TaskSection(
        title: 'Partenza filling',
        tasks: [
          Task(id: '3.1', description: 'Scartare, compilare modulo scarti e sezione BR'),
          Task(id: '3.2', description: 'Prendere i campioni e compilare la sezione BR'),
          Task(id: '3.3', description: 'Fare prima pesata e tenuta e compilare sezioni BR (tenuta e controllo)'),
          Task(id: '3.4', description: 'Compilare messa in billa bilancia'),
          Task(id: '3.5', description: 'Compilare logbook test tenuta'),
          Task(id: '3.6', description: 'Compilazione test di sfida'),
          Task(id: '3.7', description: 'Stampa graffico pressioni e compilazione sezione BR + verifica'),
        ],
      ),
      TaskSection(
        title: 'Partenza pack',
        tasks: [
          Task(id: '4.1', description: 'Prendere campioni e compilazione sezione BR'),
          Task(id: '4.2', description: 'Controllo prima scatola'),
        ],
      ),
      TaskSection(
        title: 'Fine filling',
        tasks: [
          Task(id: '5.1', description: 'Prendere i campioni e compilazione sezione BR'),
          Task(id: '5.2', description: 'Eseguire ultima pesata'),
          Task(id: '5.3', description: 'Compilazione messa in bolla fine ripartizione + verifica'),
          Task(id: '5.4', description: 'Chiusura lotto su bilancia e compilazione sezione BR'),
          Task(id: '5.5', description: 'Stampa report pesate'),
          Task(id: '5.6', description: 'Compilazione modulo scarti tenuta'),
          Task(id: '5.7', description: 'Ritiro foglietto lavorazione e foglio preparazione'),
          Task(id: '5.8', description: 'Compilazione orario fine su logbook'),
          Task(id: '5.9', description: 'Svuotare scarti IMA'),
          Task(id: '5.10', description: 'Stampare le conte'),
          Task(id: '5.11', description: 'Chiudere il passaggio flaconi tra sterile e fuori'),
        ],
      ),
      TaskSection(
        title: 'Fine pack',
        tasks: [
          Task(id: '6.1', description: 'Prendere i campioni e compilazione sezione BR'),
          Task(id: '6.2', description: 'Compilazione modulo riconciliazione e F.M. su BR'),
          Task(id: '6.3', description: 'Svuotare incartonatrice'),
          Task(id: '6.4', description: 'Fare ultimo controllo'),
          Task(id: '6.5', description: 'Allegare esemplari di fine e compilare sezione BR'),
          Task(id: '6.6', description: 'Allegare ultima etichetta'),
          Task(id: '6.7', description: 'Applicare etichetta scatola incompleta se necessaria'),
          Task(id: '6.8', description: 'Compilazione orario fine su BR logbook e ODP + pezzi prodotti'),
          Task(id: '6.9', description: 'Chiusura ordine da antares'),
          Task(id: '6.10', description: 'Ritirare foglietti lavorazione'),
          Task(id: '6.11', description: 'Compilazione modulo resi'),
          Task(id: '6.12', description: 'Verifica campioni su BR e compilazione logbook'),
          Task(id: '6.13', description: 'Eseguire lineclearance e compilare logbook'),
          Task(id: '6.14', description: 'Eseguire pulizia e compilare logbook ed etichette del pulito'),
          Task(id: '6.15', description: 'Effettuare controllo lineclearance e compilazione logbook'),
        ],
      ),
    ];
  }
}
