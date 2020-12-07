import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'contact_screen.dart';

class ContactPage extends StatelessWidget {
  static const String id = "contact_screen";
  @override
  Widget build(BuildContext context) {
    return  RaisedButton(

      child: Container(child: Text('See Contacts')),
    );
  }


}
