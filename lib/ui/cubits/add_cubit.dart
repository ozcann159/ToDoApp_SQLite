import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/entity/todo.dart';
import '../../data/repo/todo_repository.dart';

class AddCubit extends Cubit<void> {
  AddCubit() : super(null);
  final repository = ToDoRepository();

  Future<void> addToDo(String name) async {
    await repository.add(ToDo(name: name));
  }
}