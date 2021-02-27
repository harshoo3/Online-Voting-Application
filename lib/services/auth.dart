import 'package:firebase_auth/firebase_auth.dart';
import 'package:online_voting/models/user.dart';
import 'package:online_voting/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user obj based on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user){
    return user!= null ? User(uid: user.uid):null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged
    // .map((FirebaseUser user) => _userFromFirebaseUser(user));
    .map(_userFromFirebaseUser);
  }

  // sign in anonymously
  Future signInAnon() async {
    try{
      AuthResult result=  await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);

    } catch(e){
      print(e.toString());
      return null;
    }
  }

  // sign in w email pwd
  Future loginWithEmailAndPassword(String email, String password) async{
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);

    }catch(e){
      print(e.toString());
      return null;
    }
  }

  // register with email pwd
  Future registerWithEmailAndPassword(String email, String password,String name,DateTime dateTime) async{
    try{
      // AuthResult result = await _auth.
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      await DatabaseService(uid : user.uid).updateUserData(name, email,dateTime);

      return _userFromFirebaseUser(user);

    } catch(e){
      print(e.toString());
      return null;
    }
  }

  Future updateData({ String email = '',String name = ''}) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    Firestore.instance
        .collection('userdata')
        .document(user.uid)
        .updateData({
      'email':email,
      'name':name,
    });
  }

  Future getCurrentUser()async{
    try{
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      return _userFromFirebaseUser(user);

    }catch(e){
      print(e.toString());
      return null;
    }
  }

  // Future sendEmailVerification()async{
  //   try{
  //     AuthResult result = await _auth.
  //   }
  // }
  //sign out

  Future signOut() async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }

}