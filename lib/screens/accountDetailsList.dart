import 'package:flutter/material.dart';
import 'package:online_voting/models/accountDetails.dart';
import 'package:provider/provider.dart';

class AccountDetailsList extends StatefulWidget {
  @override
  _AccountDetailsListState createState() => _AccountDetailsListState();
}

class _AccountDetailsListState extends State<AccountDetailsList> {
  @override
  Widget build(BuildContext context) {

    final data = Provider.of<List<AccountDetails>>(context);
    // print(data.documents);
    data.forEach((element) {
      print(element.dateOfBirth);
      print(element.email);
      print(element.name);
    });
    return Container();
  }
}
