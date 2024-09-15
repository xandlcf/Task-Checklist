// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/task_list_screen.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: TaskListScreen()));

    // Verify that our counter starts at 0.
    expect(find.text('Lista de Tarefas'), findsOneWidget);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that the add task dialog is shown.
    expect(find.text('Adicionar nova tarefa'), findsOneWidget);

    // Enter a task title and select a date.
    await tester.enterText(find.byType(TextField), 'Nova Tarefa');
    await tester.tap(find.text('Selecionar data'));
    await tester.pumpAndSettle();

    // Select a date from the date picker.
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // Tap the 'Adicionar' button and trigger a frame.
    await tester.tap(find.text('Adicionar'));
    await tester.pumpAndSettle();

    // Verify that the task is added to the list.
    expect(find.text('Nova Tarefa'), findsOneWidget);
  });
}