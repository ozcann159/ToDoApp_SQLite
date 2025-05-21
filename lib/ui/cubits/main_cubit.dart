import 'package:bootcamp_proje/data/entity/todo.dart';
import 'package:bootcamp_proje/data/repo/todo_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class MainCubit extends Cubit<List<ToDo>> {
  MainCubit() : super(<ToDo>[]);
  var repository = ToDoRepository();

  Future<void> loadToDos() async {
    var list = await repository.loadToDos();
    emit(list);
  }

  Future<void> search(String searchText) async {
    var list = await repository.search(searchText);
    emit(list);
  }

  Future<void> delete(int id) async {
    await repository.delete(id);
    await loadToDos();
  }
}