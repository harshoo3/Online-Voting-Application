import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:online_voting/models/accountDetails.dart';

class DatabaseService{

  final String uid;
  DatabaseService({this.uid});

  final CollectionReference userdata = Firestore.instance.collection('userdata');

  Future updateUserData(String name,String email,DateTime dateTime,String mobileNo)async{
    return await userdata.document(uid).setData({
      'name': name,
      'email': email,
      'dateOfBirth': DateFormat('yyyy-MM-dd').format(dateTime),
      'mobileNo': mobileNo,
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