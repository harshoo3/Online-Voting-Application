import 'package:flutter/material.dart';
import 'package:online_voting/models/user.dart';
import 'package:online_voting/screens/electionWidget.dart';
import 'package:online_voting/screens/home/addManifesto.dart';
import 'package:online_voting/screens/home/createElection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_voting/models/electionClass.dart';
class Elections extends StatefulWidget {

  User user;
  Elections({this.user});

  @override
  _ElectionsState createState() => _ElectionsState(user:user);
}

class _ElectionsState extends State<Elections> {

  User user;
  List<ElectionClass> electionList=[],ongoingELectionList =[],upcomingELectionList =[],completedELectionList =[];
  bool detailsFetched = false;
  DateTime now = DateTime.now();
  List<String> indicesList =[];
  _ElectionsState({this.user});


  getElectionDetails(){
    Firestore.instance
      .collection('Elections')
        .document(user.orgName)
        .get()
        .then((value) {
          print(value.data.keys);

          value.data.keys.forEach((element) {
            indicesList.add(element) ;
          });
          print(indicesList.length);
          for(var i = 0;i <indicesList.length;i++){
            print(indicesList[i]);
            setState(() {
              electionList.add(
                ElectionClass(
                  post: value.data[indicesList[i]]['post'],
                  electionDescription: value.data[indicesList[i]]['electionDescription'],
                  endDate: value.data[indicesList[i]]['endDate'].toDate(),
                  setDate: value.data[indicesList[i]]['setDate'].toDate(),
                  isPartyModeAllowed: value.data[indicesList[i]]['isPartyModeAllowed'],
                  maxCandidates: value.data[indicesList[i]]['maxCandidates'],
                  startDate: value.data[indicesList[i]]['startDate'].toDate(),
                )
              );
            });
            if(now.difference(electionList[i].startDate)>=Duration(seconds: 0)){
              if(electionList[i].endDate.difference(now)>=Duration(seconds: 0)){
                ongoingELectionList.add(electionList[i]);
              }
            }
            if(now.difference(electionList[i].endDate)>=Duration(seconds: 0)){
              completedELectionList.add(electionList[i]);
            }
            if(electionList[i].startDate.difference(now)>=Duration(seconds: 0)){
              upcomingELectionList.add(electionList[i]);
            }

          }
          setState(() {
            detailsFetched = true;
          });

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getElectionDetails();
    print(electionList.length);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Elections'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: SizedBox(
                  height: 25,
                ),
              ),
              Text('Ongoing Elections:'),
              detailsFetched?ElectionWidget(election : ongoingELectionList[0]):SizedBox(),
              SizedBox(height: 25,),
              Text('Upcoming Elections :'),
              SizedBox(

              ),
              user.userType == 'org'?
              SizedBox(
                width: 300,
                child: RaisedButton(
                  color:Colors.black,
                  child: Text(
                    'Create Election',
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CreateElection(user:user)));
                  },
                ),
              ):SizedBox(height: 0,),
              // SizedBox(
              //   height: 25,
              // ),
              user.userType == 'can'?
              SizedBox(
                width: 300,
                child: FlatButton(
                  color: Colors.black,
                  child:Text(
                    'Add Manifesto',
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddManifesto()));
                  },
                ),
              ):SizedBox(height: 0,),

            ],
          ),
        ),
      ),
    );
  }
}
