import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/providers/task_provider.dart';
import 'package:time_tracker/widgets/add_task_dialog.dart';

class TaskManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Tasks'),
        backgroundColor: Colors.teal[800],
        foregroundColor: Colors.white,
      ),
      body: Consumer<TaskProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.tasks.length,
            itemBuilder: (context, index) {
              final task = provider.tasks[index];
              return ListTile(
                title: Text('${task.name}'),
                trailing: IconButton(
                  onPressed: () {
                    provider.deleteTask(task.id);
                  },
                  icon: Icon(Icons.delete, color: Colors.red),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder:
                (context) => AddTaskDialog(
                  onAdd: (newtask) {
                    Provider.of<TaskProvider>(
                      context,
                      listen: false,
                    ).addTask(newtask);
                    Navigator.pop(context);
                  },
                ),
          );
        },
        tooltip: 'Add new task',
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.teal[700],
      ),
    );
  }
}