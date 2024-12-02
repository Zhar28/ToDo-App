import 'package:flutter/material.dart';
import 'package:to_do_app/model/todo.dart';
import 'package:to_do_app/widgets/todo_item.dart';

class HistoryScreen extends StatelessWidget {
  final List<ToDo> historyList; // Accepting history list from HomePages

  const HistoryScreen({Key? key, required this.historyList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Completed Tasks"),
      ),
      body: ListView(
        children: [
          for (ToDo todo in historyList)
            ToDoItem(
              todo: todo,
              onToDoChanged: (todo) {}, // Do nothing on change in history
              onDeleteItem: (id) {
                // Optionally, delete the task from history
                historyList.removeWhere((item) => item.id == id);
              },
            ),
        ],
      ),
    );
  }
}
