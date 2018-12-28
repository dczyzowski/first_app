import 'package:first_app/MyUser.dart';
import 'package:flutter/material.dart';
import 'MyWidgets.dart';
import 'AnalyticsScreen.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class LoginForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CustomFormState();
  }
}

class CustomFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final myUser = MyUserProfile();
  bool isLogging = false;
  
  final _controller = List<TextEditingController>(2);

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _controller[0].dispose();
    _controller[1].dispose();
    super.dispose();
  }

  Widget futureWidgetOnButtonPress() {
    if (isLogging) {
      return new FutureBuilder<MyUserProfile>(
        builder: (context, AsyncSnapshot<MyUserProfile> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return new CircularProgressIndicator();
            case ConnectionState.done:
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              if(snapshot.hasData) return Text('Result: ${snapshot.data.name}');
              else return Text('Result: No data!');
          }
        },
        future: checkUserProfile().then((user) {
          if (user != null) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => AnalyticsScreen(myUser: user)),
            );
          }
        }));
    }
    return Text("");
  }

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();
    return Column(children: <Widget>[
      Card(
          child: Padding(
              padding: EdgeInsets.all(8),
              child: Form(
                  key: _formKey,
                  child: Column(children: <Widget>[
                    UserNameBox(context, focusNode, _controller[0], myUser),
                    PasswordBox(onClick: _attemptLogin,
                        mFocusNode: focusNode,
                        controller: _controller[1],
                        myUser: myUser),
                    LoginButton(
                        onClick: _attemptLogin)
                  ])))),
      Visibility(
        visible: isLogging,
        child: futureWidgetOnButtonPress(),
      )
    ]);
  }

  void _attemptLogin() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
    } else {
      form.save(); //This invokes each onSaved event
      checkUserProfile();
      setState(() {
        isLogging = true;
      });
    }
  }

  Future<MyUserProfile> checkUserProfile() async {
    final response = await http.get(
        "https://resto-worker-api.herokuapp.com/user_info/",
        headers: {HttpHeaders.authorizationHeader:myUser.getEncodedUser});
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      final responseJson = json.decode(response.body);
      MyUserProfile userEncoded = MyUserProfile.fromJson(responseJson);
      userEncoded.setHeader(myUser.getEncodedUser);
      return userEncoded;
    } else
      throw Exception('User not found');
  }
}
