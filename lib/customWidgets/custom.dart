import 'package:flutter/material.dart';

class BigTextField extends StatefulWidget {
  String field;
  List<String> fieldList=[];
  String label;
  int index;
  double height;
  BigTextField({this.field,this.label,this.fieldList,this.height=100,this.index});

  @override
  _BigTextFieldState createState() => _BigTextFieldState(field: field,label: label,index:index,fieldList:fieldList,height: height);
}

class _BigTextFieldState extends State<BigTextField>{
  String field;
  String label;
  int index;
  double height;
  List<String> fieldList=[];
  _BigTextFieldState({this.field,this.index,this.label,this.fieldList,this.height=100});

  @override
  void initState() {
    // TODO: implement initState
    // fieldList;
    // if(field==null){
    //   listGiven = true;
    // }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: height,
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        expands: true,
        maxLines: null,
        validator: (val) => val.isEmpty? 'Invalid. Mandatory Field':null,
        onChanged: (val){
            if(field==null){
              setState(() {
                fieldList[index]=val;
              });
            }else{
              setState(() {
                field=val;
              });
            }
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          suffixIcon: Icon(Icons.edit),
          hintText: label,
          // labelText: label,
          hintMaxLines: 3,
          alignLabelWithHint: true,
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
        ),
      ),
    );
  }
}
class SmallTextField extends StatefulWidget {
  String field;
  String label;
  IconData iconData;
  SmallTextField({this.field,this.label,this.iconData});
  @override
  _SmallTextFieldState createState() => _SmallTextFieldState(field: field,label:label,iconData:iconData);
}

class _SmallTextFieldState extends State<SmallTextField> {
  String field;
  String label;
  IconData iconData;
  _SmallTextFieldState({this.field,this.label,this.iconData});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: TextFormField(
        validator: (val) => val.isEmpty? 'Invalid. Mandatory field':null,
        onChanged: (val){
          setState(() {
            this.field=val;
          });
        },
        obscureText: false,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            suffixIcon: Icon(iconData),
            labelText: label,
            labelStyle: TextStyle(

            ),
            alignLabelWithHint: true,
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
        ),
      ),
    );
  }
}

