import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_voting/customWidgets/customMethods.dart';
import 'package:online_voting/models/candidate.dart';
import 'package:online_voting/models/electionClass.dart';
import 'package:online_voting/models/user.dart';
import 'package:online_voting/screens/elections/candidates/candidateWidget.dart';
import 'package:online_voting/screens/sidebarAndScreens/sidebar.dart';
import 'package:online_voting/screens/elections/viewElectionDetails.dart';
import 'package:online_voting/screens/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_voting/screens/elections/electionScreenStats.dart';
import 'package:online_voting/customWidgets/customClassesAndWidgets.dart';

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
  List  <Candidate>candidateList=[],losers=[],requestCandidateList=[],confirmedCandidateList=[],rejectedCandidatesList=[];
  List<dynamic> indicesList =[];
  bool noRequests = false;
  bool detailsFetched = false;
  bool loserFound = false;
  _ElectionScreenOrgState({this.election,this.user});

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
              if(election.isPartyModeAllowed){
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
                      votes: map['votes'],
                      questions: map['questions'],
                      index: indicesList[i],
                    ),
                  );
                });
              }else{
                setState(() {
                  candidateList.add(
                    Candidate(
                      approved: map['approved'],
                      denied: map['denied'],
                      name: map['name'],
                      email: map['email'],
                      questions: map['questions'],
                      index: indicesList[i],
                      votes:map['votes'],
                    ),
                  );
                });
              }
              if(candidateList[i].approved){
                confirmedCandidateList.add(candidateList[i]);
              }else if(!candidateList[i].approved && !candidateList[i].denied){
                requestCandidateList.add(candidateList[i]);
              }else if(candidateList[i].denied){
                rejectedCandidatesList.add(candidateList[i]);
              }
            }
            findLosers();
          }catch(e){
            print(e);
            setState(() {
              noRequests = true;
            });
          }
        });
      setState(() {
        detailsFetched = true;
      });
  }
  findLosers(){
    if(election.endDate.difference(DateTime.now()).isNegative){
      if(confirmedCandidateList!=null){
        confirmedCandidateList.sort((b,a) => a.votes.compareTo(b.votes));
        int winnerVotes =confirmedCandidateList[0].votes;
        for(int i=1;i<confirmedCandidateList.length;i++){
          if(winnerVotes>confirmedCandidateList[i].votes){
            setState(() {
              losers.add(confirmedCandidateList[i]);
            });
            print('yolo'+confirmedCandidateList[i].votes.toString());
          }
        }
        setState(() {
          loserFound = true;
        });
      }
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    getCandidates();
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: SizedBox(height: 15,)),
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
            SizedBox(height: 15,),
            ElectionScreenStats(election:election,totalVoters: user.totalVoters,confirmedCandidateList:confirmedCandidateList,context: context,user: user,),
            SizedBox(height: 15,),
            election.startDate.difference(DateTime.now()).inSeconds>0?Column(
              children: [
                Text('Requests:',
                  style: TextStyle(
                    fontSize: 20
                  ),
                ),
                SizedBox(height: 7,),
                noRequests || requestCandidateList.length==0?Text('No candidate requests pending.'):SizedBox(),
                Column(
                  children:
                  requestCandidateList.map((e) => CandidateWidget(candidate: e,election: election,user: user,)).toList(),
                ),
              ],
            ):SizedBox(),
            SizedBox(height: 25,),
            Text(election.startDate.difference(DateTime.now()).inSeconds>0?'Confirmed Candidates:':election.endDate.difference(DateTime.now()).inSeconds>0?'Candidates:':'Other Candidates:',
              style: TextStyle(
                  fontSize: 20
              ),
            ),
            SizedBox(height: 7,),
            confirmedCandidateList.length==0?Text(election.startDate.difference(DateTime.now()).inSeconds>0?'No confirmed candidates yet.':'No candidates.'):SizedBox(),
            Column(
              children:
              election.endDate.difference(DateTime.now()).inSeconds>0?
              confirmedCandidateList.map((e) => CandidateWidget(candidate: e,election: election,user: user)).toList():
              losers.map((e) => CandidateWidget(candidate: e,election: election,user: user)).toList(),
            ),
            Text('Rejected Candidates:',
              style: TextStyle(
                  fontSize: 20
              ),
            ),
            SizedBox(height: 7,),
            rejectedCandidatesList.length==0?Text(election.startDate.difference(DateTime.now()).inSeconds>0?'No rejected candidates yet.':'No rejected candidates.'):SizedBox(),
            Column(
              children:
              rejectedCandidatesList.map((e) => CandidateWidget(candidate: e,election: election,user: user)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

