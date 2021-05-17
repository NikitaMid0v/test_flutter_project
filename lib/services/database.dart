import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_flutter_project/model/post.dart';
import 'package:test_flutter_project/model/user.dart';

class DataBaseService {
  final CollectionReference userCollectionReference =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference postCollectionReference =
      FirebaseFirestore.instance.collection('posts');

  Future createUser(LocalUser user) async {
    return await userCollectionReference
        .doc(user.id)
        .set(user.toMap());
  }

  Future createPost(Post post) async {
    return await postCollectionReference
        .doc(post.id)
        .set(post.toMap());
  }

  Future<LocalUser> getUser(String id) async {
    LocalUser userFromDB;
    if (id != null) {
      DocumentSnapshot snapshot =
          await userCollectionReference.doc(id).get();
      userFromDB = LocalUser.fromJson(snapshot.data());
      return userFromDB;
    }
    return null;
  }

  Future<String> getUserName(String id) async {
    LocalUser userFromDB = await getUser(id);
    if (userFromDB != null) {
      return userFromDB.name;
    }
    return null;
  }

  Future<List<Post>> getPosts() async {
    QuerySnapshot snapshot = await postCollectionReference.orderBy("timeStamp").get();
    return snapshot.docs
        .map((doc) => Post.fromJson(doc.id, doc.data()))
        .toList();
  }
}
