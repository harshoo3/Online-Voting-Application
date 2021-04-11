import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_voting/models/candidate.dart';
import 'package:online_voting/models/electionClass.dart';
import 'package:online_voting/models/user.dart';
import 'package:online_voting/screens/candidateWidget.dart';
import 'package:online_voting/screens/home/sidebar.dart';
import 'package:online_voting/screens/home/viewElectionDetails.dart';
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
  List  <Candidate>candidateList=[],requestCandidateList=[],confirmedCandidateList=[];
  List<dynamic> indicesList =[];
  bool noRequests = false;
  bool detailsFetched = false;
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

  Future<void>getCandidates()async{
    await Firestore.instance
        .collection('Elections')
        .document(user.name)
        .get()
        .then((value) {
          try{
            value.data['${election.index}']['candidates'].keys.forEach((element) {
              indicesList.add(element);
            });
            for(var i = 0;i<indicesList.length;i++){
              // print(value.data[indicesList[i]]['candidates']['questions'][]);
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
              if(candidateList[i].approved){
                confirmedCandidateList.add(candidateList[i]);
              }else if(!candidateList[i].approved && !candidateList[i].denied){
                requestCandidateList.add(candidateList[i]);
              }
            }
            // for
            // value.data['waitingCandidates'][election.numOfWaitingCandidates-1]['candidateName'];
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

  @override
  void initState() {
    // TODO: implement initState
    getCandidates();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return !detailsFetched?Loading():Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Elections'),
      ),
      endDrawer: SideDrawer(user: user,),
      body: Center(
        child: Column(
          children: [
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
            Text('Requests'),
            !noRequests?SizedBox():Text('No candidate requests yet.'),
            Column(
              children:
              requestCandidateList.map((e) => CandidateWidget(candidate: e,election: election,user: user,)).toList(),
            ),
            Text('Confirmed Candidates'),
            Column(
              children:
              confirmedCandidateList.map((e) => CandidateWidget(candidate: e,election: election,user: user)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

