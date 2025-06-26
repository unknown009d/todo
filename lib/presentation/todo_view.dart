// use BlocBuilder

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:todd/domain/models/todo.dart';
import 'package:todd/presentation/todo_cubit.dart';
import 'package:todd/presentation/widgets/add_todo_sheet.dart';

class TodoView extends StatelessWidget {
  const TodoView({super.key});

  // void _showAddTodoBox(BuildContext context) {
  //   final todoCubit = context.read<TodoCubit>();
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       final textController = TextEditingController();
  //       return AlertDialog(
  //         content: TextField(
  //           controller: textController,
  //           autofocus: true,
  //           decoration: const InputDecoration(
  //             labelText: "Name of Todo",
  //             border: OutlineInputBorder(),
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             child: const Text("Cancel"),
  //           ),
  //           FilledButton(
  //             onPressed: () {
  //               if (textController.text.isEmpty) {
  //                 ScaffoldMessenger.of(
  //                   context,
  //                 ).showSnackBar(
  //                   SnackBar(
  //                     content: Text("Doiya koira kicchu likhun!"),
  //                     action: SnackBarAction(label: "Okay", onPressed: () {}),
  //                   ),
  //                 );
  //               } else {
  //                 todoCubit.addTodo(textController.text);
  //               }
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text("Add"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

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
                color: Colors.indigoAccent,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    content: Text("What more info do you want?"),
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
        backgroundColor: Colors.indigoAccent,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text("Share"),
                  onTap: () {
                    SharePlus.instance.share(
                      ShareParams(
                        text: "Check this out!",
                      ),
                    );
                  },
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
}
