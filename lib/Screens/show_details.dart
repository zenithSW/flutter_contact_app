import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ShowDetails extends StatefulWidget {
  static const String id = "show_details";

  @override
  _ShowDetailsState createState() => _ShowDetailsState();
}

class _ShowDetailsState extends State<ShowDetails> {
  var DName;
  void getValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    prefs.get('name');
    DName =  prefs.get('name');
    print(DName);

  }
  @override
  void initState() {
    // TODO: implement initState
    getValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Info'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Center(child: Text("")),
            ),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Center(child: Text("0424524542")),
          ),
          ],
        ),
      ) ,
    );

  }
}
