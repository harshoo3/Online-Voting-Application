import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:online_voting/models/accountDetails.dart';

class DatabaseService{

  final String uid;
  DatabaseService({this.uid});

  final CollectionReference userdata = Firestore.instance.collection('userdata');

  Future updateUserData(String name,String email,DateTime dateTime)async{
    return await userdata.document(uid).setData({
      'name': name,
      'email': email,
      'dateOfBirth': DateFormat('yyyy-MM-dd').format(dateTime),
    });
  }

  List<AccountDetails> _accountDetailsListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return AccountDetails(
        name: doc.data['name']?? '',
        email: doc.data['email']?? '',
        dateOfBirth: doc.data['dateOfBirth']??'',
      );
    }).toList();
  }

  Stream<List<AccountDetails>> get data{
    return userdata.snapshots().map(_accountDetailsListFromSnapshot);
  }


}