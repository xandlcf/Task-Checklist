import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/task.dart';
import 'task_manager.dart';
import 'add_task_dialog.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TaskManager taskManager = TaskManager();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    taskManager.loadTasks().then((_) {
      setState(() {});
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      });
    });
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AddTaskDialog(
          onTaskAdded: (title, deadline) {
            taskManager.addTask(title, deadline);
            setState(() {});
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: const Text('Lista de Tarefas', style: TextStyle(color: Colors.white)),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: taskManager.tasks.length,
        itemBuilder: (context, index) {
          Task task = taskManager.tasks[index];
          DateTime now = DateTime.now();
          DateTime today = DateTime(now.year, now.month, now.day);
          DateTime taskDeadline = DateTime(task.deadline.year, task.deadline.month, task.deadline.day);
          bool isOverdue = !task.isCompleted && taskDeadline.isBefore(today);
          bool showDaySeparator = (index == 0 || taskManager.tasks[index].deadline.day != taskManager.tasks[index - 1].deadline.day);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showDaySeparator)
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    DateFormat.EEEE('pt_BR').format(task.deadline),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              Dismissible(
                key: Key(task.title),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  taskManager.deleteTask(index);
                  setState(() {});
                },
                child: Container(
                  color: task.isCompleted
                      ? Colors.lightGreen[200]
                      : isOverdue
                          ? Colors.red[100]
                          : Colors.grey[200],
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    children: [
                      Checkbox(
                        value: task.isCompleted,
                        onChanged: (value) {
                          taskManager.toggleTaskCompletion(index);
                          setState(() {});
                        },
                      ),
                      Expanded(
                        child: Text(
                          task.title,
                          style: TextStyle(
                            decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                            fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                      Text(
                        DateFormat('dd-MM-yyyy').format(task.deadline),
                        style: TextStyle(
                          decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                          fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        taskManager.getStatus(task),
                        style: TextStyle(
                          color: task.isCompleted
                              ? (DateTime(task.completionDate!.year, task.completionDate!.month, task.completionDate!.day).isAfter(DateTime(task.deadline.year, task.deadline.month, task.deadline.day)) ? Colors.red : Colors.green)
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightGreen,
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
