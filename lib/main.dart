import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'task_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null); // Inicializa a formatação para português do Brasil
  runApp(MaterialApp(home: TaskListScreen()));
}
