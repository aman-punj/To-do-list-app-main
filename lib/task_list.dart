import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'core/models/task_model.dart';
import 'core/widgets/add_task.dart';
import 'core/widgets/task_detail.dart';
import 'main.dart';

class TaskList extends StatefulWidget {
  const TaskList({Key? key}) : super(key: key);

  @override
  State createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  late List<Task> tasks;
  String _searchQuery = '';
  List<Task> _searchResults = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromHive();
  }

  Future<void> fetchDataFromHive() async {
    tasks = tasksBox.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To Do List', style: TextStyle(fontSize: 20.sp)),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(12.0.h),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search Task',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (query) {
                  setState(() {
                    _searchQuery = query;
                    _searchResults = tasks
                        .where((task) =>
                        task.title.toLowerCase().contains(query.toLowerCase()))
                        .toList();
                  });
                },
              ),
            ),
            if (_searchQuery.isNotEmpty)
              Padding(
                padding: EdgeInsets.all(8.0.h),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: const  Color(0xFFbf32bf),
                  ),
                  child: _searchResults.isEmpty
                      ? Padding(
                    padding: EdgeInsets.all(12.0.h),
                    child: const  Text('No results found'),
                  )
                      : ListView.builder(
                    shrinkWrap: true,
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      var task = _searchResults[index];
                      return _buildTaskListItem(task);
                    },
                  ),
                ),
              ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                var task = tasks[index];
                return _buildTaskListItem(task);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(AddTaskPage());
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskListItem(Task task) {
    Color indicatorColor = _getIndicatorColor(task.priority);

    return ListTile(
      leading: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: indicatorColor,
        ),
      ),
      title: Text(task.title),
      onTap: () {
        Get.to(TaskDetailsPage(task: task))?.then((value) {
          setState(() {
            _searchQuery = '';
          });
        });
      },
    );
  }

  Color _getIndicatorColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'low':
        return Colors.green;
      case 'medium':
        return Colors.yellow;
      case 'high':
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}
