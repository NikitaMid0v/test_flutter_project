
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_flutter_project/model/user.dart';
import 'package:test_flutter_project/services/database.dart';

class AuthService{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<LocalUser> signInWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return DataBaseService().getUser(LocalUser.fromFireBase(user).id);
    } catch (e){
      print(e);
      return null;
    }
  }

  Future<LocalUser> signUpWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      DataBaseService().createUser(LocalUser.fromFireBase(user));
      return LocalUser.fromFireBase(user);
    } catch (e){
      print(e);
      return null;
    }
  }

  Future logout() async {
    await _firebaseAuth.signOut();
  }

  Stream<LocalUser> get currentUser{
    return _firebaseAuth.authStateChanges().map((user) => user != null ? LocalUser.fromFireBase(user) : null);
  }
}