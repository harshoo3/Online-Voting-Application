import 'package:flutter/material.dart';
import 'package:online_voting/models/user.dart';
import 'package:online_voting/screens/electionWidget.dart';
import 'package:online_voting/screens/home/addManifesto.dart';
import 'package:online_voting/screens/home/createElection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_voting/models/electionClass.dart';
import 'package:online_voting/screens/home/sidebar.dart';
import 'package:online_voting/screens/loading.dart';
class Elections extends StatefulWidget {

  User user;
  Elections({this.user});

  @override
  _ElectionsState createState() => _ElectionsState(user:user);
}

class _ElectionsState extends State<Elections> {

  User user;
  _ElectionsState({this.user});
  List<ElectionClass> electionList=[],ongoingELectionList =[],upcomingELectionList =[],completedELectionList =[];
  bool detailsFetched = false;
  DateTime now = DateTime.now();
  List<String> indicesList =[];


  Future<void> getElectionDetails()async{
    await Firestore.instance
      .collection('Elections')
        .document(user.orgName)
        .get()
        .then((value) {
          // print(value.data.keys);

          value.data.keys.forEach((element) {
            indicesList.add(element);
          });
          // indicesList.addAll(value.data['indicesList']);
          // print(indicesList.length);
          for(var i = 0;i <indicesList.length;i++){
            // print(indicesList[i]);
            setState(() {
              electionList.add(
                ElectionClass(
                  post: value.data[indicesList[i]]['electionDetails']['post'],
                  electionDescription: value.data[indicesList[i]]['electionDetails']['electionDescription'],
                  endDate: value.data[indicesList[i]]['electionDetails']['endDate'].toDate(),
                  setDate: value.data[indicesList[i]]['electionDetails']['setDate'].toDate(),
                  isPartyModeAllowed: value.data[indicesList[i]]['electionDetails']['isPartyModeAllowed'],
                  maxCandidates: value.data[indicesList[i]]['electionDetails']['maxCandidates'],
                  startDate: value.data[indicesList[i]]['electionDetails']['startDate'].toDate(),
                  numOfCandidates: value.data[indicesList[i]]['electionDetails']['numOfCandidates'],
                  numOfApprovedCandidates: value.data[indicesList[i]]['electionDetails']['numOfApprovedCandidates'],
                  votes: value.data[indicesList[i]]['electionDetails']['votes'],
                  index: indicesList[i],
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
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Elections'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      endDrawer: SideDrawer(user: user,),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: SizedBox(
                  height: 25,
                ),
              ),
              // FutureBuilder(builder: builder)
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
              SizedBox(
                height: 25,
              ),
              Text('Ongoing Elections:'),
              Column(
                children:
                  ongoingELectionList.map((e) => ElectionWidget(election : e,user:user)).toList(),
              ),
              Text('Upcoming Elections :'),
              Column(
                children:
                upcomingELectionList.map((e) => ElectionWidget(election : e,user:user)).toList(),
              ),
              Text('Completed Elections:'),
              Column(
                children:
                completedELectionList.map((e) => ElectionWidget(election : e,user:user)).toList() ,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
