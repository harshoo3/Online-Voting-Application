import 'package:flutter/material.dart';
import 'package:online_voting/models/electionClass.dart';
import 'package:online_voting/models/user.dart';
import 'package:online_voting/screens/home/sidebar.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/cupertino.dart';

class ViewElectionDetails extends StatelessWidget {
  User user;
  ElectionClass election;
  ViewElectionDetails({this.user,this.election});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Create Elections'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      endDrawer: SideDrawer(user: user,context: context),
      body: Column(
        children: [
          Center(child: SizedBox(height: 25.0)),
          SizedBox(
            width: 300,
            child: DateTimeFormField(
              decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                suffixIcon: Icon(Icons.event_note),
                labelText: 'Election Start Date...',
              ),
              mode: DateTimeFieldPickerMode.dateAndTime,
              initialValue: election.startDate,
            ),
          ),
          SizedBox(height: 25.0),
          SizedBox(
          width: 300,
            child: DateTimeFormField(
              decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                suffixIcon: Icon(Icons.event_note),
                labelText: 'Election Start Date...',
              ),
              mode: DateTimeFieldPickerMode.dateAndTime,
              initialValue: election.endDate,
            ),
          ),
          SizedBox(height: 25.0),
          SizedBox(
            width: 300,
            child: TextFormField(
              obscureText: false,
              readOnly: true,
              initialValue: election.post,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                suffixIcon: Icon(Icons.account_balance_outlined),
                labelText: "The Post for election...",
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
              ),
            ),
          ),
          SizedBox(height: 25,),
          SizedBox(
            width: 270,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Is Party system allowed?'),
                CupertinoSwitch(
                  activeColor: Colors.blue,
                  value: election.isPartyModeAllowed,
                  onChanged: (value) {
                  //   print("VALUE : $value");
                  //   setState(() {
                  //     isPartyModeAllowed = value;
                  //   });
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 25,),
          SizedBox(
            width: 300,
            child: TextFormField(
              initialValue: election.maxCandidates.toString(),
              // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              readOnly: true,
              obscureText: false,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                suffixIcon: Icon(Icons.person),
                labelText: "The Max number of Candidates...",
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
              ),
            ),
          ),
          SizedBox(height: 25.0),
          SizedBox(
            width: 300,
            height: 140,
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              initialValue: election.electionDescription,
              readOnly: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                suffixIcon: Icon(Icons.edit),
                labelText: "Election Description...",
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
              ),
            ),
          ),
        ],
      ),
    );
  }
}
