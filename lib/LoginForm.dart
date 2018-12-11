import 'package:first_app/MyUser.dart';
import 'package:flutter/material.dart';
import 'MyWidgets.dart';
import 'package:http/http.dart' as http;

class LoginForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CustomFormState();
  }
}

class CustomFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final myUser = MyUser();

  final List<TextEditingController> _controller = List<TextEditingController>(2);

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _controller[0].dispose();
    _controller[1].dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();
    return new Card(
        child: Padding(
            padding: EdgeInsets.all(8),
            child: Form(
              key: _formKey,
                child: Column(children: <Widget>[
                  UserNameBox(context, focusNode, _controller[0], myUser),
                  PasswordBox(context, (v) {
                    _attemptLogin();
                  }, focusNode, _controller[1], myUser),
                  LoginButton(context, () {
                    _attemptLogin();
                  })
                ]))));
  }

  void _attemptLogin() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {} else {
      form.save(); //This invokes each onSaved event
      fetchPhotos(http.Client());
      final snackBar = SnackBar(
        content: Text('Snak kurwa BAR ' + myUser.getEncodedUser),
        action: SnackBarAction(
          label: 'CLOSE',
          onPressed: () {
            // Some code to undo the change!
          },
        ),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }
  
  

  Future<http.Response> fetchPhotos(http.Client client) async {
    final Map header = new Map();
    header.putIfAbsent("Authorization", () => myUser.getEncodedUser);
    return client.get("https://resto-worker-api.herokuapp.com/", headers: header);
  }

}
