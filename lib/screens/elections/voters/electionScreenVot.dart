import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_voting/models/candidate.dart';
import 'package:online_voting/models/electionClass.dart';
import 'package:online_voting/models/user.dart';
import 'package:online_voting/models/voter.dart';
import 'package:online_voting/screens/elections/candidates/candidateWidget.dart';
import 'package:online_voting/screens/sidebarAndScreens/sidebar.dart';
import 'package:online_voting/screens/elections/viewElectionDetails.dart';
import 'package:online_voting/screens/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_voting/screens/elections/electionScreenStats.dart';
import 'package:online_voting/customWidgets/customClassesAndWidgets.dart';
class ElectionScreenVot extends StatefulWidget {
  User user;
  ElectionClass election;

  ElectionScreenVot({this.election,this.user});
  @override
  _ElectionScreenVotState createState() => _ElectionScreenVotState(user: user,election: election);
}

class _ElectionScreenVotState extends State<ElectionScreenVot> {
  User user;
  ElectionClass election;
  List<dynamic> hasVotedInElection=[],hasVotedFor=[];
  _ElectionScreenVotState({this.election,this.user});
  List  <Candidate>candidateList=[],losers=[];
  List<dynamic> indicesList =[];
  bool detailsFetched = false;
  Voter voter;
  bool hasVoted = false;
  bool noCandidates = false;
  Future<void>getCandidates()async{
    await Firestore.instance
        .collection('Elections')
        .document(user.orgName)
        .get()
        .then((value) {
      try{
        value.data['${election.index}']['candidates'].keys.forEach((element) {
          indicesList.add(element);
        });
        for(var i = 0;i<indicesList.length;i++){
          Map<dynamic,dynamic> map = value.data['${election.index}']['candidates'][indicesList[i]];
          if(election.isPartyModeAllowed && map['approved']){
            setState(() {
              candidateList.add(
                Candidate(
                  partyLogoUrl: map['partyLogoUrl'],
                  partyName: map['partyName'],
                  approved: map['approved'],
                  denied: map['denied'],
                  campaignTagline: map['campaignTagline'],
                  name: map['name'],
                  email: map['email'],
                  votes:map['votes'],
                  questions: map['questions'],
                  index: indicesList[i],
                ),
              );
            });
          }else if(map['approved']){
            setState(() {
              candidateList.add(
                Candidate(
                  votes:map['votes'],
                  approved: map['approved'],
                  denied: map['denied'],
                  name: map['name'],
                  email: map['email'],
                  questions: map['questions'],
                  index: indicesList[i],
                ),
              );
            });
          }
        }
      }catch(e){
        print(e);
        setState(() {
          noCandidates = true;
        });
      }
    });
  }
  Future<void>checkIfVoted()async{
    await Firestore.instance
        .collection('dataset')
        .document(user.email)
        .get()
        .then((value) {
      try{
        print(value.data['hasVotedInElection']);
        setState(() {
          hasVotedInElection.addAll(value.data['hasVotedInElection']);
          hasVotedFor.addAll(value.data['hasVotedFor']);
        });
        setState(() {
          voter = Voter(hasVotedFor: hasVotedFor,hasVotedInElection: hasVotedInElection);
        });
        if(voter.hasVotedInElection.isNotEmpty){
          for(int i=0;i<voter.hasVotedInElection.length;i++){
            print(voter.hasVotedInElection[i]);
            if(voter.hasVotedInElection[i]==election.index){
              print('matched');
              setState(() {
                // v.index = candidate.requestedCandidacyIndex[i].toString();
                // print('candidateIndex ${candidate.index}');
                hasVoted = true;
              });
              break;
            }
          }
        }
        findLosers();
      }catch(e){
        print(e);
      }
    });
  }
  findLosers(){
    if(election.endDate.difference(DateTime.now()).isNegative){
      if(candidateList!=null){
        candidateList.sort((b,a) => a.votes.compareTo(b.votes));
        int winnerVotes =candidateList[0].votes;
        for(int i=1;i<candidateList.length;i++){
          if(winnerVotes>candidateList[i].votes){
            setState(() {
              losers.add(candidateList[i]);
            });
            print('yolo'+candidateList[i].votes.toString());
          }
        }
      }
    }
  }
  Future<void>fetchDetails()async{
    await getCandidates();
    await checkIfVoted();
    setState(() {
      detailsFetched = true;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    fetchDetails();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return !detailsFetched?Loading():Scaffold(
      appBar: customAppBar(
          title:'Post : ${election.post}',
          context: context
      ),
      endDrawer: SideDrawer(user: user,context: context),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              hasVoted?Column(
                children: [
                  SizedBox(height: 10,),
                  Text('Your vote has been recorded.',
                    style: TextStyle(
                      fontSize: 17
                    ),
                  ),
                ],
              ):SizedBox(),
              SizedBox(height: 10,),
              SizedBox(
                width: 250,
                height: 50,
                child: FlatButton(
                  color: Colors.black,
                  child:Text(
                    'Election Details',
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ViewElectionDetails(user:user,election: election,)));
                  },
                ),
              ),
              SizedBox(height: 10,),
              ElectionScreenStats(election:election,totalVoters: user.totalVoters,confirmedCandidateList:candidateList,context: context,user: user,),
              SizedBox(height: 25,),
              Text(election.endDate.difference(DateTime.now()).inSeconds>0?'Candidates':losers.isEmpty?'':'Other Candidates',
                style: TextStyle(
                    fontSize: 20
                ),
              ),
              SizedBox(height: 10.0),
              !noCandidates?SizedBox():Text(election.startDate.difference(DateTime.now()).inSeconds>0?'No candidates yet.':'No candidates.'),
              Column(
                children:
                election.endDate.difference(DateTime.now()).inSeconds>0?
                candidateList.map((e) => CandidateWidget(candidate: e,election: election,user: user,hasVoted:hasVoted)).toList():
                losers.map((e) => CandidateWidget(candidate: e,election: election,user: user)).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
