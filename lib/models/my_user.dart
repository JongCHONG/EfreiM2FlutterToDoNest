import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  late String email;
  late String surname;
  late String uid;
  late int loginAttempts;
  late bool isBlocked;
  late DateTime? blockUntil;

  MyUser.empty() {
    uid = "";
    email = "";
    surname = "";
    loginAttempts = 0;
    isBlocked = false;
    blockUntil = null;
  }

  MyUser(DocumentSnapshot snapshot) {
    uid = snapshot.id;
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
    email = map["email"] ?? "";
    surname = map["surname"] ?? "";
    loginAttempts = map["loginAttempts"] ?? 0;
    isBlocked = map["isBlocked"] ?? false;
    blockUntil = (map["blockUntil"] as Timestamp?)?.toDate();
  }
}
