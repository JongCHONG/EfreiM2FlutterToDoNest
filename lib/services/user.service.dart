import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/my_user.dart';

class UserService {
  final CollectionReference _cloudUsers =
      FirebaseFirestore.instance.collection('users');

  void addUser(String uid, Map<String, dynamic> data) {
    _cloudUsers.doc(uid).set(data);
  }

  Future<MyUser> getUser(String uid) async {
    DocumentSnapshot snapshot = await _cloudUsers.doc(uid).get();
    return MyUser(snapshot);
  }
}
