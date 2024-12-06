import 'package:flutter/material.dart';
import 'package:skillmentor/users/screens/profile_screen.dart';
import 'package:skillmentor/users/screens/resource_screen.dart';
import 'package:skillmentor/users/screens/last_opened_screen.dart'; // Import the screen for navigation

// Extension for DateTime comparison
extension DateTimeComparison on DateTime {
  bool isSameDayAs(DateTime other) {
    return this.year == other.year && this.month == other.month && this.day == other.day;
  }
}

class UserHome extends StatefulWidget {
  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  DateTime _selectedDate = DateTime.now();
  Set<DateTime> _usedDates = {
    DateTime.now().subtract(Duration(days: 1)),
    DateTime.now().subtract(Duration(days: 2)),
    DateTime.now().add(Duration(days: 1)),
  };

  // Example progress for individual modules
  List<double> _moduleProgressList = [0.5, 0.7, 0.4, 0.6, 0.9]; // Progress for each module

  // To-Do List
  TextEditingController _taskController = TextEditingController();
  List<String> _tasks = [];
  List<bool> _taskCompletion = [];

  // Bottom Navigation Bar index tracking
  int _selectedIndex = 0; // Track selected index for bottom nav

  @override
  Widget build(BuildContext context) {
    // Calculate overall progress as the average of all module progress
    double _overallProgress = _moduleProgressList.reduce((a, b) => a + b) / _moduleProgressList.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Week Calendar - Single Line
              Container(
                margin: EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(7, (index) {
                    final date = _selectedDate
                        .subtract(Duration(days: _selectedDate.weekday - 1))
                        .add(Duration(days: index));
                    bool isToday = date.isSameDayAs(DateTime.now());  // Using the extension
                    bool isUsed = _usedDates.any((d) => d.isSameDayAs(date));  // Using the extension

                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedDate = date;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isUsed
                                    ? "You used the app on ${_formatDate(date)}."
                                    : "No app usage recorded on ${_formatDate(date)}.",
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isToday
                                ? Color(0xFFA3D8D2) // Light Teal
                                : isUsed
                                ? Color(0xFFFAD2C9) // Soft Peach
                                : Color(0xFFE1E1E1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '${date.day}',
                                style: TextStyle(
                                  color: isToday
                                      ? Colors.white
                                      : isUsed
                                      ? Colors.black
                                      : Colors.grey,
                                  fontWeight: isToday
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              Text(
                                _getDayOfWeek(date),
                                style: TextStyle(
                                  color: isToday
                                      ? Colors.white
                                      : isUsed
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              Divider(height: 20, color: Colors.grey, thickness: 1), // Divider

              // Overall Progress Bar
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Overall Progress",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: _overallProgress,
                              backgroundColor: Color(0xFFE1E1E1),
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFAD2C9)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              "${(_overallProgress * 100).toStringAsFixed(1)}%",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: _overallProgress == 1.0 ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Module Progress Section with Dropdown
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: ExpansionTile(
                  title: Text(
                    "Module Progress",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  children: List.generate(_moduleProgressList.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Module ${index + 1}", style: TextStyle(fontSize: 16)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: _moduleProgressList[index],
                                  backgroundColor: Color(0xFFE1E1E1),
                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFAD2C9)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(
                                  "${(_moduleProgressList[index] * 100).toStringAsFixed(1)}%",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: _moduleProgressList[index] == 1.0
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),

              Divider(height: 20, color: Colors.grey, thickness: 1), // Divider

              // To-Do List
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "To-Do List",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextField(
                      controller: _taskController,
                      decoration: InputDecoration(
                        labelText: 'Add a new task',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: _addTask,
                        ),
                      ),
                    ),
                    ReorderableListView(
                      shrinkWrap: true,
                      onReorder: _onReorder,
                      children: List.generate(_tasks.length, (index) {
                        return ListTile(
                          key: ValueKey(index),
                          title: Text(
                            _tasks[index],
                            style: TextStyle(
                              decoration: _taskCompletion[index]
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteTask(index),
                          ),
                          onTap: () {
                            setState(() {
                              _taskCompletion[index] = !_taskCompletion[index];
                            });
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),

              // Last Opened Card
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LastOpenedScreen()), // Navigate to the Last Opened screen
                  );
                },
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(Icons.history, size: 24),
                        SizedBox(width: 16),
                        Text(
                          "Last Opened",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Dynamically track selected index
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'Resources'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile'
          ),
        ],
        onTap: (int index) {
          setState(() {
            _selectedIndex = index; // Update the selected index
          });

          switch (index) {
            case 0:
            // Stay on the current screen
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ResourcesScreen()),
              );
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
              break;
          }
        },
      ),
    );
  }

  // Helper methods
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getDayOfWeek(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thu';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      case DateTime.sunday:
        return 'Sun';
      default:
        return '';
    }
  }

  void _addTask() {
    if (_taskController.text.isEmpty) return;
    setState(() {
      _tasks.add(_taskController.text);
      _taskCompletion.add(false);
    });
    _taskController.clear();
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
      _taskCompletion.removeAt(index);
    });
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final task = _tasks.removeAt(oldIndex);
      final taskCompletion = _taskCompletion.removeAt(oldIndex);
      _tasks.insert(newIndex, task);
      _taskCompletion.insert(newIndex, taskCompletion);
    });
  }
}
