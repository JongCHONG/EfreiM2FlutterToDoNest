import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/my_task.dart';

class TaskService {
  final CollectionReference cloudTasks =
      FirebaseFirestore.instance.collection('tasks');
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<MyTask> addTask(String title) async {
    User? currentUser = auth.currentUser;

    if (currentUser == null) {
      throw Exception("Aucun utilisateur connecté");
    }

    DocumentReference taskRef = cloudTasks.doc();

    Map<String, dynamic> taskData = {
      'title': title,
      'completed': false,
      'createdAt': Timestamp.now(),
      'userId': currentUser.uid
    };

    await taskRef.set(taskData);

    DocumentSnapshot newTaskSnapshot = await taskRef.get();

    MyTask newTask = MyTask(newTaskSnapshot);

    return newTask;
  }

  Future<List<MyTask>> getTasksForCurrentUser() async {
    User? currentUser = auth.currentUser;

    if (currentUser == null) {
      throw Exception("Aucun utilisateur connecté");
    }
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('tasks')
          .where('userId', isEqualTo: currentUser.uid)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => MyTask(doc)).toList();
    } catch (e) {
      print("erreur lors de la récupération des tâches: $e");
      throw e;
    }
  }

  Future<void> updateTask(String taskId, String newTitle) async {
    try {
      await cloudTasks
          .doc(taskId)
          .update({'title': newTitle, 'updatedAt': Timestamp.now()});
    } catch (e) {
      print("erreur lors de la mise à jour de la tâche: $e");
      throw e;
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await FirebaseFirestore.instance.collection('tasks').doc(taskId).delete();
    } catch (e) {
      print("Erreur lors de la supression de la tâche : $e");
      throw e;
    }
  }
}
