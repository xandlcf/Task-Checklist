import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTaskDialog extends StatefulWidget {
  final Function(String, DateTime) onTaskAdded;

  AddTaskDialog({required this.onTaskAdded});

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final titleController = TextEditingController();
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Adicionar nova tarefa'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Título da tarefa'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2101),
              );
              if (picked != null) {
                setState(() {
                  selectedDate = picked;
                });
              }
            },
            child: Text(selectedDate == null ? 'Selecionar data' : DateFormat('dd-MM-yyyy').format(selectedDate!)),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (titleController.text.isNotEmpty && selectedDate != null) {
              widget.onTaskAdded(titleController.text, selectedDate!);
              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Selecione uma data'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: const Text('Adicionar'),
        ),
      ],
    );
  }
}