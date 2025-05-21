import 'package:bootcamp_proje/ui/cubits/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/entity/todo.dart';
import '../screens/detail_page.dart';
import 'package:bootcamp_proje/ui/screens/add_todo_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Yapılacaklar Listesi',
          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search,color: Colors.white,),
            onPressed: () async {
              final searchText = await showSearch<String>(
                context: context,
                delegate: ToDoSearchDelegate(homeCubit),
              );
              if (searchText != null) {
                homeCubit.search(searchText);
              }
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.deepPurple.shade50,
        child: BlocBuilder<HomeCubit, List<ToDo>>(
          builder: (context, todos) {
            if (todos.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inbox,
                      size: 80,
                      color: Colors.deepPurple.shade200,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Henüz yapılacak yok!',
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.deepPurple,
                      child: Text(
                        todo.name.isNotEmpty ? todo.name[0].toUpperCase() : '?',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      todo.name,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailPage(todo: todo),
                        ),
                      );
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () {
                        homeCubit.delete(todo.id!);
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepPurple,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  AddToDoPage()),
          );
          context.read<HomeCubit>().loadToDos();
        },
        icon: const Icon(Icons.add,color: Colors.white,),
        label: const Text('Ekle',style: TextStyle(color: Colors.white),),
      ),
    );
  }
}

class ToDoSearchDelegate extends SearchDelegate<String> {
  final HomeCubit homeCubit;
  List<ToDo> searchResults = [];

  ToDoSearchDelegate(this.homeCubit);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return BackButton(onPressed: () => close(context, ''));
  }

  @override
  Widget buildResults(BuildContext context) {
    // Burada arama yapıp sonuçları döndür.
    return FutureBuilder<List<ToDo>>(
      future: homeCubit.repository.search(query),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final results = snapshot.data!;
        if (results.isEmpty) {
          return Center(child: Text('No results found.'));
        }
        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final todo = results[index];
            return ListTile(
              title: Text(todo.name),
              onTap: () {
                close(context, todo.name);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DetailPage(todo: todo)),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Center(child: Text('Type to search'));
    }
    return FutureBuilder<List<ToDo>>(
      future: homeCubit.repository.search(query),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final suggestions = snapshot.data!;
        if (suggestions.isEmpty) {
          return Center(child: Text('No suggestions'));
        }
        return ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final todo = suggestions[index];
            return ListTile(
              title: Text(todo.name),
              onTap: () {
                query = todo.name;
                showResults(context);
              },
            );
          },
        );
      },
    );
  }
}
