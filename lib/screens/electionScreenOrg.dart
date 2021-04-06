import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_voting/models/candidate.dart';
import 'package:online_voting/models/electionClass.dart';
import 'package:online_voting/models/user.dart';
import 'package:online_voting/screens/candidateWidget.dart';
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
  List<Candidate>candidateList=[],requestCandidateList=[],confirmedCandidateList=[];
  List<dynamic> indicesList =[];
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
      value.data.keys.forEach((element) {
        indicesList.add(element);
      });
      for(var i = 0;i<indicesList.length;i++){
        print(value.data[indicesList[i]]['candidates']['questions']);
        // print(value.data[indicesList[i]]['candidates']['questions'][]);
        setState(() {
          candidateList.add(
              Candidate(
                partyLogoUrl: value.data[indicesList[i]]['candidates']['partyLogoUrl'],
                partyName: value.data[indicesList[i]]['candidates']['partyName'],
                approved: value.data[indicesList[i]]['candidates']['approved'],
                denied: value.data[indicesList[i]]['candidates']['denied'],
                campaignTagline: value.data[indicesList[i]]['candidates']['campaignTagline'],
                name: value.data[indicesList[i]]['candidates']['name'],
                email: value.data[indicesList[i]]['candidates']['email'],
                questions: value.data[indicesList[i]]['candidates']['questions'],
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
      body: Column(
        children: [
          // SizedBox(
          //   width: 300,
          //   child: FlatButton(
          //     color: Colors.black,
          //     child:Text(
          //       'Contest this election',
          //       style: TextStyle(
          //           color: Colors.white
          //       ),
          //     ),
          //     onPressed: ()async{
          //       // await ;
          //     },
          //   ),
          // ),
          Text('Requests'),
          Column(
            children:
            requestCandidateList.map((e) => CandidateWidget(candidate: e,)).toList(),
          ),
          Text('Confirmed Candidates'),
          Column(
            children:
            confirmedCandidateList.map((e) => CandidateWidget(candidate: e,)).toList(),
          ),
        ],
      ),
    );
  }
}

