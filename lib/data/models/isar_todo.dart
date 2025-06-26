/*

ISAR Todo Model

Converts todo model into isar todo model that we can store in our isar db.

*/

import 'package:isar/isar.dart';
import 'package:todd/domain/models/todo.dart';

part 'isar_todo.g.dart';

@collection
class TodoIsar {
  Id id = Isar.autoIncrement;
  late String text;
  late bool isCompleted;

  // Converting ISAR object to Document object
  Todo toDomain() {
    return Todo(
      id: id,
      text: text,
      isCompleted: isCompleted,
    );
  }

  // Converting Document object to ISAR object
  static TodoIsar fromDomain(Todo todo) {
    return TodoIsar()
      ..id = todo.id
      ..text = todo.text
      ..isCompleted = todo.isCompleted;
  }
}
