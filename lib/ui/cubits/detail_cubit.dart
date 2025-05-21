import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/entity/todo.dart';
import '../../data/repo/todo_repository.dart';

class DetailCubit extends Cubit<void> {
  DetailCubit() : super(null);
  final repository = ToDoRepository();

  Future<void> updateToDo(ToDo todo) async {
    await repository.update(todo);
  }

  Future<void> deleteToDo(int id) async {
    await repository.delete(id);
  }
}