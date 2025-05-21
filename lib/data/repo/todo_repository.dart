import 'package:bootcamp_proje/data/entity/todo.dart';
import 'package:bootcamp_proje/data/sqlite/database_helper.dart';


class ToDoRepository {
  final dbHelper = DatabaseHelper();

  Future<void> add(ToDo todo) async {
    await dbHelper.insertToDo(todo);
  }

  Future<List<ToDo>> loadToDos() async {
    return await dbHelper.getToDos();
  }

  Future<List<ToDo>> search(String searchText) async {
    return await dbHelper.getToDos(query: searchText);
  }

  Future<void> delete(int id) async {
    await dbHelper.deleteToDo(id);
  }

  Future<void> update(ToDo todo) async {
    await dbHelper.updateToDo(todo);
  }
}