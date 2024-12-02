import 'package:flutter/material.dart';
import 'package:to_do_app/shared_pref_helper.dart';

import '../model/todo.dart';
import '../pages/colors.dart';
import '../widgets/todo_item.dart';

class HomePages extends StatefulWidget {
  HomePages({Key? key}) : super(key: key);

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  List<ToDo> todosList = [];
  List<ToDo> _foundToDo = [];
  final _todoController = TextEditingController();
  String _filterType = 'all'; // 'all', 'completed', 'incomplete'

  @override
  void initState() {
    super.initState();
    _loadToDoList();
  }

  Widget _buildFilterButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _filterButton('All', 'all'),
        _filterButton('Completed', 'completed'),
        _filterButton('Incomplete', 'incomplete'),
      ],
    );
  }

  Widget _filterButton(String label, String filterType) {
    return TextButton(
      onPressed: () => _changeFilter(filterType),
      child: Text(
        label,
        style: TextStyle(
          color: _filterType == filterType ? Colors.blue : Colors.black,
          fontWeight:
              _filterType == filterType ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                searchBox(), // Kotak pencarian
                _buildFilterButtons(), // Tombol filter
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 50, bottom: 20),
                        child: Text(
                          'All ToDos',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w500),
                        ),
                      ),
                      for (ToDo todoo in _foundToDo.reversed)
                        ToDoItem(
                          todo: todoo,
                          onToDoChanged: _handleToDoChange,
                          onDeleteItem: _deleteToDoItem,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20, right: 20, left: 20),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 0.0),
                          blurRadius: 10.0,
                          spreadRadius: 0.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _todoController,
                      decoration: InputDecoration(
                          hintText: 'Add a new todo item',
                          border: InputBorder.none),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20, right: 20),
                  child: ElevatedButton(
                    child: Text(
                      '+',
                      style: TextStyle(
                        fontSize: 40,
                      ),
                    ),
                    onPressed: () {
                      _addToDoItem(_todoController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tdBlue,
                      minimumSize: Size(60, 60),
                      elevation: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Load data dari SharedPreferences
  Future<void> _loadToDoList() async {
    final loadedTodos = await SharedPrefHelper.getToDoList();
    setState(() {
      todosList = loadedTodos;
      _foundToDo = loadedTodos;
    });
  }

  // Simpan data ke SharedPreferences
  Future<void> _saveToDoList() async {
    await SharedPrefHelper.saveToDoList(todosList);
  }

  void _addToDoItem(String toDo) {
    if (toDo.trim().isEmpty) return;
    setState(() {
      todosList.add(ToDo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        todoText: toDo,
      ));
      _foundToDo = todosList;
    });
    _saveToDoList(); // Simpan setelah ditambah
    _todoController.clear();
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
    _saveToDoList(); // Simpan setelah status berubah
  }

  void _deleteToDoItem(String id) {
    setState(() {
      todosList.removeWhere((item) => item.id == id);
      _foundToDo = todosList;
    });
    _saveToDoList(); // Simpan setelah dihapus
  }

  // Fungsi Filter
  void _runFilter(String enteredKeyword) {
    List<ToDo> results = todosList;

    // Filter berdasarkan teks pencarian
    if (enteredKeyword.isNotEmpty) {
      results = results
          .where((item) => item.todoText
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    // Filter berdasarkan status
    if (_filterType == 'completed') {
      results = results.where((item) => item.isDone).toList();
    } else if (_filterType == 'incomplete') {
      results = results.where((item) => !item.isDone).toList();
    }

    setState(() {
      _foundToDo = results;
    });
  }

  void _changeFilter(String filterType) {
    setState(() {
      _filterType = filterType;
    });
    _runFilter(''); // Refresh hasil filter
  }

  Widget searchBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: tdBlack,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: tdGrey),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: tdBGColor,
      elevation: 0,
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Icon(
          Icons.menu,
          color: tdBlack,
          size: 30,
        ),
        Container(
          height: 40,
          width: 40,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset('images/black.png'),
          ),
        ),
      ]),
    );
  }
}
