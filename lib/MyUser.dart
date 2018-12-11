import 'dart:convert';

class MyUser{
  String _username;
  String _password;
  Base64Codec _base64 = Base64Codec();

  MyUser();

  String get getEncodedUser{
    if(_username!=null && _password!=null){
      String base = "$_username:$_password";
      return "Basic " + _base64.encode(base.codeUnits);
    }
    else return "Error";
  }

  set username(String username){
    _username = username;
  }

  set password(String password){
    _password = password;
  }
}

class MyUserProfile extends MyUser{
  final String username;
  final String name;
  final bool isActive;
  final workingDays = new List();

  MyUserProfile({this.username, this.name, this.isActive});

  factory MyUserProfile.fromJson(Map<String, dynamic> json) {
    return MyUserProfile(
      username: json['username'] as String,
      name: json['name'] as String,
      isActive: json['thumbnailUrl'] as bool,
    );
  }

}