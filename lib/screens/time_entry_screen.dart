import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/providers/time_entry_provider.dart';

class TimeEntryScreen extends StatelessWidget {
  const TimeEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> entry = ModalRoute.of(context)?.settings.arguments as Map<String,dynamic>;
    // final Map<String, dynamic> entry = {
    //   'id': '1',
    //   'projectName': 'Project Alpha',
    //   'taskName': 'Task A',
    //   'totalTime': 7.5,
    //   'date': 'Mar 09, 2025',
    //   'notes': 'Hola Flutter',
    // };
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Entry'),
        backgroundColor: Colors.teal[800],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Project Name: ${entry['projectName']}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.edit, color: Colors.grey[600]),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: Text('Are you sure?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop,
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed:
                                        () {Provider.of<TimeEntryProvider>(
                                          context,
                                          listen: false,
                                        ).deleteTimeEntry(entry['entryId']);
                                        // Navigator.pop(context);
                                        Navigator.popAndPushNamed(context, '/');
                                        },
                                    child: Text('Delete'),
                                  ),
                                ],
                              ),
                        );
                      },
                      icon: Icon(Icons.delete, color: Colors.red[600]),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Task Name: ${entry['taskName']}'),
            Text('Total Time: ${entry['totalTime']} hours'),
            Text('Date: ${entry['date']}'),
            Text('Notes: ${entry['notes']}'),
          ],
        ),
      ),
    );
  }
}