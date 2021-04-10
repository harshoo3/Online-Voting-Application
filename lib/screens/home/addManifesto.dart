import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_voting/models/user.dart';
import 'package:online_voting/screens/loading.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:online_voting/models/electionClass.dart';
import 'dart:io';
import 'package:online_voting/customWidgets/custom.dart';
import 'package:online_voting/models/candidate.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:online_voting/screens/addImage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
class AddManifesto extends StatefulWidget {
  ElectionClass election;
  User user;
  Candidate candidate;
  AddManifesto({this.election,this.user,this.candidate});
  @override
  _AddManifestoState createState() => _AddManifestoState(election: election,user:user,candidate:candidate);
}

class _AddManifestoState extends State<AddManifesto> {
  ElectionClass election;
  User user;
  final _formkey = GlobalKey<FormState>();
  bool hasRequested = false;
  Candidate candidate;
  String partyName='';
  String partyLogoUrl='';
  bool imageAdded = false;
  bool denied = false;
  bool loading = true;
  String campaignTagline='';
  List<String>questions=['',''];
  firebase_storage.StorageReference ref;
  _AddManifestoState({this.election,this.user,this.candidate});

  Future<void> requestCandidacy()async{
    final CollectionReference elec = Firestore.instance.collection('Elections');
    if(election.isPartyModeAllowed){
      await elec.document(user.orgName).updateData({
        // '${election.index}.candidates.${election.numOfCandidates}.candidateName':user.name,
        // '${election.index}.candidates.${election.numOfCandidates}.approved':false,
        '${election.index}.electionDetails.numOfCandidates':election.numOfCandidates+1,
        '${election.index}.candidates.${election.numOfCandidates}':
        {
          'name':user.name,
          'email':user.email,
          'campaignTagline':campaignTagline,
          'partyName':partyName,
          'approved':false,
          'partyLogoUrl':partyLogoUrl,
          'questions':questions,
          'denied':denied,
        }
      });
    }else {
      await elec.document(user.orgName).updateData({
        // '${election.index}.candidates.${election.numOfCandidates}.candidateName':user.name,
        // '${election.index}.candidates.${election.numOfCandidates}.approved':false,
        '${election.index}.electionDetails.numOfCandidates':election.numOfCandidates+1,
        '${election.index}.candidates.${election.numOfCandidates}':
        {
          'name': user.name,
          'email': user.email,
          'approved':false,
          'denied':denied,
          'questions': questions,
        }
      });
    }
    setState(() {
      election.numOfCandidates=election.numOfCandidates+1;
    });
    final CollectionReference userdata = Firestore.instance.collection('dataset');
    await userdata.document(user.email).updateData({
      'requestedCandidacy': FieldValue.arrayUnion([election.index]),
      'requestedCandidacyIndex': FieldValue.arrayUnion([election.numOfCandidates-1]),
    });
    // candidate.requestedCandidacy.add(election.index);
    // candidate.requestedCandidacyIndex.add(election.numOfCandidates);
    setState(() {
      hasRequested=true;
    });
  }
  // Future<void>getDefaultLogo()async{
  //   await Firestore.instance.collection('Logos').document('Default').get().then((value){
  //     setState(() {
  //       partyLogoUrl = value.data['url'];
  //       loading = false;
  //     });
  //   });
  //
  // }
  @override
  void initState() {
    // TODO: implement initState
    // questions.add(' ');
    // getDefaultLogo();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
            'Account Details'
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              Center(child: SizedBox(height: 25,)),
              !election.isPartyModeAllowed?SizedBox():Column(
                children: [
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      validator: (val) => val.isEmpty? 'Invalid. Please enter the name of your party':null,
                      onChanged: (val){
                        setState(() {
                          this.partyName = val;
                        });
                      },
                      obscureText: false,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          suffixIcon: Icon(Icons.email_outlined),
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
                      SizedBox(
                        child: FloatingActionButton(
                          child: Text('Add your party logo'),
                          onPressed: ()async{
                              await Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddImage(user:user,election:election,candidate:candidate))).then((value){
                                setState(() {
                                  imageAdded = value;
                                });
                              });
                           },
                        ),
                      ),
                      SizedBox(height: 25.0),
                      !imageAdded?SizedBox():StreamBuilder(
                          stream: Firestore.instance.collection('Logos').document(user.email).snapshots(),
                          builder: (context, snapshot) {
                            partyLogoUrl=snapshot.data['url'];
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
                                    partyLogoUrl,
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),

                              // ),

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
                      validator: (val) => val.isEmpty? 'Invalid. Please enter the tagline of your election campaign':null,
                      onChanged: (val){
                        setState(() {
                          campaignTagline= val;
                        });
                      },
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
              // SizedBox(
              //   width: 300,
              //   height: 50,
              //   child: TextFormField(
              //     keyboardType: TextInputType.multiline,
              //     expands: true,
              //     maxLines: null,
              //     validator: (val) => val.isEmpty? 'Invalid. Mandatory Field':null,
              //     onChanged: (val){
              //       setState(() {
              //         questions.add(val);
              //       });
              //     },
              //     decoration: InputDecoration(
              //         contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              //         suffixIcon: Icon(Icons.edit),
              //         labelText: "What would your first 30 Days look like in this Role?",
              //         border:
              //         OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
              //     ),
              //   ),
              // ),
              BigTextField(height:120,label:  "Why do you want this Role?",fieldList: questions,index: 0,),
              SizedBox(height: 25.0),
              BigTextField(height:120,label:  "What would your first 30 Days look like in this Role?",fieldList: questions,index: 1,),
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
                    if(!hasRequested){
                      if(_formkey.currentState.validate()){
                        await requestCandidacy();
                      }
                    }
                    print(questions);
                    print(partyName);
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => AddManifesto(user:user,election: election,candidate:candidate,)));
                  },
                ),
              ),
              hasRequested?Text('You have already requested.'):SizedBox(),
              // GestureDetector(
              //   onTap: () {
              //     //do what you want here
              //   },
              //   child:  CircleAvatar(
              //     radius: 55.0,
              //     backgroundImage: ExactAssetImage('assets/cat.jpg'),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
