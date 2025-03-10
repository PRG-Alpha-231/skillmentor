import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillmentor/student/student_profile_screen.dart';
import 'dart:convert';

import 'package:skillmentor/users/screens/resource_screen.dart';

class UserHome extends StatefulWidget {
  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  TextEditingController _taskController = TextEditingController();
  List<Map<String, dynamic>> _tasks = []; // Each task has a 'text' and 'isCompleted' field
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  // Load tasks from SharedPreferences
  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getString('tasks');
    if (tasksJson != null) {
      setState(() {
        _tasks = List<Map<String, dynamic>>.from(json.decode(tasksJson));
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  // Save tasks to SharedPreferences
  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tasks', json.encode(_tasks));
  }

  // Add a new task
  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      setState(() {
        _tasks.add({'text': _taskController.text, 'isCompleted': false});
        _taskController.clear();
        _saveTasks();
      });
    }
  }

  // Toggle task completion status
  void _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index]['isCompleted'] = !_tasks[index]['isCompleted'];
      _saveTasks();
    });
  }

  // Delete a task
  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
      _saveTasks();
    });
  }

  // Reorder tasks
  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final task = _tasks.removeAt(oldIndex);
      _tasks.insert(newIndex, task);
      _saveTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Input field for adding tasks
                  TextField(
                    controller: _taskController,
                    decoration: InputDecoration(
                      labelText: 'Add a new task',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.add, color: Colors.blue),
                        onPressed: _addTask,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // List of tasks
                  Expanded(
                    child: ReorderableListView(
                      onReorder: _onReorder,
                      children: _tasks.map((task) {
                        final index = _tasks.indexOf(task);
                        return Card(
                          key: ValueKey(task),
                          margin: EdgeInsets.symmetric(vertical: 5),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: ReorderableDragStartListener(
                              index: index,
                              child: Icon(Icons.drag_handle, color: Colors.grey),
                            ),
                            title: Text(
                              task['text'],
                              style: TextStyle(
                                decoration: task['isCompleted']
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                color: task['isCompleted'] ? Colors.grey : Colors.black,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    task['isCompleted'] ? Icons.check_circle : Icons.circle_outlined,
                                    color: task['isCompleted'] ? Colors.green : Colors.grey,
                                  ),
                                  onPressed: () => _toggleTaskCompletion(index),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteTask(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),


 bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserHome()));
              break;
            case 1:
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ResourcesScreen()));
              break;
            case 2:
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SProfileScreen()));
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Resources',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}



