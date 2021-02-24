class User {

  final String uid;
  String email;
  String name;
  String password;
  DateTime dateOfBirth;

  User ({this.uid,this.email = '',this.name = '', this.password = '',this.dateOfBirth = null});

  // void setDetails({String email ,String name, String password ,DateTime dateOfBirth}){
  //
  // }
}