class User {

  final String uid;
  String email;
  String name;

  DateTime dateOfBirth;
  String mobileNo;
  String userType;
  String orgName;
  int electionCount;

  User ({this.uid,this.email = '',this.name = '',this.dateOfBirth,this.mobileNo = '',this.userType = '',this.electionCount,this.orgName});

  // void setDetails({String email ,String name, String password ,DateTime dateOfBirth}){
  //
  // }
}