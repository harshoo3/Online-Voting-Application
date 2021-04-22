import 'package:flutter/material.dart';
import 'package:online_voting/customWidgets/customClassesAndWidgets.dart';
import 'package:online_voting/customWidgets/customMethods.dart';
import 'package:online_voting/models/electionClass.dart';
import 'package:online_voting/models/user.dart';
import 'file:///C:/Users/harsh/AndroidStudioProjects/online_voting/lib/screens/elections/candidates/candidateWidget.dart';
import 'file:///C:/Users/harsh/AndroidStudioProjects/online_voting/lib/screens/elections/candidates/addManifesto.dart';
import 'file:///C:/Users/harsh/AndroidStudioProjects/online_voting/lib/screens/sidebarAndScreens/sidebar.dart';
import 'file:///C:/Users/harsh/AndroidStudioProjects/online_voting/lib/screens/elections/viewElectionDetails.dart';
import 'package:online_voting/screens/loading.dart';
import 'package:online_voting/models/candidate.dart';
import 'file:///C:/Users/harsh/AndroidStudioProjects/online_voting/lib/screens/elections/electionScreenStats.dart';
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
  DateTime now = DateTime.now();
  String electionKind;
  List<dynamic> indicesList =[];
  Candidate candidate;
  List  <Candidate>candidateList=[];
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
    setState(() {
      detailsFetched = true;
    });
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
          title:'Your election',
          context: context
      ),
      endDrawer: SideDrawer(user: user,context: context),
      body:SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            hasRequested && !candidate.denied && !candidate.approved?Text('You have already requested. Request pending.'):SizedBox(),
            hasRequested && candidate.denied ?Text('Your Request has been denied.'):SizedBox(),
            hasRequested && candidate.approved ?Text('Your Request has been approved.'):SizedBox(),
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
            ElectionScreenStats(election:election),
            hasRequested || electionKind!= 'upcoming'?SizedBox(): SizedBox(
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
                  // if(!hasRequested){
                  //   await requestCandidacy();
                  // }
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddManifesto(user:user,election: election,candidate:candidate,)));
                },
              ),
            ),
            SizedBox(height: 25,),
            candidateFound?Text('Your Manifesto'):SizedBox(),
            candidateFound?CandidateWidget(candidate:candidate,user: user,election: election,):SizedBox(),
            Text('Confirmed Candidates'),
            candidateList.length==0? Text('No confirmed candidates yet.'):SizedBox(),
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