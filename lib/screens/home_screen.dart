import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/time_entry.dart';
import '../providers/project_provider.dart';
import '../providers/task_provider.dart';
import '../providers/time_entry_provider.dart';
import '../screens/add_time_entry_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Entries'),
        backgroundColor: Colors.teal[800],
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Color(0xFFFFC103),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white38,
          tabs: [Tab(text: "All entries"), Tab(text: "Grouped by Projects")],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal[800]),
              child: Center(
                child: Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.folder),
              title: Text('Projects'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/manage_projects');
              },
            ),
            ListTile(
              leading: Icon(Icons.task),
              title: Text('Tasks'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/manage_tasks');
              },
            ),
          ],
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: [buildAllEntries(context), buildEntriesByProject(context)],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTimeEntryScreen()),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color(0xFFFFC103),
        tooltip: 'Add Time Entry',
      ),
    );
  }

  Widget buildAllEntries(BuildContext context) {
    return Consumer<TimeEntryProvider>(
      builder: (context, provider, child) {
        if (provider.entries.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.hourglass_empty,
                  color: Colors.grey[400],
                  size: 120,
                  opticalSize: 72,
                ),
                SizedBox(height: 20),
                Text(
                  "No time entries yet!",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Tap the + button to add your first entry.",
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: provider.entries.length,
          itemBuilder: (context, index) {
            final timeEntry = provider.entries[index];
            String formattedDate = DateFormat(
              'MMM dd, yyyy',
            ).format(timeEntry.date);
            return Dismissible(
              key: Key(timeEntry.id),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                provider.deleteTimeEntry(timeEntry.id);
              },
              background: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.centerRight,
                child: Icon(Icons.delete, color: Colors.red),
              ),
              child: Card(
                color: Colors.white70,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: ListTile(
                  title: Text(
                    '${getProjectById(context, timeEntry.projectId)} - ${getTaskById(context, timeEntry.taskId)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[300],
                    ),
                  ),
                  subtitle: Text(
                    '\nTotal Time: ${timeEntry.totalTime} hours \nDate: ${formattedDate} \nNote: ${timeEntry.notes}',
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                        provider.deleteTimeEntry(timeEntry.id);
                    },
                ),

                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/time_entry',
                      arguments: {
                        'entryId': timeEntry.id,
                        'projectName':
                            '${getProjectById(context, timeEntry.projectId)}',
                        'taskName': '${getTaskById(context, timeEntry.taskId)}',
                        'totalTime': timeEntry.totalTime,
                        'date': formattedDate,
                        'notes': timeEntry.notes,
                      },
                    );
                  },
                  isThreeLine: true,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildEntriesByProject(BuildContext context) {
    return Consumer<TimeEntryProvider>(
      builder: (context, provider, child) {
        if (provider.entries.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.hourglass_empty,
                  color: Colors.grey[400],
                  size: 120,
                  opticalSize: 72,
                ),
                SizedBox(height: 20),
                Text(
                  "No time entries yet!",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Tap the + button to add your first entry.",
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          );
        }
        var grouped = groupBy(provider.entries, (TimeEntry e) => e.projectId);
        return ListView(
          children:
              grouped.entries.map((entry) {
                String projectName = getProjectById(context, entry.key);
                double total = entry.value.fold(
                  0.0,
                  (double prev, TimeEntry element) => prev + element.totalTime,
                );
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "$projectName - Total: ${total.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[300],
                        ),
                      ),
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: entry.value.length,
                      itemBuilder: (context, index) {
                        TimeEntry timeEntry = entry.value[index];
                        String formattedDate = DateFormat(
                          'MMM dd, yyyy',
                        ).format(timeEntry.date);
                        return ListTile(
                            title: Text(
                                '- ${getTaskById(context, timeEntry.taskId)}: ${timeEntry.totalTime} hours (${formattedDate})',
                                ),
                                
                                trailing: IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                       provider.deleteTimeEntry(timeEntry.id);
                                        },
                                    ),
                        );
                      },
                    ),
                  ],
                );
              }).toList(),
        );
      },
    );
  }

  String getProjectById(BuildContext context, String projectId) {
    var project = Provider.of<ProjectProvider>(
      context,
      listen: false,
    ).projects.firstWhere((pro) => pro.id == projectId);
    return project.name;
  }

  String getTaskById(BuildContext context, String taskId) {
    var task = Provider.of<TaskProvider>(
      context,
      listen: false,
    ).tasks.firstWhere((t) => t.id == taskId);
    return task.name;
  }
}