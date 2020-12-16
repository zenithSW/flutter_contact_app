import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:contact_app/Screens/multi_select.dart';
class HomePage extends StatefulWidget {
  static const String id = "home_screen";
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Contacts App'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 200,left: 20,right: 20),
              child: InkWell(
                onTap: (){
                  Navigator.pushNamed(context, MultiContactPage.id);
                },
                child: Center(
                  child: Icon(
                    Icons.account_box_rounded ,
                    color: Colors.black,
                    size: 100.0,
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

}
