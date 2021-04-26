import 'package:flutter/material.dart';
import 'package:online_voting/customWidgets/customClassesAndWidgets.dart';
import 'package:online_voting/customWidgets/customMethods.dart';
import 'package:online_voting/models/electionClass.dart';
import 'package:online_voting/models/user.dart';
import 'package:online_voting/screens/elections/candidates/candidateWidget.dart';
import 'package:online_voting/screens/elections/candidates/addManifesto.dart';
import 'package:online_voting/screens/sidebarAndScreens/sidebar.dart';
import 'package:online_voting/screens/elections/viewElectionDetails.dart';
import 'package:online_voting/screens/loading.dart';
import 'package:online_voting/models/candidate.dart';
import 'package:online_voting/screens/elections/electionScreenStats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class ElectionScreenCan extends StatefulWidget {
  User user;
  ElectionClass election;
  ElectionScreenCan({this.election,this.user});
  @override
  _ElectionScreenCanState createState() => _ElectionScreenCanState(election:election,user:user);
}

class _ElectionScreenCanState extends State<ElectionScreenCan> {
  User user;
  ElectionClass election;
  bool hasRequested = false;
  bool checkingDone = false;
  bool detailsFetched = false;
  bool noCandidates = false;
  bool candidateFound = false;
  bool isCandidateWinner = false;
  bool loserFound = false;
  DateTime now = DateTime.now();
  String electionKind;
  List<dynamic> indicesList =[];
  Candidate candidate;
  List  <Candidate>candidateList=[],losers=[],totalCandidateList=[];
  CustomMethods _customMethods = CustomMethods();
  // List<>
  List<dynamic> requestedCandidacy=[],requestedCandidacyIndex=[];
  _ElectionScreenCanState({this.election,this.user});
  Future<void> checkRequestCandidacy()async{
    await Firestore.instance
        .collection('dataset')
        .document(user.email)
        .get()
        .then((value) {
          if(value.data['requestedCandidacy']!=null){
            setState(() {
              requestedCandidacy.addAll(value.data['requestedCandidacy']);
              requestedCandidacyIndex.addAll(value.data['requestedCandidacyIndex']);
            });
            setState(() {
              candidate = Candidate(requestedCandidacy: requestedCandidacy,requestedCandidacyIndex: requestedCandidacyIndex);
            });
            if(candidate.requestedCandidacy.isNotEmpty){
              for(int i=0;i<candidate.requestedCandidacy.length;i++){
                // print(list[i]);
                if(candidate.requestedCandidacy[i]==election.index){
                  print('matched');
                  setState(() {
                    candidate.index = candidate.requestedCandidacyIndex[i].toString();
                    print('candidateIndex ${candidate.index}');
                    hasRequested = true;
                  });
                  break;
                }
              }
            }
          }
    });
    setState(() {
      checkingDone = true;
      print('CheckingDone');
    });
  }
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
          Map<dynamic,dynamic> map =value.data['${election.index}']['candidates'][indicesList[i]];
          if(candidate.index!= indicesList[i]){
            if(map['approved']){
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
                      votes: map['votes'],
                      questions: map['questions'],
                      index: indicesList[i],
                    ),
                  );
                });
              }
            }
          }else{
            if(election.isPartyModeAllowed){
              setState(() {
                candidateFound = true;
                candidate.partyLogoUrl= map['partyLogoUrl'];
                candidate.partyName= map['partyName'];
                candidate.approved= map['approved'];
                candidate.denied= map['denied'];
                candidate.campaignTagline= map['campaignTagline'];
                candidate.name= map['name'];
                candidate.email= map['email'];
                candidate.questions= map['questions'];
                candidate.votes=map['votes'];
              });
            }else{
              setState(() {
                candidateFound = true;
                candidate.approved= map['approved'];
                candidate.denied= map['denied'];
                candidate.name= map['name'];
                candidate.email= map['email'];
                candidate.questions= map['questions'];
                candidate.votes=map['votes'];
              });
            }
          }
        }
      }catch(e){
        print(e);
        setState(() {
          noCandidates = true;
        });
      }
    });
    if(now.difference(election.endDate)>=Duration(seconds: 0)){
      setState(() {
        electionKind = 'completed';
      });
    }else if(election.startDate.difference(now)>=Duration(seconds: 0)){
      setState(() {
        electionKind = 'upcoming';
      });
    }else{
      setState(() {
        electionKind = 'ongoing';
      });
    }
    if(candidateFound){
      setState(() {
        totalCandidateList.addAll(candidateList);
        totalCandidateList.add(candidate);
      });
    }
    findLosers();
    setState(() {
      detailsFetched = true;
    });
  }
  findLosers(){
    if(election.endDate.difference(DateTime.now()).isNegative){
      if(totalCandidateList!=null){
        totalCandidateList.sort((b,a) => a.votes.compareTo(b.votes));
        int winnerVotes =totalCandidateList[0].votes;
        for(int i=1;i<totalCandidateList.length;i++){
          if(winnerVotes>totalCandidateList[i].votes){
            setState(() {
              losers.add(totalCandidateList[i]);
            });
            print('yolo'+totalCandidateList[i].votes.toString());
          }
        }
        if(candidate.votes==winnerVotes){
          setState(() {
            isCandidateWinner = true;
          });
        }
        setState(() {
          loserFound = true;
        });
      }
    }
  }
  Future<void>fetchDetails()async{
    await checkRequestCandidacy();
    await getCandidates();
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchDetails();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return !checkingDone || !detailsFetched?Loading(): Scaffold(
      appBar: customAppBar(
          title:'Post : ${election.post}',
          context: context
      ),
      endDrawer: SideDrawer(user: user,context: context),
      body:SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(height: 20,),
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
            ElectionScreenStats(election:election,totalVoters: user.totalVoters,confirmedCandidateList:totalCandidateList,user: user,context: context,),
            SizedBox(height: 25,),
            hasRequested || electionKind!= 'upcoming'?SizedBox(): SizedBox(
              width: 250,
              height: 50,
              child: FlatButton(
                color: Colors.black,
                child:Text(
                  'Contest this election',
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
                onPressed: ()async{
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddManifesto(user:user,election: election,candidate:candidate,)));
                },
              ),
            ),
            SizedBox(height: 5,),
            election.endDate.difference(DateTime.now()).inSeconds>0?Column(
              children: [
                hasRequested && !candidate.denied && !candidate.approved?Text('You have already requested. Request pending.',
                  style: TextStyle(
                      fontSize: 17
                  ),
                ):SizedBox(),
                hasRequested && candidate.denied ?Text('Your Request has been denied.',
                  style: TextStyle(
                      fontSize: 17
                  ),
                ):SizedBox(),
                hasRequested && candidate.approved ?Text('Your Request has been approved.',
                  style: TextStyle(
                      fontSize: 17
                  ),
                ):SizedBox(),
                SizedBox(height: 11,),
              ],
            ):SizedBox(),
            SizedBox(height: 8,),
            candidateFound && !isCandidateWinner?Text('Your Manifesto',
              style: TextStyle(
                  fontSize: 20
              ),
            ):SizedBox(),
            SizedBox(height: 8,),
            candidateFound && !isCandidateWinner?CandidateWidget(candidate:candidate,user: user,election: election):SizedBox(),
            Text(election.startDate.difference(DateTime.now()).inSeconds>0 ?'Confirmed Candidates':!candidate.approved?'Candidates':'Other Candidates',
              style: TextStyle(
                  fontSize: 20
              ),
            ),
            SizedBox(height: 8,),
            candidateList.length==0? Text(election.startDate.difference(DateTime.now()).inSeconds>0?'No confirmed candidates yet.':!candidate.approved?'No candidates.':'No other Candidates'):SizedBox(),
            Column(
              children:
              candidateList.map((e) => CandidateWidget(candidate: e,election: election,user: user)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
