/*

- use BlocProvider

*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todd/domain/repository/todo_repo.dart';
import 'package:todd/presentation/todo_cubit.dart';
import 'package:todd/presentation/todo_view.dart';
import 'package:todd/presentation/widgets/add_todo_sheet.dart';

class TodoPage extends StatelessWidget {
  final TodoRepo todoRepo;

  const TodoPage({super.key, required this.todoRepo});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoCubit(todoRepo),
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: GestureDetector(
              onVerticalDragEnd: (details) {
                if (details.primaryVelocity != null &&
                    details.primaryVelocity! < -300) {
                  showAddTodoSheet(context);
                }
              },
              child: Stack(
                children: [
                  const TodoView(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      color: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
