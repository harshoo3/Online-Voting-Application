import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:online_voting/models/candidate.dart';
import 'package:online_voting/models/electionClass.dart';
import 'package:online_voting/models/user.dart';
import 'package:path/path.dart' as Path;
import 'package:online_voting/screens/loading.dart';

class AddImage extends StatefulWidget {
  User user;
  ElectionClass election;
  Candidate candidate;
  AddImage({this.candidate,this.election,this.user});
  @override
  _AddImageState createState() => _AddImageState(user:user,election:election,candidate:candidate);
}

class _AddImageState extends State<AddImage> {

  User user;
  ElectionClass election;
  Candidate candidate;
  _AddImageState({this.candidate,this.election,this.user});
  bool uploading = false;
  // double val = 0;
  // bool imageChosen = false;
  // List<File> _image = [];
  File image;
  final picker = ImagePicker();
  CollectionReference imgRef;
  firebase_storage.StorageReference ref;

  chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      // _image.add(File(pickedFile?.path));
      image = File(pickedFile?.path);
    });
    if (pickedFile.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        // _image.add(File(response.file.path));
        image = File(response.file.path);
      });
    } else {
      print(response.file);
    }
  }
  Future uploadFile() async {

      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${Path.basename(image.path)}');
      await ref.putFile(image).onComplete.then((v)async {
        await ref.getDownloadURL().then((value)async {
          await imgRef.document(user.email).setData({
            'url':value,
          },
            merge: true,
          );
          // imgRef.
        });
      });
  }
  @override
  void initState() {
    super.initState();
    imgRef = Firestore.instance.collection('Logos');
  }
  @override
  Widget build(BuildContext context) {
    return uploading ? Loading():Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        foregroundColor: Colors.white,
        title: Text('Add Party logo'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        actions: [
          FlatButton(
            onPressed: (){
              // uploadFile();
              setState(() {
                uploading = true;
              });
              uploadFile().whenComplete(() => Navigator.of(context).pop(true));
            },
            child: Text('upload',style: TextStyle(color: Colors.white),))
        ],
      ),
      body: Stack(
        children: [
          // Center(
            // child: GridView.builder(
            //     itemCount:,
            //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //         crossAxisCount: 3),
            //     itemBuilder: (context, index) {
            //       return index == 0
            //           ? Center(
            //         child: IconButton(
            //             icon: Icon(Icons.add),
            //             onPressed: () =>
            //             chooseImage()
            //         ),
            //       )
            //           : Container(
            //         margin: EdgeInsets.all(3),
            //         decoration: BoxDecoration(
            //             image: DecorationImage(
            //                 image: FileImage(image),
            //                 fit: BoxFit.cover)),
            //       );
            //     }),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () =>
            chooseImage()
          ),
          image==null?SizedBox():Container(
                margin: EdgeInsets.all(3),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: FileImage(image),
                    )
                ),
          ),
        ],
      )
    );
  }
}
