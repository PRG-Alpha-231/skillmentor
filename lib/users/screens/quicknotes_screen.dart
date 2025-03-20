import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';



class QuickNotesScreen extends StatefulWidget {
  @override
  _QuickNotesScreenState createState() => _QuickNotesScreenState();
}

class _QuickNotesScreenState extends State<QuickNotesScreen> {
  List<Note> _notes = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? storedNotes = prefs.getStringList('notes');
    if (storedNotes != null) {
      setState(() {
        _notes = storedNotes.map((note) => Note.fromJson(jsonDecode(note))).toList();
      });
    }
  }

  void _saveNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> storedNotes = _notes.map((note) => jsonEncode(note.toJson())).toList();
    prefs.setStringList('notes', storedNotes);
  }

  void _addNote() {
    if (_contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Content cannot be empty')),
      );
      return;
    }
    setState(() {
      _notes.add(Note(
        title: _titleController.text.isEmpty ? 'Untitled' : _titleController.text,
        content: _contentController.text,
        dateTime: DateTime.now(),
      ));
    });
    _saveNotes();
    _titleController.clear();
    _contentController.clear();
  }

  void _deleteNote(int index) {
    Note deletedNote = _notes[index];
    setState(() {
      _notes.removeAt(index);
    });
    _saveNotes();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Note deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _notes.insert(index, deletedNote);
            });
            _saveNotes();
          },
        ),
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    int hour = dateTime.hour;
    int minute = dateTime.minute;
    String amPm = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12 == 0 ? 12 : hour % 12;
    String formattedMinute = minute.toString().padLeft(2, '0');
    return '${dateTime.month}/${dateTime.day}/${dateTime.year} $hour:$formattedMinute $amPm';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quick Notes', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever, color: Colors.white),
            onPressed: () {
              setState(() {
                _notes.clear();
              });
              _saveNotes();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(labelText: 'Title (Optional)', border: OutlineInputBorder()),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: _contentController,
                      decoration: InputDecoration(labelText: 'Content', border: OutlineInputBorder()),
                      maxLines: 5,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _addNote,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text('Add Note', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Text(
                        _notes[index].title,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4),
                          Text(_notes[index].content, style: TextStyle(fontSize: 16)),
                          SizedBox(height: 8),
                          Text(
                            _formatDate(_notes[index].dateTime),
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => _deleteNote(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Note {
  final String title;
  final String content;
  final DateTime dateTime;

  Note({required this.title, required this.content, required this.dateTime});

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'dateTime': dateTime.toIso8601String(),
      };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        title: json['title'],
        content: json['content'],
        dateTime: DateTime.parse(json['dateTime']),
      );
}
