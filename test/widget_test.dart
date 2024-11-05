// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../lib/main.dart';

void main() {
  testWidgets('Test navigazione e funzionalità principali', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verifica la presenza della GridView
    expect(find.byType(GridView), findsOneWidget);

    // Verifica la presenza delle sezioni nella MainScreen
    expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
    expect(find.byIcon(Icons.folder_outlined), findsOneWidget);
    expect(find.byIcon(Icons.calculate_outlined), findsOneWidget);
    expect(find.byIcon(Icons.timer_outlined), findsOneWidget);
    expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);

    // Test CalcoloBollini
    await tester.tap(find.byIcon(Icons.calculate_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Calcolo Bollini'), findsOneWidget);
    expect(find.text('Calcolo'), findsOneWidget);
    expect(find.text('Storico'), findsOneWidget);

    // Test LottoSection
    await tester.pageBack();
    await tester.pumpAndSettle();
    
    await tester.tap(find.byIcon(Icons.check_circle_outline));
    await tester.pumpAndSettle();

    expect(find.text('Attività Lotto'), findsOneWidget);
    expect(find.byTooltip('Reset'), findsOneWidget);
  });
}
