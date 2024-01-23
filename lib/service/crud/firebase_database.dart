import 'package:chat_app/service/auth_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // read all contacts
  Stream<QuerySnapshot> allUsers() {
    final users = _firestore.collection('users').snapshots();
    return users;
  }

  // TOTAL USERS

  // ADD USER
  Future<void> addUser(
      String email, String userName, String uid, String photoUrl) async {
    await _firestore.collection('users').doc(uid).set({
      'email': email,
      'userName': userName,
      'uid': uid,
      'photoUrl': photoUrl,
    });
  }

  // GET USER
  Future<DocumentSnapshot> getUser(String uid) async {
    final user = await _firestore.collection('users').doc(uid).get();
    return user;
  }

  // SEND MESSAGE
  Future<void> sendMessage(
      String message, String senderUID, String receiverUID) async {
    // make unique chat id
    final usersList = [senderUID, receiverUID];
    usersList.sort();
    final chatId = usersList.join("_");

    // save message
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'message': message,
      'sender': senderUID,
      'receiver': receiverUID,
      'timestamp': DateTime.now(),
    });
  }

  // GET MESSAGES
  Stream<QuerySnapshot> getMessages(String senderUID, String receiverUID) {
    // make unique chat id
    final usersList = [senderUID, receiverUID];
    usersList.sort();
    final chatId = usersList.join("_");

    // get messages
    final messages = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();

    return messages;
  }

  // UPDATE USERNAME
  Future<void> updateUserName(String uid, String newName) async {
    final user = _firestore.collection('users').doc(uid);
    user.update({"userName": newName});
  }

  // DELETE ACCOUNT
  Future<void> deleteUser(String? uid) async {
    if (uid == '') return;
    _firestore.collection('users').doc(uid).delete();
  }
}
