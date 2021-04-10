import 'package:flutter/material.dart';
import 'package:online_voting/models/candidate.dart';
import 'package:online_voting/models/electionClass.dart';
import 'package:online_voting/models/user.dart';
import 'package:online_voting/screens/home/sidebar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_voting/customWidgets/custom.dart';

class CandidateManifesto extends StatefulWidget {
  Candidate candidate;
  User user;
  ElectionClass election;
  CandidateManifesto({this.candidate,this.user,this.election});
  @override
  _CandidateManifestoState createState() => _CandidateManifestoState(candidate: candidate,user: user,election:election);
}

class _CandidateManifestoState extends State<CandidateManifesto> {
  Candidate candidate;
  User user;
  ElectionClass election;

  Future<void>acceptRequest()async{
    await Firestore.instance.collection('Elections').document(user.orgName).
    updateData({
      '${election.index}.candidates.${candidate.index}.approved':true,
    });
  }
  Future<void>denyRequest()async{
    await Firestore.instance.collection('Elections').document(user.orgName).
    updateData({
      '${election.index}.candidates.${candidate.index}.denied':true,
    });
  }
  _CandidateManifestoState({this.candidate,this.user,this.election});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: SideDrawer(user: user,),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('VoteHub'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children : [
            !election.isPartyModeAllowed?SizedBox():Column(
              children: [
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    readOnly: true,
                    initialValue: candidate.partyName,
                    obscureText: false,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        suffixIcon: Icon(Icons.sort_by_alpha),
                        labelText: "Name of your Party...",
                        border:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                    ),
                  ),
                ),
                // SmallTextField(field:partyName,iconData:Icons.account_box, label: "Name of your Party...",),
                SizedBox(height: 25,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    StreamBuilder(
                        stream: Firestore.instance.collection('Logos').document(user.email).snapshots(),
                        builder: (context, snapshot) {
                          return !snapshot.hasData
                              ? Center(
                            child: CircularProgressIndicator(),
                          )
                              : Container(
                            constraints: BoxConstraints(maxHeight: 80, maxWidth: 100),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(
                                  candidate.partyLogoUrl,
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                          );
                        }
                    ),
                  ],
                ),
                SizedBox(
                  width: 300,
                  height: 90,
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    expands: true,
                    maxLines: null,
                    readOnly: true,
                    initialValue: candidate.campaignTagline,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        suffixIcon: Icon(Icons.edit),
                        labelText: "Your Campaign Tagline...",
                        border:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 25.0),
            BigTextField(height:120,label:  "Why do you want this Role?",fieldList: candidate.questions,index: 0,readOnly:true),
            SizedBox(height: 25.0),
            BigTextField(height:120,label:  "What would your first 30 Days look like in this Role?",fieldList: candidate.questions,index: 1,readOnly: true,),
            SizedBox(height: 25.0),
            user.userType == 'org' && candidate.approved == false && candidate.denied== false?
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                  height: 50,
                  minWidth: 50,
                  color: Colors.black,
                  onPressed: (){
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Request Accept Alert"),
                          content: Text("Would you like to continue to accept the Candidate Request?"),
                          actions: [
                            FlatButton(
                              child: Text("Yes,accept"),
                              onPressed:  () async{
                                await acceptRequest();
                                setState(() {
                                  candidate.approved = true;
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                            FlatButton(
                              child: Text("Cancel"),
                              onPressed:  () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                      'Accept',
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                ),
                FlatButton(
                  height: 50,
                  minWidth: 50,
                  color: Colors.black,
                  onPressed: (){
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Request Deny Alert"),
                          content: Text("Would you like to continue to deny the Candidate Request?"),
                          actions: [
                            FlatButton(
                            child: Text("Yes,deny"),
                              onPressed:  () async{
                                await acceptRequest();
                                setState(() {
                                  candidate.denied = true;
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                            FlatButton(
                              child: Text("Cancel"),
                              onPressed:  () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    'Reject',
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
              ],
            ):SizedBox(),
            candidate.approved == true?Text(
              'The candidate has been approved to participate the election.'
            ):SizedBox(),
            candidate.denied == true?Text(
                'The candidate has been approved to participate the election.'
            ):SizedBox(),
          ]
        ),
      ),
    );
  }
}
