import 'package:firebase_auth/firebase_auth.dart';
import 'package:online_voting/models/user.dart';
import 'package:online_voting/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
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
  Future loginWithEmailAndPassword(String email, String password,String userType)async{
    try{
      await Firestore.instance.collection('dataset').document(email).get()
          .then((value)async {
        if(userType == value.data['userType'].toString()){
          dynamic result = await _auth.signInWithEmailAndPassword(email: email, password: password);
          FirebaseUser user = result.currUser;
          return _userFromFirebaseUser(user);
        }else{
          return null;
        }
      });
    }catch(e){
      // print(e.toString());
      print('yolololo 2');
      return null;
    }
  }

  // Future verifyMobileNo(String mobileNo)async{
  //   try{
  //     await _auth.verifyPhoneNumber(
  //       phoneNumber: '+91'+mobileNo,
  //       timeout: Duration(minutes: 5),
  //       verificationCompleted: null,
  //       verificationFailed: (AuthException e) {
  //         if (e.code == 'invalid-phone-number') {
  //           print('The provided phone number is not valid.');
  //         }
  //
  //         // Handle other errors
  //       },
  //       codeSent:(String verificationId, int resendToken) async {
  //         // Update the UI - wait for the user to enter the SMS code
  //         String smsCode = 'xxxx';
  //
  //         // Create a PhoneAuthCredential with the code
  //         PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider
  //             .credential(verificationId: verificationId, smsCode: smsCode);
  //         await auth.signInWithCredential(phoneAuthCredential);
  //       },
  //     );
  //   }catch(e){
  //     print(e.toString());
  //     return null;
  //   }
  // }


  // register with email pwd
  Future registerWithEmailAndPassword(String email, String password,String name,DateTime dateOfBirth,String mobileNo,String userType,String orgName,int electionCount) async{
    try{
      // AuthResult result = await _auth.signInWithCustomToken(token: nul)
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;


      await DatabaseService(uid : user.uid).updateUserData(name:name, email:email,dateOfBirth:dateOfBirth,mobileNo:mobileNo,userType:userType,orgName:orgName,electionCount:electionCount);

      return _userFromFirebaseUser(user);

    } catch(e){
      print(e.toString());
      return null;
    }
  }

  Future updateData({ String email = '',String name = '',DateTime dateOfBirth,String mobileNo='',String userType}) async {
    try{
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      if(email.isNotEmpty){
        user.updateEmail(email);
      }

      await DatabaseService(uid : user.uid).updateUserData(name:name, email:email,dateOfBirth:dateOfBirth,mobileNo:mobileNo,userType:userType);
      return _userFromFirebaseUser(user);

    } catch(e){
      print(e.toString());
      return null;
    }
  }

  Future<FirebaseUser> getCurrentUser() async{
    try{
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      return user;

    }catch(e){
      print(e.toString());
      return null;
    }
  }

  Future signOut() async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }

}