import 'package:cloud_firestore/cloud_firestore.dart';

class MyTask {
  late String title;
  late String id;
  late String userId;
  late bool completed;

  MyTask.empty() {
    id = "";
    title = "";
    userId = "";
    completed = false;
  }

  MyTask(DocumentSnapshot snapshot) {
    id = snapshot.id;
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
    title = map["title"] ?? "";
    completed = map["completed"] ?? false;
    userId = map["userId"] ?? "";
  }
}
