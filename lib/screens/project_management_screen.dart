import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/project_provider.dart';
import '../widgets/add_project_dialog.dart';

class ProjectManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Projects'),
        backgroundColor: Colors.teal[800],
        foregroundColor: Colors.white,
      ),
      body: Consumer<ProjectProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.projects.length,
            itemBuilder: (context, index) {
              final project = provider.projects[index];
              return ListTile(
                title: Text('${project.name}'),
                trailing: IconButton(
                  onPressed: () {
                    provider.deleteProject(project.id);
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
        },
        tooltip: 'Add new project',
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.teal[700],
      ),
    );
  }
}