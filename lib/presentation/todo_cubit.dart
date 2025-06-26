//  Todo Cubit StateManagement
//  Each cubit is a list of todos.

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todd/domain/models/todo.dart';
import 'package:todd/domain/repository/todo_repo.dart';

class TodoCubit extends Cubit<List<Todo>> {
  final TodoRepo todoRepo;

  TodoCubit(this.todoRepo) : super([]) {
    loadTodos();
  }

  // Load
  Future<void> loadTodos() async {
    final todoList = await todoRepo.getTodos();

    // emit the fetched data
    emit(todoList);
  }

  // Add
  Future<void> addTodo(String text) async {
    final newTodo = Todo(
      id: DateTime.now().millisecond,
      text: text,
    );

    // save the new todo
    await todoRepo.addTodo(newTodo);

    // re-load
    loadTodos();
  }

  // Delete
  Future<void> deleteTodo(Todo todo) async {
    await todoRepo.deleteTodo(todo);
    loadTodos();
  }

  // Toggle
  Future<void> toggleCompletion(Todo todo) async {
    final updatedTodo = todo.toggleCompletion();
    await todoRepo.updateTodo(updatedTodo);
    loadTodos();
  }
}
