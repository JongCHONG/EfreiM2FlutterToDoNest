import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  late String email;
  late String surname;
  late String id;

  MyUser.empty() {
    id = "";
    email = "";
    surname = "";
  }

  MyUser(DocumentSnapshot snapshot) {
    id = snapshot.id;
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
    email = map["email"] ?? "";
    surname = map["surname"] ?? "";
  }
}
