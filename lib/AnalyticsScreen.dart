import 'package:first_app/MyUser.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class AnalyticsScreen extends StatefulWidget {
  final MyUserProfile myUser;

  AnalyticsScreen({Key key, @required this.myUser}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CustomFormState();
  }
}

class CustomFormState extends State<AnalyticsScreen> {
  bool isLoading = false;
  List<WorkingDays> list = new List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Hello " + widget.myUser.name + "!"),
        ),
        body: _buildBody(context));
  }

  Widget _buildBody(BuildContext context) {
    return Builder(
        // Create an inner BuildContext so that the onPressed methods
        // can refer to the Scaffold with Scaffold.of().
        builder: (BuildContext buildContext) {
      return Center(
        child: futureWidgetOnButtonPress(),
        );
    });
  }

  Future<List<WorkingDays>> checkUserProfile() async {
    final response = await http
        .get("https://resto-worker-api.herokuapp.com/work_time/", headers: {
      HttpHeaders.authorizationHeader: widget.myUser.getEncodedUser
    });
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      final responseJson = (json.decode(response.body) as List)
          .map((data) => new WorkingDays.fromJson(data))
          .toList();
      isLoading = false;
      return responseJson;
    } else
      throw Exception('User not found');
  }

  Widget futureWidgetOnButtonPress() {
    return new FutureBuilder<List<WorkingDays>>(
        builder: (context, AsyncSnapshot<List<WorkingDays>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return new CircularProgressIndicator();
            case ConnectionState.done:
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              if (snapshot.hasData) {
                list = snapshot.data;
                return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                          title: new Text(list[index].date),
                      subtitle: new Text("You work form " +
                          list[index].startTime +
                          " to " +
                          list[index].endTime));

                    });
              }
              else
                return Text('Result: No data!');
          }
        },
        future: checkUserProfile());
  }
}
