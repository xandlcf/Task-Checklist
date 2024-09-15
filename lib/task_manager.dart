import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'task.dart';

class TaskManager {
  List<Task> tasks = [];

  Future<void> loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tasksJson = prefs.getString('tasks');
    if (tasksJson != null) {
      List<dynamic> taskList = jsonDecode(tasksJson);
      tasks = taskList.map((task) => Task.fromJson(task)).toList();
    }
  }

  Future<void> saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> taskList = tasks.map((task) => task.toJson()).toList();
    await prefs.setString('tasks', jsonEncode(taskList));
  }

  void addTask(String title, DateTime deadline) {
    tasks.add(Task(title: title, deadline: deadline));
    tasks.sort((a, b) => a.deadline.compareTo(b.deadline));
    saveTasks();
  }

  void toggleTaskCompletion(int index) {
    tasks[index].isCompleted = !tasks[index].isCompleted;
    if (tasks[index].isCompleted) {
      tasks[index].completionDate = DateTime.now();
    } else {
      tasks[index].completionDate = null;
    }
    saveTasks();
  }

  void deleteTask(int index) {
    tasks.removeAt(index);
    saveTasks();
  }

  String getStatus(Task task) {
    if (task.isCompleted) {
      DateTime completionDateOnly = DateTime(
        task.completionDate!.year,
        task.completionDate!.month,
        task.completionDate!.day,
      );
      DateTime deadlineOnly = DateTime(
        task.deadline.year,
        task.deadline.month,
        task.deadline.day,
      );
      return (completionDateOnly.isAfter(deadlineOnly)) ? "Atrasado" : "No prazo";
    }
    return "";
  }
}
