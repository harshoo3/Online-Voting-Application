import 'package:flutter/material.dart';
import 'package:online_voting/models/electionClass.dart';
import 'package:online_voting/models/user.dart';
import 'package:online_voting/screens/home/addManifesto.dart';
import 'package:online_voting/screens/loading.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:intl/intl.dart';
import 'package:online_voting/models/candidate.dart';
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
  Candidate candidate;
  // List<>
  List<dynamic> requestedCandidacy=[];
  List<dynamic> requestedCandidacyIndex=[];
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
                  // print('matched');
                  setState(() {
                    hasRequested = true;
                  });
                }
                break;
              }
            }
          }
          // print(value.data['requestedCandidacy'].length)
    });
    // print(list);
    // print('list gotten:');
    // print(election.index);

    setState(() {
      checkingDone = true;
    });
  }


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
  @override
  void initState() {
    // TODO: implement initState
    checkRequestCandidacy();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return !checkingDone?Loading(): Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Online Voting'),
      ),
      body:Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Post:${election.post}',
                style: TextStyle(
                    fontSize: 20
                ),
              ),
              CircularPercentIndicator(
                radius: 70.0,
                lineWidth: 4.0,
                percent: 0.30,
                center: new Text("30%"),
                progressColor: Colors.orange,
              ),
            ],
          ),
          LinearPercentIndicator(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.date_range_outlined,
                  color: Colors.black,
                  size: 19,
                ),
                Text(
                  DateFormat.yMMMMd('en_US').format(election.startDate).toString(),
                  style: TextStyle(
                      fontSize: 10
                  ),
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.date_range_outlined,
                  color: Colors.black,
                  size: 19,
                ),
                Text(
                  DateFormat.yMMMMd('en_US').format(election.endDate).toString(),
                  style: TextStyle(
                      fontSize: 10
                  ),
                ),
              ],
            ),
            width: 100.0,
            lineHeight: 14.0,
            percent: calculatePercent(election),
            animationDuration: 1000,
            animation: true,
            backgroundColor: Colors.grey,
            progressColor: Colors.pink,
          ),
          hasRequested?SizedBox(): SizedBox(
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
          hasRequested?Text('You have already requested.'):SizedBox(),
        ],
      ),

    );
  }
}
