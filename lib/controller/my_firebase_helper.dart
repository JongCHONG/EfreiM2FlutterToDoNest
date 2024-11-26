import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import '../models/my_user.dart';

class MyFirebaseHelper {
  final cloudUsers = FirebaseFirestore.instance.collection('users');
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
}
