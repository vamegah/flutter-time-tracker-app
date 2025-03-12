import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

import 'package:time_tracker/models/time_entry.dart';

class TimeEntryProvider with ChangeNotifier {
    
    final LocalStorage storage;

    List<TimeEntry> _entries = [];

    List<TimeEntry> get entries => _entries;

    void addTimeEntry(TimeEntry entry) {

        _entries.add(entry);
        _saveEntriesToStorage();
        notifyListeners();
        
    }

    void deleteTimeEntry(String id) {

        _entries.removeWhere((entry) => entry.id == id);
        storage.setItem(
            'entries',
            jsonEncode(_entries.map((e) => e.toJson()).toList()),
            );

        notifyListeners();

    }

    TimeEntryProvider(this.storage) {

    _loadEntriesFromStorage();

    }
    
    void _loadEntriesFromStorage() async {
        
        var storedTimeEntries = storage.getItem('entries');
        if (storedTimeEntries != null) {
            _entries = List<TimeEntry>.from(
                (storedTimeEntries as List).map((item) => TimeEntry.fromJson(item)),
                );

      notifyListeners();

    }
  }

  void _saveEntriesToStorage() {
    storage.setItem(
      'entries',
      jsonEncode(_entries.map((e) => e.toJson()).toList()),
    );
  }
}