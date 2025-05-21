import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/detail_cubit.dart';
import '../../data/entity/todo.dart';
import '../cubits/home_cubit.dart';

class DetailPage extends StatelessWidget {
  final ToDo todo;
  const DetailPage({Key? key, required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailCubit(),
      child: DetailView(todo: todo),
    );
  }
}

class DetailView extends StatefulWidget {
  final ToDo todo;
  const DetailView({Key? key, required this.todo}) : super(key: key);

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.todo.name);
  }

  void _updateToDo() async {
    if (_controller.text.trim().isEmpty) return;
    final updatedToDo = ToDo(id: widget.todo.id, name: _controller.text.trim());
    await context.read<DetailCubit>().updateToDo(updatedToDo);
    context.read<HomeCubit>().loadToDos();
    Navigator.pop(context);
  }

  void _deleteToDo() async {
    await context.read<DetailCubit>().deleteToDo(widget.todo.id!);
    context.read<HomeCubit>().loadToDos();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yapılacak Detayı',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'Yapılacak',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: _updateToDo,
                        icon: const Icon(Icons.update,color: Colors.white,),
                        label: const Text('Güncelle',style: TextStyle(color: Colors.white),),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: _deleteToDo,
                        icon: const Icon(Icons.delete,color: Colors.white,),
                        label: const Text('Sil',style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}