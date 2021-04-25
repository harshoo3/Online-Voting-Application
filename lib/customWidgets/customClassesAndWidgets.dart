import 'package:flutter/material.dart';
import 'package:online_voting/models/electionClass.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:intl/intl.dart';
class BigTextField extends StatefulWidget {
  String field;
  List<dynamic> fieldList=[];
  String label;
  int index;
  bool readOnly;
  double height;
  BigTextField({this.field,this.label,this.fieldList,this.height=100,this.index,this.readOnly});

  @override
  _BigTextFieldState createState() => _BigTextFieldState(field: field,label: label,index:index,fieldList:fieldList,height: height,readOnly: readOnly);
}

class _BigTextFieldState extends State<BigTextField>{
  String field;
  String label;
  int index;
  bool readOnly=false;
  double height;
  List<dynamic> fieldList=[];
  _BigTextFieldState({this.field,this.index,this.label,this.fieldList,this.height=100,this.readOnly});

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
      child: !readOnly?TextFormField(
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
      ):TextFormField(
        keyboardType: TextInputType.multiline,
        expands: true,
        maxLines: null,
        readOnly: true,
        initialValue: fieldList[index],
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            suffixIcon: Icon(Icons.edit),
            hintText: label,
            labelText: label,
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
Widget customAppBar({String title,BuildContext context}){
  return AppBar(
    backgroundColor: Colors.black,
    title: Text(title),
    centerTitle: true,
    leading: IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () => Navigator.of(context).pop(),
    ),
  );
}
Widget TextWidget(String text){
  return Text(
    text,
    style: TextStyle(
        backgroundColor: Colors.black,
        color: Colors.white,
        fontSize: 30
    ),
  );
}
Widget ColonText(){
  return Text(
    ':',
    style: TextStyle(
      color: Colors.black,
      fontSize: 30,
    ),
  );
}
Widget ElectionProgress({ElectionClass election,double progress,bool big}){
  return LinearPercentIndicator(
    leading: Padding(
      padding: big? const EdgeInsets.fromLTRB(40,0,0,0):EdgeInsets.only(left: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.date_range_outlined,
            color: big?Colors.black:Colors.white,
            size: big?25:19,
          ),
          Text(
            DateFormat.yMMMMd('en_US').format(election.startDate).toString(),
            style: TextStyle(
              fontSize: big?13:10,
              color: big?Colors.black:Colors.white,
            ),
          ),
        ],
      ),
    ),
    trailing: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.date_range_outlined,
          color: big?Colors.black:Colors.white,
          size: big?25:19,
        ),
        Text(
          DateFormat.yMMMMd('en_US').format(election.endDate).toString(),
          style: TextStyle(
            fontSize: big?13:10,
            color: big?Colors.black:Colors.white,
          ),
        ),
      ],
    ),
    width: big?130:100.0,
    lineHeight: 14.0,
    percent: progress,
    animationDuration: 1000,
    animation: true,
    backgroundColor: Colors.grey,
    progressColor: Colors.red,
  );
}
Widget VotePercentage({double votePercentage,bool big}){
  return CircularPercentIndicator(
    radius: big?150.0:70.0,
    lineWidth: 4.0,
    percent: votePercentage*0.01,
    center: Center(
      child: Text(
        big?votePercentage.toString()+ "% \n Voters have voted":votePercentage.toString()+ "%",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: big?Colors.black:Colors.white,
        ),
      ),
    ),
    progressColor: Colors.green,
  );
}