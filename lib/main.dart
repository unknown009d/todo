import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todd/data/models/isar_todo.dart';
import 'package:todd/data/repository/isar_todo_repo.dart';
import 'package:todd/domain/repository/todo_repo.dart';
import 'package:todd/presentation/todo_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // get dir for storing
  final dir = await getApplicationDocumentsDirectory();

  // open isar db
  final isar = await Isar.open([TodoIsarSchema], directory: dir.path);

  //initialize the repo with isar db
  final isarTodoRepo = IsarTodoRepo(isar);

  // run app
  runApp(
    MainApp(
      todoRepo: isarTodoRepo,
    ),
  );
}

class MainApp extends StatelessWidget {
  final TodoRepo todoRepo;

  const MainApp({super.key, required this.todoRepo});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          elevation: 0,
          backgroundColor: Color.fromARGB(255, 28, 28, 29),
          contentTextStyle: TextStyle(color: Colors.white),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: TodoPage(todoRepo: todoRepo),
    );
  }
}
