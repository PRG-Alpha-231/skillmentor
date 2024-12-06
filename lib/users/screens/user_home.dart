import 'package:flutter/material.dart';
import 'package:skillmentor/users/screens/resource_screen.dart';

import 'profile_screen.dart';

class UserHome extends StatefulWidget {
  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  final List<String> _toDoList = [];
  final List<bool> _taskCompletionStatus = [];
  final TextEditingController _taskController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  // Additional task categories for new progress bars
  final List<String> _workTasks = [];
  final List<bool> _workTaskCompletionStatus = [];

  final List<String> _personalTasks = [];
  final List<bool> _personalTaskCompletionStatus = [];

  final List<String> _category1Tasks = [];
  final List<bool> _category1TaskCompletionStatus = [];

  final List<String> _category2Tasks = [];
  final List<bool> _category2TaskCompletionStatus = [];

  final List<String> _category3Tasks = [];
  final List<bool> _category3TaskCompletionStatus = [];

  final List<String> _category4Tasks = [];
  final List<bool> _category4TaskCompletionStatus = [];

  final List<String> _category5Tasks = [];
  final List<bool> _category5TaskCompletionStatus = [];

  double get _overallCompletionPercentage {
    if (_toDoList.isEmpty) return 0.0;
    int completedTasks = _taskCompletionStatus.where((status) => status).length;
    return completedTasks / _toDoList.length;
  }

  double get _workCompletionPercentage {
    if (_workTasks.isEmpty) return 0.0;
    int completedWorkTasks = _workTaskCompletionStatus.where((status) => status).length;
    return completedWorkTasks / _workTasks.length;
  }

  double get _personalCompletionPercentage {
    if (_personalTasks.isEmpty) return 0.0;
    int completedPersonalTasks = _personalTaskCompletionStatus.where((status) => status).length;
    return completedPersonalTasks / _personalTasks.length;
  }

  double get _category1CompletionPercentage {
    if (_category1Tasks.isEmpty) return 0.0;
    int completedCategory1Tasks = _category1TaskCompletionStatus.where((status) => status).length;
    return completedCategory1Tasks / _category1Tasks.length;
  }

  double get _category2CompletionPercentage {
    if (_category2Tasks.isEmpty) return 0.0;
    int completedCategory2Tasks = _category2TaskCompletionStatus.where((status) => status).length;
    return completedCategory2Tasks / _category2Tasks.length;
  }

  double get _category3CompletionPercentage {
    if (_category3Tasks.isEmpty) return 0.0;
    int completedCategory3Tasks = _category3TaskCompletionStatus.where((status) => status).length;
    return completedCategory3Tasks / _category3Tasks.length;
  }

  double get _category4CompletionPercentage {
    if (_category4Tasks.isEmpty) return 0.0;
    int completedCategory4Tasks = _category4TaskCompletionStatus.where((status) => status).length;
    return completedCategory4Tasks / _category4Tasks.length;
  }

  double get _category5CompletionPercentage {
    if (_category5Tasks.isEmpty) return 0.0;
    int completedCategory5Tasks = _category5TaskCompletionStatus.where((status) => status).length;
    return completedCategory5Tasks / _category5Tasks.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
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

            // Original Progress Bar Section (Overall Progress)
            Text(
              'Overall Progress',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            _toDoList.isEmpty
                ? Container(
              height: 10,
              color: Colors.grey[300],
              child: Center(
                child: Text(
                  'No tasks to track progress',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(
                  value: _overallCompletionPercentage,
                  minHeight: 10,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
                const SizedBox(height: 5),
                Text(
                  '${(_overallCompletionPercentage * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Expansion Tile for Additional Progress Bars
            ExpansionTile(
              title: Text('Additional Progress Bars'),
              children: [
                _buildProgressBarSection('Category 1 ', _category1CompletionPercentage, Colors.tealAccent),
                _buildProgressBarSection('Category 2 ', _category2CompletionPercentage, Colors.tealAccent),
                _buildProgressBarSection('Category 3 ', _category3CompletionPercentage, Colors.tealAccent),
                _buildProgressBarSection('Category 4 ', _category4CompletionPercentage, Colors.tealAccent),
                _buildProgressBarSection('Category 5 ', _category5CompletionPercentage, Colors.tealAccent),

              ],
            ),

            const SizedBox(height: 20),

            // To-Do List Section
            Text(
              'To-Do List',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),

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
                ? Center(
              child: Text(
                "No tasks yet. Add a task!",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
                : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
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
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home',),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Resources'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (int index) {
          switch (index) {
            case 0:
          Navigator.push(context,MaterialPageRoute(builder: (context) =>UserHome() ,));
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ResourcesScreen()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
              break;
          }
        },
      ),
    );
  }

  Widget _buildProgressBarSection(String title, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 5),
        LinearProgressIndicator(
          value: progress,
          minHeight: 10,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

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
              color: isSelected ? Colors.blueAccent : Colors.grey[200],
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

  String _getDayOfWeek(DateTime date) {
    List<String> daysOfWeek = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return daysOfWeek[date.weekday % 7];
  }

  void _goToPreviousWeek() {
    setState(() {
      _selectedDate = _selectedDate.subtract(Duration(days: 7));
    });
  }

  void _goToNextWeek() {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: 7));
    });
  }

  void _addTask() {
    final task = _taskController.text.trim();
    if (task.isNotEmpty) {
      setState(() {
        _toDoList.add(task);
        _taskCompletionStatus.add(false);
      });
      _taskController.clear();
    }
  }

  void _removeTask(int index) {
    setState(() {
      _toDoList.removeAt(index);
      _taskCompletionStatus.removeAt(index);
    });
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      _taskCompletionStatus[index] = !_taskCompletionStatus[index];
    });
  }
}

extension DateTimeComparison on DateTime {
  bool isSameDayAs(DateTime other) {
    return this.year == other.year &&
        this.month == other.month &&
        this.day == other.day;
  }
}
