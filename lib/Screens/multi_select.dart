import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class MultiContactPage extends StatefulWidget {
  static const String id = "MultiSelect_contacts";
  MultiContactPage({Key key, this.title}) : super(key: key);

  final String title;
  // declared strings for the widget
  final String fireLabel = 'Done';
  final Color floatingButtonColor = Colors.red;
  final IconData fireIcon = Icons.filter_center_focus;

  //override widget
  @override
  _MultiContactPageState createState() => new _MultiContactPageState(
        floatingButtonLabel: this.fireLabel,
        icon: this.fireIcon,
        floatingButtonColor: this.floatingButtonColor,
      );
}

class _MultiContactPageState extends State<MultiContactPage> {
  List<Contact> _contacts = new List<Contact>(); // to store contact data
  List<CustomContact> _uiCustomContacts = List<
      CustomContact>(); // to display all contacts data including email, phonenumber, user avatar
  List<CustomContact> _emailListCustomContact =
      List<CustomContact>(); // to display emails of selected contacts
  List<CustomContact> _allContacts = List<
      CustomContact>(); // to display all contacts including name, email, phonenumber
  bool isNameDisplayed = true;
  bool _isLoading = false;
  bool _isSelectedContactsView = false;
  String floatingButtonLabel;
  Color floatingButtonColor;
  String email;
  IconData icon;
  // cons
  _MultiContactPageState({
    this.floatingButtonLabel,
    this.icon,
    this.floatingButtonColor,
  });

  @override
  void initState() {
    super.initState();
    getPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Contact Multi Select"),
      ),
      body: !_isLoading
          ? Container(
              child: _uiCustomContacts?.length > 0
                  ? ListView.builder(
                      itemCount: isNameDisplayed
                          ? _uiCustomContacts?.length
                          : _emailListCustomContact?.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (isNameDisplayed) {
                          CustomContact _contact = _uiCustomContacts[index];
                          var _phonesList = _contact.contact.phones.toList();

                          return _buildListTile(
                              _contact, _phonesList, isNameDisplayed);
                        } else {
                          CustomContact _contact =
                              _emailListCustomContact[index];
                          var _phonesList = _contact.contact.phones.toList();

                          return _buildListTile(
                              _contact, _phonesList, isNameDisplayed);
                        }
                      },
                    )
                  : Text(
                      "Please Check a Contact",
                      style: TextStyle(fontSize: 20.0),
                    ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: isNameDisplayed
          ? FloatingActionButton.extended(
              backgroundColor: floatingButtonColor,
              onPressed: _onSubmit,
              icon: Icon(icon),
              label: Text(floatingButtonLabel),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _onSubmit() {
    setState(() {
      isNameDisplayed = false;
      if (!_isSelectedContactsView) {
        var _customContacts =
            _allContacts.where((contact) => contact.isChecked == true).toList();
        List<String> emailList = new List<String>();
        for (int i = 0; i < _customContacts.length; i++) {
          var tempContact;
          _customContacts[i].contact.emails.forEach((item) => {
                tempContact = new CustomContact(
                    contact: _customContacts[i].contact,
                    email: "",
                    isChecked: true),
                tempContact.email = item.value,
                _emailListCustomContact.add(tempContact),
                emailList.add(item.value),
              });
        }
        print(emailList);
        for (int i = 0; i < _emailListCustomContact.length; i++) {
          print(_emailListCustomContact[i].email);
        }
        _uiCustomContacts = _customContacts;
        _isSelectedContactsView = true;
      } else {
        // here only is the error it should be _CustomContacts instead of _allContacts
        _uiCustomContacts = _allContacts;
        _isSelectedContactsView = true;
        _restateFloatingButton(
          widget.fireLabel,
          Icons.filter_center_focus,
          Colors.red,
        );
      }
    });
  }

  ListTile _buildListTile(
      CustomContact c, List<Item> list, bool isNameDisplayed) {
    return ListTile(
      leading: (c.contact.avatar != null)
          ? CircleAvatar(backgroundImage: MemoryImage(c.contact.avatar))
          : CircleAvatar(
              child: Text(
                  (c.contact.displayName[0] +
                      c.contact.displayName[1].toUpperCase()),
                  style: TextStyle(color: Colors.white)),
            ),
      title: Text(isNameDisplayed ? (c.contact.displayName ?? "") : c.email),
      subtitle: list.length >= 1 && list[0]?.value != null
          ? Column(
              children: [
                Row(
                  children: [
                    Text(list[0].value),
                  ],
                ),
                Row(
                  children: [
                    Text(c.contact.emails.first.value),
                  ],
                ),
              ],
            )
          : Text(c.contact.emails.first.value),
      trailing: Checkbox(
          activeColor: Colors.green,
          value: c.isChecked,
          onChanged: (bool value) {
            setState(() {
              c.isChecked = value;
            });
          }),
    );
  }

  void _restateFloatingButton(String label, IconData icon, Color color) {
    floatingButtonLabel = label;
    icon = icon;
    floatingButtonColor = color;
  }

  refreshContacts() async {
    setState(() {
      _isLoading = true;
    });
    var contacts = await ContactsService.getContacts();
    _populateContacts(contacts);
  }

  void _populateContacts(Iterable<Contact> contacts) {
    _contacts = contacts
        .where((item) => item.displayName != null && item.emails.length > 0)
        .toList();
    _contacts.sort((a, b) => a.displayName.compareTo(b.displayName));
    _allContacts =
        _contacts.map((contact) => CustomContact(contact: contact)).toList();
    setState(() {
      _uiCustomContacts = _allContacts;
      _isLoading = false;
    });
  }

  getPermissions() async {
    if (await Permission.contacts.request().isGranted) {
      refreshContacts();
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Oops!'),
          content: const Text(
              'Looks like permission to read contacts is not granted.'),
          actions: <Widget>[
            FlatButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }
// Future<bool> getContactsPermission() =>
//     SimplePermissions.requestPermission(Permission.ReadContacts);
}

class CustomContact {
  final Contact contact;
  bool isChecked;
  String email;
  CustomContact({
    this.contact,
    this.email,
    this.isChecked = false,
  });
}
