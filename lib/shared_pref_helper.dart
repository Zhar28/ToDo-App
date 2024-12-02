import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/todo.dart';

class SharedPrefHelper {
  static const String _keyToDoList = 'todo_list';

  // Simpan ToDo List ke SharedPreferences
  static Future<void> saveToDoList(List<ToDo> todos) async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(todos.map((todo) => todo.toJson()).toList());
    await prefs.setString(_keyToDoList, jsonString);
  }

  // Ambil ToDo List dari SharedPreferences
  static Future<List<ToDo>> getToDoList() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_keyToDoList);

    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => ToDo.fromJson(json)).toList();
    }
    return [];
  }

  // Hapus semua data ToDo List
  static Future<void> clearToDoList() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToDoList);
  }
}
