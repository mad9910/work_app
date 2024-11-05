import 'package:flutter/material.dart';
import 'models/numero.dart';
import 'screens/lotto_section.dart';
import 'screens/moduli_section.dart';
import 'screens/calcolo_bollini_section.dart';
import 'screens/tempi_section.dart';
import 'screens/reminder_section.dart';
import 'screens/numeri_section.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Work Management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = -1;
  final List<Numero> _numeri = [];
  late final List<Map<String, dynamic>> _sections;

  @override
  void initState() {
    super.initState();
    _sections = [
      {
        'title': 'Da Fare',
        'icon': Icons.check_circle_outline,
        'color': Colors.green,
        'widget': const LottoSection(),
      },
      {
        'title': 'Moduli',
        'icon': Icons.folder_outlined,
        'color': Colors.deepPurple,
        'widget': const ModuliSection(),
      },
      {
        'title': 'Calcolo Bollini',
        'icon': Icons.calculate_outlined,
        'color': Colors.orange,
        'widget': const CalcoloBollini(),
      },
      {
        'title': 'Tempi',
        'icon': Icons.timer_outlined,
        'color': Colors.red,
        'widget': const TempiSection(),
      },
      {
        'title': 'Promemoria',
        'icon': Icons.notifications_outlined,
        'color': Colors.blue,
        'widget': const ReminderSection(),
      },
      {
        'title': 'Rubrica',
        'icon': Icons.contacts_outlined,
        'color': Colors.purple,
        'widget': NumeriSection(
          numeri: _numeri,
          onAdd: _onAddNumero,
          onDelete: _onDeleteNumero,
        ),
      },
    ];
  }

  void _onAddNumero(Numero numero) {
    setState(() {
      _numeri.add(numero);
    });
  }

  void _onDeleteNumero(String id) {
    setState(() {
      _numeri.removeWhere((numero) => numero.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Work Management'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.phone),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NumeriSection(
                  numeri: _numeri,
                  onAdd: _onAddNumero,
                  onDelete: _onDeleteNumero,
                ),
              ),
            ),
            tooltip: 'Numeri Utili',
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _sections.length,
        itemBuilder: (context, index) {
          final section = _sections[index];
          return Card(
            color: section['color'],
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => section['widget'],
                  ),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    section['icon'],
                    size: 48,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    section['title'],
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}