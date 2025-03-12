import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/models/task.dart';
import 'package:time_tracker/providers/task_provider.dart';

class AddTaskDialog extends StatefulWidget{
  final Function(Task) onAdd;

  AddTaskDialog({required this.onAdd});

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog>{
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context){
    return AlertDialog(
      title: Text('Add new Task'),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(label: Text('Task name')),
      ),
      actions: [
        TextButton(onPressed: ()=> Navigator.of(context).pop(), child: Text('Cancel')),
        TextButton(onPressed: () {
          var newTask = Task(id: DateTime.now().toString(), name: _controller.text);
          widget.onAdd(newTask);
          Provider.of<TaskProvider>(context, listen: false).addTask(newTask);
          _controller.clear();
          Navigator.of(context).pop();
        }, child: Text('Add'))
      ],
    );
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }
}