import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/entity/todo.dart';
import '../../data/repo/todo_repository.dart';

class HomeCubit extends Cubit<List<ToDo>> {
  HomeCubit() : super(<ToDo>[]);
  final repository = ToDoRepository();

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