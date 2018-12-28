import 'dart:convert';

class MyUserProfile{
  String _username;
  String _password;
  String _header;
  Base64Codec _base64 = Base64Codec();
  final String username;
  final String name;
  final bool isActive;

  MyUserProfile({this.username, this.name, this.isActive});

  String get getEncodedUser{
    if(_username!=null && _password!=null){
      String base = "$_username:$_password";
      _header = "Basic " + _base64.encode(base.codeUnits);
      return _header;
    }
    else if(_header != null) return _header;
    return null;
  }

  set username(String username){
    _username = username;
  }

  set password(String password){
    _password = password;
  }

  factory MyUserProfile.fromJson(Map<String, dynamic> json) {
    return MyUserProfile(
      username: json['username'] as String,
      name: json['first_name'] as String,
      isActive: json['is_active'] as bool,
    );
  }

  void setHeader(String getEncodedUser) {_header = getEncodedUser;}
}

class WorkingDays {
  final int id;
  final String date;
  final String startTime;
  final String endTime;

  WorkingDays({this.id, this.date, this.endTime, this.startTime});

  factory WorkingDays.fromJson(Map<String, dynamic> json) {
    return WorkingDays(
      id: json['id'] as int,
      date: json['date'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
    );
  }
}