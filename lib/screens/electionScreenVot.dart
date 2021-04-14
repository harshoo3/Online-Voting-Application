import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_voting/models/candidate.dart';
import 'package:online_voting/models/electionClass.dart';
import 'package:online_voting/models/user.dart';
import 'package:online_voting/models/voter.dart';
import 'package:online_voting/screens/candidateWidget.dart';
import 'package:online_voting/screens/home/sidebar.dart';
import 'package:online_voting/screens/home/viewElectionDetails.dart';
import 'package:online_voting/screens/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_voting/screens/electionScreenStats.dart';

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
  List  <Candidate>candidateList=[];
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
          if(election.isPartyModeAllowed && value.data['${election.index}']['candidates'][indicesList[i]]['approved']){
            setState(() {
              candidateList.add(
                Candidate(
                  partyLogoUrl: value.data['${election.index}']['candidates'][indicesList[i]]['partyLogoUrl'],
                  partyName: value.data['${election.index}']['candidates'][indicesList[i]]['partyName'],
                  approved: value.data['${election.index}']['candidates'][indicesList[i]]['approved'],
                  denied: value.data['${election.index}']['candidates'][indicesList[i]]['denied'],
                  campaignTagline: value.data['${election.index}']['candidates'][indicesList[i]]['campaignTagline'],
                  name: value.data['${election.index}']['candidates'][indicesList[i]]['name'],
                  email: value.data['${election.index}']['candidates'][indicesList[i]]['email'],
                  votes:value.data['${election.index}']['candidates'][indicesList[i]]['votes'],                  questions: value.data['${election.index}']['candidates'][indicesList[i]]['questions'],
                  index: indicesList[i],
                ),
              );
            });
          }else if(value.data['${election.index}']['candidates'][indicesList[i]]['approved']){
            setState(() {
              candidateList.add(
                Candidate(
                  votes:value.data['${election.index}']['candidates'][indicesList[i]]['votes'],
                  approved: value.data['${election.index}']['candidates'][indicesList[i]]['approved'],
                  denied: value.data['${election.index}']['candidates'][indicesList[i]]['denied'],
                  name: value.data['${election.index}']['candidates'][indicesList[i]]['name'],
                  email: value.data['${election.index}']['candidates'][indicesList[i]]['email'],
                  questions: value.data['${election.index}']['candidates'][indicesList[i]]['questions'],
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
    setState(() {
      detailsFetched = true;
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
      }catch(e){
        print(e);
      }
    });
  }
  Future<void>FetchDetails()async{
    await getCandidates();
    await checkIfVoted();
    setState(() {
      detailsFetched = true;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    getCandidates();
    checkIfVoted();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return !detailsFetched?Loading():Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Elections'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      endDrawer: SideDrawer(user: user,),
      body: Center(
        child: Column(
          children: [
            hasVoted?Text('Your vote has been recorded.'):SizedBox(),
            SizedBox(
              width: 300,
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
            SizedBox(height: 25,),
            ElectionScreenStats(election:election),
            SizedBox(height: 25,),
            Text('Candidates'),
            !noCandidates?SizedBox():Text('No candidates yet.'),
            Column(
              children:
              candidateList.map((e) => CandidateWidget(candidate: e,election: election,user: user,hasVoted:hasVoted)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
