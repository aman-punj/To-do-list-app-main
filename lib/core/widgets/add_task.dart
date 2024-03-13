import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:todo_app/core/widgets/task_provider.dart';
import '../../task_list.dart';
import '../models/task_model.dart';
import 'package:intl/intl.dart';
import 'priority_provider.dart';

class AddTaskPage extends StatefulWidget {
  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final PriorityProvider priorityProvider = PriorityProvider();

  @override
  void initState() {
    super.initState();
    initializePriority();
  }

  void initializePriority() {
    for (int i = 0; i < priorityProvider.priorities.length; i++) {
      priorities.add(priorityProvider.priorities[i].priority);
    }
  }


  List<String> priorities = [];
  String defaultPriority = 'Medium';
  String selectedPriority = '';
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  DateTime selectedDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 16, 0);


  @override
  Widget build(BuildContext context) {
    // final taskProvider = Provider.of<TaskProvider>(context);

    for(int i = 0; i < priorities.length; i++){
      print(priorities[i]);
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller:  titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16.0.h),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 16.0.h),
            DropdownButtonFormField<String>(
              value: defaultPriority,
              onChanged: (value) {
                selectedPriority = value!;
              },
              items: priorities.map((priority) {
                return DropdownMenuItem<String>(
                  value: priority,
                  child: Text(priority),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0.h),
            Text(
              "Due date of Task",
              style: TextStyle(
                fontSize: 16.sp,),
            ),
            TextField(
              controller: dateController,
              readOnly: true,
              decoration: InputDecoration(
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        selectedDate != null ? DateFormat('yyyy-MM-dd').format(selectedDate) : '',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.36),
                    GestureDetector(
                      onTap: () async {
                        final DateTime currentDate = DateTime.now();
                        DateTime dateOnly = DateTime(currentDate.year, currentDate.month, currentDate.day,);

                        final DateTime? datePicked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: dateOnly,
                          lastDate: DateTime(2100),
                        );
                        await validate_date(context, datePicked!, dateOnly);
                      },
                      child: Icon(Icons.date_range_rounded, size: 24, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            TextField(
              controller: timeController,
              readOnly: true,
              decoration: InputDecoration(
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        selectedDate != null ? DateFormat('HH:mm').format(selectedDate) : '',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.36),
                    GestureDetector(
                      onTap: () async {
                        await _selectTime(context);
                      },
                      child: Icon(Icons.access_time_rounded, size: 24, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final String title = titleController.text.trim();
                final String description = descriptionController.text.trim();
                final String priority = selectedPriority == "" ? defaultPriority : selectedPriority;
                final DateTime dueDate = selectedDate;

                print(priority);
                if (title.isNotEmpty && description.isNotEmpty) {
                  if(TaskProvider().tasks.any((task) => task.title.compareTo(title) == 0)){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Task with the same title already exists'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                  else{
                    TaskProvider().addTask(
                      Task(
                        title: title,
                        description: description,
                        priority: priority,
                        dueDate: dueDate,
                      ),
                    );

                    titleController.clear();
                    descriptionController.clear();
                    dateController.clear();

                    Get.offAll(TaskList());
                  }
                }
                else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please fill in all fields'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> validate_date(BuildContext context, DateTime datePicked, DateTime dateOnly) async {
    if (datePicked != null && datePicked != selectedDate) {
      if (datePicked == dateOnly || datePicked.isAfter(dateOnly)) {
        setState(() {
          selectedDate = datePicked;
        });
        print('valid date');
      }
    }
  }

  Future<void> _selectTime(BuildContext context, [DateTime? initialTime]) async {
    final TimeOfDay? timePicked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialTime ?? DateTime.now().add(Duration(hours: 1))),
    );

    if (timePicked != null) {
      DateTime selectedDateTime = DateTime(
        selectedDate?.year ?? DateTime.now().year,
        selectedDate?.month ?? DateTime.now().month,
        selectedDate?.day ?? DateTime.now().day,
        timePicked.hour,
        timePicked.minute,
      );

      setState(() {
        selectedDate = selectedDateTime;
        dateController.text = DateFormat('yyyy-MM-dd HH:mm').format(selectedDate);
      });
    }
  }
}
