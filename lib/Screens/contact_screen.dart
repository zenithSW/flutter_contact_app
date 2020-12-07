import 'package:contact_app/Screens/show_details.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ShowContactsPage extends StatefulWidget {
  static const String id = "show_contacts";
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ShowContactsPage> {
  var currentContact;
  Iterable<Contact> _contacts;

  @override
  void initState() {
    getContacts();
    super.initState();
  }

  Future<void> getContacts() async {
    //Make sure we already have permissions for contacts when we get to this
    //page, so we can just retrieve it
    final Iterable<Contact> contacts = await ContactsService.getContacts();
    setState(() {
      _contacts = contacts;

    });
  }
 void  assignName(v) async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
   prefs.setString('name',v );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (Text('Contacts')),
      ),
      body: _contacts != null
      //Build a list view of all contacts, displaying their avatar and
      // display name
          ? ListView.builder(
        itemCount: _contacts?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          Contact contact = _contacts?.elementAt(index);
          assignName(contact.displayName);
          return ListTile(
            contentPadding:
            const EdgeInsets.symmetric(vertical: 2, horizontal: 18),
            leading: (contact.avatar != null && contact.avatar.isNotEmpty)
                ? CircleAvatar(
              backgroundImage: MemoryImage(contact.avatar),
            )
                : CircleAvatar(
              child: Text(contact.initials()),
              backgroundColor: Theme.of(context).accentColor,
            ),
            title: Text(contact.displayName ?? ''),
            //This can be further expanded to showing contacts detail
            // onPressed().
            onTap:(){
              Navigator.pushNamed(context, ShowDetails.id);
            } ,
          );
        },
      )
          : Center(child: const CircularProgressIndicator()),
    );
  }

}