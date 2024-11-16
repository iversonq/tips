import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Map<String, String>> _notes = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _activityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _timeController.dispose();
    _activityController.dispose();
    super.dispose();
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final encodedNotes = jsonEncode(_notes);
      await prefs.setString('notes', encodedNotes);
    } catch (e) {
      print('Error saving notes: $e');
    }
  }

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final savedNotes = prefs.getString('notes');
      if (savedNotes != null) {
        final List<dynamic> decodedNotes = jsonDecode(savedNotes);
        setState(() {
          _notes = decodedNotes.map((note) {
            return Map<String, String>.from(note);
          }).toList();
        });
      }
    } catch (e) {
      print('Error loading notes: $e');
    }
  }

  void _addOrEditNote({int? index}) {
    // Prepopulate the fields if we're editing an existing note
    if (index != null) {
      _titleController.text = _notes[index]['title'] ?? '';  // Default to empty string if null
      _timeController.text = _notes[index]['time'] ?? '';    // Default to empty string if null
      _activityController.text = _notes[index]['activity'] ?? '';  // Default to empty string if null
    } else {
      _titleController.clear();
      _timeController.clear();
      _activityController.clear();
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(index == null ? 'Add Activity' : 'Edit Activity'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _timeController,
                decoration: const InputDecoration(labelText: 'Time (HH:MM)'),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[0-9:]*$')),
                  LengthLimitingTextInputFormatter(5),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _activityController,
                decoration: const InputDecoration(labelText: 'Activity'),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_titleController.text.isNotEmpty &&
                  _timeController.text.isNotEmpty &&
                  _activityController.text.isNotEmpty &&
                  RegExp(r'^\d{2}:\d{2}$').hasMatch(_timeController.text)) {
                setState(() {
                  if (index == null) {
                    _notes.add({
                      'title': _titleController.text,
                      'time': _timeController.text,
                      'activity': _activityController.text,
                    });
                  } else {
                    _notes[index] = {
                      'title': _titleController.text,
                      'time': _timeController.text,
                      'activity': _activityController.text,
                    };
                  }
                });
                await _saveNotes();
                Navigator.of(ctx).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter valid data!')),
                );
              }
            },
            child: Text(index == null ? 'Add' : 'Save'),
          ),
        ],
      ),
    );
  }

  void _deleteNote(int index) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you really want to delete this activity?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _notes.removeAt(index);
              });
              _saveNotes();
              Navigator.of(ctx).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Activities'),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'image/bgnote.png',
              fit: BoxFit.cover,
            ),
          ),
          _notes.isEmpty
              ? const Center(
            child: Text(
              'No activities yet. Add one!',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          )
              : ListView.builder(
            itemCount: _notes.length,
            itemBuilder: (ctx, index) => Card(
              color: Colors.white70,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                title: Text(_notes[index]['title'] ?? 'Untitled'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Time: ${_notes[index]['time'] ?? 'N/A'}'),
                    Text('Activity: ${_notes[index]['activity'] ?? 'N/A'}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _addOrEditNote(index: index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteNote(index),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditNote(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
