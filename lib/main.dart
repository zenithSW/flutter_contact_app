import 'package:flutter/material.dart';
import 'package:contact_app/Screens/home_screen.dart';
import 'package:contact_app/Screens/contacts_page.dart';
import 'package:contact_app/Screens/contact_screen.dart';
import 'package:contact_app/Screens/show_details.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      initialRoute: HomePage.id,
      routes: {
        HomePage.id:(context) => HomePage(),
        ContactPage.id:(context) => ContactPage(),
        ShowContactsPage.id:(context)=>ShowContactsPage(),
        ShowDetails.id:(context)=> ShowDetails(),

      },
    );
  }
}


