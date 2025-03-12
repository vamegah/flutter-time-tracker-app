import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:time_tracker/models/project.dart';

class ProjectProvider with ChangeNotifier{
  final LocalStorage storage;

  List<Project> _projects = [
    Project(id: '1', name: 'Project Alpha'),
    Project(id: '2', name: 'Project Beta'),
    Project(id: '3', name: 'Project Gamma'),
  ];
  List<Project> get projects => _projects;

  ProjectProvider(this.storage){
    _loadProjectsFromStorage();
  }

  void _loadProjectsFromStorage() async{
    var storedProjects = storage.getItem('projects');
    if(storedProjects != null){
      _projects = List<Project>.from(
        (storedProjects as List).map((item) => Project.fromJson(item))
      );
      notifyListeners();
    }
  }

  void addProject(Project project){
    if(!_projects.any((p)=> p.name == project.name)){
    _projects.add(project);
    _saveProjectsToStorage();
    notifyListeners();
    }
  }

  void _saveProjectsToStorage(){
    storage.setItem('projects', jsonEncode(_projects.map((p) => p.toJson()).toList()));
  }

  void deleteProject(String id){
    _projects.removeWhere((project) => project.id == id);
    notifyListeners();
  }
}