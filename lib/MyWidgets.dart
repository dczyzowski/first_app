import 'package:flutter/material.dart';
import 'MyUser.dart';

class PasswordBox extends StatelessWidget {
  final FocusNode mFocusNode;
  final Function onClick;
  final TextEditingController controller;
  final MyUserProfile myUser;

  const PasswordBox({this.onClick, this.mFocusNode,
      this.controller, this.myUser}) : super();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        textInputAction: TextInputAction.next,
        focusNode: mFocusNode,
        autofocus: true,
        controller: controller,
        obscureText: true,
        onSaved: (val) => myUser.password = val,
        decoration: InputDecoration(
          icon: Icon(Icons.lock),
          hintText: 'Enter your password',
          labelText: 'Password',
        ),
        validator: (String value) {
          return value.length < 4 ? 'Password is too short' : null;
        },
        onFieldSubmitted: (v) {onClick();});
  }
}

class UserNameBox extends StatelessWidget {
  final BuildContext context;
  final FocusNode mFocusNode;
  final TextEditingController controller;
  final MyUserProfile myUser;

  const UserNameBox(
      this.context, this.mFocusNode, this.controller, this.myUser);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        textInputAction: TextInputAction.next,
        autofocus: true,
        controller: controller,
        onSaved: (val) => myUser.username = val,
        decoration: InputDecoration(
          icon: Icon(Icons.account_box),
          hintText: 'Enter your username',
          labelText: 'Username',
        ),
        validator: (String value) {
          return value.length < 4 ? 'Username is too short' : null;
        },
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(mFocusNode);
        });
  }

  FocusNode getFocusNode() {
    return mFocusNode;
  }
}

class LoginButton extends StatelessWidget {
  final Function onClick;
  LoginButton({this.onClick}) : super();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: SizedBox(
          width: double.infinity,
          child: FlatButton(
            child: new Text("LOGIN"),
            onPressed: () {
              onClick();
            },
            padding: const EdgeInsets.all(8),
          )));
  }
}
