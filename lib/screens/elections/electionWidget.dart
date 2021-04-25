import 'package:flutter/material.dart';
import 'package:online_voting/customWidgets/customClassesAndWidgets.dart';
import 'package:online_voting/customWidgets/customMethods.dart';
import 'package:online_voting/models/electionClass.dart';
import 'package:online_voting/models/user.dart';
import 'package:online_voting/screens/elections/organisations/electionScreenOrg.dart';
import 'package:online_voting/screens/elections/voters/electionScreenVot.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:online_voting/screens/elections/candidates/electionScreenCan.dart';
import 'package:intl/intl.dart';
class ElectionWidget extends StatefulWidget {
  User user;
  ElectionClass election;
  ElectionWidget({this.election,this.user});
  @override
  _ElectionWidgetState createState() => _ElectionWidgetState(election:election,user:user);
}

class _ElectionWidgetState extends State<ElectionWidget> {
  ElectionClass election;
  User user;
  CustomMethods _customMethods = CustomMethods();
  double progress,votePercentage;
  _ElectionWidgetState({this.election,this.user});

  @override
  Widget build(BuildContext context) {
    votePercentage =_customMethods.calculateVotePercentage(votes: election.votes,totalVoters: user.totalVoters);
    progress = _customMethods.calculateElectionProgress(election);
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: SizedBox(
          height: 150,
          width: 300,
          child: FlatButton(
            onPressed: (){
              if(user.userType == 'can'){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ElectionScreenCan(election:election,user:user)));
              }else if(user.userType == 'org'){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ElectionScreenOrg(election:election,user:user)));
              }else{
                Navigator.push(context, MaterialPageRoute(builder: (context) => ElectionScreenVot(election:election,user:user)));
              }
            },
            color: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Post:   ${election.post}',
                      style: TextStyle(
                        fontSize: 20,
                        color:Colors.white,
                      ),
                    ),
                    VotePercentage(votePercentage: votePercentage,big: false),
                  ],
                ),
                ElectionProgress(election: election,progress: progress,big: false)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
