import 'package:bootcamp_proje/ui/cubits/add_cubit.dart';
import 'package:bootcamp_proje/ui/cubits/detail_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'ui/screens/home_page.dart';
import 'ui/cubits/home_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>(
          create: (context) => HomeCubit()..loadToDos(),
        ),
        BlocProvider<DetailCubit>(
          create: (context) => DetailCubit(),
        ),
        BlocProvider<AddCubit>(
          create: (context) => AddCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'To Do App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home:  HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}