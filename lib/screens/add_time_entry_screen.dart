import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/project.dart';
import '../models/task.dart';
import '../models/time_entry.dart';
import '../providers/project_provider.dart';
import '../providers/task_provider.dart';
import '../providers/time_entry_provider.dart';
import '../widgets/add_project_dialog.dart';
import '../widgets/add_task_dialog.dart';

class AddTimeEntryScreen extends StatefulWidget {
  @override
  _AddTimeEntryScreenState createState() => _AddTimeEntryScreenState();
}

class _AddTimeEntryScreenState extends State<AddTimeEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  String projectId = '';
  String taskId = '';
  double totalTime = 0.0;
  DateTime _selectedDate = DateTime.now();
  String notes = '';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Time Entry'),
        backgroundColor: Colors.teal[800],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  //dropdown project
                  Consumer<ProjectProvider>(
                    builder: (context, provider, child) {
                      List<Project> projects = provider.projects;
                      return DropdownButtonFormField<Project>(
                        value: projects.first,
                        decoration: InputDecoration(labelText: 'Project'),
                        items:
                            projects.map((Project p) {
                              return DropdownMenuItem<Project>(
                                value: p,
                                child: Text(p.name),
                              );
                            }).toList(),
                        onChanged: (value) {
                          if (value == "Add new project") {
                            showDialog(
                              context: context,
                              builder:
                                  (context) => AddProjectDialog(
                                    onAdd: (newProject) {
                                      Provider.of<ProjectProvider>(
                                        context,
                                        listen: false,
                                      ).addProject(newProject);
                                      Navigator.pop(context);
                                    },
                                  ),
                            );
                          }
                        },
                        onSaved: (value) {
                          if (value != null) {
                            projectId = value.id;
                          }
                        },
                      );
                    },
                  ),
                  //dropdown task
                  Consumer<TaskProvider>(
                    builder: (content, provider, child) {
                      List<Task> tasks = provider.tasks;
                      return DropdownButtonFormField<Task>(
                        value: tasks.first,
                        decoration: InputDecoration(labelText: 'Task'),
                        items:
                            tasks.map((Task t) {
                              return DropdownMenuItem<Task>(
                                value: t,
                                child: Text(t.name),
                              );
                            }).toList(),
                        onChanged: (value) {
                          if (value == "Add new task") {
                            showDialog(
                              context: context,
                              builder:
                                  (context) => AddTaskDialog(
                                    onAdd: (newTask) {
                                      Provider.of<TaskProvider>(
                                        context,
                                        listen: false,
                                      ).addTask(newTask);
                                      Navigator.pop(context);
                                    },
                                  ),
                            );
                          }
                        },
                        onSaved: (value) {
                          if (value != null) {
                            taskId = value.id;
                          }
                        },
                      );
                    },
                  ),
                  //date selector
                  ListTile(
                    title: Text(
                      'Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
                    ),
                    trailing: Icon(Icons.calendar_today, color: Colors.teal[700],),
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        initialDate: _selectedDate,
                      );
                      if (picked != null && picked != _selectedDate) {
                        setState(() {
                          _selectedDate = picked;
                        });
                      }
                    },
                  ),
                  //input totalTime
                  TextFormField(
                    decoration: InputDecoration(
                      label: Text('Total time (hours)'),
                    ),
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter total time';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                    onSaved: (value) => totalTime = double.parse(value!),
                  ),
                  //input notes
                  TextFormField(
                    decoration: InputDecoration(label: Text('Notes')),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some notes';
                      }
                      return null;
                    },
                    onSaved: (value) => notes = value!,
                  ),
                  SizedBox(height: 20),
                  //button save
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[600],
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity,50),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        Provider.of<TimeEntryProvider>(
                          context,
                          listen: false,
                        ).addTimeEntry(
                          TimeEntry(
                            id: DateTime.now().toString(),
                            projectId: projectId,
                            taskId: taskId,
                            totalTime: totalTime,
                            date: _selectedDate,
                            notes: notes,
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Save',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}