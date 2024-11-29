import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  late String email;
  late String surname;
  late String uid;

  MyUser.empty() {
    uid = "";
    email = "";
    surname = "";
  }

  MyUser(DocumentSnapshot snapshot) {
    uid = snapshot.id;
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
    email = map["email"] ?? "";
    surname = map["surname"] ?? "";
  }
}
