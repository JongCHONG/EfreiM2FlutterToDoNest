import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todonest/models/my_task.dart';
import 'dart:async';

import '../models/my_user.dart';

class MyFirebaseHelper {
  final cloudUsers = FirebaseFirestore.instance.collection('users');
  final cloudTasks = FirebaseFirestore.instance.collection('tasks');
  final auth = FirebaseAuth.instance;

  Future<MyUser> getUser(uid) async {
    DocumentSnapshot snapshot = await cloudUsers.doc(uid).get();
    return MyUser(snapshot);
  }

  addUser(String uid, Map<String, dynamic> data) {
    cloudUsers.doc(uid).set(data);
  }

  Future<MyUser> inscription(
      String surname, String email, String password) async {
    UserCredential credential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    String id = credential.user!.uid;
    Map<String, dynamic> datas = {
      'surname': surname,
      'email': email,
      'createdAt': Timestamp.now(),
      'uid': id
    };
    addUser(id, datas);
    return getUser(id);
  }

  Future<MyUser> connexion(String email, String password) async {
    UserCredential credential =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    String id = credential.user!.uid;
    return getUser(id);
  }

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
}
