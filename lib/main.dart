import 'package:flutter/material.dart';
import 'package:contact_app/Screens/home_screen.dart';
import 'package:contact_app/Screens/multi_select.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      initialRoute: HomePage.id,
      routes: {
        HomePage.id:(context) => HomePage(),
        MultiContactPage.id:(context) => MultiContactPage(),

      },
    );
  }
}


