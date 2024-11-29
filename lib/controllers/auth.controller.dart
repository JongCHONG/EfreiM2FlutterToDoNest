import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todonest/main.dart';
import 'package:todonest/services/user.service.dart';
import 'dart:async';
import 'package:todonest/notifications/notifications.dart';

import '../models/my_user.dart';

class AuthController {
  final cloudUsers = FirebaseFirestore.instance.collection('users');
  final cloudTasks = FirebaseFirestore.instance.collection('tasks');
  final auth = FirebaseAuth.instance;

  final int maxLoginAttempts = 3;
  final int blockDuration = 60;

  Future<MyUser> register(String surname, String email, String password,
      BuildContext context) async {
    UserCredential credential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    String id = credential.user!.uid;
    Map<String, dynamic> datas = {
      'surname': surname,
      'email': email,
      'createdAt': Timestamp.now(),
      'uid': id,
      'loginAttempts': 0,
      'isBlocked': false,
      'blockUntil': null,
    };
    UserService().addUser(id, datas);

    Notifications.show(context, 'Inscription réussie !');

    return UserService().getUser(id);
  }

  Future<MyUser> connection(
      String email, String password, BuildContext context) async {
    try {
      QuerySnapshot querySnapshot =
          await cloudUsers.where('email', isEqualTo: email).get();

      if (querySnapshot.docs.isEmpty) {
        throw ('Utilisateur non trouvé');
      }

      DocumentSnapshot userDoc = querySnapshot.docs.first;
      MyUser user = MyUser(userDoc);

      if (user.isBlocked) {
        if (user.blockUntil != null &&
            DateTime.now().isBefore(user.blockUntil!)) {
          Notifications.show(
            context,
            'Votre compte est bloqué jusqu\'à ${user.blockUntil}',
          );
          throw ('Votre compte est bloqué jusqu\'à ${user.blockUntil}');
        } else {
          await cloudUsers.doc(user.uid).update({
            'isBlocked': false,
            'blockUntil': null,
            'loginAttempts': 0,
          });
        }
      }

      int attempts = user.loginAttempts;

      if (attempts == maxLoginAttempts) {
        await cloudUsers.doc(user.uid).update({
          'isBlocked': true,
          'blockUntil': Timestamp.fromDate(
              DateTime.now().add(Duration(seconds: blockDuration))),
        });
        throw ('Trop de tentatives échouées. Votre compte a été bloqué.');
      } else {
        await cloudUsers.doc(user.uid).update({
          'loginAttempts': attempts + 1,
        });
      }

      UserCredential credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      Notifications.show(context, 'Connexion réussie !');

      await cloudUsers.doc(user.uid).update({
        'loginAttempts': 0,
        'isBlocked': false,
        'blockUntil': null,
      });

      String id = credential.user!.uid;
      return UserService().getUser(id);
    } catch (e) {
      if (e is FirebaseAuthException) {
        print('Erreur de connexion Firebase : ${e.message}');

        return Future.error(e.toString());
      } else if (e is Exception) {
        print('Erreur: ${e.toString()}');

        return Future.error(e.toString());
      }

      rethrow;
    }
  }

  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
          builder: (context) => const MyHomePage(
                title: 'TodoNest',
              )),
      (Route<dynamic> route) => false,
    );

    Notifications.show(context, 'Déconnexion réussi !');
  }
}
