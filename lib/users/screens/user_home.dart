import 'package:flutter/material.dart';
import 'package:skillmentor/users/screens/profile_screen.dart';
import 'package:skillmentor/users/screens/resource_screen.dart';
import 'package:skillmentor/users/screens/last_opened_screen.dart';

import 'admin.dart';
import 'instructor_home_screen.dart'; // Corrected import for LastOpenedScreen

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
                      physics: NeverScrollableScrollPhysics(),
                      onReorder: _onReorder,
                      children: List.generate(_tasks.length, (index) {
                        return ListTile(
                          key: ValueKey(index),
                          leading: ReorderableDragStartListener(
                            index: index,
                            child: Icon(Icons.drag_handle),
                          ),
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

              // Last Opened Card (Fixed layout issue)
              SizedBox(
                width: double.infinity, // Makes sure the GestureDetector takes the full width
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LastOpenedScreen()), // Navigate to LastOpenedScreen
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
              ),
              SizedBox(
                width: double.infinity, // Makes sure the GestureDetector takes the full width
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InstructorHomeScreen()), // Navigate to instructor Home
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
                            "Instructor  Home",
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
              ),
            ],
          ),
        ),
      ),

      // Position the Elevated Button in the Bottom Right corner using a Stack
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(12.0), // Adjusted padding for a sleeker look
        child: Align(
          alignment: Alignment.bottomRight,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              iconColor: Colors.lightBlue, // Light blue color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // More angular for a squarish look
              ),
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 18), // Increased padding for a bigger button
              elevation: 6, // Slightly increased elevation
            ),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminApp())); // Action to perform when button is pressed
              print('Button pressed');
            },
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Icon(
                  Icons.check, // Change this to your desired icon
                  size: 24, // Slightly larger icon size
                  color: Colors.white,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 10, // Smaller alert icon
                    backgroundColor: Colors.red, // Alert icon color
                    child: Icon(
                      Icons.warning, // Alert symbol (!)
                      size: 14, // Smaller alert symbol
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
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
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
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

  // Format date in 'dd MMM yyyy' format
  String _formatDate(DateTime date) {
    return "${date.day} ${_getMonthName(date.month)} ${date.year}";
  }

  // Get day of the week (e.g., Monday, Tuesday, etc.)
  String _getDayOfWeek(DateTime date) {
    return ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"][date.weekday - 1];
  }

  // Get month name (e.g., January, February, etc.)
  String _getMonthName(int month) {
    return [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ][month - 1];
  }

  // Add task to the to-do list
  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      setState(() {
        _tasks.add(_taskController.text);
        _taskCompletion.add(false);
        _taskController.clear();
      });
    }
  }

  // Reorder tasks
  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final task = _tasks.removeAt(oldIndex);
      _tasks.insert(newIndex, task);
      final completionStatus = _taskCompletion.removeAt(oldIndex);
      _taskCompletion.insert(newIndex, completionStatus);
    });
  }

  // Delete task from to-do list
  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
      _taskCompletion.removeAt(index);
    });
  }
}
