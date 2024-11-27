import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todonest/main.dart';
import 'package:todonest/services/user.service.dart';
import 'dart:async';

import '../models/my_user.dart';

class AuthController {
  final cloudUsers = FirebaseFirestore.instance.collection('users');
  final cloudTasks = FirebaseFirestore.instance.collection('tasks');
  final auth = FirebaseAuth.instance;

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
    UserService().addUser(id, datas);
    return UserService().getUser(id);
  }

  Future<MyUser> connexion(String email, String password) async {
    UserCredential credential =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    String id = credential.user!.uid;
    return UserService().getUser(id);
  }

    void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const MyHomePage(title: 'TodoNest',)),
      (Route<dynamic> route) => false,
    );
  }
}
