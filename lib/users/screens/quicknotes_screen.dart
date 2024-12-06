import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quick Notes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QuickNotesScreen(),
    );
  }
}

class QuickNotesScreen extends StatefulWidget {
  @override
  _QuickNotesScreenState createState() => _QuickNotesScreenState();
}

class _QuickNotesScreenState extends State<QuickNotesScreen> {
  final List<Note> _notes = []; // Store notes in a list
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  void _addNote() {
    if (_contentController.text.isNotEmpty) {
      setState(() {
        _notes.add(Note(
          title: _titleController.text.isEmpty ? 'Untitled' : _titleController.text,
          content: _contentController.text,
          dateTime: DateTime.now(),
        ));
      });
      _titleController.clear();
      _contentController.clear();
    }
  }

  void _editNote(int index) {
    _titleController.text = _notes[index].title;
    _contentController.text = _notes[index].content;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Note'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title (Optional)'),
              ),
              TextField(
                controller: _contentController,
                decoration: InputDecoration(labelText: 'Content'),
                maxLines: 5,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _notes[index] = Note(
                    title: _titleController.text.isEmpty ? 'Untitled' : _titleController.text,
                    content: _contentController.text,
                    dateTime: _notes[index].dateTime,
                  );
                });
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index); // Remove the note from the list
    });
  }

  void _clearAllNotes() {
    // Show confirmation dialog before clearing all notes
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Clear All Notes'),
          content: Text('Are you sure you want to delete all notes?'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _notes.clear(); // Clear all notes
                });
                Navigator.pop(context);
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  // Format the date and time in 12-hour format with AM/PM
  String _formatDate(DateTime dateTime) {
    int hour = dateTime.hour;
    int minute = dateTime.minute;
    String amPm = hour >= 12 ? 'PM' : 'AM';

    // Convert hour to 12-hour format
    hour = hour % 12;
    hour = hour == 0 ? 12 : hour;  // Adjust hour to 12 if it was 0 (midnight)

    // Format minute with leading zero if necessary
    String formattedMinute = minute.toString().padLeft(2, '0');

    // Return formatted date and time
    return '${dateTime.month}/${dateTime.day}/${dateTime.year} $hour:$formattedMinute $amPm';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quick Notes'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: _clearAllNotes, // Call _clearAllNotes when pressed
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input fields for title and content
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title (Optional)',  // Indicate that the title is optional
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addNote,
              child: Text('Add Note'),
            ),
            SizedBox(height: 16),
            // List of notes with title, content, date, and edit/delete options
            Expanded(
              child: ListView.builder(
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Text(_notes[index].title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_notes[index].content),
                          SizedBox(height: 8), // Increased space between content and date
                          Text(
                            _formatDate(_notes[index].dateTime),
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      trailing: Wrap(
                        spacing: 12,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _editNote(index),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteNote(index),
                          ),
                        ],
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

  Note({
    required this.title,
    required this.content,
    required this.dateTime,
  });
}
