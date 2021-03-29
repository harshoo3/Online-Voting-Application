import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;
import 'package:online_voting/screens/loading.dart';

class AddImage extends StatefulWidget {
  @override
  _AddImageState createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {

  bool uploading = false;
  double val = 0;
  List<File> _image = [];
  final picker = ImagePicker();
  CollectionReference imgRef;
  firebase_storage.StorageReference ref;

  chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image.add(File(pickedFile?.path));
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
        _image.add(File(response.file.path));
      });
    } else {
      print(response.file);
    }
  }
  Future uploadFile() async {
    int i = 1;

    for (var img in _image) {
      setState(() {
        val = i / _image.length;
      });
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${Path.basename(img.path)}');
      await ref.putFile(img).onComplete.then((v)async {
        await ref.getDownloadURL().then((value) {
          imgRef.add({'url': value});
          i++;
        });
      });
    }
  }
  @override
  void initState() {
    super.initState();
    imgRef = Firestore.instance.collection('imageURLs');
  }
  @override
  Widget build(BuildContext context) {
    return uploading ? Loading():Scaffold(
      appBar: AppBar(
        title: Text('Add Party logo'),
        actions: [
          FlatButton(
            onPressed: (){
              // uploadFile();
              setState(() {
                uploading = true;
              });
              uploadFile().whenComplete(() => Navigator.of(context).pop());
            },
            child: Text('upload'))
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: GridView.builder(
                itemCount: _image.length + 1,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (context, index) {
                  return index == 0
                      ? Center(
                    child: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () =>
                        chooseImage()
                    ),
                  )
                      : Container(
                    margin: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: FileImage(_image[index - 1]),
                            fit: BoxFit.cover)),
                  );
                }),
          ),
        ],
      )
    );
  }
}
