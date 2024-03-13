import 'package:flutter/material.dart';
import '../../main.dart';
import '../models/priority_model.dart';

class PriorityProvider extends ChangeNotifier {
  List<Pref> priority = [];

  List<Pref> get priorities => priority;

  PriorityProvider() {
    _initCategoryBox();
  }

  Future<void> _initCategoryBox() async {
    priority = priorityBox.values.toList();
    List<String> defaultPriorities = ['High', 'Medium', 'Low'];
    if (priorityBox.isEmpty) {
      await addDefaultPriority(defaultPriorities);
    }
    notifyListeners();
  }

  Future<void> addDefaultPriority(List<String> defaultCategories) async {
    for (String priority in defaultCategories) {
      addCategory(Pref(priority: priority));
    }
  }

  Future<void> addCategory(Pref priority) async {
    await priorityBox.add(priority);
    notifyListeners();
  }

}
