import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:online_voting/models/accountDetails.dart';

class DatabaseService{

  final String uid;
  DatabaseService({this.uid});

  Future updateUserData({String name,String email,DateTime dateOfBirth,String mobileNo,String userType})async{

    final CollectionReference userdata = Firestore.instance.collection('dataset');
    return await userdata.document(email).setData({
      'uid': uid,
      'name': name,
      'email': email,
      'dateOfBirth': DateFormat('yyyy-MM-dd').format(dateOfBirth),
      'mobileNo': mobileNo,
      'userType': userType,
    });
  }

  // AccountDetails _accountDetailsListFromSnapshot(DocumentSnapshot snapshot){
  //   return snapshot.data
  // }
  //
  // Stream<AccountDetails> get data{
  //   return userdata.document(uid).map(_accountDetailsListFromSnapshot);
  // }


}