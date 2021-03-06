import 'package:flutter/material.dart';
import 'package:online_voting/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_voting/models/electionClass.dart';
import 'package:online_voting/screens/elections/electionWidget.dart';
import 'package:online_voting/screens/elections/organisations/createElection.dart';
import 'package:online_voting/screens/loading.dart';
import 'package:online_voting/customWidgets/customClassesAndWidgets.dart';
import 'package:online_voting/screens/sidebarAndScreens/sidebar.dart';
// import 'dart:';
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
  ElectionClass election;
  List<String> indicesList =[];


  Future<void> getElectionDetails()async{
    await Firestore.instance.collection('Elections').document(user.orgName).get().then((value) {
          // print(value.data.keys);
      try{
        value.data.keys.forEach((element) {
          indicesList.add(element);
        });

        // indicesList.addAll(value.data['indicesList']);
        // print(indicesList.length);
        for(var i = 0;i <indicesList.length;i++){
          Map<dynamic,dynamic> map=value.data[indicesList[i]]['electionDetails'];
          // print(indicesList[i]);
          setState(() {
            electionList.add(
                ElectionClass(
                  post: map['post'],
                  electionDescription: map['electionDescription'],
                  endDate: map['endDate'].toDate(),
                  setDate: map['setDate'].toDate(),
                  isPartyModeAllowed: map['isPartyModeAllowed'],
                  maxCandidates: map['maxCandidates'],
                  startDate: map['startDate'].toDate(),
                  numOfCandidates: map['numOfCandidates'],
                  numOfApprovedCandidates: map['numOfApprovedCandidates'],
                  votes: map['votes'],
                  index: indicesList[i],
                )
            );
          });
          if(now.difference(electionList[i].endDate)>=Duration(seconds: 0)){
            completedELectionList.add(electionList[i]);
          }else if(electionList[i].startDate.difference(now)>=Duration(seconds: 0)){
            upcomingELectionList.add(electionList[i]);
          }else{
            ongoingELectionList.add(electionList[i]);
          }
        }
      }catch(e){
        print(e);
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
      appBar: customAppBar(
        title:'Elections',
        context: context
      ),
      endDrawer: SideDrawer(user: user,context: context,),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: SizedBox(
                  height: 15,
                ),
              ),
              // FutureBuilder(builder: builder)
              user.userType == 'org'?
              Column(
                children: [
                  SizedBox(
                    width: 250,
                    height: 50,
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
                  ),
                  SizedBox(height: 15,)
                ],
              ):SizedBox(height: 0,),
              Text(
                'Ongoing Elections:',
                style: TextStyle(
                    fontSize: 20
                ),
              ),
              SizedBox(height: 5,),
              ongoingELectionList.length==0?Text('No Ongoing Elections to show.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ):SizedBox(),
              Column(
                children:
                  ongoingELectionList.map((e) => ElectionWidget(election : e,user:user)).toList(),
              ),
              SizedBox(height: 15,),
              Text(
                'Upcoming Elections:',
                style: TextStyle(
                    fontSize: 20
                ),
              ),
              SizedBox(height: 5,),
              upcomingELectionList.length==0?Text('No Upcoming Elections to show.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ):SizedBox(),
              Column(
                children:
                upcomingELectionList.map((e) => ElectionWidget(election : e,user:user)).toList(),
              ),
              SizedBox(height: 15,),
              Text(
                'Completed Elections:',
                style: TextStyle(
                  fontSize: 20
                ),
              ),
              SizedBox(height: 5,),
              completedELectionList.length==0?Text('No Completed Elections yet.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ):SizedBox(),
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
