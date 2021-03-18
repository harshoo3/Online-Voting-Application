class User {

  final String uid;
  String email;
  String name;
  String password;
  DateTime dateOfBirth;
  String mobileNo;
  String userType;

  User ({this.uid,this.email = '',this.name = '', this.password = '',this.dateOfBirth = null,this.mobileNo = '',this.userType = ''});

  // void setDetails({String email ,String name, String password ,DateTime dateOfBirth}){
  //
  // }
}