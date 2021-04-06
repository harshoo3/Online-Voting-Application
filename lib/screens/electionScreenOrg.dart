import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_voting/models/electionClass.dart';
import 'package:online_voting/models/user.dart';
import 'package:online_voting/screens/loading.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ElectionScreenOrg extends StatefulWidget {
  User user;
  ElectionClass election;
  ElectionScreenOrg({this.election,this.user});
  @override
  _ElectionScreenOrgState createState() => _ElectionScreenOrgState(election: election,user: user);
}

class _ElectionScreenOrgState extends State<ElectionScreenOrg> {
  User user;
  ElectionClass election;
  _ElectionScreenOrgState({this.election,this.user});

  double calculatePercent(ElectionClass election){
    if(election!=null){
      num bigdiff = election.endDate.difference(election.startDate).inSeconds;
      num smalldiff = DateTime.now().difference(election.startDate).inSeconds;
      double ans = smalldiff/bigdiff;
      if(ans>1){
        return 1;
      }else if(ans<0){
        return 0;
      }else{
        return ans;
      }
    }
  }
  Future<void>getRequests()async{
    await Firestore.instance
        .collection('Elections')
        .document(user.name)
        .get()
        .then((value) {
          // for
          // value.data['waitingCandidates'][election.numOfWaitingCandidates-1]['candidateName'];
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: 300,
        child: FlatButton(
          color: Colors.black,
          child:Text(
            'Contest this election',
            style: TextStyle(
                color: Colors.white
            ),
          ),
          onPressed: ()async{
            await getRequests();
          },
        ),
      ),
    );
  }
}

