import 'package:flutter/material.dart';
import 'package:online_voting/customWidgets/customClassesAndWidgets.dart';
import 'package:online_voting/customWidgets/customMethods.dart';
import 'package:online_voting/models/candidate.dart';
import 'package:online_voting/models/electionClass.dart';
import 'package:online_voting/models/user.dart';
import 'package:online_voting/screens/elections/candidates/candidateWidget.dart';
import 'package:online_voting/screens/elections/countdown.dart';

class ElectionScreenStats extends StatefulWidget {
  ElectionClass election;
  BuildContext context;
  User user;
  int totalVoters;
  List<Candidate>confirmedCandidateList=[];
  ElectionScreenStats({this.election,this.user,this.totalVoters,this.context,this.confirmedCandidateList});
  @override
  _ElectionScreenStatsState createState() => _ElectionScreenStatsState(user:user,totalVoters: totalVoters,confirmedCandidateList:confirmedCandidateList, context: context,election: election);
}
class _ElectionScreenStatsState extends State<ElectionScreenStats> {
  ElectionClass election;
  BuildContext context;
  int totalVoters;
  User user;
  bool winnerFound = false;
  List<Candidate>confirmedCandidateList=[],winner=[];
  double progress,votePercentage;
  bool isUserWinner = false;
  _ElectionScreenStatsState({this.election,this.user,this.totalVoters,this.context,this.confirmedCandidateList});
  CustomMethods _customMethods = CustomMethods();

  findWinner(){
    if(election.endDate.difference(DateTime.now()).isNegative){
      if(confirmedCandidateList!=null){
        confirmedCandidateList.sort((b,a) => a.votes.compareTo(b.votes));
        print(confirmedCandidateList[0].votes);
        setState(() {
          winner.add(confirmedCandidateList[0]);
        });
        if(user.userType=='can' && !isUserWinner){
          if(winner[0].email == user.email){
            setState(() {
              isUserWinner = true;
            });
          }
        }
        for(int i=1;i<confirmedCandidateList.length;i++){
          print(confirmedCandidateList[i].votes);
          if(winner[0].votes>confirmedCandidateList[i].votes){
            break;
          }else{
            if(user.userType=='can' && !isUserWinner){
              if(confirmedCandidateList[i].email == user.email){
                setState(() {
                  isUserWinner = true;
                });
              }
            }
            setState(() {
              winner.add(confirmedCandidateList[i]);
            });
          }
        }
        setState(() {
          winnerFound = true;
        });
        print(winnerFound);
      }
    }
  }
  @override
  void initState() {
    findWinner();
    // TODO: implement initState
    super.initState();
  }
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
        winnerFound && winner!=null?Column(
          children: [
            Text(winner.length>1?"And the Winner is..\n It's a draw":'And the Winner is..',
              style: TextStyle(
                fontSize: 35,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10,),
            Column(
              children:
              winner.map((e) => CandidateWidget(candidate: e,election: election,user: user)).toList(),
            ),
            isUserWinner?Text("You've Won",
              style: TextStyle(
                fontSize: 35,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ):SizedBox(),
          ],
        ):SizedBox(),
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

