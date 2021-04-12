import 'package:flutter/material.dart';
import 'package:online_voting/customWidgets/customMethods.dart';
import 'package:online_voting/models/electionClass.dart';
import 'package:online_voting/models/user.dart';
import 'package:online_voting/screens/candidateWidget.dart';
import 'package:online_voting/screens/home/addManifesto.dart';
import 'package:online_voting/screens/home/sidebar.dart';
import 'package:online_voting/screens/home/viewElectionDetails.dart';
import 'package:online_voting/screens/loading.dart';
import 'package:online_voting/models/candidate.dart';
import 'package:online_voting/screens/electionScreenStats.dart';
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
    print(election.index);
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
          if(candidate.index!= indicesList[i]){
            if(value.data['${election.index}']['candidates'][indicesList[i]]['approved']){
              if(election.isPartyModeAllowed){
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
                      questions: value.data['${election.index}']['candidates'][indicesList[i]]['questions'],
                      index: indicesList[i],
                    ),
                  );
                });
              }else{
                setState(() {
                  candidateList.add(
                    Candidate(
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
          }else{
            if(election.isPartyModeAllowed){
              setState(() {
                candidateFound = true;
                candidate.partyLogoUrl= value.data['${election.index}']['candidates'][indicesList[i]]['partyLogoUrl'];
                candidate.partyName= value.data['${election.index}']['candidates'][indicesList[i]]['partyName'];
                candidate.approved= value.data['${election.index}']['candidates'][indicesList[i]]['approved'];
                candidate.denied= value.data['${election.index}']['candidates'][indicesList[i]]['denied'];
                candidate.campaignTagline= value.data['${election.index}']['candidates'][indicesList[i]]['campaignTagline'];
                candidate.name= value.data['${election.index}']['candidates'][indicesList[i]]['name'];
                candidate.email= value.data['${election.index}']['candidates'][indicesList[i]]['email'];
                candidate.questions= value.data['${election.index}']['candidates'][indicesList[i]]['questions'];
              });
            }else{
              setState(() {
                candidateFound = true;
                candidate.approved= value.data['${election.index}']['candidates'][indicesList[i]]['approved'];
                candidate.denied= value.data['${election.index}']['candidates'][indicesList[i]]['denied'];
                candidate.name= value.data['${election.index}']['candidates'][indicesList[i]]['name'];
                candidate.email= value.data['${election.index}']['candidates'][indicesList[i]]['email'];
                candidate.questions= value.data['${election.index}']['candidates'][indicesList[i]]['questions'];
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
    if(now.difference(election.startDate)>=Duration(seconds: 0)){
      if(election.endDate.difference(now)>=Duration(seconds: 0)){
        setState(() {
          electionKind = 'ongoing';
        });
      }
    }
    if(now.difference(election.endDate)>=Duration(seconds: 0)){
      setState(() {
        electionKind = 'completed';
      });
    }
    if(election.startDate.difference(now)>=Duration(seconds: 0)){
      setState(() {
        electionKind = 'upcoming';
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
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Online Voting'),
      ),
      endDrawer: SideDrawer(user: user,),
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
            candidateList.length==0? Text('No confirmed candidates.'):SizedBox(),
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
