import 'package:flutter/material.dart';
import 'package:online_voting/customWidgets/customClassesAndWidgets.dart';
import 'package:online_voting/customWidgets/customMethods.dart';
import 'package:online_voting/models/electionClass.dart';
import 'package:online_voting/screens/elections/countdown.dart';

class ElectionScreenStats extends StatefulWidget {
  ElectionClass election;
  BuildContext context;
  int totalVoters;
  ElectionScreenStats({this.election,this.totalVoters,this.context});
  @override
  _ElectionScreenStatsState createState() => _ElectionScreenStatsState(totalVoters: totalVoters,context: context,election: election);
}
class _ElectionScreenStatsState extends State<ElectionScreenStats> {
  ElectionClass election;
  BuildContext context;
  int totalVoters;
  double progress,votePercentage;
  _ElectionScreenStatsState({this.election,this.totalVoters,this.context});
  CustomMethods _customMethods = CustomMethods();

  @override
  Widget build(context) {
    votePercentage =_customMethods.calculateVotePercentage(votes: election.votes,totalVoters: totalVoters);
    progress = _customMethods.calculateElectionProgress(election);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        election.startDate.difference(DateTime.now()).inSeconds>0?Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('The voting is yet to begin...',
              style: TextStyle(
                fontSize: 30,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 5,),
            Text('Countdown till the election'),
            StartDateCountdown(startDate: election.startDate,),
          ],
        ):election.endDate.difference(DateTime.now()).inSeconds>0?
        Text('The voting has begun...',
          style: TextStyle(
            fontSize: 30,
            color: Colors.black,
          ),
        ):Text('The voting has ended...',
          style: TextStyle(
            fontSize: 30,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 25,),
        Text('Election Progress...',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        ElectionProgress(election: election,progress: progress,big: true),
        SizedBox(height: 25,),
        VotePercentage(votePercentage: votePercentage,big: true),
      ],
    );
  }
}

