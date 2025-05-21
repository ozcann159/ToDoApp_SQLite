import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/add_cubit.dart';

class AddToDoPage extends StatelessWidget {
  const AddToDoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddCubit(),
      child: const AddToDoView(),
    );
  }
}

class AddToDoView extends StatefulWidget {
  const AddToDoView({Key? key}) : super(key: key);

  @override
  State<AddToDoView> createState() => _AddToDoViewState();
}

class _AddToDoViewState extends State<AddToDoView> {
  final TextEditingController _controller = TextEditingController();

  void _saveToDo() async {
    if (_controller.text.trim().isEmpty) return;
    await context.read<AddCubit>().addToDo(_controller.text.trim());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Yapılacak Ekle',style: TextStyle(color: Colors.white),),
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
                const SizedBox(height: 20),
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'Yapılacak',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: _saveToDo,
                    icon: const Icon(Icons.save),
                    label: const Text('Kaydet', style: TextStyle(fontSize: 18,color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}