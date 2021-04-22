import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:online_voting/models/accountDetails.dart';

class DatabaseService{

  final String uid;
  DatabaseService({this.uid});

  Future setUserData({String name,String email,DateTime dateOfBirth,String mobileNo,String userType,String orgName,int electionCount})async{

    final CollectionReference userdata = Firestore.instance.collection('dataset');
    return await userdata.document(email).setData({
      'uid': uid,
      'name': name,
      'email': email,
      'dateOfBirth': DateFormat('yyyy-MM-dd').format(dateOfBirth),
      'mobileNo': mobileNo,
      'userType': userType,
      'orgName': orgName,
      'electionCount':electionCount,
    });

  }
  Future updateUserData({String email,DateTime dateOfBirth,String mobileNo,String userType})async{
    final CollectionReference userdata = Firestore.instance.collection('dataset');
    return await userdata.document(email).setData({
      'dateOfBirth': DateFormat('yyyy-MM-dd').format(dateOfBirth),
      'mobileNo': mobileNo,
    },merge: true);
  }
// AccountDetails _accountDetailsListFromSnapshot(DocumentSnapshot snapshot){
  //   return snapshot.data
  // }
  //
  // Stream<AccountDetails> get data{
  //   return userdata.document(uid).map(_accountDetailsListFromSnapshot);
  // }


}