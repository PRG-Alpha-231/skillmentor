import 'package:flutter/material.dart';

class UserHome extends StatefulWidget {
  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  final List<String> _toDoList = [];
  final List<bool> _taskCompletionStatus = [];
  final TextEditingController _taskController = TextEditingController();
  DateTime _selectedDate = DateTime.now(); // Initially selected date

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Week Navigation and Calendar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_left),
                  onPressed: _goToPreviousWeek,
                ),
                Text(
                  '${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                IconButton(
                  icon: Icon(Icons.arrow_right),
                  onPressed: _goToNextWeek,
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildWeekCalendar(),

            const SizedBox(height: 20),

            // To-Do List Section
            Text(
              'To-Do List',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),

            // Task Input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: InputDecoration(
                      hintText: 'Enter a task...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addTask,
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Task List
            _toDoList.isEmpty
                ? Center(child: Text("No tasks yet. Add a task!"))
                : Expanded(
              child: ListView.builder(
                itemCount: _toDoList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: IconButton(
                      icon: Icon(
                        _taskCompletionStatus[index]
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: _taskCompletionStatus[index]
                            ? Colors.green
                            : Colors.blue,
                      ),
                      onPressed: () => _toggleTaskCompletion(index),
                    ),
                    title: Text(
                      _toDoList[index],
                      style: TextStyle(
                        decoration: _taskCompletionStatus[index]
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeTask(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Resources'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  // Build week calendar (7 days)
  Widget _buildWeekCalendar() {
    List<Widget> dayWidgets = [];
    for (int i = 0; i < 7; i++) {
      DateTime day = _selectedDate.add(Duration(days: i - _selectedDate.weekday));
      bool isSelected = day.isSameDayAs(DateTime.now());
      dayWidgets.add(
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = day;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.orange : Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  _getDayOfWeek(day),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
                if (isSelected)
                  Text(
                    '${day.day}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: dayWidgets,
    );
  }

  // Helper function to get the weekday name
  String _getDayOfWeek(DateTime date) {
    List<String> daysOfWeek = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return daysOfWeek[date.weekday % 7];
  }

  // Navigate to the previous week
  void _goToPreviousWeek() {
    setState(() {
      _selectedDate = _selectedDate.subtract(Duration(days: 7));
    });
  }

  // Navigate to the next week
  void _goToNextWeek() {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: 7));
    });
  }

  // Add task to the to-do list
  void _addTask() {
    final task = _taskController.text.trim();
    if (task.isNotEmpty) {
      setState(() {
        _toDoList.add(task);
        _taskCompletionStatus.add(false); // Initialize task as not completed
      });
      _taskController.clear();
    }
  }

  // Remove task from the to-do list
  void _removeTask(int index) {
    setState(() {
      _toDoList.removeAt(index);
      _taskCompletionStatus.removeAt(index); // Remove completion status
    });
  }

  // Toggle task completion status
  void _toggleTaskCompletion(int index) {
    setState(() {
      _taskCompletionStatus[index] = !_taskCompletionStatus[index];
    });
  }
}

extension DateTimeComparison on DateTime {
  // Check if two DateTime objects represent the same day
  bool isSameDayAs(DateTime other) {
    return this.year == other.year &&
        this.month == other.month &&
        this.day == other.day;
  }
}
