import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'contact_screen.dart';
import 'contacts_page.dart';
import 'package:permission_handler/permission_handler.dart';
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
          title: const Text('Home Screen'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 200,left: 20,right: 20),
              child: InkWell(
                onTap: ()async {
                  final PermissionStatus permissionStatus = await _getPermission();
                  if (permissionStatus == PermissionStatus.granted) {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => ShowContactsPage()));
                  } else {
                    //If permissions have been denied show standard cupertino alert dialog
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => CupertinoAlertDialog(
                          title: Text('Permissions error'),
                          content: Text('Please enable contacts access '
                              'permission in system settings'),
                          actions: <Widget>[
                            CupertinoDialogAction(
                              child: Text('OK'),
                              onPressed: () => Navigator.of(context).pop(),
                            )
                          ],
                        ));
                  }
                },
                child: Center(
                  child: Icon(
                    Icons.verified_user,
                    color: Colors.lightBlue,
                    size: 24.0,
                    semanticLabel: 'Text to announce in accessibility modes',
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
      await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ??
          PermissionStatus.undetermined;
    } else {
      return permission;
    }
  }
}
