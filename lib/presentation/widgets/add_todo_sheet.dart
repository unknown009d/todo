import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todd/domain/models/todo.dart';
import 'package:todd/presentation/todo_cubit.dart';

void showAddTodoSheet(BuildContext context) {
  final todoCubit = context.read<TodoCubit>();
  final textController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        left: 28,
        right: 28,
        top: 48,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: textController,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: "Name of Todo",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () {
                  final text = textController.text.trim();
                  if (text.isEmpty) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Doiya koira kicchu likhun!"),
                        showCloseIcon: true,
                      ),
                    );
                  } else {
                    todoCubit.addTodo(text);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text("Add"),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
