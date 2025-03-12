import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:time_tracker/models/task.dart';

class TaskProvider with ChangeNotifier{
  final LocalStorage storage;

  List<Task> _tasks = [
    Task(id: '1', name: 'Task 1'),
    Task(id: '2', name: 'Task 2'),
    Task(id: '3', name: 'Task 3'),
  ];
  List<Task> get tasks => _tasks;

  TaskProvider(this.storage){
    _loadTasksFromStorage();
  }

  void _loadTasksFromStorage() async {
    var storedTasks = storage.getItem('tasks');
    if(storedTasks != null){
      _tasks = List<Task>.from(
        (storedTasks as List).map((item) => Task.fromJson(item))
      );
      notifyListeners();
    }
  }

  void addTask(Task task){
    if(!_tasks.any((t)=> t.name == task.name)){
    _tasks.add(task);
    _saveTasksToStorage();
    notifyListeners();
    }
  }

  void _saveTasksToStorage(){
    storage.setItem('tasks', jsonEncode(_tasks.map((t) => t.toJson()).toList));
  }

  void deleteTask(String id){
    _tasks.removeWhere((task )=> task.id == id);
    notifyListeners();
  }

}