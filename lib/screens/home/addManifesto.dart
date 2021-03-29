import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transparent_image/transparent_image.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:online_voting/screens/addImage.dart';
class AddManifesto extends StatefulWidget {
  @override
  _AddManifestoState createState() => _AddManifestoState();
}

class _AddManifestoState extends State<AddManifesto> {
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
      body: Column(
        children: [
          Center(
            child: SizedBox(
              width: 300,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Enter your Party name',
                  labelStyle: TextStyle(
                    color: Colors.black,
                  )
                ),
              ),
            ),
          ),
          SizedBox(
            child: FloatingActionButton(
              child: Text('Add your party logo'),
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddImage()));
              },
            ),
          ),
          StreamBuilder(
            stream: Firestore.instance.collection('imageURLs').snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? Center(
                child: CircularProgressIndicator(),
              )
                  : Container(
                padding: EdgeInsets.all(4),
                child: GridView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data.documents.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.all(3),
                        child: FadeInImage.memoryNetwork(
                            fit: BoxFit.cover,
                            placeholder: kTransparentImage,
                            image: snapshot.data.documents[index].data['url']),
                      );
                    }),
              );
            },
          ),
        ],
      ),
    );
  }
}
