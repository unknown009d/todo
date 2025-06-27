// use BlocBuilder

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:todd/domain/models/todo.dart';
import 'package:todd/presentation/todo_cubit.dart';
import 'package:todd/presentation/widgets/add_todo_sheet.dart';

class TodoView extends StatelessWidget {
  const TodoView({super.key});

  @override
  Widget build(BuildContext context) {
    final todoCubit = context.read<TodoCubit>();

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color(0xFF418377),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 40,
                            offset: Offset(2, 4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/icon/icon.png'),
                        radius: 24,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "WHY ARE YOU HERE?",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "JUST TO SUFFER",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.add_box_outlined),
              title: Text("Create"),
              onTap: () {
                Navigator.of(context).pop();
                showAddTodoSheet(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.remove_circle_outline),
              title: Text("Remove"),
              onTap: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Slide the list items to delete!"),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text("Information"),
              onTap: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Technically Developed by Druba"),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: Icon(
              Icons.menu,
            ),
          ),
        ),
        title: Text("Same old todo bull*hit"),
        backgroundColor: const Color(0xFF418377),
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              if (value == 'share') {
                final todos = context.read<TodoCubit>().state;
                _shareTodos(context, todos);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'share',
                  child: Text("Share"),
                ),
              ];
            },
          ),
        ],
      ),
      body: BlocBuilder<TodoCubit, List<Todo>>(
        builder: (context, todos) {
          if (todos.isEmpty) {
            return Center(
              child: Text(
                "No tasks yet! Swipe up to create task.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];

              return Dismissible(
                key: Key(todo.id.toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red[400],
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  // if(direction == DismissDirection.endToStart)
                  todoCubit.deleteTodo(todo);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Deleted ${todo.text}"),
                      action: SnackBarAction(
                        label: "Undo",
                        onPressed: () => todoCubit.addTodo(todo.text),
                      ),
                    ),
                  );
                },
                child: ListTile(
                  onTap: () => todoCubit.toggleCompletion(todo),
                  title: Text(
                    todo.text,
                    style: TextStyle(
                      decoration: todo.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  leading: Checkbox(
                    value: todo.isCompleted,
                    onChanged: (value) => todoCubit.toggleCompletion(todo),
                  ),
                  trailing: IconButton(
                    tooltip: "Remove todo",
                    onPressed: () => todoCubit.deleteTodo(todo),
                    icon: const Icon(Icons.cancel_outlined),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _shareTodos(BuildContext context, List<Todo> todos) {
    final todoText = [
      'Tasks:',
      if (todos.isEmpty)
        'No task'
      else ...[
        for (final todo in todos)
          '- ${todo.text} – ${todo.isCompleted ? '✅' : '⛔'}',
      ],
    ].join('\n');

    SharePlus.instance.share(
      ShareParams(title: "Todo app tasks", text: todoText),
    );
  }
}
